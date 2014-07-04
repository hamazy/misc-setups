#!/bin/bash

set -o errexit
#set -o nounset

export GLOBUS_LOCATION=/opt/gt5
export LIBTOOLPREFIX=/usr/local
CPPFLAGS="-I${LIBTOOLPREFIX}/include -I${GLOBUS_LOCATION}/include/globus -I${GLOBUS_LOCATION}/include/globus/gcc64dbg -I."
LDFLAGS="-L${LIBTOOLPREFIX}/lib -L${GLOBUS_LOCATION}/lib -Lopenssl -Wl,--no-as-needed"
simple_ca_pass=casecret

[ ! -d $GLOBUS_LOCATION ] && sudo mkdir $GLOBUS_LOCATION
sudo chown -R $USER:staff $GLOBUS_LOCATION

cd ~/Downloads
[ ! -f gt5.2.5-all-source-installer.tar.gz ] && \
  curl -s -L -O http://toolkit.globus.org/ftppub/gt5/5.2/5.2.5/installers/src/gt5.2.5-all-source-installer.tar.gz
[ ! -d gt5.2.5-all-source-installer ] && \
  tar xzf gt5.2.5-all-source-installer.tar.gz
cd - >/dev/null

cd ~/Downloads/gt5.2.5-all-source-installer
[ ! -f Makefile ] && \
  ./configure --prefix=$GLOBUS_LOCATION --with-flavor=gcc64dbg 
[ ! -x ${GLOBUS_LOCATION}/bin/gcc64dbg/shared/gsiscp ] && \
  make && make install
cd - >/dev/null

. ${GLOBUS_LOCATION}/etc/globus-user-env.sh
[ ! -d ${GLOBUS_LOCATION}/var/lib/globus/simple_ca ] && \
  $GLOBUS_LOCATION/bin/grid-ca-create -pass ${simple_ca_pass} -noint

cd ~/Downloads
[ ! -f globus_simple_ca_*-1.0-noflavor_data.tar.gz ] && \
  grid-ca-package -g -cadir ${GLOBUS_LOCATION}/var/lib/globus/simple_ca
[ ! -f ${GLOBUS_LOCATION}/share/certificates/grid-security.conf.* ] && \
  gpt-install -verbose globus_simple_ca_*-1.0-noflavor_data.tar.gz
cd - >/dev/null

# grid-default-ca -ca 05810fb7

[ ! -f ${GLOBUS_LOCATION}/etc/hostcert_request.pem ] && \
  grid-cert-request -host `hostname` -nopw
[ ! -f $HOME/.globus/usercert_request.pem ] && \
  grid-cert-request -cn $USER -nopw

[ ! -s ${GLOBUS_LOCATION}/etc/hostcert.pem ] && \
  grid-ca-sign -in ${GLOBUS_LOCATION}/etc/hostcert_request.pem \
  -out ${GLOBUS_LOCATION}/etc/hostcert.pem -key ${simple_ca_pass}
sudo chown root:wheel ${GLOBUS_LOCATION}/etc/hostcert.pem
sudo chown root:wheel ${GLOBUS_LOCATION}/etc/hostkey.pem
[ ! -s $HOME/.globus/usercert.pem ] && \
  grid-ca-sign -in $HOME/.globus/usercert_request.pem \
  -out $HOME/.globus/usercert.pem -key ${simple_ca_pass}

[ ! -d /etc/grid-security ] && sudo mkdir /etc/grid-security
[ ! -f /etc/grid-security/grid-mapfile ] && sudo grid-mapfile-add-entry -dn `grid-cert-info -subject` -ln $USER

[ ! -f /Library/LaunchDaemons/org.globus.gsiftp.plist ] && \
  sudo ed <<EOF
f /Library/LaunchDaemons/org.globus.gsiftp.plist
a
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
"http:// www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>org.globus.gridftp</string>
    <key>ProgramArguments</key>
    <array>
      <string>$GLOBUS_LOCATION/sbin/globus-gridftp-server</string>
      <string>-i</string>
    </array>
    <key>EnvironmentVariables</key>
    <dict>
      <key>GLOBUS_LOCATION</key>
      <string>$GLOBUS_LOCATION</string>
      <key>DYLD_LIBRARY_PATH</key>
      <string>$GLOBUS_LOCATION/lib</string>
    </dict>
    <key>inetdCompatibility</key>
    <dict>
      <key>Wait</key>
      <false/>
    </dict>
    <key>OnDemand</key>
    <true/>
    <key>Sockets</key>
    <dict>
      <key>Listeners</key>
      <dict>
	<key>SockServiceName</key>
	<string>gsiftp</string>
	<key>SockFamily</key>
	<string>IPv4</string>
	<key>SockPassive</key>
	<true/>
	<key>SockType</key>
	<string>stream</string>
      </dict>
    </dict>
  </dict>
</plist>
.
w
q
EOF
sudo launchctl load /Library/LaunchDaemons/org.globus.gsiftp.plist

[ ! -f $GLOBUS_LOCATION/etc/globus-gatekeeper.options.txt ] && \
ed <<EOF
f $GLOBUS_LOCATION/etc/globus-gatekeeper.options.txt
a
-pidfile $GLOBUS_LOCATION/var/run/globus-gatekeeper.pid
-lf LOG_DAEMON
-p 2119
-l $GLOBUS_LOCATION/var/log/globus-gatekeeper.log
-grid_services $GLOBUS_LOCATION/etc/grid-services
-gridmap /etc/grid-security/grid-mapfile
-x509_cert_dir $GLOBUS_LOCATION/share/certificates
-x509_user_cert $GLOBUS_LOCATION/etc/hostcert.pem
-x509_user_key $GLOBUS_LOCATION/etc//hostkey.pem
.
w
q
EOF

[ ! -f /Library/LaunchDaemons/org.globus.gsigatekeeper.plist ] && \
  sudo ed <<EOF
f /Library/LaunchDaemons/org.globus.gsigatekeeper.plist
a
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
"http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>org.globus.globus-gatekeeper</string>
    <key>Disabled</key>
    <false/>
    <key>ProgramArguments</key>
    <array>
      <string>$GLOBUS_LOCATION/sbin/globus-gatekeeper</string>
      <string>-conf</string>
      <string>$GLOBUS_LOCATION/etc/globus-gatekeeper.options.txt</string>
    </array>
    <key>LowPriorityIO</key>
    <false/>
    <key>EnvironmentVariables</key>
    <dict>
      <key>GLOBUS_LOCATION</key>
      <string>$GLOBUS_LOCATION</string>
      <key>DYLD_LIBRARY_PATH</key>
      <string>$GLOBUS_LOCATION/lib</string>
    </dict>
    <key>inetdCompatibility</key>
    <dict>
      <key>Wait</key>
      <false/>
    </dict>
    <key>OnDemand</key>
    <true/>
    <key>RunAtLoad</key>
    <false/>
    <key>Sockets</key>
    <dict>
      <key>Listeners</key>
      <dict>
	<key>SockServiceName</key>
	<string>gsigatekeeper</string>
	<key>SockType</key>
	<string>stream</string>
      </dict>
    </dict>
  </dict>
</plist>
.
w
q
EOF

globus-gatekeeper-admin -E jobmanager-fork-poll
sudo launchctl load /Library/LaunchDaemons/org.globus.gsigatekeeper.plist

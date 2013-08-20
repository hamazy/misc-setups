#!/bin/bash

set -o errexit
set -o nounset

ENSIME_ROOT=$HOME/.ensime
if [ ! -d $ENSIME_ROOT ] ; then
    mkdir $ENSIME_ROOT
    curl -s -L https://www.dropbox.com/sh/ryd981hq08swyqr/ZiCwjjr_vm/ENSIME%20Releases/ensime_2.10.0-0.9.8.9.tar.gz | tar -xzf - --strip-components 1 -C $ENSIME_ROOT
    chmod 755 $ENSIME_ROOT/bin/server
fi

[ ! -d $HOME/.sbt/plugins ] && mkdir -p $HOME/.sbt/plugins
if [ ! $(grep "ensime-sbt-cmd" $HOME/.sbt/plugins/plugins.sbt) ] ; then
    ed <<EOF
f $HOME/.sbt/plugins/plugins.sbt
\$a

addSbtPlugin("org.ensime" % "ensime-sbt-cmd" % "0.1.1")

.
w
q
EOF
fi

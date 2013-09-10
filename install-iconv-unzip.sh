#!/bin/bash

set -o errexit
set -o nounset

sudo port install libiconv
sudo port fetch unzip

tar -xzf /opt/local/var/macports/distfiles/unzip/unzip60.tar.gz

cd unzip60
curl https://bugs.archlinux.org/task/15256?getfile=3685 | patch -p1

ed unix/Makefile <<EOF
/^LFLAGS/
c
LFLAGS1 = -L/opt/local/lib -liconv
.
/^prefix/
c
prefix = /opt/local
.
875c
	\$(MAKE) unzips CFLAGS="-O3 -Wall -DBSD -I/opt/local/include -DNATIVE" LF2=""
.
w
q
EOF
make macosx -f unix/Makefile
sudo make install
cd -

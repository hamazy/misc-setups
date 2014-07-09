#!/bin/bash

set -o errexit
set -o nounset

brew tap homebrew/dupes
brew install libiconv
brew link libiconv --force

[ ! -d ~/Downloads/unzip60 ] && \
  curl -s -L -o - http://jaist.dl.sourceforge.net/project/infozip/UnZip%206.x%20%28latest%29/UnZip%206.0/unzip60.tar.gz | tar xzf - -C ~/Downloads

cd ~/Downloads/unzip60
curl https://bugs.archlinux.org/task/15256?getfile=3685 | patch -p1

ed unix/Makefile <<EOF
/^LFLAGS/
c
LFLAGS1 = -L/usr/local/lib -liconv
.
/^prefix/
c
prefix = /usr/local
.
875c
	\$(MAKE) unzips CFLAGS="-O3 -Wall -DBSD -I/usr/local/include -DNATIVE" LF2=""
.
w
q
EOF
make macosx -f unix/Makefile
sudo make install
cd -

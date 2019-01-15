#!/bin/bash

set -o errexit
set -o nounset

PRG="$0"
while [ -h "$PRG" ] ; do
    PRG=`readlink "$PRG"`
done
dir=$(cd "$(dirname "$PRG")"; pwd)

pushd "$dir" >/dev/null

MEW_VERSION=6.8
[ ! -f ~/Downloads/mew-${MEW_VERSION}.tar.gz ] && curl -s -L -o ~/Downloads/mew-${MEW_VERSION}.tar.gz http://mew.org/Release/mew-${MEW_VERSION}.tar.gz
[ ! -d ~/Downloads/mew-${MEW_VERSION} ] && tar -xzf ~/Downloads/mew-${MEW_VERSION}.tar.gz -C ~/Downloads
pushd ~/Downloads/mew-${MEW_VERSION}
./configure --prefix=/Applications/Emacs.app/Contents/Resources \
            --with-emacs=/Applications/Emacs.app/Contents/MacOS/Emacs \
            --with-elispdir=/Applications/Emacs.app/Contents/Resources/site-lisp/ \
            --with-etcdir=/Applications/Emacs.app/Contents/Resources/etc/ \
            --infodir=/Applications/Emacs.app/Contents/Resources/info
make
make install
popd

popd >/dev/null

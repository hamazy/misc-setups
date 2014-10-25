#!/bin/bash

set -o errexit
set -o nounset

PRG="$0"
while [ -h "$PRG" ] ; do
    PRG=`readlink "$PRG"`
done
dir=$(cd "$(dirname "$PRG")"; pwd)

version=24.4

pushd "$dir" >/dev/null

# curl -s -L -O http://core.ring.gr.jp/pub/GNU/emacs/emacs-${version}.tar.gz
# tar -xzf emacs-${version}.tar.gz

[ ! -d emacs-${version} ] && git clone git@github.com:mirrors/emacs.git emacs-${version}

pushd emacs-${version}
[ ! -f configure ] && ./autogen.sh
CC=/usr/bin/gcc CXX=/usr/bin/g++ ./configure --with-ns
make bootstrap
make
make install
popd

curl -s -L -O http://mew.org/Release/mew-6.5.tar.gz
tar -xzf mew-6.5.tar.gz
pushd mew-6.5
./configure --prefix=$dir/emacs-${version}/nextstep/Emacs.app/Contents/MacOS/ --with-emacs=$dir/emacs-${version}/nextstep/Emacs.app/Contents/MacOS/Emacs --with-elispdir=$dir/emacs-${version}/nextstep/Emacs.app/Contents/Resources/site-lisp/ --with-etcdir=$dir/emacs-${version}/nextstep/Emacs.app/Contents/Resources/etc/ --infodir=$dir/emacs-${version}/nextstep/Emacs.app/Contents/Resources/info
make
make install
popd

curl -s -L -O http://www.ring.gr.jp/archives/elisp/skk/maintrunk/ddskk-15.1.tar.gz
tar -xzf ddskk-15.1.tar.gz
pushd ddskk-15.1
curl -s -L -o - http://openlab.jp/skk/dic/SKK-JISYO.L.gz | gzip -dc >dic/SKK-JISYO.L
make what-where EMACS=$dir/emacs-${version}/nextstep/Emacs.app/Contents/MacOS/Emacs
make install EMACS=$dir/emacs-${version}/nextstep/Emacs.app/Contents/MacOS/Emacs
popd
if [ ! -f $HOME/.skk ] ; then
    ed <<EOF
f $HOME/.skk
a
(setq skk-large-jisyo "/Applications/Emacs.app/Contents/Resources/etc/skk/SKK-JISYO.L")
(setq skk-dcomp-activate t)
.
w
q
EOF
fi

popd >/dev/null

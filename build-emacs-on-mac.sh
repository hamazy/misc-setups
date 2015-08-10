#!/bin/bash

set -o errexit
set -o nounset

PRG="$0"
while [ -h "$PRG" ] ; do
    PRG=`readlink "$PRG"`
done
dir=$(cd "$(dirname "$PRG")"; pwd)

version=24.5

pushd "$dir" >/dev/null

[ ! -f emacs-${version}.tar.gz ] && curl -s -L -O http://core.ring.gr.jp/pub/GNU/emacs/emacs-${version}.tar.gz
[ ! -d emacs-${version} ] && tar -xzf emacs-${version}.tar.gz

pushd emacs-${version}
[ ! -f configure ] && ./autogen.sh
CC=/usr/bin/gcc CXX=/usr/bin/g++ ./configure --with-ns
make bootstrap
make
make install
popd

mew_version=6.6
[ ! -f mew-${mew_version}.tar.gz ] && curl -s -L -O http://mew.org/Release/mew-${mew_version}.tar.gz
[ ! -d mew-${mew_version} ] && tar -xzf mew-${mew_version}.tar.gz
pushd mew-${mew_version}
./configure --prefix=$dir/emacs-${version}/nextstep/Emacs.app/Contents/MacOS/ --with-emacs=$dir/emacs-${version}/nextstep/Emacs.app/Contents/MacOS/Emacs --with-elispdir=$dir/emacs-${version}/nextstep/Emacs.app/Contents/Resources/site-lisp/ --with-etcdir=$dir/emacs-${version}/nextstep/Emacs.app/Contents/Resources/etc/ --infodir=$dir/emacs-${version}/nextstep/Emacs.app/Contents/Resources/info
make
make install
popd

ddskk_version=15.2
curl -s -L -O http://www.ring.gr.jp/archives/elisp/skk/maintrunk/ddskk-${ddskk_version}.tar.gz
tar -xzf ddskk-${ddskk_version}.tar.gz
pushd ddskk-${ddskk_version}
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

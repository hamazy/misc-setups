#!/bin/bash

set -o errexit
set -o nounset

PRG="$0"
while [ -h "$PRG" ] ; do
    PRG=`readlink "$PRG"`
done
dir=$(cd "$(dirname "$PRG")"; pwd)

pushd "$dir" >/dev/null

curl -s -L -O http://core.ring.gr.jp/pub/GNU/emacs/emacs-24.3.tar.gz
tar -xzf emacs-24.3.tar.gz

pushd emacs-24.3
CC=/usr/bin/gcc CXX=/usr/bin/g++ ./configure --with-ns
make install
popd

curl -s -L -O http://mew.org/Release/mew-6.5.tar.gz
tar -xzf mew-6.5.tar.gz
pushd mew-6.5
./configure --prefix=$dir/emacs-24.3/nextstep/Emacs.app/Contents/MacOS/ --with-emacs=$dir/emacs-24.3/nextstep/Emacs.app/Contents/MacOS/Emacs --with-elispdir=$dir/emacs-24.3/nextstep/Emacs.app/Contents/Resources/site-lisp/ --with-etcdir=$dir/emacs-24.3/nextstep/Emacs.app/Contents/Resources/etc/ --infodir=$dir/emacs-24.3/nextstep/Emacs.app/Contents/Resources/info
make
make install
popd

curl -s -L -O http://www.ring.gr.jp/archives/elisp/skk/maintrunk/ddskk-15.1.tar.gz
tar -xzf ddskk-15.1.tar.gz
pushd ddskk-15.1
curl -s -L -o - http://openlab.jp/skk/dic/SKK-JISYO.L.gz | gzip -dc >dic/SKK-JISYO.L
make what-where EMACS=$dir/emacs-24.3/nextstep/Emacs.app/Contents/MacOS/Emacs
make install EMACS=$dir/emacs-24.3/nextstep/Emacs.app/Contents/MacOS/Emacs
popd
ed <<EOF
f \$HOME/.skk
a
(setq skk-large-jisyo "/Applications/Emacs.app/Contents/Resources/etc/skk/SKK-JISYO.L")
(setq skk-dcomp-activate t)
.
w
q
EOF

popd >/dev/null

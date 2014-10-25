#!/bin/bash

set -o errexit
set -o nounset

[ ! -d $HOME/.lein/bin ] && mkdir -p $HOME/.lein/bin
[ ! -f $HOME/.lein/bin/lein ] && curl https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein -o $HOME/.lein/bin/lein && chmod 755 $HOME/.lein/bin/lein
# [ -x $HOME/.lein/bin/lein ] && export PATH=$HOME/.lein/bin:$PATH

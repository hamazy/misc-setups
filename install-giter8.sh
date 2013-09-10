#!/bin/bash

set -o errexit
set -o nounset

if [ ! -x $HOME/bin/cs ] ; then
    curl https://raw.github.com/n8han/conscript/master/setup.sh | sh
fi

if [ ! -x $HOME/bin/g8 ] ; then
    $HOME/bin/cs n8han/giter8
fi


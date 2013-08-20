#!/bin/bash

set -o errexit
set -o nounset

ENSIME_ROOT=$HOME/.ensime
if [ ! -d $ENSIME_ROOT ] ; then
    mkdir $ENSIME_ROOT
    curl -s -L https://www.dropbox.com/sh/ryd981hq08swyqr/ZiCwjjr_vm/ENSIME%20Releases/ensime_2.10.0-0.9.8.9.tar.gz | tar -xzf - --strip-components 1 -C $ENSIME_ROOT
    chmod 755 $ENSIME_ROOT/bin/server
fi

SBT_PLUGINS=$HOME/.sbt/plugins
SBT_PLUGINS_DEF=$SBT_PLUGINS/plugins.sbt
[ ! -d $SBT_PLUGINS ] && mkdir -p $SBT_PLUGINS
[ ! -f $SBT_PLUGINS_DEF ] && touch $SBT_PLUGINS_DEF
if [ ! `grep "ensime-sbt-cmd" $SBT_PLUGINS_DEF` ] ; then
    ed <<EOF
f $HOME/.sbt/plugins/plugins.sbt
\$a

addSbtPlugin("org.ensime" % "ensime-sbt-cmd" % "0.1.1")

.
w
q
EOF
fi

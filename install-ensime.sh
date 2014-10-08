#!/bin/bash

set -o errexit
set -o nounset

SBT_VERSION=0.13
SBT_PLUGINS=$HOME/.sbt/$SBT_VERSION/plugins
SBT_PLUGINS_DEF=$SBT_PLUGINS/plugins.sbt
[ ! -d $SBT_PLUGINS ] && mkdir -p $SBT_PLUGINS
[ ! -f $SBT_PLUGINS_DEF ] && touch $SBT_PLUGINS_DEF
grep "ensime-sbt" $SBT_PLUGINS_DEF || ed <<EOF
f $SBT_PLUGINS_DEF
\$a

resolvers += Resolver.sonatypeRepo("snapshots")

addSbtPlugin("org.ensime" % "ensime-sbt" % "0.1.5-SNAPSHOT")

.
w
q
EOF

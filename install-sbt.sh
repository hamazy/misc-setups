#!/bin/bash

set -o errexit
set -o nounset

SBT_VERSION=0.12.1
SBT_PACKAGE_DIR=$HOME/.sbt-$SBT_VERSION

if [ ! -d $SBT_PACKAGE_DIR ] ; then
    mkdir $SBT_PACKAGE_DIR
    curl -s -L http://scalasbt.artifactoryonline.com/scalasbt/sbt-native-packages/org/scala-sbt/sbt/$SBT_VERSION/sbt.tgz | tar -xzf - -C $SBT_PACKAGE_DIR
fi


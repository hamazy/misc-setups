#!/bin/bash

set -o errexit
set -o nounset

SBT_PACKAGE_DIR=$HOME/.sbt-${SBT_VERSION:=0.13.6}

if [ ! -d $SBT_PACKAGE_DIR ] ; then
    mkdir $SBT_PACKAGE_DIR
    curl -s -L https://dl.bintray.com/sbt/native-packages/sbt/${SBT_VERSION}/sbt-${SBT_VERSION}.tgz | tar -xzf - --strip-components 1 -C $SBT_PACKAGE_DIR
fi

#!/bin/sh

DIST=/t/GIT/dtc

test -d $DIST || mkdir -p $DIST
cd $DIST/dtc

make

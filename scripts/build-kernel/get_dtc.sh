#!/bin/sh
#
# http://www.devicetree.org/Device_Tree_Compiler

DIST=/t/GIT/dtc

test -d $DIST || mkdir -p $DIST
cd $DIST

git clone git://git.kernel.org/pub/scm/utils/dtc/dtc.git

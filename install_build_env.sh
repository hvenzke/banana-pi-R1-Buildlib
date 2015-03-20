#!/bin/sh
# v 0.2

# docu refs:
# https://wiki.debian.org/HowToRebuildAnOfficialDebianKernelPackage
# http://wiki.oppserver.net/index.php/DEBIAN_KERNEL_BAUEN

# script for setup debian kernel build and packaging

apt-get -y install apt-file less vim 
apt-get -y install devscripts equivs wget build-essential fakeroot  make-kpkg
apt-get -y  install automake autoconf bison flex libtool  
apt-get -y -qq install git
apt-get -y install libncurses-dev ncurses-dev 

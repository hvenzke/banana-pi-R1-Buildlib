#!/bin/sh
# v 0.2

# docu refs:
# https://wiki.debian.org/HowToRebuildAnOfficialDebianKernelPackage
# http://debiananwenderhandbuch.de/kernelbauen.html
# http://wiki.oppserver.net/index.php/DEBIAN_KERNEL_BAUEN

# script for setup debian kernel build and packaging

apt-get -y install apt-file less vim 
apt-get -y install devscripts equivs wget build-essential fakeroot  make-kpkg
apt-get -y install automake autoconf bison flex libtool diffstat quilt
apt-get -y -qq install git
apt-get -y install libncurses-dev ncurses-dev  libusb-1.0-0 libusb-1.0-0-dev 
apt-get -y install  libfdt-dev libfdt1



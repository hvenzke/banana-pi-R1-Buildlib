#!/bin/sh
# v 0.2
# docu refs:
# https://wiki.debian.org/HowToRebuildAnOfficialDebianKernelPackage
# http://debiananwenderhandbuch.de/kernelbauen.html
# http://wiki.oppserver.net/index.php/DEBIAN_KERNEL_BAUEN
# http://manpages.ubuntu.com/manpages/trusty/de/man5/kernel-pkg.conf.5.html

# Edit and execute this script - debian jessie recommended


# Path where you have min +8G free 
BUILD_DIR=/t/GIT

# method
SOURCE_COMPILE="yes"                        # force source compilation: yes / no
KERNEL_CONFIGURE="no"                       # want to change my default configuration
KERNEL_CLEAN="yes"                          # run MAKE clean before kernel compilation
USEALLCORES="yes"                           # Use all CPU cores for compiling

# user
DEST_LANG="de_DE.UTF-8"                     # sl_SI.UTF-8, en_US.UTF-8
TZDATA="Europe/BERLIN"                   # Timezone
ROOTPWD="123456"                              # Must be changed @first login
MAINTAINER="Horst Venzke"                  # deb signature
MAINTAINERMAIL="support@remsnet.de"    # deb signature

# advanced
KERNELTAG="v3.19"                           # which kernel version - valid only for mainline
CONFIG_LOCALVERSION="-banana-R1"            # pkg name
CONFIG_EXTRAVERSION="01"                    # pkg revsion


FBTFT="yes"                                 # https://github.com/notro/fbtft
EXTERNAL="yes"                              # compile extra drivers`

#---------------------------------------------------------------------------------------

# check git
test -x /usr/bin/git || echo " ERROR - git not installed; exit 1"

# Build dir
SRC=$BUILD_DIR
# destination
DEST=$(pwd)/output


# get updates of the main build libraries
if [ -d "$SRC/lib" ]; then
   #
   # debian compliant kernel build
    test -d $DEST/lib/linux-kernel-$KERNELTAG || mkdir -p $DEST/lib/linux-kernel-$KERNELTAG
    cd $DEST/lib/linux-kernel-$KERNELTAG
    make oldconfig
    
    # we build all kernel packages 
   fakeroot make-kpkg buildpackage --initrd --revision $CONFIG_EXTRAVERSION --append-to-version `date +%Y%m%d`
fi

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
# http://piprojects.net/bananapi-kernel-3-18-rc5/o
# http://www.dingolfing.org/members/kutschi/cubietruck-server.html
# http://www.at91.com/linux4sam/bin/view/Linux4SAM/U-Boot

# source is where we have +8GB free
SRC=/t/GIT
OUTP=$SRC/test

DEST=$(pwd)/test


# cleanup output
test -d $OUTP && cd $SRC; rm -rf ./test

# create output
test -d $OUTP || mkdir $OUTP; cd $OUTP


DISTRIBUTION="Debian"
RELEASE=$DISTRIBUTION
REVISION
BOARD="bananapi-r1"
GPGPASS=""
BRANCH="next"


# check git
test -x /usr/bin/git || echo " ERROR - git not installed; exit 1"

# Hostname
HOST="$BOARD"


# Load libraries
. $SRC/lib/configuration.sh                        # Board configuration
. $SRC/lib/boards.sh                                       # Board specific install
. $SRC/lib/common.sh                                       # Functions
VERSION="${BOARD^} $DISTRIBUTION $REVISION $RELEASE $BRANCH"


# fetch_from_github [repository, sub directory]
mkdir -p $OUTP
fetch_from_github "$BOOTLOADER" "$BOOTSOURCE"
fetch_from_github "$LINUXKERNEL" "$LINUXSOURCE"
if [[ -n "$DOCS" ]]; then fetch_from_github "$DOCS" "$DOCSDIR"; fi
if [[ -n "$MISC1" ]]; then fetch_from_github "$MISC1" "$MISC1_DIR"; fi
if [[ -n "$MISC2" ]]; then fetch_from_github "$MISC2" "$MISC2_DIR"; fi
if [[ -n "$MISC3" ]]; then fetch_from_github "$MISC3" "$MISC3_DIR"; fi
if [[ -n "$MISC4" ]]; then fetch_from_github "$MISC4" "$MISC4_DIR"; fi


# Patching sources
patching_sources

# Grab linux kernel version
grab_kernel_version



# Build dir
SRC=$BUILD_DIR
# destination
DEST=$(pwd)/output


# get updates of the main build libraries
if [ -d "$SRC/lib" ]; then
   #
   # debian compliant kernel build prepare
   test -d  $DEST/linux-mainline && mv $DEST/linux-mainline $DEST/linux-kernel-$KERNELTAG
   KSRC=$DEST/linux-kernel-$KERNELTAG
   cd $KSRC
   make oldconfig

    # we build all kernel packages 
   fakeroot make-kpkg buildpackage --initrd --revision $CONFIG_EXTRAVERSION --append-to-version `date +%Y%m%d`
fi

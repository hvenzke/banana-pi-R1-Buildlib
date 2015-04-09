#!/bin/bash

# http://piprojects.net/de/banana-pi-kernel-3-18-rc-bauen/
#
# debug
#set -x 
#
#
GIT=/t/GIT
OUT=$GIT/output
SOURCES=$OUT/linux-mainline
INST=/usr/bin/install

REL=$GIT/.test1



timestamp() {
	 D=`date +"%Y%M%d_%H%M"`
}	


cp_cfg() {
	cd $SOURCES
	test -f $REL && cp -p $REL .config

}

k_v() {
        #
        cd $SOURCES
                cp_cfg
		make oldconfig
		make modules_prepare
                kversion=$(make -s kernelrelease)
                echo $kversion
}

clean_kernel() {
        #
        cd $SOURCES
	#
	test -f .config && cp .config $GIT/.config-$kversion-$timestamp
	make clean
	make distclean
}

backup_boot() {
	test -d /boot.bak && rm -rf /boot.bak
	test -d /boot.bak || mkdir /boot.bak
	cd /boot
	cp -rp ./* /boot.bak
	cd 
}


backup_dtb() { 
	        cp -rp /boot/dtb /boot.bak/
                #
                test -f /boot/dtb && rm -rf /boot/dtb
                test -d /boot/dtb && rm -rf /boot/dtb
                test -d /boot/dtb || mkdir -p /boot/dtb

}

compile_uImage() {
	#
	cd $SOURCES
	clean_kernel
	k_v
	#
	# https://gcc.gnu.org/onlinedocs/gcc/ARM-Options.html
	CPPFLAGS="-Ofast"
	CFLAGS="-Ofast"
	#
	#
 	make -j3 dtbs modules
 	make -j3 LOADADDR=0x40008000 uImage
	#
	timestamp
}

compile_docs() {
	cd $SOURCES
	k_v
	#
	make mandocs
	#
	timestamp
}

install_modules() {
	cd $SOURCES
	#
	make modules_install INSTALL_MOD_PATH=/
	#
	timestamp
}

install_dtbs() {
	#
        cd $SOURCES
        k_v
	#
	backup_dtb
	
	if [ -d /boot/dtb ] && [ -d /boot.bak/dtb ]; then
		test -d /boot/dtb || mkdir -p /boot/dtb
        	cp -rp arch/arm/boot/dts/*.dtb /boot/dtb
	else
		test -d /boot/dtb || mkdir -p /boot/dtb
		cp -rp /boot/dtb /boot.bak/
		#
		cp -rp arch/arm/boot/dts/*.dtb /boot
	fi
}

install_BPi_dtbs() {

        cd $SOURCES
	#
	backup_dtb
	#
	echo "Installing New sun7i-a20-bananapi.dtb "
        $INST -m 755 arch/arm/boot/dts/sun7i-a20-bananapi.dtb /boot/sun7i-a20-bananapi.dtb
	echo done
	ls -la /boot/sun7i-a20-bananapi.dtb
}

install_headers() {
        cd $SOURCES
        k_v
        make  headers_install ARCH=armv7l INSTALL_HDR_PATH=/usr/include
}

install_docs() {
        cd $SOURCES
        k_v
        make installmandocs
}


install_BPi_uImage() {
	#
	cd $SOURCES
	#
	backup_boot
	# 
	k_v
	#
	echo "Installing New uImage"
	$INST -m 755 arch/arm/boot/uImage /boot/uImage
	$INST -m 755 arch/arm/boot/Image /boot/kernel.img

	install_BPi_dtbs
	#
	echo "Installing New uImage"
	$INST -m 644 .config /boot/config-$kversion

	echo "Installing New symvers-$kversion "
	$INST -m 644 ./Module.symvers  /boot/symvers-$kversion
	echo ""
	echo "done"
	ls -la /boot/symvers-$kversion /boot/kernel.img /boot/uImage /boot/config-$kversion /boot/sun7i-a20-bananapi.dtb
	echo ""
}

install_kernel() {
	#
	backup_boot
	#
	install_modules
	#
	install_BPi_dtbs
	#
	install_uImage
	#
	install_headers
	#
	install_docs
}

build_pkg() {
	#
	        #
        cd $SOURCES
        #
        backup_boot
        #
        k_v
	#
	#http://debian-handbook.info/browse/de-DE/stable/sect.kernel-compilation.html
	make deb-pkg 
}

case "$1" in
build)	
	echo "Kernel build"
	compile_uImage
	echo "Kernel build done" 
	timestamp
	
	;;
clean)	
	echo "Kernel cleanup"
	clean_kernel
        ;;
install) 
	echo "install all"
	install_kernel
        ;;
install_uImage) 
	echo "install install_uImage"
	install_BPi_uImage
        ;;
install_dtbs) 
	echo "install dtbs"
	install_BPi_dtbs
        ;;
install_modules)
	install_modules
        ;;
timestamp)
	timestamp
	echo "timestamp $D"
	;;
kversion)
	k_v
	;;
backup)
	backup_boot
	;;

*)	echo "Usage: $0 {build|timestamp|clean|install|install_uImage|install_dtbs|install_modules|install_uImage|install_headers|kversion|backup}"
        ;;
esac
exit 0

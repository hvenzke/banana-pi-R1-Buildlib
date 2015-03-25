!/bin/sh

DEST="/t/GIT/output/u-boot"
CTHREADS="-j2"
REVISION="2.5"
BOOTCONFIG="Bananapi_defconfig"
MODULES="hci_uart gpio_sunxi rfcomm hidp sunxi-ir bonding spi_sun7i 8021q"
MODULES_NEXT="brcmfmac"

cd $DEST
make clean distclean
test -d $DEST/spl/ || mkdir -p $DEST/spl/

## patch mainline uboot configuration to boot with old kernels
echo "CONFIG_ARMV7_BOOT_SEC_DEFAULT=y" >> $DEST/.config
echo "CONFIG_ARMV7_BOOT_SEC_DEFAULT=y" >> $DEST/spl/.config
echo "CONFIG_OLD_SUNXI_KERNEL_COMPAT=y" >> $DEST/.config
echo "CONFIG_OLD_SUNXI_KERNEL_COMPAT=y"	>> $DEST/spl/.config 

cd $DEST
make $CTHREADS $BOOTCONFIG CROSS_COMPILE=arm-linux-gnueabihf-
make $CTHREADS

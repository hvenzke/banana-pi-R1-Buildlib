#
# banana-pi-R1 headless
setenv bootargs earlyprintk console=tty1 console=ttyS0,115200  root=/dev/mmcblk0p1 panic=10 consoleblank=0  elevator=deadline rootwait
mmc dev 0
ext4load mmc 0 0x46000000 /boot/zImage
env set fdt_high ffffffff
bootz 0x46000000


This Fork are for our "Banana Pi R1" needs  as an FIREWALL:
- work in progress -

- Fully Modularised kernel 
- wiki support
- full usb support
- all possible fstypes 
- DM , MD , LVM enabled
- Linux LVS , Netfilter with all possible modules for FIREWALL usage (ufw , shirewall and more ) 
- IPsec , crypt , selinux kernel modules

----------------------------------------
1. SDK for ARM 
2. Use proven sources and configurations
3. Create SD images for various boards: Cubieboard 1, Cubieboard 2, Cubietruck, BananaPi, BananaPi, BananaPi PRO, Banana Pi R1, Cubox, Humminboard, Olimex Lime, Olimex Lime 2, Olimex Micro, Orange Pi, Udoo quad

4. Well documented, maintained & easy to use
5. Boot loaders and kernel images are compiled and cached.
```bash
#!/bin/bash
# 
# Edit and execute this script - debian jessie recommended
#

# method
SOURCE_COMPILE="yes"						# force source compilation: yes / no
KERNEL_CONFIGURE="no"						# want to change my default configuration
KERNEL_CLEAN="yes"							# run MAKE clean before kernel compilation
USEALLCORES="yes"							# Use all CPU cores for compiling
   
# user 
DEST_LANG="de_DE.UTF-8" 	 				# sl_SI.UTF-8, en_US.UTF-8
TZDATA="Europe/Berlin" 					# Timezone
ROOTPWD="1234"   		  					# Must be changed @first login
MAINTAINER="Horst Venzke"					# deb signature
MAINTAINERMAIL="support@remsnet.de"	# deb signature
    
# advanced
KERNELTAG="v3.19"							# which kernel version - valid only for mainline
FBTFT="yes"									# https://github.com/notro/fbtft 
EXTERNAL="yes"								# compile extra drivers`

#---------------------------------------------------------------------------------------

# source is where we start the script
SRC=$(pwd)

# destination
DEST=$(pwd)/output                      		      	

test -x /usr/bin/git || echo "ERROR , git not installed - Please use script install_build_env.sh "; exit 1

# get updates of the main build libraries
if [ -d "$SRC/lib" ]; then
	cd $SRC/lib
	git pull 
else
	git clone https://github.com/hvenzke/banana-pi-R1-Buildlib
fi

source $SRC/lib/main.sh
#---------------------------------------------------------------------------------------
```

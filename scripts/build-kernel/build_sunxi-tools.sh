#!/bin/bash

DEST="/t/GIT/output"
CTHREADS="-j2"

cd $DEST/sunxi-tools

# for host
make -s clean && make -s fex2bin && make -s bin2fex

if [ -x /usr/bin/fex2bin ]; then
	echo "checking for /usr/bin/fex2bin : OK"
else
	cp fex2bin bin2fex /usr/bin
fi
	

if [ -x /usr/bin/bin2fex ]; then
        echo "checking for /usr/bin/bin2fex : OK"
else
        cp -p bin2fex /usr/bin/
	chmod 755 /usr/bin/bin2fex
fi



# for destination
make -s clean && make $CTHREADS 'fex2bin' CC=arm-linux-gnueabihf-gcc

make $CTHREADS 'bin2fex' CC=arm-linux-gnueabihf-gcc && make $CTHREADS 'nand-part' CC=arm-linux-gnueabihf-gcc

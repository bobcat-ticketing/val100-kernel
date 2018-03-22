#!/bin/sh

BUILDROOT=/usr/src/buildroot
SOURCE=/usr/src/linux

cp $BR2_CONFIG $BUILDROOT/.config
cp *_kernel_config.txt $SOURCE
cd $BUILDROOT
make

#cd $SOURCE
#export ARCH=arm
#export CROSS_COMPILE=$BUILDROOT/output/host/usr/bin/arm-buildroot-linux-gnueabihf-
#make

#!/bin/sh
set -e
. ./build.sh
 
mkdir -p isodir
mkdir -p isodir/boot
mkdir -p isodir/boot/grub
 
cp sysroot/boot/zincos.kernel isodir/boot/zincos.kernel
cat > isodir/boot/grub/grub.cfg << EOF
menuentry "zincos" {
	multiboot /boot/zincos.kernel
}
EOF
grub-mkrescue -o zincos.iso isodir


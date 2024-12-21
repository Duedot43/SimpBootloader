#!/bin/sh

# Compile the bootloader
nasm -f bin bootloader.asm -o bootloader.bin

# Compile the kernel
nasm -f bin kernel.asm -o kernel.bin

# Compile the functions
#nasm -f bin functions.asm -o functions.bin

#cat kernel.bin functions.bin | dd of=linked-kernel.bin bs=512 conv=sync

dd if=data.txt of=data.bin bs=512 conv=sync

# concantinate both files to make the bootable image with the bootloader and the kernel
cat bootloader.bin kernel.bin data.bin > bootable.img


#boot the vm
qemu-system-x86_64 -drive file=bootable.img,format=raw #-s -S -d int



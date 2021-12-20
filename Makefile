CXX = ~/opt/cross/bin/i686-elf-g++
CXX_GLOBAL_INCLUDES = -I ./src/include
CXX_FLAGS = -c -ffreestanding -nostdlib -fno-builtin -fno-rtti -fno-exceptions  $(CXX_GLOBAL_INCLUDES)

ASM = ~/opt/cross/bin/i686-elf-as
ASM_FLAGS = -c

LD = ~/opt/cross/bin/i686-elf-ld

.PHONY: all compile link build

all: compile link build

compile:
	# make sub directories
	make -C ./src/boot/

link:
	$(LD) -o build/boot.bin --oformat binary -e _start -Ttext 0x7c00 build/int/bootsect.o

build:
	cp build/boot.bin build/kernel_floppy.img
	truncate -s 1440k build/kernel_floppy.img

run:
	qemu-system-i386 build/kernel_floppy.img
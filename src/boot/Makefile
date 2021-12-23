CXX = ~/opt/cross/bin/i686-elf-g++
CXX_GLOBAL_INCLUDES = -I ./src/include
CXX_FLAGS = -c -ffreestanding -nostdlib -fno-builtin -fno-rtti -fno-exceptions  $(CXX_GLOBAL_INCLUDES)

ASM = nasm
ASM_FLAGS = -f bin



compile:
	$(ASM) $(ASM_FLAGS) boot_one.asm -o ../../build/boot.bin;

CXX = ~/opt/cross/bin/i686-elf-g++
CXX_GLOBAL_INCLUDES = -I ./src/include
CXX_FLAGS = -c -ffreestanding -nostdlib -fno-builtin -fno-rtti -fno-exceptions  $(CXX_GLOBAL_INCLUDES)

ASM = ~/opt/cross/bin/i686-elf-as
ASM_FLAGS = -c



compile:
	$(ASM) $(ASM_FLAGS) bootsect.s -o ../../build/int/bootsect.o;

[bits 16]

org 0x7c00

_start:
    jmp start
    nop ; padding to 3 bytes

; OEM Parameter block
bpbOEM			db "KERNEL  "
bpbBytesPerSector:  	DW 512
bpbSectorsPerCluster: 	DB 1
bpbReservedSectors: 	DW 1
bpbNumberOfFATs: 	    DB 2
bpbRootEntries: 	    DW 224
bpbTotalSectors: 	    DW 2880
bpbMedia: 	            DB 0xF0
bpbSectorsPerFAT: 	    DW 9
bpbSectorsPerTrack: 	DW 18
bpbHeadsPerCylinder: 	DW 2
bpbHiddenSectors: 	    DD 0
bpbTotalSectorsBig:     DD 0
bsDriveNumber: 	        DB 0
bsUnused: 	            DB 0
bsExtBootSignature: 	DB 0x29
bsSerialNumber:	        DD 0x12345678
bsVolumeLabel: 	        DB "MOS FLOPPY "
bsFileSystem: 	        DB "FAT12   "
msg db "Boot loader: Initializing stage 1", 0

boot_print:
    lodsb
    or al, al
    jz return
    mov ah, 0eh
    int 10h
    jmp boot_print
return:
    ret

start:
    xor ax, ax
    mov ds, ax
    mov es, ax

    mov si, msg
    call boot_print



    cli
    hlt


times 510 - ($-$$) db 0
dw 0xAA55

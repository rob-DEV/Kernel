;***********************************
; BOOT STAGE 1
;***********************************

org 0
bits 16

start: jmp main

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

print:
    lodsb
    or al, al
    jz return
    mov ah, 0eh
    int 10h
    jmp print
return:
    ret

;************************************************;
; Reads a series of sectors
; CX=>Number of sectors to read
; AX=>Starting sector
; ES:BX=>Buffer to read to
;************************************************;
readSectors:
     .MAIN
          mov     di, 0x0005                          ; five retries for error
     .SECTORLOOP
          push    ax
          push    bx
          push    cx
          call    LBACHS                              ; convert starting sector to CHS
          mov     ah, 0x02                            ; BIOS read sector
          mov     al, 0x01                            ; read one sector
          mov     ch, BYTE [absoluteTrack]            ; track
          mov     cl, BYTE [absoluteSector]           ; sector
          mov     dh, BYTE [absoluteHead]             ; head
          mov     dl, BYTE [bsDriveNumber]            ; drive
          int     0x13                                ; invoke BIOS
          jnc     .SUCCESS                            ; test for read error
          xor     ax, ax                              ; BIOS reset disk
          int     0x13                                ; invoke BIOS
          dec     di                                  ; decrement error counter
          pop     cx
          pop     bx
          pop     ax
          jnz     .SECTORLOOP                         ; attempt to read again
          int     0x18
     .SUCCESS
          mov     si, msgProgress
          call    print
          pop     cx
          pop     bx
          pop     ax
          add     bx, WORD [bpbBytesPerSector]        ; queue next buffer
          inc     ax                                  ; queue next sector
          loop    .MAIN                               ; read next sector
          ret
LBACHS:
          xor     dx, dx                              ; prepare dx:ax for operation
          div     WORD [bpbSectorsPerTrack]           ; calculate
          inc     dl                                  ; adjust for sector 0
          mov     BYTE [absoluteSector], dl
          xor     dx, dx                              ; prepare dx:ax for operation
          div     WORD [bpbHeadsPerCylinder]          ; calculate
          mov     BYTE [absoluteHead], dl
          mov     BYTE [absoluteTrack], al
          ret

main:
    ; ---------------------------------------------------
    ; Loaded at 0x7C00
    ; ---------------------------------------------------
        cli
        mov ax, 0x07C0
        mov ds, ax
        mov es, ax
        mov fs, ax
        mov gs, ax

    ; ---------------------------------------------------
    ; Stack setup
    ; ---------------------------------------------------
        mov ax, 0x0000
        mov ss, ax
        mov sp, 0xFFFF
        sti

    ; ---------------------------------------------------
    ; Print initial welcome
    ; ---------------------------------------------------
    
        mov si, msgBoot
        call print

    ; ---------------------------------------------------
    ; Load root directory of FAT-12 table
    ; ---------------------------------------------------
    ; compute size of root directory in cx
        xor cx, cx
        xor dx, dx
        mov ax, 0x0020 ; 32 byte directory entry
        mul WORD [bpbRootEntries] ; total directory size
        div WORD [bpbBytesPerSector] ; sectors used by directory
        xchg ax, cx
    ; compute location of root directory in ax
        mov al, BYTE [bpbNumberOfFATs]
        mul WORD [bpbSectorsPerFAT]
        add ax, WORD [bpbReservedSectors]
        mov WORD [datasector], ax
        add WORD [datasector], cx
        
    ; read root into memory
        mov bx, 0x0200 ; copy root dir above boot code
        call readSectors

absoluteSector db 0x00
absoluteHead   db 0x00
absoluteTrack  db 0x00

datasector dw 0x0000

msgBoot db "Boot loader: Initializing stage 1", 0x0D, 0x0A, 0x00
msgProgress db ".", 0x00

times 510 - ($-$$) db 0
dw 0xAA55
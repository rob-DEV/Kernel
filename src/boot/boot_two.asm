;***********************************
; BOOT STAGE 2
;***********************************

org 0
bits 16

; loaded at arbitrary memory address 
jmp main

print:
    lodsb
    or al, al
    jz return
    mov ah, 0eh
    int 10h
    jmp print
return:
    ret

main:
    cli
    push cs
    pop ds

    mov si, msg
    call print

    cli
    hlt

msg db "Boot loader: Initializing stage 2", 0

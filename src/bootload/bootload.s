.code16 # use 16 bits
.global _start

_start:
  mov $msg, %si
  mov $0xe, %ah

print_loop:
  lodsb
  cmp $0, %al
  je done
  int $0x10
  jmp print_loop
done:
  hlt

msg: .asciz "Loading kernel bootloader..."

.fill 510-(.-_start)
.word 0xaa55 # magic signature

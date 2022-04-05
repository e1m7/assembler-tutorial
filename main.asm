format ELF
public _start

section '.text' executable
_start:
  ; Основной код
  call exit

section '.exit' executable
exit:
  mov eax, 1
  xor ebx, ebx
  int 0x80
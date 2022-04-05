
; Программа №13: как правильно оформлять программу с библиотеками
; Программа №13: как правильно оформлять программу с библиотеками
; Программа №13: как правильно оформлять программу с библиотеками

format ELF
public _start

; Компоновка включает в себя все библиотеки
; ld prog13.o asmlib/mth.o asmlib/fmt.o asmlib/sys.o asmlib/str.o -o prog13
; Предварительно их надо скомпилировать внутри каталога asmlib/
; fasm fmt.asm, ...

; extrn gcd
; extrn print_number
; extrn print_line
; extrn exit

; Более правильно делать это через заголовочные файлы

include "asmlib/fmt.inc"
include "asmlib/mth.inc"
include "asmlib/str.inc"
include "asmlib/sys.inc"

section '.text' executable
_start:
  mov eax, 30
  mov ebx, 20
  call gcd
  call print_number
  call print_line
  call exit



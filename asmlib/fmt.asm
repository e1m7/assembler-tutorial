
; ======================================
; Библиотека для работы с вводом/выводом
; ======================================

format ELF

public print_char
public print_number
public print_string
public print_line

include "str.inc"

section '.bss' writable
  bss_char rb 1

; Вывод на экран числа
section '.print_number' executable
; На входе: eax = number
; На выходе:
print_number:
  push eax
  push ebx
  push ecx
  push edx
  xor ecx, ecx
  .next_iter:
    cmp eax, 0
    je .print_iter
    mov ebx, 10
    xor edx, edx
    div ebx
    add edx, '0'
    push edx
    inc ecx
    jmp .next_iter
  .print_iter:
    cmp ecx, 0
    je .close
    pop eax
    call print_char
    dec ecx
    jmp .print_iter
  .close:
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret


; Вывод символа на экран
section '.print_char' executable
; На входе: eax = char
; На выходе: 
print_char:
  push eax
  push ebx
  push ecx
  push edx
  mov [bss_char], al
  mov eax, 4
  mov ebx, 1
  mov ecx, bss_char
  mov edx, 1
  int 0x80
  pop edx
  pop ecx
  pop ebx
  pop eax
  ret


; Вывод строки на экран
section '.print_string' executable
; На входе: eax = string
; На выходе: 
print_string:
  push eax
  push ebx
  push ecx
  push edx
  mov ecx, eax
  call length_string
  mov edx, eax
  mov eax, 4
  mov ebx, 1
  int 0x80
  pop edx
  pop ecx
  pop ebx
  pop eax
  ret


; Переход на новую линию
section '.print_line' executable
; На входе:
; На выходе:
print_line:
  push eax
  mov eax, 0xA
  call print_char
  pop eax
  ret

; Программа №4: простейшая программа вывода строки на экран через секции
; Программа №4: простейшая программа вывода строки на экран через секции
; Программа №4: простейшая программа вывода строки на экран через секции

; Если в программе определены секции, то готовую программу удобно дезассемблировать
; 1) fasm prog04.asm                                компиляция (превратить в коды)
; 2) ld prog04.o -o prog04                          компоновка (склеить из кодов exe)
; 3) ./prog04                                       исполнение (запустить)
; 4) objdump -S -M intel -d prog04 > prog04.dump    дезассемблирование (достать из exe коды)

format ELF
public _start

section '.data' writable 
new_line equ 0xA
message db "Hello Universe!", new_line, 0

section '.text' executable
_start:
  mov eax, message
  call print_string
  call exit

section '.print_string' executable
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

section '.length_string' executable
length_string:
  push edx
  xor edx, edx
  .next_iter:
    cmp [eax + edx], byte 0
    je .close
    inc edx
    jmp .next_iter
  .close:
    mov eax, edx
    pop edx
    ret

section '.exit' executable
exit:
  mov eax, 1
  mov ebx, 0
  int 0x80


; Программа №6: вывод символа из регистра на экран
; Программа №6: вывод символа из регистра на экран
; Программа №6: вывод символа из регистра на экран

; Задача: мы хотим вывести на экран результат сложения

; mov eax, 10                     ; Поместить в eax = 10
; mov ebx, 20                     ; Поместить в ebx = 20  
; add eax, ebx                    ; Произвести сложение eax = 10 + 20 = 30

; В ассемблере нет способа вывести на экран значение регистра (eax = 30)
; Вывести на экран 10-тичное число 30 из регистра можно двумя способами: 
; 1) 30 конвертировать в строку '30' (и использовать функцию 4)
; 2) разбить по символам `3` (на экран), `0` (на экран)

; rax = 8bit    8bit    8bit    8bit    8bit    8bit    8bit    al=8bit 
; rax = 1byte   1byte   1byte   1byte   1byte   1byte   1byte   al=1byte
; rax = 1сим    1сим    1сим    1сим    1сим    1сим    1сим    al=1сим

; В программе есть сложная система указателей:

; 1) в секции .bss определен байт памяти `bss_char` (изначально = 1)
; 2) в основной программе eax = 'H' (код H = 72, регистр eax 32 бита == 4 байта)
; 3) переменную bss_char настраиваем на 1-байтовую часть eax, которая называется al
; 4) функция 4 выведет на экран (ebx=1) один символ (edx=1) с адреса (ecx=bss_char)

format ELF
public _start

section '.bss' writable
  bss_char db 1                     ; bss_char = 1 символ (байт)

section '.text' executable
_start:
  mov eax, 'H'
  call print_char
  mov eax, 'E'
  call print_char
  mov eax, 'L'
  call print_char
  mov eax, 'L'
  call print_char
  mov eax, 'O'
  call print_char
  call exit

section '.print_char' executable
; | input
; eax = char
print_char:
  push eax                          ; Сохранить в стек
  push ebx                          ; Сохранить в стек
  push ecx                          ; Сохранить в стек
  push edx                          ; Сохранить в стек
  mov [bss_char], al                ; Настроить al на байт, который в регистре al
  mov eax, 4                        ; eax = 4 (команда write)
  mov ebx, 1                        ; ebx = 1 (вывод на экран)
  mov ecx, bss_char                 ; ecx = адрес строки байт, которую выводим
  mov edx, 1                        ; edx = 1 (длина вывода в байтах)
  int 0x80                          ; Системный вызов 
  pop edx                           ; Вернуть из стека
  pop ecx                           ; Вернуть из стека
  pop ebx                           ; Вернуть из стека
  pop eax                           ; Вернуть из стека
  ret                               ; Вернуться

section '.exit' executable
exit:
  mov eax, 1
  xor ebx,ebx
  int 0x80


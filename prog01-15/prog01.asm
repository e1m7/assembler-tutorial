
; Программа №1: вывод строки на экран
; Программа №1: вывод строки на экран
; Программа №1: вывод строки на экран

; Регистры:
; 1) rax  64bit
; 2) eax  32bit
; 3) ax   16bit
; 4) ah   8bit

; Данные:
; 1 byte    8bit    (байт)              1 db
; 1 word    16bit   (слово)             1 dw
; 1 dword   32bit   (двойное слово)     1 dd  
; 1 qword   64bit   (четвертное слово)  1 rd  

; Запуск программы:
; 1) fasm prog01.asm
; 2) ld prog01.o -o prog01
; 3) ./prog01

; Чтобы вывести строку на экран надо:
; 1) eax = 4 (номер функции)
; 2) ebx = 1 (направление вывода)
; 3) ecx = message (строка байт, должна оканчиваться 0-ым байтом)
; 4) edx = len (длина message)
; 5) int 0x80 (вызвать системную функцию)

format ELF                  ; 32bit-ная архитектура

new_line equ 0xA                          ; new_line = байт с кодом 10 (новая строка)
message db "Hello World", new_line, 0     ; message = 'Hello World', new_line, байт 0
len = $ - message                         ; len = текущий адрес - адрес message (12 байт)

public _start

_start:
  mov eax, 4                ; eax = 4 (команда write)
  mov ebx, 1                ; ebx = 1 (выводим в терминал)
  mov ecx, message          ; ecx = адрес начала сообщения message
  mov edx, len              ; edx = длина сообщения len
  int 0x80                  ; Системный вызов
  call exit                 ; Вызвать процедуру exit

exit:
  mov eax, 1                ; eax = 1 (команда exit)
  mov ebx, 0                ; ebx = 0 (возвращаем 0, нормальный выход)
  int 0x80                  ; Системный вызов

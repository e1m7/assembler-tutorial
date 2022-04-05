
; Программа №17: ввод данных
; Программа №17: ввод данных
; Программа №17: ввод данных

format ELF
public _start

include "asmlib/fmt.inc"
include "asmlib/sys.inc"
include "asmlib/str.inc"

section '.bss' writable
  _buffer_char_size equ 2
  _buffer_char rb _buffer_char_size
  _buffer_number_size equ 11
  _buffer_number rb _buffer_number_size
  buffer_size equ 20
  buffer rb buffer_size


; Замечание: в 32-битовой архитектуре самое большое число 4294967295 (10 символов)
; Замечание: для ввода числа в 32-битной архитектуре достаточно буфера в 11 символов

section '.text' executable
_start:

  ; Ввод символа
  ; call input_char               ; Вызвали ввод символа
  ; call print_char               ; Вывели символ
  ; call print_line
  ; call exit

  ; Ввод числа
  ; call input_number             ; Вызвали ввод числа
  ; call print_number             ; Вызвали вывод числа    
  ; call print_line
  ; call exit

  ; Ввод строки
  ; mov eax, buffer               ; eax = буфер строки
  ; mov ebx, buffer_size          ; ebx = размер буфера (20)
  ; call input_string             ; Вызвать процедуру ввода строки
  ; call print_string
  ; call exit


section '.input_char' executable
; |output
; eax = char
input_char:
  mov eax, _buffer_char                 ; eax = настроили на буфер
  mov ebx, _buffer_char_size            ; ebx = размер буфера
  call input_string                     ; Вызвали ввод строки
  mov eax, [eax]                        ; eax = то, на что указывает eax
  ret

section '.input_number' executable
; |output
; eax = number
input_number:
  mov eax, _buffer_number               ; eax настраиваем на _buffer_number
  mov ebx, _buffer_number_size          ; ebx настраиваем на _buffer_number_size (11)  
  call input_string                     ; Вызвали чтение строки
  call string_to_number                 ; Вызвали перевод строки в число
  ret

section '.input_string' executable
; |output
; eax = buffer
; ebx = buffer size
input_string:
  push eax                      ; Сохранить в стеке
  push ebx                      ; Сохранить в стеке
  push ecx                      ; Сохранить в стеке
  push edx                      ; Сохранить в стеке
  push eax                      ; Сохраним в стеке eax
  mov ecx, eax                  ; ecx = eax
  mov edx, ebx                  ; edx = ebx
  mov eax, 3                    ; eax = 3 (функция ввода текста)
  mov ebx, 2                    ; ebx = 2 (с клавиатуры)
  int 0x80                      ; Системный вызов
  
  ; После ввода надо на последнее место буфера (или cтроки) положить байт 0 
  pop ebx                       ; ebx = eax (до ввода строки)
  mov [ebx + eax - 1], byte 0   ; ebx (адрес buffer) + eax (число введенных символов) - 1 = 0
  pop edx                       ; Восстановить из стека
  pop ecx                       ; Восстановить из стека
  pop ebx                       ; Восстановить из стека
  pop eax                       ; Восстановить из стека
  ret


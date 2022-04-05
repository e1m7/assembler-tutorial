
; Программа №14: реализация функции printf
; Программа №14: реализация функции printf
; Программа №14: реализация функции printf

; Замечание: суть форматирования в том, что строка `msg` вставляется в скобки `[msg]`
; Замечание: перед вызовом процедуры строка помещена в стек, шаблон помещен в eax

format ELF
public _start

include "asmlib/fmt.inc"
include "asmlib/sys.inc"

section '.data' writable
  fmt db "Hello [%s] and [%s]", 0
  msg1 db "World", 0
  msg2 db "Universe", 0

section '.text' executable
_start:
  push msg2                   ; Строка msg2 в стеке
  push msg1                   ; Строка msg1 в стеке

  ; 
  ;        esp =>       4 байта
  ;              |msg1| 4 байта
  ;              |msg2| 4 байта
  ; 

  mov eax, fmt                ; eax = формат вывода строки  
  call printf                 ; Вызвать процедуру printf  
  call print_line
  call exit

section '.printf' executable
; |input
; eax = format-string
; stack = mes1, mes2
printf:

  ; Замечание: в процессе обработки строки нам надо будет достать из стека адрес msg1, msg2
  ; Замечание: для этого надо использовать esp, он показывет на самый верх стека (где нет данных)
  ; Замечание: в 32-битной архитектуре 1 значение стека == 4 байта
  ; Замечание: в 64-битной архитектуре 1 значение стека == 8 байт

  mov ebx, 8                      ; ebx = 8 (две записи в стеке)

  .next_iter:
    cmp [eax], byte 0             ; Сравнение [eax] == 0 (дошли до конца строки?)
    je .close                     ; Если да, то .close (выход из процедуры)
    cmp [eax], byte '%'           ; Если нет, то сравнение [eax] == % (дошли до %?)
    je .special_char              ; Если да, то .special_char (выводим спец-символ)
    jmp .default_char             ; Если нет, то .default_char (выводим обычный символ)

    .special_char:                ; Специальный символ
      inc eax                     ; eax = eax + 1 (указываем на следующий после %)
      cmp [eax], byte 's'         ; Сравнение [eax] == s (указываем на символ `s`?)
      je .print_string            ; Если да, то выводим строку из стека
      jmp .next_step              ; Если нет, то переход .next_step (новый шаг)

    .print_string:                ; Вывод строки из стека (msg1, msg2)
      push eax                    ; Сохраняем eax в стек (регистр нужен для print_string)

  ; 
  ;        esp =>       4 байта
  ;              |eax | 4 байта
  ;              |msg1| 4 байта
  ;              |msg2| 4 байта
  ;              
  
      mov eax, [esp + ebx]        ; eax = то, на что указывает [esp + ebx] (msg1)
      call print_string           ; Вызов процедуры вывода строки
      pop eax                     ; Востановить eax из стека
      jmp .shift_stack            ; Сдвинуть стек (значение регистра ebx=4)

    .default_char:                ; Обычный символ
      push eax                    ; Сохранить eax в стек (регистр нужен для print_char)
      mov eax, [eax]              ; eax = то, на что указывает eax
      call print_char             ; Вызов процедуры вывода символа
      pop eax                     ; Восстановить eax из стека
      jmp .next_step              ; Переход на .next_step

    .shift_stack:                 ; Сдвиг стека
      add ebx, 4                  ; ebx = ebx + 4 = 8 + 4 = 12 (msg2)

    .next_step:                   ; Очередной шаг по строке
      inc eax                     ; eax = eax + 1
      jmp .next_iter              ; Переход на начало цикла

  .close:                         ; Завершение процедуры
    ret                           ; Возврат в основную программу



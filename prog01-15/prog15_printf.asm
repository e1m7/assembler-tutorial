
; Программа №15: реализация функции printf
; Программа №15: реализация функции printf
; Программа №15: реализация функции printf

format ELF
public _start

include "asmlib/fmt.inc"
include "asmlib/sys.inc"

section '.data' writable
  fmt db "Hello [%x]", 0
  msg1 db "World", 0
  msg2 db "Universe", 0

section '.text' executable
_start:
  push 20
  mov eax, fmt
  call printf
  call print_line
  call exit

section '.printf' executable
; | input
; eax = format-string
; stack = data
printf:

  push eax                              ; Сохранить в стек
  push ebx                              ; Сохранить в стек    
  mov ebx, 16                           ; ebx = 16 (4 данных в стеке)
  .next_iter:
    cmp [eax], byte 0                   ; Конец строки?
    je .close                           ; Да => на выход
    cmp [eax], byte '%'                 ; Нет => нашли символ %?
    je .special_char                    ; Да => обработка спец-символа
    jmp .default_char                   ; Нет => обработка обычного символа  

    .special_char:                      ; Обработка спец-символа
      inc eax                           ; eax = eax + 1 (следующий после %)    

      cmp [eax], byte 's'               ; [eax] == `s`
      je .print_string                  ; Да => вывод строки

      cmp [eax], byte 'd'               ; [eax] == `d`
      je .print_number                  ; Да => вывод 10-тичного числа

      cmp [eax], byte 'o'               ; [eax] == `o`
      je .print_oct                     ; Да => вывод 8-ричного числа

      cmp [eax], byte 'x'               ; [eax] == `x`  
      je .print_hex                     ; Да => вывод 16-ричного числа

      cmp [eax], byte 'c'               ; [eax] == `c`
      je .print_char                    ; Да => вывод символа

      cmp [eax], byte '%'               ; [eax] == `%`
      je .print_percent                 ; Да => вывод символа `%`
      jmp .next_step

    .print_string:
      push eax
      mov eax, [esp + ebx]
      call print_string
      pop eax
      jmp .shift_stack

    .print_number:
      push eax
      mov eax, [esp + ebx]
      call print_number
      pop eax
      jmp .shift_stack

    .print_oct:
      push eax
      mov eax, [esp + ebx]
      call print_oct
      pop eax
      jmp .shift_stack

    .print_hex:
      push eax
      mov eax, [esp + ebx]
      call print_hex
      pop eax
      jmp .shift_stack

    .print_char:
      push eax
      mov eax, [esp + ebx]
      call print_char
      pop eax
      jmp .shift_stack

    .print_percent:
      push eax
      mov eax, '%'
      call print_char
      pop eax
      jmp .next_step

    .default_char:
      push eax
      mov eax, [eax]
      call print_char
      pop eax
      jmp .next_step

    .shift_stack:
      add ebx, 4
    .next_step:
      inc eax
      jmp .next_iter

  .close:
    pop ebx 
    pop eax
    ret

section '.print_oct' executable
; | input
; eax = number
print_oct:
  push eax
  push ebx
  push ecx
  push edx
  xor ecx, ecx
  
  ; Перед выводом числа добавим 0
  push eax
  mov eax, '0'
  call print_char
  pop eax

  .next_iter:
    cmp eax, 0
    je .print_iter
    mov ebx, 8                      ; Делим число на 8
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

section '.print_hex' executable
; |input
; eax = number
print_hex:
  push eax
  push ebx
  push ecx
  push edx
  xor ecx, ecx

  ; Перед выводом добавим 0x
  push eax
  mov eax, '0'
  call print_char
  mov eax, 'x'
  call print_char
  pop eax

  .next_iter:
    cmp eax, 0
    je .print_iter
    mov ebx, 16               ; Делим число на 16
    xor edx, edx
    div ebx

    cmp edx, 10               ; Сравнить edx ? 10
    jl .is_number             ; Если меньше, то это число
    jmp .is_alpha             ; Если больше или равно, то это буква
    .is_number:
      add edx, '0'            ; Делаем из цифры цифру  
      jmp .next_step
    .is_alpha:
      sub edx, 10             ; Если вышел остаток C == 13, то edx = edx - 10 = 3
      add edx, 'A'            ; edx = edx + `A` = `C`
      jmp .next_step

  .next_step:
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

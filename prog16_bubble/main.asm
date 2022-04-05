
; Программа №16: сортировка массива по возростанию "пузырьком"
; Программа №16: сортировка массива по возростанию "пузырьком"
; Программа №16: сортировка массива по возростанию "пузырьком"


format ELF
public _start

include "asmlib/fmt.inc"
include "asmlib/sys.inc"

section ".data" writable
  array db 5,4,3,2,1          ; массив
  array_size equ 5            ; размер массива


section '.text' executable
_start:
  mov eax, array
  mov ebx, array_size

  call print_bytes
  call print_line

  call bubble_sort            ; Отсортировать массив
  
  call print_bytes
  call print_line
  call exit


section '.bubble_sort' executable
; |input
; eax = array
; ebx = array_size
bubble_sort:

  ; Замечание: переменная i = ecx (внешний цикл), переменная j = edx (внутренний цикл)
  ; Замечание: надо (по фен-шую) использовать только a,b,c,d- регистры и стек

  push ebx                    ; Сохранить в стек
  push ecx                    ; Сохранить в стек
  push edx                    ; Сохранить в стек

  xor ecx, ecx                ; ecx = 0 (переменная i = 0)

  .first_iter:                ; Внешний цикл (начало)
    cmp ecx, ebx              ; Сравнение ecx == ebx (5?)
    je .break_first           ; Да => выход из внешнего цикла
    xor edx, edx              ; Нет => edx = 0 (переменная j = 0)  

; for (size_t j = 0; j < size - i - 1; ++j) {
; ebx = size - i - 1          ; ebx сейчас равно 5 (размеру массива)

    push ebx                  ; Сохранить ebx в стек
    sub ebx, ecx              ; ebx = ebx - ecx 
    dec ebx                   ; ebx = ebx - 1

; ebx = size - i - 1          ; ebx получается как раз = 5 - i - 1

    .second_iter:             ; Внутренний цикл (начало)
      cmp edx, ebx            ; Сравнение edx == ebx (дошли до `5 - i - 1`?)
      je .break_second        ; Да => выход из внутреннего цикла 
      push ebx                ; Нет => сохранить ebx в стек
      mov bl, [eax+edx]       ; bl = первый элемент
      cmp bl, [eax+edx+1]     ; Сравнение первый == второй элементы
      jg .swap                ; Если больше, то .swap (перейти на обмен)
      jmp .pass               ; Если нет, то .pass (перейти дальше по внутреннему циклу)

    .swap:                    ; Обмен элементами (первый <=> второй)
      push ecx                ; Сохранить ecx в стек
      mov cl, [eax+edx+1]     ; cl = второй
      mov [eax+edx+1], bl     ; второй = первый
      mov [eax+edx], cl       ; первый = второй  
      pop ecx                 ; Восстановить ecx из стека

    .pass:                    ; Переход переход внутреннего цикла
      pop ebx                 ; Восстановить ebx из стека
      inc edx                 ; edx = edx + 1
      jmp .second_iter        ; Внутренний цикл (прыжок на начало)
    
    .break_second:            ; Подготовка к итерации внешнего цикла
      pop ebx                 ; Восстановить ebx из стека
      inc ecx                 ; ecx = ecx + 1
      jmp .first_iter         ; Внешний цикл (прыжок на начало)

  .break_first:               ;
    pop edx                   ; Достать из стека
    pop ecx                   ; Достать из стека
    pop ebx                   ; Достать из стека
    ret                       ;


section ".print_bytes" executable
; |input
; eax = array
; ebx = array_size
print_bytes:

  push eax                ; Сохранить в стек
  push ebx                ; Сохранить в стек
  push ecx                ; Сохранить в стек

  mov ecx, eax            ; exc = eax
  xor eax, eax            ; eax = 0 (очистить eax)
  mov al, '['             ; al = `[`
  call print_char         ; Вывести на экран символ `[`
  mov al, ' '             ; al = ' '
  call print_char         ; Вывести на экран символ ` `

  .next_iter:             ;
    cmp ebx, 0            ; Сравнение ebx == 0 (дошли до конца массива?)
    je .close             ; Если да => .close
    mov al, [ecx]         ; Если нет => al = очередной байт массива
    call print_number     ; Вывести элемент на экран
    inc ecx               ; ecx = ecx + 1
    mov al, ' '           ; al = ' '
    call print_char       ; Вывести на экран символ ` `
    dec ebx               ; ebx = ebx - 1 
    jmp .next_iter        ; Переход на начало цикла

  .close:                 ;
    mov al, ']'           ; al = `]`
    call print_char       ; Вывести на экран символ `]`

    pop ecx               ; Восстановить из стека
    pop ebx               ; Восстановить из стека
    pop eax               ; Восстановить из стека
    ret                   ;

; Программа №7: вывод на экран числа из регистра
; Программа №7: вывод на экран числа из регистра
; Программа №7: вывод на экран числа из регистра

; После того как мы освоили вывод на экран 1-го символа из регистра, можно выводить 571
; Для вывода числа надо разбить его на цифры и вызывать для каждой процедуру print_char

; Как разбить число на цифры?

; Создадим цикл для перебора числа по одному символу (по одной цифре)
; 571/10 = 57 и остаток 1 (занесем эту цифру в стек)
; 57/10 = 5 и остаток 7 (занесем эту цифру в стек)
; 5/10 = 0 и остаток 5 (занесем эту цифру в стек)
; Цикл продолжается пока текущее число != 0

; стек = 5 (код символа = 53)
;        7 (код символа = 55)
;        1 (код символа = 49)
; Возьмем из стека три раза значение и получим `5`,`7`,`1` (53 55 49)

; add eax, 10 (сложение)
; sub eax, 10 (вычитание)
; mul eax, 10 (умножение)
; div eax, 10 (деление)

format ELF
public _start

section '.bss' writable
  bss_char db 1

section '.text' executable
_start:
  mov eax, 571
  call print_number
  call print_line
  mov eax, 10
  mov ebx, 20
  add eax, ebx
  call print_number
  call print_line
  call exit

section '.print_number' executable
; | input
; eax = number
print_number:
  push eax                    ; Сохранили в стек
  push ebx                    ; Сохранили в стек
  push ecx                    ; Сохранили в стек
  push edx                    ; Сохранили в стек
  xor ecx, ecx                ; ecx = 0 (счетчик сколько нашли цифр)

  ; На данный момент в регистрах:
  ; а) eax = число, которое надо вывести (571)
  ; б) ecx = счетчик цифр числа (0)

  ; Цикл деления числа eax (571) на 10, чтобы получить отдельные цифры

  .next_iter:                 ; Цикл для прохода по всему числу и занесению его в стек
    cmp eax, 0                ; Сравнение eax == 0
    je .print_iter            ; Если eax == 0, то переходим на .print_iter
    ; Если eax != 0, то выполняется код ниже...
    mov ebx, 10               ; ebx = 10 (подготовим на что делить)
    xor edx, edx              ; edx = 0 (подготовим регистр для остатка)
    div ebx                   ; eax = eax / ebx = 571 / 10 (eax=57 результат, edx=1 остаток)

    ; Замечание: мы должны положить в стек не число 1, а код символа 1 (не 1, а 49)
    ; Замечание: для получения кода символа `1` можно сложить 1 (как число) и `0` (как символ)
    
    add edx, '0'              ; edx(1) + '0'(48) = 49(код 49) = "1" как символу
    push edx                  ; Занесли в стек первую цифру = "1" (код 49)
    inc ecx                   ; Увеличили счетчик найденных цифр (было 0, стало 1)
    jmp .next_iter            ; Вернуться в начало цикла .next_iter

    ; Замечание: после выхода из этого цикла в стеке будут находится три числа: 53|55|49 (самый низ)
    ; Замечание: после выхода из этого цикла ecx == 3 (сколько раз занесли в стек цифру)

  ; Цикл вывода на экран отдельных символов числа 571, которые достаются из стека

  .print_iter:                ; Цикл для вытаскивания из стека символов для печати
    cmp ecx, 0                ; Сравнение ecx == 0
    je .close                 ; Если esc == 0, то закрываем процедуру (восстанавливаем регистры и ret)
    ; Если ecx != 0, то выполняется код ниже...
    pop eax                   ; eax = достаем символ из стека (первым придет символ с кодом 53 = `5`)
    call print_char           ; Вызвать процедуру печати символа (на экран будет выведена `5`)
    dec ecx                   ; Уменьшаем счетчки найденных цифр (было 3, стало 2)
    jmp .print_iter           ; Вернуться в начало цикла .print_iter

  .close:
    pop edx                   ; Достали из стека
    pop ecx                   ; Достали из стека
    pop ebx                   ; Достали из стека
    pop eax                   ; Достали из стека
    ret                       ; Вернуться в основную программу

section '.print_char' executable
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

section '.print_line' executable
print_line:
  push eax
  mov eax, 0xA
  call print_char
  pop eax
  ret

section '.exit' executable
exit:
  mov eax, 1
  xor ebx,ebx
  int 0x80



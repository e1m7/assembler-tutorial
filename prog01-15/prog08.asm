
; Программа №8: перевод из числа в строку
; Программа №8: перевод из числа в строку
; Программа №8: перевод из числа в строку

; Мы можем разбивать число 571 на цифры (5,7,1), а потом обрабатывать их отдельно
; Надо разбить число на цифры и записать их в нужном порядке в строку, добавив в конце 0

; Замечание:
; Символ 1 имеет код 49
; Символ 2 имеет код 50
; Символ 5 имеет код 53

; Замечание:
; При любой длине буфера мы сможем обработать число размером -1 от его длины
; Крайним символом строки всегда должен быть 0 (буфер=10, число 123456789, на конце 0)

; Считается, что во всех операциях надо использовать только регистры eax, ebx, ecx, edx
; В данном случае их нам не хватит, поэтому воспользуемся дополнительными регистрами:
;   1) esi (этот возьмем)
;   2) edi
;   3) ebp (работает со стеком, не надо трогать)
;   4) esp (работает со стеком, не надо трогать)

; Замечание: есть еще регистры
; В 32-битной архитектуре есть еще регистры: mm0 ... mm7
; В 64-битной архитектуре есть еще регистры: r8 ... r15

format ELF
public _start

section '.data' writable
  _buffer.size equ 20         ; Размер буфера = 20 символов

section '.bss' writable
  _buffer rb _buffer.size     ; Буфер размером в 20 байт
  bss_char rb 1

section '.text' executable
_start:
  mov eax, 125                ; В регистре eax = число 125
  mov ebx, _buffer            ; В регистре ebx = буфер для строки  
  mov ecx, _buffer.size       ; В регистре ecx = размер буфера
  call number_to_string       ; Вызвать процедуру number_to_string

  mov eax, _buffer            ; eax = _buffer
  call print_string           ; Вывести строку на экран
  call print_line             ; Перейти на новую строку  
  call exit                   ; Завершить программу

section '.number_to_string' executable
; | input
; eax = number (125)
; ebx = _buffer
; ecx = _buffer.size
number_to_string:
  push eax                    ; Сохраняем в стек
  push ebx                    ; Сохраняем в стек
  push ecx                    ; Сохраняем в стек
  push edx                    ; Сохраняем в стек
  push esi                    ; Сохраняем в стек

  mov esi, ecx                ; esi = _buffer.size = 20 (ecx нам нужен для другого)
  dec esi                     ; Уменьшим буфера на 1, чтобы дописать в него 0 (было 20, стало 19)
  xor ecx, ecx                ; Очистим ecx (ecx = 0)  

  ; Запускаем цикл прохода по числу, на входе в цикл:
  ; eax = 125
  ; ebx = _buffer
  ; esi = 19
  ; ecx = 0

  .next_iter:
    push ebx                  ; Сохранить в стек адрес начала _buffer (терять нельзя)
    mov ebx, 10               ; ebx = 10 (на это число будем делить 125)
    xor edx, edx              ; edx = 0 (туда придет остаток от деления) 
    div ebx                   ; eax = eax / ebx ==> eax = 12, edx = 5
    pop ebx                   ; Вернуть из стека адрес начала _buffer (ebx ==> строку)
    add edx, '0'              ; edx = edx(5) + '0'(48) = 53 (символ `5`)
    push edx                  ; (53) положили в стек
    inc ecx                   ; ecx = ecx + 1 (было 0, стало 1)
    cmp eax, 0                ; Сравнение eax == 0 (наше число 125 уже превратилось в 0?)
    je .next_step             ; Если eax == 0, то переход на .next_step      
    ; Если eax != 0, то выполняется код ниже...
    jmp .next_iter            ; Переход на новую итерацию цикла (.next_iter)  

  ; Цикл прохода по числу окончен, по выходу:
  ; В стеке будут три числа: 49|50|53 (самый низ)
  ; В регистрах ebx = _buffer | ecx = 3 (цифр в стеке) | esi = 19 (байт под строку)

  ; Готовимся к следующему шагу: доставать из стека символы
  .next_step:
    mov edx, ecx              ; edx = ecx = 3
    xor ecx, ecx              ; ecx = 0

  ; Запускаем цикл прохода по строке (вытащенной из стека)
  ; В стеке: 49|50|53
  ; edx = 3 (числа в стеке)
  ; ecx = 0
  ; ebx = _buffer
  ; esi = 19 (байт под строку)

  .to_string:   
    cmp ecx, esi              ; Сравнение: ecx == esi (забили буфер?)
    je .pop_iter              ; Если ecx == esi, то переход на .pop_iter
    ; Если ecx != esi, то выполянется код ниже...
    cmp ecx, edx              ; Сравнение: ecx == edx (достали уже все числа?)  
    je .null_char             ; Если ecx == edx, то переход на .null_char
    ; Если ecx != edx, то выполняется код ниже...
    pop eax                   ; Достали из стека число в eax (на 1-ом шаге eax=49=`1`)
    mov [ebx+ecx], eax        ; Положили по адресу ebx+ecx то что в eax
    inc ecx                   ; ecx = ecx + 1 (было 0, стало 1)
    jmp .to_string            ; Переход на новую итерацию .to_string

  ; Замечание: выход из цикла возможен по двум вариантам: 
  ; Вариант 1: забили буфер (надо достать из стека все, но не доклеивать к строке)
  ; Вариант 2: достали все из стека (надо дописать на последнее место 0-ой байт)

  ; Вариант 1: забили буфер, писать больше некуда (допустим, что esi == 2)
  ; ecx = 2 (если eci == 2)
  ; edx = 3
  ; ebx = _buffer
  ; esi = 2 (буфер был = 3, -1 на 0-ой байт, нам дали 2 байта на число-строку)

  .pop_iter:
    cmp ecx, edx              ; Сравнение: ecx (сколько достали) == edx (сколько их в стеке)
    je .close                 ; Если ecx == edx, то зря сюда пришли (стек = буферу), переход на .close
    ; Если ecx != edx, то выполняем код ниже...
    pop eax                   ; Достаем из стека число в eax
    inc ecx                   ; ecx = ecx + 1 (было допустим 2, стало допустим 3)
    jmp .pop_iter             ; Перехдим на новую итерацию .pop_iter

  ; Замечание: этот цикл нужен для того, чтобы прокрутить доставание из стека чисел
  ; Замечание: если число не поместилось в буфер, то его все равно надо выбрать из стека
  ; Замечание: по окончании цикла стек пустой, в буфере то, что поместилось (часть числа)

  ; Вариант 2: все числа из стека были обработаны
  ; ecx = 3
  ; edx = 3
  ; ebx = _buffer
  ; esi = 19

  .null_char:
    mov esi, edx              ; esi = edx (3), теперь esi указывает на 3
  .close:
    mov [ebx+esi], byte 0     ; Добавляем к полученной строке byte `0`

    pop esi                   ; Возвращаем из стека
    pop edx                   ; Возвращаем из стека
    pop ecx                   ; Возвращаем из стека
    pop ebx                   ; Возвращаем из стека
    pop eax                   ; Возвращаем из стека
    ret


section '.print_number' executable
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
    cmp [eax+edx], byte 0
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
  xor ebx,ebx
  int 0x80



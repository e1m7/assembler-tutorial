
; Программа №11: нахождение чисел Фибоначчи
; Программа №11: нахождение чисел Фибоначчи
; Программа №11: нахождение чисел Фибоначчи

format ELF
public _start

section '.data' writable
  strnum db "12345678", 0
  _buffer.size equ 20

section '.bss' writable
  _buffer rb _buffer.size
  bss_char rb 1

section '.text' executable
_start:
  
  mov eax, 10                 ; eax = 10
  call fibonacci
  call print_number           ; Вывод на экран 55
  call print_line             ; Новая строка
  call exit                   ; Выход из программы


section '.fibonacci' executable
; | input
; eax = number
; | output
; eax = fibonacci number
fibonacci:
  push ebx                    ; Сохранить в стек
  push ecx                    ; Сохранить в стек
  mov ebx, 0                  ; ebx = 0 (1-ый элемент последовательности)  
  mov ecx, 1                  ; ecx = 1 (2-ой элемент последовательности)
  cmp eax, 0                  ; Проверка eax == 0 (прислали 0? отдельный случай!)  
  je .close0                  ; Если да, то переход на .close0

  ; Алгоритм нахождения нового числа Фибоначчи
  ; новое = 1-ое + 2-ое (ebx + ecx)
  ; 1-е = 2-ое                           
  ; 2-ое = новое                        

  ; eax = 10 (надо найти 10-ое число Фибоначчи), т.е. 55
  ; 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55

  .next_iter:
    cmp eax, 1                ; Проверка eax <= 1 (сколько раз делаем вычисления)  
    jle .close                ; Если да, то вычисления кончились, переход на .close
    push ecx                  ; Если нет, то сохраним в стеке ecx (2-ой элемент)
    add ecx, ebx              ; ecx = ecx + ebx (2-ой = 2-ой + 1-ый)
    pop ebx                   ; Достали из стека ebx (ebx = старый 2-ой элемент)
    dec eax                   ; eax = aex - 1 (уменьшили счетчик искомого элемента)
    jmp .next_iter
  .close0:                    ; Выход при eax == 0
    xor ecx, ecx              ; exc = 0 (это и будет ответ)
  .close:                     ; Выход при ecx >= 1
    mov eax, ecx              ; eax = ecx (последний вычисленный член последовательности)    

    pop ecx                   ; Восстановили из стека
    pop ebx                   ; Восстановили из стека
    ret

; Библиотека

section '.factorial' executable
factorial:
  push ebx
  mov ebx, eax
  mov eax, 1
  .next_iter: 
    cmp ebx, 1
    jle .close
    mul ebx
    dec ebx
    jmp .next_iter 
  .close:
    pop ebx
    ret

section '.string_to_number' executable
string_to_number:
  push ebx
  push ecx
  push edx
  xor ebx, ebx
  xor ecx, ecx
  .next_iter:               
    cmp [eax + ebx], byte 0
    je .next_step
    mov cl, [eax + ebx]
    sub cl, '0'
    push ecx
    inc ebx
    jmp .next_iter
  .next_step:
    mov ecx, 1
    xor eax, eax
  .to_number:
    cmp ebx, 0
    je .close
    pop edx
    imul edx, ecx
    imul ecx, 10
    add eax, edx
    dec ebx
    jmp .to_number
  .close:
    pop edx
    pop ecx
    pop ebx
    ret

section '.number_to_string' executable
number_to_string:
  push eax
  push ebx
  push ecx
  push edx
  push esi
  mov esi, ecx
  dec esi
  xor ecx, ecx
  .next_iter:
    push ebx
    mov ebx, 10
    xor edx, edx
    div ebx
    pop ebx
    add edx, '0'
    push edx
    inc ecx
    cmp eax, 0
    je .next_step
    jmp .next_iter
  .next_step:
    mov edx, ecx
    xor ecx, ecx
  .to_string:   
    cmp ecx, esi
    je .pop_iter
    cmp ecx, edx
    je .null_char
    pop eax
    mov [ebx+ecx], eax
    inc ecx
    jmp .to_string
  .pop_iter:
    cmp ecx, edx
    je .close
    pop eax
    inc ecx
    jmp .pop_iter
  .null_char:
    mov esi, edx
  .close:
    mov [ebx+esi], byte 0
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
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
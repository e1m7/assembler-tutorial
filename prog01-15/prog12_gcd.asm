
; Программа №12: наибольший общий делитель
; Программа №12: наибольший общий делитель
; Программа №12: наибольший общий делитель

; Замечание: НОД(a,b) = наибольший из общих делителей чисел (для 54 и 24 это 6)
; Замечание: поиск происходит по рекурентной формуле gcd(a,b) = gcd(b,a mod b)
; Замечание: поиск останавливается при gcd(a,0) = a

; a = eax (54)
; b = ebx (24)
; gcd(aex, ebx) = gcd(ebx, eax mod ebx)
; Выполняем деление пока ebx != 0


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
  mov eax, 54                 ; eax = 1 число
  mov ebx, 24                 ; ebx = 2 число
  call gcd                    ; Вызвать наибольший общий делитель  
  call print_number           ; Вывести его на экран
  call print_line             ; Вывести новую линию
  call exit                   ; Выход из программы

section '.gcd' executable
; | input
; eax = number1
; ebx = number2
; | output
; eax = gcd(number1, number2)
gcd:
  push ebx                    ; Сохранить в стек

  .next_iter:                 ; Итерация №1   
    cmp ebx, 0                ; Сравнение ebx == 0 (24 == 0?)
    je .close                 ; Если да, то конец процедуры  
    xor edx, edx              ; Если нет, то edx = 0 (готовим место под остаток от деления)
    div ebx                   ; aex / ebx = eax (целая часть = 2) edx (остаток = 6)
    push ebx                  ; Сохраняем в стек ebx (24 ушло в стек)  
    mov ebx, edx              ; ebx = edx (6)
    pop eax                   ; eax = 24 (достали из стека)    
    jmp .next_iter

    ; Итерация №2: eax = 24, ebx = 6                          Итерация №3: eax = 6, ebx = 0
    ; Сравниваем ebx == 0 (нет, ebx == 6)                     Сравнение ebx == 0 (да, выход)
    ; edx = 0
    ; eax / ebx = eax (целая часть = 4) edx (остаток = 0)
    ; Сохраняем в стек ebx (6 ушло в стек)
    ; ebx = edx (0)
    ; eax = 6 (достали из стека)

    ; После окончания цикла: eax = 6 (наибольший общий делитель)
  .close:
    pop ebx                   ; Достать из стека  
    ret


; Библиотека

section '.fibonacci' executable
fibonacci:
  push ebx
  push ecx
  mov ebx, 0
  mov ecx, 1
  cmp eax, 0
  je .close0
  .next_iter:
    cmp eax, 1
    jle .close
    push ecx
    add ecx, ebx
    pop ebx
    dec eax
    jmp .next_iter
  .close0:
    xor ecx, ecx
  .close:
    mov eax, ecx
    pop ecx
    pop ebx
    ret


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
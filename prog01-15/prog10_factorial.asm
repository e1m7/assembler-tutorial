
; Программа №10: нахождение факториала числа
; Программа №10: нахождение факториала числа
; Программа №10: нахождение факториала числа

; Замечание: 6! = 1*2*3*4*5*6 = 720

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
  
  mov eax, 6                  ; eax = 6
  call factorial              ; eax = 720
  call print_number           ; Вывод на экран 720 
  call print_line             ; Новая строка
  call exit                   ; Выход из программы


section '.factorial' executable
; | input
; eax = number
; | output
; eax = number!
factorial:
  push ebx                    ; Сохранить ebx в стек
  mov ebx, eax                ; ebx = eax = 6
  mov eax, 1                  ; eax = 1 (тут будем накапливать ответ)

  ; Начинаем цикл подсчета
  ; ebx = 6 (сколько раз крутить цикл, с 6 до 1)
  ; eax = накапливаем ответ (6*5*4*3*2*1 = 720)

  .next_iter: 
    cmp ebx, 1                ; Сравнение ebx <= 1 (дошли с 6 до 1?)
    jle .close                ; Если да, то переход на .close
    mul ebx                   ; Если нет, то eax = eax * ebx = 1 * 6 = 6
    dec ebx                   ; ebx = ebx - 1 (было 6, стало 5)
    jmp .next_iter 
  .close:
    pop ebx                   ; Восстановить ebx из стека
    ret                       ; Вернуться в основную программу    

; Библиотека

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
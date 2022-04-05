
; =================================
; Библиотека для работы со строками
; =================================

format ELF

public string_to_number
public number_to_string
public length_string

; Конвертация строки в число
section '.string_to_number' executable
; На входе: eax = string
; На выходе: eax = number
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


; Конвертация числа в строку
section '.number_to_string' executable
; На входе: eax = number, ebx = buffer, ecx = buffer.size
; На выходе: 
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


; Нахождение длины строки
section '.length_string' executable
; На входе: eax = string
; На выходе: eax = lenght
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
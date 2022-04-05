
; =================================================
; Библиотека для работы с математическими функциями
; =================================================

format ELF

public gcd
public fibonacci
public factorial

; Наибольший общий делитель
section '.gcd' executable
; На входе: eax = number1, ebx = number2
; На выходе: eax = number
gcd:
  push ebx
  push edx
  .next_iter:
    cmp ebx, 0
    je .close
    xor edx, edx
    div ebx
    push ebx
    mov ebx, edx
    pop eax
    jmp .next_iter
  .close:
    pop edx
    pop ebx
    ret


; Нахождение чисел Фибоначчи
section '.fibonacci' executable
; На входе: eax = number
; На выходе: eax = number
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

; Нахождение факториала числа
section '.factorial' executable
; На входе: eax = number
; На выходе: eax = number
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

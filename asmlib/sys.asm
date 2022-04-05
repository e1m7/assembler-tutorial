
; ===========================================
; Библиотека для работы с системными вызовами
; ===========================================

format ELF

public exit

section '.time' executable
; На входе:
; На выходе: eax = number
time:
  push ebx
  mov eax, 13
  xor ebx, ebx
  int 0x80
  pop ebx
  ret

; Выход из программы
section '.exit' executable
exit:
  mov eax, 1
  xor ebx,ebx
  int 0x80
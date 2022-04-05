
; Программа №9: перевод из строки в число
; Программа №9: перевод из строки в число
; Программа №9: перевод из строки в число

; Теперь стоит обратная задача: перевести строку формата "12345678",0 в число 123455678
; Строку надо разбить на отдельные цифры и правильно сложить их в регистр eax = 12345678
; Для разбиения мы проходим по всей строке и кладем ее цифры в стек
; Для склеивания числа мы используем правило: 123 = 1*100 + 2*10 + 3*1

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
  
  mov eax, strnum                 ; eax = строка "571",0
  call string_to_number           ; Перевести строку в число    
  call print_number               ; Вывести число на экран
  call print_line                 ; Вывести новую строку  
  call exit                       ; Закончить программу

section '.string_to_number' executable
string_to_number:

  push ebx                        ; Сохранить в стек
  push ecx                        ; Сохранить в стек
  push edx                        ; Сохранить в стек

  ; Занести в стек цифры числа 571: 1|7|5 (самый низ)

  xor ebx, ebx                    ; ebx = 0 (счетчик цифр)
  xor ecx, ecx                    ; ecx = 0 (перевалочный регистр, нужен для переброса)
  .next_iter:               
    cmp [eax + ebx], byte 0       ; Проверка [eax+ebx] == 0 (дошли до конца строки?)
    je .next_step                 ; Если да, то переход на .next_step  
    mov cl, [eax + ebx]           ; Если нет, то cl кладем байт [eax+ebx] (на первом шаге `5`)
    sub cl, '0'                   ; cl = `5` - `0` = 5 (было cl=53, стало cl=5)
    push ecx                      ; Сохранили в стек ecx (32-битный стек)
    inc ebx                       ; ebx = ebx + 1 (счетчик цифр увеличили на 1)  
    jmp .next_iter

  ; Достать цифры из стека: 1*1+7*10+5*100 = 571
  ; Надо отдельно считать 1, 10, 100, 1000, ...     => ecx
  ; Надо отдельно считать сумму 1*1+7*10+5*100      => eax

  .next_step:
    mov ecx, 1                    ; ecx = 1 (первая "десятка" в формуле)
    xor eax, eax                  ; eax = 0 (обнуляем регистр eax для собирания туда ответа)  
  .to_number:
    cmp ebx, 0                    ; Проверка ebx == 0 (все ли взяли из стека?)
    je .close                     ; Если да, то переход на .close
    pop edx                       ; Если нет, то edx = первое число из стека (первое = 1)
    imul edx, ecx                 ; edx = edx * ecx = 1 * 1 = 1 (первое слагаемое)
    imul ecx, 10                  ; ecx = ecx * 10 = 1 * 10 = 10 (вторая "десятка" в формуле)
    add eax, edx                  ; eax = eax + edx = 0 + 1 = 1 (собираем ответ в eax)
    dec ebx                       ; ebx = ebx - 1 (уменьшаем счетчик ebx, было 3, стало 2)
    jmp .to_number

  ; Закончить подпрограмму
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
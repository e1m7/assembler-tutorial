
; Программа №2: вывод строки на экран через процедуры
; Программа №2: вывод строки на экран через процедуры
; Программа №2: вывод строки на экран через процедуры

; Если добавить инструкцию executable, то не будет добавлена отладочная информация
; Объем исполняемого файла уменьшится, но дезассемблирование будет неудобным (для продакшена)
; В данном случае использование процедур не выгодно (выгода будет, когда вызов более 1-го раза)

format ELF executable
entry _start

new_line equ 0xA
message db "Hello Universe!", new_line, 0

_start:
  mov eax, message          ; Настраиваем eax на строку
  call print_string         ; Вызываем процедуру печати строки
  call exit                 ; Вызываем процедуру окончания программы

print_string:
; | input
; eax = string
  push eax                  ; Положить в стек
  push ebx                  ; Положить в стек
  push ecx                  ; Положить в стек
  push edx                  ; Положить в стек 
  mov ecx, eax              ; ecx = начало сообщения message
  call length_string        ; eax = длина сообщения (вычисляется в length_string)
  mov edx, eax              ; edx = eax длина вообщения (должна быть в edx)
  mov eax, 4                ; eax = 4 (команда write)
  mov ebx, 1                ; ebx = 1 (выводим в терминал)
  int 0x80
  pop edx                   ; Достать из стека
  pop ecx                   ; Достать из стека
  pop ebx                   ; Достать из стека
  pop eax                   ; Достать из стека
  ret

length_string:
; | input
; eax = string
; | output
; eax = number
  push edx                  ; Сохранить значение регистра edx (положить в стек)
  xor edx,edx               ; Обнуление регистра edx (аналог mov edx,0), код короче
  .next_iter:               ; Начало внутренней процедуры (цикл)
    cmp [eax+edx], byte 0   ; Сравнить значение по адресу eax + edx с байтом `0`
    je .close               ; Закрываем цикл, если [eax+edx] равно byte `0`
    inc edx                 ; edx = edx + 1
    jmp .next_iter
  .close:                   ; Конец внутренней процедуры (цикл)
    mov eax,edx             ; eax = edx (вычисленная длина должна быть в eax)
    pop edx                 ; Вернуть значение регистра edx (взять из стека)
    ret

exit:
; | input
; | output
  mov eax, 1                ; eax = 1 (команда exit)
  mov ebx, 0                ; ebx = 0 (возвращаем 0)
  int 0x80

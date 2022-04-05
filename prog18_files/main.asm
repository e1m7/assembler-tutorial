
; Программа №18: процедуры для работы с файлами
; Программа №18: процедуры для работы с файлами
; Программа №18: процедуры для работы с файлами

format ELF
public _start

include "asmlib/fmt.inc"
include "asmlib/sys.inc"

section '.bss' writeable
  buffer_size equ 50
  buffer rb buffer_size

section '.data' writeable
  datas db "Hello, World", 0
  ; datas_size = $ - datas              ; запись с последним 0-ым байтом
  datas_size = $ - datas - 1
  filename db "test_file.txt", 0

section '.text' executable
_start:

  ; Создание файла
  ; mov eax, filename
  ; mov ebx, 777o
  ; call fcreate
  ; call fclose

  ; Удаление файла
  ; mov eax, filename
  ; call fdelete

  ; Открытие файла
  ; mov eax, filename           ; eax = имя файла
  ; mov ebx, 1                  ; ebx = 1 (открытие на запись)
  ; call fopen
  ; mov ebx, datas
  ; mov ecx, datas_size
  ; call fwrite
  ; call fclose

  ; Чтение из файла
  mov eax, filename             ; eax = имя файла
  mov ebx, 0                    ; ebx = 0 (открыть на чтение)
  call fopen                    ; Открыть файл
  mov ebx, buffer               ; ebx = буфер
  mov ecx, buffer_size          ; ecx = размер буфера  
  call fread                    ; Читать из файла
  push eax
  mov eax, buffer               ; eax = буфер  
  call print_string             ; Вывести (прочитанную) строку  
  pop eax
  call fclose

  ; Замечание: данные в файл записываются в бинарном виде (из-за последнего 0)
  ; Замечание: 4865 6c6c 6f2c 2057 6f72 6c64 00 (с последним 0-ем в виде `00`)
  ; Замечание: при чтении файла `cat test_file.txt` текст будет виден символами
  ; Замечание: если скорректировать размер данных на -1, то данные запишутся верно

  call print_line
  call exit

section '.fcreate' executable
; |input
; eax = filename
; ebx = permissions (777 полные права)
; |output
; eax = descriptor
fcreate:
  push ebx
  push ecx
  mov ecx, ebx                ; ecx = ebx (777)
  mov ebx, eax                ; ebx = eax (имя файла)
  mov eax, 8                  ; eax = 8 (функция создания файла)
  int 0x80                    ; Системный вызов, eax = дескриптор файла
  pop ecx
  pop ebx
  ret

section '.fdelete' executable
; |input
; eax = filename
fdelete:
  push eax
  push ebx
  mov ebx, eax                ; ebx = eax (имя файла)
  mov eax, 10                 ; eax = 10 (функция удаления файла, unlink)
  int 0x80

  ; Замечание: технически файл останется на месте (на диске), удалится ссылка на него
  pop ebx
  pop eax
  ret

section '.fopen' executable
; |input
; eax = filename
; ebx = mode 
; 0 = O_RDONLY только чтение
; 1 = 0_WRONLY только запись
; 2 = 0_RDWR чтение и запись
; |output
; eax = descriptor
fopen:
  push ebx
  push ecx
  mov ecx, ebx                ; ecx = ebx (1)
  mov ebx, eax                ; ebx = eax (имя файла)
  mov eax, 5                  ; eax = 5 (функция открытия файла)
  int 0x80
  pop ecx
  pop ebx
  ret

section '.fclose' executable
; |input
; eax = descriptor
fclose:
  push ebx
  mov ebx, eax                ; ebx = eax (дескриптор файла)
  mov eax, 6                  ; eax = 6 (функция закрытия файла)
  int 0x80
  pop ebx
  ret

section '.fwrite' executable
; |input
; eax = descriptor
; ebx = data
; ecx = data size
fwrite:
  push eax
  push ebx
  push ecx
  push edx
  push ebx
  push ecx
  mov ebx, 1                  ; ebx = 1 (запись вперед)
  xor ecx, ecx                ; ecx = 0 (с -0-ой позиции файла)  
  call fseek                  ; Вызвать процедуру установки указателя файла
  pop ecx
  pop ebx
  mov edx, ecx                ; edx = ecx (размер данных для записи в файл)
  mov ecx, ebx                ; ecx = ebx (сами данные для записи в файл)
  mov ebx, eax                ; ebx = eax (дескриптор файла)
  mov eax, 4                  ; eax = 4 (функция записи/вывода)
  int 0x80
  pop edx
  pop ecx
  pop ebx
  pop eax
  ret

section '.fread' executable
; |input
; eax = descriptor
; ebx = buffer
; ecx = buffer size
fread:
  push eax
  push ebx
  push ecx
  push edx
  push ebx
  push ecx
  mov ebx, 1                  ; ebx = 1 (запись вперед)
  xor ecx, ecx                ; ecx = 0 (с -0-ой позиции файла)  
  call fseek                  ; Вызвать процедуру установки указателя файла
  pop ecx
  pop ebx
  mov edx, ecx                ; edx = ecx (размер данных для записи в файл)
  mov ecx, ebx                ; ecx = ebx (сами данные для записи в файл)
  mov ebx, eax                ; ebx = eax (дескриптор файла)
  mov eax, 3                  ; eax = 4 (функция чтения)
  int 0x80
  pop edx
  pop ecx
  pop ebx
  pop eax
  ret


section '.fseek' executable
; |input
; eax = descriptor
; ebx = mode seek
; ecx = position
; 0 = SEEK_SET (начало позиции работы с файлом)
; 1 = SEEK_CUR (направление смещения, вперед)
; 2 = SEEK_END (сместиться к концу файла)
fseek:
  push eax
  push ebx
  push edx
  mov edx, ebx                ; edx = ebx (модификатор направления)
  mov ebx, eax                ; ebx = eax (дескриптор файла)
  mov eax, 19                 ; eax = 19 (функция смещения указателя)
  int 0x80
  pop edx
  pop ebx
  pop eax
  ret
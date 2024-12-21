section .text
    global keyboard
    global saySomething
    global newline
    global print_hex
    global calcBootloader

keyboard:
    mov bx, 0x4001 ; memory begening for the string 0x4000 is metadata
    mov ch, 0x1 ; b10
    .keyboard:
        ; Print the input from al
        mov ah, 0x00
        int 0x16

        mov ah, 0x0E ; stored in the AL register
        cmp al, 0x3; ctlC
        JE keyboardDone ; jump if true?
        int 0x10

        mov [bx], al
        add bx, 0x1 ; incriment mem location
        add ch, 0x1 ; Increment metatadata
        loop .keyboard

saySomething:
    int 0x0E
    mov al, 'P'
    int 0x10
    ret

keyboardDone:
    mov [0x4000], ch ; Move metadata
    mov ch, 0x0 ; clear ch register
    mov cx, 0x0 ; clear cx
    call printInput
    jmp _start.return

printInput:
    mov si, 0x4001 ; Start of data
    mov cl, [0x4000] ; Get metadata
    call printMem
    ret

printMem:
    ; Store memory location to be read in si and store bytes to be read after that in cx
    .print_loop:
        mov ah, 0x0E      ; AH = 0Eh (Teletype output)
        lodsb             ; Load the byte at SI into AL and advance SI
        int 0x10          ; BIOS interrupt for screen output
        loop .print_loop  ; Continue printing until CX becomes zero
    ret

printMemBin:
    ; Store memory location to be read in si and store bytes to be read after that in cx
    .print_loop:
        mov cx, 16
        mov ah, 0x0E      ; AH = 0Eh (Teletype output)
        lodsb             ; Load the byte at SI into AL and advance SI
        call bin
        call newline
        loop .print_loop  ; Continue printing until CX becomes zero
    ret

newline:
    mov al, 0x0A        ; Character to print (newline)
    int 0x10            ; BIOS interrupt for screen output
    mov al, 0x0D        ; Carrage Return
    int 0x10            ; BIOS interrupt for screen output

print_hex:
    ; Input: dl (the value to be printed in hex)
    
    ; Convert the lower nibble to ASCII and print
    mov ah, dl        ; Move the value to ah
    shr ah, 4         ; Shift right to keep only the higher nibble
    call hex_to_ascii ; Call a subroutine to convert to ASCII and print
    
    ; Convert the higher nibble to ASCII and print
    mov ah, dl        ; Move the value to ah (original value is still in dl)
    and ah, 0x0F      ; Mask to keep only the lower nibble
    call hex_to_ascii ; Call a subroutine to convert to ASCII and print
    
    ret

hex_to_ascii:
    ; Input: ah (the nibble value to be converted to ASCII)
    ; Output: prints the ASCII character
    
    ; Convert the nibble to ASCII
    add ah, '0'       ; Convert to ASCII character
    
    ; Print the ASCII character
    mov ah, 0x0E      ; AH = 0Eh (Teletype output)
    int 0x10          ; BIOS interrupt for screen output
    
    ret
addal2ax:
    add dl, 0x1 ; add al to d
;    call saySomething
    jmp calcBootloader.addreturn ; tf is this

calcBootloader:
    mov dl, 0x0
    mov al, 0x0
    mov si, 0x7C00
    mov cx, 512
    .readMem:
;        lodsb             ; Load the byte at SI into AL and advance SI
        mov al, [si]
        add si, 0x01
        cmp al, 0x0       ; if there is a null byte then add it to the counter
        je addal2ax
        .addreturn:       ; idfk
        loop .readMem     ; Continue printing until CX becomes zero
    mov cx, 16
    mov [0x2000], dl
    mov si, 0x2000
    call bin

    mov al, ' '
    call print

    mov al, 'B'
    call print

    mov al, 'F'
    call print
    ret

div0:
    mov edx, 0
    mov eax, 0
    mov ecx, 0
    div ecx


bin:
    ; cx is counter (byte 8, word 16)
    ; si is memory address
    mov al, [si]
    and al, 00000001
    add al, 48

    int 0x0E ;print
    int 0x10

    shr byte [si], 1           ; Shift the byte to the right to get the next bit

    dec cx                     ; Decrement loop counter
    jnz bin       ; Jump back if CX is not zero
    ret

print:
    int 0x0E ;print
    int 0x10
    ret


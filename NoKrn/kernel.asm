section .text
    global _start

_start:
    ; Set up the segment registers
    xor ax, ax
    mov ds, ax
    mov es, ax

    ; Load the spooky text from disk
    mov ah, 0x02        ; AH = 02h (Read sectors)
    mov al, 1           ; Read one sector
    mov ch, 0           ; Cylinder number
    mov cl, 3           ; Sector number (adjust as needed)
    mov dh, 0           ; Head number
    mov dl, 0x80        ; Drive number (0x80 for the first hard disk)
    mov bx, 0x3000      ; Destination address in memory (adjust as needed)

    int 0x13            ; Issue the interrupt to read the sector

    mov ah, 0x0E        ; AH = 0Eh (Teletype output)
    mov al, 'K'         ; Character to print (indicating the "KILL" stage)
    int 0x10
    mov ah, 0x0E        ; AH = 0Eh (Teletype output)
    mov al, 'R'         ; Character to print (indicating the "YOUR" stage)
    int 0x10
    mov ah, 0x0E        ; AH = 0Eh (Teletype output)
    mov al, 'N'         ; Character to print (indicating the "SELF" stage)
    int 0x10
    call newline




;    mov cx, 16
;    mov si, 0x4000
;    mov word [si], 14

;    call bin

    mov al, 'B'
    call print

    mov al, 'L'
    call print

    mov al, 'S'
    call print

    ;call newline
    ;call calcBootloader
    ;call newline
    call newline
    mov al, '~'
    call print
;    cli
;    hlt


    ; Print raw data to the screen
;    mov si, 0x7C00           ; SI points to the start of the data
;    mov cx, 512          ; Number of bytes to print (assuming a standard sector size)
;    call printMem



    call keyboard
    .return: ; so the keyboard function can return to the correct place because I suck at asm
    ;call saySomething

    cli
    hlt

    ; Copy data from 0x1000 to 0xb800 (video mem)
;    mov ax, 0x1000
;    mov ds, ax
;    mov ax, 0xb800
;    mov es, ax
;    mov al, [ds:0]
;    mov [es:0], al


;    mov ah, 0x0E        ; AH = 0Eh (Teletype output)
;    mov al, 'C'         ; Character to print (indicating the "SELF" stage)
;    int 0x10


copy:
    mov esi,0x1000  ; source address of the code in DS:SI
    mov edi,0xA000  ; destination address of the code in ES:DI
    mov ecx,0x200   ; size of the code, 512 bytes (0x200)
    rep movsb       ; copy bytes from address in SI to address in DI.
    ret

%include "functions.asm"

times 512-($-$$) db 0  ; Fill the remaining bytes with zeros

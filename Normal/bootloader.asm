section .text
    global _start

_start:
    ; Set up the segment registers
    xor ax, ax
    mov ds, ax
    mov es, ax

    ; Load the kernel from disk
    mov ah, 0x02        ; AH = 02h (Read sectors)
    mov al, 1           ; Read one sector
    mov ch, 0           ; Cylinder number
    mov cl, 2           ; Sector number (adjust as needed)
    mov dh, 0           ; Head number
    mov dl, 0x80        ; Drive number (0x80 for the first hard disk)
    ;mov dl, 0x00        ; Drive number (0x00 for the first floppy disk)
    mov bx, 0x1000      ; Destination address in memory (adjust as needed)

    int 0x13            ; Issue the interrupt to read the sector

    ; Print diagnostic message
    mov ah, 0x0E        ; AH = 0Eh (Teletype output)
    mov al, 'L'         ; Character to print (indicating the "Loaded" stage)
    int 0x10            ; BIOS interrupt for screen output

    ; Check for errors
    jc read_error       ; Jump if carry flag is set (indicates error)

    ; Print diagnostic message
    mov ah, 0x0E        ; AH = 0Eh (Teletype output)
    mov al, 'S'         ; Character to print (indicating success)
    int 0x10            ; BIOS interrupt for screen output

    ; Print raw data to the screen
    ;mov si, 0x1000           ; SI points to the start of the data
    ;mov cx, 512          ; Number of bytes to print (assuming a standard sector size)
    ;call print_raw_data  ; Call the print_raw_data subroutine

    mov ah, 0x0E        ; AH = 0Eh (Teletype output)
    mov al, 'D'         ; Character to print (indicating success)
    int 0x10

    mov al, 0x0A        ; Character to print (newline)
    int 0x10            ; BIOS interrupt for screen output

    mov al, 0x0D        ; Carrage Return
    int 0x10            ; BIOS interrupt for screen output

    ; Jump to the loaded kernel
    jmp 0x0000:0x1000

read_error:
    ; Print diagnostic message
    mov ah, 0x0E        ; AH = 0Eh (Teletype output)
    mov al, 'E'         ; Character to print (indicating error)
    int 0x10            ; BIOS interrupt for screen output

    ; Halt the CPU
    cli
    hlt

print_raw_data:
    ; Print bytes in SI to the screen
    .print_loop:
        mov ah, 0x0E      ; AH = 0Eh (Teletype output)
        lodsb             ; Load the byte at SI into AL and advance SI
        int 0x10          ; BIOS interrupt for screen output
        loop .print_loop  ; Continue printing until CX becomes zero
        ret

times 510-($-$$) db 0  ; Fill the remaining bytes with zeros
dw 0xAA55              ; Boot signature

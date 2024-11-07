%include 'functions.asm'

section .data
    leftRotor db 0
    middleRotor db 0
    rightRotor db 0

    reflector db 'ZYXWVUTSRQPONMLKJIHGFEDCBA', 0
    left db 'EKMFLGDQVZNTOWYHXUSPAIBRCJ', 0
    middle db 'AJDKSIRUXBLHWTMCQGZNPYFVOE', 0
    right db 'BDFHJLCPRTXVZNYEIWGAKMUSQO', 0
    plugBoard db 'AJDKSIRUXBLHWTMCQGZNPYFVOE', 0

    welcomeMsg db 'Only Capital Alphabets and Spaces', 0

section .bss
    userInput resb 100

section .text
    global _start

rotateRight:
    inc byte [rightRotor]
    cmp byte [rightRotor], 26
    jz rightOverflow
    ret

rightOverflow:
    mov byte [rightRotor], 0
    call rotateMiddle
    ret

rotateMiddle:
    inc byte [middleRotor]
    cmp byte [middleRotor], 26
    jz middleOverflow
    ret
middleOverflow:
    mov byte [middleRotor], 0
    call rotateLeft
    ret

rotateLeft:
    inc byte [leftRotor]
    cmp byte [leftRotor], 26
    jz leftOverflow
    ret
leftOverflow:
    mov byte [leftRotor], 0
    ret

charToIndex:
    sub al, 'A'
    ret

indexToChar:
    add al, 'A'
    ret

encryptChar:
    cmp al, ' '
    jz .encryptFinish

    call charToIndex                            ; Convert character to 0-25 index

    ; Plugboard substitution
    movzx edi, al
    mov al, byte [plugBoard + edi]              ; Substitute using plugboard

    ; right rotor

    call charToIndex
    movzx edi, al
    mov al, byte [right + edi]


    ;middle rotor
    call charToIndex
    movzx edi, al
    mov al, byte [middle + edi]

    ;left rotor
    call charToIndex
    movzx edi, al
    mov al, byte [left + edi]

    ;reflector shift
    call charToIndex
    movzx edi, al
    mov al, byte [reflector + edi]

    ;backward left
    mov edi, 0
.loopLeft:
    cmp byte [left+edi], al
    jz .substituteLeft
    inc edi
    jmp .loopLeft
.substituteLeft:
    push edi
    mov al, byte [esp]
    pop edi
    call indexToChar

    ;backward middle
    mov edi, 0
.loopMiddle:
    cmp byte [middle+edi], al
    jz .substituteMiddle
    inc edi
    jmp .loopMiddle
.substituteMiddle:
    push edi
    mov al, byte [esp]
    pop edi
    call indexToChar

    ;backward right
    mov edi, 0
.loopRight:
    cmp byte [right+edi], al
    jz .substituteRight
    inc edi
    jmp .loopRight
.substituteRight:
    push edi
    mov al, byte [esp]
    pop edi
    call indexToChar

    ;backward plugboard
    mov edi, 0
.loopPlugboard:
    cmp byte [plugBoard+edi], al
    jz .substitutePlugboard
    inc edi
    jmp .loopPlugboard
.substitutePlugboard:
    push edi
    mov al, byte [esp]
    pop edi
    call indexToChar

.encryptFinish:

    ret

; Main program
_start:
    ; Read user input (up to 100 characters)
    mov eax, welcomeMsg
    call sprintln

    mov eax, 3                                  ; sys_read
    mov ebx, 0                                  ; stdin
    mov ecx, userInput
    mov edx, 100
    int 0x80

    ; Encrypt each character
    mov ecx, userInput
.nextChar:
    mov al, byte [ecx]                          ; Load next character
    cmp al, 10                                   ; Check for null terminator
    je .done
    call encryptChar                            ; Encrypt character in AL
    call putchar                                ; Output encrypted character
    call rotateRight                           ; Rotate rotors
    inc ecx                                     ; Move to the next character
    jmp .nextChar                               ; Repeat for all characters

.done:
    ; Print newline
    mov eax, 0xA
    call putchar
    ; Exit
    call quit

iprint:
    push eax
    push ecx
    push edx
    push esi
    mov ecx, 0

divideLoop:
    inc ecx
    mov edx, 0
    mov esi, 10
    idiv esi
    add edx, 48
    push edx
    cmp eax, 0
    jnz divideLoop

printLoop:
    dec ecx
    mov eax, esp
    call sprint
    pop eax
    cmp ecx, 0
    jnz printLoop

    pop esi
    pop edx
    pop ecx
    pop eax
    ret

iprintln:
    call iprint
    push eax
    mov eax, 0xA
    push eax
    mov eax, esp
    call sprint
    pop eax
    pop eax
    ret
 
slen:
    push ebx
    mov ebx, eax
nextchar:
    cmp byte [eax], 0
    je finsihed
    inc eax
    jmp nextchar
finsihed:
    sub eax, ebx
    pop ebx
    ret

sprint:
    push edx
    push ecx
    push ebx
    push eax
    call slen

    mov edx, eax
    pop eax

    mov ecx, eax
    mov ebx, 1
    mov eax, 4
    int 0x80

    pop ebx
    pop ecx
    pop edx
    ret

sprintln:
    call sprint
    push eax
    mov eax, 0xA
    push eax
    mov eax, esp
    call sprint
    pop eax
    pop eax
    ret

quit:
    mov eax, 1
    mov ebx, 0
    int 0x80
    ret

atoi:
    push    ebx             ; preserve ebx on the stack to be restored after function runs
    push    ecx             ; preserve ecx on the stack to be restored after function runs
    push    edx             ; preserve edx on the stack to be restored after function runs
    push    esi             ; preserve esi on the stack to be restored after function runs
    mov     esi, eax        ; move pointer in eax into esi (our number to convert)
    mov     eax, 0          ; initialise eax with decimal value 0
    mov     ecx, 0          ; initialise ecx with decimal value 0

.multiplyLoop:
    xor     ebx, ebx        ; resets both lower and uppper bytes of ebx to be 0
    mov     bl, [esi+ecx]   ; move a single byte into ebx register's lower half
    cmp     bl, 48          ; compare ebx register's lower half value against ascii value 48 (char value 0)
    jl      .finished       ; jump if less than to label finished
    cmp     bl, 57          ; compare ebx register's lower half value against ascii value 57 (char value 9)
    jg      .finished       ; jump if greater than to label finished

    sub     bl, 48          ; convert ebx register's lower half to decimal representation of ascii value
    add     eax, ebx        ; add ebx to our integer value in eax
    mov     ebx, 10         ; move decimal value 10 into ebx
    mul     ebx             ; multiply eax by ebx to get place value
    inc     ecx             ; increment ecx (our counter register)
    jmp     .multiplyLoop   ; continue multiply loop

.finished:
    cmp     ecx, 0          ; compare ecx register's value against decimal 0 (our counter register)
    je      .restore        ; jump if equal to 0 (no integer arguments were passed to atoi)
    mov     ebx, 10         ; move decimal value 10 into ebx
    div     ebx             ; divide eax by value in ebx (in this case 10)

.restore:
    pop     esi             ; restore esi from the value we pushed onto the stack at the start
    pop     edx             ; restore edx from the value we pushed onto the stack at the start
    pop     ecx             ; restore ecx from the value we pushed onto the stack at the start
    pop     ebx             ; restore ebx from the value we pushed onto the stack at the start
    ret

putchar:
    push ebx
    push ecx
    push edx
    push eax
    mov ecx, esp
    mov eax, 4
    mov ebx, 1
    mov edx, 1
    int 0x80

    pop eax
    pop edx
    pop ecx
    pop ebx
    ret

	AREA ARMex, CODE, READONLY
		ENTRY

start
    mov r1, #1
	
Section .text
    global _ft_strlen

_ft_strlen :
	mov rcx, 0
	jmp count

count :
	cmp BYTE [rdi + rcx], 0
	je end
	inc rcx
	jmp count

end :
	mov rax, rcx
	ret
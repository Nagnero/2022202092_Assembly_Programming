	AREA    ARMex, CODE, READONLY
		ENTRY
	
Start
	LDR r0, TEMPADDR1
	LDR r1, =string1
	MOV r3, #0

loop
	LDRB r2, [r1]	; string
	ADD r1, r1, #1	; move to next character
	ADD r3, r3, #1	; plus one len
	CMP r2, #0
	BEQ done
	B loop
   
done
	SUB r3, r3, #1
	STR r3, [r0]
	MOV pc, lr

TEMPADDR1 & &40000
string1 DCB "Hello, World!", 0

	END
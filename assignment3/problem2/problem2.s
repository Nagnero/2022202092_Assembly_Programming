	AREA    ARMex, CODE, READONLY
		ENTRY
	
Start
	LDR r0, TEMPADDR1
	LDR r1, =string1
	MOV r3, #0
	B	loop

loop
	LDRB r2, [r1]
	ADD r1, r1, #1
	ADD r3, r3, #1
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
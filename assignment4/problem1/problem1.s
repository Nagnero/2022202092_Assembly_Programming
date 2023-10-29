	AREA ARMex, CODE, READONLY
		ENTRY
	
start
	LDR r0, TEMPADDR1
	MOV	r1, #1
	MOV r2, #1
	
loop	; Loop
	
	ADD r2, r2, #1
	
	
	
TEMPADDR1 & &40000

	MOV pc, lr
	END
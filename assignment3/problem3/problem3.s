	AREA ARMex, CODE, READONLY
		ENTRY
	
start
	LDR r0, TEMPADDR1
	MOV	r1, #0
	MOV r2, #1
	
	BL	Example1
	BL	Example2
	BL	Example3
	
Example1	; Loop
	ADD r1, r2
	ADD r2, r2, #1
	CMP r2, #11
	BNE	Example1

	
Example2	; n(n+1)/2


Example3	; Unlooping
	
	
TEMPADDR1 & &40000

	MOV pc, lr
	END

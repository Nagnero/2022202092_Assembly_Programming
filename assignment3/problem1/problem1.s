	AREA ARMex, CODE, READONLY
		ENTRY
	
start
	MOV r0, #11
	MOV r1, #1
	MOV r2, #5
	MOV r3, #2
	LDR r4, TEMPADDR1
	
	B	Example_1
	
Example_1
	MOV r3, r3, LSL #1
	ADD r2, r2, r3
	SUB r0, r0, r1
	ADD r0, r0, r2
	STR r0, [r4]
	
	
TEMPADDR1 & &40000

	MOV pc, lr
	END

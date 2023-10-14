	AREA ARMex, CODE, READONLY
		ENTRY
	
start
	LDR r0, TEMPADDR1
	MOV	r1, #0
	MOV r2, #1
	
	B	Example1
	
	
Example1	; Loop
	ADD r1, r2
	ADD r2, r2, #1
	CMP r2, #11
	BNE	Example1
	STR r1, [r0], #4

	
Example2	; n(n+1)/2
	MOV r1, #10
	ADD r2, r1, 1
	MUL r3, r1, r2
	LSR r1, r3, 1
	STR r1, [r0], #4


Example3	; Unlooping
	MOV r1, #0
	MOV r2, #1
	ADD r1, r2
	ADD r2, #1
	ADD r1, r2
	ADD r2, #1
	ADD r1, r2
	ADD r2, #1
	ADD r1, r2
	ADD r2, #1
	ADD r1, r2
	ADD r2, #1
	ADD r1, r2
	ADD r2, #1
	ADD r1, r2
	ADD r2, #1
	ADD r1, r2
	ADD r2, #1
	ADD r1, r2
	ADD r2, #1
	ADD r1, r2
	ADD r2, #1
	STR r1, [r0]
	
	
	
TEMPADDR1 & &40000

	MOV pc, lr
	END
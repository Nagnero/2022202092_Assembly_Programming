	AREA ARMex, CODE, READONLY
		ENTRY
   
start
	LDR r0, TEMPADDR1
	MOV r1, #2
	MOV r2, #1
	STR r2, [r0], #4

loop
	MUL r2, r1, r2
	STR r2, [r0], #4
	ADD r1, #1
	CMP r1, #11
	BEQ endline
	B loop
   
TEMPADDR1 & &40000

endline
	MOV pc, lr
	END
	AREA ARMex, CODE, READONLY
		ENTRY
   
start
	LDR r0, TEMPADDR1
	MOV r1, #17 ; 010001
	MOV r2, #3 ; 000011
	MOV r3, #0
	MOV r4, #0
	
loop1	; 17 x 3, Rs is 3
	ADD r3, #1
	MOV r2, r2, LSR #2
	CMP r2, #0
	BNE loop1
	
loop2	; 3 x 17, Rs is 17
	ADD r4, #1
	MOV r1, r1, LSR #2
	CMP r1, #0
	BNE loop2

   
TEMPADDR1 & &40000

	MOV pc, lr
	END
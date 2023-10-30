	AREA ARMex, CODE, READONLY
		ENTRY
   
start
	LDR r0, TEMPADDR1
	MOV r1, #0

	MOV r2, #1
	STR r2, [r0], #4 ; store 1!

	MOV r2, r2, LSL #1
	STR r2, [r0], #4 ; store 2!

	ADD r2, r2, r2, LSL #2
	STR r2, [r0], #4 ; store 3!

	MOV r2, r2, LSL #2
	STR r2, [r0], #4 ; store 4!

	ADD r2, r2, r2, LSL #2
	STR r2, [r0], #4 ; store 5!

	ADD r2, r2, r2, LSL #1
	MOV r2, r2, LSL #1
	STR r2, [r0], #4 ; store 6!

	MOV r1, r2, LSL #3
	SUB r2, r1 , r2
	STR r2, [r0], #4 ; store 7!

	MOV r2, r2, LSL #3
	STR r2, [r0], #4 ; store 8!

	ADD r2, r2, r2, LSL #3
	STR r2, [r0], #4 ; store 9!

	MOV r1, r2, LSL #3
	ADD r2, r1, r2, LSL #1
	STR r2, [r0], #4 ; store 10!
   
   
   
TEMPADDR1 & &40000

	MOV pc, lr
	END
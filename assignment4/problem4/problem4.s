	AREA ARMex, CODE, READONLY
		ENTRY
   
start
	LDR r0, TEMPADDR1
	LDR r1, Value1 ; first value
	LDR r2, Value2 ; second value
	
	; get value1's sign bit
	STR r1, [r0]
	LDRB r3, [r0, #3]
	CMP r3, #0x80
	MOVCS r3, #1
	MOVCC r3, #0
	
	; get value1's exponent bit
	LDRH r5, [r0, #3]
	LSL r5, #17
	LSR r5, #24
	
	; get value1's mantissa bit and add 1.0
	LDR r7, [r0]
	LSL r7, #9
	LSR r7, #1
	ADD r7, r7, #0x80000000
	LSR r7, #9
	
	; get value2's sign bit
	STR r2, [r0]
	LDRB r4, [r0, #3]
	CMP r4, #0x80
	MOVCS r4, #1
	MOVCC r4, #0
	
	; get value2's exponent bit
	LDRH r6, [r0, #3]
	LSL r6, #17
	LSR r6, #24
	
	; get value2's mantissa bit and add 1.0
	LDR r8, [r0]
	LSL r8, #9
	LSR r8, #1
	ADD r8, r8, #0x80000000
	LSR r8, #9
	
	
	; check 0
	ADD r9, r5, r7
	CMP r9, #0
	BEQ value10
	ADD r9, r6, r8
	CMP r9, #0
	BEQ value20
	
	; check Nan
	
	
	CMP r5, r6 ; compare exponent
	BEQ same ; exponent is equal
	
	; exponent of val1 > val2
	SUBHI r9, r5, r6 ; r9 = r5 - r6
	ADDHI r6, r6, r9 ; increase val2 exponent
	LSRHI r8, r9 ; right shift val2 mantissa
	MOVHI r10, r5
	
	; exponent of val1 < val2
	SUBHI r9, r6, r5 ; r9 = r6 - r5
	ADDHI r5, r5, r9 ; increase val1 exponent
	LSRHI r7, r9 ; right shift val1 mantissa
	MOVHI r10, r6
	
same
	MOVEQ r10, r5

	CMP r3, #0
	BEQ val1POS
	BNE val2NEG
	
val1POS
	CMP r4, #0 ; check val2 sign bit
	MOVEQ r12, #0 ; both positive, r12 is sign bit of result
	ADDEQ r11, r7, r8
	BEQ 
	
val2NEG
	
   
TEMPADDR1 & &40000
Value1 DCD 0x3F800000
Value2 DCD 0x40500000
	
value10
	MOV r1, #0

value20
	MOV r1, #0

endline
	MOV pc, lr
	END
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
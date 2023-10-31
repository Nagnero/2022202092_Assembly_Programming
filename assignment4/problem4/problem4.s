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
	LSR r7, #8
	
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
	LSR r8, #8
	
	
	CMP r5, r6 ; compare exponent
	BGT val1greater
	BLT val1lesser
	MOV r11, r5 ; save result exponent if exponent is equal
	B comparesign
	
val1greater	; exponent of val1 > val2
	SUB r9, r5, r6 ; r9(shift num) = r5 - r6
	ADD r6, r6, r9 ; increase val2 exponent
	LSR r8, r9 ; right shift val2 mantissa
	MOV r11, r5 ; save result exponent
	B comparesign
	
val1lesser	; exponent of val1 < val2
	SUB r9, r6, r5 ; r9(shift num) = r6 - r5
	ADD r5, r5, r9 ; increase val1 exponent
	LSR r7, r9 ; right shift val1 mantissa
	MOV r11, r6 ; save result exponent
	B comparesign
	

comparesign
	CMP r3, r4 ; check sign
	MOVEQ r10, r3 ; save result sign bit
	ADDEQ r12, r7, r8 ; if sign is same, add mantissa
	BEQ check10 ; and go to nomarlization
	CMP r7, r8; if sign is different, compare mantissa
	SUBGT r12, r7, r8
	MOVGT r10, r3 ; save result sign bit
	SUBLE r12, r8, r7
	MOVLE r10, r4 ; save result sign bit

	
	; nomarlization process
check10
	CMP r12, #0x01000000 ; check mantissa > 10.xx
	LSRGE r12, #1 ; right shift result mantissa
	ADDGE r11, #1 ; increase result exponent
	BGE check10

check1
	CMP r12, #0x00800000 ; check mantissa < 0.xx
	LSLLT r12, #1 ; left shift result mantissa
	SUBLT r11, #1 ; decrease result exponent
	BLT check1
	
finish	; after normarlization
	SUB r12, #0x00800000 ; sub matissa bit 1.0
	LSL r10, #31
	ADD r10, r10, r11, LSL #23 ; add exponent bit to result
	ADD r10, r10, r12 ; add mantissa bit to result
	STR r10, [r0] ; store result to r0
	B endline
	
   
TEMPADDR1 & &40000
Value1 DCD 0xFFF00000
Value2 DCD 0xC1F00000
	
endline
	MOV pc, lr
	END
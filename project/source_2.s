	AREA code_area, CODE, READONLY
		ENTRY

float_number_series EQU 0x0450
sorted_number_series EQU 0x00018AEC
final_result_series EQU 0x00031190

;========== Do not change this area ===========

initialization
	LDR r0, =0xDEADBEEF				; seed for random number
	LDR r1, =float_number_series	
	LDR r2, =10000  				; The number of element in stored sereis
	LDR r3, =0x0EACBA90				; constant for random number

save_float_series
	CMP r2, #0
	BEQ is_init
	BL random_float_number
	STR r0, [r1], #4
	SUB r2, r2, #1
	MOV r5, #0
	B save_float_series

random_float_number
	MOV r5, LR
	EOR r0, r0, r3
	EOR r3, r0, r3, ROR #2
	CMP r0, r1
	BLGE shift_left
	BLLT shift_right
	BX r5

shift_left
	LSL r0, r0, #1
	BX LR

shift_right
	LSR r0, r0, #1
	BX LR
	
;============================================

;========== Start your code here ===========
	
is_init
	MOV r0, r1						; r0 is last data address
	LDR r1, =float_number_series	
	ADD r1, #4						; r1 will points last value
	
outer_loop
	CMP r0, r1						; check last loop
	BEQ exit
	LDR r2, =float_number_series
	LDR r4, [r1]					; get last data to r4
	B compare_loop					; insert sort
next_loop
	ADD r1, #4
	B outer_loop					; repeat loop

compare_loop ; r3 is val1, r4 is val2
	CMP r2, r1			; check loop out
	BEQ next_loop
	LDR r3, [r2]		; get first data to r3
	LDR r5, =sorted_number_series
	STR r3, [r5]		; get value1 sign bit to r6
	LDRB r6, [r0, #3]
	CMP r6, #0x80
	MOVCS r6, #1
	MOVCC r6, #0
	
	STR r4, [r5]		; get value2 sign bit to r7
	LDRB r7, [r0, #3]
	CMP r7, #0x80
	MOVCS r7, #1
	MOVCC r7, #0
	
	CMP r6, r7			; compare sign bit
	BGT val1_bigger		; if val1 is bigger
	BLT val2_bigger		; if val2 is bigger
	
	STR r3, [r5]		; get val1 exponent r8
	LDRH r8, [r5, #3]
	LSL r8, #17
	LSR r8, #24
	
	STR r4, [r5]		;get val2 exponent to r9
	LDRH r9, [r5, #3]
	LSL r9, #17
	LSR r9, #24
	
	CMP r8, r9			; compare exponent
	BGT val1_bigger
	BLT val2_bigger
	

val1_bigger ; insert data
	MOV r3, r1			; temp addr
	LDR r4, [r3]
	LDR r5, [r2]
	STR r4, [r2]
	ADD r2, #4
loop_shift
	CMP r2, r3
	STREQ r5, [r2]
	BEQ next_loop
	LDR r6, [r2]
	STR r5, [r2]
	MOV r5, r6
	ADD r2, #4
	B loop_shift

val2_bigger ; don't switch data and compare next loop
	ADD r2, #4
	B compare_loop
	

exit
	MOV pc, LR
	END

;========== End your code here ===========
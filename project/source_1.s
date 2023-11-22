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
	BEQ ms_init
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
	
ms_init
	LDR r1, =float_number_series	
	LDR r2, =10000					; The number of element in stored sereis
	
	
exit
	END

;========== End your code here ===========
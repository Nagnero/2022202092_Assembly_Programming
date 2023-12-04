	AREA code_area, CODE, READONLY
		ENTRY

float_number_series EQU 0x0450
sorted_number_series EQU 0x00018AEC
final_result_series EQU 0x00031190

;========== Do not change this area ===========

initialization
	LDR r0, =0xDEADBEEF				; seed for random number
	LDR r1, =float_number_series	
	LDR r2, =10000				  ; The number of element in stored sereis
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
	LDR r13, =sorted_number_series
	MOV r0, r1		; r0 is last data address
	LDR r2, =10000					; The number of element in stored sereis
	
merge_sort
	MOV r3, #1		; r3 is current size
outer_loop
	CMP r3, r2
	BGT exit		; exit condition
	MOV r4, #0		; r4 is left start
inner_loop
	SUB r5, r2, #1	; r5 is temp val (length - 1)
	CMP r4, r5		; check inner loop exit condition
	LSLGE r3, #1	
	BGE outer_loop
	SUB r6, r3, #1	; r6 is temp val (current size - 1)
	ADD r7, r4, r6	; r7 is mid
	ADD r8, r4, r3, LSL #1	; r8 is temp val (left + 2*current size)
	SUB r8, #1
	CMP r8, r5
	ADDLT r9, r4, r3, LSL #1 ; r9 is right
	SUBLT r9, #1
	MOVGE r9, r5
	BL merge
	ADD r4, r3, LSL #1
	B inner_loop

merge	; r4: left, r7: mid, r9: right
	STMFD sp!, {r0-r9}
	MOV r0, r4		; r0 is i
	ADD r1, r7, #1	; r1 is j
	MOV r2, r4		; r2 is k
	LDR r3, =float_number_series	; r3 is arr
	LDR r5, =final_result_series	; r5 is temp (result)
loop1
	LDR r6, [r3, r0, LSL #2]	; arr[i]
	LDR r8, [r3, r1, LSL #2]	; arr[j]
	CMP r0, r7
	BGT loop2
	CMP r1, r9
	BGT loop2
	MOV r10, r6, LSR #31 		; r10 is sign bit
	MOV r11, r8, LSR #31		; r11 is sign bit
	CMP r10, r11			; compare sign bit
	BGT save_arri
	BLT save_arrj
	
	CMP r10, #1
	BEQ both_minus		; both value is minus
	CMP r6, r8		; else both value is plus
	BLE save_arri
	BGT save_arrj
	
both_minus
	CMP r6, r8
	BGE save_arri
	BLT save_arrj
	
save_arri
	STR r6, [r5, r2, LSL #2] 
	ADD r0, r0, #1		; increase i
	ADD r2, r2, #1		; increase k
	B loop1
save_arrj
	STR r8, [r5, r2, LSL #2]
	ADD r1, r1, #1		; increase j
	ADD r2, r2, #1		; increase k
	B loop1
	
	
loop2
	CMP r0, r7		; compare i and mid
	BGT loop3
	LDR r6, [r3, r0, LSL #2]
	STR r6, [r5, r2, LSL #2] 
	ADD r0, r0, #1		; increase i
	ADD r2, r2, #1		; increase k
	B loop2
	
loop3
	CMP r1, r9		; compare j and right
	BGT loop4
	LDR r8, [r3, r1, LSL #2]
	STR r8, [r5, r2, LSL #2]
	ADD r1, r1, #1		; increase j
	ADD r2, r2, #1		; increase k
	B loop3
	
loop4
	CMP r4, r9
	BGT exit_merge
	LDR r6, [r5, r4, LSL #2]
	STR r6, [r3, r4, LSL #2]
	ADD r4, r4, #1
	B loop4
	
exit_merge
	LDMFD sp!, {r0-r9}
	MOV pc, LR
	
exit
	MOV pc, #0
	END

;========== End your code here ===========
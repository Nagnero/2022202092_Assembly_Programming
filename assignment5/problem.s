CR	EQU 0x0D

	AREA ARMex, CODE, READONLY
		ENTRY
   
start
	LDR r0, =k
	MOV r3, #1
	STRB r3, [r0] ; save 1 to k
	LDR r1, =Arr1 ; first string
	LDR r2, =Arr2 ; second string
	BL copy_arr_wo_space
	STRB r0, [r1] ; store length to k
	B endline
	
copy_arr_wo_space
	STMFD sp!, {r0-r5}
	MOV r3, #0 ; same as i
	MOV r4, #0 ; same as j
	MOV r5, #0 ; length of arr1
	
copy_arr1_to_arr2
	LDRB r0, [r1], #1 ; r0 is temp variable for char
	CMP r0, #CR ; check if charactor is same as CR
	BEQ end_copy ; end of copying string
	CMP r0, #0x20 ; check with space
	STRBNE r0, [r2], #1 ; save char to r2
	ADDNE r4, #1 ; increase j (length of arr2)
	ADD r3, #1 ; increase i
	B copy_arr1_to_arr2
end_copy
	STMFD sp!, {r4}
	LDMFD sp!, {r0-r6}
	MOV pc, lr ; exit from function
	
endline
	MOV pc, lr

		
	;dataArray, DATA
k
	DCB 0
Arr1
	DCB "Hello, World", CR
	ALIGN
Arr2
	DCB 0
	
	END
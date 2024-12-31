; Function: ft_lstsort_asm
; Parameters:
;   R0 - Pointer to the list (address of t_list *)
;   R1 - Pointer to comparison function (address of int (*f_comp)(int, int))
        AREA    Sorting_Code, CODE, READONLY
        ALIGN
        THUMB
        EXPORT  ft_lstsort_asm

ft_lstsort_asm FUNCTION
		PUSH	{R0-R1, LR}
		LDR R3 , [SP]         ; head of the list  R3 = head 
		LDR R4, [SP, #4]      ; address of the compare function R4 = compare function
		
L_outer
		MOVS R5, #0           ; Flag for swapped R5 = flag
		MOV R6, R3            ; R6 = head (current node)
		LDR R6, [R6]		  ; Load R6 with the value of head pointer
		
L_inner		
		
        LDR R7, [R6, #4]      ; R7 = next node (R6->NEXT)
		CMP R7, #0  		  ; If R7 is null, exit
		BEQ check_swap
		
		LDR R0, [R6] 		  ; R0 = Current node value (R6->VALUE)
		LDR R1, [R7]		  ; R1 = next node value (R7->VALUE)
		PUSH {R3}             ; Push R3 to protect head of the list in R3
		BLX R4                ; Call comparison function (R4) (a<b?)
		POP {R3}              ; Pop head of the list from stack and save into R3

        CMP R0, #1		      ; Check if a and b are ordered
		BEQ no_swap			  ; If ordered, branch no_swap label to move to the next node
			
		LDR R2, [R6]          ; R2 = current node value
        LDR R0, [R7]          ; R0 = next node value
        STR R0, [R6]          ; R6->value = R7->value
        STR R2, [R7]          ; R7->value = prev R6->value
   			
        MOVS R5, #1           ; Set swapped flag

no_swap
        MOV R6, R7            ; Move to the next node
        B   L_inner           ; Continue inner loop

check_swap
        CMP R5, #0            ; Check if swapped occurred
        BNE L_outer           ; If swapped, continue outer loop
				
		POP	{R0-R1, PC}
		ENDFUNC
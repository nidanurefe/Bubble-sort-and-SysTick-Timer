        AREA    Timing_Code, CODE, READONLY
        ALIGN
        THUMB
        EXPORT  Systick_Start_asm
        EXPORT  Systick_Stop_asm
		EXPORT	SysTick_Handler 
									
		EXTERN	ticks			; Declare ticks variable is defined in another module

SysTick_Handler FUNCTION
		PUSH	{LR}			; Push LR to protect its value
		LDR     R0, =ticks      ; Load the address of tick counts in R0
        LDR     R1, [R0]		; Load the ticks count in R1
        ADDS    R1, R1, #1		; Increment ticks count
        STR     R1, [R0]		; Store incremented ticks count in its address, R0
		POP		{PC}			; Restore return address from stack
		ENDFUNC					; End of function.

Systick_Start_asm FUNCTION
		PUSH	{LR}			; Push LR to protect its value
		LDR     R0, =0xE000E010 ; Load address of SysTick control and Status Register (STCSR) addresses in R0
        LDR     R1, =0xE000E014 ; Load address of SysTick Reload Value Register(STRVR) in R1
		
        LDR     R2, =0x1D9      ; Load reload value in R2
								; Reload value is calculated using formula (SystemCoreClock / 100000) - 1
								; Oscillator frequency is defined as 50000000UL and
								; SystemClock is defined as (XTAL / 2U)
								; Therefore SystemCoreClock = 25 MHz
								; And reload value = 249
								
        STR     R2, [R1]        ; Set the reload value to STRVR
        MOVS    R2, #7          ; Set bits to enable SysTick, its interrupt, and select processor clock.
        STR     R2, [R0]		; Write SysTick configuration to STCSR to start SysTick
        POP		{PC}			; Restore return address from stack
		ENDFUNC					; End of function.

Systick_Stop_asm FUNCTION
		PUSH	{LR}			; Push LR to protect its value
		LDR     R0, =0xE000E010 ; Load address of SysTick Control and Status Register (STCSR)
        MOVS    R1, #0          ; Load 0 into R1 to disable SysTick
        STR     R1, [R0]		; Write 0 to adress of STCSR to stop SysTick
        LDR     R0, =ticks		; Load the address of ticks variable into R0
        LDR     R1, [R0]		; Load current ticks count in R1
        MOVS    R2, #0			; Write 0 into R2 to reset ticks
        STR     R2, [R0]        ; Write 0 to ticks variable to reset
        MOV     R0, R1          ; Return the non-zero value of ticks
		POP		{PC}			; Restore return address from stack
		ENDFUNC					; End of function.

		END

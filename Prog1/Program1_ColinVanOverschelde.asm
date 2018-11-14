TITLE Program Template     (template.asm)

; Author: Colin Van Overschelde
; Course / Project ID: CS 271 / Programming Assignment #1                Date: 1/20/2018
; Description: Program1_ColinVanOverschelde.asm demonstrates defining variables, using library procedures for I/O
;				and integer artithmetic in MASM assembly language

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data

; (insert variable definitions here)
	; Introduction prompts
	nameAndTitle		BYTE	"Hi, my name is Colin Van Overschelde and this is Programming Assignment #1", 0		; string to display program title
	instructions1		BYTE	"Programming Assignment #1 calculates the sum, difference, product,", 0				; string to display the first line of instructions
	instructions2		BYTE	"(integer) quotient and remainder of any two integers", 0							; string to display the second line of instructions
	promptFirstNum		BYTE	"Enter the first integer: ", 0														; string to prompt user for first integer
	promptSecondNum		BYTE	"Enter the second integer: ", 0														; string to prompt user for second integer
	terminating			BYTE	"Program complete, terminating...", 0												; string to display the end of the program

	; Input numbers and result
	num1				SDWORD	?																					; operand 1
	num2				SDWORD	?																					; operand 2
	result				SDWORD	?																					; result of arithmetic
	remainder			SDWORD	?																					; remainder of division operation

	; Output strings
	sumResult			BYTE	" + ", 0									
	differenceResult	BYTE	" - ", 0
	productResult		BYTE	" * ", 0
	quotientResult		BYTE	" / ", 0
	remainderResult		BYTE	" % ", 0
	equalsResult		BYTE	" = ", 0

	; Extra Credit Prompts
	extraCredit1		BYTE	"**EC: Repeat until the user chooses to quit.", 0									; string to display extra credit options submitted
	extraCredit2		BYTE	"**EC: Validate the second number to be less than the first.", 0					; string to display extra credit options submitted
	num2TooLarge		BYTE	"The second number must be less than the first!", 0									; string to display when invalid input for num2
	keepPlaying			BYTE	"Play again? (0=Yes, 1=No): ", 0													; string to display to loop program
	
.code
main PROC

; (insert executable instructions here)
	; Display your name and program title on the output screen
	mov		EDX, OFFSET nameAndTitle
	call	WriteString
	call	CrLf
	call	CrLf

	; Display Extra Credit
	mov		EDX, OFFSET extraCredit1
	call	WriteString
	call	CrLf
	mov		EDX, OFFSET extraCredit2
	call	WriteString
	call	CrLf
	call	CrLf

L1:
	; Display instructions for the user
	mov		EDX, OFFSET instructions1
	call	WriteString
	call	CrLf

	mov		EDX, OFFSET instructions2
	call	WriteString
	call	CrLf
	call	CrLf

	; Read the first number from the user
	mov		EDX, OFFSET promptFirstNum
	call	WriteString
	call	ReadInt
	mov		num1, EAX
	call	CrLf

	; Read the second number from the user
L2:
	mov		EDX, OFFSET promptSecondNum
	call	WriteString
	call	ReadInt
	jmp		L4

	; Display invalid input notification
L3:
	mov		EDX, OFFSET num2TooLarge
	call	WriteString
	call	CrLf
	jmp		L2
	
L4:
	; Check that the number input is less than num1
	cmp		EAX, num1
	jg		L3
	
	; Assign input to num2
	mov		num2, EAX
	call	CrLf

	; Calculate and display the sum
	mov		EAX, num1
	add		EAX, num2
	mov		result, EAX
	mov		EAX, num1
	call	WriteInt
	mov		EDX, OFFSET sumResult
	call	WriteString
	mov		EAX, num2
	call	WriteInt
	mov		EDX, OFFSET equalsResult
	call	WriteString
	mov		EAX, result
	call	WriteInt
	call	CrLf
	
	; Calculate and display the difference
	mov		EAX, num1
	sub		EAX, num2
	mov		result, EAX
	mov		EAX, num1
	call	WriteInt
	mov		EDX, OFFSET differenceResult
	call	WriteString
	mov		EAX, num2
	call	WriteInt
	mov		EDX, OFFSET equalsResult
	call	WriteString
	mov		EAX, result
	call	WriteInt
	call	CrLf

	; Calculate and display the product
	mov		EAX, num1
	imul	num2
	mov		result, EAX
	mov		EAX, num1
	call	WriteInt
	mov		EDX, OFFSET productResult
	call	WriteString
	mov		EAX, num2
	call	WriteInt
	mov		EDX, OFFSET equalsResult
	call	WriteString
	mov		EAX, result
	call	WriteInt
	call	CrLf

	; Calculate and display the quotient (integer)
	mov		EAX, num1
	CDQ
	mov		EBX, num2
	idiv	EBX
	mov		result, EAX
	mov		remainder, EDX
	mov		EAX, num1
	call	WriteInt
	mov		EDX, OFFSET quotientResult
	call	WriteString
	mov		EAX, num2
	call	WriteInt
	mov		EDX, OFFSET equalsResult
	call	WriteString
	mov		EAX, result
	call	WriteInt
	call	CrLf

	; Display the remainder
	mov		EAX, num1
	call	WriteInt
	mov		EDX, OFFSET remainderResult
	call	WriteString
	mov		EAX, num2
	call	WriteInt
	mov		EDX, OFFSET equalsResult
	call	WriteString
	mov		EAX, remainder
	call	WriteInt
	call	CrLf
	call	CrLf

	; Prompt keep playing
	mov		EDX, OFFSET keepPlaying
	call	WriteString
	call	ReadInt
	cmp		EAX, 0
	je		L1


	; Display terminating message
	mov		EDX, OFFSET terminating
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main

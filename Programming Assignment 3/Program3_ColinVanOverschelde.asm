TITLE Program3     (Program3_ColinVanOverschelde.asm)

; Author: Colin Van Overschelde
; OSU E-mail: vanoverc@oregonstate.edu
; Course: CS 271
; Project ID: Programming Assignment #3
; Due Date: 2/11/2018
; Description: Demonstrates Implementing data validation, an accumulator, integer arithmetic, 
;			   defining variables (integer and string), using library procedures for I/O
;			   and implementing control structures (decision, loop, procedure)

INCLUDE Irvine32.inc

; (insert constant definitions here)
	UPPER_LIMIT = -1
	LOWER_LIMIT = -100

.data

; (insert variable definitions here)
	; Input strings
	welcome			BYTE	"Welcome to the Integer Accumulator by Colin Van Overschelde", 0
	getName			BYTE	"What is your name? ", 0
	greeting		BYTE	"Hello, ", 0
	instruction1	BYTE	"Please enter numbers in [-100, -1].", 0
	instruction2	BYTE	"Enter a non-negative number when you are finished to see results.", 0
	inputPrompt		BYTE	"Enter number: ", 0

	; Data variables
	userName		BYTE	25 DUP(0)
	someNum			SWORD	?
	numCount		WORD	0
	total			SWORD	0
	average			SWORD	0
	remainder		WORD	0
	countAverage	WORD	0

	; Output strings
	displayCount1	BYTE	"You entered ", 0
	displayCount2	BYTE	" valid numbers.", 0
	displaySum		BYTE	"The sum of your valid numbers is ", 0
	displayAverage	BYTE	"The rounded average is ", 0
	partingMessage	BYTE	"Thank you for playing Integer Accumulator!  It's been a pleasure to meet you, ", 0
	noInput			BYTE	"No negative numbers entered, skipping average claculation.", 0

.code
main PROC

	; (insert executable instructions here)
	;	Display Program Info
	CALL	displayProgInfo

	; Greet User
	CALL	greetUser

	; Display Instruction
	CALL	displayInstructions

	; Get input numbers
	CALL	getInput

	; Check if any input was entered
	MOV		AX, numCount
	MOV		BX, 0
	CMP		AX, BX
	JE		SkipCalculations	; If not, skip calculations

	; Calculate the average of the entered numbers
	CALL	calcAverage

	SkipCalculations:
	; Display Output
	CALL	displayOutput

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

; Procedure: displayProgInfo
; Description: Display the introduction strings for this program
; Receives: n/a
; Returns: n/a
; Pre-Conditions: n/a
; Registers Changed: n/a
displayProgInfo	PROC
	; Prepare registers
	PUSH	EBP
	MOV		EBP, ESP
	PUSHAD

	; Display the welcome string
	MOV		EDX, OFFSET welcome
	CALL	WriteString
	CALL	CrLf

	; Restore registers
	POPAD
	POP		EBP

	RET
displayProgInfo	ENDP

; Procedure: greetUser
; Description: Prompts the user for their name and then greets them
; Receives: n/a
; Returns: n/a
; Pre-Conditions: n/a
; Registers Changed: n/a
greetUser PROC
	; Prepare registers
	PUSH	EBP
	MOV		EBP, ESP
	PUSHAD

	; Prompt user for their name
	MOV		EDX, OFFSET getName
	CALL	WriteString

	; Get userName from input
	MOV		EDX, OFFSET userName
	MOV		ECX, SIZEOF	userName
	CALL	ReadString

	; Display greeting string
	MOV		EDX, OFFSET greeting
	CALL	WriteString
	; Display userName
	MOV		EDX, OFFSET userName
	CALL	WriteString
	CALL	CrLf

	; Restore registers
	POPAD
	POP		EBP

	RET
greetUser ENDP

; Procedure: displayInstructions
; Description: Displays the program instruction strings
; Receives: n/a
; Returns: n/a
; Pre-Conditions: n/a
; Registers Changed: n/a
displayInstructions PROC
	; Prepare registers
	PUSH	EBP
	MOV		EBP, ESP
	PUSHAD

	; Display the program instructions
	CALL	CrLf
	MOV		EDX, OFFSET instruction1
	CALL	WriteString
	CALL	CrLf
	MOV		EDX, OFFSET instruction2
	CALL	WriteString
	Call	CrLf
	
	; Restore registers
	POPAD
	POP		EBP

	RET
displayInstructions ENDP

; Procedure:getInput
; Description: Accepts input values and adds them to total
; Receives: n/a
; Returns: n/a
; Pre-Conditions: n/a
; Registers Changed: n/a
getInput PROC
	; Prepare registers
	PUSH	EBP
	MOV		EBP, ESP
	PUSHAD

	; Enter loop to accept input
	InputLoop:
		; Prompt user for input
		MOV		EDX, OFFSET inputPrompt
		CALL	WriteString

		; Read the input
		CALL	ReadInt
		MOV		someNum, AX

		; Validate that input is betwee [-100, -1] inclusive
		MOV		BX, UPPER_LIMIT
		CMP		AX, BX
		JG		StopInput
		MOV		BX, LOWER_LIMIT
		CMP		AX, BX
		JGE		AddToSum
		CALL	displayInstructions
		JMP		InputLoop

	AddToSum:
		; Add the validated input value to total
		INC		numCount
		MOV		BX, total
		ADD		BX, AX
		MOV		total, BX
		JMP		InputLoop
		
	StopInput:
		; Does nothing, just resumes the procedure

	; Restore registers
	POPAD
	POP		EBP

	ret
getInput ENDP

; Procedure: calcAverage
; Description: Calculates the average value of the input numbers
; Receives: n/a
; Returns: n/a
; Pre-Conditions: n/a
; Registers Changed: n/a
calcAverage PROC
	; Prepare registers
	PUSH	EBP
	MOV		EBP, ESP
	PUSHAD

	; Calculate average
	MOV		AX, total
	CWD
	MOV	 	BX, numCount
	IDIV	BX
	MOV		average, AX
	MOV		remainder, DX

	; Round to nearest int
	; Calculate "0.5" value of remainder
	MOV		AX, numCount
	DEC		AX
	CWD
	MOV		BX, -2
	IDIV	BX
	MOV		countAverage, AX
	MOV		BX, remainder
	; Compare "0.5" value of remainder to remainder
	CMP		AX, BX
	JLE		ResumeAverage	; If remainder is less than "0.5" value, skip rounding
	DEC		average			; Round the average to the next integer

	ResumeAverage:
	; Restore registers
	POPAD
	POP		EBP

	ret
calcAverage ENDP

; Procedure: displayOutput
; Description: Displays the output strings for the program
; Receives: n/a
; Returns: n/a
; Pre-Conditions: n/a
; Registers Changed: n/a
displayOutput PROC
	; Prepare registers
	PUSH		EBP
	MOV			EBP, ESP
	PUSHAD

	; Check if the user entered at least 1 valid number
	MOVZX		EAX, numCount
	MOV			EBX, 0
	CMP			EAX, EBX
	JE			NoInputEntered		; If not numbers input, skip all calculated output

	; Display the count of valid numbers entered
	MOV			EDX, OFFSET displayCount1
	CALL		WriteString
	CALL		WriteDec
	MOV			EDX, OFFSET displayCount2
	CALL		WriteString
	CALL		CrLf

	; Display the sum of the valid numbers entered
	MOV			EDX, OFFSET displaySum
	CALL		WriteString
	MOVSX		EAX, total
	CALL		WriteInt
	CALL		CrLf

	; Display the average of the valid numbers entered
	MOV			EDX, OFFSET displayAverage
	CALL		WriteString
	MOVSX		EAX, average
	CALL		WriteInt
	CALL		CrLf
	JMP			ResumeOutput

	NoInputEntered:
		; Display no valid numbers entered
		MOV		EDX, OFFSET noInput
		CALL	WriteString
		CALL	CrLf
	
	ResumeOutput:
	; Display parting message to the user
	MOV			EDX, OFFSET	partingMessage
	CALL		WriteString
	MOV			EDX, OFFSET userName
	CALL		WriteString
	CALL		CrLf

	; Restore registers
	POPAD
	POP			EBP

	ret
displayOutput ENDP

END main

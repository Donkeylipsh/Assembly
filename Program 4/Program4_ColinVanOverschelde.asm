TITLE Programming Assignment 4     (Program4ColinVanOverschelde.asm)

; Author: Colin Van Overschelde
; OSU E-mail: vanoverc@oregonstate.edu
; Course: CS 271
; Project ID: Programming Assignment 4
; Due Date: 2/18/2018
; Description: Programming Assignment 4 calculates and displays composite numbers while demonstrating designing and implementing:
;			    procedures, loops, nested loops and data validation

INCLUDE Irvine32.inc

; (insert constant definitions here)
MIN_INPUT = 1			; Data validation variable
MAX_INPUT = 10000		; Data validation variable
LINES_PER_PAGE = 250	; Number of composite numbers to display per page

.data

; (insert variable definitions here)
;introduction globals
programName		BYTE	"Welcome to Composite Numbers", 0
programAuthor	BYTE	"Programmed by Colin Van Overschelde", 0
instructions1	BYTE	"Enter the number of composite numbers you would like to see.", 0
instructions2	BYTE	"I'll accpect orders for up to 400 composites.", 0
extraCredit1	BYTE	"**EC: All output columns are aligned", 0
extraCredit2	BYTE	"**EC: Accepts up to 10,000 composites, and displays 250 composites per page of output", 0

; getUserData globals
inputPrompt		BYTE	"Enter the number of composites to display [1 .. 10,000]: ", 0
badInput		BYTE	"Out of range.  Try again.", 0
compositeCount	WORD	?				; Contains the number of composites to display
isBadInput		BYTE	0				; Boolean value used to determine input validation

; showComposites globals
totalComposites		WORD	0			; The count of composite numbers found so far
currentNum			WORD	1			; The value of the current number being evaluated
minComposite		WORD	0			; The value of last composite number found
nextPage			BYTE	"Press any key to continue...", 0

; farewell globals
certification	BYTE	"Results certified by Colin Van Overschelde.  Goodbye", 0

.code
; Description: main is a simple main procedure that performs procedure calls to perform all program implementations
;			   1. Display Introduction
;			   2. Prompt for input
;				  2a. Validate input is within range
;			   3. Calculate and display composites
;			   4. Say farewell
; Receives: n/a
; Returns: n/a
; Pre-Conditions: n/a
; Registers Changed: none
main PROC

; (insert executable instructions here)
	CALL	introduction
	CALL	getUserData
	CALL	showComposites
	CALL	farewell
	exit	; exit to operating system
main ENDP

; (insert additional procedures here)
; Description: introduction displays the program title and extra credit
; Receives: n/a
; Returns: n/a
; Pre-Conditions: n/a
; Registers Changed: none
introduction PROC
	; Prepare Registers
	PUSH	EBP
	MOV		EBP, ESP
	PUSHAD

	; Display Program Information
	MOV		EDX, OFFSET programName
	CALL	WriteString
	
	MOV		AL, 9
	CALL	WriteChar

	MOV		EDX, OFFSET programAuthor
	CALL	WriteString
	CALL	CrLf

	MOV		EDX, OFFSET extraCredit1
	CALL	WriteString
	CALL	CrLf

	MOV		EDX, OFFSET extraCredit2
	CALL	WriteString
	CALL	CrLf

	CALL	CrLf

	; Display Program Instructions
	MOV		EDX, OFFSET instructions1
	CALL	WriteString
	CALL	CrLf

	MOV		EDX, OFFSET instructions2
	CALL	WriteString
	CALL	CrLf

	CALL	CrLf

	; Restore registers
	POPAD
	POP		EBP

	RET
introduction ENDP

; Description: getUserData prompt the user for the count of composite numbers they want to display and
;			   performs data validation to ensure the input value is within range
; Receives: n/a
; Returns: n/a
; Pre-Conditions: n/a
; Registers Changed: none
getUserData PROC
	; Prepare registers
	PUSH	EBP
	MOV		EBP, ESP
	PUSHAD

	getInput:
	; Prompt for input
	MOV		EDX, OFFSET inputPrompt
	CALL	WriteString
	
	CALL	ReadInt
	MOV		compositeCount, AX
	CALL	validate

	MOV		AL, isBadInput
	CMP		AL, 1
	JE		getInput

	; Restore registers
	POPAD
	POP		EBP

	RET

	; Description: validate performs data validation on the value input for compositeCount
	;			   If valid, return to calling instruction
	;			   If invalid, display invalid range notification and jump to getInput
	; Receives: n/a (compositeCount global variabel is used)
	; Returns: n/a
	; Pre-Conditions: compositeCount must contain the count of composite numbers the user wants to display
	; Registers Changed: none
	validate PROC
		; Prepare registers
		PUSH	EBP
		MOV		EBP, ESP
		PUSHAD

		; Reset isBadInput
		MOV		AL, 0
		MOV		isBadInput, AL

		MOV		AX, compositeCount
		MOV		BX, MIN_INPUT
		CMP		AX, BX
		JL		retryInput

		MOV		BX, MAX_INPUT
		CMP		AX, BX
		JA		retryInput


		resumeValidate:
		; Restore registers
		POPAD
		POP		EBP

		RET

		retryInput:
			MOV		EDX, OFFSET badInput
			CALL	WriteString
			CALL	CrLf
			MOV		isBadInput, 1
			JMP		resumeValidate

	validate ENDP
getUserData ENDP

; Description: showComposites displays a list of composites numbers of length compositeCount
; Receives: n/a (uses compositeCount)
; Returns: n/a
; Pre-Conditions: compositeCount contains the count of composite numbers to display
; Registers Changed: n/a
showComposites PROC
	; Prepare registers
	PUSH	EBP
	MOV		EBP, ESP
	PUSHAD

	; Start loop
	findComposites:
		MOV		AX, currentNum
		INC		AX
		MOV		currentNum, AX

		; Call isComposite for currentNum
		CALL	isComposite
		
		MOV		AX, totalComposites
		MOV		BX, compositeCount
		CMP		AX, BX
		JL	findComposites

	

	; Restore registers
	POPAD
	POP		EBP

	RET

	; Description: isComposite checks if currentNum is a composite number,
	;			   if it is, the number is printed to output
	;			   otherwise, the procedures ends without displaying any output
	; Receives: n/a (value in currentNum is used)
	; Returns: n/a
	; Pre-Conditions: currentNum contains a value to be evaluated
	; Registers Changed: n/a
	isComposite PROC
		; Prepare registers
		PUSH	EBP
		MOV		EBP, ESP
		PUSHAD

		MOVZX	ECX, currentNum	
		; Decrement ECX
		DEC		ECX
		
		; Start loop
		checkComposite:
		; Print ECX
			MOV		EAX, 1
			CMP		EAX, ECX
			JE		resumeIsComposite

			MOV		AX, currentNum
			CWD

			DIV		CX

			MOV		BX, 0
			
			; Compare EDX to 0
			CMP		DX, BX
			JE		printComposite
			LOOP	checkComposite

		resumeIsComposite:
		; Restore registers
		POPAD
		POP		EBP

		RET

		printComposite:
			MOVZX	EAX, currentNum
			CALL	WriteDec
			MOV		AL, 9
			CALL	WriteChar
			MOV		AX, totalComposites
			INC		AX
			MOV		totalComposites, AX

			; Check for new line
			CWD
			MOV		BX, 10
			DIV		BX
			MOV		BX, 0
			CMP		DX, BX
			JE		newLine

			resumePrinting:
			; Check for new page
			MOV		AX, totalComposites
			CWD
			MOV		BX, LINES_PER_PAGE
			DIV		BX
			MOV		BX, 0
			CMP		DX, BX
			JE		newPage
			

			resumePrintComposite:
			JMP		resumeIsComposite

			newLine:
			CALL	CrLf
			JMP		resumePrinting

			newPage:
			MOV		EDX, OFFSET nextPage
			CALL	WriteString
			CALL	ReadChar
			CALL	Clrscr
			JMP		resumePrintComposite

	isComposite ENDP
showComposites ENDP

; Description: farewell is a procedure to display the closing messages
; Receives: n/a
; Returns: n/a
; Pre-Conditions: n/a
; Registers Changed: n/a
farewell PROC
	; Prepare registers
	PUSH	EBP
	MOV		EBP, ESP
	PUSHAD

	; Say goodbye
	CALL	CrLf
	MOV		EDX, OFFSET certification
	CALL	WriteString
	CALL	CrLf

	; Restore registers
	POPAD
	POP		EBP

	RET
farewell ENDP

END main

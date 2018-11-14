TITLE Programming Assignment 2     (Assignment2_Colin_Van_Overschelde.asm)

; Author: Colin Van Overschelde
; OSU E-mail: vanoverc@oregonstate.edu
; Course: CS 271
; Project ID: Programming Assignment #2
; Due Date: 1/28/2018
; Description: Programming Assignment #2 demonstrates getting string input, designing and implementing counted and post-test loops,
;			   keeping track of a previous value and implementing data validation

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data

	; introduction section strings
	programTitle	BYTE	"Welcome to Fibonacci Numbers", 0
	myName			BYTE	"Programmed by Colin Van Overschelde", 0
	userNamePrompt	BYTE	"What is your name? ", 0
	userGreeting	BYTE	"Hello, ", 0

	; introduction section input variables
	userName		BYTE	25 DUP(0)

	; userInstructions section strings
	instructions1	BYTE	"Enter the number of Fibonacci terms to be displayed", 0
	instructions2	BYTE	"Give the number as an integer in the range [1 .. 46].", 0

	; getUserData section strings
	promptFibCount	BYTE	"How many Fibonacci terms do you want? ", 0
	outOfRange		BYTE	"Out of range.  Enter a number in [1...46]", 0
	
	; getUserData section input variables
	fibCount		DWORD	?

	; displayFibs section strings
	someFibs		BYTE	"Display fibs started...", 0
	spacer			BYTE	"     ", 0

	; displayFibs logical variables
	fib1			DWORD	1
	fib2			DWORD	0
	result			DWORD	?
	iterator		WORD	0

	; farewell section strings
	certified		BYTE	"Results certified by Colin Van Overschelde", 0
	farewellMsg1	BYTE	"Goodbye, ", 0
	farewellMsg2	BYTE	".", 0

.code
main PROC

; (insert executable instructions here)

introduction:
	; Display the program title and programmer’s name. Then get the user’s name, and greet the user.
	mov		EDX, OFFSET programTitle
	call	WriteString
	call	CrLf
	mov		EDX, OFFSET myName
	call	WriteString
	call	CrLf
	call	CrLf

	mov		EDX, OFFSET userNamePrompt
	call	WriteString
	mov		EDX, OFFSET userName
	mov		ECX, SIZEOF	userName
	call	ReadString
	
	mov		EDX, OFFSET userGreeting
	call	WriteString
	mov		EDX, OFFSET userName
	call	WriteString
	call	CrLf
	
userInstructions:
	; Prompt the user to enter the number of Fibonacci terms to be displayed. Advise the user to enter an integer in the range [1 .. 46].
	mov		EDX, OFFSET instructions1
	call	WriteString
	call	CrLf
	mov		EDX, OFFSET instructions2
	call	WriteString
	call	CrLf

getUserData:
	mov		EDX, OFFSET promptFibCount			; Get and validate the user input (n).
	call	WriteString
	
	call	ReadInt
	mov		BX, 47
	movzx	EBX, BX
	cmp		EAX, EBX							; compare fibCount to 47
	JG		getUserData2						; if greater than 47, jump to getUserData2
	mov		BX, 1
	movzx	EBX, BX
	cmp		EAX, EBX							; compare fibCount to 1
	JL		getUserData2						; if less than 1, jump to getUserData2
	mov		fibCount, EAX						; Input is valid, so assign to fibCount
	jmp		displayFibs							; jump to displayFibs

getUserData2:
	; display the invalid input message
	jmp		getUserData							; jump to getUserData

checkNewLine:
	mov		BL, 5					; Compare iterator % 5 to 0
	;movzx	EBX, BX
	mov		AX, iterator
	div		BL
	mov		BL, 0
	;movzx	AH, BX
	cmp		AH, BL
	; if equal, print new line
	JE		printNewLine
	jmp		resumeFibsLoop			; jump to resumeFibsLoop

printNewLine:
	call	CrLf
	jmp		resumeFibsLoop

displayFibs:
	; Calculate and display all of the Fibonacci numbers up to and including the nth term. The results should be
	;		displayed 5 terms per line with at least 5 spaces between terms.
	;mov		EDX, OFFSET someFibs
	;call	WriteString
	mov		ECX, fibCount			; move fibCount to ECX

fibsLoop:
	; Compare iterator to 0
	mov		BX, 0
	;movzx	EBX, BX
	mov		AX, iterator
	cmp		AX, BX
	JG		checkNewLine			; if greater than 0, jump to checkNewLine

resumeFibsLoop:
	mov		EAX, fib1
	add		EAX, fib2				; add fib1 and fib2

	call	WriteDec				; print result
	

	; print spacer
	mov		EDX, OFFSET spacer
	call	WriteString

	mov		EBX, fib2				; move fib2 to fib 1
	mov		fib1, EBX
	mov		fib2, EAX				; move result to fib1
	inc		iterator				; increment iterator
	loop	fibsLoop				; loop displayFibs
	
farewell:
	; Display a parting message that includes the user’s name, and terminate the program.
	call	CrLf				; print new line
	mov		EDX, OFFSET certified
	call	WriteString
	call	CrLf
	mov		EDX, OFFSET farewellMsg1
	call	WriteString
	mov		EDX, OFFSET userName
	call	WriteString
	mov		EDX, OFFSET	farewellMsg2
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main

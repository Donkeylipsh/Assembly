TITLE Assignment #5     (Assignment_5_Colin_Van_Overschelde.asm)

; Author: Colin Van Overschelde
; OSU E-mail: vanoverc@oregonstate.edu
; Course: CS 271
; Project ID: Programming Assignment #5
; Due Date: 3/4/2018
; Description: Assignment 5 demonstrates passing parameters on the stack to procedures and using 
;			   indirect register addressing to fill an array with random numbers, sort the array
;			   in descending order, and calculate the median value

INCLUDE Irvine32.inc

; (insert constant definitions here)
MIN = 10		; Minimum number of random integers to generate
MAX = 200		; Maximum number of random integers to generate
LO = 100		; Lo-est value of random integer
HI = 999		; Hi-est value of random integer

.data

; intro variables
intro1	byte	"Sorting Random Integers", 0
intro2	byte	"Programmed by Colin Van Overschelde", 0
intro3	byte	"This program generates random numbers in the range [100 .. 999],", 0
intro4	byte	"displays the original list, sorts the list, and calculates the", 0
intro5	byte	"median value.  Finally it displays the list sorted in descending order.", 0

; getData variables
getData1		byte	"getData called...", 0
getNums			byte	"How many numbers should be generated? [10 .. 200]: ", 0
invalidNums		byte	"Invalid input", 0
request			dword	?

; fillArray strings
numArray		dword	MAX	DUP(?)
fillArray1		byte	"fillArray called...", 0

; displayList strings
unsortedNums	byte	"The unsorted random numbers:", 0
displayList1	byte	"displayList called...", 0

; sortList strings
sortedNums		byte	"The sorted list:", 0

; displayMedian strings
displayMedian1		byte	"displayMedian called...", 0
medianValueText		byte	"Median value: ", 0

; farewell strings
farewell1	byte	"Thank you for using 'Sorting Random Integers', goodbye", 0

.code
; ************************************************************************************
; Procedure: main
; Description: Calls the procedures necessary to fill an array with random integers, sort the array and calculate the median value
; Receives: n/a
; Returns: n/a
; Pre-Conditions: n/a
; Registers Changed: n/a
; ************************************************************************************
main PROC
	; Display introduction text
	call	intro
	
	; Get number of random integers to generate from user
	push	OFFSET request
	call	getData

	; Number of integers to generate is now stored in request

	; Initialize starting seed value for random integers
	call	Randomize

	; Fill array with random integers
	push	OFFSET numArray
	mov		EAX, request
	push	EAX		; Value of request
	call	fillArray

	; Array is now filled with random integers between 100 and 999

	; Display the unsorted array of random integers
	mov		EDX, OFFSET unsortedNums
	call	WriteString
	call	CrLf
	push	OFFSET numArray
	mov		EAX, request
	push	EAX		; Value of request
	call	displayList

	; Sort the list of random integers in descending order
	push	OFFSET numArray
	mov		EAX, request
	push	EAX
	call	sortList

	; Display the median value of the random integers
	push	OFFSET numArray
	mov		EAX, request
	push	EAX
	call	displayMedian

	; Display the sorted array of random integers
	mov		EDX, OFFSET sortedNums
	call	WriteString
	call	CrLf
	push	OFFSET numArray
	mov		EAX, request
	push	EAX		; Value of request
	call	displayList

	; Display farewell text
	call	farewell

	exit	; exit to operating system
main ENDP

; ************************************************************************************
; Procedure: intro
; Description: Display the welcome text for the program
; Receives: n/a
; Returns: n/a
; Pre-Conditions: n/a
; Registers Changed: none
; ************************************************************************************
intro PROC
	; Prepare registers
	PUSH	EBP
	MOV		EBP, ESP
	PUSHAD

	; Display introduction text
	mov		EDX, OFFSET intro1
	call	WriteString
	
	; Insert tab spacers to format output
	mov		al, 9
	mov		ECX, 4
	tabs:
		call	WriteChar
		loop	tabs

	; Continue displaying introduction text
	mov		EDX, OFFSET intro2
	call	WriteString
	call	CrLf
	call	CrLf

	mov		EDX, OFFSET intro3
	call	WriteString
	call	CrLf

	mov		EDX, OFFSET intro4
	call	WriteString
	call	CrLf

	mov		EDX, OFFSET intro5
	call	WriteString
	call	CrLf
	call	CrLf

	; Restore registers
	POPAD
	POP		EBP

	ret
intro ENDP

; ************************************************************************************
; Procedure: getData
; Description: Prompts the user for the count of random integers to generate, with data validation
; Receives: n/a
; Returns: The number of integer values to generate, which is stored in request
; Pre-Conditions: Offset of request is the first parameter on stack
; Registers Changed: n/a
; ************************************************************************************
getData PROC
	; Prepare registers
	PUSH	EBP
	MOV		EBP, ESP
	PUSH	EAX
	PUSH	EDX
	PUSH	ESI

	startInput:
		mov		EDX, OFFSET getNums
		call	WriteString
		call	ReadInt
		cmp		EAX, MIN
		JL		badInput
		cmp		EAX, MAX
		JG		badInput
		JMP		goodInput

	badInput:
		; Display invalid input
		MOV		EDX, OFFSET invalidNums
		CALL	WriteString
		CALL	CrLf
		JMP		startInput

	goodInput:
		mov		ESI, [EBP + 8]
		mov		[ESI], EAX

	; Restore registers
	POP		ESI
	POP		EDX
	POP		EAX
	POP		EBP
	ret		4
getData ENDP

; ************************************************************************************
; Procedure: fillArray
; Description: Populates an array with random integers
; Receives: The 32-bit value stored in request [EBP + 8], the Offset of numArray [EBP + 12]
; Returns: numArray populated with a number of random integers equal to request
; Pre-Conditions: n/a
; Registers Changed: none
; ************************************************************************************
fillArray PROC
	; Prepare registers
	PUSH	EBP
	MOV		EBP, ESP
	PUSHAD

	; Move stack parameters to registers
	mov		ESI, [EBP + 12]		; Offset of numArray
	mov		ECX, [EBP + 8]		; Value of request

	; Fill array with random integers
	; Skip filling array if request <= 0
	cmp		ECX, 0
	JLE		finished
	; Start filling array
	numLoop:
		; Prepare EAX for RandomRange, EAX value of 900 returns range = 0 - 899
		MOV		EAX, HI
		SUB		EAX, LO
		INC		EAX
		CALL	RandomRange
		; Add LO to random value to return a value in the range = 100 - 999, i.e. LO to HI
		ADD		EAX, LO
		; Move the new value into the array
		MOV		[ESI], EAX
		; Move ESI to point to next index in array
		ADD		ESI, 4
		LOOP	numLoop

	finished:
	call	CrLf

	POPAD
	POP		EBP
	ret		8
fillArray ENDP

; ************************************************************************************
; Procedure: sortList
; Description: Sorts an array parameter in descending order
; Receives: [EBP + 8] = Value of request, [EBP + 12] = Offset of numArray, an array of 32-bit integers
; Returns: numArray sorted in descending order
; Pre-Conditions: n/a
; Registers Changed: none
; ************************************************************************************
sortList PROC
	; Prepare registers
	PUSH	EBP
	MOV		EBP, ESP
	PUSHAD

	; Get parameters
	MOV		ESI, [EBP + 12]
	MOV		ECX, [EBP + 8]

	; Start sortLoop
	sortLoop:
		; LARGEST_INDEX to the address stored in ESI
		MOV		EDI, ESI

		PUSH	ECX
		PUSH	ESI
		
		; Start compareLoop
		compareLoop:
			MOV		EAX, [EDI]
			MOV		EBX, [ESI]
			CMP		EAX, EBX
			JL		newLargest
			JMP		resumeCompare

			newLargest:
				MOV		EDI, ESI

			resumeCompare:
				ADD		ESI, 4
				LOOP	compareLoop

		; Resume outer Loop
		; Restore initial ESI value
		POP		ESI
		; Swap value in ESI with value in EDI, EDI contains the largest value of the unsorted array
		MOV		EAX, [EDI]
		MOV		EBX, [ESI]
		MOV		[ESI], EAX
		MOV		[EDI], EBX

		; Move to the next element in the array
		ADD		ESI, 4

		; Restore ECX for sortLoop
		POP		ECX
		LOOP	sortLoop 

	call	CrLf

	POPAD
	POP		EBP
	ret		8
sortList ENDP

; ************************************************************************************
; Procedure: displayMedian
; Description: Calculates the median value of an array parameter
; Receives: [EBP + 8] = value of request (size of array), [EBP + 12] = offset of numArray
; Returns: n/a
; Pre-Conditions: Array is already sorted using sortList procedure
; Registers Changed: none
; ************************************************************************************
displayMedian PROC
	; Prepare registers
	PUSH	EBP
	MOV		EBP, ESP
	PUSHAD

	; Get parameters
	MOV		ESI, [EBP + 12]		; numArray
	MOV		EAX, [EBP + 8]		; request

	; Check if request is even
	MOV		DX, 0
	MOV		BX, 2
	DIV		BX
	CMP		DX, 0
	JE		evenMedian		; If yes, just to evenMedian
	; If not calculate median index
	MOV		EBX, SIZEOF DWORD
	MOVZX	EAX, AX
	MUL		EBX
	MOV		EAX, [ESI + EAX]
	JMP		printMedian
	
	evenMedian:
		; If request = even, median is the average of the two middle values
		MOV		EBX, SIZEOF DWORD
		DEC		EAX
		MOVZX	EAX, AX
		MUL		EBX
		MOV		EBX, [ESI + EAX]
		ADD		EAX, 4
		MOV		EAX, [ESI + EAX]
		ADD		EAX, EBX
		MOV		DX, 0
		MOV		BX, 2
		DIV		BX
		MOVZX	EAX, AX

	printMedian:
		; Display median value
		MOV		EDX, OFFSET medianValueText
		CALL	WriteString
		CALL	WriteDec

	; Add display formatting
	call	CrLf
	call	CrLf

	; Restore registers
	POPAD
	POP		EBP
	ret		8
displayMedian ENDP

; ************************************************************************************
; Procedure: displayList
; Description: Displays the values of an array parameter, 10 values per line
; Receives: [EBP + 8] = value of request, [EBP + 12] = offset of numArray
; Returns: n/a
; Pre-Conditions: n/a
; Registers Changed: none
; ************************************************************************************
displayList PROC
	; Prepare Registers
	PUSH	EBP
	MOV		EBP, ESP
	PUSHAD

	; Retrieve parameters
	MOV		ECX, [EBP + 8]
	MOV		ESI, [EBP + 12]

	CMP		ECX, 0
	JLE		finishDisplay
	printLoop:
		; Print next value in array
		MOV		EAX, [ESI]
		CALL	WriteDec
		MOV		AL, 9
		CALL	WriteChar

		; Check for new line
		MOV		EAX, [EBP + 8]
		SUB		EAX, ECX
		INC		EAX
		CWD
		MOV		BX, 10
		DIV		BX
		MOV		BX, 0
		CMP		BX, DX
		JE		printNewLine

	resumePrint:
		ADD		ESI, 4
		LOOP	printLoop
		JMP		finishDisplay

	printNewLine:
		CALL	CrLf
		JMP		resumePrint

	finishDisplay:

	call	CrLf
	
	; Restore registers
	POPAD
	POP		EBP
	ret		8
displayList ENDP

; ************************************************************************************
; Procedure: farewell
; Description: Displays the goodbye message to the user
; Receives: n/a
; Returns: n/a
; Pre-Conditions: n/a
; Registers Changed: none
; ************************************************************************************
farewell PROC
	; Display farewell message
	call	CrLf
	mov		EDX, OFFSET farewell1
	call	WriteString
	call	CrLf

	ret
farewell ENDP
END main

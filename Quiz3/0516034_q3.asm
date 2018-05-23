;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; National Chiao Tung University
; Department Of Computer Science
; 
; Assembly Programming Tests
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Write programs in the Release mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; $Student Name: ·¨µ¾¶v
; $Student ID: 0516034
; $Student Email: eugene87222@gmail.com
;
; Instructor Name: Sai-Keung Wong 
;
TITLE 

include Irvine32.inc
include Macros.inc

.data
X_dir		BYTE			?
Y_dir		BYTE			?
X			BYTE			?
Y			BYTE			?
LEN		DWORD	20
WID		DWORD	60

UP_ROW			BYTE		1
LEFT_COL			BYTE		1
DOWN_ROW	BYTE		18
RIGHT_COL		BYTE		58
TARGET			BYTE		?
DIR		DWORD	?  ; 0 for horizontal, 1 for vertical
HIDE		DWORD	0

.code
main PROC
L0:
	call ShowMenu
look4inputoption:
	mov eax, 50
	call Delay
	call ReadKey
	jz look4inputoption
	.IF al == 49
		call WriteChar
		call Opt1
	.ELSEIF al == 50
		call WriteChar
		call Opt2
		jmp Bye
	.ELSE
		mWriteLn "Invalid"
		jmp look4inputoption
	.ENDIF
	jmp L0
Bye:
	exit
main ENDP

ClearBG PROC
	call Clrscr
	ret
ClearBG ENDP

ShowMenu PROC
	mWriteLn "1) Floating point calculation"
	mWriteLn "2) Simple control"
	call Crlf
	mWriteLn "Please select an option......"
	ret
ShowMenu ENDP

Opt1 PROC
	call ClearBG
	mWriteLn "Please input three floating point numbers."
	finit
	mWrite "Enter a: "
	call ReadFloat
	mWrite "Enter b: "
	call ReadFloat
	mWrite "Enter c: "
	call ReadFloat
	fmul ST(0), ST(1)
	fadd ST(0), ST(2)
	mWrite "a + b * c = "
	call WriteFloat
	call Crlf
	mWrite "press any key to go back to the menu......"
look4anykey:	
	mov eax, 50
	call Delay
	call ReadKey
	jz look4anykey
	ret
Opt1 ENDP

Opt2 PROC
	mov eax, gray*16
	call SetTextColor
	call ClearBG
	mov eax, lightblue*16
	call SetTextColor
	call DrawOneFrame
Draw:
	call DrawBitmap
look4key:
	mov eax, 50
	call Delay
	call ReadKey
	.IF al == 'r'
		mov UP_ROW, 1
		mov LEFT_COL, 1
		mov DOWN_ROW, 18
		mov RIGHT_COL, 58
		jmp Draw
	.ELSEIF al == 'w'
		mov al, UP_ROW
		mov TARGET, al
		mov DIR, 0
		call ClearLine
		.IF UP_ROW < 18
			inc UP_ROW
		.ENDIF
	.ELSEIF al == 's'
		mov al, DOWN_ROW
		mov TARGET, al
		mov DIR, 0
		call ClearLine
		.IF DOWN_ROW > 1
			dec DOWN_ROW
		.ENDIF
	.ELSEIF al == 'a'
		mov al, LEFT_COL
		mov TARGET, al
		mov DIR, 1
		call ClearLine
		.IF LEFT_COL < 58
			inc LEFT_COL
		.ENDIF
	.ELSEIF al == 'd'
		mov al, RIGHT_COL
		mov TARGET, al
		mov DIR, 1
		call ClearLine
		.IF RIGHT_COL > 1
			dec RIGHT_COL
		.ENDIF
	.ELSEIF al == 'f'
		.IF HIDE == 0
			mov HIDE, 1
			mov eax, gray*16
			call SetTextColor
		.ELSE
			mov HIDE, 0
			mov eax, lightblue*16
			call SetTextColor
		.ENDIF
		call DrawOneFrame
	.ELSEIF al == 'q'
		mov eax, black*16+lightgray
		call SetTextColor
		call ClearBG
		mWriteLn "Student ID: 0516034"
		mWriteLn "Student name: ·¨µ¾¶v"
		mWriteLn "press any key to exit......"
look4anykey:
		mov eax, 50
		call Delay
		call ReadKey
		jz look4anykey
		jmp Bye
	.ENDIF
	jmp look4key
Bye:
	ret
Opt2 ENDP

DrawOneFrame PROC
	call InitCoor
	call DrawVertical_LEFT
	call DrawHorizontal_BOTTOM
	call DrawVertical_RIGHT
	call DrawHorizontal_TOP
	mov eax, lightgray
	call SetTextColor
	ret
DrawOneFrame ENDP

InitCoor PROC
	mov X, 0
	mov Y, 0
	ret
InitCoor ENDP

DrawHorizontal_TOP PROC
	mov ecx, WID
	mov X_dir, -1
	mov Y_dir, 0
	call DrawOneLine
	ret
DrawHorizontal_TOP ENDP

DrawHorizontal_BOTTOM PROC
	mov ecx, WID
	mov X_dir, 1
	mov Y_dir, 0
	call DrawOneLine
	ret
DrawHorizontal_BOTTOM ENDP

DrawVertical_LEFT PROC
	mov ecx, LEN
	mov X_dir, 0
	mov Y_dir, 1
	call DrawOneLine
	ret
DrawVertical_LEFT ENDP

DrawVertical_RIGHT PROC
	mov ecx, LEN
	mov X_dir, 0
	mov Y_dir, -1
	call DrawOneLine
	ret
DrawVertical_RIGHT ENDP

DrawOneLine PROC
	mov dl, X
	mov dh, Y
L0:
	call GotoXY
	mov al, ' '
	call WriteChar
	add dl, X_dir
	add dh, Y_dir
	loop L0
	sub dl, X_dir
	sub dh, Y_dir
	mov X, dl
	mov Y, dh
	call GotoXY
	ret
DrawOneLine ENDP

GetColor PROC
ReRandom:
	call Random32
	shr eax, 28
	.IF eax == 8
		jmp ReRandom
	.ENDIF
	shl eax, 4
	call SetTextColor
	ret
GetColor ENDP

DrawBitmap PROC
	call Randomize
	mov dh, 0
	mov ecx, 18
L0:
	inc dh
	mov dl, 1
	mov esi, 0
L1:
	call GetColor
	call GotoXY
	mov al, ' '
	call WriteChar
	inc dl
	inc esi
	cmp esi, 58
	jl L1
	loop L0
	ret
DrawBitmap ENDP

ClearLine PROC
	mov eax, gray*16
	call SetTextColor
	.IF DIR == 0
		mov dl, 1
		mov dh, TARGET
		mov ecx, 58
L0:
		call GotoXY
		mov al, ' '
		call WriteChar
		inc dl
		loop L0
	.ELSEIF DIR == 1
		mov dl, TARGET
		mov dh, 1
		mov ecx, 18
L1:
		call GotoXY
		mov al, ' '
		call WriteChar
		inc dh
		loop L1
	.ENDIF
	ret
ClearLine ENDP

END main
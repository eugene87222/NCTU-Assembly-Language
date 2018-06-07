; Name: Yang Hsiang Chun
; Student ID: 0516034
; Email: eugene87222@gmail.com
TITLE

include Irvine32.inc
include Macros.inc

.data
	; menu
	OP1		BYTE			"1"
	OP2		BYTE			"2"
	OP3		BYTE			"3"
	OP4		BYTE			"4"
	OP5		BYTE			"5"
	OP6		BYTE			"6"

	; option 1
	LU_X		BYTE			?
	LU_Y		BYTE			?
	LB_X		BYTE			?
	LB_Y		BYTE			?
	RU_X	BYTE			?
	RU_Y 	BYTE			?
	LEN		DWORD	?
	WID		DWORD	?
	COLOR	BYTE			black

	; option 4
	X					REAL8		?
	var				REAL8		?
	N					DWORD	?
	Float_Zero		REAL8		0.0
	Res				REAL8		?
	Ng				DWORD	-1
	Num				DWORD	0
	twopi			REAL8		6.2831853
	tmp				REAL8		?

.code

; main function
main PROC
begin:
	call show_menu
look4input:
	mov eax, 50
	call Delay
	call ReadKey
	jz look4input

	call WriteChar
	call Crlf

	.IF al == OP1
		call show_colorful_frame

	.ELSEIF al == OP2
		call sum_of_signed_int

	.ELSEIF al == OP3
		call sum_of_unsigned_int

	.ELSEIF al == OP4
		call compute_sin

	.ELSEIF al == OP5
		call show_student_info

	.ELSEIF al == OP6
		jmp the_end

	.ENDIF
	mWriteLn "Press any key to go back to the menu"

input_sth:
	mov eax, 50
	call Delay
	call Readkey
	jz input_sth

	jmp begin

the_end:
	mWriteLn "goodbye~"
	mov eax, 1000
	call Delay
	exit
main ENDP

; show menu
show_menu PROC
	mWriteLn "1) Show colorful frames"
	mWriteLn "2) Sum up signed integers"
	mWriteLn "3) Sum up unsigned integers"
	mWriteLn "4) Compute sin(x)"
	mWriteLn "5) Show student information"
	mWriteLn "6) Quit"
	ret
show_menu ENDP

; Option 1
; show colorful frame
show_colorful_frame PROC
	call ClearBG
	
	call InitCoor

	mov edi, 0
draw:
	;call Randomize
re_random:
	call Random32
	shr eax, 28
	cmp al, black
	je re_random
	cmp al, COLOR
	je re_random

	mov COLOR, al

	shl eax, 4
	call SetTextColor
	
	mov ecx, LEN
	mov dl, LU_X
	mov dh, LU_Y
	call DrawHorizontal_TOP

	mov ecx, LEN
	mov dl, LB_X
	mov dh, LB_Y
	call DrawHorizontal_BOTTOM
	mov dl, LB_X
	mov dh, LB_Y
	inc dl
	dec dh
	mov LB_X, dl
	mov LB_Y, dh
	
	sub LEN, 2

	mov ecx, WID
	mov dl, LU_X
	mov dh, LU_Y
	call DrawVertical_LEFT
	mov dl, LU_X
	mov dh, LU_Y
	inc dl
	inc dh
	mov LU_X, dl
	mov LU_Y, dh
	
	mov ecx, WID
	mov dl, RU_X
	mov dh, RU_Y
	call DrawVertical_RIGHT
	mov dl, RU_X
	mov dh, RU_Y
	dec dl
	inc dh
	mov RU_X, dl
	mov RU_Y, dh

	sub WID, 2
	
	mov eax, 500
	call Delay

	inc edi
	cmp edi, 10
	jl draw

	mov eax, lightgray
	call SetTextColor

	mov dl, 0
	mov dh, 24
	call GotoXY
	call Crlf
	ret
show_colorful_frame ENDP

ClearBG PROC
	call Clrscr
	ret
ClearBG ENDP

InitCoor PROC
	mov LU_X, 1
	mov LU_Y, 1
	mov LB_X, 1
	mov LB_Y, 23
	mov RU_X, 55
	mov RU_Y, 1
	mov LEN, 55
	mov WID, 23
	ret
InitCoor ENDP

DrawHorizontal_TOP PROC
	call DrawHorizontal
	ret
DrawHorizontal_TOP ENDP

DrawHorizontal_BOTTOM PROC
	call DrawHorizontal
	ret
DrawHorizontal_BOTTOM ENDP

DrawHorizontal PROC
L0:
	call GotoXY
	mov al, ' '
	call WriteChar
	inc dl
	loop L0
	ret
DrawHorizontal ENDP

DrawVertical_LEFT PROC
	call DrawVertical
	ret
DrawVertical_LEFT ENDP

DrawVertical_RIGHT PROC
	call DrawVertical
	ret
DrawVertical_RIGHT ENDP

DrawVertical PROC
L0:
	call GotoXY
	mov al, ' '
	call WriteChar
	inc dh
	loop L0
	ret
DrawVertical ENDP

; Option 2
; sum of signed integers
sum_of_signed_int PROC
begin:
	mWrite "Input the number of signed integers: "
	call ReadInt

	cmp eax, 0
	je the_end
	jnl good_input

	mWriteLn "Input cannot smaller than 0"
	jmp begin

good_input:
	mWrite "Please input "
	call WriteDec
	mWriteLn " signed integers (each in one line)"

	mov ecx, eax
	mov edi, 0
	mov edx, 0

read:
	call ReadInt
	jo read
	add edx, eax
	inc edi
	loop read

	mWrite "Sum: "
	mov eax, edx
	call WriteInt
	call Crlf
the_end:
	ret
sum_of_signed_int ENDP

; Option 3
; sum of unsigned integers
sum_of_unsigned_int PROC
begin:
	mWrite "Input the number of unsigned integers: "
	call ReadInt

	cmp eax, 0
	je the_end
	jnl good_input

	mWriteLn "Input cannot smaller than 0"
	jmp begin

good_input:
	mWrite "Please input "
	call WriteDec
	mWriteLn " unsigned integers (each in one line)"

	mov ecx, eax
	mov edi, 0
	mov edx, 0

read:
	call ReadInt
	jo read
	cmp eax, 0
	jge valid

	mWriteLn "Invalid input"
	jmp read

valid:
	add edx, eax
	inc edi
	loop read

	mWrite "Sum: "
	mov eax, edx
	call WriteDec
	call Crlf

the_end:
	ret
sum_of_unsigned_int ENDP

; Option 4
; compute sin(x)
compute_sin PROC
	mWrite "Input a floating number x: "

	finit
	call ReadFloat
	fst X
	fld twopi
L0:
	fcomi ST(0), ST(1)
	jnc CheckNeg
	fsub ST(1), ST(0)
	jmp L0

CheckNeg:
	fstp tmp
	fld twopi
	fchs
L1:
	fcomi ST(0), ST(1)
	jc ReadN
	fsub ST(1), ST(0)
	jmp L1
	
ReadN:
	fstp var
	fstp var
	mWrite "Input the number of terms: "
	call ReadInt

	cmp eax, 1
	jnl good_input

	mWriteLn "Input cannot smaller than 1"
	jmp ReadN

good_input:
	mov N, eax
	finit
	fld Float_Zero
	fld var
	fld var

	mov ecx, N
	mov eax, 1
	mov edi, 1

Taylor:
	fadd ST(2), ST(0)
	
	fmul ST(0), ST(1)
	fmul ST(0), ST(1)
	
	inc edi
	mov Num, edi
	fidiv Num

	inc edi
	mov Num, edi
	fidiv Num

	fchs

	loop Taylor

	fstp Res
	fstp Res
	fstp Res

	finit
	fld X
	mWrite "Calculate sin( "
	call WriteFloat
	mWrite " ) using the first "
	mov eax, N
	call WriteDec
	mWrite " terms: "
	finit
	fld Res
	call WriteFloat
	call Crlf

	ret
compute_sin ENDP

; Option 5
; show_student_info
show_student_info PROC
	mWriteLn "ID: 0516034"
	mWriteLn "Name: ·¨µ¾¶v"
	mWriteLn "Email: eugene87222@gmail.com"
	ret
show_student_info ENDP

END main
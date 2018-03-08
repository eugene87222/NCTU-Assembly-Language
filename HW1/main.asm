TITLE

include Irvine32.inc
include Macros.inc

.data
	OP1		BYTE			"1"
	OP2		BYTE			"2"
	OP3		BYTE			"3"
	OP4		BYTE			"4"
	OP5		BYTE			"5"
	OP6		BYTE			"6"

	COLOR	DWORD	?

	X			REAL8		?
	N			DWORD	?
	Res		REAL8		0.0
	Ng		DWORD	-1
	Num		DWORD	?

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
	call Random32
	shr eax, 24
	call SetTextColor
	ret
show_colorful_frame ENDP

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
again:
	call ReadInt
	
	cmp eax, 0
	jge valid

	mWriteLn "Invalid input"
	jmp again

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

ReadN:
	mWrite "Input the number of terms: "
	call ReadInt

	cmp eax, 1
	jnl good_input

	mWriteLn "Input cannot smaller than 1"
	jmp ReadN

good_input:
	mov N, eax
	finit
	fld Res
	fld X
	fld X

	mov ecx, N
	mov eax, 1
	mov edi, 1

Taylor:
	fadd ST(2), ST(0)
	
	fmul ST(0), ST(1)
	fmul ST(0), ST(1)

	inc edi
	imul edi
	mov Num, edi
	fidiv Num

	inc edi
	imul edi
	mov Num, edi
	fidiv Num

	fidiv Ng

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
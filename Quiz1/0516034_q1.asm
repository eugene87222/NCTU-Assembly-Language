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
	LEN			DWORD		?

	X_dir		BYTE		?
	Y_dir		BYTE		?
	X			BYTE		?
	Y			BYTE		?
	WID			DWORD		?
	HEIGHT		DWORD		?
	DelayTime	DWORD		?

	N			DWORD	?
	M			DWORD	?
	TWO		DWORD	2
	ONE		SDWORD	-1

	SCR_WID				BYTE		?
	HALF_SCR_WID		BYTE		?
	newX		BYTE		?
	newY		BYTE		?
	oldX			BYTE		?
	oldY			BYTE		?

	S0			REAL8		1.0
	S1			REAL8		3.5
	Tmp1	REAL8		?
	Tmp2	REAL8		?
	Res		REAL8		?

.code
main PROC
begin:
	call Clrscr
	mov eax, blue*16+white
	call SetTextColor
	mov X, 0
	mov Y, 0
	mov LEN, 50
	mov ecx, 15
L0:
	mov ebx, ecx
	call DrawOneLine
	mov X, 0
	inc Y
	mov ecx, ebx
	loop L0
	mov DelayTime, 0
	call DrawOneFrame
	call ShowMenu
SelectOption:
	mov eax, 50
	call Delay
	call ReadKey
	jz SelectOption
	call WriteChar
	call Crlf
	.IF al == '1'
		call Option1
		jmp begin
	.ELSEIF al == '2'
		call Option2
		jmp begin
	.ELSEIF al == '3'
		call Option3
		jmp begin
	.ELSEIF al == '4'
		call Option4
		jmp begin
	.ELSEIF al == '5'
		call Option5
		jmp the_end
	.ELSE
		jmp SelectOption
	.ENDIF
	call ReadInt
the_end:
	exit
main ENDP

DrawOneLine PROC
	mov ecx, LEN
	mov dl, X
	mov dh, Y
L0:
	call GotoXY
	mov al, ' '
	call WriteChar
	inc dl
	loop L0
	ret
DrawOneLine ENDP

DrawOneFrame PROC
	mov X, 0
	mov Y, 0
	mov WID, 50
	mov HEIGHT, 15
	mov eax, lightgreen*16
	call SetTextColor
	mov X_dir, 1
	mov Y_dir, 0
	call DrawHorizontal
	mov X_dir, 0
	mov Y_dir, 1
	call DrawVertical
	mov X_dir, -1
	mov Y_dir, 0
	call DrawHorizontal
	mov X_dir, 0
	mov Y_dir, -1
	call DrawVertical
	mov eax, black*16+lightgray
	call SetTextColor
	ret
DrawOneFrame ENDP

DrawHorizontal PROC
	mov dl, X
	mov dh, Y
	mov ecx, WID
L0:
	call GotoXY
	mov al, ' '
	call WriteChar
	add dl, X_dir
	add dh, Y_dir
	mov eax, DelayTime
	call Delay
	loop L0
	sub dl, X_dir
	sub dh, Y_dir
	mov X, dl
	mov Y, dh
	ret
DrawHorizontal ENDP

DrawVertical PROC
	mov dl, X
	mov dh, Y
	mov ecx, HEIGHT
L0:
	call GotoXY
	mov al, ' '
	call WriteChar
	add dl, X_dir
	add dh, Y_dir
	mov eax, DelayTime
	call Delay
	loop L0
	sub dl, X_dir
	sub dh, Y_dir
	mov X, dl
	mov Y, dh
	ret
DrawVertical ENDP

ShowMenu PROC
	mov eax, blue*16+white
	call SetTextColor
	mov dl, 2
	mov dh, 2
	call GotoXY
	mWriteLn "My student ID is: 0516034"
	inc dh
	call GotoXY
	mWriteLn "Please select one of the option"
	inc dh
	call GotoXY
	mWriteLn "1. Compute (2+4+6+...+2n)/m"
	inc dh
	call GotoXY
	mWriteLn "2. Compute (2-4+6-...+(-1)^(n+1) 2n)*m"
	inc dh
	call GotoXY
	mWriteLn "3. Compute S(n)."
	inc dh
	mov dl, 5
	call GotoXY
	mWriteLn "Define S(n) = S(n-1) + S(n-2), n>=2."
	inc dh
	mov dl, 6
	call GotoXY
	mWriteLn "S(0) = 1, S(1) = 3.5."
	inc dh
	mov dl, 2
	call GotoXY
	mWriteLn "4. Animate a character to move horizontally"
	inc dh
	call GotoXY
	mWriteLn "5. Quit the program"
	inc dh
	call GotoXY
	mWriteLn "Please select and option......"
	inc dh
	call GotoXY
	mov eax, black*16+lightgray
	call SetTextColor
	ret
ShowMenu ENDP

Option1 PROC
	call Clrscr
begin:
	mWriteLn "1. Compute ( 2+4+6+...+2n )/m"
	mWrite "Input n [0, 100]: "
inputn:
	call ReadInt
	jo inputn
	jns check100
	mWriteLn "Input is out of range, please input again"
	jmp inputn
check100:
	cmp eax, 100
	jle okay
	mWriteLn "Input is out of range, please input again"
	jmp inputn
okay:
	mov N, eax
	mWrite "Input m (non-zero, signed integer): "
inputm:
	call ReadInt
	jo inputm
	jnz good
	mWriteLn "m cannot be zero, please input again"
	jmp inputm
good:
	mov M, eax
	cmp N, 0
	je GoBack
	mov ebx, 0
	mov edi, 1
	mov ecx, N
L1:
	mov eax, edi
	mul TWO
	add ebx, eax
	inc edi
	loop L1
	mov eax, ebx
	idiv M
	mWrite "Quotient: "
	call WriteInt
	mov eax, edx
	call Crlf
	mWrite "Remainder: "
	call WriteInt
	call Crlf
	call Crlf
	jmp begin
GoBack:
	mov eax, black*16+lightgray
	call SetTextColor
	ret
Option1 ENDP

Option2 PROC
	call Clrscr
begin:
	mWriteLn "2. Compute ( 2-4+6-...+(-1)^(n+1) 2n )*m"
	mWrite "Input n [0, 50]: "
inputn:
	call ReadInt
	jo inputn
	jns check50
	mWriteLn "Input is out of range, please input again"
	jmp inputn
check50:
	cmp eax, 50
	jle okay
	mWriteLn "Input is out of range, please input again"
	jmp inputn
okay:
	mov N, eax
	mWrite "Input m (non-zero, signed integer): "
inputm:
	call ReadInt
	jo inputm
	jnz good
	mWriteLn "m cannot be zero, please input again"
	jmp inputm
good:
	mov M, eax
	cmp N, 0
	je GoBack
	mov ebx, 0
	mov edi, 1
	mov ecx, N
L1:
	mov eax, edi
	mul TWO
	neg ONE
	mul ONE
	add ebx, eax
	inc edi
	loop L1
	mov eax, ebx
	imul M
	mWrite "Result: "
	call WriteInt
	call Crlf
	call Crlf
	jmp begin
GoBack:
	mov eax, black*16+lightgray
	call SetTextColor
	ret
Option2 ENDP

Option3 PROC
	call Clrscr
begin:
	mWriteLn "3. Compute S(n)."
	mWriteLn "    Define S(n) = S(n-1) + S(n-2), n>=2."
	mWriteLn "    S(0) = 1.0, S(1) = 3.5"
	mWrite "Please input n: "
inputn:
	call ReadInt
	jo inputn
	jns good
	mWriteLn "n cannot be negative, please input again"
	jmp inputn
good:
	jz TheEnd
	mov N, eax
	cmp eax, 1
	jg calculate
	mWriteLn "S(1) = 3.5"
	call Crlf
	jmp begin
calculate:
	finit
	fld S0
	fld S1
	mov ecx, N
	dec ecx
L0:
	fadd ST(1), ST(0)
	fstp Tmp1
	fstp Tmp2
	fld Tmp1
	fld Tmp2
	loop L0
	fst Res
	mov eax, N
	mWrite "S("
	call WriteDec
	mWrite ") is "
	finit
	fld Res
	call WriteFloat
	call Crlf
	call Crlf
	jmp begin
TheEnd:
	ret
Option3 ENDP

Option4 PROC
	mov eax, blue*16+white
	call SetTextColor
	call Clrscr
	call GetMaxXY
	mov SCR_WID, dl
	movzx eax, dl
	mov dl, 2
	div dl
	mov HALF_SCR_WID, al
	mov newX, al
	mov newY, 12
	call Show
ToRight:
	call SavePos
	inc newX
	mov al, SCR_WID
	cmp newX, al
	jge ToBound
	call Clean
	call Show
	mov eax, 100
	call Delay
	jmp ToRight
ToBound:
	dec newX
ToLeft:
	call SavePos
	dec newX
	cmp newX, 0
	jl TheEnd
	call Clean
	call Show
	mov eax, 100
	call Delay
	jmp ToLeft
TheEnd:
	mov eax, black*16+lightgray
	call SetTextColor
	ret
Option4 ENDP

SavePos PROC
	mov al, newX
	mov oldX, al
	mov al, newY
	mov oldY, al
	ret
SavePos ENDP

Clean PROC
	mov eax, blue*16
	call SetTextColor
	mov dl, oldX
	mov dh, oldY
	call GotoXY
	mov al, ' '
	call WriteChar
	call GotoXY
	ret
Clean ENDP

Show PROC
	mov eax, white*16
	call SetTextColor
	mov dl, newX
	mov dh, newY
	call GotoXY
	mov al, ' '
	call WriteChar
	call GotoXY
	ret
Show ENDP

Option5 PROC
	call Clrscr
	mWriteLn "Thanks for playing this system."
	mWriteLn "This program is written by"
	mWriteLn "    Name: ·¨µ¾¶v"
	mWriteLn "    ID: 0516034"
	mWriteLn "I am learning assembly programming."
	mWriteLn "Please contact me at eugene87222@gmail.com"
	call Crlf
	mWrite "Press any key to exit"
input_sth:
	mov eax, 50
	call Delay
	call Readkey
	jz input_sth
	ret
Option5 ENDP

END main
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
MYBITMAP_WIDTH	DWORD	5
MYBITMAP_HEIGHT	DWORD	3
MYBITMAP1		BYTE		1, 1, 0, 1, 1
						BYTE		0, 0, 1, 0, 0
						BYTE		1, 1, 0, 1, 1
MYBITMAP2		BYTE		1, 1, 1, 1, 1
						BYTE		0, 1, 0, 1, 0
						BYTE		1, 1, 1, 1, 1 
X_dir		BYTE			?
Y_dir		BYTE			?
X			BYTE			?
Y			BYTE			?
LEN		DWORD	20
WID		DWORD	60
BitmapPosX			BYTE		1
BitmapPosY			BYTE		1
BitmapPosX_old	BYTE		?
BitmapPosY_old	BYTE		?
BitmapIdx			DWORD	1
BitmapColor		DWORD	yellow*16
LineIdx		BYTE		?

 .code
main PROC
	mov	eax, lightgreen*16
	call SetTextColor
	call DrawOneFrame
	call DrawBitmap
look4key:
	mov eax, 50
	call Delay
	call ReadKey
	jz STAY
	call SaveBitmapPos
	.IF al == 'b'
		mov BitmapIdx, 1
		mov BitmapColor, yellow*16
	.ELSEIF al == 32
		.IF BitmapIdx == 1
			mov BitmapIdx, 2
			mov BitmapColor, white*16
		.ELSE
			mov BitmapIdx, 1
			mov BitmapColor, yellow*16
		.ENDIF
	.ELSEIF al == 'w'
		.IF BitmapPosY > 1
			dec BitmapPosY
		.ENDIF
	.ELSEIF al == 'a'
		.IF BitmapPosX > 1
			dec BitmapPosX
		.ENDIF
	.ELSEIF al == 's'
		.IF BitmapPosY < 16
			inc BitmapPosY
		.ENDIF
	.ELSEIF al == 'd'
		.IF BitmapPosX < 54
			inc BitmapPosX
		.ENDIF
	.ELSEIF al == 'q' || al == 27
		jmp Bye
	.ENDIF
	call ClearBitmap
	call DrawBitmap
STAY:
	jmp look4key
Bye:
	mov eax, black*16+lightgray
	call SetTextColor
	call ClearBG
	mov dh, 0
	mov dl, 0
	call GotoXY
	mWriteLn "Student ID: 0516034"
	mWriteLn "Student Name: ·¨µ¾¶v"
	mWriteLn "press any key to exit....."
look4sth:
	mov eax, 50
	call Delay
	call ReadKey
	jz look4sth
	exit
main ENDP

ClearBG PROC
	call Clrscr
	ret
ClearBG ENDP

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

 DrawBitmap PROC
	.IF BitmapIdx == 1
		mov ebx, OFFSET MYBITMAP1
	.ELSE
		mov ebx, OFFSET MYBITMAP2
	.ENDIF
	mov eax, BitmapColor
	call SetTextColor
	mov edi, 0
	mov LineIdx, 0
L0:
	mov eax, 5
	mul edi
	mov esi, eax
	mov dl, BitmapPosX
	mov dh, BitmapPosY
	add dh, LineIdx
	inc LineIdx
	call GotoXY
	mov ecx, MYBITMAP_WIDTH
L1:
	mov al, [ebx+esi]
	.IF al == 1
		mov al, ' '
		call WriteChar
	.ENDIF
	inc dl
	call GotoXY
	inc esi
	loop L1
	inc edi
	cmp edi, MYBITMAP_HEIGHT
	jl L0
	ret
 DrawBitmap ENDP

 ClearBitmap PROC
	mov eax, black*16
	call SetTextColor
	mov LineIdx, 0
	mov edi, 0
L0:
	mov dl, BitmapPosX_old
	mov dh, BitmapPosY_old
	add dh, LineIdx
	inc LineIdx
	call GotoXY
	mWrite "     "
	inc edi
	cmp edi, MYBITMAP_HEIGHT
	jl L0
	ret
 ClearBitmap ENDP

 SaveBitmapPos PROC
	mov dl, BitmapPosX
	mov BitmapPosX_old, dl
	mov dl, BitmapPosY
	mov BitmapPosY_old, dl
	ret
 SaveBitmapPos ENDP

END main


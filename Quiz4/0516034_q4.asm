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
; Date: 2018/05/17
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

CharColor	DWORD	?
UserColor	DWORD	yellow*16
AIColor		DWORD	lightred*16

UserX			BYTE			?
UserY			BYTE			?
Old_UserX		BYTE			?
Old_UserY		BYTE			?
AIX				BYTE			?
AIY				BYTE			?
Old_AIX		BYTE			?
Old_AIY		BYTE			?

Key		BYTE		?

MovingCycle	DWORD	3
Counting		DWORD	1
Stop			DWORD	0
ReachTop	DWORD	1

WallIdx		BYTE		3, 11, 17, 25, 32, 40, 47, 54
WallLen		DWORD	18
Hole1		DWORD	?
Hole2		DWORD	?
ZeroArray	BYTE		18*58	DUP(0)
MapArray	BYTE		18*58	DUP(?)

.code
main PROC
PlayAgain:
	mov eax, black*16+lightgray
	call SetTextColor
	call Clrscr
ResetGame:
	mov eax, lightblue*16
	call SetTextColor
	call DrawOneFrame
	call initChar
	mov dl, AIX
	mov dh, AIY
	mov eax, AIColor
	mov CharColor, eax
	call DrawCharacter
	mov dl, UserX
	mov dh, UserY
	mov eax, UserColor
	mov CharColor, eax
	call DrawCharacter
	call Randomize
	call GetMap
	mov eax, lightblue*16
	call SetTextColor
	call DrawMap
look4input:
	mov eax, 50
	call Delay
	call ReadKey
	.IF al == 'r'
		call CleanOldMap
		jmp ResetGame
	.ELSEIF al == 'w' || al == 'a' || al == 's' || al == 'd'
		.IF Stop == 0
			mov Key, al
			call SaveOldUser
			call HandleKey
		.ENDIF
	.ELSEIF al == ' '
		.IF Stop == 1
			mov Stop, 0
		.ELSE
			mov Stop, 1
		.ENDIF
	.ELSEIF al == 'q'
		jmp Bye
	.ENDIF
	.IF Stop == 0
		mov dl, Old_UserX
		mov dh, Old_UserY
		call CleanCharacter
		mov dl, UserX
		mov dh, UserY
		mov eax, UserColor
		mov CharColor, eax
		call DrawCharacter
		.IF UserX == 0
			jmp UserWin
		.ENDIF
		mov eax, MovingCycle
		.IF Counting == eax
			call SaveOldAI
			call HandleAI
			mov dl, Old_AIX
			mov dh, Old_AIY
			call CleanCharacter
			mov dl, AIX
			mov dh, AIY
			mov eax, AIColor
			mov CharColor, eax
			call DrawCharacter
			.IF AIX == 0
				jmp AIWin
			.ENDIF
			mov Counting, 1
		.ELSE
			inc Counting
		.ENDIF
	.ENDIF
	jmp look4input
UserWin:
	mov dl, 23
	mov dh, 0
	call GotoXY
	mov eax, yellow*16+black
	call SetTextColor
	mWrite "You Win !"
	jmp Next
AIWin:
	mov dl, 23
	mov dh, 0
	call GotoXY
	mov eax, yellow*16+black
	call SetTextColor
	mWrite "AI Wins !"
Next:
	mov dl, 0
	mov dh, 21
	call GotoXY
	mov eax, lightgray+black*16
	call SetTextColor
	mWriteLn "1) Play again"
	mWriteLn "2) Quit"
look4choice:
	mov eax, 50
	call Delay
	call ReadKey
	jz look4choice
	.IF al == '1'
		jmp PlayAgain
	.ELSEIF al == '2'
		jmp Bye
	.ELSE
		mWriteLn "Invalid"
		jmp look4choice
	.ENDIF
Bye:
	mov eax, lightgray+black*16
	call SetTextColor
	call Clrscr
	mWriteLn "Student ID: 0516034"
	mWriteLn "Student name: ·¨µ¾¶v"
	mWriteLn "Student email: eugene87222@gmail.com"
	mWriteLn "press any key to exit......"
look4any:
	mov eax, 50
	call Delay
	call ReadKey
	jz look4any
	exit
main ENDP

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

initChar PROC
	mov UserX, 57
	mov UserY, 17
	mov AIX, 57
	mov AIY, 0
	ret
initChar ENDP

DrawCharacter PROC
	inc dl
	inc dh
	call GotoXY
	mov eax, CharColor
	call SetTextColor
	mov al, ' '
	call WriteChar
	ret
DrawCharacter ENDP

CleanCharacter PROC
	inc dl
	inc dh
	call GotoXY
	mov eax, black*16
	call SetTextColor
	mov al, ' '
	call WriteChar
	ret
CleanCharacter ENDP

SaveOldUser PROC
	mov al, UserX
	mov Old_UserX, al
	mov al, UserY
	mov Old_UserY, al
	ret
SaveOldUser ENDP

SaveOldAI PROC
	mov al, AIX
	mov Old_AIX, al
	mov al, AIY
	mov Old_AIY, al
	ret
SaveOldAI ENDP

RandomHole PROC
	mov eax, 18
	call RandomRange
	mov Hole1, eax
ReRandom:
	mov eax, 18
	call RandomRange
	cmp eax, Hole1
	je ReRandom
	mov Hole2, eax
	ret
RandomHole ENDP

GetMap PROC
	mov ecx, 18*58
	mov esi, OFFSET ZeroArray
	mov edi, OFFSET MapArray
	rep movsb
	mov ecx, LENGTHOF WallIdx
	mov ebx, OFFSET WallIdx
	mov esi, 0
	; ebx -> Wall index
L0:
	mov al, [ebx+esi]
	movzx eax, al
	push esi
	push ecx
	mul WallLen
	mov edx, OFFSET MapArray
	add edx, eax
	call RandomHole
	; edx -> Map array[wall idx]
	mov esi, 0
	mov ecx, 18
L1:
	.IF esi == Hole1 || esi == Hole2
		nop
	.ELSE
		mov eax, 1
		mov [edx+esi], eax
	.ENDIF
	inc esi
	loop L1
	pop ecx
	pop esi
	inc esi
	loop L0
	ret
GetMap ENDP

CleanOldMap PROC
	mov eax, black*16
	call SetTextColor
	mov ecx, 18
	mov dh, 0
L0:
	mov dl, 1
	inc dh
	mov esi, 0
L1:
	call GotoXY
	mov al, ' '
	call WriteChar
	inc dl
	inc esi
	cmp esi, 58
	jl L1
	loop L0
	ret
CleanOldMap ENDP

DrawMap PROC
	mov ecx, 58
	mov esi, 0
L0:
	mov ebx, OFFSET MapArray
	mov eax, esi
	mul WallLen
	add ebx, eax
	mov edx, esi
	push esi
	push ecx
	mov esi, 0
	mov ecx, WallLen
	inc dl
	mov dh, 1
L1:
	call GotoXY
	mov al, [ebx+esi] 
	.IF al == 0
		nop
	.ELSE
		mov al, ' '
		call WriteChar
	.ENDIF
	inc dh
	inc esi
	loop L1

	pop ecx
	pop esi
	inc esi
	loop L0
	ret
DrawMap ENDP

HandleKey PROC
	mov ebx, OFFSET MapArray
	mov al, UserX
	movzx esi, al
	mov eax, 18
	mul esi
	add ebx, eax
	mov al, UserY
	movzx eax, al
	add ebx, eax
	.IF Key == 'w'
		.IF UserY != 0
			mov al, [ebx-1]
			.IF al != 1
				dec UserY
			.ENDIF
		.ENDIF
	.ELSEIF Key == 'a'
		.IF UserX != 0
			mov al, [ebx-18]
			.IF al != 1
				dec UserX
			.ENDIF
		.ENDIF
	.ELSEIF Key == 's'
		.IF UserY != 17
			mov al, [ebx+1]
			.IF al != 1
				inc UserY
			.ENDIF
		.ENDIF
	.ELSEIF Key == 'd'
		.IF UserX != 57
			mov al, [ebx+18]
			.IF al != 1
				inc UserX
			.ENDIF
		.ENDIF
	.ENDIF
	ret
HandleKey ENDP

HandleAI PROC
	mov ebx, OFFSET MapArray
	mov al, AIX
	movzx esi, al
	mov eax, 18
	mul esi
	add ebx, eax
	mov al, AIY
	movzx eax, al
	add ebx, eax
	mov al, [ebx-18]
	.IF AIX == 0
		jmp Finish
	.ENDIF
	.IF al != 1
		dec AIX
		mov ReachTop, 0
		jmp Finish
	.ENDIF
	.IF AIY != 0 && ReachTop == 0
		dec AIY
		jmp Finish
	.ENDIF
	mov ReachTop, 1
	.IF AIY != 57
		inc AIY
	.ENDIF
Finish:
	ret
HandleAI ENDP

END main

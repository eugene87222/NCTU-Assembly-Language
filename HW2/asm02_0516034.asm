TITLE
;=======================
; Assembly Programming 2
;
; Student Name: ·¨µ¾¶v
; Student ID: 0516034
; Student Email Address: eugene87222@gmail.com
;=======================

include Irvine32.inc
include Macros.inc

.data
	X_dir		BYTE			?
	Y_dir		BYTE			?
	X			BYTE			?
	Y			BYTE			?
	LEN		DWORD	?
	WID		DWORD	?
	
	DelayTime			DWORD	?

	ShipColor		DWORD	yellow
	Color1			DWORD	?
	Color2			DWORD	?
	Color3			DWORD	?
	ShipX			BYTE			15
	ShipY			BYTE			10
	ShipOldX		BYTE			15
	ShipOldY		BYTE			10
	UP				BYTE			'e'
	DOWN			BYTE			'c'

.code
main PROC
menu:
	call ClearBG
	call SetShipColor
	mov LEN, 70
	mov WID, 9
	mov DelayTime, 0
	call DrawOneFrame
	call ShowMenu
	call Crlf
SelectOption:
	mov eax, 50
	call Delay
	call ReadKey
	jz SelectOption
	call WriteChar
	call Crlf
	.IF al == '1'
		call ChangeShipColor
		jmp menu
	.ELSEIF al == '2'
		mov DelayTime, 50
		call FrameTheWindow
		mov eax, 500
		call Delay
		jmp menu
	.ELSEIF al == '3'
		call Play
		jmp menu
	.ELSEIF al == '4'
		call ShowAuthorInfo
		jmp menu
	.ELSEIF al == '5'
		jmp the_end
	.ELSE
		jmp SelectOption
	.ENDIF
	call ReadInt
the_end:
	exit
main ENDP

SetShipColor PROC
	mov eax, ShipColor
	shl eax, 4		; eax = eax * 16
	call SetTextColor
	ret
SetShipColor ENDP

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

; clear the background (Clrscr)
ClearBG PROC
	call Clrscr
	ret
ClearBG ENDP

; Set the coordinate and width / length
InitCoor PROC
	mov X, 0
	mov Y, 0
	ret
InitCoor ENDP

DrawHorizontal_TOP PROC
	mov ecx, LEN
	mov X_dir, -1
	mov Y_dir, 0
	call DrawOneLine
	ret
DrawHorizontal_TOP ENDP

DrawHorizontal_BOTTOM PROC
	mov ecx, LEN
	mov X_dir, 1
	mov Y_dir, 0
	call DrawOneLine
	ret
DrawHorizontal_BOTTOM ENDP

DrawVertical_LEFT PROC
	mov ecx, WID
	mov X_dir, 0
	mov Y_dir, 1
	call DrawOneLine
	ret
DrawVertical_LEFT ENDP

DrawVertical_RIGHT PROC
	mov ecx, WID
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
	mov eax, DelayTime
	call Delay
	loop L0
	sub dl, X_dir
	sub dh, Y_dir
	mov X, dl
	mov Y, dh
	call GotoXY
	ret
DrawOneLine ENDP

ShowMenu PROC
	mov dl, 2
	mov dh, 1
	call GotoXY
	mWriteLn "1) Change ship color"
	inc dh
	call GotoXY
	mWriteLn "2) Show a frame around the screen rectangular area"
	inc dh
	call GotoXY
	mWriteLn "3) Play now!!!"
	inc dh
	call GotoXY
	mWriteLn "4) Show author information" 
	inc dh
	call GotoXY
	mWriteLn "5) Quit game"
	add dh, 2
	call GotoXY
	mWriteLn "Please enter an option......"
	ret
ShowMenu ENDP

;=======================
; Option 1
; Change ship color
ChangeShipColor PROC
	call ClearBG
	call GenerateThreeColor
	call ShowOption
SelectColor:
	mov eax, 25
	call Delay
	call ReadKey
	jz SelectColor
	call WriteChar
	call Crlf
	.IF al == '1'
		mov edx, Color1
	.ELSEIF al == '2'
		mov edx, Color2
	.ELSEIF al == '3'
		mov edx, Color3
	.ELSE
		mWriteLn "Invalid input"
		jmp SelectColor
	.ENDIF
	mov ShipColor, edx
	mov eax, 7
	call Writechar
	ret
ChangeShipColor ENDP

; Get a random color (not black)
GetRandomColor PROC
GetColor:
	mov eax, 16
	call RandomRange
	cmp eax, black
	je GetColor
	ret
GetRandomColor ENDP

GenerateThreeColor PROC
GetColor1:
	call GetRandomColor
	mov Color1, eax
GetColor2:
	call GetRandomColor
	cmp eax, Color1
	je GetColor2
	mov Color2, eax
GetColor3:
	call GetRandomColor
	cmp eax, Color1
	je GetColor3
	cmp eax, Color2
	je GetColor3
	mov Color3, eax
	ret
GenerateThreeColor ENDP

ShowOption PROC
mWriteLn "Please select a color for the space ship"
	mov X_dir, 1
	mov Y_dir, 0
	mov X, 2
	mov Y, 2
	mov eax, Color1
	shl eax, 4		; eax = eax * 16
	call SetTextColor
	call DrawRectangle
	mWrite "1"
	add X, 4
	mov eax, Color2
	shl eax, 4		; eax = eax * 16
	call SetTextColor
	call DrawRectangle
	mWrite "2"
	add X, 4
	mov eax, Color3
	shl eax, 4		; eax = eax * 16
	call SetTextColor
	call DrawRectangle
	mWrite "3"
	call Crlf
	ret
ShowOption ENDP

DrawRectangle PROC
	mov ecx, 3
	call DrawOneLine
	inc Y
	sub X, 2
	mov ecx, 3
	call DrawOneLine
	dec Y
	dec dl
	inc dh
	call GotoXY
	mov eax, lightgray
	call SetTextColor
	ret
DrawRectangle ENDP

;=======================
; Option 2
FrameTheWindow PROC
	call ClearBG
	mov LEN, 80
	mov WID, 22
	call SetShipColor
	call DrawOneFrame
	ret
FrameTheWindow ENDP

;=======================
; Option 3
Play PROC
	mov DelayTime, 0
	call FrameTheWindow
	call ShowShip
KeepPlay:
	call SaveShipPos
	mov eax, 50
	call Delay
	.IF ShipX == 76
		mov ShipX, 1
	.ELSE
		inc ShipX
	.ENDIF
	call ReadKey
	cmp al, ' '
	je the_end
	.IF al == UP
		.IF ShipY == 1
			mov ShipY, 20
		.ELSE
			dec ShipY
		.ENDIF
	.ELSEIF al == DOWN
		.IF ShipY == 20
			mov ShipY, 1
		.ELSE
			inc ShipY
		.ENDIF
	.ENDIF
	call AnimateShip
	jmp KeepPlay
the_end:
	mov eax, lightgray
	call SetTextColor
	ret
Play ENDP

AnimateShip PROC
	call CleanShip
	call ShowShip
	ret
AnimateShip ENDP

SaveShipPos PROC
	mov al, ShipX
	mov ShipOldX, al
	mov al, ShipY
	mov ShipOldY, al
	ret
SaveShipPos ENDP

CleanShip PROC
	mov al, ShipX
	cmp al, ShipOldX
	jne Clean
	mov al, ShipY
	cmp al, ShipOldY
	jne Clean
Clean:
	mov eax, lightgray
	call SetTextColor
	mov dl, ShipOldX
	mov dh, ShipOldY
	mov ecx, 3
L0:
	.IF dl == 79
		mov dl, 1
	.ENDIF
	call GotoXY
	mov al, ' '
	call WriteChar
	inc dl
	loop L0
	ret
CleanShip ENDP

ShowShip PROC
	call SetShipColor
	mov al, ShipX
	mov X, al
	mov al, ShipY
	mov Y, al
	mov DelayTime, 0
	mov X_dir, 1
	mov Y_dir, 0
	mov ecx, 3
	call DrawOneLine
	ret
ShowShip ENDP

;=======================
; Option 4
ShowAuthorInfo PROC
	mWriteLn "Student Name: ·¨µ¾¶v"
	mWriteLn "Student ID: 0516034"
	mWriteLn "Student Email Address: eugene87222@gmail.com"
	call Crlf
	mWriteLn "Press any key to go back to the menu"
input_sth:
	mov eax, 50
	call Delay
	call Readkey
	jz input_sth
	ret
ShowAuthorInfo ENDP

END main

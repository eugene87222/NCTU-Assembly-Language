
;========================================================
; Student Name: 法稻秜
; Student ID: 0516034
; Email: eugene87222@gmail.com
;========================================================
; Prof. Sai-Keung WONG
; Email: cswingo@cs.nctu.edu.tw
; Room: EC706
; Assembly Language 
; Date: 2018/04/15
;========================================================
; Description:
;
; IMPORTANT: always save EBX, EDX, EDI and ESI as their
; values are preserved by the callers in C calling convention.
;

INCLUDE Irvine32.inc
INCLUDE Macros.inc

invisibleDigitX  TEXTEQU %(-100000)
invisibleDigitY  TEXTEQU %(-100000)

MOVE_LEFT		= 0
MOVE_RIGHT	= 1
MOVE_UP			= 2
MOVE_DOWN	= 3
MOVE_STOP		= 4

MOVE_LEFT_KEY		= 'a'
MOVE_RIGHT_KEY		= 'd'
MOVE_UP_KEY			= 'w'
MOVE_DOWN_KEY	= 's'

COLOR_RANDOM		=	'r'
COLOR_RAINBOW		=	'p'
COLOR_ORIGIN			=	'o'

; PROTO C is to make agreement on calling convention for INVOKE

c_updatePositionsOfAllObjects PROTO C

ShowSubRegionAtLoc PROTO,
	x : DWORD, y: DWORD, w : DWORD, h : DWORD, x0 : DWORD, y0 : DWORD
	
computeLocationOfPixelInImage PROTO,
	x0 : DWORD, y0 : DWORD, w : DWORD, h : DWORD

swapPickedGridCellandCurGridCellRegion PROTO

PROGRAM_STATE_PRE_START_GAME	= 0
PROGRAM_STATE_START_GAME			= 1
PROGRAM_STATE_PRE_PLAY_GAME		= 2
PROGRAM_STATE_PLAY_GAME				= 3
PROGRAM_STATE_PRE_END_GAME		= 4
PROGRAM_STATE_END_GAME				= 5

.data 
colors BYTE 01ch
colorOriginal BYTE 01ch

MYINFO	BYTE "My Name: 法稻秜: StudentID: 0516034",0 

OpenMsgDelay		DWORD	25
EnterStageDelay	DWORD	50

MyMsg BYTE "Assignment Three for Assembly Language...",0dh, 0ah
BYTE "My Name: 法稻秜",0dh, 0ah 
BYTE "My student ID: 0516034.", 0dh, 0ah, 0dh, 0ah
BYTE "My Email is: eugene87222@gmail.com.", 0dh, 0ah, 0dh, 0ah
BYTE "Make sure that the screen dimension is (120, 30).", 0dh, 0ah, 0dh, 0ah
BYTE "Key usages:", 0dh, 0ah
BYTE "Control keys:", 0dh, 0ah
BYTE "     a->left, d->right, w->up, s->down", 0dh, 0ah
BYTE "     p->rainbow color, r->random color", 0dh, 0ah
BYTE "     c->clear", 0dh, 0ah
BYTE "     v->save", 0dh, 0ah
BYTE "     l->load", 0dh, 0ah
BYTE "     spacebar->toggle grow / not grow", 0dh, 0ah
BYTE "Mouse control: ", 0dh, 0ah
BYTE "     passive mouse movement: show the mouse cursor", 0dh, 0ah
BYTE "     left mouse button: set target", 0dh, 0ah
BYTE "ESC: quit", 0dh, 0ah

CaptionString BYTE "Student Name: 法稻秜",0
MessageString BYTE "Welcome to Wonderful World", 0dh, 0ah, 0dh, 0ah
				BYTE "My Student ID is 0516034", 0dh, 0ah, 0dh, 0ah
				BYTE "My Email is: eugene87222@gmail.com.", 0dh, 0ah, 0dh, 0ah
				BYTE "Control keys:", 0dh, 0ah
				BYTE "     a->left, d->right, w->up, s->down", 0dh, 0ah
				BYTE "     p->rainbow color, r->random color", 0dh, 0ah
				BYTE "     c->clear", 0dh, 0ah
				BYTE "     v->save", 0dh, 0ah
				BYTE "     l->load", 0dh, 0ah
				BYTE "     spacebar->toggle grow / not grow", 0dh, 0ah
				BYTE "Mouse control: ", 0dh, 0ah
				BYTE "     passive mouse movement: show the mouse cursor", 0dh, 0ah
				BYTE "     left mouse button: set target", 0dh, 0ah
				BYTE "ESC: quit", 0dh, 0ah
				BYTE "Enjoy playing!", 0

CaptionString_EndingMessage BYTE "Student Name: 法稻秜",0
MessageString_EndingMessage BYTE "Thanks for playing...", 0dh, 0ah, 0dh, 0ah
				BYTE "My Student ID is 0516034", 0dh, 0ah, 0dh, 0ah
				BYTE "My Email is: eugene87222@gmail.com.", 0dh, 0ah, 0dh, 0ah
				BYTE "See you later!", 0


EndingMsg BYTE "Thanks for playing.", 0

SetSpeed_Message		BYTE		"Enter the speed of the snake (integer) [1, 200]:", 0
SetLifeCycle_Message	BYTE		"Enter the snake life cycle (integer) [1, 100]:", 0

windowWidth	DWORD 8000
windowHeight	DWORD 8000

scaleFactor	DWORD	128
canvasMinX	DWORD -4000
canvasMaxX	DWORD 4000
canvasMinY	DWORD -4000
canvasMaxY	DWORD 4000
;
particleRangeMinX REAL8 0.0
particleRangeMaxX REAL8 0.0
particleRangeMinY REAL8 0.0
particleRangeMaxY REAL8 0.0
;
tmpParticleY DWORD ?
;
particleSize DWORD  2
numParticles DWORD 20000
particleMaxSpeed DWORD 3

mouseX		SDWORD 0	; mouse x-coordinate
mouseY		SDWORD 0	; mouse y-coordinate

maxNumSnakeObj	DWORD	1024
numSnakeObj	DWORD	1
numSaveObj		DWORD	0
snakeObjPosX SDWORD	1024 DUP(0)
snakeObjPosY SDWORD	1024 DUP(0)
snakeLife	DWORD	0
snakeLifeCycle	DWORD	25

cur_snakeObjPosX DWORD 0
cur_snakeObjPosY DWORD 0

default_snakeLifeCycle	DWORD 25

snakeSpeed				DWORD 100
Default_SnakeMaxSpeed	DWORD 200

snakeMoveDirection			DWORD	MOVE_RIGHT
Toggle		DWORD	0

flg_target	DWORD	0		; is the target set? true or false
target_x	DWORD	?		; target x-coordinate
target_y	DWORD	?		; target y-coordinate
flgQuit		DWORD	0
maxNumObjects	DWORD 512
numObjects	DWORD	300
objPosX		SDWORD	2048 DUP(0)
objPosY		SDWORD	2048 DUP(0)
objTypes	BYTE	2048 DUP(1)
objSpeedX	SDWORD	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20
			SDWORD	2048 DUP(?)
objSpeedY	SDWORD	2, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20
			SDWORD	2048 DUP(?)			
objColor	DWORD	0, 254, 254,
					254, 254, 254,
					0, 127, 0,
					2048*3 DUP(128)
studentObjColor	DWORD	2048*3 DUP(?)

ColorState				DWORD	COLOR_ORIGIN
RainbowIdx			DWORD	0

goMsg		BYTE "I love assembly programming. Let's start...", 0
bell		BYTE 0,0, 0
					
testDBL	REAL4	3.141592654
zero REAL8 0.0

particleState BYTE 0
negOne REAL8 -1.0

openingMsg	BYTE	"This program allows a user to draw a picture using spheres......", 0dh
			BYTE	"Great programming.", 0
movementDIR	BYTE	0
state		BYTE	0

imagePercentage DWORD	0

mImageStatus DWORD 0
mImagePtr0 BYTE 200000 DUP(?)
mImagePtr1 BYTE 200000 DUP(?)
mImagePtr2 BYTE 200000 DUP(?)
mTmpBuffer	BYTE	200000 DUP(?)
mImageWidth DWORD 0
mImageHeight DWORD 0
mBytesPerPixel DWORD 0
mImagePixelPointSize DWORD 6

mFlipX DWORD 0
mFlipY DWORD 1
mEnableBrighter DWORD 0
mAmountOfBrightness DWORD 1
mBrightnessDirection DWORD 0

				;x, y, width, height	
mSubImage		DWORD	0, 0, 30, 30
mShowAtLocation	DWORD	30, 30

;width and height
GridDimensionW	DWORD	8
GridDimensionH	DWORD	8
GridCellW			DWORD	1
GridCellH			DWORD	1
CurGridX		DWORD	0
CurGridY		DWORD	0
flgPickedGrid	DWORD	0
PickedGridX		DWORD	-1
PickedGridY		DWORD	-1

OldPickedGridX		DWORD	-1
OldPickedGridY		DWORD	-1

GridColorRed		BYTE	0
GridColorGreen		BYTE	0
GridColorBlue		BYTE	0


FlgSaveImage			BYTE		0
FlgRestoreImage		BYTE		0
FlgShowGrid				BYTE		0	;2
FlgYellowFlower		BYTE		0	;3
FlgBrigtenImage		BYTE		0	;4
FlgDarkenImage		BYTE		0	;5
FlgGrayLevelImage	BYTE		0	;6

programState		BYTE	0

.code

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_ClearScreen()
;
;Clear the screen.
;We can set text color if you want.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_ClearScreen PROC C
	mov al, 0
	mov ah, 0
	call SetTextColor
	call clrscr
	ret
asm_ClearScreen ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_ShowTitle()
;
;Show the title of the program
;at the beginning.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_ShowTitle PROC C USES edx
	mov dx, 0
	call GotoXY
	xor eax, eax
	mov ah, 0h
	mov al, 0e1h
	call SetTextColor
	mov edx, offset MyMsg
	call WriteString
	call Crlf
	ret
asm_ShowTitle ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_InitializeApp()
;
;This function is called
;at the beginning of the program.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_InitializeApp PROC C USES ebx edi esi edx
	call AskForInput_Initialization
	;call initSnake
	ret
asm_InitializeApp ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_EndingMessage()
;
;This function is called
;when the program exits.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_EndingMessage PROC C USES ebx edx
	mov ebx, OFFSET CaptionString_EndingMessage
	mov edx, OFFSET MessageString_EndingMessage
	call MsgBox
	ret
asm_EndingMessage ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_updateSimulationNow()
;
;Update the simulation.
;For example,
;we can update the positions of the objects.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_updateSimulationNow PROC C USES edi esi ebx
	;
	call updateSnake
	;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;DO NOT REMOVE THE FOLLOWING LINE
	call c_updatePositionsOfAllObjects 
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ret
asm_updateSimulationNow ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void setCursor(int x, int y)
;
;Set the position of the cursor 
;in the console (text) window.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
setCursor PROC C USES edx,
	x:DWORD, y:DWORD
	mov edx, y
	shl edx, 8
	xor edx, x
	call Gotoxy
	ret
setCursor ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_GetMouseXY(int &out_mouseX, int &out_mouseY)
;or
;void asm_GetMouseXY(int *out_mouseX, int *out_mouseY)
;Get the mouse coordinates
; out_mouseX = mouseX;	// or *out_mouseX = mouseX;
; out_mouseY = mouseY;	// or *out_mouseY = mouseY;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetMouseXY PROC C USES edi,
	out_mouseX: PTR SDWORD, out_mouseY: PTR SDWORD
	;;;;;;;;;;;;;;;;;;;;;;;
	; modify it
	push eax
	mov eax, mouseX
	mov edi, out_mouseX
	mov [edi], eax
	mov eax, mouseY
	mov edi, out_mouseY
	mov [edi], eax
	pop eax
	;;;;;;;;;;;;;;;;;;;;;;;
	ret
asm_GetMouseXY ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; bool asm_GetTargetXY(int &out_mouseX, int &out_mouseY)
; or
; bool asm_GetTargetXY(int *out_mouseX, int *out_mouseY)
;
; Get the target coordinates and also return a flag.
; Return true if the target is set and false otherwise.
; 
; out_mouseX = target_x;	// or *out_mouseX = target_x
; out_mouseY = target_y;	// or *out_mouseY = target_y
; return flg_target
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetTargetXY PROC C USES edi,
	out_mouseX: PTR SDWORD, out_mouseY: PTR SDWORD
	;;;;;;;;;;;;;;;;;;;;;;;
	; modify it
	cmp flg_target, 0
	je L0
	mov edi, out_mouseX
	mov eax, target_x
	mov [edi], eax
	mov edi, out_mouseY
	mov eax, target_y
	mov [edi], eax
	mov snakeMoveDirection, MOVE_STOP
L0:
	mov eax, flg_target
	;;;;;;;;;;;;;;;;;;;;;;;
	ret
asm_GetTargetXY ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetNumParticles PROC C
	mov eax, numParticles
	ret
asm_GetNumParticles ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetParticleMaxSpeed PROC C
	mov eax, particleMaxSpeed
	ret
asm_GetParticleMaxSpeed ENDP

;
;int asm_GetParticleSize()
;
;Return the particle size.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetParticleSize PROC C
	;modify this procedure
	mov eax, 1
	ret
asm_GetParticleSize ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_handleMousePassiveEvent( int x, int y )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_handleMousePassiveEvent PROC C USES eax ebx edx,
	x : DWORD, y : DWORD
	mov eax, x
	mWrite "x:"
	call WriteDec
	mWriteln " "
	mov eax, y
	mWrite "y:"
	call WriteDec
	mWriteln " "
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov ebx, canvasMaxX
	sub ebx, canvasMinX
	mov eax, x
	mul ebx
	div windowWidth
	add eax, canvasMinX
	mov mouseX, eax 
	;
	mov ebx, canvasMaxY
	sub ebx, canvasMinY
	mov eax, windowHeight
	sub eax, y
	mul ebx
	div windowHeight
	add eax, canvasMinY
	mov mouseY, eax 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov eax, windowHeight
	cdq
	mov ecx, GridDimensionH
	div ecx
	mov ebx, eax	; ebx = y
	
	mov eax, windowWidth
	cdq
	mov ecx, GridDimensionW
	div ecx			; eax = x
	
	mov ecx, eax
	mov eax, x
	cmp mFlipX, 0
	je L0
	mov edx, windowWidth
	sub edx, eax
	mov eax, edx
L0:
	cdq
	div ecx
	mov CurGridX, eax
	;
	mov ecx, ebx
	mov eax, y
;
	cmp mFlipY, 1
	je L1
	mov edx, windowHeight
	sub edx, eax
	mov eax, edx
;
L1:
	cdq
	div ecx
	mov CurGridY, eax
	
	ret
asm_handleMousePassiveEvent ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_handleMouseEvent(int button, int status, int x, int y)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_handleMouseEvent PROC C USES ebx,
	button : DWORD, status : DWORD, x : DWORD, y : DWORD
	
	mWriteln "asm_handleMouseEvent"
	mov eax, button
	mWrite "button:"
	call WriteDec
	mWriteln " "
	mov eax, status
	mWrite "status:"
	call WriteDec
	mov eax, x
	mWriteln " "
	mWrite "x:"
	call WriteDec
	mWriteln " "
	mov eax, y
	mWrite "y:"
	call WriteDec
	mWriteln " "
	mov eax, windowWidth
	mWrite "windowWidth:"
	call WriteDec
	mWriteln " "
	mov eax, windowHeight
	mWrite "windowHeight:"
	call WriteDec
	mWriteln " "
	;
	;mov flg_target, 0
	cmp button, 0
	jne exit0
	cmp status, 0
	jne exit0
	;
	mov flg_target, 1
	mov ebx, canvasMaxX
	sub ebx, canvasMinX
	mov eax, x
	mul ebx
	div windowWidth
	add eax, canvasMinX
	mov target_x, eax 
	;
	mov ebx, canvasMaxY
	sub ebx, canvasMinY
	mov eax, windowHeight
	sub eax, y
	mul ebx
	div windowHeight
	add eax, canvasMinY
	mov target_y, eax 
exit0:
	ret
asm_handleMouseEvent ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int asm_HandleKey(int key)
;
;Handle key events.
;Return 1 if the key has been handled.
;Return 0, otherwise.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_HandleKey PROC C USES ebx ebx esi edi, 
	key : DWORD
	mov eax, key
	;;;;;;;;;;;;;;;;;;;;;;;
	; modify it 
	.IF al =='w'
		mov snakeMoveDirection, MOVE_UP
		mov flg_target, 0
		mov eax, 1
	.ELSEIF al =='a'
		mov snakeMoveDirection, MOVE_LEFT
		mov flg_target, 0
		mov eax, 1
	.ELSEIF al =='s'
		mov snakeMoveDirection, MOVE_DOWN
		mov flg_target, 0
		mov eax, 1
	.ELSEIF al =='d'
		mov snakeMoveDirection, MOVE_RIGHT
		mov flg_target, 0
		mov eax, 1
	.ELSEIF al == 32
		.IF Toggle == 0
			mov Toggle, 1
			mov eax, 1
		.ELSE
			mov Toggle, 0
		.ENDIF
	.ELSEIF al == 'r'
		mov ColorState, COLOR_RANDOM
		mov RainbowIdx, 0
		mov eax, 1
	.ELSEIF al == 'p'
		mov ColorState, COLOR_RAINBOW
		mov eax, 1
	.ELSEIF al == 'c'
		mov numSnakeObj, 1
		mov eax, 1
	.ELSEIF al == 'v'
		mov eax, numSnakeObj
		mov numSaveObj, eax
		mov ecx, numSaveObj
		mov esi, OFFSET objPosX
		mov edi, OFFSET snakeObjPosX
		rep movsd
		mov ecx, numSaveObj
		mov esi, OFFSET objPosY		
		mov edi, OFFSET snakeObjPosY
		rep movsd
		mov eax, 1
	.ELSEIF al == 'l'
		.IF numSaveObj != 0
			mov eax, numSaveObj
			mov numSnakeObj, eax
			mov ecx, numSaveObj
			mov esi, OFFSET snakeObjPosX
			mov edi, OFFSET objPosX
			rep movsd
			mov ecx, numSaveObj
			mov esi, OFFSET snakeObjPosY
			mov edi, OFFSET objPosY
			rep movsd
		.ENDIF
		mov eax, 1
	.ELSE
		mov eax, 0
	.ENDIF
	;;;;;;;;;;;;;;;;;;;;;;;
	ret
asm_HandleKey ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_SetWindowDimension(int w, int h, int scaledWidth, int scaledHeight)
;
;w: window resolution (i.e. number of pixels) along the x-axis.
;h: window resolution (i.e. number of pixels) along the y-axis. 
;scaledWidth : scaled up width
;scaledHeight : scaled up height
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_SetWindowDimension PROC C USES ebx,
	w: DWORD, h: DWORD, scaledWidth : DWORD, scaledHeight : DWORD
	mov ebx, offset windowWidth
	mov eax, w
	mov [ebx], eax
	mov eax, scaledWidth
	shr eax, 1	; divide by 2, i.e. eax = eax/2
	mov ebx, offset canvasMaxX
	mov [ebx], eax
	neg eax
	mov ebx, offset canvasMinX
	mov [ebx], eax
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov ebx, offset windowHeight
	mov eax, h
	mov [ebx], eax
	mov eax, scaledHeight
	shr eax, 1	; divide by 2, i.e. eax = eax/2
	mov ebx, offset canvasMaxY
	mov [ebx], eax
	neg eax
	mov ebx, offset canvasMinY
	mov [ebx], eax
	;
	finit
	fild canvasMinX
	fstp particleRangeMinX
	;
	finit
	fild canvasMaxX
	fstp particleRangeMaxX
	;
	finit
	fild canvasMinY
	fstp particleRangeMinY
	;
	finit
	fild canvasMaxY
	fstp particleRangeMaxY	
	;
;	call asm_ComputeGridCellDimension
	ret
asm_SetWindowDimension ENDP	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int asm_GetNumOfObjects()
;
;Return the number of objects
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetNumOfObjects PROC C
	;mov eax, maxNumObjects
	;;;;;;;;;;;;;;;;;;;;;;;
	; modify it 
	mov eax, maxNumObjects
	;;;;;;;;;;;;;;;;;;;;;;;
	ret
asm_GetNumOfObjects ENDP	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int asm_GetObjectType(int objID)
;
;Return the object type
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetObjectType		PROC C USES ebx edx,
	objID: DWORD
	push ebx
	push edx
	xor eax, eax
	mov edx, offset objTypes
	mov ebx, objID
	mov al, [edx + ebx]
	pop edx
	pop ebx
	ret
asm_GetObjectType		ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_GetObjectColor (int &r, int &g, int &b, int objID)
;Input: objID, the ID of the object
;
;Return the color three color components
;red, green and blue.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetObjectColor  PROC C USES ebx edi esi,
	r: PTR DWORD, g: PTR DWORD, b: PTR DWORD, objID: DWORD
	;;;;;;;;;;;;;;;;;;;;;;;
	; modify it 
	mov eax, objID
	inc eax
	.IF eax >= numSnakeObj
		mov ebx, r
		mov eax, 255
		mov [ebx], eax
		mov ebx, g
		mov eax, 0
		mov [ebx], eax
		mov ebx, b
		mov eax, 0
		mov [ebx], eax
	.ELSE
		mov edi, OFFSET objColor
		mov eax, 12
		mul objID
		add edi, eax
		mov ebx, r
		mov eax, [edi]
		mov [ebx], eax
		mov ebx, g
		mov eax, [edi+4]
		mov [ebx], eax
		mov ebx, b
		mov eax, [edi+8]
		mov [ebx], eax
	.ENDIF
	;;;;;;;;;;;;;;;;;;;;;;;
	ret
asm_GetObjectColor ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int asm_ComputeRotationAngle(a, b)
;return an angle*10.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_ComputeRotationAngle PROC C USES ebx,
	a: DWORD, b: DWORD
	mov ebx, b
	shl ebx, 1
	mov eax, a
	add eax, 10
	ret
asm_ComputeRotationAngle ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int asm_ComputeObjPositionX(int x, int objID)
;
;Return the x-coordinate.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_ComputeObjPositionX PROC C USES edi esi,
	x: DWORD, objID: DWORD
	;;;;;;;;;;;;;;;;;;;;;;;
	; modify it 
	mov eax, objID
	inc eax
	.IF eax >= numSnakeObj
		mov eax, cur_snakeObjPosX
	.ELSE
		mov ebx, OFFSET objPosX
		mov eax, 4
		mul objID
		mov esi, eax
		mov eax, [ebx+esi]
	.ENDIF
	;;;;;;;;;;;;;;;;;;;;;;;
	ret
asm_ComputeObjPositionX ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int asm_ComputeObjPositionY(int y, int objID)
;
;Return the y-coordinate.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_ComputeObjPositionY PROC C USES ebx esi edx,
	y: DWORD, objID: DWORD
	;;;;;;;;;;;;;;;;;;;;;;;
	; modify it 
	mov eax, objID
	inc eax
	.IF eax >= numSnakeObj
		mov eax, cur_snakeObjPosY
	.ELSE
		mov ebx, OFFSET objPosY
		mov eax, 4
		mul objID
		mov esi, eax
		mov eax, [ebx+esi]
	.ENDIF
	;;;;;;;;;;;;;;;;;;;;;;;
	ret
asm_ComputeObjPositionY ENDP

ASM_setText PROC C
	;mov al, 0e1h
	mov al, 01eh
	call SetTextColor
	ret
ASM_setText ENDP

asm_ComputeParticlePosX PROC C,
	xPtr : PTR REAL8
	ret
asm_ComputeParticlePosX ENDP

asm_ComputeParticlePosY PROC C,
	x : DWORD, yPtr : PTR REAL8, yVelocityPtr : PTR REAL8
	ret
asm_ComputeParticlePosY ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;
; void asm_SetImageInfo(
;	int imageindex, 
;	char *imagePtr, 
;	unsigned int w, // width
;	unsigned int h, // height
;	unsigned int bytesPerPixel
; )
;
; Assume bytesPerPixel = 3
;
; Save the image to a buffer, e.g., mImagePtr0
; The buffer must be large enough to store all the bytes
;
; Set mImageWidth and mImageHeight.
;
asm_SetImageInfo PROC C USES esi edi ebx,
	imageIndex : DWORD,
	imagePtr : PTR BYTE, w : DWORD, h : DWORD, 
	bytesPerPixel : DWORD
	;;;;;;;;;;;;;;;;;;;;;;;
	; modify it 
	mov eax, bytesPerPixel
	mov mBytesPerPixel, eax
	mov esi, imagePtr
	mov eax, w
	mov mImageWidth, eax
	mov eax, h
	mov mImageHeight, eax
	mul mImageWidth
	mul bytesPerPixel
	mov ecx, eax
	.IF imageIndex == 0
		mov edi, OFFSET mImagePtr0
	.ELSEIF imageIndex == 1
		mov edi, OFFSET mImagePtr1
	.ELSEIF imageIndex == 2
		mov edi, OFFSET mImagePtr2
	.ENDIF
	rep movsb
	;;;;;;;;;;;;;;;;;;;;;;;	
	ret
asm_SetImageInfo ENDP

asm_GetImagePixelSize PROC C
	mov eax, mImagePixelPointSize
	ret
asm_GetImagePixelSize ENDP

asm_GetImageStatus PROC C
	mov eax, mImageStatus
	ret
asm_GetImageStatus ENDP

asm_getImagePercentage PROC C
	mov eax, imagePercentage
	ret
asm_getImagePercentage ENDP

;
;asm_GetImageColour(int imageIndex, int ix, int iy, int &r, int &g, int &b)
;
asm_GetImageColour PROC C USES ebx esi, 
	imageIndex : DWORD,
	ix: DWORD, iy : DWORD,
	r: PTR DWORD, g: PTR DWORD, b: PTR DWORD
	;;;;;;;;;;;;;;;;;;;;;;;
	; modify it 
	push eax
	mov eax, mImageHeight
	dec eax
	sub eax, iy
	mul mImageWidth
	add eax, ix
	mul mBytesPerPixel
	mov esi, eax
	.IF imageIndex == 0
		mov al, mImagePtr0[esi]
		movzx eax, al
		mov ebx, r
		mov [ebx], eax
		mov al, mImagePtr0[esi+1]
		movzx eax, al
		mov ebx, g
		mov [ebx], eax
		mov al, mImagePtr0[esi+2]
		movzx eax, al
		mov ebx, b
		mov [ebx], eax
	.ELSEIF imageIndex == 1
		mov al, mImagePtr1[esi]
		movzx eax, al
		mov ebx, r
		mov [ebx], eax
		mov al, mImagePtr1[esi+1]
		movzx eax, al
		mov ebx, g
		mov [ebx], eax
		mov al, mImagePtr1[esi+2]
		movzx eax, al
		mov ebx, b
		mov [ebx], eax
	.ELSEIF imageIndex == 2
		mov al, mImagePtr2[esi]
		movzx eax, al
		mov ebx, r
		mov [ebx], eax
		mov al, mImagePtr2[esi+1]
		movzx eax, al
		mov ebx, g
		mov [ebx], eax
		mov al, mImagePtr2[esi+2]
		movzx eax, al
		mov ebx, b
		mov [ebx], eax
	.ENDIF
	pop eax
	;;;;;;;;;;;;;;;;;;;;;;;
	ret
asm_GetImageColour ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;const char *asm_getStudentInfoString()
;
;return pointer in edx
asm_getStudentInfoString PROC C
	mov eax, offset MYINFO
	ret
asm_getStudentInfoString ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_GetImageDimension(int &iw, int &ih)
; iw = mImageWidth
; ih = mImageHeight
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetImageDimension PROC C USES ebx,
	iw : PTR DWORD, ih : PTR DWORD
	;;;;;;;;;;;;;;;;;;;;;;;
	; modify it 
	mov ebx, iw
	mov eax, mImageWidth
	mov [ebx], eax
	mov ebx, ih
	mov eax, mImageHeight
	mov [ebx], eax
	;;;;;;;;;;;;;;;;;;;;;;;
	ret
asm_GetImageDimension ENDP

asm_GetImagePos PROC C USES ebx,
	x : PTR DWORD,
	y : PTR DWORD
	mov eax, canvasMinX
	mov ebx, scaleFactor
	cdq
	idiv ebx
	mov ebx, x
	mov [ebx], eax
	mov eax, canvasMinY
	mov ebx, scaleFactor
	cdq
	idiv ebx
	mov ebx, y
	mov [ebx], eax
	ret
asm_GetImagePos ENDP

AskForInput_Initialization PROC USES ebx edi esi
	mov al, blue + white*16
	or al, 88h
	mov ah, 080h
	call SetTextColor
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; add your own stuff
	call Crlf
	call Crlf
	call initSnake
	mov al, blue + white*16
	call SetTextColor
	call Clrscr
	mov ebx, OFFSET GoMsg
	mov esi, 0
L0:
	mov al, [ebx+esi]
	cmp al, 0
	je exitL0
	call WriteChar
	inc esi
	jmp L0
exitL0:
	call Crlf
	mov eax, EnterStageDelay
	call Delay
	mov eax, 0
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov ebx, OFFSET CaptionString
	mov edx, OFFSET MessageString
	call MsgBox
	ret
AskForInput_Initialization ENDP

initSnake PROC USES ebx edi esi
	;;;;;;;;;;;;;;;;;;;;;;;
	; add your own stuff 
	mov ebx, OFFSET OpeningMsg
	mov esi, 0
L0:
	mov al, [ebx+esi]
	cmp al, 0
	je exitL0
	cmp al, 13
	jne NormalChar0
	call Crlf
NormalChar0:
	call WriteChar
	mov eax, OpenMsgDelay
	call Delay
	inc esi
	jmp L0
exitL0:
	call Crlf
	mov eax, black*16+lightgreen
	;mov ah, 080h
	call SetTextColor
	mov ebx, OFFSET SetSpeed_Message
	mov esi, 0
L1:
	mov al, [ebx+esi]
	cmp al, 0
	je exitL1
	cmp al, 13
	jne NormalChar1
	call Crlf
NormalChar1:
	call WriteChar
	mov eax, OpenMsgDelay
	call Delay
	inc esi
	jmp L1
exitL1:
	call ReadInt
	js SmallSpeed
	jz SmallSpeed
	cmp eax, 200
	jg BigSpeed
	mov snakeSpeed, eax
	jmp SpeedDone
SmallSpeed:
	mov snakeSpeed, 100
	jmp SpeedDone
BigSpeed:
	mov ebx, Default_SnakeMaxSpeed
	mov snakeSpeed, ebx
SpeedDone:
	mov al, blue + white*16
	or al, 88h
	mov ah, 080h
	call SetTextColor
	mov ebx, OFFSET SetLifeCycle_Message
	mov esi, 0
L2:
	mov al, [ebx+esi]
	cmp al, 0
	je exitL2
	cmp al, 13
	jne NormalChar2
	call Crlf
NormalChar2:
	call WriteChar
	mov eax, OpenMsgDelay
	call Delay
	inc esi
	jmp L2
exitL2:
	call ReadInt
	js NotInRange
	jz NotInRange
	cmp eax, 100
	jg NotInRange
	mov snakeLifeCycle, eax
	jmp LifeCycleDone
NotInRange:
	mov ebx, default_snakeLifeCycle
	mov snakeLifeCycle, ebx
LifeCycleDone:
	;;;;;;;;;;;;;;;;;;;;;;;
	ret
initSnake ENDP 

updateSnake PROC USES ebx edx edi esi
	;;;;;;;;;;;;;;;;;;;;;;;
	; modify it
	.IF Toggle == 0
		.IF snakeMoveDirection == MOVE_LEFT
			mov eax, cur_snakeObjPosX
			sub eax, snakeSpeed
			mov cur_snakeObjPosX, eax
			cmp eax, canvasMinX
			jg safe1
			mov snakeMoveDirection, MOVE_RIGHT
			jmp safe1
safe1:
		.ELSEIF snakeMoveDirection == MOVE_RIGHT
			mov eax, cur_snakeObjPosX
			add eax, snakeSpeed
			mov cur_snakeObjPosX, eax
			cmp eax, canvasMaxX
			jl safe2
			mov snakeMoveDirection, MOVE_LEFT
			jmp safe2
safe2:
		.ELSEIF snakeMoveDirection == MOVE_UP
			mov eax, cur_snakeObjPosY
			add eax, snakeSpeed
			mov cur_snakeObjPosY, eax
			cmp eax, canvasMaxY
			jl safe3
			mov snakeMoveDirection, MOVE_DOWN
			jmp safe3
safe3:
		.ELSEIF snakeMoveDirection == MOVE_DOWN
			mov eax, cur_snakeObjPosY
			sub eax, snakeSpeed
			mov cur_snakeObjPosY, eax
			cmp eax, canvasMinY
			jg safe4
			mov snakeMoveDirection, MOVE_UP
			jmp safe4
safe4:
		.ELSEIF snakeMoveDirection == MOVE_STOP
			cmp flg_target, 0
			je Arrive
			mov eax, target_x
			sub eax, cur_snakeObjPosX
			mov ebx, eax
			mov eax, snakeSpeed
			cmp ebx, eax
			jge Bye
			neg eax
			cmp ebx, eax
			jle Bye
			mov eax, target_y
			sub eax, cur_snakeObjPosY
			mov ebx, eax
			mov eax, snakeSpeed
			cmp ebx, eax
			jge Bye
			neg eax
			cmp ebx, eax
			jle Bye
			mov flg_target, 0
Bye:
			mov ebx, target_x
			sub ebx, cur_snakeObjPosX
			mov edx, target_y
			sub edx, cur_snakeObjPosY
			mov edi, snakeSpeed		; for X
			mov esi, snakeSpeed		; for Y
			mov eax, cur_snakeObjPosX
			cmp eax, target_x
			jg L0
			mov eax, cur_snakeObjPosY
			cmp eax, target_y
			jg L1
			jmp L3
L1:
			neg edx
			neg esi
			jmp L3
L0:
			mov eax, cur_snakeObjPosY
			cmp eax, target_y
			jg L2
			neg ebx
			neg edi
			jmp L3
L2:
			neg ebx
			neg edx
			neg edi
			neg esi
L3:
			.IF ebx > edx
				mov eax, cur_snakeObjPosX
				add eax, edi
				mov cur_snakeObjPosX, eax
			.ELSEIF ebx < edx
				mov eax, cur_snakeObjPosY
				add eax, esi
				mov cur_snakeObjPosY, eax
			.ELSE
				mov eax, cur_snakeObjPosX
				add eax, edi
				mov cur_snakeObjPosX, eax
				mov eax, cur_snakeObjPosY
				add eax, esi
				mov cur_snakeObjPosY, eax
			.ENDIF
Arrive:
		.ENDIF
		.IF snakeMoveDirection != MOVE_STOP
			nop
		.ELSEIF snakeMoveDirection == MOVE_STOP && flg_target == 1
			nop
		.ELSE
			jmp STOP
		.ENDIF
		mov eax, numObjects
		dec eax
		cmp numSnakeObj, eax
		je STOP
		mov eax, snakeLifeCycle
		.IF snakeLife == eax
			mov eax, 4
			mul numSnakeObj
			sub eax, 4
			mov esi, eax
			mov ebx, OFFSET objPosX
			mov eax, cur_snakeObjPosX
			mov [ebx+esi], eax
			mov ebx, OFFSET objPosY
			mov eax, cur_snakeObjPosY
			mov [ebx+esi], eax
			;========================
			; rainbow or random or origin color mode
			.IF ColorState == COLOR_RANDOM
				mov edi, OFFSET objColor
				mov eax, 12
				mul numSnakeObj
				sub eax, 12
				mov esi, eax
				mov eax, 255
				call RandomRange
				mov [edi+esi], eax
				add esi, 4
				mov eax, 255
				call RandomRange
				mov [edi+esi], eax
				add esi, 4
				mov eax, 255
				call RandomRange
				mov [edi+esi], eax
			.ELSEIF ColorState == COLOR_RAINBOW
				.IF RainbowIdx == 0
					mov edi, OFFSET objColor
					mov eax, 12
					mul numSnakeObj
					sub eax, 12
					add edi, eax
					mov eax, 255
					mov [edi], eax
					mov eax, 0
					mov [edi+4], eax
					mov eax, 0
					mov [edi+8], eax
				.ELSEIF RainbowIdx == 1
					mov edi, OFFSET objColor
					mov eax, 12
					mul numSnakeObj
					sub eax, 12
					add edi, eax
					mov eax, 234
					mov [edi], eax
					mov eax, 97
					mov [edi+4], eax
					mov eax, 0
					mov [edi+8], eax
				.ELSEIF RainbowIdx == 2
					mov edi, OFFSET objColor
					mov eax, 12
					mul numSnakeObj
					sub eax, 12
					add edi, eax
					mov eax, 255
					mov [edi], eax
					mov eax, 255
					mov [edi+4], eax
					mov eax, 0
					mov [edi+8], eax
				.ELSEIF RainbowIdx == 3
					mov edi, OFFSET objColor
					mov eax, 12
					mul numSnakeObj
					sub eax, 12
					add edi, eax
					mov eax, 0
					mov [edi], eax
					mov eax, 255
					mov [edi+4], eax
					mov eax, 0
					mov [edi+8], eax
				.ELSEIF RainbowIdx == 4
					mov edi, OFFSET objColor
					mov eax, 12
					mul numSnakeObj
					sub eax, 12
					add edi, eax
					mov eax, 0
					mov [edi], eax
					mov eax, 0
					mov [edi+4], eax
					mov eax, 255
					mov [edi+8], eax
				.ELSEIF RainbowIdx == 5
					mov edi, OFFSET objColor
					mov eax, 12
					mul numSnakeObj
					sub eax, 12
					add edi, eax
					mov eax, 43
					mov [edi], eax
					mov eax, 0
					mov [edi+4], eax
					mov eax, 255
					mov [edi+8], eax
				.ELSEIF RainbowIdx == 6
					mov edi, OFFSET objColor
					mov eax, 12
					mul numSnakeObj
					sub eax, 12
					add edi, eax
					mov eax, 87
					mov [edi], eax
					mov eax, 0
					mov [edi+4], eax
					mov eax, 255
					mov [edi+8], eax
				.ENDIF
				inc RainbowIdx
				.IF RainbowIdx >= 7
					mov RainbowIdx, 0
				.ENDIF
			.ELSEIF ColorState == COLOR_ORIGIN
				nop
			.ENDIF
			;========================
			inc numSnakeObj
			mov snakeLife, 0
		.ELSE
			inc snakeLife
		.ENDIF
	.ENDIF
STOP:
	mov eax, 4
	mul numSnakeObj
	mov esi, eax
	mov ebx, OFFSET objPosX
	mov eax, cur_snakeObjPosX
	mov [ebx+esi], eax
	mov ebx, OFFSET objPosY
	mov eax, cur_snakeObjPosY
	mov [ebx+esi], eax
	;;;;;;;;;;;;;;;;;;;;;;;
	ret
updateSnake ENDP

END


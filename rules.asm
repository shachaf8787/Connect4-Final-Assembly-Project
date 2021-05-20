	;=============================================================
	;|| Project Name: 4 In a Row								||
	;|| Author: Shachaf Chen									||
	;|| E-Mail: shachaf8787@gmail.com							||
	;|| File Name: rules										||
	;|| File Description:										||
	;||		a sub file thats defines everything related to the:	||
	;||		game logic and rules of the game. the file defines	||
	;||		procedures and macros that: check if coloum is full	||
	;||		or blank, check which row is open in the specific	||
	;||		coloum, drop a disk into the open cell, move the	||
	;||		cursor to specific location, and print in the left	||
	;||		side which player has the turn to play now			||
	;=============================================================
	

LOCALS @@
;----------------------------------------------------------
; checks if the coloum isn't full and puts true or false in pinokio 
; 2d array
;----------------------------------------------------------
proc is_valid_location
	pusha
	mov bx, offset game_board
	getByteValue2dArray bx, 5, col_location, BOARD_COLUMS
	cmp ax, 0
	jne @@next
	mov [pinokio], TRUE
	jmp @@next1
@@next:
	mov [pinokio], FALSE
@@next1:
	popa
	ret
endp is_valid_location
;----------------------------------------------------------
; checks what is the next open row in the coloum and puts it in row_location
; 2d array
;----------------------------------------------------------
proc get_next_open_row
;Local Variables {
		sub sp, 2
		row equ [ss:bp - 2]
	;}
	pusha
	mov cl, 0
	mov bx, offset game_board
@@loop:
	row equ cl
	mov [local3], cl
	getByteValue2dArray bx, cl, col_location, BOARD_COLUMS
	cmp al, 0
	je @@end
	inc cl
	cmp cl, BOARD_ROWS
	jl @@loop
@@end:
	mov [row_location], cl
	popa
	add sp, 2 ; De-allocate local variables
	ret
endp get_next_open_row
;----------------------------------------------------------
; drops the piece in the board
; 2d array
;----------------------------------------------------------
macro drop_piece row, col, piece ; piece 1 or 2
	mov bx, offset game_board
	local1 equ row
	local2 equ col
	setByteValue2dArray piece, bx, local1, local2, BOARD_COLUMS
endm
;----------------------------------------------------------
; movs the mouse x cords into the variable [col_location]
;----------------------------------------------------------
macro mouse_to_x_cord
	pusha
	TranslateMouseCoords
	mov ax, cx
	sub ax, 60d
	mov cl, SQUARE_SIZE
	div cl
	mov [col_location], al
	popa
endm
;----------------------------------------------------------
;Description: displays the players turn and color in the top left corner
; input: message, color
; output: none
;----------------------------------------------------------
macro display_turn message, color
	; Clears a rectangle (draws in black)
	push 0 ; push x
	push 32 ; push y
	push 60 ; push width
	push 24 ; push height
	call GR_ClearRect
	utm_SetCursorPosition 0, 4
	mov dx, offset player_general_message
	call printString
	utm_SetCursorPosition 0, 5
	mov dx, offset message
	utm_PrintStrVGA color, dx, 0, 6
endm
















	;=============================================================
	;|| Project Name: 4 In a Row								||
	;|| Author: Shachaf Chen									||
	;|| E-Mail: shachaf8787@gmail.com							||
	;|| File Name: winCheck										||
	;|| File Description:										||
	;||		check if a player won the game. horizontally and    ||
	;||		vertically. + checking negatively					||
	;=============================================================
	

LOCALS @@
MACRO getCellAddress2dArrayBytesWin reg, address, row, col, num_cols
  push dx
  mov ax, num_cols
																		;mov dx, row
  xor dh, dh
  mov dl, row
  mul dx
																		;add ax, col
  xor ah, ah
  add al, col
  add ax, address
  mov reg, ax
  pop dx
ENDM


																		;Description: checks all possible winning locations
																		;and passes if or which player one 
																		; input: offset address of the 2D array, piece
																		; output: player_won equals zero one or two
	
PROC winning_move
	offset_board equ [ss:bp + 6]
	piece equ [ss:bp + 4]
	push bp
	mov  bp, sp
;LOCAL VARS{
	sub sp, 4
	row equ [ss:bp - 2]
	col equ [ss:bp - 4]
	
	;REGS:
	pusha
;}

																		;check horizontal locations for win{
		mov bx, offset_board

		MOV ch, 0    													; set Ch=0 checks colums
	@@OUTER_LOOP:       									            ; loop label
		MOV cl, 0 														; set Cl=0 checks rows
		
	@@INNER_LOOP:        									            ; loop label
		row equ cl
		col equ ch
		getCellAddress2dArrayBytesWin si, bx, row, col, BOARD_COLUMS
																		;getCellAddress2dArrayBytesWin reg, address, row, col, num_cols
		compare_5_macro piece, [si], [si+1], [si+2], [si+3]
		cmp ax, TRUE
		je @@equal

		inc cl															; set CH=CH+1
		cmp cl, BOARD_ROWS
		JL @@INNER_LOOP           									    ; jump to label @INNER_LOOP if CL<6


		inc ch															; set CH=CH+1
		cmp ch, BOARD_COLUMS-3
		JL @@OUTER_LOOP            										; jump to label @OUTER_LOOP if CX<4
	;}
	
	
	
	
	
																		;check vertical locations for win{
		
		mov bx, offset_board

		MOV ch, 0    													; set Ch=0 checks colums
	@@OUTER_LOOP1:                   									; loop label
		MOV cl, 0  														; set Cl=0 checks rows
		
	@@INNER_LOOP1:                 										; loop label
		row equ cl
		col equ ch
		getCellAddress2dArrayBytesWin si, bx, row, col, BOARD_COLUMS
																		;getCellAddress2dArrayBytesWin reg, address, row, col, num_cols
		compare_5_macro piece, [si], [si+7], [si+14], [si+21]
		cmp ax, TRUE
		je @@equal

		inc cl															; set CH=CH+1
		cmp cl, BOARD_ROWS-3
		JL @@INNER_LOOP1              									; jump to label @INNER_LOOP if CL<6


		inc ch															; set CH=CH+1
		cmp ch, BOARD_COLUMS
		JL @@OUTER_LOOP1            									; jump to label @OUTER_LOOP if CX<4
	;}
	
	

																		;check positively sloped diagonals locations for win{
	
		mov bx, offset_board

		MOV ch, 0    													; set Ch=0 checks colums
	@@OUTER_LOOP2:                  									; loop label
		MOV cl, 0 														; set Cl=0 checks rows
		
	@@INNER_LOOP2:                 										; loop label
		row equ cl
		col equ ch
		getCellAddress2dArrayBytesWin si, bx, row, col, BOARD_COLUMS
																		;getCellAddress2dArrayBytesWin reg, address, row, col, num_cols
		compare_5_macro piece, [si], [si+8], [si+16], [si+24]
		cmp ax, TRUE
		je @@equal

		inc cl															; set CH=CH+1
		cmp cl, BOARD_ROWS-3
		JL @@INNER_LOOP2             									; jump to label @INNER_LOOP if CL<6


		inc ch															; set CH=CH+1
		cmp ch, BOARD_COLUMS-3
		JL @@OUTER_LOOP2            									; jump to label @OUTER_LOOP if CX<4
	
	;}
	
																		;check negatively sloped diagonals locations for win{
	
		mov bx, offset_board

		MOV ch, 0    													; set Ch=0 checks colums
	@@OUTER_LOOP3:                   									; loop label
		MOV cl, 3  														; set Cl=0 checks rows
		
	@@INNER_LOOP3:                 										; loop label
		row equ cl
		col equ ch
		getCellAddress2dArrayBytesWin si, bx, row, col, BOARD_COLUMS
																		;getCellAddress2dArrayBytesWin reg, address, row, col, num_cols
		compare_5_macro piece, [si], [si-6], [si-12], [si-18]
		cmp ax, TRUE
		je @@equal

		inc cl															; set CH=CH+1
		cmp cl, BOARD_ROWS
		JL @@INNER_LOOP3              									; jump to label @INNER_LOOP if CL<6


		inc ch															; set CH=CH+1
		cmp ch, BOARD_COLUMS-3
		JL @@OUTER_LOOP3           										; jump to label @OUTER_LOOP if CX<4
		
	;}
	
	jmp @@not_equal
@@equal:
	push piece
	pop [player_won]
@@not_equal:
	popa
	add sp, 4 															; De-allocate local variables
	pop bp
	ret 4
ENDP winning_move

																		;board: the board you want to use
																		;piece: 1 or 2 
macro winning_move_macro board, piece
	push offset board
	push piece
	call winning_move
endm

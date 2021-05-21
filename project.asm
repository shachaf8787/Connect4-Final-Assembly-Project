.486
IDEAL
MODEL small
STACK 100h
p186
jumps
;NOWARN BRK
DATASEG
; --------------------------
;CONSTANTS {
		INCLUDE "Colors.asm" ;(All the constants are in "Colors.asm")
		BOARD_ROWS EQU 6
		BOARD_COLUMS EQU 7
		SQUARE_SIZE EQU 28
		RADIUS EQU SQUARE_SIZE/2 - 2
	;}

		
	game_board db BOARD_ROWS*BOARD_COLUMS dup (0)
	
	printNumArr 	DB 0,0,0,0,'$' 
	Print_Dec		DB 0,0,0,0,0,'$'
	ARR_DEC			DB 0,0,0,0,0
	turn db 0
	chr db 0
	selection db 0
	pinokio db False
	player_won dw 0
	
;GAME MESSAGES {
	PLAYER_ONE_MESSAGE db 'Player 1 make your selection(0-6)$'
	PLAYER_TWO_MESSAGE db 'Player 2 make your selection(0-6)$'
	PLAYER_ONE_WIN_MESSAGE db 'Congrats player one won$'
	PLAYER_TWO_WIN_MESSAGE db 'Congrats player two won$'
	player_1_bmp_win_message db 'pic1.bmp', 0
	player_2_bmp_win_message db 'pic2.bmp', 0
	player_general_message db 'player:$'
	player_1_turn_message db '  RED$'
	player_2_turn_message db ' YELLOW$'
	background db 'Background.bmp', 0
;}

;GAME LOCATIONS {
	col_location db 0
	row_location db 0


;}
;locals {
	local1 equ 0
	local2 equ 0
	local3 db 0
	local4 dw 0
;}
; --------------------------
CODESEG
    include "UtilLib.inc"
    include "GrLib.inc"  
include 'text.asm'
include 'aviProc.asm'
include 'rules.asm'
include 'winCheck.asm'
include 'print_bo.asm'
include 'FullPic.asm'
include 'openning.asm'
start:
	mov ax, @data
	mov ds, ax
; --------------------------

	    ; Init library with double buffering flag on
    mov ax, 0
    ut_init_lib ax

	gr_set_video_mode 12h ; 80x30  8x16  640x480
	call display_openning_screen

	
	gr_set_video_mode_vga ;320 * 200
	push offset game_board
	call draw_board_graphics
	display_turn player_1_turn_message, RED
	
	;start of the main game loop
	mov cx, 42 ; will run 42 times at most
main_game_loop:
	ShowMouse ;showing the mouse on the screen
	pusha
MouseLoop:
; clears the seventh row of the board
	utm_Delay 1
	push 60
	push 0
	push 200
	push 28
	call GR_ClearRect
	
	; check if there is a character to read
	mov [chr], 0
	mov ah, 1h
	int 16h
	jz noKey
; waits for character
	call readChr
; check if user asks to quit
	cmp [chr], 'q'
	je exit
noKey:

;prints a yellow or a red circle on the seventh row on the mouses x cord {
	GetMouseStatus
	TranslateMouseCoords
	cmp cx, 74 ;edge of left side
	jl no_circle ;if circle is out of range from board
	cmp cx, 246 ;edge of right side
	jg no_circle ;if circle is out of range from board
	cmp [turn], 0
	jne yellow_circle
	gr_set_color RED
	jmp red_circle
yellow_circle:
	gr_set_color YELLOW
red_circle:
	grm_FillCircle cx, 14, RADIUS
no_circle:
;}
	GetMouseStatus
	cmp bx, 01h ; check left mouse click
	jne MouseLoop ; if left click not pressed jump to mouse loop
	mouse_to_x_cord ;converts the mouse cords to columns
	popa
	utm_Delay 2
;checks if it is player 1 turn, checks if the place that was pressed is a veiled location, if not valid jumps to the start of the loop if valid continue.
;displays who's turn it is, gets the next open row, drops the piece in the location chosen, checks if player 1 won, if he did jumps to display player 1 winning message if not jumps to next.
;PLAYER 1 {
	cmp [turn], 0
	jne player2
	call is_valid_location
	cmp [pinokio], TRUE
	jne main_game_loop
	display_turn player_2_turn_message, YELLOW
	call get_next_open_row
	drop_piece row_location, col_location, 1 ; piece 1 or 2
	winning_move_macro game_board, 1
	cmp [player_won], 1
	je player_1_won
	jmp next
;}
;checks if the place that was pressed is a veiled location, if not valid jumps to the start of the loop if valid continue.
;displays who's turn it is, gets the next open row, drops the piece in the location chosen, checks if player 2 won, if he did jumps to display player 1 winning message if not jumps to next.
;PLAYER 2 {
player2:
	call is_valid_location
	cmp [pinokio], TRUE
	jne main_game_loop
	display_turn player_1_turn_message, RED
	call get_next_open_row
	drop_piece row_location, col_location, 2 ; piece 1 or 2
	winning_move_macro game_board, 2
	cmp [player_won], 2
	je player_2_won
;}
;hides the mouse, draws the board, show to mouse back again, changes the turn, loops main game loop.
next:
	HideMouse
	push offset game_board
	call draw_board_graphics
	ShowMouse
	call change_turn
	loop main_game_loop
	jmp exit
	
;displays player 1 winning message
player_1_won:
	HideMouse
	print_bmp_file player_1_bmp_win_message
	jmp exit
;displays player 2 winning message
player_2_won:
	HideMouse
	print_bmp_file player_2_bmp_win_message
; --------------------------
	
exit:
	gr_set_video_mode_txt
	mov ax, 4c00h
	int 21h
END start



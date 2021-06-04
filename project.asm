.486
jumps
IDEAL
MODEL small
STACK 100h

	;=============================================================
	;|| Project Name: 4 In a Row								||
	;|| Author: Shachaf Chen    								||
	;|| Teacher: Arik Weinstein									||
	;|| E-Mail: shachaf8787@gmail.com							||
	;|| File Name: project										||
	;|| File Description:										||
	;||		the main file of the project, this file call all the||
	;||		sub-files, and uses all the vars, procedures, macros||
	;||		and all the things. this file actually running the	||
	;||		game, and making the game work properly				||
	;=============================================================

p186
jumps
DATASEG
; --------------------------
;CONSTANTS {
		INCLUDE "Colors.asm" 							    ;(All the constants are in "Colors.asm")	
		BOARD_ROWS EQU 6 								    ;defining number of rows in the game board
		BOARD_COLUMS EQU 7 								    ;defining number of colums in the game board
		SQUARE_SIZE EQU 28 								    ;defining the size of every square of the board
		RADIUS EQU SQUARE_SIZE/2 - 2 					    ;defining the radius of the disks in the game
	;}

		
	game_board db BOARD_ROWS*BOARD_COLUMS dup (0) 		    ;defining the board of the game, storing it in an array
	
	printNumArr 	DB 0,0,0,0,'$' 							;\ 
	Print_Dec		DB 0,0,0,0,0,'$'						; - assigning arrays variables(preparing for using soon)
	ARR_DEC			DB 0,0,0,0,0							;/
	turn db 0												;reset the turn variable(presents which player can pull a disk
	chr db 0												;variable for defining which character to compare the input from the keyboard
	selection db 0											;reset the selection variable, which means the place to pull a disc
	pinokio db False										;defining the pinokio variable, this variable responsible for representing true or false
	player_won dw 0											;this variable represent which player have won the game, its will be 1 if player one is won, etc.
	
;GAME MESSAGES {
	PLAYER_ONE_MESSAGE db 'Player 1 make your selection(0-6)$';message that appear in the left of the screen, tell the player which turn is it
	PLAYER_TWO_MESSAGE db 'Player 2 make your selection(0-6)$';^^^^^^^^^^^^^^^^^^^^^^^^^^^^^the same ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	PLAYER_ONE_WIN_MESSAGE db 'Congrats player one won$'	;message to announce the winning player of the game
	PLAYER_TWO_WIN_MESSAGE db 'Congrats player two won$'	;^^^^^^^^^^^^^^^^^^the same^^^^^^^^^^^^^^^^^^^^^^^^
	player_1_bmp_win_message db 'p1won.bmp', 0				; variable that holding the the name of the winning screen for player 1
	player_2_bmp_win_message db 'p2won.bmp', 0				;^^^^^^^^^^^^^^^^^^^^^^^^^the same^^^^^^^^^^^^^^^^^^^^^^^^ but for player 2
	player_general_message db 'player:$'					;variable that holding a string which use to write "player" on the left-side screen
	player_1_turn_message db '  RED$'						;one of the constants that building the sentence: "player RED/YELLOW"
	player_2_turn_message db ' YELLOW$'						;one of the constants that building the sentence: "player RED/YELLOW"
	inst db 'inst.bmp', 0									;variable that holding the the name of the bmp file for instructions screen
	home db 'home.bmp', 0									;variable that holding the the name of the bmp file for home screen
;}

;GAME LOCATIONS {
	col_location db 0 										;variable for holding the column location, my usecase is in the main game loop, to create an accurate place where to pull a disc
	row_location db 0										;variable for holding the row location, my usecase is in the main game loop, to create an accurate place where to pull a disc


;}
;locals {
	local1 equ 0											;\*
	local2 equ 0											; \*
	local3 db 0												; /
	local4 dw 0
;}
; --------------------------
CODESEG
; ###########################################################
; # Procedure: get_keyboard_click			     			#
; # 	   	   Wait for keyboard click and put scan code	#		
; #     	   in ah										#
; # 														#
; # Credit:    Arik Weinstein - from projexam				#
; ###########################################################
proc get_keyboard_click
waitForClick:											; Loop anchor
	jz waitForClick										; If there is no click wait for click
	mov ah, 0											; Read key and clear buffer
	int 16h
	ret
endp get_keyboard_click

    include "UtilLib.inc"
    include "GrLib.inc"  
include 'text.asm'
include 'aviProc.asm'
include 'rules.asm'
include 'winCheck.asm'
include 'print_bo.asm'
include 'FullPic.asm'
start:
	mov ax, @data
	mov ds, ax
; --------------------------

	    ; Init library with double buffering flag on
    mov ax, 0
    ut_init_lib ax

	; gr_set_video_mode 12h ; 80x30  8x16  640x480
	; call display_openning_screen
	
	gr_set_video_mode_vga ;320 * 200
	
	print_bmp_file home
	WaitForClicks:
		call get_keyboard_click
		
		cmp al, 27d ;if Esc key was clicked - exit the game
		je exit
		
		cmp al, 'h' ;if h key was clicked - return to home (this screen)
		je start
		
		cmp al, 'p' ; if p key was clicked - jump to the game
		je prepareforgame
		
		cmp al, 'i' ; if i key was clicked - go to instructions screen 			
		je instructions
		jmp WaitForClicks
		
		
	instructions:
		print_bmp_file inst
		call get_keyboard_click
		cmp al, 'h'
		je start
		cmp al, 'p'
		je prepareforgame
		cmp al, 27d
		je exit
		jmp instructions
	prepareforgame:	
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
	;  Wait for key press
	call get_keyboard_click
	cmp al, 27d ;if Esc key was clicked - exit the game
		je exit
		
		cmp al, 'h' ;if h key was clicked - return to home (this screen)
		je start
		
		cmp al, 'p' ; if p key was clicked - jump to the game
		je prepareforgame
		
		cmp al, 'i' ; if i key was clicked - go to instructions screen 			
		je instructions
	jmp player_1_won
	;jmp exit
;displays player 2 winning message
player_2_won:
	HideMouse
	print_bmp_file player_2_bmp_win_message
	;wait for key press
	call get_keyboard_click
	cmp al, 27d ;if Esc key was clicked - exit the game
		je exit
		
		cmp al, 'h' ;if h key was clicked - return to home (this screen)
		je start
		
		cmp al, 'p' ; if p key was clicked - jump to the game
		je prepareforgame
		
		cmp al, 'i' ; if i key was clicked - go to instructions screen 			
		je instructions
	jmp player_2_won

; --------------------------
	
exit:
	gr_set_video_mode_txt
	mov ax, 4c00h
	int 21h
END start



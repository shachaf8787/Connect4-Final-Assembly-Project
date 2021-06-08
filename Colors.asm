	;=============================================================
	;|| Project Name: 4 In a Row								||
	;|| Author: Shachaf Chen									||
	;|| E-Mail: shachaf8787@gmail.com							||
	;|| File Name: Colors										||
	;|| File Description:										||
	;||		a sub file thats define all colors,					||
	;||		scan codes, bottons, booleans values, file modes,	||
	;||		and clock mode.										||
	;=============================================================

	;Colors ;{
		black 			EQU 0000b			;define all colors codes.
		
		blue 			EQU 0001b
		green 			EQU 0010b
		cyan			EQU 0011b
		red				EQU 0100b
		magenta			EQU 0101b
		brown			EQU 0110b
		yellow			EQU 2Ch
		
		army_green		EQU 74h
		
		light_gray		EQU 0111b
		dark_gray		EQU 1000b
		
		light_blue		EQU 1001b
		light_green		EQU 1010b
		light_cyan		EQU 1011b
		light_red		EQU 1100b
		pink			EQU 1101b
		light_brown		EQU 1110b
		orange			EQU 2Ah
		white			EQU 1111b
		
		clear_black		EQU 10h
		
		dark_red		EQU 70h
		pp_pink			EQU 59h
		
		dark_yellow		EQU 2Bh
		orange			EQU 2Ah
		white_1			EQU 1Fh
	;}
	
	
	;Scan Codes {
		ARR_U 			EQU 48h 			;define keyboard clicks. translate from computer language
		ARR_D 			EQU 50h				;to human language
		ARR_L 			EQU 4Bh
		ARR_R 			EQU 4Dh
		
		SC_SPACE		EQU 39h
		SC_ENTER		EQU 1Ch
		SC_RSHFT		EQU 36h
	;}

	;}
	
	; MAIN_MENU {
		BTN_PLAY EQU 0						;define bottons for play, help and exit
		BTN_HELP EQU 1
		BTN_EXIT EQU 2
	;}
	
	; Boolean Values {
		TRUE 	EQU 1						;bools - true=1, false=0
		FALSE 	EQU 0
	;}
	
	;FILES {
		READ  		EQU 0					;define file handling methodes
		WRITE 		EQU 1
		READ&WRITE 	EQU 2
		
		SOF			EQU 0
		CURRENT		EQU 1
		EOF			EQU 2
	;}
	
	;CLOCK {
		CLOCK_ADDRESS EQU WORD PTR ES:6Ch	;define the clock, using for count seconds.		
	;}
	

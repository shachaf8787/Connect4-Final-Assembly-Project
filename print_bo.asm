		;=============================================================
		;|| Project Name: 4 In a Row								||
		;|| Author: Shachaf Chen									||
		;|| E-Mail: shachaf8787@gmail.com							||
		;|| File Name: print_bo										||
		;|| File Description:										||
		;||		this main mission of the file is to deal with arrays||
		;||		and draw the matrix(the game table). it contains	||
		;||		procedures and macros with the ability to print 2	||
		;||		dimensional array, print a decimal number, print	||
		;||		array in backwards(reverse), print the matrix in	||
		;||		reverse, draw a circle(disk) in the given place		||
		;=============================================================
		


LOCALS @@
masm
;**************************************************************************;
 ;-----------------------------  PRINT_2D_ARRAY  ---------------------------;
 ;**************************************************************************;

  PRINT_2D_ARRAY PROC
    ; this procedure will print the given 2D array
    ; input : SI=offset address of the 2D array    ;       : BH=number of rows
    ;       : BL=number of columns 
    ; output : none

   PUSH AX                        ; push BX onto the STACK
   PUSH CX                        ; push CX onto the STACK
   PUSH DX                        ; push DX onto the STACK
   PUSH SI                        ; push SI onto the STACK
   
   MOV CX, BX                     ; set CX=BX

   @@OUTER_LOOP:                   ; loop label
     MOV CL, BL                   ; set CL=BL

     @@INNER_LOOP:                 ; loop label
       MOV AH, 2                  ; set output function
       MOV DL, 20H                ; set DL=20H
       INT 21H                    ; print a character
                             
       MOV AX, [SI]               ; set AX=[SI]
       xor ah, ah                 ; delete whatever is in ah  *use only if trying to print a db type array                     
	   CALL OUTDEC                ; call the procedure OUTDEC

       ADD SI, 1                  ; set SI=SI+2
       DEC CL                     ; set CL=CL-1
     JNZ @@INNER_LOOP              ; jump to label @INNER_LOOP if CL!=0
                           
     MOV AH, 2                    ; set output function
     MOV DL, 0DH                  ; set DL=0DH
     INT 21H                      ; print a character

     MOV DL, 0AH                  ; set DL=0AH
     INT 21H                      ; print a character

     DEC CH                       ; set CH=CH-1
   JNZ @@OUTER_LOOP                ; jump to label @OUTER_LOOP if CX!=0

   POP SI                         ; pop a value from STACK into SI
   POP DX                         ; pop a value from STACK into DX
   POP CX                         ; pop a value from STACK into CX
   POP AX                         ; pop a value from STACK into AX

   RET
 PRINT_2D_ARRAY ENDP

 ;**************************************************************************;
 ;--------------------------------  OUTDEC  --------------------------------;
 ;**************************************************************************;

 OUTDEC PROC
   ; this procedure will display a decimal number
   ; input : AX
   ; output : none

   PUSH BX                        ; push BX onto the STACK
   PUSH CX                        ; push CX onto the STACK
   PUSH DX                        ; push DX onto the STACK

   XOR CX, CX                     ; clear CX
   MOV BX, 10                     ; set BX=10

   @@OUTPUT:                       ; loop label
     XOR DX, DX                   ; clear DX
     DIV BX                       ; divide AX by BX
     PUSH DX                      ; push DX onto the STACK
     INC CX                       ; increment CX
     OR AX, AX                    ; take OR of Ax with AX
   JNE @@OUTPUT                    ; jump to label @OUTPUT if ZF=0

   MOV AH, 2                      ; set output function

   @@DISPLAY:                      ; loop label
     POP DX                       ; pop a value from STACK to DX
     OR DL, 30H                   ; convert decimal to ascii code
     INT 21H                      ; print a character
   LOOP @@DISPLAY                  ; jump to label @DISPLAY if CX!=0

   POP DX                         ; pop a value from STACK into DX
   POP CX                         ; pop a value from STACK into CX
   POP BX                         ; pop a value from STACK into BX

   RET                            ; return control to the calling procedure
 OUTDEC ENDP
 
 
 
   PRINT_2D_ARRAY_BACKWARDS PROC
    ; this procedure will print the given 2D array
    ; input : SI=offset address of the 2D array    ;       : BH=number of rows
    ;       : BL=number of columns 
    ; output : none

   PUSH AX                        ; push BX onto the STACK
   PUSH CX                        ; push CX onto the STACK
   PUSH DX                        ; push DX onto the STACK
   PUSH SI                        ; push SI onto the STACK
   
   MOV CX, BX                     ; set CX=BX

   @OUTER_LOOP:                   ; loop label
     MOV CL, BL                   ; set CL=BL

     @INNER_LOOP:                 ; loop label
       MOV AH, 2                  ; set output function
       MOV DL, 20H                ; set DL=20H
       INT 21H                    ; print a character
                             
       MOV AX, [SI]               ; set AX=[SI]
       xor ah, ah                 ; delete whatever is in ah  *use only if trying to print a db type array                     
	   CALL OUTDEC                ; call the procedure OUTDEC

       sub SI, 1                  ; set SI=SI+2
       DEC CL                     ; set CL=CL-1
     JNZ @INNER_LOOP              ; jump to label @INNER_LOOP if CL!=0
                           
     MOV AH, 2                    ; set output function
     MOV DL, 0DH                  ; set DL=0DH
     INT 21H                      ; print a character

     MOV DL, 0AH                  ; set DL=0AH
     INT 21H                      ; print a character

     DEC CH                       ; set CH=CH-1
   JNZ @OUTER_LOOP                ; jump to label @OUTER_LOOP if CX!=0

   POP SI                         ; pop a value from STACK into SI
   POP DX                         ; pop a value from STACK into DX
   POP CX                         ; pop a value from STACK into CX
   POP AX                         ; pop a value from STACK into AX

   RET
 PRINT_2D_ARRAY_BACKWARDS ENDP
 
ideal


proc print_the_board_backward
	pusha
	mov SI, offset game_board        ; set SI=offset address of ARRAY
	add si, 41
    MOV BH, BOARD_ROWS          ; number of rows
    MOV BL, BOARD_COLUMS		; number of columns
	CALL PRINT_2D_ARRAY_BACKWARDS          ; call the procedure PRINT_2D_ARRAY
	;call TEXT_NEWLINE
	popa
	ret
endp print_the_board_backward


proc print_the_board
	pusha
	mov SI, offset game_board        ; set SI=offset address of ARRAY
    MOV BH, BOARD_ROWS          ; number of rows
    MOV BL, BOARD_COLUMS		; number of columns
	CALL PRINT_2D_ARRAY          ; call the procedure PRINT_2D_ARRAY
	;call TEXT_NEWLINE
	popa
	ret
endp print_the_board



;----------------------------------------------------------
;Description: displays the board in graphic mode
; input: offset board
; output: none
;----------------------------------------------------------
proc draw_board_graphics
	offset_board equ [ss:bp + 4]
	push bp
	mov  bp, sp
;LOCAL VARS{
	sub sp, 4
	row equ [ss:bp - 2]
	col equ [ss:bp - 4]
;}

	;REGS:
	pusha
;}
											; Set initial pen color
    gr_set_color BLUE
	GRm_FillRect 60, 28, 200, 172
	
		mov bx, offset_board
		mov dx, 186  						; y cord first position
		MOV ch, 0    						; set Ch=0 checks rows
	@@OUTER_LOOP:            		      	;loop label
		MOV cl, 0  							; set Cl=0 checks colums
		
		mov [local4], 74  					; x cord first position
	@@INNER_LOOP:               		  	; loop label
		row equ ch
		mov [local3], cl
		
		getByteValue2dArray bx, row, local3, BOARD_COLUMS
		cmp ax, 0
		je @@black
		cmp ax, 1
		je @@red
		gr_set_color YELLOW
		jmp @@continue
	@@black:
	gr_set_color BLACK
	jmp @@continue
	@@red:
	gr_set_color RED
	@@continue:
											;draw circle on board{
		pusha
		push [local4]
		push dx
		push RADIUS
		call GR_FillCircle
		popa
	;}
		add [local4], SQUARE_SIZE
		inc cl								; set CH=CH+1
		cmp cl, BOARD_COLUMS
		JL @@INNER_LOOP              		; jump to label @INNER_LOOP if CL<7

		sub dx, SQUARE_SIZE
		inc ch								; set CH=CH+1
		cmp ch, BOARD_ROWS
		JL @@OUTER_LOOP            			; jump to label @OUTER_LOOP if CX<6
	;}
	popa
	add sp, 4 								; De-allocate local variables
	pop bp
	ret 2
endp draw_board_graphics

;----------------------------------------------------------
;Description: displays the bmp file given to the macro
; input: file
; output: none
;----------------------------------------------------------
macro print_bmp_file file
;puts file in filename{
	push offset filename
	push offset file
	call Strcpy
	;}
											; Process BMP file
	call OpenFile
	call ReadHeader
	call ReadPalette
	call CopyPal
	call CopyBitmap
	call CloseFile
endm



























	;=============================================================
	;|| Project Name: 4 In a Row								||
	;|| Author: Shachaf Chen									||
	;|| E-Mail: shachaf8787@gmail.com							||
	;|| File Name: aviProc										||
	;|| File Description:										||
	;||		a sub file thats defines procedures and macros for  ||
	;||		print string to the screen, read a character into	||
	;||		char variable and set cursor position				||
	;=============================================================

										; print a string on the screen assuming the string offset is in dx
proc printString
	pusha
	mov ah, 9h
	int 21h 							;interrupt that displays a string
	popa
	ret
endp printString

										; reads a character into chr
proc readChr
	pusha
										; waits for character
	mov ah, 0h
	int 16h
	mov [chr], al						; save character to [chr]
	popa
	ret
endp readChr




										;description: sets the cursor position
										;input: x_cord, y_cord
proc setCursorePosition 
	x_cord equ [byte ptr ss:bp + 6]
	y_cord equ [byte ptr ss:bp + 4]
	push bp
	mov  bp, sp
	pusha
										; print chararcter
										; set cursore location
	mov dh, y_cord 						; row
	mov dl, x_cord 						; column
	mov bh, 0 							; page number
	mov ah, 2
	int 10h
	popa
	pop bp
	ret 4
endp setCursorePosition
										;description: sets the cursor position
										;input: x_cord, y_cord
macro set_cursore_position_macro x, y
	push x
	push y
	call setCursorePosition
endm





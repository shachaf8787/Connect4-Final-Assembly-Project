;===================================================================================================
; General Utilities
;
; Written By: Oded Cnaan (oded.8bit@gmail.com)
; Site: http://odedc.net 
; Licence: GPLv3 (see LICENSE file)
; Package: UtilLib
;
; Description: 
; General common utilities 
;===================================================================================================
LOCALS @@

DATASEG
  _dss         dw    0        ; Saved DS segment
CODESEG
;------------------------------------------------------------------------
; Initialization - call at the beginning of your program
;------------------------------------------------------------------------
MACRO ut_init_lib freeMem
  local _out
  mov [_dss], ds
  cmp freeMem, FALSE
  je _out
  ; Free redundant memory take by program
  ; to allow using malloc
  call FreeProgramMem
_out:  
ENDM
;----------------------------------------------------------
; called at the beginnig of each PROC to store
; and set BP value
;----------------------------------------------------------
MACRO store_sp_bp
    push bp
	mov bp,sp
ENDM
;----------------------------------------------------------
; called at the end of each PROC to restore 
; SP and BP
;----------------------------------------------------------
MACRO restore_sp_bp
    mov sp,bp
    pop bp
ENDM
;----------------------------------------------------------
; Create 'num' local variables
;----------------------------------------------------------
MACRO define_local_vars num
  sub sp, num*2
ENDM
;----------------------------------------------------------
; Toogles a boolean memory variable
;----------------------------------------------------------
MACRO toggle_bool_var mem
  local _setone, _endtog
  push ax
  mov ax, [mem]
  cmp ax, 0
  je _setone
  mov [mem], 0
  jmp _endtog
_setone:
  mov [mem],1
_endtog:  
  pop ax
ENDM
;----------------------------------------------------------
; move two memory variables
;----------------------------------------------------------
MACRO movv from, to
	push [word ptr from]
	pop [word ptr to]
ENDM
;----------------------------------------------------------
; Compare two memory variables
;----------------------------------------------------------
MACRO cmpv var1, var2, register
  mov register, var1
  cmp register, var2
ENDM
;----------------------------------------------------------
; Return control to DOS
; code = 0 is a normal exit
;----------------------------------------------------------
MACRO return code
  mov ah, 4ch
  mov al, code
  int 21h
ENDM
;----------------------------------------------------------
; Gets the memory address of the specific (row,col) element
; in the 2d array of BYTES
;
; array2D[4][2] where 4 is the number of rows and 2 the 
; number of columns.
;
; Equivalent to a C# 2d array:
; byte[,] array2D = new byte[,] = {{1,2}, {3,4}, {5,6}, {7,8}}
;
; Input:
;   reg     - the register that will hold the result. Cannot be DX
;   address - offset of the 2d array (assuming ds segment)
;   row,col - of the required cell
;   rows_size - in the array
;
; Input cannot use AX or DX registers
;----------------------------------------------------------
if 0
MACRO getCellAddress2dArrayBytes reg, address, row, col, num_cols
  push dx
  mov ax, num_cols
  mov dx, row
  mul dx
  ;add ax, [word ptr col]
  add ax, col
  add ax, address
  mov reg, ax
  pop dx
ENDM
endif
MACRO getCellAddress2dArrayBytes reg, address, row, col, num_cols
  push dx
  mov ax, num_cols
  ;mov dx, row
  xor dh, dh
  mov dl, row
  mul dx
  ;add ax, col
  xor ah, ah
  add al, [col]
  add ax, address
  mov reg, ax
  pop dx
ENDM
;----------------------------------------------------------
; Gets the memory address of the specific (row,col) element
; in the 2d array of WORDS
;----------------------------------------------------------
MACRO getCellAddress2dArrayWords reg, address, row, col, num_cols
  mov ax, num_cols
  mov dx, row
  mul dx
  shl ax, 1       ; x2 for words
  add ax, col*2
  add ax, address
  mov reg, ax
ENDM
;----------------------------------------------------------
; Sets a byte value in the specific (row,col) element in the 
; 2d array
;----------------------------------------------------------
MACRO setByteValue2dArray value, address, row, col, num_cols
  push si
  getCellAddress2dArrayBytes si, address, row, col, num_cols
  mov [byte ptr si], value
  pop si
ENDM
;----------------------------------------------------------
; Sets a word value in the specific (row,col) element in the 
; 2d array
;----------------------------------------------------------
MACRO setWordValue2dArray value, address, row, col, num_cols
  push si
  getCellAddress2dArrayWords si, address, row, col, num_cols
  mov [word si], value
  pop si
ENDM
;----------------------------------------------------------
; Gets a byte value in the specific (row,col) element in the 
; 2d array
;----------------------------------------------------------
MACRO getByteValue2dArray address, row, col, num_cols
  push si
  getCellAddress2dArrayBytes si, address, row, col, num_cols
  xor ah, ah
  mov al, [byte ptr si]
  pop si
ENDM
;----------------------------------------------------------
; Gets a word value in the specific (row,col) element in the 
; 2d array
;----------------------------------------------------------
MACRO getWordValue2dArray address, row, col, num_cols
  push si
  getCellAddress2dArrayWords si, address, row, col, num_cols
  mov ax, [word si]
  pop si
ENDM




macro mod_number number, divider
	xor ax, ax
	mov ax, [word ptr number]
	mov bl, [byte ptr divider]
	div bl
endm
;changes the turn from 1 to 2 and from 2 to 1
proc change_turn
	pusha
	inc [turn]
	;mod_number turn, 2
	xor ax, ax
	mov al, [turn]
	mov bl, 2
	div bl
	mov [turn], ah
	popa
	ret
endp change_turn


;Description: compares all the 5 variables
;Input: 	var1, var2, var3, var4, var5
;Output: 	ax equals 1 if true and zero if false
proc compare_5
	var1 equ [ss:bp + 12]
	var2 equ [ss:bp + 10]
	var3 equ [ss:bp + 8]
	var4 equ [ss:bp + 6]
	var5 equ [ss:bp + 4]
	push bp
	mov  bp, sp
	push bx
	
	mov ax, TRUE
	mov bx, var1
	cmp bx, var2
	jne @@not_equal
	cmp bx, var3
	jne @@not_equal
	cmp bx, var4
	jne @@not_equal
	cmp bx, var5
	jne @@not_equal
	jmp @@equal
@@not_equal:
	mov ax, FALSE
@@equal:
	pop bx
	pop bp
	ret 10
endp compare_5


;Description: compares all the 5 variables
;Input: 	var1, var2, var3, var4, var5
;Output: 	ax equals 1 if true and zero if false
macro compare_5_macro var1, var2, var3, var4, var5
	mov al, var1
	xor ah, ah
	push ax
	mov al, var2
	xor ah, ah
	push ax
	mov al, var3
	xor ah, ah
	push ax
	mov al, var4
	xor ah, ah
	push ax
	mov al, var5
	xor ah, ah
	push ax
	call compare_5
endm














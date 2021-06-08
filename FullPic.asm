	;=============================================================
	;|| Project Name: 4 In a Row								||
	;|| Author: Shachaf Chen									||
	;|| E-Mail: shachaf8787@gmail.com							||
	;|| File Name: FullPic										||
	;|| File Description:										||
	;||		this file takes a picture in a bmp format, read it  ||
	;||		in 320X200 format and print it to the screen.		||
	;=============================================================
	

locals @@
DATASEG
											;filename db [byte ptr file],0
filename db 'pic1.bmp',0
filehandle dw ?
Header db 54 dup (0)
Palette db 256*4 dup (0)
ScrLine db 320 dup (0)
ErrorMsg db 'Error', 13, 10,'$'
CODESEG

											; Open file
proc OpenFile
	mov ah, 3Dh
	xor al, al
	mov dx, offset filename
	int 21h
	jc openerror
	mov [filehandle], ax
	ret
	openerror:
	mov dx, offset ErrorMsg
	mov ah, 9h
	int 21h
	ret
endp OpenFile

											; close file at end of use
proc CloseFile
	push bx
	push ax
	mov bx, [filehandle]
	mov ah, 3Eh
	int 21h
	pop ax
	pop bx
	ret
endp CloseFile
											; Read BMP file header, 54 bytes
proc ReadHeader
	mov ah,3fh
	mov bx, [filehandle]
	mov cx,54
	mov dx,offset Header
	int 21h
	ret
endp ReadHeader

											; Read BMP file color palette, 256 colors * 4 bytes (400h)
proc ReadPalette
	mov ah,3fh
	mov cx,400h
	mov dx,offset Palette
	int 21h
ret
endp ReadPalette

											; Copy the colors palette to the video memory
											; The number of the first color should be sent to port 3C8h
											; The palette is sent to port 3C9h
proc CopyPal
	mov si,offset Palette
	mov cx,256
	mov dx,3C8h
	mov al,0
											; Copy starting color to port 3C8h
	out dx,al
											; Copy palette itself to port 3C9h
	inc dx
PalLoop:
											; Note: Colors in a BMP file are saved as BGR values rather than RGB.
	mov al,[si+2] 							; Get red value.
	shr al,2 								; Max. is 255, but video palette maximal
											; value is 63. Therefore dividing by 4.
	out dx,al 								; Send it.
	mov al,[si+1]							; Set Green Value
	mov al,[si+1]
	shr al,2
	out dx,al 								; Send it.
	mov al,[si] 							; Get blue value.
	shr al,2
	out dx,al								; Send it.
	add si,4 								; Point to next color.
											; (There is a null chr. after every color.)
	loop PalLoop
	ret
endp CopyPal

											; BMP graphics are saved upside-down.
											; Read the graphic line by line (200 lines in VGA format),
											; displaying the lines from bottom to top.
proc CopyBitmap
	mov ax, 0A000h
	mov es, ax
	mov cx,200
PrintBMPLoop:
	push cx
											; di = cx*320, point to the correct screen line
	mov di,cx
	shl cx,6
	shl di,8
	add di,cx
											; Read one line
	mov ah,3fh
	mov cx,320
	mov dx,offset ScrLine
	int 21h
											; Copy one line into video memory
	cld 									; Clear direction flag, for movsb
	mov cx,320
	mov si,offset ScrLine

	rep movsb 								; Copy line to the screen
											;rep movsb is same as the following code:
											;mov es:di, ds:si
											;inc si
											;inc di
											;dec cx
											;loop until cx=0
	pop cx
	loop PrintBMPLoop
	ret
endp CopyBitmap

	;=============================================================
	;|| Project Name: 4 In a Row								||
	;|| Author: Shachaf Chen									||
	;|| E-Mail: shachaf8787@gmail.com							||
	;|| File Name: openning										||
	;|| File Description:										||
	;||		this file take a care for the opening screen of the ||
	;||		game. this file displays the intro, and the info	||
	;||		about me and the project.							||
	;=============================================================
	

locals @@
DATASEG
; -------------------------------
; Your variables here
y_cord_screen dw 0 ;the y coordinate of the opening screen
x_cord_screen dw 0 ;the x coordinate of the opening screen
openning_screen	dw 85,165,245,325,405,485,565,645
		dw 645,646,647,648,649,650,651,652,653,654,655
		dw 93,173,253,333,413,493,573,653,733,813,893,973
		dw 106,107,108,109,110,111,112,113,114;40
		dw 110,190,270,350,430,510,590,670,750,830
		dw 826,827,828,829,830,831,832,833,834
		dw 117,197,277,357,437,517,597,677,757,837
		dw 117,198,279,360,441,522,603,684,765,846
		dw 846,766,686,606,526,446,366,286,206,126
		dw 138,218,298,378,458,538,618,698,778,858
		dw 138,139,140,141,142,143,144,145
		dw 146,226,306,386,466,546,626,706,786,866
		dw 458,459,460,461,462,463,464,465;125
		dw 1128,1208,1288,1368,1448,1528,1608,1688,1768,1848
		dw 1129,1130,1131,1132,1213,1294,1373,1452,1451,1450,1449
		dw 1529,1610,1691,1772,1853
		dw 1138,1218,1298,1378,1458,1538,1618,1698,1778,1858
		dw 1139,1140,1141,1142,1143,1144,1145,1146,1147
		dw 1148,1228,1308,1388,1468,1548,1628,1708,1788,1868
		dw 1859,1860,1861,1862,1863,1864,1865,1866,1867
		dw 1152,1233,1314,1395,1476,1557,1638,1719,1800,1881;199
		dw 1802,1723,1644,1565
		dw 1646,1727,1808,1889
		dw 1810,1731,1652,1573,1494,1415,1336,1257,1178;216
author db 'C','r','e','a','t','e','d',' ','B','y',' ','S','h','a','c','h','a','f',' ','C','h','e','n',';',')',' '
continue_message db 'Press Any Key To Continue$'
projectpropertiesline1 db 'Teacher: Arik Weinstein | Year: 2021 | ID: 214797813 | School: Oded-Kadima Zoran$'
projectpropertiesline2 db 'ID: 214797813 | School: Oded-Kadima Zoran$'
; -------------------------------
CODESEG
; Description: print the openning screen
; Input: none
; Output: none
proc display_openning_screen
	pusha
	mov di, offset openning_screen ; sets di to the memory location of openning_screen
	mov cx, 216; number of times to loop
@@screen_loop:
	mov ax, [di] ;ax equals the offset of openning_screen
	mov bl, 80d ;number of x positions possible
	div bl
	mov [byte ptr x_cord_screen], ah ;שארית חלוקה 
	mov [byte ptr y_cord_screen], al;תוצאה
	utm_SetCursorPosition [x_cord_screen], [y_cord_screen]
;display char{
	mov ah, 9 
	mov al, 219   ;AL = character to display 
	mov bl, 4     ;bl = Foreground 
	mov bh, 0eh     ; bh = Background
	push cx
	mov cx, 1  ;cx = number of times to write character 
	int 10h
	pop cx
	;}
	add di, 2 ; set di to next argument in the array
	utm_Delay 1 ;call dellay of 1/18 sec
	loop @@screen_loop
	
; the program displays the authors name char by char
;{
	mov di, offset author ; sets di to the memory location of author
	mov cx, 26; number of times to loop
	mov [y_cord_screen], 25
	mov [x_cord_screen], 25
@@screen_loop1:
	mov ax, [di] ;ax equals the offset of openning_screen
	utm_SetCursorPosition [x_cord_screen], [y_cord_screen]
;display char{
	mov dl, [di]
	mov ah, 2
	int 21h
	;}
	add di, 1 ; set di to next argument in the array
	utm_Delay 2 ;call dellay of 2/18 sec
	inc [x_cord_screen]
	loop @@screen_loop1

; the program displays a wait for character message and waits for a character
;{
	mov [y_cord_screen], 27
	mov [x_cord_screen], 25
	utm_SetCursorPosition [x_cord_screen], [y_cord_screen]
	mov dx, offset continue_message
	call printString
	utm_SetCursorPosition 0, 29
	mov dx, offset projectpropertiesline1
	call printString
@@key:
	;
	;utm_PrintStrVGA 15, dx, 25, 27
	; check if there is a character to read
	mov [chr], 0
	mov ah, 1h
	int 16h
	jz @@noKey
; waits for character
	call readChr
	cmp [chr], 0
	jne @@exit
@@noKey:
	utm_Delay 2 ;call delay of 2/18 sec
	;utm_PrintStrVGA 0, dx, 25, 27
	;utm_Delay 9 ;call delay of 2/18 sec	
	jmp @@key
	
	
@@exit:
;}
	popa
	ret
endp display_openning_screen
	

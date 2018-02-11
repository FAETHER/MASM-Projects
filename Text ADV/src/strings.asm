.data

string proc
	   ;Console strings ----------------------------------------------
	   
	   num1 db 0
       msg1 db "What is your name? ",0
       msg2 db "Hello ",0
	   backquote db "'",0
	   frontquote db "'",0
	   space db "   ",0
	   welcome db " Welcome to Text Adventure!",0ah,0
	   bye db "Goodbye!",0ah,0
		
	   continue db "Do you want to continue?",0ah,0
	   error db "Invalid syntax. Try again.",0ah,0
	   yes db "Yes",0
	   no db "No",0
	   ConsTitleString db 'Text Adventure',0    ; Window title
	   
	   ; DirectX strings -----------------------------------------------
	   
	   MyClassName         db 'Directx',0            ; Our class name
       WinTitleString      db 'Graphics window',0    ; Window title
	   plainText         db "Here will be all graphics for the project.",0
	   szTexttemplate db "%d",0
	   
string endp	   

Global_Vars proc
	;-----------------------------------------------------------------------------
	; Global variables
	;-----------------------------------------------------------------------------
    hWindow         HWND    ?
    hInstance       HANDLE  ?
    IDI_ICON        equ     01h

    g_pD3D              LPDIRECT3D8             NULL
    g_pd3dDevice        LPDIRECT3DDEVICE8       NULL

    tmpfloat        FLOAT                   1.0f
    d3dcol        D3DCOLOR                00000000h;
	;g_pFontUL           LPD3DXFONT              NULL    ; Used to create the under-lined font
	;Coordinates------------------------------------------------------------------
	
	plainTextC RECT <10,10,200,30>
	
	
	
	;Macro------------------------------------------------------------------------
	
	return MACRO returnvalue
		mov eax, returnvalue ;just a macro example. 
		ret
	ENDM
Global_Vars endp
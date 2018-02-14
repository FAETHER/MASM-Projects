;include \ASM\Text ADV\src\Vertice.asm
;include \ASM\Text ADV\src\renderX.asm

.code

; This function clears the background and draws a shaded triangle.
Draw PROC
	pusha
	
	; Cleat the target with color 00000000h (black).
	; COINVOKE is defined in macros.inc. It's used to call functions through a COM interface.
	COINVOKE lpD3DDevice,IDirect3DDevice8,Clear, 0, NULL, D3DCLEAR_TARGET, 00000000h, 0, 0

	; Beginning of scene.	
	COINVOKE lpD3DDevice,IDirect3DDevice8,BeginScene

		; Set the vertex format.
		COINVOKE lpD3DDevice,IDirect3DDevice8,SetVertexShader, D3DFVF_XYZ or D3DFVF_DIFFUSE

		; Draw a triangle.		
		COINVOKE lpD3DDevice,IDirect3DDevice8,DrawPrimitiveUP, D3DPT_TRIANGLELIST, 1, ADDR vertexes, sizeof CUSTOM_VERTEX

	; End of scene.
	COINVOKE lpD3DDevice,IDirect3DDevice8,EndScene

	; Swap the front and back buffers.
	COINVOKE lpD3DDevice,IDirect3DDevice8,Present, NULL, NULL, NULL, NULL

	popa
	ret
Draw ENDP




; This functions creates a Direct3D device and sets some initial parameters.
Init PROC
	pusha
	
	; Create a D3D device. The parameters are:
	;  * Handle of owner window
	;  * Width of owner window
	;  * Height of owner window
	;  * Desired bits per pixel
	;  * Fullscreen flag (true/false)
	;
	invoke CreateD3DDevice,hWindow,XDIM,YDIM,32,0
	.if eax == FALSE
		invoke ExitProcess,0
		popa
		ret
	.endif

	; Disable Z-buffering.
	COINVOKE lpD3DDevice,IDirect3DDevice8,SetRenderState, D3DRS_ZENABLE, D3DZB_FALSE
	
	; Disable lighting.
	COINVOKE lpD3DDevice,IDirect3DDevice8,SetRenderState, D3DRS_LIGHTING, FALSE
	
	; Set the culling mode to no culling.
	COINVOKE lpD3DDevice,IDirect3DDevice8,SetRenderState, D3DRS_CULLMODE, D3DCULL_NONE


	; Transform the world matrix to move all objects "backwards".
	invoke _D3DXMatrixTranslation, ADDR worldMatrix, xtrans,ytrans, ztrans
	COINVOKE lpD3DDevice,IDirect3DDevice8,SetTransform, D3DTS_WORLD, ADDR worldMatrix
	
	; Set up a projection matrix. I'm using a right-handed coordinate system here, i.e.
	; Z grows "towards the screen".
	invoke _D3DXMatrixPerspectiveFovRH, ADDR projMatrix, fov, aspect, zNear, zFar
	COINVOKE lpD3DDevice,IDirect3DDevice8,SetTransform, D3DTS_PROJECTION, ADDR projMatrix
		
	popa
	ret
Init ENDP




WndProc PROC hWnd:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
	LOCAL crect:RECT
	LOCAL ps:PAINTSTRUCT

 	mov eax,uMsg

 	.if eax==WM_PAINT
    		invoke BeginPaint,hWnd,ADDR ps

		; Draw another frame    		
    		invoke Draw
    		
    		invoke EndPaint,hWnd,ADDR ps
    		xor eax,eax
  
  	.elseif eax==WM_KEYDOWN
    		.if wParam==VK_ESCAPE
      			invoke PostMessage,hWnd,WM_CLOSE,NULL,NULL
    		.endif
		xor eax,eax
		
  	.elseif eax==WM_DESTROY
    		invoke PostQuitMessage,0
 
	.else
 		invoke DefWindowProc,hWnd,uMsg,wParam,lParam
 	.endif
 
 	ret
WndProc ENDP




WinMain PROC hInst:DWORD,prevInstance:DWORD,cmdlinePtr:DWORD,cmdShow:DWORD
	LOCAL wc:WNDCLASSEX
	LOCAL msg:MSG

 	lea edi,wc
 	xor eax,eax
 	mov ecx,(sizeof WNDCLASSEX)/4
 	rep stosd
 	mov eax,hInst
  	mov wc.hInstance,eax
 	mov wc.cbSize, sizeof WNDCLASSEX
 	mov wc.style,CS_OWNDC or CS_HREDRAW or CS_VREDRAW
 	mov wc.lpszClassName,offset MyClassName
 	mov wc.lpfnWndProc,offset WndProc
 	invoke LoadCursor,NULL,IDC_ARROW
 	mov wc.hCursor,eax
 	mov wc.hbrBackground,0

 	invoke RegisterClassEx,ADDR wc

 	sub eax,eax 
 	invoke CreateWindowEx,NULL,ADDR MyClassName,ADDR WinTitleString,WS_OVERLAPPEDWINDOW OR WS_CLIPCHILDREN OR WS_CLIPSIBLINGS,80,80,XDIM,YDIM,eax,eax,hInst,eax
 	mov hWindow,eax

	; Initialize
	invoke Init

 	invoke ShowWindow,eax,SW_SHOWDEFAULT
 	invoke UpdateWindow,hWindow  

 	@@winmainmsgloop:
  		invoke InvalidateRect,hWindow,NULL,FALSE 
  		sub eax,eax
  		lea edi,msg
  		invoke GetMessage,edi,eax,eax,eax
  		test eax,eax
  		jz @@quitmsgposted
  		push edi
  		push edi
  		call TranslateMessage
  		call DispatchMessage
  	jmp @@winmainmsgloop
 
 	EVEN
 
 	@@quitmsgposted:

	; Destroy the D3D device.  
  	invoke DestroyD3DDevice
  	
  	mov eax,msg.wParam
 	Abort::
  	invoke ExitProcess,eax
  
  	ret
WinMain ENDP


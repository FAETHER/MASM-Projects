.code

spacefunc proc
		push offset space
		call StdOut
		;jmp cont
		ret
		spacefunc endp
		
CMPchar proc
		push 1000 
		mov ecx,3                            ;the length of the abc and def strings	
		
		cld                                  ;set the direction flag so that EDI and ESI will increase using repe
		mov esi, edx                         ;moves address of edx string into esi
		mov edi, offset [yes]
		
		repe cmpsb     						 ;#repeat compare [esi] with [edi] until ecx!=0 and current chars in strings match	
		
		cmp ecx,0                            ;#test if the above command passed until the end of strings
		
		je strings_are_equal  				 ;#if yes then strings are equal
		jmp strings_not_equal
		
		
		ret
	CMPchar endp

INPUT proc
		push 10
		push offset choice
		call StdIn 
		mov edx, offset choice
		ret
		INPUT endp
	
strings_are_equal:		
		push offset welcome 
		call StdOut
		jmp exit0
		
strings_not_equal:
		push offset bye
		call StdOut
		jmp exit0

general proc
		 
		 push offset msg1 ; put in to stack the effective add of msg1
		 call StdOut ; call console display API

		 push 1000 ; set the maximum input character
		 
		 push offset buffer ; put in to stack the effective add of input storage
		 call StdIn ; call console input API

		 push offset msg2 ; put in to stack the effective add of msg2
		 call StdOut ; call console display API
		 
		 push offset frontquote
		 call StdOut
		 
		 push offset buffer ; put in to stack the effective add of input storage
		 call StdOut ; call console display API
		 
		 push offset backquote
		 call StdOut
		 
		 call spacefunc
		 
		 push offset continue 
		 call StdOut
		 
		 call spacefunc
		 
		 push offset yes 
		 call StdOut
		 
		 call spacefunc
		 
		 push offset no 
		 call StdOut 
		 
		 call spacefunc		
		 
		 ret
general endp		 
		 
		 
		 
		 
		 
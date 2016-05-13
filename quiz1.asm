; Quiz #1 for CSCI 2525 - Assembly Language & Computer Organization
; Written by Justin Shapiro

TITLE QUIZ5.asm

INCLUDE Irvine32.inc

.data

	bottomRange = 50
	numGrades   = 20
	Fletter     = 70
	Dletter     = 68
	Cletter     = 67
	Bletter     = 66
	Aletter     = 65

	grades    WORD numGrades DUP(0)

	prompt1   BYTE "The letter grades are: ", 0
	leftP     BYTE "(", 0
	rightP    BYTE ")", 0

.code
	main PROC

		call Randomize

		mov eax, 0
		mov ecx, numGrades
		mov esi, OFFSET grades
		
		L1: mov al, bottomRange + 1
			call RandomRange
			add al, bottomRange
			call AlphaGrade
			mov WORD PTR[esi], ax
			add esi, 2
			mov eax, 0
		loop L1

		call PrintGrade
		call WaitMsg

	exit
	main ENDP

	AlphaGrade PROC

		cmp al, 59
		jle F
		cmp al, 69
		jle D
		cmp al, 79
		jle CC
		cmp al, 89
		jle B
		cmp al, 100
		jle A

		F: mov ah, Fletter
		   jmp endAlpha

		D: mov ah, Dletter
		   jmp endAlpha

		CC: mov ah, Cletter
			jmp endAlpha

		B: mov ah, Bletter
		   jmp endAlpha

		A: mov ah, Aletter
		   jmp endAlpha


		endAlpha:
	ret
	AlphaGrade ENDP

	PrintGrade PROC

		mov edx, OFFSET prompt1
		call WriteString
		call Crlf
		call Crlf
		
		mov eax, 0
		mov edx, 0
		mov dh, 2
		
		mov esi, OFFSET grades
		mov ecx, numGrades
		
		L1: mov bx, WORD PTR[esi]
			mov al, bl
			call WriteDec

			mov dl, 7
			call GotoXY

			push edx
				mov edx, OFFSET leftP
				call WriteString

				call SetText

				mov edx, OFFSET rightP
					call WriteString
			pop edx	
		
			call Crlf
			add esi, 2
			inc dh
		loop L1
	
	ret
	PrintGrade ENDP

	SetText PROC
			mov eax, 0
			mov al, bl
			cmp al, 59
			jle F
			cmp al, 69
			jle D
			cmp al, 79
			jle CC
			cmp al, 100
			jle AB
			
			F: mov eax, 4 + (14*16)
			   call SetTextColor
			   mov eax, 0
			   mov al, bh
			   jmp write_char

			D: mov eax, 0 + (14*16)
			   call SetTextColor
			   mov eax, 0
			   mov al, bh
			   jmp write_char

			CC: mov eax, 14 + (0*16)
				call SetTextColor
				mov eax, 0
				mov al, bh
				jmp write_char

			AB: mov eax, 2 + (0*16)
				call SetTextColor
				mov eax, 0
				mov al, bh
				jmp write_char
			
			write_char:
				call WriteChar
			mov eax, 7
		    call SetTextColor
	ret
	SetText ENDP
END main
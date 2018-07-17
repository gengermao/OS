; haribote-os
; TAB=4

		ORG		0xc200
		
		;调用显卡显示功能
		MOV		AL,0x13
		MOV		AH,0x00
		INT		0x10
fin:
		HLT
		JMP		fin

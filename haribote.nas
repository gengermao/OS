; haribote-os
; TAB=4
		;设置bios相关参数
		CYLS	EQU		0x0ff0	;设定启动区
		LEDS	EQU		0x0ff1		
		VMODE	EQU		0x0ff2	;设定颜色的位数
		SCRNX	EQU		0x0ff4	;分辨率x
		SCRNY	EQU		0x0ff6	;分辨率y
		VRAM	EQU		0x0ff8	;图像缓冲区
		
		ORG		0xc200
		
		;调用显卡显示功能
		MOV		AL,0x13
		MOV		AH,0x00
		INT		0x10
		MOV		BYTE [VMODE],8		;记录画面模式
		MOV		WORD [SCRNX],320
		MOV		WORD [SCRNY],200
		MOV		DWORD [VRAM],0x000a0000
		
		;用BIOS获取键盘上各种LED灯的状态
		MOV 	AH,0x02
		INT		0x16
		MOV		[LEDS],AL
		
fin:
		HLT
		JMP		fin

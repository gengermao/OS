; hello-os
; TAB=4
		
		ORG 0x7c00

; 以下这段是标准FAT12格式软盘专用代码

		JMP		entry
		DB		0x90
		DB		"GENGSGOS"		; 启动区名称（任意字符串，ansi码，8字节）
		DW		512				; 扇区大小（必须为512字节）
		DB		1				; 簇的大小（必须为1）
		DW		1				; FAT的起始位置（一般从第一个扇区开始）
		DB		2				; FAT的个数（必须为2）
		DW		224				; 根目录的大小（一般是224项）
		DW		2880			; 该磁盘的大小（必须是2880扇区）
		DB		0xf0			; 磁盘种类（必须是0xf0）
		DW		9				; FAT的长度（必须是9扇区）
		DW		18				; 1个磁道有几个扇区（必须是18）
		DW		2				; 磁头数（必须是2）
		DD		0				; 不使用分区（是0）
		DD		2880			; 重写一次磁盘大小
		DB		0,0,0x29		; 意义不明
		DD		0xffffffff		; 卷标
		DB		"HELLO-OS   "	; 磁盘的名称（11字节）
		DB		"FAT12   "		; 磁盘格式名称（8字节）
		RESB	18				; 空出18字节

; 程序本体

entry:
		MOV		AX,0			;初始化寄存器
		MOV		SS,AX			;初始化栈空间
		MOV		SP,0x7c00
		MOV		DS,AX
		
;设置在读取启动区后要读取的下一个扇区信息

		MOV 	AX,0x0820		;设置缓冲区地址，把这个扇区信息放在这个缓冲内存地址
		MOV		ES,AX
		MOV		CH,0			;柱面0
		MOV		DH,0			;磁头0
		MOV 	CL,2			;扇区2
		
		MOV		AH,0x02			;读盘
		MOV 	AL,1			;1个扇区
		MOV 	BX,0
		MOV 	DL,0x00			;A驱动器
		INT 	0x13  			;调用磁盘BIOS
		JC		error
		MOV 	SI,0
retry:
		MOV 	AH,0x02
		MOV 	AL,1			;1个扇区
		MOV 	BX,0
		MOV 	DL,0x00			;A驱动器
		INT 	0x13  			;调用磁盘BIOS
		JNC		fin				;没出错就跳到fin
		ADD 	SI,1			;出错了就尝试5次
		CMP		SI,5
		JAE 	error
		MOV		AH,0x00			;重置驱动器
		MOV 	DL,0x00
		INT 	0x13			;重试之前进行系统复位
		JMP		retry			;跳转，重新尝试
fin:
		HLT						;让CPU停止，等待指令
		JMP		fin				;无限循环

error:
		MOV 	SI,msg
putloop:
		MOV 	AL,[SI]
		ADD		SI,1
		CMP		AL,0
		
		JE		fin
		MOV		AH,0x0e			;显示一个文字
		MOV		BX,15			;指定字符颜色
		INT		0x10			;调用显卡
		JMP		putloop
msg:
		DB		0x0a, 0x0a
		DB		"load error"
		DB		0x0a
		DB		0
		
		RESB	0x7dfe-$
		
		DB 		0x55,0xaa
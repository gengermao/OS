org		0x7c00
	
	; 以下这段是标准FAT12格式软盘专用代码

	jmp		entry
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
			mov		ax,0
			mov 	DS,ax		;初始化DS寄存器
			mov 	ss,ax
			mov 	sp,0x7c00	;初始化ss寄存器
			mov 	es,ax		;初始化es寄存器
			
			mov 	si,msg
	outputloop:
			mov 	al,[si]
			cmp		al,0
			je		fin
			
			mov 	ah,0x0e
			mov 	bx,15
			int		0x10
			
			add 	si,1
			jmp		outputloop
	fin:
			hlt
			jmp 	fin
	msg:
			db 		0x0a,0x0a
			db		"welcome to geng's OS"
			db  	0x0a
			db		0
			
			
			
			
			
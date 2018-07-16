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
			
			mov  	ax,0x820
			mov 	es,ax		;初始化es寄存器
			mov 	ch,0		;柱面
			mov 	dh,0		;磁头
			mov 	cl,2		;扇区
			
	readloop:
			mov		si,0		;如果把si=0,放在next里执行，就会有两句相同的该语句了。
			
	;设置相关参数
	retry:
			mov		ah,0x02		;模式
			mov 	dl,0x00		;读取哪个盘
			mov		al,1		;读取长度
			mov		bx,0			
			int		0x13
			jnc		next
			add 	si,1
			cmp		si,5
			jae		error
			mov 	ah,0x00
			mov  	dl,0x00
			int		0x13
			jmp		retry
	
	next:
			;mov si,0 放在此处不好  
			mov		ax,es
			add		ax,0x0020
			mov		es,ax
			add		cl,1
			cmp		cl,18
			jbe		readloop
			add		dh,1
			cmp 	dh,2
			jb		readloop
			mov		dh,0
			add		ch,1
			cmp		ch,10
			jb		readloop
			
	error:
			mov  	si,msg
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
void io_hlt(void);


void HariMain(void)
{
	int i;
	char *p;
	
	p = (char *) 0xa0000;
	
	for(i =0; i <= 0xffff; i++){
		//p = i;//带入地址
		//*p = i & 0x0f;
		//*(p + i) = i & 0x0f;
		p[i] = i & 0x0f;
	}
	for(;;){
		io_hlt();
	}
}
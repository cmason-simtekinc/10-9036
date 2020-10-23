
#line 1 "main.c" /0
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
  
#line 1 "Hardware.H" /0
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
  
#line 1 "types.h" /0









 








 
 
 
 
 
 typedef unsigned short int	BOOL;			 
 typedef long			S32_T;		 
 typedef unsigned long		U32_T;		 
 typedef short int			S16_T;     		 
 typedef unsigned short int	U16_T;    		 
 typedef unsigned short int	word;    		 
 typedef char			S8_T;			 
 typedef unsigned char		U8_T;			 
 typedef unsigned char		byte;			 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
#line 88 "types.h" /1
  
  
  
  
  
 
#line 94 "types.h" /0
 
 
 
 
 
 
 
 
 
#line 20 "Hardware.H" /0
 
 
 
 
 
 sfr   P0                = 0x80;
 sfr   SP                = 0x81;
 sfr   DPL               = 0x82;
 sfr   DPH               = 0x83;
 sfr   DPP               = 0x84;
 sfr   PCON              = 0x87;
 sfr   TCON              = 0x88;
 sfr   TMOD              = 0x89;
 sfr   TL0               = 0x8A;
 sfr   TL1               = 0x8B;
 sfr   TH0               = 0x8C;
 sfr   TH1               = 0x8D;
 sfr   P1                = 0x90;
 sfr   I2CADD1           = 0x91;
 sfr   I2CADD2           = 0x92;
 sfr   I2CADD3           = 0x93;
 sfr   SCON              = 0x98;
 sfr   SBUF              = 0x99;
 sfr   I2CDAT            = 0x9A;
 sfr   I2CADD            = 0x9B;
 sfr   T3FD              = 0x9D;
 sfr   T3CON             = 0x9E;
 sfr   P2                = 0xA0;
 sfr   TIMECON           = 0xA1;
 sfr   HTHSEC            = 0xA2;
 sfr   SEC               = 0xA3;
 sfr   MIN               = 0xA4;
 sfr   HOUR              = 0xA5;
 sfr   INTVAL            = 0xA6;
 sfr   DPCON             = 0xA7;
 sfr   IE                = 0xA8;
 sfr   IEIP2             = 0xA9;
 sfr   PWMCON            = 0xAE;
 sfr   CFG841            = 0xAF;
 sfr   P3                = 0xB0;
 sfr   PWM0L             = 0xB1;
 sfr   PWM0H             = 0xB2;
 sfr   PWM1L             = 0xB3;
 sfr   PWM1H             = 0xB4;
 sfr   SPH               = 0xB7;
 sfr   IP                = 0xB8;
 sfr   ECON              = 0xB9;
 sfr   EDATA1            = 0xBC;
 sfr   EDATA2            = 0xBD;
 sfr   EDATA3            = 0xBE;
 sfr   EDATA4            = 0xBF;
 sfr   WDCON             = 0xC0;
 sfr   CHIPID            = 0xC2;
 sfr   EADRL             = 0xC6;
 sfr   EADRH             = 0xC7;
 sfr   T2CON             = 0xC8;
 sfr   RCAP2L            = 0xCA;
 sfr   RCAP2H            = 0xCB;
 sfr   TL2               = 0xCC;
 sfr   TH2               = 0xCD;
 sfr   PSW               = 0xD0;
 sfr   DMAL              = 0xD2;
 sfr   DMAH              = 0xD3;
 sfr   DMAP              = 0xD4;
 sfr   ADCCON2           = 0xD8;
 sfr   ADCDATAL          = 0xD9;
 sfr   ADCDATAH          = 0xDA;
 sfr   PSMCON            = 0xDF;
 
 sfr   DCON              = 0xE8;
 sfr   I2CCON            = 0xE8;
 sfr   ADCCON1           = 0xEF;
 sfr   B                 = 0xF0;
 sfr   ADCOFSL           = 0xF1;
 sfr   ADCOFSH           = 0xF2;
 sfr   ADCGAINL          = 0xF3;
 sfr   ADCGAINH          = 0xF4;
 sfr   ADCCON3           = 0xF5;
 sfr   SPIDAT            = 0xF7;
 sfr   SPICON            = 0xF8;
 sfr   DAC0L             = 0xF9;
 sfr   DAC0H             = 0xFA;
 sfr   DAC1L             = 0xFB;
 sfr   DAC1H             = 0xFC;
 sfr   DACCON            = 0xFD;
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 typedef struct flashpage {
 U8_T D1;
 U8_T D2;
 U8_T D3;
 U8_T D4;
 }FLASHPAGE;
 
 FLASHPAGE Flashread(U16_T pageaddress);
 void ErasePageOfFlash(U16_T pageaddr);
 U8_T WriteAPageToFlash(FLASHPAGE newdata, U16_T pageaddr);                                 
 FLASHPAGE ReadAPageFromFlash(U16_T pageaddr);                                              
 
 
 
 sfr  FPGAADDR           = 0x80;
 sbit DispTData          = 0x80;
 sbit DispClk            = 0x81;
 sbit DispCe             = 0x82;
 sbit DispRst            = 0x83;
 sbit DispRs             = 0x84;
 
 
 
 
 sbit FpgaA0             = 0x90;
 sbit FpgaA1             = 0x91;
 sbit FpgaA2             = 0x92;
 sbit FpgaA3             = 0x93;
 sbit FpgaA4             = 0x94;
 sbit FpgaA5             = 0x95;
 sbit FpgaA6             = 0x96;
 sbit FpgaA7             = 0x97;
 
 
 
 
 
 sbit cs_e15             = P2^0;
 sbit cs_e02             = P2^1;
 sbit cs_e17             = P2^2;
 sbit cs_e13             = P2^3;
 sbit HBCtrl             = P2^4;
 sbit WBCtrl             = P2^5;
 sbit WTCtrl             = P2^6;
 sbit NIWTIHCtrl         = P2^7;
 
 
 
 
 sbit DebugTmp           = P3^3;
 sbit RTS_DE             = P3^4;
 sbit a2d_wr             = P3^5;
 sbit FpgaWr      		= P3^6;
 sbit DO2_ctrl           = P3^6;
 sbit HeartBeat          = P3^6;
 sbit DO1_ctrl           = P3^7;
 
 sfr ACC                 = 0xE0;            
 
 
 
 sbit A_0                = 0xE0;
 sbit A_1                = 0xE1;
 sbit A_2                = 0xE2;
 sbit A_3                = 0xE3;
 sbit A_4                = 0xE4;
 sbit A_5                = 0xE5;
 sbit A_6                = 0xE6;
 sbit A_7                = 0xE7;
 
 
 
 
 
 
 
 
 
 
 sbit  TF1               = 0x8F;
 sbit  TR1               = 0x8E;
 sbit  TF0               = 0x8D;
 sbit  TR0               = 0x8C;
 sbit  IE1               = 0x8B;
 sbit  IT1               = 0x8A;
 sbit  IE0               = 0x89;
 sbit  IT0               = 0x88;
 
 
 
 sbit  T2EX              = 0x91;
 sbit  T2                = 0x90;
 
 
 
 sbit  SM0               = 0x9F;
 sbit  SM1               = 0x9E;
 sbit  SM2               = 0x9D;
 sbit  REN               = 0x9C;
 sbit  TB8               = 0x9B;
 sbit  RB8               = 0x9A;
 sbit  TI                = 0x99;
 sbit  RI                = 0x98;
 
 
 
 sbit  EA                = 0xAF;
 sbit  EADC              = 0xAE;
 sbit  ET2               = 0xAD;
 sbit  ES                = 0xAC;
 sbit  ET1               = 0xAB;
 sbit  EX1               = 0xAA;
 sbit  ET0               = 0xA9;
 sbit  EX0               = 0xA8;
 
 
 
 sbit  RD                = 0xB7;
 sbit  WR                = 0xB6;
 sbit  T1                = 0xB5;
 sbit  T0                = 0xB4;
 sbit  INT1              = 0xB3;
 sbit  INT0              = 0xB2;
 sbit  TXD               = 0xB1;
 sbit  RXD               = 0xB0;
 
 
 
 sbit  PSI               = 0xBF;
 sbit  PADC              = 0xBE;
 sbit  PT2               = 0xBD;
 sbit  PS                = 0xBC;
 sbit  PT1               = 0xBB;
 sbit  PX1               = 0xBA;
 sbit  PT0               = 0xB9;
 sbit  PX0               = 0xB8;
 
 
 
 sbit  PRE3              = 0xC7;
 sbit  PRE2              = 0xC6;
 sbit  PRE1              = 0xC5;
 sbit  PRE0              = 0xC4;
 sbit  WDIR              = 0xC3;
 sbit  WDS               = 0xC2;
 sbit  WDE               = 0xC1;
 sbit  WDWR              = 0xC0;
 
 
 
 sbit  TF2               = 0xCF;
 sbit  EXF2              = 0xCE;
 sbit  RCLK              = 0xCD;
 sbit  TCLK              = 0xCC;
 sbit  EXEN2             = 0xCB;
 sbit  TR2               = 0xCA;
 sbit  CNT2              = 0xC9;
 sbit  CAP2              = 0xC8;
 
 
 
 sbit  CY                = 0xD7;
 sbit  AC                = 0xD6;
 sbit  F0                = 0xD5;
 sbit  RS1               = 0xD4;
 sbit  RS0               = 0xD3;
 sbit  OV                = 0xD2;
 sbit  F1                = 0xD1;
 sbit  P                 = 0xD0;
 
 
 
 sbit  ADCI              = 0xDF;
 sbit  DMA               = 0xDE;
 sbit  CCONV             = 0xDD;
 sbit  SCONV             = 0xDC;
 sbit  CS3               = 0xDB;
 sbit  CS2               = 0xDA;
 sbit  CS1               = 0xD9;
 sbit  CS0               = 0xD8;
 
 
 
 sbit  D1                = 0xEF;
 sbit  D1EN              = 0xEE;
 sbit  D0                = 0xED;
 sbit  D0EN              = 0xEB;
 
 
 
 sbit  MDO               = 0xEF;
 sbit  MDE               = 0xEE;
 sbit  MCO               = 0xED;
 sbit  MDI               = 0xEC;
 sbit  I2CM              = 0xEB;
 sbit  I2CRS             = 0xEA;
 sbit  I2CTX             = 0xE9;
 sbit  I2CI              = 0xE8;
 
 
 
 sbit  ISPI              = 0xFF;
 sbit  WCOL              = 0xFE;
 sbit  SPE               = 0xFD;
 sbit  SPIM              = 0xFC;
 sbit  CPOL              = 0xFB;
 sbit  CPHA              = 0xFA;
 sbit  SPR1              = 0xF9;
 sbit  SPR0              = 0xF8;
 
#line 24 "main.c" /0
 
  
#line 1 "C:\KEIL\C51\INC\INTRINS.H" /0






 
 
 
 
 
 extern void          _nop_     (void);
 extern bit           _testbit_ (bit);
 extern unsigned char _cror_    (unsigned char, unsigned char);
 extern unsigned int  _iror_    (unsigned int,  unsigned char);
 extern unsigned long _lror_    (unsigned long, unsigned char);
 extern unsigned char _crol_    (unsigned char, unsigned char);
 extern unsigned int  _irol_    (unsigned int,  unsigned char);
 extern unsigned long _lrol_    (unsigned long, unsigned char);
 extern unsigned char _chkfloat_(float);
 extern void          _push_    (unsigned char _sfr);
 extern void          _pop_     (unsigned char _sfr);
 
 
 
#line 25 "main.c" /0
 
  
#line 1 "C:\KEIL\C51\INC\MATH.H" /0






 
 
 
 
 
 #pragma SAVE
 #pragma REGPARMS
 extern char  cabs  (char  val);
 extern int    abs  (int   val);
 extern long  labs  (long  val);
 extern float fabs  (float val);
 extern float sqrt  (float val);
 extern float exp   (float val);
 extern float log   (float val);
 extern float log10 (float val);
 extern float sin   (float val);
 extern float cos   (float val);
 extern float tan   (float val);
 extern float asin  (float val);
 extern float acos  (float val);
 extern float atan  (float val);
 extern float sinh  (float val);
 extern float cosh  (float val);
 extern float tanh  (float val);
 extern float atan2 (float y, float x);
 
 extern float ceil  (float val);
 extern float floor (float val);
 extern float modf  (float val, float *n);
 extern float fmod  (float x, float y);
 extern float pow   (float x, float y);
 
 #pragma RESTORE
 
 
#line 26 "main.c" /0
 
  
#line 1 "CIRCUIT.H" /0
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 extern void ext1_5thHardwareDelay(void);
 extern void extHardwareDelay(void);
 
 extern U8_T  aSevenSegXlate(U8_T ascii);
 extern U16_T aFourteenSegXlate(U8_T ascii);
 
 extern U16_T aMAX144ReadADC(void);
 extern void  aHI8045DriverLoad(U8_T xdata* bmapptr, U8_T loop);                            
 extern U8_T  aFPGARead(U8_T addr);                                                         
 extern void  aFPGAWrite(U8_T addr, U8_T dat);                                              
 
 
 
 
 extern U8_T  idata AssyVarPass1 _at_ 0x35;                                              
 
 
 
#line 27 "main.c" /0
 
  
#line 1 "C:\KEIL\C51\INC\STRING.H" /0
 
 
 
 
 
 
 
 
 
 
 
 
 
 typedef unsigned int size_t;
 
 
 
#line 18 "C:\KEIL\C51\INC\STRING.H" /1
  
 
#line 20 "C:\KEIL\C51\INC\STRING.H" /0
 
 #pragma SAVE
 #pragma REGPARMS
 extern char *strcat (char *s1, char *s2);
 extern char *strncat (char *s1, char *s2, int n);
 
 extern char strcmp (char *s1, char *s2);
 extern char strncmp (char *s1, char *s2, int n);
 
 extern char *strcpy (char *s1, char *s2);
 extern char *strncpy (char *s1, char *s2, int n);
 
 extern int strlen (char *);
 
 extern char *strchr (const char *s, char c);
 extern int strpos (const char *s, char c);
 extern char *strrchr (const char *s, char c);
 extern int strrpos (const char *s, char c);
 
 extern int strspn (char *s, char *set);
 extern int strcspn (char *s, char *set);
 extern char *strpbrk (char *s, char *set);
 extern char *strrpbrk (char *s, char *set);
 extern char *strstr  (char *s, char *sub);
 extern char *strtok  (char *str, const char *set);
 
 extern char memcmp (void *s1, void *s2, int n);
 extern void *memcpy (void *s1, void *s2, int n);
 extern void *memchr (void *s, char val, int n);
 extern void *memccpy (void *s1, void *s2, char val, int n);
 extern void *memmove (void *s1, void *s2, int n);
 extern void *memset  (void *s, char val, int n);
 #pragma RESTORE
 
 
#line 28 "main.c" /0
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 byte              devicedata[5];                                            
 byte              firmware[5];                                                
 
 
 
 static word       HrtBeatDelay;                                                            
 static word       acReset;                                                                 
 static word       acDataChange;                                                            
 static word       acFirmwareRsp;                                                           
 
 static byte       uart0_TxBuf[512];                                      
 static word       uart0_TxHead = 0;                                                        
 static word       uart0_TxTail = 0;                                                        
 static word       uart0_TxCount = 0;                                                       
 static byte       uart0_TxFlag = 0;                                                        
 static byte       uart0_RxBuf[512];                                      
 static word       uart0_RxHead = 0;                                                        
 static word       uart0_RxTail = 0;                                                        
 static byte       uart0_Mode = 0;                                                          
 static word       uart0_RxCount = 0;                                                       
 static word       olduart0_RxCount;                                                        
 static byte       MinMsgLen;                                                               
 
 
 
 void initailize_ADUC841_UART(byte t3con, t3fd);                                            
 static void UART_ISR(void);                                                                
 void UART_Write(byte c);                                                                   
 void RemoveMsgFromBuffer(byte cnt);                                                        
 void wrAD7247(word val, byte ch);
 
 
 
 
 
 
 
 
 static void UART_ISR(void) interrupt 4                                                     
 {
 if (RI)                                                                              
 {
 EA = 0;                                                                            
 if (uart0_RxCount != 512)                                        
 {
 uart0_RxBuf[uart0_RxHead] = SBUF;                                                
 uart0_RxCount++;                                                                 
 uart0_RxHead++;                                                                  
 uart0_RxHead &= (512 - 1);                                               
 }
 RI = 0;                                                                            
 EA = 1;                                                                            
 }  
 if (TI)                                                                              
 {
 EA = 0;                                                                            
 uart0_TxBuf[uart0_TxTail] = 0;                                                     
 uart0_TxTail++;                                                                    
 uart0_TxTail &= (512 - 1);                                                 
 uart0_TxCount--;                                                                   
 if ((uart0_TxFlag == 1) && (uart0_TxCount > 0))                                    
 SBUF = uart0_TxBuf[uart0_TxTail];                                                
 else                                                                               
 uart0_TxFlag = 0;                                                                
 TI = 0;                                                                            
 EA = 1;                                                                            
 }  
 }  
 
 
 
 
 
 
 
 
 
 void UART_Write(byte c)                                                                    
 {
 uart0_TxBuf[uart0_TxHead] = c;                                                       
 EA = 0;                                                                              
 uart0_TxCount++;                                                                     
 EA = 1;                                                                              
 uart0_TxHead++;                                                                      
 uart0_TxHead &= (512 - 1);                                                   
 if (!uart0_TxFlag)                                                                   
 {
 uart0_TxFlag = 1;                                                                  
 SBUF = uart0_TxBuf[uart0_TxTail];                                                  
 }
 }
 
 
 
 
 
 
 
 
 void initailize_ADUC841_UART(byte t3con, t3fd)
 { 
 T3CON       =     t3con;                                                             
 T3FD        =     t3fd;                                                              
 SCON        =     0xD0;                                                              
 ES          =     1;                                                                 
 RTS_DE      =     0;                                                                 
 }
 
 
 
 
 
 
 
 
 void RemoveMsgFromBuffer(byte cnt)
 {
 word tmp;
 
 if((uart0_RxTail+cnt) > (512 - 1))
 {
 tmp = 512 - uart0_RxTail;                                        
 memset(&uart0_RxBuf[uart0_RxTail], 0, tmp);                                        
 uart0_RxTail += cnt;                                                               
 uart0_RxTail &= (512 - 1);                                                 
 memset(&uart0_RxBuf[0], 0, uart0_RxTail);                                          
 }
 else
 {
 memset(&uart0_RxBuf[uart0_RxTail], 0, cnt);                                        
 uart0_RxTail += cnt;                                                               
 uart0_RxTail &= (512 - 1);                                                 
 }
 EA = 0;                                                                              
 uart0_RxCount -= cnt;                                                                
 EA = 1;                                                                              
 MinMsgLen = 2;                                                           
 }
 
 
 
 
 
 
 
 
 void wrAD7247(word val, byte ch)
 { 
 byte  tmp;
 
 P0      = (byte)(val >> 4);                                                          
 tmp     = 0xF0 | (((byte)(val << 4)) & 0xF0);                                        
 P2      = tmp;                                                                       
 
 P2     &= ch;                                                                        
 
 a2d_wr   = 0;                                                                        
 a2d_wr   = 1;                                                                        
 
 P2     |= 0xF0;                                                                      
 
 
 
 
 }
 
 
 
 
 
 
 
 
 void main(void)
 {
 word  index;
 byte  cmd, adr, DeviceAddress;
 
 
 
 SP = 0x50;                                                                           
 
 
 
 CFG841 |= 0x81;                                                                      
 
 
 
 
 
 
 
 memset(&uart0_TxBuf[0], 0, 512);                                   
 memset(&uart0_RxBuf[0], 0, 512);                                   
 uart0_TxHead     = 0;                                                                
 uart0_TxTail     = 0;                                                                
 uart0_TxCount    = 0;                                                                
 uart0_TxFlag     = 0;                                                                
 uart0_RxHead     = 0;                                                                
 uart0_RxTail     = 0;                                                                
 uart0_Mode       = 0;                                                                
 uart0_RxCount    = 0;                                                                
 olduart0_RxCount = 0;                                                                
 MinMsgLen        = 2;                                                    
 
 
 
 initailize_ADUC841_UART(0x82, 0x40);                                                 
 
 
 
 
 HeartBeat = 0;                                                                       
 RTS_DE = 1;                                                                          
 EA = 1;                                                                              
 
 
 
 HrtBeatDelay = 1;                                                                    
 HeartBeat = 0;                                                                       
 
 
 
 firmware[0] = 0x74;                                                                  
 firmware[1] = 0x44;                                                                  
 firmware[2] = 0x55;                                                                  
 firmware[3] = 0x2D;                                                                  
 
 
 
 acReset = 1;                                                                         
 while(1)                                                                             
 {
 DeviceAddress = P1 & 0x07;                                                         
 HrtBeatDelay--;                                                                    
 if((HeartBeat==0)&&(HrtBeatDelay <= 0x10))                                         
 {
 HeartBeat = 1;                                                                   
 HrtBeatDelay = 0x7FFF;                                                           
 }
 else if((HeartBeat==1)&&(HrtBeatDelay <= 0x10))                                    
 {
 HeartBeat = 0;                                                                   
 HrtBeatDelay = 0x0700;                                                           
 }
 if(acReset > 0)                                                                    
 {
 
 
 
 memset(&devicedata[0], 0, 5);                                     
 
 
 
 
 
 
 
 
 acDataChange  = 1;                                                               
 
 acFirmwareRsp = 0;                                                               
 acReset--;                                                                       
 }
 if(acDataChange > 0x00)                                                            
 {
 index  = devicedata[3];                                                          
 index = index << 6;                                                              
 index &= 0x0FC0;                                                                 
 index |= (devicedata[2] & 0x3F);                                                 
 wrAD7247(index, 0xFE);                                                           
 
 
 
 
 if((devicedata[4] & 0x01) == 0)                                                  
 DO1_ctrl = 0;                                                                  
 else
 DO1_ctrl = 1;                                                                  
 
 acDataChange--;                                                                  
 }
 
 
 
 
 
 
 if(acFirmwareRsp > 0x00)                                                           
 {
 
 UART_Write(0xFE);                                                    
 UART_Write(firmware[0]);                                                         
 UART_Write(firmware[1]);                                                         
 UART_Write(firmware[2]);                                                         
 UART_Write(firmware[3]);                                                         
 acFirmwareRsp--;                                                                 
 }
 
 
 
 if(uart0_RxCount >= MinMsgLen)                                                     
 {
 if(uart0_RxCount != 0)                                                           
 {
 index  = uart0_RxTail;                                                         
 cmd    = uart0_RxBuf[index];                                                   
 index++;                                                                       
 index &= (512 - 1);                                                    
 adr    = uart0_RxBuf[index];                                                   
 if(DeviceAddress == adr)                                                       
 {
 switch(cmd)                                                                  
 {
 case 0xF0 :
 MinMsgLen = 2;                                              
 if(uart0_RxCount >= MinMsgLen)                                        
 {
 acReset++;                                                          
 RemoveMsgFromBuffer(MinMsgLen);                                     
 
 }
 break;
 case 0xF5 :
 MinMsgLen = 5;                                         
 if(uart0_RxCount >= MinMsgLen)                                        
 {
 index++;                                                            
 index &= (512 - 1);                                         
 devicedata[0] = uart0_RxBuf[index];                                 
 index++;                                                            
 index &= (512 - 1);                                         
 devicedata[1] = uart0_RxBuf[index];                                 
 index++;                                                            
 index &= (512 - 1);                                         
 devicedata[2] = uart0_RxBuf[index];                                 
 index++;                                                            
 index &= (512 - 1);                                         
 devicedata[3] = uart0_RxBuf[index];                                 
 index++;                                                            
 index &= (512 - 1);                                         
 devicedata[4] = uart0_RxBuf[index];                                 
 index++;                                                            
 index &= (512 - 1);                                         
 devicedata[5] = uart0_RxBuf[index];                                 
 if(acDataChange < 0xffff) {acDataChange++;}                         
 RemoveMsgFromBuffer(MinMsgLen);                                     
 
 }
 break;
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 case 0xFE :
 MinMsgLen = 2;                                              
 if(uart0_RxCount >= MinMsgLen)                                        
 {
 acFirmwareRsp++;                                                    
 RemoveMsgFromBuffer(MinMsgLen);                                     
 
 }
 break;
 default   :
 RemoveMsgFromBuffer(1);                                          
 break;
 } 
 } 
 else
 {
 RemoveMsgFromBuffer(1);                                                
 
 }
 } 
 else
 {
 RemoveMsgFromBuffer(1);                                                  
 
 }
 } 
 } 
 }  

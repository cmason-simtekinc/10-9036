//
//========================================================================================
//     Copyright (c) 2007     Simtek, Incorporated      All rights reserved.
//
//     This is unpublished proprietary source code of Simtek, Inc
//
//     The copyright notice above does not evidence any actual or intended
//     publication of such source code.
//========================================================================================
//
//========================================================================================
// Module Name    : Hardware.H
// Purpose        : Definition of Hardware Specific Registers
// Author         : C. Mason
// Date           : June 8, 2007
// Notes          :
//
//========================================================================================
//
#include "types.h"

//========================================================================================
//                      BYTE Register                                                     //
//========================================================================================
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
//sfr   ACC               = 0xE0;
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
//========================================================================================
////                      naming constant declarations                                    //
//========================================================================================
#define gReset                      0x01
#define gBIT                        0x02
#define gDisplayChange              0x04
#define gBrightChange               0x08
#define gFirmwareRequest            0x10
#define gSwitchStatus               0x20
#define gInstSwStatus               0x40
#define gAnnun                      0x80
#define gAddressChange              0x40
#define MAX_TX_UART0_BUF_SIZE       512
#define MAX_TX_UART0_MASK           (MAX_TX_UART0_BUF_SIZE - 1)
#define MAX_RX_UART0_BUF_SIZE       512
#define MAX_RX_UART0_MASK           (MAX_RX_UART0_BUF_SIZE - 1)
//========================================================================================
//                      global variables                                                  //
//========================================================================================
//extern U8_T Flags;

typedef struct flashpage {
      U8_T D1;
      U8_T D2;
      U8_T D3;
      U8_T D4;
}FLASHPAGE;

FLASHPAGE Flashread(U16_T pageaddress);
void ErasePageOfFlash(U16_T pageaddr);
U8_T WriteAPageToFlash(FLASHPAGE newdata, U16_T pageaddr);                                // write a byte to flash memory
FLASHPAGE ReadAPageFromFlash(U16_T pageaddr);                                             // read a byte from the flash memory
//========================================================================================
// Hardware Specific P0 (0x80) Bit Registers
//========================================================================================
sfr  FPGAADDR           = 0x80;
sbit DispTData          = 0x80;
sbit DispClk            = 0x81;
sbit DispCe             = 0x82;
sbit DispRst            = 0x83;
sbit DispRs             = 0x84;
//========================================================================================
// Hardware Specific P1 (0x90) Bit Registers
//========================================================================================
//sfr  FpgaAddr           = 0x90;
sbit FpgaA0             = 0x90;
sbit FpgaA1             = 0x91;
sbit FpgaA2             = 0x92;
sbit FpgaA3             = 0x93;
sbit FpgaA4             = 0x94;
sbit FpgaA5             = 0x95;
sbit FpgaA6             = 0x96;
sbit FpgaA7             = 0x97;

//========================================================================================
// Hardware Specific P2 (0xA0) Bit Registers
//========================================================================================
//sbit XtalSel10n20       = 0xA0;
sbit cs_e15             = P2^0;
sbit cs_e02             = P2^1;
sbit cs_e17             = P2^2;
sbit cs_e13             = P2^3;
sbit HBCtrl             = P2^4;
sbit WBCtrl             = P2^5;
sbit WTCtrl             = P2^6;
sbit NIWTIHCtrl         = P2^7;

//========================================================================================
// Hardware Specific P3 (0xB0) Bit Registers
//========================================================================================
sbit DebugTmp           = P3^3;
sbit RTS_DE             = P3^4;
sbit a2d_wr             = P3^5;
sbit FpgaWr      		= P3^6;
sbit DO2_ctrl           = P3^6;
sbit HeartBeat          = P3^6;
sbit DO1_ctrl           = P3^7;

sfr ACC                 = 0xE0;           // Accumulator
//========================================================================================
// ACC (0xE0) Bit Registers
//========================================================================================
sbit A_0                = 0xE0;
sbit A_1                = 0xE1;
sbit A_2                = 0xE2;
sbit A_3                = 0xE3;
sbit A_4                = 0xE4;
sbit A_5                = 0xE5;
sbit A_6                = 0xE6;
sbit A_7                = 0xE7;

//========================================================================================
// Hardware Specific Bit Registers                                                        //
//========================================================================================

//========================================================================================
//    BIT Register.....                                                                   //
//========================================================================================
//          TCON                                                                          //
//========================================================================================
sbit  TF1               = 0x8F;
sbit  TR1               = 0x8E;
sbit  TF0               = 0x8D;
sbit  TR0               = 0x8C;
sbit  IE1               = 0x8B;
sbit  IT1               = 0x8A;
sbit  IE0               = 0x89;
sbit  IT0               = 0x88;
//========================================================================================
// P1 //
//========================================================================================
sbit  T2EX              = 0x91;
sbit  T2                = 0x90;
//========================================================================================
// SCON //
//========================================================================================
sbit  SM0               = 0x9F;
sbit  SM1               = 0x9E;
sbit  SM2               = 0x9D;
sbit  REN               = 0x9C;
sbit  TB8               = 0x9B;
sbit  RB8               = 0x9A;
sbit  TI                = 0x99;
sbit  RI                = 0x98;
//========================================================================================
// IE //
//========================================================================================
sbit  EA                = 0xAF;
sbit  EADC              = 0xAE;
sbit  ET2               = 0xAD;
sbit  ES                = 0xAC;
sbit  ET1               = 0xAB;
sbit  EX1               = 0xAA;
sbit  ET0               = 0xA9;
sbit  EX0               = 0xA8;
//========================================================================================
// P3 //
//========================================================================================
sbit  RD                = 0xB7;
sbit  WR                = 0xB6;
sbit  T1                = 0xB5;
sbit  T0                = 0xB4;
sbit  INT1              = 0xB3;
sbit  INT0              = 0xB2;
sbit  TXD               = 0xB1;
sbit  RXD               = 0xB0;
//========================================================================================
// IP //
//========================================================================================
sbit  PSI               = 0xBF;
sbit  PADC              = 0xBE;
sbit  PT2               = 0xBD;
sbit  PS                = 0xBC;
sbit  PT1               = 0xBB;
sbit  PX1               = 0xBA;
sbit  PT0               = 0xB9;
sbit  PX0               = 0xB8;
//========================================================================================
// WDCON //
//========================================================================================
sbit  PRE3              = 0xC7;
sbit  PRE2              = 0xC6;
sbit  PRE1              = 0xC5;
sbit  PRE0              = 0xC4;
sbit  WDIR              = 0xC3;
sbit  WDS               = 0xC2;
sbit  WDE               = 0xC1;
sbit  WDWR              = 0xC0;
//========================================================================================
// T2CON //
//========================================================================================
sbit  TF2               = 0xCF;
sbit  EXF2              = 0xCE;
sbit  RCLK              = 0xCD;
sbit  TCLK              = 0xCC;
sbit  EXEN2             = 0xCB;
sbit  TR2               = 0xCA;
sbit  CNT2              = 0xC9;
sbit  CAP2              = 0xC8;
//========================================================================================
// PSW //
//========================================================================================
sbit  CY                = 0xD7;
sbit  AC                = 0xD6;
sbit  F0                = 0xD5;
sbit  RS1               = 0xD4;
sbit  RS0               = 0xD3;
sbit  OV                = 0xD2;
sbit  F1                = 0xD1;
sbit  P                 = 0xD0;
//========================================================================================
// ADCCON2 //
//========================================================================================
sbit  ADCI              = 0xDF;
sbit  DMA               = 0xDE;
sbit  CCONV             = 0xDD;
sbit  SCONV             = 0xDC;
sbit  CS3               = 0xDB;
sbit  CS2               = 0xDA;
sbit  CS1               = 0xD9;
sbit  CS0               = 0xD8;
//========================================================================================
// DCON //
//========================================================================================
sbit  D1                = 0xEF;
sbit  D1EN              = 0xEE;
sbit  D0                = 0xED;
sbit  D0EN              = 0xEB;
//========================================================================================
// I2CCON //
//========================================================================================
sbit  MDO               = 0xEF;
sbit  MDE               = 0xEE;
sbit  MCO               = 0xED;
sbit  MDI               = 0xEC;
sbit  I2CM              = 0xEB;
sbit  I2CRS             = 0xEA;
sbit  I2CTX             = 0xE9;
sbit  I2CI              = 0xE8;
//========================================================================================
// SPICON //
//========================================================================================
sbit  ISPI              = 0xFF;
sbit  WCOL              = 0xFE;
sbit  SPE               = 0xFD;
sbit  SPIM              = 0xFC;
sbit  CPOL              = 0xFB;
sbit  CPHA              = 0xFA;
sbit  SPR1              = 0xF9;
sbit  SPR0              = 0xF8;
//========================================================================================
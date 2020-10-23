//
///////////////////////////////////////////////////////////////////////////////
//     Copyright (c) 2013     Simtek, Incorporated      All rights reserved.
//
//     This is unpublished proprietary source code of Simtek, Inc
//
//     The copyright notice above does not evidence any actual or intended
//     publication of such source code.
///////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////
// Module Name:CIRCUIT.H
// Purpose  : Definition of Hardware Specific Routines
// Author   : C. Mason
// Date     : August 20, 2013
// Notes    :
//
///////////////////////////////////////////////////////////////////////////////
//
#ifndef CIRCUIT_H
#define CIRCUIT_H 1

// GLOBAL PROTOTYPES //
extern void ext1_5thHardwareDelay(void);
extern void extHardwareDelay(void);

extern U8_T  aSevenSegXlate(U8_T ascii);
extern U16_T aFourteenSegXlate(U8_T ascii);
//extern void  aFourteenSegXlate(U8_T ascii);
extern U16_T aMAX144ReadADC(void);
extern void  aHI8045DriverLoad(U8_T XDATA* bmapptr, U8_T loop);                           // output the data to the display driver
extern U8_T  aFPGARead(U8_T addr);                                                        //
extern void  aFPGAWrite(U8_T addr, U8_T dat);                                             //

#define tmpvar1               0x35                                                        //
//#define tmpvar2               0x36                                                      //
//#define tmpvar3               0x37                                                      //
extern U8_T  IDATA AssyVarPass1 _at_ tmpvar1;                                             // setup an assembly and C passable variable
//extern U8_T  IDATA AssyVarPass2 _at_ tmpvar2;                                           //
//extern U16_T IDATA AssyVarPassW _at_ tmpvar1;                                           //
#endif      // end of CIRCUIT_H //

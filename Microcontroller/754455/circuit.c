//========================================================================================
//     Copyright (c) 2014     Simtek, Incorporated      All rights reserved.
//
//     This is unpublished proprietary source code of Simtek, Inc
//
//     The copyright notice above does not evidence any actual or intended
//     publication of such source code.
//========================================================================================
//
//========================================================================================
// Module Name: circuit.c
// Purpose : interface the main routines with the hardware and execute some functions in
//           assembly.
// Author : C. Mason
// Date : December 9, 2014
// Notes :
//
// Revision -
// Notes : original. cjm
//
//========================================================================================
//
//
//========================================================================================//
//                      INCLUDE FILE DECLARATIONS                                         //
//========================================================================================//
#include "types.h"                                                                        //
#include "intrins.h"                                                                      //
#include "CIRCUIT.H"                                                                      //
#include "Hardware.H"                                                                     //
//========================================================================================//
//                      GLOBAL VARIABLES DECLARATIONS                                     //
//========================================================================================//
//U8_T  IDATA AssyVarPass1 _at_ tmpvar1;                                                    //
//U8_T  IDATA AssyVarPass2 _at_ tmpvar2;                                                    //
//U16_T IDATA AssyVarPassW _at_ tmpvar1;                                                    //
//#define tmpvar4             0x38                                                        //
//static U8_T IDATA AssyVarPass3 _at_ tmpvar4;                                            //
//========================================================================================//
//                      harware pin declarations                                          //
//========================================================================================//
//sbit ADCCs			= 0x82;
//sbit ADCClk			= 0x83;
//sbit ADCDin			= 0x84;
//sbit  DispCs                  = 0xA0;
//sbit  DispClk                 = 0xA1;
//sbit  DispLoad                = 0xA2;
//sbit  DispData                = 0xA3;
//sbit  ADCClk                  = 0xA4;
//sbit  ADCDin                  = 0xA5;
//sbit  ADCCs                   = 0xA6;
//========================================================================================//
//                      LOCAL SUBPROGRAM DECLARATIONS                                     //
//========================================================================================//
//U8_T aSevenSegXlate(U8_T ascii);                                                          // translate the ASCII character into seven segment data
//U16_T aFourteenSegXlate(U8_T ascii)                                                       // translate the ASCII character into fourteen segment data
//void x100nSDelay(void);                                                                   //
//void x001uSDelay(void);                                                                   //
//void ext1_5thHardwareDelay(void);                                                         //
//void extHardwareDelay(void);                                                              //
//void aHI8045DriverLoad(U8_T XDATA* bmapptr, U8_T loop);                                   //
//                                                                                        //
//========================================================================================//
//                      ROUTINES ADDED TO MAIN                                            //
//========================================================================================//

//
// ---------------------------------------------------------------------------------------
// Function Name : aFPGARead(U8_T addr)
// Purpose       : read data from a FPGA register
// Params        : the address of the register to read
// Returns       : the data read from the FPGA
// Note          :
// ---------------------------------------------------------------------------------------
//
//U8_T aFPGARead(U8_T addr)                                                                 // write address to the FPGA and read the data from the FPGA
//{
////      U8_T tmp;
//      
//      FPGAADDR = addr;                                                                    // place the address on the port for the FPGA to read
//#pragma asm
//      nop                                                                                 // give the display time to see the change
//      nop                                                                                 // give the display time to see the change
//      nop                                                                                 // give the display time to see the change
//#pragma endasm
//      fpgaserialale = 1;                                                                        // activate the FPGA ale line
//#pragma asm
//      nop                                                                                 // give the display time to see the change
//      nop                                                                                 // give the display time to see the change
//      nop                                                                                 // give the display time to see the change
//#pragma endasm
//      fpgaserialale = 0;                                                                        // deactivate the FPGA ale line
//#pragma asm
//      nop                                                                                 // give the display time to see the change
//      nop                                                                                 // give the display time to see the change
//      nop                                                                                 // give the display time to see the change
//#pragma endasm
//      FPGAADDR = 0xFF;                                                                    // setup the FPGA communications port for reading data
//#pragma asm
//      nop                                                                                 // give the display time to see the change
//      nop                                                                                 // give the display time to see the change
//      nop                                                                                 // give the display time to see the change
//#pragma endasm
//      FpgaRd = 0;                                                                         // activate the FPGA write line to write the data into the FPGA
//#pragma asm
//      nop                                                                                 // give the display time to see the change
//      nop                                                                                 // give the display time to see the change
//      nop                                                                                 // give the display time to see the change
//      mov         tmpvar1,FPGAADDR;                                                       // read the dat from the FPGA
//      nop                                                                                 // give the display time to see the change
//      nop                                                                                 // give the display time to see the change
//      nop                                                                                 // give the display time to see the change
//#pragma endasm
//      FpgaRd = 1;                                                                         // deactivate the FPGA write line to finish the process
//      return AssyVarPass1;                                                                // pass read value back to calling routine
//}

//
// ---------------------------------------------------------------------------------------
// Function Name : aFPGAWrite(U8_T addr, U8_T dat)
// Purpose       : write data to an FPGA register
// Params        : the FPGA register address, the data to write to the register
// Returns       : void
// Note          :
// ---------------------------------------------------------------------------------------
//
//void aFPGAWrite(U8_T addr, U8_T dat)                                                       // write address and data to the FPGA
//{
//      FPGAADDR = addr;                                                                    // place the address on the port for the FPGA to read
//#pragma asm
//      nop                                                                                 // give the display time to see the change
//      nop                                                                                 // give the display time to see the change
//      nop                                                                                 // give the display time to see the change
//#pragma endasm
//      fpgaserialale = 1;                                                                        // activate the FPGA ale line
//#pragma asm
//      nop                                                                                 // give the display time to see the change
//      nop                                                                                 // give the display time to see the change
//      nop                                                                                 // give the display time to see the change
//#pragma endasm
//      fpgaserialale = 0;                                                                        // deactivate the FPGA ale line
//#pragma asm
//      nop                                                                                 // give the display time to see the change
//      nop                                                                                 // give the display time to see the change
//      nop                                                                                 // give the display time to see the change
//#pragma endasm
//      FPGAADDR = dat;                                                                     // place the data to write on the port for the FPGA to read
//#pragma asm
//      nop                                                                                 // give the display time to see the change
//      nop                                                                                 // give the display time to see the change
//      nop                                                                                 // give the display time to see the change
//#pragma endasm
//      FpgaWr = 0;                                                                         // activate the FPGA write line to write the data into the FPGA
//#pragma asm
//      nop                                                                                 // give the display time to see the change
//      nop                                                                                 // give the display time to see the change
//      nop                                                                                 // give the display time to see the change
//#pragma endasm
//      FpgaWr = 1;                                                                         // deactivate the FPGA write line to finish the process
//}


//========================================================================================
//     Copyright (c) 2007     Simtek, Incorporated      All rights reserved.              //
//                                                                                        //
//     This is unpublished proprietary source code of Simtek, Inc                         //
//                                                                                        //
//     The copyright notice above does not evidence any actual or intended                //
//     publication of such source code.                                                   //
//========================================================================================
//                                                                                        //
//========================================================================================
// Module Name : Main.c                                                                   //
// Purpose     : Main loop of program for 10-8024 (749469.hex)                            //
// Author      : C. Mason                                                                 //
// Date        : December 18, 2014                                                        //
// Notes       :                                                                          //
//                                                                                        //
//========================================================================================
// mode com2 9600,0,8,1
// assign com2 <sin >sout
//                                                                                        //
//========================================================================================
//          include file declarations                                                     //
//========================================================================================
#include "Hardware.H"                                                                     //
#include "intrins.H"                                                                      //
#include "math.H"                                                                         //
#include "CIRCUIT.H"                                                                      //
#include <string.h>
//========================================================================================
//          naming constant declarations                                                  //
//========================================================================================
#define ResetRequest          0xF0                                                        // soft reset of instrument
#define ResetReqLen              2                                                        // soft reset of instrument
#define DataChangeRequest     0xF5                                                        // change indicator bar 1 inbd
#define DataChangeReqLen         5                                                        // change indicator bar 1 inbd
//#define SetDimPnl             0x40                                                        // set panel brightness
#define Firmware              0xFE                                                        // send panel firmware version request
#define FirmwareLen              2                                                        // send panel firmware version request
#define FirmwareResponse  Firmware                                                        // send panel firmware version
#define FirmwareRspLen           5                                                        // send panel firmware version
#define DefaultMsgLen  ResetReqLen                                                        // send panel firmware version
#define OneByte                  1                                                        // send panel firmware version

//========================================================================================
//          fpga addresses definitions                                                    //
//========================================================================================
//#define aPWM0H                0xC0                                                        // address of register in the FPGA that holds PWM1 high byte of data
//#define aPWM0L                0xC1                                                        // address of register in the FPGA that holds PWM1 low byte of data

#define aControl              0x80                                                        // address of register in the FPGA that holds states of the hardware control lines
#define aIndOutBD1            0x81                                                        // address of register in the FPGA that holds states for LEDs DS40-34 for the INBD indicator bar
#define aIndOutBD2            0x82                                                        // address of register in the FPGA that holds states for LEDs DS33-27 for the INBD indicator bar
#define aIndOutBD3            0x83                                                        // address of register in the FPGA that holds states for LEDs DS26-20 for the INBD indicator bar
#define aIndOutBD4            0x84                                                        // address of register in the FPGA that holds states for LEDs DS19-13 for the INBD indicator bar
#define aIndOutBD5            0x85                                                        // address of register in the FPGA that holds states for LEDs DS12-6 for the INBD indicator bar
#define aIndOutBD6            0x86                                                        // address of register in the FPGA that holds states for LEDs DS5-1 for the INBD indicator bar
#define aIndInBD1             0x87                                                        // address of register in the FPGA that holds states for LEDs DS40-34 for the OUTBD indicator bar
#define aIndInBD2             0x88                                                        // address of register in the FPGA that holds states for LEDs DS33-27 for the OUTBD indicator bar
#define aIndInBD3             0x89                                                        // address of register in the FPGA that holds states for LEDs DS26-20 for the OUTBD indicator bar
#define aIndInBD4             0x8A                                                        // address of register in the FPGA that holds states for LEDs DS19-13 for the OUTBD indicator bar
#define aIndInBD5             0x8B                                                        // address of register in the FPGA that holds states for LEDs DS12-6 for the OUTBD indicator bar
#define aIndInBD6             0x8C                                                        // address of register in the FPGA that holds states for LEDs DS5-1 for the OUTBD indicator bar
//========================================================================================
//          variables declarations                                                        //
//========================================================================================
byte              devicedata[DataChangeReqLen];                                           //
byte              firmware[FirmwareRspLen];                                               // firmware revision information
//static byte       PnlBrtnessH;                                                            //
//static byte       PnlBrtnessL;                                                            //
//static word       acPnlBrt;                                                               //
static word       HrtBeatDelay;                                                           //
static word       acReset;                                                                //
static word       acDataChange;                                                           //
static word       acFirmwareRsp;                                                          //
//FLASHPAGE FData;                                                                        //
static byte       uart0_TxBuf[MAX_TX_UART0_BUF_SIZE];                                     //
static word       uart0_TxHead = 0;                                                       //
static word       uart0_TxTail = 0;                                                       //
static word       uart0_TxCount = 0;                                                      //
static byte       uart0_TxFlag = 0;                                                       //
static byte       uart0_RxBuf[MAX_RX_UART0_BUF_SIZE];                                     //
static word       uart0_RxHead = 0;                                                       //
static word       uart0_RxTail = 0;                                                       //
static byte       uart0_Mode = 0;                                                         //
static word       uart0_RxCount = 0;                                                      //
static word       olduart0_RxCount;                                                       //
static byte       MinMsgLen;                                                              //
//========================================================================================
//          subroutine declarations                                                       //
//========================================================================================
void initailize_ADUC841_UART(byte t3con, t3fd);                                           //
static void UART_ISR(void);                                                               //
void UART_Write(byte c);                                                                  //
void RemoveMsgFromBuffer(byte cnt);                                                       //
void wrAD7247(word val, byte ch);

//----------------------------------------------------------------------------------------
// name    : UART_ISR(void)                                                         //
// purpose       : service all interrupts caused by traffic on the serial data port       //
// params        : void                                                                   //
// returns       : void                                                                   //
// notes         :                                                                        //
//----------------------------------------------------------------------------------------
static void UART_ISR(void) interrupt 4                                                    // interrupt serivice routine for all serail UART interrupts
{
      if (RI)                                                                             // check to see if the receive interrupt flag
        {
        EA = 0;                                                                           // disable other interrupt wihle processing receive
        if (uart0_RxCount != MAX_RX_UART0_BUF_SIZE)                                       // make sure the buffer is not full
          {
          uart0_RxBuf[uart0_RxHead] = SBUF;                                               // save the newly received data
          uart0_RxCount++;                                                                // updated received count to show the new byte
          uart0_RxHead++;                                                                 // update pointer to next receive buffer location
          uart0_RxHead &= MAX_RX_UART0_MASK;                                              // make sure the pointer does not go outside buffer space
          }
        RI = 0;                                                                           // clear the byte recieved interrupt flag
        EA = 1;                                                                           // reenable all interrupts
        } // End of if(RI)
      if (TI)                                                                             // check to see if the transmit interrupt flag
        {
        EA = 0;                                                                           // disable all interrupts
        uart0_TxBuf[uart0_TxTail] = 0;                                                    // clear the transmit buffer location of the last transmitted byte
        uart0_TxTail++;                                                                   // update the transmit buffer tail index
        uart0_TxTail &= MAX_TX_UART0_MASK;                                                // mask the index to make sure to stay within the buffer
        uart0_TxCount--;                                                                  // update the count of bytes in the buffer
        if ((uart0_TxFlag == 1) && (uart0_TxCount > 0))                                   // check to see if there is more data to transmit
          SBUF = uart0_TxBuf[uart0_TxTail];                                               // transmit the next byte in the transmit buffer
        else                                                                              // no more data to transmit
          uart0_TxFlag = 0;                                                               // clear the first byte transmit flag
        TI = 0;                                                                           // clear the byte transmitted interrupt flag
        EA = 1;                                                                           // reenable all interrupts
        } // End of if(TI)
} // End of UART_Int

//----------------------------------------------------------------------------------------
// name    : UART_Write(byte c)                                                     //
// purpose       : write data to the serial port transmit buffer for transmission, and to //
//                 start the transmission process if it is not started.                   //
// params        : data byte to write to the buffer                                       //
// returns       : void                                                                   //
// notes         :                                                                        //
//----------------------------------------------------------------------------------------
void UART_Write(byte c)                                                                   //
{
      uart0_TxBuf[uart0_TxHead] = c;                                                      // write the new byte to the transmit buffer
      EA = 0;                                                                             // diable all interrupts
      uart0_TxCount++;                                                                    // update the number of bytes in the transmit buffer
      EA = 1;                                                                             // reenable all interrupts
      uart0_TxHead++;                                                                     // update the index to the next byte in the transmit buffer
      uart0_TxHead &= MAX_TX_UART0_MASK;                                                  // make sure the index stays within the buffer
      if (!uart0_TxFlag)                                                                  // check to see if this is the first byte to transmit
        {
        uart0_TxFlag = 1;                                                                 // set the first byte transmitted flag
        SBUF = uart0_TxBuf[uart0_TxTail];                                                 // transmit the byte
        }
}

//----------------------------------------------------------------------------------------
// name    : initailize_ADUC841_UART(byte t3con, t3fd)                              //
// purpose       : setup the internal UART                                                //
// params        : divider and fractional divider data                                    //
// returns       : void                                                                   //
// notes         :                                                                        //
//----------------------------------------------------------------------------------------
void initailize_ADUC841_UART(byte t3con, t3fd)
{// setup serial port for 8 bits, baud at 38400(mode 1, 8 bit uart)
      T3CON       =     t3con;                                                            // set the divider to 5 for 38400
      T3FD        =     t3fd;                                                             // set the fractional divide to 01 for 38400
      SCON        =     0xD0;                                                             // set serial port to mode 1 (8 bit uart)
      ES          =     1;                                                                // enable serial interrupts (ie register)
      RTS_DE      =     0;                                                                // disable the transmitter
}

//----------------------------------------------------------------------------------------
// name    : RemoveMsgFromBuffer(byte cnt)                                          //
// purpose       : remove a processed or error message from the serial receive buffer     //
// params        : size of the message to remove from the buffer                          //
// returns       : void                                                                   //
// notes         :                                                                        //
//----------------------------------------------------------------------------------------
void RemoveMsgFromBuffer(byte cnt)
{
      word tmp;

      if((uart0_RxTail+cnt) > MAX_RX_UART0_MASK)
        {
        tmp = MAX_RX_UART0_BUF_SIZE - uart0_RxTail;                                       // find the number of bytes until the end of the buffer
        memset(&uart0_RxBuf[uart0_RxTail], 0, tmp);                                       // remove the message from the buffer
        uart0_RxTail += cnt;                                                              // update the array index
        uart0_RxTail &= MAX_RX_UART0_MASK;                                                // make sure the index does not point outside buffer space
        memset(&uart0_RxBuf[0], 0, uart0_RxTail);                                         // remove the message from the buffer
        }
      else
        {
        memset(&uart0_RxBuf[uart0_RxTail], 0, cnt);                                       // remove the message from the buffer
        uart0_RxTail += cnt;                                                              // update the array index
        uart0_RxTail &= MAX_RX_UART0_MASK;                                                // make sure the index does not point outside buffer space
        }
      EA = 0;                                                                             // disable interrupts
      uart0_RxCount -= cnt;                                                               // update counter to reflect number of bytes still in the buffer
      EA = 1;                                                                             // renable interrupts
      MinMsgLen = DefaultMsgLen;                                                          // reset the minimum message length to the default
}

//----------------------------------------------------------------------------------------
// name    : wrAD7247                                                                     //
// purpose : write a given channel to the a2d                                             //
// params  : value to write                                                               //
// returns : void                                                                         //
// notes   :                                                                              //
//----------------------------------------------------------------------------------------
void wrAD7247(word val, byte ch)
{// value bits 3 - 0 to p2.7-4, value bits 11 - 4 to p0.7-0
      byte  tmp;
      // write data to port
      P0      = (byte)(val >> 4);                                                         // place bits 11 - 4 on the port pins to write to the a2d
      tmp     = 0xF0 | (((byte)(val << 4)) & 0xF0);                                       // combine bits 3-0 of port 2 with bits 3-0 of the value
      P2      = tmp;                                                                      // place bits 3-0 for a2d on the port pins

      P2     &= ch;                                                                       // activate the a2d channel to update

      a2d_wr   = 0;                                                                       // write the new value to the a2d
      a2d_wr   = 1;                                                                       // deactivate write

      P2     |= 0xF0;                                                                     // disable all a2d chip selects
//    cs_e15 = 1;                                                                         //
//    cs_e02 = 1;                                                                         //
//    cs_e17 = 1;                                                                         //
//    cs_e13 = 1;                                                                         //
}

//----------------------------------------------------------------------------------------
// name    : main(void)                                                                   //
// purpose       : create the main loop                                                   //
// params        : void                                                                   //
// returns       : void                                                                   //
// notes         :                                                                        //
//----------------------------------------------------------------------------------------
void main(void)
{
      word  index;
      byte  cmd, adr, DeviceAddress;
//========================================================================================
//          set the stack pointer                                                         //
//========================================================================================
      SP = 0x50;                                                                          // relocate the stack
//========================================================================================
//          enable the internal extended RAM                                              //
//========================================================================================
      CFG841 |= 0x81;                                                                     // add the internal external RAM mapping switch bit and stack exspansion bit
//========================================================================================
//          initailize ADuC internal PWM                                                  //
//========================================================================================
//      initailize_ADUC841_PWM();                                                           // setup PWM for __% max duty cycle and 256 bits of resolution 16bit programmable pulse and cycle time
//========================================================================================
//          initailize ADuC internal UART                                                 //
//========================================================================================
      memset(&uart0_TxBuf[0], 0, MAX_TX_UART0_BUF_SIZE);                                  // blank out the buffer
      memset(&uart0_RxBuf[0], 0, MAX_RX_UART0_BUF_SIZE);                                  // blank out the buffer
      uart0_TxHead     = 0;                                                               // zero out the transmit buffer head pointer
      uart0_TxTail     = 0;                                                               // zero out the transmit buffer tail pointer
      uart0_TxCount    = 0;                                                               // clear the transmit mode flag
      uart0_TxFlag     = 0;                                                               // zero out the transmitted data counter
      uart0_RxHead     = 0;                                                               // zero out the receive buffer head pointer
      uart0_RxTail     = 0;                                                               // zero out the receive buffer tail pointer
      uart0_Mode       = 0;                                                               // clear the receive mode flag
      uart0_RxCount    = 0;                                                               // zero out the received data counter
      olduart0_RxCount = 0;                                                               //
      MinMsgLen        = DefaultMsgLen;                                                   // initailize the minimum message length to the smallest full message length
//========================================================================================
//          testing baud rate 115200 @ 14.7456Mhz                                         //
//========================================================================================
      initailize_ADUC841_UART(0x82, 0x40);                                                // initailize the com port for 115200 bps, mode 1, 8 bit uart, odd parity
//========================================================================================
//          initailize serial transmitter hardware                                        //
//========================================================================================
//      HalfnFull = 0;                                                                      // set RS422 buss to full duplex
      HeartBeat = 0;                                                                      // turn on the heart beat
      RTS_DE = 1;                                                                         // enable the transmitter
      EA = 1;                                                                             // enable all interrupts
//========================================================================================
//          initailize all internal hardware variables                                    //
//========================================================================================
      HrtBeatDelay = 1;                                                                   // intailize the heart beat counter
      HeartBeat = 0;                                                                      // turn on the heart beat
//========================================================================================
//          initialize all harware control pins                                           //
//========================================================================================
      firmware[0] = 0x74;                                                                 // initailize the microcontroller firmware revision information
      firmware[1] = 0x44;                                                                 // initailize the microcontroller firmware revision information
      firmware[2] = 0x55;                                                                 // initailize the microcontroller firmware revision information
      firmware[3] = 0x2D;                                                                 // initailize the microcontroller firmware revision information
//========================================================================================
//          set the reset action counter to execute the reset procedure                   //
//========================================================================================
      acReset = 1;                                                                        // for a initail reset of values
      while(1)                                                                            // keep going until dead
        {
        DeviceAddress = P1 & 0x07;                                                        // get the set address
        HrtBeatDelay--;                                                                   // update heartbeat counter
        if((HeartBeat==0)&&(HrtBeatDelay <= 0x10))                                        // check if the heart beat is ready to be turned off
          {
          HeartBeat = 1;                                                                  // turn LED off
          HrtBeatDelay = 0x7FFF;                                                          // set the delay for off state
          }
        else if((HeartBeat==1)&&(HrtBeatDelay <= 0x10))                                   // check if the heart beat is ready to be turned on
          {
          HeartBeat = 0;                                                                  // turn LED on
          HrtBeatDelay = 0x0700;                                                          // set the delay for on state
          }
        if(acReset > 0)                                                                   // check to see if a reset has been requested
          {
//========================================================================================
//          reset the ddata registers                                                     //
//========================================================================================
          memset(&devicedata[0], 0, DataChangeReqLen);                                    // blank out the buffer
//========================================================================================
//          initailize all of the harware values                                          //
//========================================================================================
//          PnlBrtnessH   = 0x00;                                                           // reset lighting to power on state
//          PnlBrtnessL   = 0x00;                                                           // reset lighting to power on state
//========================================================================================
//          set the action counters to reset the indicator for the user viewpoint         //
//========================================================================================
          acDataChange  = 1;                                                              // set the action counter to output new data to the displays one time to show the reset value
//          acPnlBrt      = 1;                                                              // set the action counter to output new data to the displays one time to show the reset value
          acFirmwareRsp = 0;                                                              // clear the firmware response action counter
          acReset--;                                                                      // clear the reset flag
          }
        if(acDataChange > 0x00)                                                           // check to see if the indicators needs to be updated
          {
          index  = devicedata[3];                                                         // get the high byte
          index = index << 6;                                                             // put the data into the correct bit position
          index &= 0x0FC0;                                                                // mask off any other data
          index |= (devicedata[2] & 0x3F);                                                // mask off extra data and combine with high byte to get DAC setting
          wrAD7247(index, 0xFE);                                                          // write value to a2d channel 1 (E15)
//          wrAD7247(index, 0xFD);                                                          // write value to a2d channel 2 (E02)
//          wrAD7247(index, 0xFB);                                                          // write value to a2d channel 3 (E17)
//          wrAD7247(index, 0xF7);                                                          // write value to a2d channel 4 (E13)

          if((devicedata[4] & 0x01) == 0)                                                 // check the flag control bit state
            DO1_ctrl = 0;                                                                 // hide the flag
          else
            DO1_ctrl = 1;                                                                 // show the flag

          acDataChange--;                                                                 // update the INBD indicator bar update action counter
          }
//        if(acPnlBrt > 0x00)                                                               // check to see if the panel cimming needs to be updated
//          {
//          aFPGAWrite(aPWM0H, PnlBrtnessH);                                                // write the high byte of data to the PWM regsiter in the FPGA
//          aFPGAWrite(aPWM0L, PnlBrtnessL);                                                // write the low byte of data to the PWM regsiter in the FPGA
//          acPnlBrt--;                                                                     // clear the display change request flag
//          }
        if(acFirmwareRsp > 0x00)                                                          // check to see if the firmware revision information has been requested
          {
//#define FirmwareRspLen           5                                                        // send panel firmware version
          UART_Write(FirmwareResponse);                                                   // write the firmware response to the UART transmission buffer
          UART_Write(firmware[0]);                                                        // write the firmware information to the UART transmission buffer
          UART_Write(firmware[1]);                                                        // write the firmware information to the UART transmission buffer
          UART_Write(firmware[2]);                                                        // write the firmware information to the UART transmission buffer
          UART_Write(firmware[3]);                                                        // write the firmware information to the UART transmission buffer
          acFirmwareRsp--;                                                                // update the firmware revision response action counter
          }
//========================================================================================
//          serial routines                                                               //
//========================================================================================
        if(uart0_RxCount >= MinMsgLen)                                                    // check for the minimum message size
          {
          if(uart0_RxCount != 0)                                                          // make sure at least a command and start byte were recieved and recieve count is not zero
            {
            index  = uart0_RxTail;                                                        // copy the tail index to use in the processing of the buffer
            cmd    = uart0_RxBuf[index];                                                  // get the command
            index++;                                                                      // update array pointer to next byte
            index &= MAX_RX_UART0_MASK;                                                   // make sure the pointer does not go outside buffer space
            adr    = uart0_RxBuf[index];                                                  // get the address
            if(DeviceAddress == adr)                                                      // make sure that the received address matches the hardware address
              {
              switch(cmd)                                                                 // find which command
                {
                case ResetRequest :
                     MinMsgLen = ResetReqLen;                                             // reset the minimum message length to the default
                     if(uart0_RxCount >= MinMsgLen)                                       // check to see if all the bytes for this message were recieved
                       {
                       acReset++;                                                         // update the reset action counter
                       RemoveMsgFromBuffer(MinMsgLen);                                    // remove the message from the recieve buffer
//                       MinMsgLen = DefaultMsgLen;                                         // reset the minimum message length to the default
                       }
                     break;
                case DataChangeRequest :
                     MinMsgLen = DataChangeReqLen;                                        // set the minimum message length to this message length to reduce main loop process time
                     if(uart0_RxCount >= MinMsgLen)                                       // check to see if all the bytes for this message were recieved
                       {
                       index++;                                                           // update array pointer to next byte
                       index &= MAX_RX_UART0_MASK;                                        // make sure the pointer does not go outside buffer space
                       devicedata[0] = uart0_RxBuf[index];                                // get the 13th byte of bar graph data
                       index++;                                                           // update array pointer to next byte
                       index &= MAX_RX_UART0_MASK;                                        // make sure the pointer does not go outside buffer space
                       devicedata[1] = uart0_RxBuf[index];                                // get the 13th byte of bar graph data
                       index++;                                                           // update array pointer to next byte
                       index &= MAX_RX_UART0_MASK;                                        // make sure the pointer does not go outside buffer space
                       devicedata[2] = uart0_RxBuf[index];                                // get the 13th byte of bar graph data
                       index++;                                                           // update array pointer to next byte
                       index &= MAX_RX_UART0_MASK;                                        // make sure the pointer does not go outside buffer space
                       devicedata[3] = uart0_RxBuf[index];                                // get the 13th byte of bar graph data
                       index++;                                                           // update array pointer to next byte
                       index &= MAX_RX_UART0_MASK;                                        // make sure the pointer does not go outside buffer space
                       devicedata[4] = uart0_RxBuf[index];                                // get the 13th byte of bar graph data
                       index++;                                                           // update array pointer to next byte
                       index &= MAX_RX_UART0_MASK;                                        // make sure the pointer does not go outside buffer space
                       devicedata[5] = uart0_RxBuf[index];                                // get the 13th byte of bar graph data
                       if(acDataChange < 0xffff) {acDataChange++;}                        // update the indicator action counter
                       RemoveMsgFromBuffer(MinMsgLen);                                    // remove the message from the recieve buffer
//                       MinMsgLen = DefaultMsgLen;                                         // reset the minimum message length to the default
                       }
                     break;
//                case SetDimPnl :
//                    MinMsgLen = 4;                                                        // set the minimum message length to this message length to reduce main loop process time
//                    if(uart0_RxCount >= MinMsgLen)                                        // check to see if all the bytes for this message were recieved
//                      {
//                      index++;                                                            // update array pointer to next byte
//                      index &= MAX_RX_UART0_MASK;                                         // make sure the pointer does not go outside buffer space
//                      PnlBrtnessH = uart0_RxBuf[index];                                   // get the high nibble of the dimming data
//                      PnlBrtnessH &= 0x0F;                                                // mask the unused portion of the data
//                      index++;                                                            // update array pointer to next byte
//                      index &= MAX_RX_UART0_MASK;                                         // make sure the pointer does not go outside buffer space
//                      PnlBrtnessL = uart0_RxBuf[index];                                   // get the low nibble of the dimming data
//                      PnlBrtnessL &= 0x0F;                                                // mask the unused portion of the data
//                      if(acPnlBrt < 0xffff) {acPnlBrt++;}                                 // set the panel dimming change action counter
//                      RemoveMsgFromBuffer(4);                                             // remove the message from the recieve buffer
//                      MinMsgLen = DefaultMsgLen;                                          // reset the minimum message length to the default
//                      }
//                    break;
                case Firmware :
                     MinMsgLen = FirmwareLen;                                             // reset the minimum message length to the default
                     if(uart0_RxCount >= MinMsgLen)                                       // check to see if all the bytes for this message were recieved
                       {
                       acFirmwareRsp++;                                                   // update the firmware response action counter
                       RemoveMsgFromBuffer(MinMsgLen);                                    // remove the message from the recieve buffer
//                       MinMsgLen = DefaultMsgLen;                                         // reset the minimum message length to the default
                       }
                     break;
                default   :
                    RemoveMsgFromBuffer(OneByte);                                         // remove the message from the recieve buffer
                    break;
                }//end switch(cmd)
              }//if address
            else
              {
              RemoveMsgFromBuffer(OneByte);                                               // remove the message from the recieve buffer
//              MinMsgLen = DefaultMsgLen;                                                  // reset the minimum message length to the default
              }
            }//if uart0_RxCount != 0
          else
            {
            RemoveMsgFromBuffer(OneByte);                                                 // remove the message from the recieve buffer
//            MinMsgLen = DefaultMsgLen;                                                    // reset the minimum message length to the default
            }
          }// end if((uart0_RxCount >= 2) && (uart0_RxCount != olduart0_RxCount))
      }// end of while //
} // End of main() //
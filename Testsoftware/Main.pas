unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Menus, IniFiles, Math,
  DXClass, DIB, ExtDlgs, IdBaseComponent, IdComponent, IdUDPBase,
  ShellAPI, jpeg, CPDrv, fileCtrl, spin, Buttons, ImgList,
  ToolWin;

const

  lblAddressWWW      = 'www.simtekinc.com';
  fileCFG            = 'simtek.dcf';

  InstNum            = '9036';
  InstHead           = '10';
  InstRevLevel       = '-';

  lblTestSoftwareCap = ': '+InstHead+'-' + InstNum;
  lblTestSoftwareRev = ':   ' + InstRevLevel;
  lblWARNINGCaption  = 'CAUTION FOR USE IN' +#$0D#$0A+ 'FLIGHT SIMULATOR ONLY';

  InstRevInf         = InstHead + '-' + InstNum+' Test Software Rev ' + InstRevLevel;
  InstSec            = '10' + InstNum;

  icTXQue            = 512;
  icRXQue            = 1024;
  dsf                = 'Courier,8,clWindowText,clWindow';

  GENSec             = 'general';
  InstSecK01         = 'edtIPAddress';
  InstSecK02         = 'COMPort';
  InstSecK03         = 'cpdCOMBAUDRATE';
  GenSecK01          = 'TxWinLimit';
  GenSecK02          = 'RxWinLimit';
  GenSecK03          = 'cpdDATABITS';
  GenSecK04          = 'cpdPARITY';
  GenSecK05          = 'cpdSTOPBITS';
  GenSecK12          = 'memolog';
  GenSecK13          = 'memotrx';
  GenSecK14          = 'memordx';
  GenSecK15          = 'memoraw';
// Host Command Setn to the Instrument
  TSCapHeader        = ' Transmit speed = ';

  StartByte          = $FF;
  lenDefault         = 1;        // this should be the length of the shortest message returned

  C0Command          = 'Reset';
  C0Request          = $F0; // Reset Request
  C0Requestlength    = 2;
  C0CapHeader        = C0Command + ' Transmit speed = ';
  C0Response         = C0Request;
  C0Responselength   = 0;

  C1Command          = 'Firmware';
  C1Request          = $FE; // cursor home
  C1Requestlength    = 2;
  C1CapHeader        = C1Command + ' Transmit speed = ';
  C1DeviceValDefault = ': 7?-???? Rev ?';
  C1Response         = C1Request;
  C1Responselength   = 6;

  C2Command          = 'Status';
  C2Request          = $F1; // Options Change Request
  C2Requestlength    = 2;
  C2CapHeader        = C2Command + ' Transmit speed = ';
  C2Response         = C2Request;
  C2Responselength   = 3;

  C3Command          = 'Display';
  C3Request          = $F5; // display on
  C3Requestlength    = 5;//35
  C3CapHeader        = C3Command + ' Transmit speed = ';
  C3Response         = C3Request;
  C3Responselength   = 0;

  C4Command          = 'Indicators';
  C4Request          = $F3; // Ind on
  C4Requestlength    = 6;//35
  C4CapHeader        = C4Command + ' Transmit speed = ';
  C4Response         = C4Request;
  C4Responselength   = 0;

  // Descriptive labels to use with routines
  lblDimming1Cap     = 'Panel Dimming Level = ';
  lblDimming1Hint    = 'Shows Display Brightness Value';
  lblDimming2Cap     = 'Indicator Dimming Level = ';
  lblDimming2Hint    = 'Shows Indicator Brightness Value';

  clActive           = clLime;
  clInactive         = clRed;
  clDisabled         = clAppWorkSpace;
  LightOnTime        = 40;

  clShowing          = $000052FD;
  clHidden           = clBlack;

type
 Tx = record
   s    : string;                               //
   ai   : byte;                                 // average update rate index
   ar   : array[0..255] of double;              // average update rate
   us   : double;                               // update speed
   ui   : byte;                                 // update index
   uc   : integer;                              // update rate count
end;

type
    TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    mm01: TMenuItem;
    Exit1: TMenuItem;
    Port1: TMenuItem;
    StatusBar: TStatusBar;
    mm02: TMenuItem;
    mm02s01: TMenuItem;
    mm02s02: TMenuItem;
    mm06: TMenuItem;
    mm05: TMenuItem;
    mm04: TMenuItem;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    lblScrollRate: TLabel;
    lblTestSoftwarePNValue: TLabel;
    lblFirmwareTitle2: TLabel;
    lblFirmwareValue2: TLabel;
    lblWARNING: TLabel;
    lblTestSoftwarePNTile: TLabel;
    lblTestSoftwareRevValue: TLabel;
    lblTestSoftwareRevTile: TLabel;
    imgSimtekLogo: TImage;
    lblFirmwareTitle1: TLabel;
    lblFirmwareValue1: TLabel;
    pnlDividerBar05: TPanel;
    pnlDividerBar03: TPanel;
    pnlDividerBar01: TPanel;
    pnlDividerBar02: TPanel;
    pnlDividerBar04: TPanel;
    tkbScrollRate: TTrackBar;
    TabSheet4: TTabSheet;
    lblResponseRequestsTitle1: TLabel;
    lblResponseRequestsTitle2: TLabel;
    lblRecievedTimeout: TLabel;
    lblC1TransmitRate: TLabel;
    lblC2TransmitRate: TLabel;
    lblC4TransmitRate: TLabel;
    lblTransmitRate: TLabel;
    lblRequestsSent: TLabel;
    lblResponseRecieved: TLabel;
    lblC5TransmitRate: TLabel;
    lblC6TransmitRate: TLabel;
    cbxResponse: TCheckBox;
    tkbRecieveTimeOut: TTrackBar;
    tkbC1UpdateRate: TTrackBar;
    tkbC2UpdateRate: TTrackBar;
    tkbC4UpdateRate: TTrackBar;
    tbUpdateRate: TTrackBar;
    cbxGraphicsEnable: TCheckBox;
    cbxTRXWindowEnable: TCheckBox;
    cbxRDXWindowEnable: TCheckBox;
    ScrollBar2: TScrollBar;
    tkbC5UpdateRate: TTrackBar;
    tkbC6UpdateRate: TTrackBar;
    DXTimer1: TDXTimer;
    mm03: TMenuItem;
    mm03s01: TMenuItem;
    mm03s02: TMenuItem;
    mm03s03: TMenuItem;
    mm03s04: TMenuItem;
    mm03s05: TMenuItem;
    mm03s05s01: TMenuItem;
    mm03s05s02: TMenuItem;
    mm03s05s03: TMenuItem;
    N2: TMenuItem;
    N1: TMenuItem;
    N3: TMenuItem;
    mm02s03: TMenuItem;
    mm08: TMenuItem;
    lblTransmitted: TLabel;
    lblReceived: TLabel;
    PopupMenu1: TPopupMenu;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Delete1: TMenuItem;
    MenuItem1: TMenuItem;
    Selectall1: TMenuItem;
    MenuItem2: TMenuItem;
    pmClearAll: TMenuItem;
    N4: TMenuItem;
    Print1: TMenuItem;
    pnlStatusLights: TPanel;
    mTXLight: TShape;
    lblTrxDataLight: TLabel;
    mRXLight: TShape;
    lblRdxDataLight: TLabel;
    lblAvailablePortsTitle: TLabel;
    lblBaudRateTitle: TLabel;
    cbBaudRate: TComboBox;
    lblBaudRateColon: TLabel;
    lblAvailablePortsColon: TLabel;
    updnValidPorts: TUpDown;
    updnBaudRate: TUpDown;
    cbValidPorts: TComboBox;
    Upind: TPanel;
    MemoTx: TRichEdit;
    CPDrv: TCommPortDriver;
    MemoRx: TRichEdit;                     
    cbfilterGarbage: TCheckBox;
    tkbPointer1: TTrackBar;
    cdegbox: TEdit;
    cdeg: TLabel;
    AddrLab: TLabel;
    updnAddr: TUpDown;
    AddrColon: TLabel;
    cbAddress: TComboBox;
    tkbC3UpdateRate: TTrackBar;
    lblC3TransmitRate: TLabel;
    lblFPData: TLabel;
    lblCalPoint1: TLabel;
    lblCalPoint2: TLabel;
    lblCalPoint3: TLabel;
    lblCalPoint4: TLabel;
    lblCalPoint5: TLabel;
    lblCalPoint6: TLabel;
    lblCalPoint7: TLabel;
    chex: TLabel;
    lblFlag: TLabel;
    lblScrollStep: TLabel;
    updnScrollStep: TUpDown;
    edtScrollStep: TEdit;
    IDD1: TLabel;

    procedure ScrollBar2Change(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mm02s01Click(Sender: TObject);
    procedure mm02s02Click(Sender: TObject);
    procedure scrolleverything();
    procedure mm05Click(Sender: TObject);     // scroll
    procedure tbUpdateRateChange(Sender: TObject);
    procedure tkbC1UpdateRateChange(Sender: TObject);
    procedure tkbC2UpdateRateChange(Sender: TObject);
    procedure tkbC3UpdateRateChange(Sender: TObject);
    procedure tkbC4UpdateRateChange(Sender: TObject);
    procedure tkbC5UpdateRateChange(Sender: TObject);
    procedure tkbC6UpdateRateChange(Sender: TObject);
    procedure cbxResponseClick(Sender: TObject);
    procedure tkbRecieveTimeOutChange(Sender: TObject);
    procedure imgSimtekLogoClick(Sender: TObject);
    procedure tkbScrollRateChange(Sender: TObject);
    procedure paintGUI;
    function  decodeRecievedData(sp1, sp2 : string):string;
    function  encodeCommandData(CommandByte : byte) : string;
    function  calculateRate(ct : double;g : Tx;rc : boolean;l : TObject;t : TObject;s : string):Tx;
    procedure cpOutputData(s : string; rc : boolean);
    procedure wrMemoWindow(show,memo,lbl :TObject; Limit,Place : integer;head,cap,s : string);
    procedure lblFirmwareTitle2Click(Sender: TObject);
    procedure DXTimer1Timer(Sender: TObject; LagCount: Integer);
    function  buildMainCaption : string;
    procedure responseReset;
    //serial interface
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    procedure parseFont(memo : TRichEdit;sf,section,key : string;sini : TIniFile);
    procedure cpSetComPort();
    function  cpIntToBaudRate(rate: string): TBaudRate; {Reads data from the serial port and posts a message}
    function  cpIntToBaud(baud : integer) : string;
    function  cpParityToInt(parity : string):integer;
    function  cpIntToParity(parity: TParity): string;
    function  cpIntToStopBits(stopbits : TStopBits):string;
    function  cpStopBitsToInt(stopbits : string):integer;
    function  cleanRxBuffer(len : integer) : string;
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    // Gui functions
    //----------------------------------------------------------------------------------------------------------------------
    procedure setindicator(ind : TLabel; val : integer);
    //----------------------------------------------------------------------------------------------------------------------
    // responses
    //----------------------------------------------------------------------------------------------------------------------
    procedure responseStatus(ptrCK: pbyte);
    procedure responseFirmware(s : string);
    //----------------------------------------------------------------------------------------------------------------------
    procedure mm03s01Click(Sender: TObject);
    procedure mm02s03Click(Sender: TObject);
    procedure mm03s03Click(Sender: TObject);
    procedure mm03s05s01Click(Sender: TObject);
    procedure MemoTxChange(Sender: TObject);
    procedure memoTxKeyPress(Sender: TObject; var Key: Char);
    procedure MemoRxChange(Sender: TObject);
    procedure MemoRxKeyPress(Sender: TObject; var Key: Char);
    procedure mm07Click(Sender: TObject);

    procedure setColorCOMLightsOff;
    procedure loadStatusBarText(Sender: TObject);
    procedure saveSettings;
    procedure cbBaudRateChange(Sender: TObject);
    procedure cbValidPortsChange(Sender: TObject);
    procedure updnBaudRateClick(Sender: TObject; Button: TUDBtnType);
    procedure updnValidPortsClick(Sender: TObject; Button: TUDBtnType);
    procedure cpDRVReceiveData(Sender: TObject; DataPtr: Pointer;
      DataSize: Cardinal);
    procedure mm08Click(Sender: TObject);
    procedure KnobRotaryMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure parseTx(s : String);
    procedure debugDisplay();  //sets digit locations on res file
    procedure mm04Click(Sender: TObject);
    procedure mm06Click(Sender: TObject);
    procedure tkbPointer1Change(Sender: TObject);
    procedure cdegboxClick(Sender: TObject);
    procedure degbox_selectall(Sender: TObject;AA: byte);
    procedure cdegboxKeyPress(Sender: TObject; var Key: Char);
    procedure azdegbuttonMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure load_deg_from_degbox(Sender: TObject;AA: byte);
    procedure Indicator3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Indicator2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure shpIndicatorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure IDD0Click(Sender: TObject);
    procedure updnAddrClick(Sender: TObject; Button: TUDBtnType);
    procedure lblCalPointClick(Sender: TObject);
    procedure lblCalPointMouseEnter(Sender: TObject);
    procedure lblCalPointMouseLeave(Sender: TObject);
    procedure updnScrollStepClick(Sender: TObject; Button: TUDBtnType);
    procedure edtScrollStepKeyPress(Sender: TObject; var Key: Char);
    procedure edtScrollStepClick(Sender: TObject);
    procedure cbAddressChange(Sender: TObject);
    //*************************************************************************************************************
  private
    { Private declarations }
    function  ValuesToHexString(s : string):string;
    procedure setMomentaryBtn(button : TObject);
    procedure DisplayHint1(Sender: TObject);
    procedure cpGetData(instr : string) ;
  public
    { Public declarations }
    procedure setColorCOMLightTX(SetColor : TColor;i : integer);
    procedure setColorCOMLightRX(SetColor : TColor;i : integer);
    procedure TrafficLightsOff;
  end;

type
  TComRecord  = Record
    Port      : ShortInt;
    Baud      : ShortInt;
    Parity    : ShortInt;
    DataBits  : ShortInt;
    StopBits  : ShortInt;
    HandShak  : ShortInt;
end;

var
  MainForm                  : TMainForm;
  hWind                     : HWND;
  {------------- Variables for serial Communications -----------------------------------------}
  gPort                     : String;                // open port name
  gBaud                     : String;                // port baud rate
  gDataBits                 : String;                // port data bits
  gStopBits                 : String;                // port stop bits
  gParity                   : String;                // port parity setting
  LightTXOnTime             : integer = 1;           // define counter to keep activity TX light on
  LightRXOnTime             : integer = 1;           // define counter to keep activity RX light on
  DisplayPortDialog         : integer = 0;           //
  TxWinLimit                : integer = 250;         //
  RxWinLimit                : integer = 250;         //
  RxPlace                   : integer = 0;           //
  TxPlace                   : integer = 0;           //
  ComStat                   : TComStat;  { Com Status Structure }
  hComm                     : HWND = INVALID_HANDLE_VALUE;
  PortInfo                  : TComRecord;
  DCB                       : TDCB;
  TpCommProp                : TCommProp;
  TimeOuts                  : TCommTimeouts;
  zsRXBuff                  : array[0..2047] of char;
  bBindex                   : byte;
  bEindex                   : byte;
  lzsBuffer                 : array[0..255] of char;
  //  MY VARIABLES FOR PROGRAM  DME PANEL
  Txc,Rxc                   : TColor;
  VersionInfo               : TOSVERSIONINFO;
// variables for serial message shortfalls
  gSerialBufNew             : string  = '';          //
  gSerialBufHold            : string  = '';          //
  gByteCount                : word    = 0;           //
  gWholeMsg                 : integer = LenDefault;

  TXCount                   : byte    = 1; {define and initilize Counter}
  RXCount                   : byte    = 1; {define and initilize Counter}
  sWidth                    : integer = 1024;

  PConfiged                 : boolean = FALSE;
  commandflag               : boolean = FALSE;
  ChangeFlag                : Boolean = True; // indicates some part of image needs to be updated
  count                     : longint = 0;
  countAlso                 : longint = 17;
  toggleBool                : boolean = TRUE;

  fScrollReq                : boolean = False;
//  dScrollValue              : byte = 0;
  scrollbit                 : boolean;
// Device Output control variables
  fImageRedraw              : boolean;
  scrcount                  : integer =0;
  rscrcount                 : integer =0;
  scrolldirection           : boolean =false;

  ActiveDigit               : cardinal = 0;
  C0RequestData             : array[0..C0Requestlength] of byte;  // reset
  C1RequestData             : array[0..C1Requestlength] of byte;  // firmware
  C2RequestData             : array[0..C2Requestlength] of byte;  // status
  C3RequestData             : array[0..C3Requestlength] of byte;  // display
  C4RequestData             : array[0..C4Requestlength] of byte;  //use for indicators

  C1ResponseData            : array[0..C1Responselength] of byte; // firmware
  C2ResponseData            : array[0..C2Responselength] of byte; //status
// Host to Instrument request Action Flags
  fC0Request                : boolean  = False; // reset
  fC1Request                : boolean  = False; // firmware
  fC2Request                : boolean  = False; // status
  fC3Request                : boolean  = False; // display
  fC4Request                : boolean  = False; // indicator                                  display backlight toggle
  fgeneric                  : boolean  = False;
// Debug Variables
  NumberOfRequests         : cardinal = 0;
  UserImageSelected        : boolean  = True;
  NumberOfResponse         : cardinal = 0;
// Display Dimming Variables
  tkbDimming2Old           : integer;
  tkbDimming1Old           : integer;
  //integer to hold count down for txshape blink on transmission
  tx_integer, rx_integer   : integer;
  //byte to hold panel address
  address                  : byte;
  //bytes to transmit dimming data
  bright1, bright2         : byte;
  //variables to scroll display
  scrollvalue              : byte;
  scrollcount              : integer = 0;
  //variable to hold brightness data
  resetbit                 : boolean;

  scrollClickCounter       : integer;
  scrolldeg                : integer;
  scrollflag               : integer;
// display paintbox variables
//  ********************************************************************************************************
  CanvasRect               : array[0..31] of TRect; // digit locations on canvas
  DigitRect                : array[0..255] of TRect; // digit locations of res File
  FocusedRect              : TRect; // digit that will change next        most likely not needed
  digitCnt                 : integer; //keeps track of what digit needs to be changed
  debugDis                 : array[0..32] of TLabel;
//**********************************************************************************************************
  ltime                    : TDateTime;                // current time
// Device BIT control variables
  fPTInputStatus           : boolean  = False;
  fCTInputStatus           : boolean  = False;
  fRKInputStatus           : boolean  = False;
  fOFLInputStatus          : boolean  = False;
  fEBInputStaus            : boolean  = False;
  fZALLInputStatus         : boolean  = False;
  fPresetPWROFFInputStatus : boolean  = False;
  fPresetMANInputStatus    : boolean  = False;
  fPreset1InputStatus      : boolean  = False;
  fPreset2InputStatus      : boolean  = False;
  fPreset3InputStatus      : boolean  = False;
  fPreset4InputStatus      : boolean  = False;
  fPreset5InputStatus      : boolean  = False;
  fPreset6InputStatus      : boolean  = False;
  fPresetREMInputStatus    : boolean  = False;
  fINITInputStatus         : boolean  = False;
  fRightArrowInputStatus   : boolean  = False;
  fUpArrowInputStatus      : boolean  = False;
  fBRTDSPLA2DInputStatus   : boolean  = False;
  fBRTPNLA2DInputStatus    : boolean  = False;
  fMemoryStatus            : boolean  = False;

  gRate                    : Tx;
  gRateC1                  : Tx;
  gRateC2                  : Tx; // DisplayRequest     = $F2;
  gRateC3                  : Tx; // DimmingRequest     = $F3;
  gRateC4                  : Tx; // FirmwareRequest    = $F4;
  gRateC5                  : Tx; // FirmwareRequest    = $F4;
  gRateC6                  : Tx; // FirmwareRequest    = $F4;
  BurstFileName            : string = 'BurstFile.txt';
  BurstFileContents        : TStringlist = nil;
  //bit to reset procedures
  degbar                  : array[0..2] of TTrackBar;
  deglab                  : array[0..2] of TLabel;
  degbox                  : array[0..2] of TEdit;
  hexlab                  : array[0..2] of TLabel;

implementation

{$R *.DFM}
//
procedure TMainForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

// clear rx window
procedure TMainForm.mm02s01Click(Sender: TObject);
begin
  MemoRx.Clear;
end;

// clear tx window
procedure TMainForm.mm02s02Click(Sender: TObject);
begin
  MemoTx.Clear;
end;

// clear num requests and num response
procedure TMainForm.mm02s03Click(Sender: TObject);
begin
  NumberOfRequests                := 0;
  NumberOfResponse                := 0;
end;

procedure TMainForm.tbUpdateRateChange(Sender: TObject);
begin
 if tbUpdateRate.Position = 0 then DXTimer1.Interval := 0 else DXTimer1.Interval := 1;
 if tkbScrollRate.Position < tbUpdateRate.Position then
   tkbScrollRate.Position := tbUpdateRate.Position;
end;

// turn scroll on / off
procedure TMainForm.mm05Click(sender: TObject);
begin
  if (scrollbit = true) then
     scrollbit:= false
  else
     scrollbit:= true;
  if fScrollReq = false then fScrollReq := true else fScrollReq := false;
end;

// reset request
procedure TMainForm.mm06Click(Sender: TObject);
begin
 fC0Request := true;
 resetbit   := true;
 responseReset;
end;

procedure TMainForm.mm07Click(Sender: TObject);
begin
  fC1Request                      := True;
end;

// firmware request
procedure TMainForm.mm08Click(Sender: TObject);
begin
  fC1request                      := True;
end;

// display request
procedure TMainForm.imgSimtekLogoClick(Sender: TObject);
var url : string;
begin
  url := lblAddressWWW;
  ShellExecute(self.WindowHandle,'open',PChar(url),nil,nil, SW_SHOWNORMAL);
end;

procedure TMainForm.lblFirmwareTitle2Click(Sender: TObject);
begin
  lblFirmwareValue1.Caption := C1DeviceValDefault;
  lblFirmwareValue2.Caption := C1DeviceValDefault;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var i, tmp            : integer;
    SimtekIni    : TIniFile;
begin
  hWind := MainForm.Handle; //get a handle to the main window.                                                                               // clear out the transmit window.
  memoTx.Clear;                                                                               // clear out the transmit window.
  memoRx.Clear;                                                                               // clear out the receive window.
  SimtekIni                            := nil;                                                     //
  if FileExists('C:\simtekinc\' + fileCFG) then
    begin
    Try
      SimtekIni                        := TIniFile.Create('C:\simtekinc\' + fileCFG);                        // create and load the ini file data
      With SimtekIni      do                                                                       //
        begin
        DisplayPortDialog         :=                ReadInteger(InstSec, InstSecK01, 1);      //
        // load the limit for the transmit and recieve windows
        TxWinLimit                :=                ReadInteger(GENSec,  GenSecK01,  250);    //
        RxWinLimit                :=                ReadInteger(GENSec,  GenSecK02,  250);    //
        // load the com port setting if they are stored else load the defaults
        gPort                     :=                ReadString(InstSec, InstSecK02, 'COM3');  //
        gBaud                     :=                ReadString(InstSec, InstSecK03, '115200');  //
        gDataBits                 :=                ReadString(GENSec,  GenSecK03,  '3');     //
        gStopBits                 :=                ReadString(GENSec,  GenSecK04,  '0');     //
        gParity                   :=   'odd'; //   ReadString(InstSec, GenSecK05,  'none');  //
        end;//With sini      do
      finally
        SimtekIni.Free;                                                                                //
        cpSetComPort;
      end;
    end
  else
    begin
    DisplayPortDialog             :=                1;         //
// load the limit for the transmit and recieve windows
    TxWinLimit                    :=                250;       //
    RxWinLimit                    :=                250;       //
// load the com port setting if they are stored else load the defaults
    gPort                         :=                'COM3';    //
    gBaud                         :=                '115200';  //
    gDataBits                     :=                '3';       //
    gStopBits                     :=                '0';       //
    gParity                       :=                'odd';     //
    end;
  TxPlace                         := Length(IntToStr(TxWinLimit));                            // get the number of possible lines in the window
  RxPlace                         := Length(IntToStr(RxWinLimit));                            // get the number of possible lines in the window
  ltime                           := Now;
  degbar[0]                       := tkbPointer1;
  deglab[0]                       := cdeg;
  degbox[0]                       := cdegbox;
  hexlab[0]                       := chex;
  responseReset;
  fImageRedraw                    := true;
  DXTimer1.Enabled                := true;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if hComm <> INVALID_HANDLE_VALUE then CloseHandle(hComm);
end;

procedure TMainForm.DisplayHint1(Sender: TObject);
begin
  StatusBar.simpleText := Application.Hint;
end;

procedure TMainForm.responseReset;
begin
    TrafficLightsOff;                          // Turn off the communications status indicators
    memoTx.Clear;                              // Blank the dataout and datain
    memoRx.Clear;                              // Blank the dataout and datain

    mm06.Caption                     := '&'+C0Command;
    mm08.Caption                     := C1Command;

    mm03s05s01.Caption               := '&'+C1Command;
    mm03s05s02.Caption               := '&'+C2Command;

    lblFirmwareValue1.Caption        := C1DeviceValDefault;
    lblFirmwareValue2.Caption        := C1DeviceValDefault;

    lblScrollRate.caption   := 'Scroll Rate Value: ' + InttoStr(tkbScrollRate.Position);

    MainForm.Caption                 := buildMainCaption;       //
    lblTransmitRate.Caption          := TSCapHeader + '0.00Hz';
    lblC1TransmitRate.Caption        := C1CapHeader + '0.00Hz';
    lblC2TransmitRate.Caption        := C2CapHeader + '0.00Hz';

    lblTestSoftwarePNValue.Caption   := lblTestSoftwareCap;
    lblTestSoftwareRevValue.Caption  := lblTestSoftwareRev;
    lblWARNING.Caption               := lblWARNINGCaption;

    C4RequestData[2] := $00;
    C4RequestData[3] := $00;
    C4RequestData[4] := $00;
    C4RequestData[5] := $00;

    toggleBool := TRUE;
    degbar[0].Position    := 0;
    scrolldeg             := 0;
    scrollflag            := 0;
    cdegbox.Text          := '000.0';
    resetbit              := false;
    scrcount              := 0;
    scrolldirection       := false;
    updnBaudRate.Position := 0;
    fImageRedraw          := True;
end;

procedure TMainForm.responseStatus(ptrCK: pbyte);        // ask how to fix this function
begin
  inc(ptrCK);                    // ff
end;

procedure TMainForm.responseFirmware(s : string);
var
  si    : string;
  b1,b2 : byte;
begin
    inc(NumberOfResponse);
    b2 := Ord(s[3]);
    b1 := ((b2 shr 4) and $0F) or $30;
    b2 := (b2 and $0F) or $30;
    si := ': ' + chr(b1) + chr(b2) + '-';
    b2 := Ord(s[4]);
    b1 := ((b2 shr 4) and $0F) or $30;
    b2 := (b2 and $0F) or $30;
    si := si + chr(b1) + chr(b2);
    b2 := Ord(s[5]);
    b1 := ((b2 shr 4) and $0F) or $30;
    b2 := (b2 and $0F) or $30;
    si := si + chr(b1) + chr(b2) + ' rev ';
    si := si + s[6];
    lblFirmwareValue1.Caption := si;
end;

procedure TMainForm.tkbC1UpdateRateChange(Sender: TObject);
begin
  lblC1TransmitRate.Caption := IntToStr(tkbC1UpdateRate.Position);
  fImageRedraw := True;
end;

procedure TMainForm.tkbC2UpdateRateChange(Sender: TObject);
begin
  lblC2TransmitRate.Caption := IntToStr(tkbC2UpdateRate.Position);
  fImageRedraw := True;
end;

procedure TMainForm.tkbC3UpdateRateChange(Sender: TObject);
begin
  lblC3TransmitRate.Caption := IntToStr(tkbC3UpdateRate.Position);
  fImageRedraw := True;
end;

procedure TMainForm.tkbC4UpdateRateChange(Sender: TObject);
begin
  lblC4TransmitRate.Caption := IntToStr(tkbC4UpdateRate.Position);
  fImageRedraw := True;
end;

procedure TMainForm.tkbC5UpdateRateChange(Sender: TObject);
begin
  lblC5TransmitRate.Caption := IntToStr(tkbC5UpdateRate.Position);
  fImageRedraw := True;
end;

procedure TMainForm.tkbC6UpdateRateChange(Sender: TObject);
begin
  lblC6TransmitRate.Caption := IntToStr(tkbC6UpdateRate.Position);
  fImageRedraw := True;
end;

procedure TMainForm.ScrollBar2Change(Sender: TObject);
begin
    lblTransmitRate.Top           :=  10 - ScrollBar2.Position;
    tbUpdateRate.Top              :=  22 - ScrollBar2.Position;
    tkbC1UpdateRate.Top           :=  64 - ScrollBar2.Position;
    lblC1TransmitRate.Top         :=  52 - ScrollBar2.Position;
    lblC2TransmitRate.Top         :=  94 - ScrollBar2.Position;
    tkbC2UpdateRate.Top           := 106 - ScrollBar2.Position;
    lblC3TransmitRate.Top         := 136 - ScrollBar2.Position;
    tkbC3UpdateRate.Top           := 148 - ScrollBar2.Position;
    lblC4TransmitRate.Top         := 178 - ScrollBar2.Position;
    tkbC4UpdateRate.Top           := 190 - ScrollBar2.Position;
    lblC5TransmitRate.Top         := 220 - ScrollBar2.Position;
    tkbC5UpdateRate.Top           := 232 - ScrollBar2.Position;
    lblC6TransmitRate.Top         := 262 - ScrollBar2.Position;
    tkbC6UpdateRate.Top           := 270 - ScrollBar2.Position;
    cbxTRXWindowEnable.Top        := 310 - ScrollBar2.Position;
    cbxRDXWindowEnable.Top        := 330 - ScrollBar2.Position;
    cbxGraphicsEnable.Top         := 350 - ScrollBar2.Position;
    cbxResponse.Top               := 370 - ScrollBar2.Position;
    lblResponseRequestsTitle1.Top := 390 - ScrollBar2.Position;
    lblRequestsSent.Top           := 390 - ScrollBar2.Position;
    lblResponseRequestsTitle2.Top := 410 - ScrollBar2.Position;
    lblResponseRecieved.Top       := 410 - ScrollBar2.Position;
    lblRecievedTimeout.Top        := 430 - ScrollBar2.Position;
    tkbRecieveTimeOut.Top         := 430 - ScrollBar2.Position;
end;

procedure TMainForm.edtScrollStepClick(Sender: TObject);
begin
  TEdit(Sender).SelectAll;
end;

procedure TMainForm.edtScrollStepKeyPress(Sender: TObject; var Key: Char);
var
  s   : string;
  num : extended;
  err : integer;
begin

    case key of
     '0'..'9':;
     #13: begin
          key := #0;
          s := edtScrollStep.Text;
          val(s,num,err);
          if ((err = 0) and (num <= 100)) then
            begin
            err:= Round(num);
            updnScrollStep.Position:= err;
            edtScrollStep.SelectAll;
            end//if err = 0 then
          else
            begin
            MessageDlg('Invalid value.  Please reenter the value 0-100',mtError,[mbOk],0);
            num := updnScrollStep.Position;
            err := Round(num);
            edtScrollStep.Text := FloatToStr(num);
            updnScrollStep.position := err;
            edtScrollStep.SelectAll;
            end;//else
          end;
     #8:;
    end;


end;

function TMainForm.encodeCommandData(CommandByte: byte): string; //preps messages to be send to the instrument
var
   s          : string;
   tmp        : integer;
   cs         : byte;

   DPtr    : pbyte;
begin
  s := '';

  case CommandByte of
    C0Request  : begin               // reset

      s        := s + chr(C0Request);
      s        := s + chr(updnAddr.Position);
      inc(NumberOfRequests);
      end;
    C1Request  : begin               // firmware
      s        := s + chr(C1Request);
      s        := s + chr(updnAddr.Position);
      inc(NumberOfRequests);
      end;
    C3Request  : begin                // display
      s        := s + chr(C3Request);
      s        := s + chr(updnAddr.Position);
      s        := s + Chr(C3RequestData[0]);      // 01
      s        := s + Chr(C3RequestData[1]);      // 02
      s        := s + Chr((C3RequestData[3] and $01));      // 02
      inc(NumberOfRequests);
      end;
    else begin
      s   := chr(CommandByte);
    end;
  end;
  TXCount := 30;
  Result  := s;
end;

procedure TMainForm.updnAddrClick(Sender: TObject; Button: TUDBtnType);
begin
  if updnAddr.Position > 7 then updnAddr.Position := 7;
  cbAddress.Text := cbAddress.Items[updnAddr.Position];
end;

procedure TMainForm.updnBaudRateClick(Sender: TObject; Button: TUDBtnType);
begin
  if updnBaudRate.Position > 6 then updnBaudRate.Position := 6;
  cbBaudRate.ItemIndex := updnBaudRate.Position;
  gBaud := cbBaudRate.Items.Strings[updnBaudRate.Position];
  //cpSetComPort;
end;

procedure TMainForm.updnValidPortsClick(Sender: TObject; Button: TUDBtnType);
begin
  if updnValidPorts.Position > 255 then updnValidPorts.Position := 255;
  gPort := cbValidPorts.Items.Strings[updnValidPorts.Position];
  gPort := UpperCase(gPort);
  //pSetComPort;
end;

procedure TMainForm.updnScrollStepClick(Sender: TObject; Button: TUDBtnType);
begin
  edtScrollStep.Text := IntToStr(updnScrollStep.Position);
end;

function TMainForm.ValuesToHexString(s: string): string;
var i         : integer;
    cnt       : byte;
    SMsg      : string;
begin
    cnt := length(s);
    SMsg  := '';
    for i := 1 to cnt do {Loop through the buffer and}
      SMsg  := SMsg + IntToHex(ord(s[i]),2)+' '; {Convert the bytes to a pascal string}
    Result := SMsg;
end;

procedure TMainForm.MemoRxKeyPress(Sender: TObject; var Key: Char);
var UserrecieveString,CharacterCreationString,StringToRecieve : string;
    CharacterPointer,CharacterToRecieve,Stringlength,BadCharPos : byte;
begin
  case Key of
    '0'..'9':;
    'A'..'F':;
    'a'..'f':;
    #8 :;
    #13:begin
        UserrecieveString := memoRx.Lines.Strings[memoRx.Lines.Count-1];
        memoRx.Lines.Delete(memoRx.Lines.Count-1);
        BadCharPos := pos('>',UserrecieveString);
        if BadCharPos <> 0 then
          begin
          memoRx.Lines.Add(UserrecieveString);
          Delete(UserrecieveString,1,BadCharPos+1);
          end;
        While pos(' ',UserrecieveString) <> 0 do
          begin
          BadCharPos := pos(' ',UserrecieveString);
          Delete(UserrecieveString,BadCharPos,1);
          end;//while
        Stringlength := length(UserrecieveString);
        CharacterPointer := 1;
        StringToRecieve := '';
        While CharacterPointer <= Stringlength do
          begin
          CharacterCreationString := '$' + UserrecieveString[CharacterPointer] + UserrecieveString[CharacterPointer+1];
          CharacterToRecieve := StrToInt(CharacterCreationString);
          StringToRecieve := StringToRecieve + Chr(CharacterToRecieve);
          CharacterPointer := CharacterPointer + 2;
          end;
        if StringToRecieve <> '' then gSerialBufHold := decodeRecievedData(StringToRecieve,gSerialBufHold);
        Key := #00;
        end;
    else Key := #00;
  end;//case
end;


procedure TMainForm.MemoRxChange(Sender: TObject);
begin
  lblReceived.Caption := 'Lines Received : ' + IntToStr(memoRx.lines.count);
end;

procedure TMainForm.cbAddressChange(Sender: TObject);
begin
  updnAddr.Position := TComboBox(Sender).ItemIndex;
  TComboBox(Sender).SelectAll;
end;

procedure TMainForm.IDD0Click(Sender: TObject);
begin
  if IDD1.Font.Color = clHidden then
    begin
    C3RequestData[3] := C3RequestData[3] or TLabel(Sender).Tag;

    end
  else
    begin
    C3RequestData[3] := C3RequestData[3] and (not TLabel(Sender).Tag);

    end;
  fC3Request   := True;
  fImageRedraw := True;
end;

procedure TMainForm.cbBaudRateChange(Sender: TObject);
begin
  gBaud := cpIntToBaud(cbBaudRate.ItemIndex);
  cpSetComPort;
end;

procedure TMainForm.cbValidPortsChange(Sender: TObject);
begin
  gPort := cbValidPorts.Text;
  UpperCase(gPort);
  cpSetComPort;
end;

procedure TMainForm.cbxResponseClick(Sender: TObject);
begin
  lblResponseRequestsTitle1.Visible := cbxResponse.Checked;
  lblRequestsSent.Visible           := cbxResponse.Checked;
  lblResponseRequestsTitle2.Visible := cbxResponse.Checked;
  lblResponseRecieved.Visible       := cbxResponse.Checked;
  lblRecievedTimeout.Visible        := cbxResponse.Checked;
  tkbRecieveTimeOut.Visible         := cbxResponse.Checked;
  N1.Visible                        := cbxResponse.Checked;
  mm02s03.Visible                   := cbxResponse.Checked;
  NumberOfRequests                  :=   0;
  NumberOfResponse                  :=   0;
end;


procedure TMainForm.degbox_selectall(Sender: TObject;AA: byte);
begin
  if (scrollbit) then
  exit
  else
      degbox[AA].SelectAll;
end;

procedure TMainForm.cdegboxClick(Sender: TObject);
begin
    degbox_selectall(Sender,0);
end;

procedure TMainForm.cdegboxKeyPress(Sender: TObject; var Key: Char);
begin
  if (scrollbit = True) then
  exit
  else
  begin
  case key of
   '0'..'9':;
   '.':;
   #13: begin
        key := #0;
        load_deg_from_degbox(Sender,0);
        degbox_selectall(Sender,0);
        end;
   #8:;
  end
  end;
end;

procedure TMainForm.scrolleverything();
begin
    degbar[0].Position := scrolldeg;
    if(scrolldirection) then
      begin
      scrolldeg := scrolldeg + updnScrollStep.Position;
      if(scrolldeg > 4095)then
        begin
        scrolldeg := 4095;
        scrolldirection := not scrolldirection;
        end;
      end
    else
      begin
      scrolldeg := scrolldeg - updnScrollStep.Position;
      if(scrolldeg < 0)then
        begin
        scrolldeg := 0;
        scrolldirection := not scrolldirection;
        end;
      end;
    scrollflag := scrollflag + 1; //updnScrollStep.Position;
    if(scrollflag >= 300) then
      begin
      IDD0Click(IDD1);
      scrollflag := 0;
      end;
    fC3Request := true;
end;

function  TMainForm.cleanRxBuffer(len : integer) : string;
var x : integer;
begin
  x        := 1;
  while(x <= len)do
  begin
    Result := Result + IntToHex(ord(gSerialBufNew[x]),2) + ' ';
    inc(x);
  end;
  delete(gSerialBufNew,1,len);
  gByteCount := length(gSerialBufNew);
  gWholeMsg  := lenDefault;
end;

procedure TMainForm.DXTimer1Timer(Sender: TObject; LagCount: Integer);
var  rxtimeout : integer;                 // timeout time for attempt to read receive buffer
     wdlist    : array[0..10] of string;  //
     wrstr     : string;                  // string to write to transmit buffer
     li        : integer;                 // line index
     counter   : integer;                 //
     ratecalc  : boolean;                 //
     ctime     : double;                  //
begin

  if(LightTXOnTime <> 0)then
    begin
    LightTXOnTime := LightTXOnTime - 1;
    setColorCOMLightTX(clInactive,LightTXOnTime);                       // Show the port as active
    end;
  if(LightRXOnTime <> 0)then
    begin
    LightRXOnTime := LightRXOnTime - 1;
    setColorCOMLightRX(clInactive,LightRXOnTime);                       // Show the port as active
    end;

  rxtimeout                   := tkbRecieveTimeOut.Position;
  wrstr                       := '';
  lblRequestsSent.Caption     := ': ' + IntToStr(NumberOfRequests);
  lblResponseRecieved.Caption := ': ' + IntToStr(NumberOfResponse);

  if (gByteCount >= gWholeMsg ) then
    begin
    gSerialBufHold := decodeRecievedData(gSerialBufNew,gSerialBufHold);
    end;//if (gByteCount >= gWholeByte)

  if fScrollReq then
    begin
    if ScrollCount > tkbScrollRate.Position then
      begin
      scrollEverything();
//      if dScrollValue > 57 then dScrollValue := 1;
      fImageRedraw    := True;
      ScrollCount     := 0;
//      inc(dScrollValue);
      end;//if DispScrolRateCnt > tkbScrollRate.Position then
    inc(ScrollCount);
    end;
  wrstr           := '';
  mm03s05.Checked := mm03s05s01.Checked
                  or mm03s05s02.Checked
                  or mm03s05s03.Checked;
  inc(gRate.uc);

  if gRateC1.uc >= (tkbC1UpdateRate.Position) then
    begin
    if mm03s05.Checked and mm03s02.Checked then
      begin
      if mm03s05s01.Checked then fC1Request := True;
      end;
    gRateC1.uc := 0;
    end; //if gRateC1.uc >= (tkbC1UpdateRate.Position)then
  if gRateC2.uc >= (tkbC2UpdateRate.Position) then
    begin
    if mm03s05.Checked and mm03s02.Checked then
      begin      if mm03s05s02.Checked then fC2Request := True;   end;
    gRateC2.uc := 0;
    end; //if gRateC2.uc >= (tkbC2UpdateRate.Position)then

  if gRateC3.uc >= (tkbC3UpdateRate.Position) then
    begin
    if mm03s05.Checked and mm03s02.Checked then
      begin      if mm03s05s03.Checked then fC3Request := True;   end;
    gRateC3.uc := 0;
    end; //if gRateC3.uc >= (tkbC3UpdateRate.Position)then

  ctime           := Now;
  li              := 0;

  if fC0Request then
    begin
    wrstr         := wrstr + encodeCommandData(C0Request);
    if mm03s04.Checked then
      begin
      inc(li);
      wdlist[li]  := wrstr;
      wrstr       := '';
      end;// mm03s04.Checked
    fC0Request    := False;
    resetbit      := False;
    end;// if fC0Request

  if fC1Request then
    begin
    wrstr         := wrstr + encodeCommandData(C1Request);
    if mm03s04.Checked then
      begin
      inc(li);
      wdlist[li]  := wrstr;
      wrstr       := '';
      end;// mm03s04.Checked
    gRateC1 := calculateRate(ctime, gRateC1, True, lblC1TransmitRate, tkbC1UpdateRate, C1CapHeader);
    fC1Request    := False;
    end;// if fC1Request

  if fC2Request then
    begin
    wrstr         := wrstr + encodeCommandData(C2Request);
    if mm03s04.Checked then
      begin
      inc(li);
      wdlist[li]  := wrstr;
      wrstr       := '';
      end;// mm03s04.Checked
    gRateC2 := calculateRate(ctime, gRateC2, True, lblC2TransmitRate, tkbC2UpdateRate, C2CapHeader);
    fC2Request    := False;
    end;// if fC2Request

  if fC3Request then
    begin
    wrstr         := wrstr + encodeCommandData(C3Request);
    if mm03s04.Checked then
      begin
      inc(li);
      wdlist[li]  := wrstr;
      wrstr       := '';
      end;// mm03s04.Checked
    gRateC3 := calculateRate(ctime, gRateC3, True, lblC3TransmitRate, tkbC3UpdateRate, C3CapHeader);
    fC3Request    := False;
    end;// if fC3Request

  if fC4Request then
    begin
    wrstr         := wrstr + encodeCommandData(C4Request);
    if mm03s04.Checked then
      begin
      inc(li);
      wdlist[li]  := wrstr;
      wrstr       := '';
      end;// mm03s04.Checked
    gRateC4 := calculateRate(ctime, gRateC4, True, lblC3TransmitRate, tkbC3UpdateRate, C4CapHeader);
    fC4Request    := False;
    end;// if fC4Request
//
  if mm03s03.Checked and (wrstr <> '') then
    begin
    inc(li);
    wdlist[li]    := wrstr;
    wrstr         := '';
    end;//if mm03s01.Checked
//
  if gRate.uc >= (tbUpdateRate.Position) then
    begin
    if mm03s02.Checked then gRate := calculateRate(ctime,    gRate, True, lblTransmitRate, tbUpdateRate, TSCapHeader)
    else                    gRate := calculateRate(gRate.uc, gRate, True, lblTransmitRate, tbUpdateRate, TSCapHeader);

      for counter  := 1 to li do
        begin
        wrstr           := wdlist[counter];
        wdlist[counter] := '';
        if counter       = li then ratecalc := True else  ratecalc := False;
        cpOutputData(wrstr, ratecalc);
        end;//for counter := 1 to li do

    gRate.uc := 0;
    inc(gRateC1.uc);
    inc(gRateC2.uc);
    inc(gRateC3.uc);
    inc(gRateC4.uc);
    inc(gRateC5.uc);
    inc(gRateC6.uc);
    end;//if gRate.uc >= (tbUpdateRate.Position) then

  if (fImageRedraw and cbxGraphicsEnable.Checked) then
    begin
    paintGUI;
    end;

  if TXCount > 1 then
  Dec(TXCount);
  if TXCount = 1 then
    begin
    TXCount := 0;
    setColorCOMLightTX(clRed,1);
    end;

  if RXCount > 1 then Dec(RXCount);
  if RXCount = 1 then
    begin
    RXCount := 0;
    setColorCOMLightRX(clRed,1);
    end;
end;

function TMainForm.decodeRecievedData(sp1, sp2: string):string;
var
  SMsg      : string;
  Msg        : string;       // FF0000531100000000000000000000080000
  lsLineNum : string;
  i         : integer;
  count     : byte;
  cal,giv   : byte;
  DPtr      : pbyte;
  SPtr      : pbyte;
  tmp1, tmp2 : byte;
begin
// If filtering is not enable then add the strings to the receive window ass they arrive
//    if (not cbfilterGarbage.Checked) then
//      begin
//      wrMemoWindow(cbxRDXWindowEnable,memoRx,lblReceived,RxWinLimit,RxPlace,'BRX ','Lines Received : ',sp1);
//      end;
///else if filtering is enabled the strings will be added as they are decoded
    sp1 := sp2 + sp1;
    sp2 := '';

    i := 1;
    while i <= length(sp1) do
      begin
      gByteCount := length(sp1);
      if (Ord(sp1[i+1]) = updnAddr.Position) then
      begin
        cal := Ord(sp1[i]);
        case cal of
            C1Request :
              begin
              gWholeMsg  :=  C1Responselength;
              if gByteCount >= gWholeMsg then
                begin
                sp2 := copy(sp1,i,gWholeMsg);
                responseFirmware(sp2);
                delete(sp1,i,gWholeMsg);

//              i        := 1;
                fImageRedraw := True;
                inc(NumberOfResponse);
                if (cbfilterGarbage.Checked) then
                  begin
//                  if (SMsg <> '') then
//                    begin
//                    wrMemoWindow(cbxRDXWindowEnable,memoRx,lblReceived,RxWinLimit,RxPlace,'CRX ','Lines Received : ',SMsg);
//                    SMsg := '';
//                    end;
                  wrMemoWindow(cbxRDXWindowEnable,memoRx,lblReceived,RxWinLimit,RxPlace,'DRX ','Lines Received : ',sp2);
                  end;//if (cbfilterGarbage.Checked) then
                sp2 := '';
                end//if gByteCount >= gWholeMsg then
              else
                begin
                sp2  := sp1;
                i := i + length(sp1);
                SMsg := SMsg + sp2;//ValuesToHexString(sp2); // add the bad command caharacter to the error string
                end;
              end;//C1 Request :
            else
              begin
              if (cbfilterGarbage.Checked) then
                begin
                sp2  := copy(sp1,i,1);
                SMsg := SMsg + sp2;//ValuesToHexString(sp2); // add the bad command caharacter to the error string
                end;
              i      := i + 1;
              end;//else case
          end;//case cal
        end//if (Ord(sp1[i+1]) = updnAddr.Position) then
      else // bad address
        begin
        if (cbfilterGarbage.Checked) then
          begin
          sp2  := copy(sp1,i,1);
          SMsg := SMsg + sp2;//ValuesToHexString(sp2); // add the bad command caharacter to the error string
          end;
        i      := i + 1;
        end;//else if (Ord(sp1[i+1]) = updnAddr.Position) then
      end;// while i <= length(sp1) do

      if (cbfilterGarbage.Checked) then
        begin
        if (SMsg <> '') then
          wrMemoWindow(cbxRDXWindowEnable,memoRx,lblReceived,RxWinLimit,RxPlace,'ERX ','Lines Received : ',SMsg);
          sp2:='';
          end;

      delete(sp1,1,i);
      gSerialBufNew := '';
      gByteCount  := length(sp1+sp2);  //set byte count to the length of the buffer
      Result := sp1+sp2;
end;

procedure TMainForm.tkbRecieveTimeOutChange(Sender: TObject);
begin
  lblRecievedTimeout.Caption := 'Recieve Timeout = ' + IntToStr(tkbRecieveTimeOut.Position);
end;

procedure TMainForm.tkbScrollRateChange(Sender: TObject);
begin
 if tkbScrollRate.Position < tbUpdateRate.Position then
   tbUpdateRate.Position := tkbScrollRate.Position;
 lblScrollRate.caption   := 'Scroll Rate Value: ' + InttoStr(tkbScrollRate.Position);
end;

//Set indicator color //////////////////////////////////////////////////////////////////////
procedure TMainForm.paintGUI;
begin
  fImageRedraw := False;
  setindicator(IDD1,(C3Requestdata[3] and $01));
end;

procedure TMainForm.setindicator(ind : TLabel; val : integer);
    begin
    if (val = 0) then
    begin
      ind.font.color  := clHidden;
      ind.Font.Style  := [];
      ind.Caption     := 'Hidden';
      ind.Font.Size   := 9;
    end
    else
    begin
      ind.font.color  := clShowing;
      ind.Font.Style  := [fsBold];
      ind.Font.Size   := 14;
      ind.Caption     := 'Showing';
    end;
end;

procedure TMainForm.debugDisplay();
var
  I : integer;
begin
  for I := 0 to 31 do
  begin
    debugDis[I].Caption := InttoStr(C3RequestData[I+3]);
  end;                                                  
end;

function TMainForm.calculateRate(ct : double;g : Tx;rc : boolean;l : TObject;t : TObject; s : string):Tx;
var
   i   : integer;
   cus : double; // current update speed
   cuh : double; // current update Hz
   cua : double; // current update average
begin
  if (g.us <> 0) and rc then
    begin
    cus := (ct - g.us) * 86400;
    if cus <> 0 then
      begin
      g.ar[g.ai] := cus;
      inc(g.ai);
      if g.ui < 255 then Inc(g.ui);
      cua := 0;
      for i := 0 to (g.ui - 1) do
        begin  cua := cua + g.ar[i];    end;
      cus := cua / g.ui;
      cuh := RoundTo((1 / cus),-2);
      g.s := FloatToStr(cuh) +'Hz';
      g.us := ct;
      end;//if cus <> 0 then
    end// if g.us <> 0 then
  else if rc then
    begin
    g.us := ct;
    g.ai := 0;
    end;//else if g.us <> 0 then
  TLabel(l).Caption := s + g.s + ' ' +  IntToStr(TTrackBar(t).Position);
  Result := g;
end;

procedure TMainForm.cpOutputData(s: string; rc: boolean);
var
   count     : byte;
   SMsg      : string;
   lsLineNum : string;
begin
  SMsg       := '';                                                     // start with a clean label to write on.
  if s <> '' then
    begin
    cpDrv.SendString(s);                                                // send the whole string
    LightTXOnTime := LightOnTime;                                       //
    setColorCOMLightTX(clActive,1);                                     //
    end;
  wrMemoWindow(cbxTRXWindowEnable,memoTx,lblTransmitted,TxWinLimit,TxPlace,'TX ','Lines Transmitted : ',s);
end;

procedure TMainForm.wrMemoWindow(show,memo,lbl :TObject; limit,place : integer;head,cap,s : string);
var lsLineNum : string;
    i         : integer;
    cnt       : byte;
    SMsg      : string;
begin
  if TCheckBox(show).Checked then
    begin
    SMsg := ValuesToHexString(s);

    if TMemo(memo).Lines.Count >= limit then TMemo(memo).Clear;
    lsLineNum := head + IntToStr(TMemo(memo).Lines.Count) + ' -> ';

    While length(lsLineNum) < (place + 7) do
      Insert('0',lsLineNum,4);

    TMemo(memo).Lines.Add(lsLineNum + SMsg);          {then store them in the memo Window }
    TLabel(lbl).Caption := cap + IntToStr(TMemo(memo).Lines.Count);
    end;
end;

procedure TMainForm.setColorCOMLightRX(SetColor: TColor;i : integer);
begin
  if i > 1 then Dec(i);
  if i = 1 then
    begin
    mRXLight.Brush.Color := SetColor;                       // change the comm transmit light to active
    end;
end;

procedure TMainForm.setColorCOMLightTX(SetColor: TColor;i : integer);
begin
  if i > 1 then Dec(i);
  if i = 1 then
    begin
    TXCount := 0;
    mTXLight.Brush.Color := SetColor;                         // change the comm transmit light to active
    end;
end;

procedure TMainForm.tkbPointer1Change(Sender: TObject);
var
    XX,AA    : byte;
    tmp      : word;
    II       : integer;
    worddata : word;
    DD,PP    : extended;
    AD       : extended;
begin
    AD := 0.072039072039072;
    PP:= ((degbar[0].Position/4095)*30);
    scrolldeg := degbar[0].Position;

    hexlab[0].Caption := '(0x'+IntToStr(degbar[0].Position)+')';
    if (PP < 10) then
      deglab[0].Caption:= 'Val = 00' + FloatToStrF(PP,ffFixed,4,1)
    else if (PP < 100) then
      deglab[0].Caption:= 'Val = 0' + FloatToStrF(PP,ffFixed,4,1)
    else
      deglab[0].Caption:= 'Val = ' + FloatToStrF(PP,ffFixed,4,1);
    tmp := degbar[0].Position;
    if(resetbit = false) then
    begin
      C3RequestData[0] := (tmp AND $3F);
      C3RequestData[1] := ((tmp shr 6) AND $3F);
      fC3Request := true;
    end;
end;

procedure TMainForm.TrafficLightsOff;
begin
  setColorCOMLightTX(clBtnFace,1);                             // change the comm recieve light to inactive
  setColorCOMLightRX(clBtnFace,1);                             // change the comm recieve light to inactive
end;

procedure TMainForm.memoTxKeyPress(Sender: TObject; var Key: Char);
var UserrecieveString,CharacterCreationString,StringToRecieve : string;
    CharacterPointer,CharacterToRecieve,Stringlength,BadCharPos : byte;
begin
   case Key of
    '0'..'9':;
    'A'..'F':;
    'a'..'f':;
    #8 :;
    #13:begin
        UserrecieveString := memoTx.Lines.Strings[memoTx.Lines.Count-1];
        memoTx.Lines.Delete(memoTx.Lines.Count-1);
        BadCharPos := pos('>',UserrecieveString);
        if BadCharPos <> 0 then
          begin
          memoTx.Lines.Add(UserrecieveString);
          Delete(UserrecieveString,1,BadCharPos+1);
          end;
        While pos(' ',UserrecieveString) <> 0 do
          begin
          BadCharPos := pos(' ',UserrecieveString);
          Delete(UserrecieveString,BadCharPos,1);
          end;//while
        Stringlength := length(UserrecieveString);
        CharacterPointer := 1;
        StringToRecieve := '';
        While CharacterPointer <= Stringlength do
          begin
          CharacterCreationString := '$' + UserrecieveString[CharacterPointer] + UserrecieveString[CharacterPointer+1];
          CharacterToRecieve := StrToInt(CharacterCreationString);
          StringToRecieve := StringToRecieve + Chr(CharacterToRecieve);
          CharacterPointer := CharacterPointer + 2;
          end;
        if StringToRecieve <> '' then
        begin
        parseTx(StringToRecieve);
        end;
        Key := #00;
        end;
    else Key := #00;
  end;//case
end;

procedure TMainForm.parseTx(s : String);
var
    i,j,k         : integer;
    RequestLen    : byte;
begin
    i := 1;
    if (length(s) <> 0) and (Ord(s[i]) = $FF) then
    begin
      inc(i);// increment i
      RequestLen := Ord(s[i]);
      inc(i);// increment i
      case RequestLen of
          $03: begin
            case Ord(s[i]) of
                $F0: begin
                  fC0Request := true;
                end;
                $FE: begin
                  fC1Request := true;
                end;
                $F1: begin
                  fC2Request := true;
                end;
            end;
          end;
           $23: begin
               if Ord(s[i]) = $F5 then
               begin
                  inc(i);// increment i
                  C3RequestData[0] := $FF;
                  C3RequestData[1] := $23;
                  C3RequestData[2] := $F5;
                  for j := 3 to RequestLen do
                  begin
                     C3RequestData[j] := Ord(s[i]);
                     inc(i);
                     //Label7.Caption := 'Poot' + InttoStr(i);
                  end;
                  fC3Request := true;
               end;
           end;
      end;
    end;// if length(s) <> 0 then
    //debugDisplay();
end;

procedure TMainForm.MemoTxChange(Sender: TObject);
begin
  lblTransmitted.Caption := 'Lines Transmitted : ' + IntToStr(memoTx.lines.count);
end;

procedure TMainForm.mm03s01Click(Sender: TObject);
var i : byte;
begin
  mm03s02.Checked           := mm03s01.Checked;
  mm03s01.Checked           := not mm03s01.Checked;
  gRate.ui                  := 0;
  gRate.s                   := '';
  gRate.ai                  := 0;
  gRate.us                  := 0;
  for i := 0 to 255 do
    gRate.ar[i]             := 0;
  gRate.ui                  := 0;
  gRate.uc                  := 0;
  gRateC1                   := gRate;
  gRateC2                   := gRate;
  gRateC3                   := gRate;
  gRateC4                   := gRate;
end;

procedure TMainForm.mm03s03Click(Sender: TObject);
begin
  mm03s03.Checked                 := mm03s04.Checked;
  mm03s04.Checked                 := not mm03s04.Checked;
end;

procedure TMainForm.mm03s05s01Click(Sender: TObject);
begin
  TMenuItem(Sender).Checked       := not TMenuItem(Sender).Checked;
end;

procedure TMainForm.mm04Click(Sender: TObject);
begin
  fC2Request := true;
end;

procedure TMainForm.cpGetData(instr: String);
begin
// Add the string to the recieved lines box with header info
  gSerialBufHold := gSerialBufNew;
  gSerialBufNew  := gSerialBufHold + instr;
  gSerialBufHold := '';
  gByteCount := length(gSerialBufNew);
end;

procedure TMainForm.cpDRVReceiveData(Sender: TObject; DataPtr: Pointer;
  DataSize: Cardinal);
var i : integer;
    s : string;
begin
// Convert incoming data into a string
  s := StringOfChar(' ', DataSize);                                      //
  move(DataPtr^, pchar(s)^, DataSize);                                   //
  if s = '' then exit;                                                   //
  if(not cbfilterGarbage.Checked)then
    begin
    wrMemoWindow(cbxRDXWindowEnable,memoRx,lblReceived,RxWinLimit,RxPlace,'BRX ','Lines Received : ',s);
    end;
  LightRXOnTime := LightOnTime;                                          //
  setColorCOMLightRX(clActive,1);                                        //
// Process the buffer line by line.  This breaks the buffer block into discreet lines.
  while s <> '' do                                                       //
  begin
    i := Length(s);
    cpGetData(Copy(s,1,i));                                              // Process the line
    delete(s,1,i);                                                       // then delete it.
  end;
end;

function  TMainForm.cpIntToBaud(baud: integer): string;
begin
  case baud of
     0 : Result :=   '9600';
     1 : Result :=  '19200';
     2 : Result :=  '28800';
     3 : Result :=  '38400';
     4 : Result :=  '57600';
     5 : Result :=  '76800';
     6 : Result :=  '93750';
     7 : Result := '115200';
     8 : Result :=  '12800';
    else Result :=   '9600';
    end;
end;

function  TMainForm.cpIntToBaudRate(rate: string): TBaudRate;
var irate : integer;
begin
  irate := StrToInt(rate);
  case irate of
       110 : Result := br110;
       300 : Result := br300;
       600 : Result := br600;
      1200 : Result := br1200;
      2400 : Result := br2400;
      4800 : Result := br4800;
      9600 : Result := br9600;
     14400 : Result := br14400;
     19200 : Result := br19200;
     38400 : Result := br38400;
     56000 : Result := br56000;
     57600 : Result := br57600;
    115200 : Result := br115200;
    128000 : Result := br128000;
    256000 : Result := br256000;
    else     Result := brCustom;
    end;
end;

function  TMainForm.cpParityToInt(parity: string): integer;
begin
       if parity = 'none'  then result := 0
  else if parity = 'odd'   then result := 1
  else if parity = 'even'  then result := 2
  else if parity = 'mark'  then result := 3
  else if parity = 'space' then result := 4
  else                          result := 0;
end;

function TMainForm.cpIntToParity(parity: TParity): string;
begin
  case Ord(parity) of
     1 : Result := 'odd';
     2 : Result := 'even';
     3 : Result := 'mark';
     4 : Result := 'space';
    else Result := 'none';
    end;
end;

function TMainForm.cpIntToStopBits(stopbits: TStopBits): string;
begin
  case Ord(stopbits) of
     1 : Result := '1.5';
     2 : Result := '2';
    else Result := '1';
    end;
end;

function  TMainForm.cpStopBitsToInt(stopbits: string): integer;
begin
       if stopbits = '1'   then result := 0
  else if stopbits = '1.5' then result := 1
  else if stopbits = '2'   then result := 2
  else                          result := 0;
end;

procedure TMainForm.setColorCOMLightsOff;
var i              : integer;
begin
  i                := 1;                                                      //
  setColorCOMLightRX(clDisabled,i);
  i                := 1;                                                      //
  setColorCOMLightTX(clDisabled,i);
end;

procedure TMainForm.loadStatusBarText(Sender: TObject);
begin
  StatusBar.SimpleText := Application.Hint;             // process window message
end;

procedure TMainForm.KnobRotaryMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  var pos  : integer;
begin
  pos := TShape(sender).Tag shl 1;                                            // uses tag to shift position
  if(pos > $08)then pos := 1;
  begin
    //pos shl 4;                                                                         // $10 is the last position on the rotary switch
    TShape(sender).Tag := pos;
  end;                                                                           // (this hex value will change per rotary switch)
  if(pos < $80)then TShape(sender).Tag := pos;                                // shifts bit left to increase position of "Index"
  TShape(sender).Visible := True;
  fImageRedraw := True;
  //label7.Caption := inttostr(TShape(sender).Tag);

end;

procedure TMainForm.lblCalPointClick(Sender: TObject);
begin
  degbar[0].Position := TLabel(Sender).Tag;
end;

procedure TMainForm.lblCalPointMouseEnter(Sender: TObject);
begin
  TLabel(sender).Font.Color := clBlue;
  TLabel(sender).Font.Style := [fsBold];
  TLabel(sender).Font.Height := TLabel(sender).Font.Height - 4;
end;

procedure TMainForm.lblCalPointMouseLeave(Sender: TObject);
begin
  TLabel(sender).Font.Color  := clBlack;
  TLabel(sender).Font.Style  := [];
  TLabel(sender).Font.Height := TLabel(sender).Font.Height + 4;
end;

procedure TMainForm.saveSettings;
var
  sini     : TIniFile;
begin
  if FileExists('C:\simtekinc\' + fileCFG) then
    sini      := TIniFile.Create('C:\simtekinc\' + fileCFG)
  else
    begin
    sini      := TIniFile.Create('C:\simtekinc\' + fileCFG);
    end;
  With sini      do
    begin
    WriteString(InstSec, InstSecK02, gPort);                             // Save the open com port
    WriteString(InstSec, InstSecK03, gBaud);                             // Set the default baud rate for startup
    WriteString(GENSec,  GenSecK03,  gDataBits);                         // Set the default Data word length
    WriteString(GENSec,  GenSecK04,  gStopBits);                         // Set the default Parity mode for startup
    WriteString(InstSec, GenSecK05,  gParity);                           // Set the default Number of Stop bits
//    WriteInteger(GENSec,  GenSecK06, integer(CPDrv.HwFlow));             // Set the default Number of Stop bits
//    WriteInteger(GENSec,  GenSecK07, integer(CPDrv.SwFlow));             // Set the default Number of Stop bits
//    WriteInteger(GENSec,  GenSecK08, Ord(CPDrv.EnableDTROnOpen));        //
//    WriteInteger(GENSec,  GenSecK09, Ord(CPDrv.CheckLineStatus));        //
//    WriteInteger(GENSec,  GenSecK10, CPDrv.InBufSize);                   // Set the default Number of Stop bits
//    WriteInteger(GENSec,  GenSecK11, CPDrv.OutBufSize);                  // Set the default Number of Stop bits
//    WriteString(GENSec,  GenSecK12,  assembleFont(memoLog));             // Set the default Number of Stop bits
//    WriteString(GENSec,  GenSecK13,  assembleFont(memoTx));              // Set the default Number of Stop bits
//    WriteString(GENSec,  GenSecK14,  assembleFont(memoRx));              // Set the default Number of Stop bits
//    WriteString(GENSec,  GenSecK15,  assembleFont(memoRawRx));           // Set the default Number of Stop bits
//////////////////////////////////////////////////////////////////////////
    end;
  sini.Free;
end;

procedure TMainForm.setMomentaryBtn(button : TObject);

begin
end;

procedure TMainForm.shpIndicatorMouseDown(Sender: TObject; Button: TMouseButton;   //////////////////////////////////////////////
  Shift: TShiftState; X, Y: Integer);
begin
 if((C4RequestData[2] and TShape(Sender).Tag) = TShape(Sender).Tag)then
    C4RequestData[2] := C4RequestData[2] and (not TShape(Sender).Tag)
  else
    C4RequestData[2] := C4RequestData[2] or TShape(Sender).Tag;

  fC4Request := True;
  fImageRedraw := True;
end;

procedure TMainForm.Indicator2MouseDown(Sender: TObject; Button: TMouseButton;   //////////////////////////////////////////////
  Shift: TShiftState; X, Y: Integer);
begin
 if((C4RequestData[3] and TShape(Sender).Tag) = TShape(Sender).Tag)then
    C4RequestData[3] := C4RequestData[3] and (not TShape(Sender).Tag)
  else
    C4RequestData[3] := C4RequestData[3] or TShape(Sender).Tag;

  fC4Request := True;
  fImageRedraw := True;
end;

procedure TMainForm.Indicator3MouseDown(Sender: TObject; Button: TMouseButton;   //////////////////////////////////////////////
  Shift: TShiftState; X, Y: Integer);
begin
 if((C4RequestData[4] and TShape(Sender).Tag) = TShape(Sender).Tag)then
    C4RequestData[4] := C4RequestData[4] and (not TShape(Sender).Tag)
  else
    C4RequestData[4] := C4RequestData[4] or TShape(Sender).Tag;

  fC4Request := True;
  fImageRedraw := True;
end;

procedure TMainForm.parseFont(memo: TRichEdit; sf,section,key: string; sini: TIniFile);
begin
  if(sf = '')then
    begin
    sf                        :=                sini.ReadString(section, key, dsf);
    if(sf = '')then
      begin
      sf                      :=                dsf;
      end;
    end;
  memo.Lines.Delimiter        :=                ',';
  memo.Lines.DelimitedText    :=                sf;
  memo.Font.Name              :=                memo.Lines.Strings[0];
  memo.Font.Size              :=                StrToInt(memo.Lines.Strings[1]);
  memo.Font.Color             :=                StringToColor(memo.Lines.Strings[2]);
  memo.Color                  :=                StringToColor(memo.Lines.Strings[3]);
  memo.Clear;
end;

procedure TMainForm.cpSetComPort;
var i        : integer;                                       //
begin
  if cpDrv.Connected then                                     // check to make sure the port is closed
    begin
    cpDrv.Disconnect;                                         // disconnect the com port
    setColorCOMLightsOff;                                     // deactivate comm line lights
    end;
  gParity := 'odd';

  cpDrv.PortName            := '\\.\'+gPort;                  // assign the port
  cpDrv.BaudRate            := cpIntToBaudRate(gBaud);        // set the baud rate
  cpDrv.BaudRateValue       := StrToInt(gBaud);               // set the default baud rate
  cpDrv.Parity              := TParity(cpParityToInt(gParity));// set the parity
  cpDrv.Databits            := TDataBits(StrToInt(gDataBits));// set the number of data bits
  cpDrv.StopBits            := TStopBits(cpStopBitsToInt(gStopBits)); // set the number of stop bits

  CPDrv.HwFlow              := THwFlowControl(0);             //
  CPDrv.SwFlow              := TSwFlowControl(0);             //
  CPDrv.EnableDTROnOpen     := False;                         //
  CPDrv.CheckLineStatus     := False;                         //
  CPDrv.InBufSize           := 65536;                         //
  CPDrv.OutBufSize          := 2048;                          //
  setColorCOMLightsOff;                                       // deactivate comm line lights
  try
    cpDrv.Connect;                                            // open the com port
    mm04.Enabled            := cpDrv.Connected;               // deactivate all comport dependent menu functions
    if mm04.Enabled then                                      // make sure that the port is open
      begin
      saveSettings;                                           // save new settings to INI file
      mm04.Enabled          := True;                          // set the status menu item to active
      i                     := 1;                             //
      setColorCOMLightTX(clInactive,i);                       // Show the port as active
      i                     := 1;                             //
      setColorCOMLightRX(clInactive,i);                       // Show the port as active
      end
    else
      MessageDlg('Error Port Not Opened Properly!',mtError,[mbOk],0);
  except
    MessageDlg('Error Port Not Opened Properly!',mtError,[mbOk],0);
  end;
  mm03.Enabled              := mm04.Enabled;                  // enable the menu item if the com port was opened
  mm05.Enabled              := mm04.Enabled;                  // enable the menu item if the com port was opened

  Application.OnHint        := loadStatusBarText;             // reset the window message to recieve
  Application.ShowHint      := True;                          // enable the messaging
  MainForm.Caption          := buildMainCaption;              // show the com port settings on the main form bar
  cbValidPorts.Text         := gPort;                         //
  cbBaudRate.Text           := gBaud;                         //
end;

procedure TMainForm.load_deg_from_degbox(Sender: TObject;AA: byte);
var
  s   : string;
  num : extended;
  err : integer;
begin
  if (scrollbit) then
  exit
  else
  begin
    s:= degbox[AA].Text;
    val(s,num,err);
    if ((err = 0) and (num <= 30)) then
    begin
      err:= Round((num/30)*4095);
      degbar[AA].Position:= err;
    end//if err = 0 then
    else
    begin
      MessageDlg('Invalid value.  Please reenter the value',mtError,[mbOk],0);
      num := ((degbar[0].Position/4095)*30);
      num := RoundTo(num,-1);
      degbox[AA].Text := FloatToStr(num);
    end;//else
  end; //else scrollbit
end;

procedure TMainForm.azdegbuttonMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    load_deg_from_degbox(Sender,0);
end;

function TMainForm.buildMainCaption: string;
var s,s2 : string;
begin
    s := InstRevInf;
    if cpDrv.Connected then
    begin
     s2 := '   ' + cpDrv.PortName;
     s2 := AnsiUpperCase(s2);
     Delete(s2, 1, pos('C',s2)-1);

     s := s + ' ' + s2 + ' ';
     case ord(cpDrv.BaudRate) of
       1  : s := s + ' 110';    //       br110
       2  : s := s + ' 300';    //       br300
       3  : s := s + ' 600';    //       br600
       4  : s := s + ' 1200';   //       br1200
       5  : s := s + ' 2400';   //       br2400
       6  : s := s + ' 4800';   //       br4800
       7  : s := s + ' 9600';   //       br9600
       8  : s := s + ' 14400';  //       br14400
       9  : s := s + ' 19200';  //       br19200
       10 : s := s + ' 38400';  //       br38400
       11 : s := s + ' 56000';  //       br56000
       12 : s := s + ' 57600';  //       br57600
       13 : s := s + ' 115200'; //       br115200
       14 : s := s + ' 128000'; //       br128000
       15 : s := s + ' 256000'; //       br256000
       else s := s + ' ' + IntToStr(cpDrv.BaudRateValue);
     end;
     s := s + ',' + IntToStr(5+ord(cpDrv.DataBits)) + ',1';

     s := s + ',' + cpIntToStopBits(cpDrv.StopBits);
//     case ord(cpDrv.StopBits) of
//       0  :  s := s + ',1';
//       1  :  s := s + ',1.5';
//       2  :  s := s + ',2';
//      else   s := s + ',Error';
//     end;
     s := s + ',' + cpIntToParity(cpDrv.Parity);
//     case ord(cpDrv.Parity) of
//       0  :  s := s + ',None';
//       1  :  s := s + ',Odd';
//       2  :  s := s + ',Even';
//       3  :  s := s + ',Mark';
//       4  :  s := s + ',Space';
//       else  s := s + ',Error';
//     end;
    end
  else
    begin
    s := s + ' com port not connected';
    end;
  Result := s;
end;
end.

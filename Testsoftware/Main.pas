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
  lenDefault         = 3;        // this should be the length of the shortest message returned

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
  C1DeviceValDefault = ': 7?-???? Rev ? : 7?-???? Rev ?';
  C1Response         = C1Request;
  C1Responselength   = 10;

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

//  C4Command          = 'Display';
//  C4Request          = $F2; // display toggle
//  C4Requestlength    = 35;//35
//  C4CapHeader        = C4Command + ' Transmit speed = ';
//  C4Response         = C4Request;
//  C4Responselength   = 0;

//  C2Command          = 'Realtime Report Buttons';
//  C2Request          = $22; // Firmware information
//  C2Requestlength    = 0;
//  C2CapHeader        = C2Command + ' Transmit speed = ';
//  C2DeviceValDefault = ': 7?-???? Rev ?';
//  C2Response         = C2Request;
//  C2Responselength   = 4;
//
//  C3Command          = 'Realtime Report Potentiometer';
//  C3Request          = $23; // Display Request
//  C3Requestlength    = 0;
//  C3CapHeader        = C3Command + ' Transmit speed = ';
//  C3Response         = C3Request;
//  C3Responselength   = 6;

  // Descriptive labels to use with routines
  lblDimming1Cap     = 'Panel Dimming Level = ';
  lblDimming1Hint    = 'Shows Display Brightness Value';
  lblDimming2Cap     = 'Indicator Dimming Level = ';
  lblDimming2Hint    = 'Shows Indicator Brightness Value';

  clActive           = clLime;
  clInactive         = clWhite;
  clDisabled         = clGray;
  //LightOnTime      = 20;

  clShowing          = clWhite;
  clHidden           = clBlack;
  lblBxbxValDefault  = ': unknown';

  adTop        : integer = 365;
  adBot        : integer = 400;
  cdTop        : integer = 365;
  cdBot        : integer = 400;
  alarmTop     : integer = 290;
  alarmbot     : integer = 382;

  rdTop        : integer = 158;
  rdMid        : integer = 176;
  rdBot        : integer = 196;

  //StartByte = $FE;
  //SECTION = '10883801';




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
    Label8: TLabel;
    MemoTx: TRichEdit;
    CPDrv: TCommPortDriver;
    MemoRx: TRichEdit;
    cbfilterGarbage: TCheckBox;
    pointer: TTrackBar;
    cdegbox: TEdit;
    cdeg: TLabel;
    ELab: TLabel;
    SLab: TLabel;
    WLab: TLabel;
    AddrLab: TLabel;
    updnAddr: TUpDown;
    Label3: TLabel;
    cbAddress: TComboBox;
    tkbC3UpdateRate: TTrackBar;
    lblC3TransmitRate: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    IDD0: TLabel;
    IDD1: TLabel;
    NLab: TLabel;
    lblFPData: TLabel;
    Label1: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label9: TLabel;

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
    procedure decodeRecievedData(s : string);
    procedure decodeSerial(var sp1, sp2 : string);
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
    procedure mm09Click(Sender: TObject);
    procedure pointerChange(Sender: TObject);
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
    //*************************************************************************************************************
  private
    { Private declarations }
    procedure initializeDisplay(cnt : integer);
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

//  PanelMap                  : TBitMap; // holds the bitmap for the instrument face
//  OSBitMap                  : TBitMap; // off-screen bitmap you do your drawing on

// variables for serial message shortfalls
  gSerialBuffer             : string  = '';          //
  gSerialBufferSMsg         : string  = '';          //
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
  dScrollValue              : byte = 0;
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
//  fC7Request                : boolean  = false; //
//  fC8Request                : boolean  = false; //
//  fScrollReq                : boolean  = False; // scroll change flag
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

  slidebar                : array[0..1] of TTrackBar;
  slidelab                : array[0..1] of TLabel;
  slidebyte               : array[0..3] of byte;
  sinbyte                 : array[0..5] of byte;
  cosbyte                 : array[0..5] of byte;
  degbar                  : array[0..2] of TTrackBar;
  sinlab                  : array[0..2] of TLabel;
  coslab                  : array[0..2] of TLabel;
  deglab                  : array[0..2] of TLabel;
  degbox                  : array[0..2] of TEdit;

  An                      : array[0..10] of TLabel;

implementation

//uses UAbout, PortDlg;
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
//         Label2.caption := inttostr(ord(scrollbit));
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
procedure TMainForm.mm09Click(Sender: TObject);
begin
end;

//procedure TMainForm.About1Click(Sender: TObject);
//var AboutForm : TAboutBox;
//begin
//AboutForm := TAboutBox.Create(Self);
//AboutForm.ShowModal;
//end;

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
  //lblFirmwareValue3.Caption := C1DeviceValDefault;
end;



//procedure TMainForm.debugDisplay_setup();
//begin
//end;
procedure TMainForm.initializeDisplay(cnt : integer); // sets the display to be blank at start up
//var
begin
end;


procedure TMainForm.FormCreate(Sender: TObject);
var i, tmp            : integer;
    SimtekIni    : TIniFile;
begin

  hWind := MainForm.Handle; //get a handle to the main window.                                                                               // clear out the transmit window.
  memoTx.Clear;                                                                               // clear out the transmit window.
  memoRx.Clear;                                                                               // clear out the receive window.
                                                                                 // clear out the receive window.
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
  degbar[0]                       := Compass;
  deglab[0]                       := cdeg;
  degbox[0]                       := cdegbox;
  responseReset;
  fImageRedraw                    := true;
  DXTimer1.Enabled                := true;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Any background operations in other threads must be closed here
  if hComm <> INVALID_HANDLE_VALUE then CloseHandle(hComm);
//  if PanelMap.Handle <> INVALID_HANDLE_VALUE then PanelMap.Free;
//  if OSBitMap.Handle <> INVALID_HANDLE_VALUE then OSBitMap.Free;
end;

procedure TMainForm.DisplayHint1(Sender: TObject);
begin
  StatusBar.simpleText := Application.Hint;
end;


{function TMainForm.calcPot(leftnibble, rightnibble : byte) : byte;
begin
    leftnibble := leftnibble shl 4;  //shift left 4

    Result:= leftnibble or rightnibble;

end;    }

procedure TMainForm.responseReset;
begin
    TrafficLightsOff;                          // Turn off the communications status indicators
    memoTx.Clear;                              // Blank the dataout and datain
    memoRx.Clear;                              // Blank the dataout and datain

    mm06.Caption                     := '&'+C0Command;
    mm08.Caption                     := C1Command;

    mm03s05s01.Caption               := '&'+C1Command;
    mm03s05s02.Caption               := '&'+C2Command;
//  mm03s05s03.Caption               := '&'+C3Command;


    lblFirmwareValue1.Caption        := C1DeviceValDefault;
    lblFirmwareValue2.Caption        := C1DeviceValDefault;
    //lblFirmwareValue3.Caption        := C1DeviceValDefault;
    //tkbDimming1Old                   := 4096;
    //tkbDimming2Old                   := 4096;

    lblScrollRate.caption   := 'Scroll Rate Value: ' + InttoStr(tkbScrollRate.Position);

    MainForm.Caption                 := buildMainCaption;       //
    lblTransmitRate.Caption          := TSCapHeader + '0.00Hz';
    lblC1TransmitRate.Caption        := C1CapHeader + '0.00Hz';
    lblC2TransmitRate.Caption        := C2CapHeader + '0.00Hz';
//    lblC3TransmitRate.Caption        := C3CapHeader + '0.00Hz';

    {jetToggle.Top                    := jetTop;
    masterToggle.Top                 := masterBot;
    ecmToggle.Top                    := ecmBot;
    ircmToggle.Top                   := ircmBot;}

    lblTestSoftwarePNValue.Caption   := lblTestSoftwareCap;
    lblTestSoftwareRevValue.Caption  := lblTestSoftwareRev;
    lblWARNING.Caption               := lblWARNINGCaption;

    C4RequestData[2] := $00;
    C4RequestData[3] := $00;
    C4RequestData[4] := $00;
    C4RequestData[5] := $00;

    //    initializeDisplay(5);
    toggleBool := TRUE;
    degbar[0].Position    := 0;
    scrolldeg             := 0;
    cdegbox.Text          := '000.0';
    resetbit              := false;
    scrcount              := 0;
    scrolldirection       := false;
    updnBaudRate.Position := 0;
    fImageRedraw          := True;
//    ActiveControl                    := UserImage;
end;

procedure TMainForm.responseStatus(ptrCK: pbyte);        // ask how to fix this function
begin
  inc(ptrCK);                    // ff

//  ButtonLeft.Tag          := (ptrCK^ and $01);                                              // individual pushbuttons
//  inc (ptrCK);
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
    b2 := Ord(s[7]);
    b1 := ((b2 shr 4) and $0F) or $30;
    b2 := (b2 and $0F) or $30;
    si := ': ' + chr(b1) + chr(b2) + '-';
    b2 := Ord(s[8]);
    b1 := ((b2 shr 4) and $0F) or $30;
    b2 := (b2 and $0F) or $30;
    si := si + chr(b1) + chr(b2);
    b2 := Ord(s[9]);
    b1 := ((b2 shr 4) and $0F) or $30;
    b2 := (b2 and $0F) or $30;
    si := si + chr(b1) + chr(b2) + ' rev ';
    si := si + s[10];
    lblFirmwareValue2.Caption := si;
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
//r ofset : integer;
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
//  if cbxResponse.Checked then   ofset :=  60
//  else                          ofset :=   0;
//    lblPot2TrapZero.caption       := IntToStr(ScrollBar2.Position);
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
//  C0Command          = 'Reset';      C0Request          = $90; // Reset Request
//  C1Command          = 'Options';    C1Request          = $91; // Options Change Request
//  C2Command          = 'Firmware';   C2Request          = $92; // Firmware information
//  C3Command          = 'Displays';   C3Request          = $A0; // Display Request
//  C4Command          = 'Indicator';  C4Request          = $A1; // Indicator/Annunciator Change Request
//  C5Command          = 'Dimming';    C5Request          = $B0; // Dimming Change Request
//  C6Command          = 'Status';     C6Request          = $D0; // Input Status Request
    C0Request  : begin               // reset

      s        := s + chr(C0Request);
      s        := s + chr(updnAddr.Position);
      inc(NumberOfRequests);
      end;
    C1Request  : begin               // firmware
//      s        := s + chr(StartByte);
//      s        := s + chr($03);
      s        := s + chr(C1Request);
      s        := s + chr(updnAddr.Position);
      inc(NumberOfRequests);
      end;
    C2Request  : begin               // status
//      s        := s + chr(StartByte);
//      s        := s + chr($03);
      s        := s + chr(C2Request);
      s        := s + chr(updnAddr.Position);
      inc(NumberOfRequests);
    end;
    C3Request  : begin                // display
//      s        := s + chr(StartByte);
      s        := s + chr(C3Request);
      s        := s + chr(updnAddr.Position);
      s        := s + Chr(C3RequestData[0]);      // 01
      s        := s + Chr(C3RequestData[1]);      // 02
      s        := s + Chr((C3RequestData[3] and $01));      // 02
      inc(NumberOfRequests);
      end;
      C4Request  : begin                // Indicators
//      s        := s + chr(StartByte);
      s        := s + chr(C4Request);
      s        := s + chr(updnAddr.Position);
      s        := s + Chr(C4RequestData[2]);      // 01
      s        := s + Chr(C4RequestData[3]);      // 02
      s        := s + Chr(C4RequestData[4]);      // 03
      s        := s + Chr(C4RequestData[5]);      // 04
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
        if StringToRecieve <> '' then decodeRecievedData(StringToRecieve);
        Key := #00;
        end;
    else Key := #00;
  end;//case
end;


procedure TMainForm.MemoRxChange(Sender: TObject);
begin
  lblReceived.Caption := 'Lines Received : ' + IntToStr(memoRx.lines.count);
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

//procedure TMainForm.cdegboxKeyDown(Sender: TObject; var Key: Word;
//  Shift: TShiftState);
//begin
//if (scrollbit) then
//  exit;
//  case key of
//   '0'..'9':;
//   '.':;
//   #13: load_deg_from_degbox(Sender,0);
//   #8:;
//  end;
//end;

procedure TMainForm.cdegboxKeyPress(Sender: TObject; var Key: Char);
begin
  if (scrollbit = True) then
  exit
  else
  begin
  case key of
   '0'..'9':;
   '.':;
   #13: begin key := #0; load_deg_from_degbox(Sender,0); degbox_selectall(Sender,0); end;
   #8:;
  end
  end;
end;

procedure TMainForm.scrolleverything();
begin
    if(scrolldirection) then
      begin
      degbar[0].Position:= scrolldeg;
      if (scrolldeg = 0) then
        begin
        scrolldeg:= 3000;

        if scrcount = 0 then scrolldirection := false
        else scrolldirection := true;
        dec(scrcount);
        end
      else
        dec(scrolldeg);
      end
    else
      begin
      degbar[0].Position:= scrolldeg;
      if (scrolldeg = 3000) then
        begin
        scrolldeg:= 0;
        inc(scrcount);
        if scrcount = 1 then scrolldirection:=true
        else scrolldirection:=false;
        end
      else
        inc(scrolldeg);
      end;
    fC3Request := true;
end;

function  TMainForm.cleanRxBuffer(len : integer) : string;
var x : integer;
begin
//    Result := mem2str(gSerialBuffer,len);
  x        := 1;
  while(x <= len)do
  begin
    Result := Result + IntToHex(ord(gSerialBuffer[x]),2) + ' ';
    inc(x);
  end;
  delete(gSerialBuffer,1,len);
  gByteCount := length(gSerialBuffer);
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
  rxtimeout                   := tkbRecieveTimeOut.Position;
  wrstr                       := '';
  lblRequestsSent.Caption     := ': ' + IntToStr(NumberOfRequests);
  lblResponseRecieved.Caption := ': ' + IntToStr(NumberOfResponse);

  if (gByteCount >= gWholeMsg ) then
    begin
    decodeSerial(gSerialBuffer,gSerialBufferSMsg);
    end;//if (gByteCount >= gWholeByte)


  if fScrollReq then
    begin
    if ScrollCount > tkbScrollRate.Position then
      begin
      scrollEverything();
      if dScrollValue > 57 then dScrollValue := 1;
      fImageRedraw    := True;
      ScrollCount     := 255;
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

    //if li <> 0 then
//      begin
      for counter  := 1 to li do
        begin
        wrstr           := wdlist[counter];
        wdlist[counter] := '';
        if counter       = li then ratecalc := True else  ratecalc := False;
        cpOutputData(wrstr, ratecalc);
        end;//for counter := 1 to li do
//      end;//if li <> 0 then
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

procedure  TMainForm.decodeSerial(var sp1, sp2 : string);
var     // sp1 = gSerialBuffer    sp2 = gSerialBufferSMsg
  SMsg       : string;
  s1         : string;       // FF0000531100000000000000000000080000
  tmp1, tmp2 : byte;
  i          : integer;
begin
  sp1          := sp1 + sp2;   // add message to the buffer
  sp2          := '';         // clean out the message


  gByteCount  := length(sp1);  //set byte count to the length of the buffer
  SMsg := ' ';
  while(gByteCount >= gWholeMsg) do   // whole message is the minimum sized message I should recieve
  begin
    tmp1 := ord(sp1[1]);
    if tmp1 = $FF then     // make sure a valid start byte is there
    begin
      tmp1 := ord(sp1[2]);
      if (tmp1= $F1) then
      begin
        gWholeMsg  :=  C2Responselength;
        if ((gByteCount < gWholeMsg)) then     // check to see if message is long enough
        begin
          Exit; // not enough then I need to  exit this function
        end
        else
        begin
          if (ord(sp1[3])=$20) then
          begin
            sp1[3]:= sp1[4];
          end;
          decodeRecievedData(copy(sp1,1,C2Responselength));   // send it here cause I already set up this function
          cleanRxBuffer(C2Responselength)             // get rid of the message
        end;
      end
      else if (tmp1= $FE) then
      begin
        gWholeMsg  :=  C1Responselength;
        if gByteCount < gWholeMsg then
        begin
          Exit;
        end
        else
        begin
          decodeRecievedData(copy(sp1,1,C1Responselength));
          cleanRxBuffer(C1Responselength)
        end;
      end
      else
      begin
           SMsg := cleanRxBuffer(3);  // not start byte
           //wrMemoWindow(cbxRDXWindowEnable,memoRx,lblReceived,RxWinLimit,RxPlace,'RX ','Lines Received : ',SMsg);
      end;
    end
    else
    begin
      //wrMemoWindow(cbxRDXWindowEnable,memoRx,lblReceived,RxWinLimit,RxPlace,'RX ','Lines Received : ',copy(sp1,1,5));
      SMsg := cleanRxBuffer(1);
    end;
  end;// while
    if (cbfilterGarbage.Checked = false) then
    begin                                                   //
    wrMemoWindow(cbxRDXWindowEnable,memoRx,lblReceived,RxWinLimit,RxPlace,'RX ','Lines Received : ',SMsg);
    end;                                   //
end;

procedure TMainForm.decodeRecievedData(s: string);
var
  SMsg      : string;
  lsLineNum : string;
  i         : integer;
  count     : byte;
  cal,giv   : byte;
  DPtr      : pbyte;
  SPtr      : pbyte;

  //0- reset 1- status 2-rtbuttons 3-rtpot 4-displays 5-firmware
begin
  if length(s) <> 0 then
    begin
    i := 1;
    while i <= length(s) do
      begin
      if (Ord(s[i]) = $FF) then
      begin
        if (Ord(s[i+1]) = $F1) then
        begin
//          if((Ord(s[i+2]) = $F1)) then
//          begin
          SPtr     := Addr(s[i+2]);
          DPtr     := Addr(C2ResponseData[1]);
          CopyMemory(DPtr, SPtr, C2Responselength);
          responseStatus(DPtr);
          i        := i + C2Responselength;
          fImageRedraw := True;
          inc(NumberOfResponse);
//          end;
        end//case = C1Response
        else if (Ord(s[i+1]) = $FE) then
        begin
            // program revision
          responseFirmware(s);
          i        := i + C1Responselength;
          fImageRedraw := True;
          inc(NumberOfResponse);
        end//case = C5Response
        else
          begin
          i          := i + length(s);
          end;
        end;// case Ord(s[i]) of
      end;// while i <= length(s) do
    end;// if length(s) <> 0 then

  wrMemoWindow(cbxRDXWindowEnable,memoRx,lblReceived,RxWinLimit,RxPlace,'RX ','Lines Received : ',s);
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
  setindicator(IDD0,((not C3Requestdata[3]) and $01));
end;

procedure TMainForm.setindicator(ind : TLabel; val : integer);
    begin
    if (val = 0) then
    begin
      ind.font.color:= clHidden;
    end
    else
    begin
     ind.font.color:= clShowing;
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
   i         : integer;
   count     : byte;
   SMsg      : string;
   lsLineNum : string;
begin
  SMsg       := '';                                                     // start with a clean label to write on.
  if s <> '' then
    begin
    cpDrv.SendString(s);                                                // send the whole string
    //LightTXOnTime := LightOnTime;                                       //
    i        := 1;                                                      //
    setColorCOMLightTX(clActive,i);                                   //
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
    cnt := length(s);
    SMsg  := '';
    for i := 1 to cnt do {Loop through the buffer and}
      SMsg  := SMsg + IntToHex(ord(s[i]),2)+' '; {Convert the bytes to a pascal string}

    if TMemo(memo).Lines.Count >= limit then TMemo(memo).Clear;
    lsLineNum := head + IntToStr(TMemo(memo).Lines.Count) + ' -> ';

    While length(lsLineNum) < (place + 7) do
      Insert('0',lsLineNum,4);

    TMemo(memo).Lines.Add(lsLineNum + SMsg);          {then store them in the RX Window }
    TLabel(lbl).Caption := cap + IntToStr(TMemo(memo).Lines.Count);
    end;
end;

procedure TMainForm.setColorCOMLightRX(SetColor: TColor;i : integer);
begin
  if i > 1 then Dec(i);
  if i = 1 then
    begin
    //mRXLight.Brush.Color := SetColor;                       // change the comm transmit light to active
    end;
end;

procedure TMainForm.setColorCOMLightTX(SetColor: TColor;i : integer);
begin
  if i > 1 then Dec(i);
  if i = 1 then
    begin
    TXCount := 0;
    //mTXLight.Brush.Color := SetColor;                         // change the comm transmit light to active
    end;
end;

procedure TMainForm.pointerChange(Sender: TObject);
var
    XX,AA    : byte;
    tmp      : word;
    II       : integer;
    worddata : word;
    DD,PP    : extended;
    AD       : extended;
begin
    AD := 0.072039072039072;
    PP:= (degbar[0].Position/10);

//    if(((PP >= 0) and (PP < 90)) or (PP = 300)) then NLab.Font.color := clBlue
//    else NLab.Font.color := clBlack;
//    if ((PP >= 90) and (PP < 180)) then ELab.Font.color := clBlue
//    else ELab.Font.color := clBlack;
//    if ((PP >= 180) and (PP < 270)) then SLab.Font.color := clBlue
//    else SLab.Font.color := clBlack;
//    if ((PP >= 270) and (PP < 300)) then WLab.Font.color := clBlue
//    else WLab.Font.color := clBlack;

    if (PP < 10) then
      deglab[0].Caption:= 'Deg = 00' + FloatToStrF(PP,ffFixed,4,1)
    else if (PP < 100) then
      deglab[0].Caption:= 'Deg = 0' + FloatToStrF(PP,ffFixed,4,1)
    else
      deglab[0].Caption:= 'Deg = ' + FloatToStrF(PP,ffFixed,4,1);

    tmp := Round((PP)/AD);

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
  gSerialBufferSMsg := gSerialBufferSMsg + instr;
  gByteCount := length(gSerialBuffer+gSerialBufferSMsg);
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
//  gParity := 'none';

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
s : string;
num : extended;
err : integer;
begin
  if (scrollbit) then
  exit
  else
  begin
    s:= degbox[AA].Text;
    val(s,num,err);
    if ((err = 0) and (num < 360)) then
    begin
      err:= Round(num*10);
      degbar[AA].Position:= err;
    end//if err = 0 then
    else
    begin
      MessageDlg('Invalid value.  Please reenter the value',mtError,[mbOk],0)
    end;//else
  end; //else scrollbit
//typebit:= false;
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
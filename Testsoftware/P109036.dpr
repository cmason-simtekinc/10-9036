program P109036;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  CPDrv in 'CPDrv.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;

  end.

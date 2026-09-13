program XlsFilterUnified;

{$IFDEF WIN32}
  // Обеспечивает запуск на Windows XP (5.1), Vista (6.0), 7 (6.1), 8, 10 и 11
  {$SETPEOSVERSION 5.1}
  {$SETPESUBSYSVERSION 5.1}
{$ENDIF}

uses
  Vcl.Forms,
  ufmMain in 'ufmMain.pas' {fmMain},
  uDataLoader in 'uDataLoader.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Единый фильтр уголовных дел ИЦ МВД';
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.

program XlsFilterUnified;

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

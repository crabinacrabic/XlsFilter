unit ufmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Grids, uDataLoader;

type
  TfmMain = class(TForm)
    pnlTop: TPanel;
    btnOpenFile: TButton;
    lblLoadedFile: TLabel;
    ProgressBar1: TProgressBar;
    PageControl1: TPageControl;
    tsAuto: TTabSheet;
    tsManual: TTabSheet;
    tsHelp: TTabSheet;
    pnlAutoTop: TPanel;
    btnFindRepeated: TButton;
    btnExportRepeated: TButton;
    lblAutoStats: TLabel;
    lbRepeated: TListBox;
    pnlManualTop: TPanel;
    lblDocNum: TLabel;
    edtDocNum: TEdit;
    lblDate: TLabel;
    edtDate: TEdit;
    btnFilterManual: TButton;
    btnResetManual: TButton;
    gridManual: TStringGrid;
    memoHelp: TMemo;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure btnOpenFileClick(Sender: TObject);
    procedure btnFindRepeatedClick(Sender: TObject);
    procedure btnExportRepeatedClick(Sender: TObject);
    procedure btnFilterManualClick(Sender: TObject);
    procedure btnResetManualClick(Sender: TObject);
    procedure gridManualDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    FCurrentFile: string;
    FSourceGrid: TStringGrid;
    procedure UpdateProgress(Current, Total: Integer);
    procedure AutoSizeGrid(Grid: TStringGrid);
  public
    destructor Destroy; override;
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

destructor TfmMain.Destroy;
begin
  FSourceGrid.Free;
  inherited;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  Caption := 'Единый фильтр уголовных дел ИЦ МВД (Версии 1 + 2 + 3)';
  FSourceGrid := TStringGrid.Create(Self);
  FSourceGrid.Visible := False;
  ProgressBar1.Visible := False;
  PageControl1.ActivePageIndex := 0;

  memoHelp.Lines.Clear;
  memoHelp.Lines.Add('========================================================================');
  memoHelp.Lines.Add('ЕДИНЫЙ ФИЛЬТР УГОЛОВНЫХ ДЕЛ ИЦ МВД (Delphi 10 / 11 / 12 / RAD Studio)');
  memoHelp.Lines.Add('========================================================================');
  memoHelp.Lines.Add('');
  memoHelp.Lines.Add('1. ВКЛАДКА "?? АНАЛИЗ ПОВТОРОВ (Версия 3)":');
  memoHelp.Lines.Add('   - Автоматически находит все уголовные дела с повторными отменами и');
  memoHelp.Lines.Add('     возобновлениями предварительного следствия/дознания (где возобновлений > 1).');
  memoHelp.Lines.Add('   - Группирует дела по связке (Код ОВД + Номер дела) во времени.');
  memoHelp.Lines.Add('   - Позволяет сохранить итоговый реестр в файл кнопкой "Экспорт в TXT".');
  memoHelp.Lines.Add('');
  memoHelp.Lines.Add('2. ВКЛАДКА "?? РУЧНОЙ ПОИСК (Версия 1)":');
  memoHelp.Lines.Add('   - Позволяет быстро найти конкретное дело или группу дел.');
  memoHelp.Lines.Add('   - Поддерживает ввод номеров через запятую: 58954, 1050301, 177907');
  memoHelp.Lines.Add('   - Подсвечивает ключевые колонки зеленым и красным цветом.');
  memoHelp.Lines.Add('');
  memoHelp.Lines.Add('3. СТАТЬИ УПК РФ В БАЗЕ ДАННЫХ:');
  memoHelp.Lines.Add('   - ст. 208 ч. 1 п. 1 ? лицо, подлежащее привлечению, не установлено (83%+ базы);');
  memoHelp.Lines.Add('   - ст. 208 ч. 1 п. 2 ? обвиняемый скрылся либо место нахождения не установлено;');
  memoHelp.Lines.Add('   - ст. 208 ч. 1 п. 3 ? место известно, но участие временно невозможно;');
  memoHelp.Lines.Add('   - ст. 208 ч. 1 п. 4 ? временное тяжелое заболевание подозреваемого/обвиняемого;');
  memoHelp.Lines.Add('   - ст. 24 ч. 1 п. 4 ? смерть подозреваемого или обвиняемого;');
  memoHelp.Lines.Add('   - ст. 427 ч. 5 ? отмена мер воспитательного воздействия в отношении подростка;');
  memoHelp.Lines.Add('   - Решения прокурора: отмена постановлений и возврат следователю/дознавателю.');
end;

procedure TfmMain.UpdateProgress(Current, Total: Integer);
begin
  ProgressBar1.Max := Total;
  ProgressBar1.Position := Current;
  Application.ProcessMessages;
end;

procedure TfmMain.AutoSizeGrid(Grid: TStringGrid);
var
  c, r, maxW, textW: Integer;
begin
  for c := 0 to Grid.ColCount - 1 do
  begin
    maxW := 60;
    for r := 0 to Grid.RowCount - 1 do
    begin
      textW := Grid.Canvas.TextWidth(Grid.Cells[c, r]);
      if textW > maxW then maxW := textW;
    end;
    Grid.ColWidths[c] := maxW + 16;
  end;
end;

procedure TfmMain.btnOpenFileClick(Sender: TObject);
var
  count: Integer;
begin
  OpenDialog1.InitialDir := ExtractFilePath(ParamStr(0));
  if OpenDialog1.Execute then
  begin
    FCurrentFile := OpenDialog1.FileName;
    ProgressBar1.Visible := True;
    try
      count := TDataLoader.LoadTable(FCurrentFile, FSourceGrid,
        procedure(Cur, Tot: Integer)
        begin
          UpdateProgress(Cur, Tot);
        end
      );
      lblLoadedFile.Caption := Format('Загружен файл: %s (Записей: %d)', [ExtractFileName(FCurrentFile), count]);
      btnResetManualClick(Sender);
      ShowMessage(Format('Файл успешно загружен!'#13#10'Всего строк: %d', [count]));
    finally
      ProgressBar1.Visible := False;
    end;
  end;
end;

procedure TfmMain.btnFindRepeatedClick(Sender: TObject);
type
  TCaseRecord = record
    sgLine: Integer;
    OvdCode: string;
    DocNum: string;
    fCount: Integer;
    DatesList: string;
    DecisionsList: string;
  end;
var
  x, i, totalRepeated: Integer;
  Cache: array of TCaseRecord;
  rowOvd, rowDoc, rowDate, rowDec: string;
  found: Boolean;
begin
  if FSourceGrid.RowCount <= 1 then
  begin
    ShowMessage('Сначала откройте файл таблицы!');
    Exit;
  end;

  lbRepeated.Clear;
  SetLength(Cache, 0);
  ProgressBar1.Visible := True;
  ProgressBar1.Max := FSourceGrid.RowCount;

  try
    for x := 1 to FSourceGrid.RowCount - 1 do
    begin
      rowOvd := Trim(FSourceGrid.Cells[1, x]);
      rowDoc := Trim(FSourceGrid.Cells[3, x]);
      rowDate := Trim(FSourceGrid.Cells[7, x]);
      rowDec := Trim(FSourceGrid.Cells[6, x]);

      if rowDoc = '' then Continue;

      found := False;
      for i := Low(Cache) to High(Cache) do
      begin
        if (Cache[i].DocNum = LowerCase(rowDoc)) and
           ((rowOvd = '') or (Cache[i].OvdCode = LowerCase(rowOvd))) then
        begin
          Inc(Cache[i].fCount);
          if Pos(rowDate, Cache[i].DatesList) = 0 then
            Cache[i].DatesList := Cache[i].DatesList + ', ' + rowDate;
          found := True;
          Break;
        end;
      end;

      if not found then
      begin
        SetLength(Cache, Length(Cache) + 1);
        Cache[Length(Cache) - 1].sgLine := x;
        Cache[Length(Cache) - 1].OvdCode := LowerCase(rowOvd);
        Cache[Length(Cache) - 1].DocNum := LowerCase(rowDoc);
        Cache[Length(Cache) - 1].fCount := 1;
        Cache[Length(Cache) - 1].DatesList := rowDate;
        Cache[Length(Cache) - 1].DecisionsList := rowDec;
      end;

      if x mod 1000 = 0 then
      begin
        ProgressBar1.Position := x;
        Application.ProcessMessages;
      end;
    end;

    totalRepeated := 0;
    for x := Low(Cache) to High(Cache) do
    begin
      if Cache[x].fCount > 1 then
      begin
        Inc(totalRepeated);
        lbRepeated.Items.Add(Format(
          'ОВД: %-3s | Дело №: %-8s | Возобновлений: [%2d] | Строка: %-5d | Даты: %s',
          [Cache[x].OvdCode, Cache[x].DocNum, Cache[x].fCount, Cache[x].sgLine, Cache[x].DatesList]
        ));
      end;
    end;

    lblAutoStats.Caption := Format('Всего уголовных дел: %d  |  Дел с повторными возобновлениями (> 1): %d',
      [Length(Cache), totalRepeated]);

    ShowMessage(Format(
      'Анализ завершен!'#13#10 +
      'Всего уголовных дел в базе: %d'#13#10 +
      'Найдено дел с повторными отменами и возобновлениями: %d',
      [Length(Cache), totalRepeated]
    ));
  finally
    ProgressBar1.Visible := False;
  end;
end;

procedure TfmMain.btnExportRepeatedClick(Sender: TObject);
begin
  if lbRepeated.Items.Count = 0 then
  begin
    ShowMessage('Нет данных для сохранения! Сначала выполните поиск повторов.');
    Exit;
  end;

  SaveDialog1.InitialDir := ExtractFilePath(ParamStr(0));
  SaveDialog1.FileName := 'Повторные_возобновления.txt';
  if SaveDialog1.Execute then
  begin
    ForceDirectories(ExtractFileDir(SaveDialog1.FileName));
    lbRepeated.Items.SaveToFile(SaveDialog1.FileName);
    ShowMessage('Результаты успешно сохранены в файл:'#13#10 + SaveDialog1.FileName);
  end;
end;

procedure TfmMain.btnFilterManualClick(Sender: TObject);
var
  j, i, targetRow: Integer;
  valDoc, valDate, cDate: string;
  matchDoc, matchDate: Boolean;
begin
  if FSourceGrid.RowCount <= 1 then
  begin
    ShowMessage('Сначала откройте файл таблицы!');
    Exit;
  end;

  cDate := Trim(LowerCase(edtDate.Text));
  gridManual.RowCount := 1;
  gridManual.ColCount := FSourceGrid.ColCount;

  for i := 0 to FSourceGrid.ColCount - 1 do
    gridManual.Cells[i, 0] := FSourceGrid.Cells[i, 0];

  targetRow := 1;
  for j := 1 to FSourceGrid.RowCount - 1 do
  begin
    valDoc := FSourceGrid.Cells[3, j];
    valDate := FSourceGrid.Cells[7, j];

    matchDoc := TDataLoader.MatchDocumentTokens(valDoc, edtDocNum.Text);
    matchDate := (cDate = '') or (LowerCase(Trim(valDate)) = cDate);

    if matchDoc and matchDate and ((Trim(edtDocNum.Text) <> '') or (cDate <> '')) then
    begin
      gridManual.RowCount := targetRow + 1;
      for i := 0 to FSourceGrid.ColCount - 1 do
        gridManual.Cells[i, targetRow] := FSourceGrid.Cells[i, j];
      Inc(targetRow);
    end;
  end;

  AutoSizeGrid(gridManual);
  ShowMessage(Format('Найдено записей по вашему фильтру: %d', [targetRow - 1]));
end;

procedure TfmMain.btnResetManualClick(Sender: TObject);
var
  j, i: Integer;
begin
  if FSourceGrid.RowCount <= 1 then Exit;

  gridManual.RowCount := FSourceGrid.RowCount;
  gridManual.ColCount := FSourceGrid.ColCount;

  for j := 0 to FSourceGrid.RowCount - 1 do
    for i := 0 to FSourceGrid.ColCount - 1 do
      gridManual.Cells[i, j] := FSourceGrid.Cells[i, j];

  AutoSizeGrid(gridManual);
end;

procedure TfmMain.gridManualDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
const
  clPaleGreen = TColor($CCFFCC);
  clPaleRed = TColor($CCCCFF);
begin
  if gdFocused in State then
  begin
    gridManual.Canvas.Brush.Color := clBlack;
    gridManual.Canvas.Font.Color := clWhite;
  end
  else
  begin
    if (ACol = 3) or (ACol = 7) then
      gridManual.Canvas.Brush.Color := clPaleGreen
    else
      gridManual.Canvas.Brush.Color := clPaleRed;
  end;

  if (ACol >= 0) and (ARow >= 0) then
  begin
    gridManual.Canvas.FillRect(Rect);
    gridManual.Canvas.TextOut(Rect.Left + 4, Rect.Top + 3, gridManual.Cells[ACol, ARow]);
  end;
end;

end.

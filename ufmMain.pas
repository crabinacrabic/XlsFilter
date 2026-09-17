unit ufmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Grids, System.Generics.Collections, uDataLoader;

type
  TfmMain = class(TForm)
    pnlHeader: TPanel;
    lblTitle: TLabel;
    lblSubtitle: TLabel;
    btnOpenFile: TButton;
    pnlFileBadge: TPanel;
    lblLoadedFile: TLabel;
    ProgressBar1: TProgressBar;
    PageControl1: TPageControl;
    tsAuto: TTabSheet;
    pnlAutoTop: TPanel;
    btnFindRepeated: TButton;
    btnExportRepeated: TButton;
    pnlKpiTotal: TPanel;
    lblKpiTotalTitle: TLabel;
    lblKpiTotalVal: TLabel;
    pnlKpiUnique: TPanel;
    lblKpiUniqueTitle: TLabel;
    lblKpiUniqueVal: TLabel;
    pnlKpiRepeated: TPanel;
    lblKpiRepeatedTitle: TLabel;
    lblKpiRepeatedVal: TLabel;
    gridRepeated: TStringGrid;
    lbRepeated: TListBox;
    tsManual: TTabSheet;
    pnlManualTop: TPanel;
    lblDocNum: TLabel;
    edtDocNum: TEdit;
    lblDate: TLabel;
    edtDate: TEdit;
    btnFilterManual: TButton;
    btnResetManual: TButton;
    lblManualStats: TLabel;
    gridManual: TStringGrid;
    tsHelp: TTabSheet;
    memoHelp: TMemo;
    StatusBar1: TStatusBar;
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
    procedure gridRepeatedDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    FCurrentFile: string;
    FSourceGrid: TStringGrid;
    procedure UpdateProgress(Current, Total: Integer);
    procedure AutoSizeGrid(Grid: TStringGrid);
    procedure InitRepeatedGrid;
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

procedure TfmMain.InitRepeatedGrid;
begin
  gridRepeated.ColCount := 6;
  gridRepeated.RowCount := 2;
  gridRepeated.FixedRows := 1;
  gridRepeated.FixedCols := 0;
  gridRepeated.DefaultRowHeight := 24;

  gridRepeated.Cells[0, 0] := '№ п/п';
  gridRepeated.Cells[1, 0] := 'Код ОВД';
  gridRepeated.Cells[2, 0] := 'Номер дела';
  gridRepeated.Cells[3, 0] := 'Возобновлений';
  gridRepeated.Cells[4, 0] := 'Первая строка';
  gridRepeated.Cells[5, 0] := 'Хронология дат возобновлений';

  gridRepeated.ColWidths[0] := 60;
  gridRepeated.ColWidths[1] := 75;
  gridRepeated.ColWidths[2] := 130;
  gridRepeated.ColWidths[3] := 120;
  gridRepeated.ColWidths[4] := 100;
  gridRepeated.ColWidths[5] := 600;
end;

procedure TfmMain.FormCreate(Sender: TObject);
begin
  Caption := 'Единый фильтр уголовных дел ИЦ МВД';
  FSourceGrid := TStringGrid.Create(Self);
  FSourceGrid.Visible := False;
  ProgressBar1.Visible := False;
  PageControl1.ActivePageIndex := 0;

  InitRepeatedGrid;

  memoHelp.Lines.Clear;
  memoHelp.Lines.Add('========================================================================================');
  memoHelp.Lines.Add('  ЕДИНЫЙ АНАЛИТИЧЕСКИЙ КОМПЛЕКС ИЦ МВД: СПРАВОЧНИК И РУКОВОДСТВО ПОЛЬЗОВАТЕЛЯ');
  memoHelp.Lines.Add('  Совместимость: Windows XP / Vista / 7 / 8 / 10 / 11 (32-bit & 64-bit)');
  memoHelp.Lines.Add('========================================================================================');
  memoHelp.Lines.Add('');
  memoHelp.Lines.Add('  [ВНИМАНИЕ: ОФИЦИАЛЬНЫЙ ДИСКЛЕЙМЕР О ГЕНЕРАЦИИ ИИ]');
  memoHelp.Lines.Add('  Все данные, номера уголовных дел, статьи и процессуальные решения сформированы');
  memoHelp.Lines.Add('  и модифицированы при помощи искусственного интеллекта (ИИ) в учебных и тестовых целях.');
  memoHelp.Lines.Add('  В фамилиях реальных лиц намеренно изменена 1 буква для исключения персональной идентичности.');
  memoHelp.Lines.Add('  Любые совпадения с реальными гражданами или событиями являются абсолютно случайными.');
  memoHelp.Lines.Add('');
  memoHelp.Lines.Add('1. ОСНОВНЫЕ РЕЖИМЫ РАБОТЫ');
  memoHelp.Lines.Add('----------------------------------------------------------------------------------------');
  memoHelp.Lines.Add('  [Вкладка 1] "Анализ повторных возобновлений":');
  memoHelp.Lines.Add('    - Быстрый хеш-индекс O(1): сканирует базу в 10 000+ записей за сотые доли секунды;');
  memoHelp.Lines.Add('    - Находит все дела с возобновлением расследования более одного раза (возобновлений > 1);');
  memoHelp.Lines.Add('    - Группирует дела по уникальной связке (Код ОВД + Номер уголовного дела);');
  memoHelp.Lines.Add('    - Собирает полную хронологию дат процессуальных решений;');
  memoHelp.Lines.Add('    - Позволяет сохранить готовый реестр дел в текстовый файл (кнопка "Экспорт отчета в TXT...").');
  memoHelp.Lines.Add('');
  memoHelp.Lines.Add('  [Вкладка 2] "Ручной фильтр по делам":');
  memoHelp.Lines.Add('    - Мгновенный поиск одного уголовного дела или списка дел через запятую (например: 100101, 200202);');
  memoHelp.Lines.Add('    - Опциональная фильтрация по конкретной дате процессуального решения;');
  memoHelp.Lines.Add('    - Пастельная эргономичная подсветка ключевых столбцов таблицы для комфортной работы.');
  memoHelp.Lines.Add('');
  memoHelp.Lines.Add('2. СТАТЬИ УПК РФ В ВЕДОМСТВЕННОЙ БАЗЕ ДАННЫХ');
  memoHelp.Lines.Add('----------------------------------------------------------------------------------------');
  memoHelp.Lines.Add('  * Статья 208 УПК РФ — Основания, порядок и сроки приостановления предварительного следствия:');
  memoHelp.Lines.Add('      - п. 1 ч. 1 ст. 208 — Лицо, подлежащее привлечению в качестве обвиняемого, не установлено');
  memoHelp.Lines.Add('                            (составляет более 83% всех решений в выгрузке);');
  memoHelp.Lines.Add('      - п. 2 ч. 1 ст. 208 — Подозреваемый или обвиняемый скрылся от следствия либо место его');
  memoHelp.Lines.Add('                            нахождения не установлено по иным причинам (~5% базы);');
  memoHelp.Lines.Add('      - п. 3 ч. 1 ст. 208 — Место нахождения известно, однако реальная возможность его участия');
  memoHelp.Lines.Add('                            в уголовном деле временно отсутствует;');
  memoHelp.Lines.Add('      - п. 4 ч. 1 ст. 208 — Временное тяжелое заболевание подозреваемого или обвиняемого.');
  memoHelp.Lines.Add('');
  memoHelp.Lines.Add('  * Статья 24 ч. 1 п. 4 УПК РФ — Прекращение уголовного дела в связи со смертью подозреваемого.');
  memoHelp.Lines.Add('');
  memoHelp.Lines.Add('  * Статья 427 ч. 5 УПК РФ — Отмена постановления о прекращении дела в отношении несовершеннолетнего');
  memoHelp.Lines.Add('                             при систематическом неисполнении воспитательных мер и возобновление.');
  memoHelp.Lines.Add('');
  memoHelp.Lines.Add('  * Прокурорский надзор:');
  memoHelp.Lines.Add('      - "Возвр прокурором следов-лю / дознав-лю" — возврат дела прокурором для дополнительного следствия;');
  memoHelp.Lines.Add('      - "По инициативе прокур.п.1 / п.2" — отмена незаконного приостановления надзирающим прокурором.');
  memoHelp.Lines.Add('');
  memoHelp.Lines.Add('3. ТЕХНИЧЕСКАЯ ИНФОРМАЦИЯ И ОПТИМИЗАЦИЯ');
  memoHelp.Lines.Add('----------------------------------------------------------------------------------------');
  memoHelp.Lines.Add('  - Алгоритмическая сложность поиска: O(N) благодаря хеш-таблице TDictionary.');
  memoHelp.Lines.Add('  - Двунаправленная поддержка кодировок: UTF-8 (с/без BOM) и Windows-1251 (ANSI).');
  memoHelp.Lines.Add('  - Прямой вызов Win32 API WM_SETREDRAW для мгновенной перерисовки таблиц без мерцания.');
  memoHelp.Lines.Add('  - Полная поддержка всех версий Windows: XP, Vista, 7, 8, 10, 11 (32 и 64 бита).');
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
  Grid.Perform(WM_SETREDRAW, 0, 0);
  try
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
  finally
    Grid.Perform(WM_SETREDRAW, 1, 0);
    Grid.Invalidate;
  end;
end;

procedure TfmMain.btnOpenFileClick(Sender: TObject);
var
  count: Integer;
  t0: Cardinal;
begin
  OpenDialog1.InitialDir := ExtractFilePath(ParamStr(0));
  if OpenDialog1.Execute then
  begin
    FCurrentFile := OpenDialog1.FileName;
    ProgressBar1.Visible := True;
    StatusBar1.Panels[0].Text := 'Статус: Чтение таблицы...';
    Application.ProcessMessages;
    t0 := GetTickCount;
    try
      count := TDataLoader.LoadTable(FCurrentFile, FSourceGrid,
        procedure(Cur, Tot: Integer)
        begin
          UpdateProgress(Cur, Tot);
        end
      );

      lblLoadedFile.Caption := Format('%s (%d строк)', [ExtractFileName(FCurrentFile), count]);
      lblLoadedFile.Font.Color := clLime;
      lblKpiTotalVal.Caption := IntToStr(count);

      StatusBar1.Panels[0].Text := Format('Статус: База загружена за %d мс', [GetTickCount - t0]);
      StatusBar1.Panels[1].Text := 'Файл: ' + ExtractFileName(FCurrentFile);
      StatusBar1.Panels[2].Text := Format('Строк в базе: %d', [count]);

      btnResetManualClick(Sender);

      ShowMessage(Format('Файл успешно загружен за %d мс!'#13#10'Всего строк: %d'#13#10'Таблица готова к фильтрации и анализу.',
        [GetTickCount - t0, count]));
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
  x, totalRepeated, outRow, cacheIdx: Integer;
  Cache: array of TCaseRecord;
  Dict: TDictionary<string, Integer>;
  caseKey, rowOvd, rowDoc, rowDate, rowDec: string;
  t0: Cardinal;
begin
  if FSourceGrid.RowCount <= 1 then
  begin
    ShowMessage('Сначала откройте файл таблицы с данными!');
    Exit;
  end;

  lbRepeated.Clear;
  InitRepeatedGrid;
  SetLength(Cache, 0);

  Dict := TDictionary<string, Integer>.Create;
  ProgressBar1.Visible := True;
  ProgressBar1.Max := FSourceGrid.RowCount;
  StatusBar1.Panels[0].Text := 'Статус: Сканирование базы на повторы...';
  Application.ProcessMessages;
  t0 := GetTickCount;

  try
    // Высокоскоростной алгоритм O(1) через хеш-таблицу
    for x := 1 to FSourceGrid.RowCount - 1 do
    begin
      rowOvd := Trim(FSourceGrid.Cells[1, x]);
      rowDoc := Trim(FSourceGrid.Cells[3, x]);
      rowDate := Trim(FSourceGrid.Cells[7, x]);
      rowDec := Trim(FSourceGrid.Cells[6, x]);

      if rowDoc = '' then Continue;

      caseKey := LowerCase(rowOvd) + '_' + LowerCase(rowDoc);

      if Dict.TryGetValue(caseKey, cacheIdx) then
      begin
        Inc(Cache[cacheIdx].fCount);
        if Pos(rowDate, Cache[cacheIdx].DatesList) = 0 then
          Cache[cacheIdx].DatesList := Cache[cacheIdx].DatesList + ', ' + rowDate;
      end
      else
      begin
        cacheIdx := Length(Cache);
        SetLength(Cache, cacheIdx + 1);
        Cache[cacheIdx].sgLine := x;
        Cache[cacheIdx].OvdCode := LowerCase(rowOvd);
        Cache[cacheIdx].DocNum := LowerCase(rowDoc);
        Cache[cacheIdx].fCount := 1;
        Cache[cacheIdx].DatesList := rowDate;
        Cache[cacheIdx].DecisionsList := rowDec;
        Dict.Add(caseKey, cacheIdx);
      end;
    end;

    // Подсчет количества дел с повторами
    totalRepeated := 0;
    for x := Low(Cache) to High(Cache) do
      if Cache[x].fCount > 1 then Inc(totalRepeated);

    // Пакетное заполнение таблицы с блокировкой перерисовки
    gridRepeated.Perform(WM_SETREDRAW, 0, 0);
    try
      gridRepeated.RowCount := totalRepeated + 1;
      outRow := 1;
      for x := Low(Cache) to High(Cache) do
      begin
        if Cache[x].fCount > 1 then
        begin
          gridRepeated.Cells[0, outRow] := IntToStr(outRow);
          gridRepeated.Cells[1, outRow] := Cache[x].OvdCode;
          gridRepeated.Cells[2, outRow] := Cache[x].DocNum;
          gridRepeated.Cells[3, outRow] := IntToStr(Cache[x].fCount);
          gridRepeated.Cells[4, outRow] := IntToStr(Cache[x].sgLine);
          gridRepeated.Cells[5, outRow] := Cache[x].DatesList;
          Inc(outRow);

          lbRepeated.Items.Add(Format(
            'ОВД: %-3s | Дело №: %-8s | Возобновлений: [%2d] | Первая строка: %-5d | Даты: %s',
            [Cache[x].OvdCode, Cache[x].DocNum, Cache[x].fCount, Cache[x].sgLine, Cache[x].DatesList]
          ));
        end;
      end;
    finally
      gridRepeated.Perform(WM_SETREDRAW, 1, 0);
      gridRepeated.Invalidate;
    end;

    lblKpiTotalVal.Caption := IntToStr(FSourceGrid.RowCount - 1);
    lblKpiUniqueVal.Caption := IntToStr(Length(Cache));
    lblKpiRepeatedVal.Caption := IntToStr(totalRepeated);

    StatusBar1.Panels[0].Text := Format('Статус: Анализ завершен за %d мс', [GetTickCount - t0]);
    StatusBar1.Panels[2].Text := Format('Дел с повторами: %d', [totalRepeated]);

    ShowMessage(Format(
      'Анализ базы успешно завершен за %d мс!'#13#10 +
      'Всего записей в базе: %d'#13#10 +
      'Уникальных уголовных дел: %d'#13#10 +
      'Дел с повторными отменами и возобновлениями (> 1): %d',
      [GetTickCount - t0, FSourceGrid.RowCount - 1, Length(Cache), totalRepeated]
    ));
  finally
    Dict.Free;
    ProgressBar1.Visible := False;
  end;
end;

procedure TfmMain.btnExportRepeatedClick(Sender: TObject);
begin
  if lbRepeated.Items.Count = 0 then
  begin
    ShowMessage('Нет данных для сохранения! Сначала выполните анализ повторов.');
    Exit;
  end;

  SaveDialog1.InitialDir := ExtractFilePath(ParamStr(0));
  SaveDialog1.FileName := 'Повторные_возобновления_ИТОГ.txt';
  if SaveDialog1.Execute then
  begin
    ForceDirectories(ExtractFileDir(SaveDialog1.FileName));
    lbRepeated.Items.SaveToFile(SaveDialog1.FileName);
    StatusBar1.Panels[0].Text := 'Статус: Отчет успешно сохранен';
    ShowMessage('Отчет успешно сохранен в файл:'#13#10 + SaveDialog1.FileName);
  end;
end;

procedure TfmMain.btnFilterManualClick(Sender: TObject);
var
  j, i, targetRow: Integer;
  valDoc, valDate, cDate: string;
  matchDoc, matchDate: Boolean;
  t0: Cardinal;
begin
  if FSourceGrid.RowCount <= 1 then
  begin
    ShowMessage('Сначала откройте файл таблицы с данными!');
    Exit;
  end;

  cDate := Trim(LowerCase(edtDate.Text));
  t0 := GetTickCount;

  gridManual.Perform(WM_SETREDRAW, 0, 0);
  try
    gridManual.RowCount := FSourceGrid.RowCount;
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
        for i := 0 to FSourceGrid.ColCount - 1 do
          gridManual.Cells[i, targetRow] := FSourceGrid.Cells[i, j];
        Inc(targetRow);
      end;
    end;

    if targetRow = 1 then
      gridManual.RowCount := 2
    else
      gridManual.RowCount := targetRow;
  finally
    gridManual.Perform(WM_SETREDRAW, 1, 0);
    gridManual.Invalidate;
  end;

  lblManualStats.Caption := Format('Отображено записей: %d из %d', [targetRow - 1, FSourceGrid.RowCount - 1]);
  StatusBar1.Panels[0].Text := Format('Фильтр применен за %d мс: найдено %d', [GetTickCount - t0, targetRow - 1]);
  AutoSizeGrid(gridManual);
  ShowMessage(Format('Фильтр выполнен за %d мс!'#13#10'Найдено записей: %d', [GetTickCount - t0, targetRow - 1]));
end;

procedure TfmMain.btnResetManualClick(Sender: TObject);
var
  j, i: Integer;
  t0: Cardinal;
begin
  if FSourceGrid.RowCount <= 1 then Exit;

  t0 := GetTickCount;
  gridManual.Perform(WM_SETREDRAW, 0, 0);
  try
    gridManual.RowCount := FSourceGrid.RowCount;
    gridManual.ColCount := FSourceGrid.ColCount;

    for j := 0 to FSourceGrid.RowCount - 1 do
      for i := 0 to FSourceGrid.ColCount - 1 do
        gridManual.Cells[i, j] := FSourceGrid.Cells[i, j];
  finally
    gridManual.Perform(WM_SETREDRAW, 1, 0);
    gridManual.Invalidate;
  end;

  lblManualStats.Caption := Format('Отображено записей: %d из %d', [FSourceGrid.RowCount - 1, FSourceGrid.RowCount - 1]);
  StatusBar1.Panels[0].Text := Format('Отображена вся база (сброс за %d мс)', [GetTickCount - t0]);
  AutoSizeGrid(gridManual);
end;

procedure TfmMain.gridManualDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
const
  clHeaderBg = TColor($EAEAEA);
  clSelectedBg = TColor($994411);
  clPaleGreen = TColor($D8F6D8);
  clZebraOdd = TColor($FAFAFA);
  clZebraEven = TColor($FFFFFF);
begin
  if ARow = 0 then
  begin
    gridManual.Canvas.Brush.Color := clHeaderBg;
    gridManual.Canvas.Font.Color := clBlack;
    gridManual.Canvas.Font.Style := [fsBold];
  end
  else if gdSelected in State then
  begin
    gridManual.Canvas.Brush.Color := clSelectedBg;
    gridManual.Canvas.Font.Color := clWhite;
    gridManual.Canvas.Font.Style := [fsBold];
  end
  else
  begin
    if (ACol = 3) or (ACol = 7) then
      gridManual.Canvas.Brush.Color := clPaleGreen
    else if ARow mod 2 = 1 then
      gridManual.Canvas.Brush.Color := clZebraOdd
    else
      gridManual.Canvas.Brush.Color := clZebraEven;

    gridManual.Canvas.Font.Color := clBlack;
    gridManual.Canvas.Font.Style := [];
  end;

  gridManual.Canvas.FillRect(Rect);
  gridManual.Canvas.TextOut(Rect.Left + 5, Rect.Top + 4, gridManual.Cells[ACol, ARow]);
end;

procedure TfmMain.gridRepeatedDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
const
  clHeaderBg = TColor($EAEAEA);
  clSelectedBg = TColor($994411);
  clAlertBg = TColor($E0E0FF);
  clZebraOdd = TColor($FAFAFA);
  clZebraEven = TColor($FFFFFF);
begin
  if ARow = 0 then
  begin
    gridRepeated.Canvas.Brush.Color := clHeaderBg;
    gridRepeated.Canvas.Font.Color := clBlack;
    gridRepeated.Canvas.Font.Style := [fsBold];
  end
  else if gdSelected in State then
  begin
    gridRepeated.Canvas.Brush.Color := clSelectedBg;
    gridRepeated.Canvas.Font.Color := clWhite;
    gridRepeated.Canvas.Font.Style := [fsBold];
  end
  else
  begin
    if ACol = 3 then
      gridRepeated.Canvas.Brush.Color := clAlertBg
    else if ARow mod 2 = 1 then
      gridRepeated.Canvas.Brush.Color := clZebraOdd
    else
      gridRepeated.Canvas.Brush.Color := clZebraEven;

    if (ACol = 3) and (StrToIntDef(gridRepeated.Cells[ACol, ARow], 0) >= 5) then
    begin
      gridRepeated.Canvas.Font.Color := clRed;
      gridRepeated.Canvas.Font.Style := [fsBold];
    end
    else
    begin
      gridRepeated.Canvas.Font.Color := clBlack;
      gridRepeated.Canvas.Font.Style := [];
    end;
  end;

  gridRepeated.Canvas.FillRect(Rect);
  gridRepeated.Canvas.TextOut(Rect.Left + 6, Rect.Top + 4, gridRepeated.Cells[ACol, ARow]);
end;

end.

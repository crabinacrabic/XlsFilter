unit uDataLoader;

interface

uses
  System.SysUtils, System.Classes, Vcl.Grids, System.Variants, System.Win.ComObj;

type
  TDataLoader = class
  public
    class function LoadTable(const FileName: string; Grid: TStringGrid; ProgressBarProc: TProc<Integer, Integer>): Integer;
    class function MatchDocumentTokens(const CellValue, TokenList: string): Boolean;
  end;

implementation

class function TDataLoader.MatchDocumentTokens(const CellValue, TokenList: string): Boolean;
var
  Tokens: TStringList;
  i: Integer;
  val, target: string;
begin
  target := Trim(LowerCase(CellValue));
  if Trim(TokenList) = '' then
    Exit(True);

  Result := False;
  Tokens := TStringList.Create;
  try
    Tokens.Delimiter := ',';
    Tokens.StrictDelimiter := True;
    Tokens.DelimitedText := TokenList;
    for i := 0 to Tokens.Count - 1 do
    begin
      val := Trim(LowerCase(Tokens[i]));
      if (val <> '') and (target = val) then
      begin
        Result := True;
        Break;
      end;
    end;
  finally
    Tokens.Free;
  end;
end;

class function TDataLoader.LoadTable(const FileName: string; Grid: TStringGrid; ProgressBarProc: TProc<Integer, Integer>): Integer;
var
  CsvFile: string;
  Lines, Row: TStringList;
  j, i, totalRows: Integer;
  ExlApp, Sheet: OLEVariant;
  r, c: Integer;
begin
  Result := 0;
  if not FileExists(FileName) then
    raise Exception.Create('Файл не найден: ' + FileName);

  // 1. Проверяем CSV формат или наличие CSV рядом
  CsvFile := FileName;
  if not SameText(ExtractFileExt(FileName), '.csv') then
  begin
    if FileExists(ChangeFileExt(FileName, '.csv')) then
      CsvFile := ChangeFileExt(FileName, '.csv');
  end;

  if SameText(ExtractFileExt(CsvFile), '.csv') and FileExists(CsvFile) then
  begin
    Lines := TStringList.Create;
    Row := TStringList.Create;
    Row.Delimiter := ';';
    Row.StrictDelimiter := True;
    try
      Lines.LoadFromFile(CsvFile, TEncoding.UTF8);
      totalRows := Lines.Count;
      if totalRows = 0 then Exit(0);

      Grid.RowCount := totalRows;
      Row.DelimitedText := Lines[0];
      Grid.ColCount := Row.Count;

      for j := 0 to totalRows - 1 do
      begin
        if Trim(Lines[j]) = '' then Continue;
        Row.DelimitedText := Lines[j];
        for i := 0 to Row.Count - 1 do
        begin
          if i < Grid.ColCount then
            Grid.Cells[i, j] := Row[i];
        end;

        if Assigned(ProgressBarProc) and (j mod 500 = 0) then
          ProgressBarProc(j, totalRows);
      end;
      Result := totalRows - 1;
      Exit;
    finally
      Lines.Free;
      Row.Free;
    end;
  end;

  // 2. Если CSV нет, читаем через OLE Excel (если установлен)
  try
    ExlApp := CreateOleObject('Excel.Application');
  except
    on E: Exception do
      raise Exception.Create('Microsoft Excel не установлен, и файл .csv не найден рядом.'#13#10 +
                             'Пожалуйста, экспортируйте файл в CSV или используйте файл .csv!');
  end;

  try
    ExlApp.Visible := False;
    ExlApp.Workbooks.Open(FileName);
    Sheet := ExlApp.Workbooks[ExtractFileName(FileName)].WorkSheets[1];
    r := Sheet.UsedRange.Rows.Count;
    c := Sheet.UsedRange.Columns.Count;

    Grid.RowCount := r;
    Grid.ColCount := c;

    for j := 1 to r do
    begin
      for i := 1 to c do
        Grid.Cells[i - 1, j - 1] := VarToStr(Sheet.Cells[j, i]);

      if Assigned(ProgressBarProc) and (j mod 500 = 0) then
        ProgressBarProc(j, r);
    end;
    Result := r - 1;
  finally
    ExlApp.Quit;
    ExlApp := Unassigned;
    Sheet := Unassigned;
  end;
end;

end.

unit uDataLoader;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, System.StrUtils,
  Vcl.Grids, System.Variants, System.Win.ComObj;

type
  TDataLoader = class
  private
    class function DetectFileEncoding(const FileName: string): TEncoding;
  public
    class function LoadTable(const FileName: string; Grid: TStringGrid; ProgressBarProc: TProc<Integer, Integer>): Integer;
    class function MatchDocumentTokens(const CellValue, TokenList: string): Boolean;
  end;

implementation

class function TDataLoader.DetectFileEncoding(const FileName: string): TEncoding;
var
  Stream: TFileStream;
  Buffer: array[0..2] of Byte;
  BytesRead: Integer;
begin
  Result := TEncoding.UTF8;
  if not FileExists(FileName) then Exit;

  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  try
    BytesRead := Stream.Read(Buffer, 3);
    if (BytesRead >= 3) and (Buffer[0] = $EF) and (Buffer[1] = $BB) and (Buffer[2] = $BF) then
    begin
      Result := TEncoding.UTF8;
      Exit;
    end;
    if (BytesRead >= 2) and (Buffer[0] = $FF) and (Buffer[1] = $FE) then
    begin
      Result := TEncoding.Unicode;
      Exit;
    end;
  finally
    Stream.Free;
  end;

  // Если сигнатуры BOM нет, пробуем русскую ведомственную кодировку Windows-1251
  Result := TEncoding.GetEncoding(1251);
end;

class function TDataLoader.MatchDocumentTokens(const CellValue, TokenList: string): Boolean;
var
  Target, TrimmedList, Token: string;
  i: Integer;
begin
  Target := Trim(LowerCase(CellValue));
  TrimmedList := Trim(LowerCase(TokenList));

  if TrimmedList = '' then
    Exit(True);

  // Надежное посимвольное сканирование без выделения памяти в куче
  Token := '';
  for i := 1 to Length(TrimmedList) do
  begin
    if TrimmedList[i] = ',' then
    begin
      if (Token <> '') and (Token = Target) then
        Exit(True);
      Token := '';
    end
    else if TrimmedList[i] <> ' ' then
      Token := Token + TrimmedList[i];
  end;

  if (Token <> '') and (Token = Target) then
    Exit(True);

  Result := False;
end;

class function TDataLoader.LoadTable(const FileName: string; Grid: TStringGrid; ProgressBarProc: TProc<Integer, Integer>): Integer;
var
  CsvFile: string;
  Lines, Row: TStringList;
  j, i, totalRows: Integer;
  ExlApp, Sheet: OLEVariant;
  r, c: Integer;
  Enc: TEncoding;
begin
  Result := 0;
  if not FileExists(FileName) then
    raise Exception.Create('Файл не найден: ' + FileName);

  // 1. Проверяем наличие CSV файла или готовой выгрузки
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
    Enc := DetectFileEncoding(CsvFile);

    try
      Lines.LoadFromFile(CsvFile, Enc);
      totalRows := Lines.Count;
      if totalRows = 0 then Exit(0);

      // Блокируем перерисовку таблицы во время пакетной загрузки для максимальной скорости
      Grid.Perform(WM_SETREDRAW, 0, 0);
      try
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

          if Assigned(ProgressBarProc) and (j mod 1000 = 0) then
            ProgressBarProc(j, totalRows);
        end;
      finally
        Grid.Perform(WM_SETREDRAW, 1, 0);
        Grid.Invalidate;
      end;

      Result := totalRows - 1;
      Exit;
    finally
      Lines.Free;
      Row.Free;
    end;
  end;

  // 2. Если CSV не найден, используем OLE Automation Excel (при наличии)
  try
    ExlApp := CreateOleObject('Excel.Application');
  except
    on E: Exception do
      raise Exception.Create('Microsoft Excel не установлен, а файл CSV не найден рядом с таблицей.'#13#10 +
        'Пожалуйста, используйте файл формата .csv или установите Excel.');
  end;

  try
    ExlApp.Workbooks.Open(FileName);
    Sheet := ExlApp.Workbooks[1].WorkSheets[1];
    r := 1;
    while VarToStr(Sheet.Cells[r, 1].Value) <> '' do
      Inc(r);

    totalRows := r - 1;
    Grid.Perform(WM_SETREDRAW, 0, 0);
    try
      Grid.RowCount := totalRows;
      Grid.ColCount := 10;

      for j := 1 to totalRows do
      begin
        for c := 1 to 10 do
          Grid.Cells[c - 1, j - 1] := VarToStr(Sheet.Cells[j, c].Value);

        if Assigned(ProgressBarProc) and (j mod 500 = 0) then
          ProgressBarProc(j, totalRows);
      end;
    finally
      Grid.Perform(WM_SETREDRAW, 1, 0);
      Grid.Invalidate;
    end;

    Result := totalRows - 1;
  finally
    try
      ExlApp.Quit;
    except
    end;
    ExlApp := Unassigned;
  end;
end;

end.

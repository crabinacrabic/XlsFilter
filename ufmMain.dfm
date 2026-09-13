object fmMain: TfmMain
  Left = 180
  Top = 120
  Caption = 'Единый фильтр уголовных дел ИЦ МВД'
  ClientHeight = 700
  ClientWidth = 1100
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 14
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 1100
    Height = 55
    Align = alTop
    TabOrder = 0
    object lblLoadedFile: TLabel
      Left = 190
      Top = 18
      Width = 120
      Height = 14
      Caption = 'Файл не выбран'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnOpenFile: TButton
      Left = 12
      Top = 10
      Width = 165
      Height = 32
      Caption = '?? Открыть файл таблицы'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnOpenFileClick
    end
    object ProgressBar1: TProgressBar
      Left = 850
      Top = 16
      Width = 230
      Height = 20
      Anchors = [akTop, akRight]
      TabOrder = 1
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 55
    Width = 1100
    Height = 645
    ActivePage = tsAuto
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object tsAuto: TTabSheet
      Caption = '?? Автоматический анализ повторов (Версия 3)'
      object pnlAutoTop: TPanel
        Left = 0
        Top = 0
        Width = 1092
        Height = 50
        Align = alTop
        TabOrder = 0
        object lblAutoStats: TLabel
          Left = 460
          Top = 17
          Width = 240
          Height = 14
          Caption = 'Нажмите кнопку для запуска анализа'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object btnFindRepeated: TButton
          Left = 10
          Top = 8
          Width = 250
          Height = 32
          Caption = '? Найти дела с возобновлениями > 1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = btnFindRepeatedClick
        end
        object btnExportRepeated: TButton
          Left = 270
          Top = 8
          Width = 170
          Height = 32
          Caption = '?? Экспорт в TXT'
          TabOrder = 1
          OnClick = btnExportRepeatedClick
        end
      end
      object lbRepeated: TListBox
        Left = 0
        Top = 50
        Width = 1092
        Height = 565
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Consolas'
        Font.Style = []
        ItemHeight = 15
        ParentFont = False
        TabOrder = 1
      end
    end
    object tsManual: TTabSheet
      Caption = '?? Ручной фильтр (Версия 1)'
      ImageIndex = 1
      object pnlManualTop: TPanel
        Left = 0
        Top = 0
        Width = 1092
        Height = 50
        Align = alTop
        TabOrder = 0
        object lblDocNum: TLabel
          Left = 12
          Top = 17
          Width = 72
          Height = 14
          Caption = 'Номер дела:'
        end
        object lblDate: TLabel
          Left = 330
          Top = 17
          Width = 35
          Height = 14
          Caption = 'Дата:'
        end
        object edtDocNum: TEdit
          Left = 90
          Top = 13
          Width = 225
          Height = 22
          TabOrder = 0
          Text = '58954, 1050301, 177907'
        end
        object edtDate: TEdit
          Left = 370
          Top = 13
          Width = 110
          Height = 22
          TabOrder = 1
        end
        object btnFilterManual: TButton
          Left = 495
          Top = 9
          Width = 140
          Height = 30
          Caption = '?? Фильтровать'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          OnClick = btnFilterManualClick
        end
        object btnResetManual: TButton
          Left = 645
          Top = 9
          Width = 120
          Height = 30
          Caption = 'Сброс фильтра'
          TabOrder = 3
          OnClick = btnResetManualClick
        end
      end
      object gridManual: TStringGrid
        Left = 0
        Top = 50
        Width = 1092
        Height = 565
        Align = alClient
        ColCount = 10
        DefaultRowHeight = 22
        RowCount = 2
        TabOrder = 1
        OnDrawCell = gridManualDrawCell
      end
    end
    object tsHelp: TTabSheet
      Caption = '?? О программе и статьях УПК'
      ImageIndex = 2
      object memoHelp: TMemo
        Left = 0
        Top = 0
        Width = 1092
        Height = 615
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*.csv;*.xlsx'
    Filter = 
      'Все поддерживаемые таблицы (*.csv;*.xlsx;*.xls)|*.csv;*.xlsx;*.xls|' +
      'Таблицы CSV (*.csv)|*.csv|' +
      'Таблицы Excel (*.xlsx;*.xls)|*.xlsx;*.xls|' +
      'Все файлы (*.*)|*.*'
    Left = 360
    Top = 8
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Текстовый отчет (*.txt)|*.txt|Все файлы (*.*)|*.*'
    Left = 420
    Top = 8
  end
end

object fmMain: TfmMain
  Left = 140
  Top = 80
  Caption = #1045#1076#1080#1085#1099#1081' '#1072#1085#1072#1083#1080#1090#1080#1095#1077#1089#1082#1080#1081' '#1082#1086#1084#1087#1083#1077#1082#1089' '#1048#1062' '#1052#1042#1044': '#1059#1095#1077#1090' '#1091#1075#1086#1083#1086#1074#1085#1099#1093' '#1076#1077#1083
  ClientHeight = 750
  ClientWidth = 1180
  Color = 16119288
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object pnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 1180
    Height = 72
    Align = alTop
    BevelOuter = bvNone
    Color = 2239774
    ParentBackground = False
    TabOrder = 0
    object lblTitle: TLabel
      Left = 20
      Top = 12
      Width = 445
      Height = 25
      Caption = #1045#1076#1080#1085#1099#1081' '#1092#1080#1083#1100#1090#1088' '#1091#1075#1086#1083#1086#1074#1085#1099#1093' '#1076#1077#1083' '#1048#1062' '#1052#1042#1044
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Segoe UI Semibold'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblSubtitle: TLabel
      Left = 22
      Top = 40
      Width = 515
      Height = 15
      Caption = #1060#1086#1088#1084#1072' '#1074#1077#1076#1086#1084#1089#1090#1074#1077#1085#1085#1086#1081' '#1089#1090#1072#1090#1086#1090#1095#1077#1090#1085#1086#1089#1090#1080' '#8470' 3 '#8226' '#1040#1085#1072#1083#1080#1079' '#1086#1090#1084#1077#1085' '#1087#1088#1080#1086#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1081' '#1080' '#1074#1086#1079#1086#1073#1085#1086#1074#1083#1077#1085#1080#1081
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 12632256
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object btnOpenFile: TButton
      Left = 660
      Top = 18
      Width = 190
      Height = 36
      Anchors = [akTop, akRight]
      Caption = #1054#1073#1079#1086#1088' '#1080' '#1079#1072#1075#1088#1091#1079#1082#1072' '#1092#1072#1081#1083#1072'...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnOpenFileClick
    end
    object pnlFileBadge: TPanel
      Left = 860
      Top = 18
      Width = 300
      Height = 36
      Anchors = [akTop, akRight]
      BevelOuter = bvNone
      Color = 3289650
      ParentBackground = False
      TabOrder = 1
      object lblLoadedFile: TLabel
        Left = 12
        Top = 10
        Width = 275
        Height = 15
        Caption = #1060#1072#1081#1083' '#1085#1077' '#1074#1099#1073#1088#1072#1085' ('#1085#1072#1078#1084#1080#1090#1077' '#171#1054#1073#1079#1086#1088'...'#187')'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 65535
        Font.Height = -12
        Font.Name = 'Segoe UI Semibold'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object ProgressBar1: TProgressBar
      Left = 660
      Top = 57
      Width = 500
      Height = 8
      Anchors = [akTop, akRight]
      Smooth = True
      TabOrder = 2
      Visible = False
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 72
    Width = 1180
    Height = 654
    ActivePage = tsAuto
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object tsAuto: TTabSheet
      Caption = #1040#1085#1072#1083#1080#1079' '#1087#1086#1074#1090#1086#1088#1085#1099#1093' '#1074#1086#1079#1086#1073#1085#1086#1074#1083#1077#1085#1080#1081
      object pnlAutoTop: TPanel
        Left = 0
        Top = 0
        Width = 1172
        Height = 76
        Align = alTop
        BevelOuter = bvNone
        Color = 16382457
        ParentBackground = False
        TabOrder = 0
        object btnFindRepeated: TButton
          Left = 14
          Top = 18
          Width = 230
          Height = 40
          Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100' '#1072#1085#1072#1083#1080#1079' '#1087#1086#1074#1090#1086#1088#1086#1074
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = btnFindRepeatedClick
        end
        object btnExportRepeated: TButton
          Left = 252
          Top = 18
          Width = 180
          Height = 40
          Caption = #1069#1082#1089#1087#1086#1088#1090' '#1086#1090#1095#1077#1090#1072' '#1074' TXT...'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = btnExportRepeatedClick
        end
        object pnlKpiTotal: TPanel
          Left = 560
          Top = 12
          Width = 180
          Height = 52
          Anchors = [akTop, akRight]
          BevelOuter = bvNone
          Color = clWhite
          ParentBackground = False
          TabOrder = 2
          object lblKpiTotalTitle: TLabel
            Left = 10
            Top = 6
            Width = 90
            Height = 14
            Caption = #1057#1058#1056#1054#1050' '#1042' '#1058#1040#1041#1051#1048#1062#1045
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 8421504
            Font.Height = -11
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblKpiTotalVal: TLabel
            Left = 10
            Top = 22
            Width = 10
            Height = 23
            Caption = '-'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -17
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
        end
        object pnlKpiUnique: TPanel
          Left = 750
          Top = 12
          Width = 190
          Height = 52
          Anchors = [akTop, akRight]
          BevelOuter = bvNone
          Color = clWhite
          ParentBackground = False
          TabOrder = 3
          object lblKpiUniqueTitle: TLabel
            Left = 10
            Top = 6
            Width = 110
            Height = 14
            Caption = #1059#1053#1048#1050#1040#1051#1068#1053#1067#1061' '#1044#1045#1051
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 8421504
            Font.Height = -11
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblKpiUniqueVal: TLabel
            Left = 10
            Top = 22
            Width = 10
            Height = 23
            Caption = '-'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -17
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
        end
        object pnlKpiRepeated: TPanel
          Left = 950
          Top = 12
          Width = 210
          Height = 52
          Anchors = [akTop, akRight]
          BevelOuter = bvNone
          Color = clWhite
          ParentBackground = False
          TabOrder = 4
          object lblKpiRepeatedTitle: TLabel
            Left = 10
            Top = 6
            Width = 135
            Height = 14
            Caption = #1055#1054#1042#1058#1054#1056#1053#1067#1061' '#1042#1054#1047#1054#1041#1053#1054#1042#1051#1045#1053#1048#1049
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 204
            Font.Height = -11
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblKpiRepeatedVal: TLabel
            Left = 10
            Top = 22
            Width = 10
            Height = 23
            Caption = '-'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 204
            Font.Height = -17
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
        end
      end
      object gridRepeated: TStringGrid
        Left = 0
        Top = 76
        Width = 1172
        Height = 546
        Align = alClient
        ColCount = 6
        DefaultRowHeight = 24
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
        TabOrder = 1
        OnDrawCell = gridRepeatedDrawCell
      end
      object lbRepeated: TListBox
        Left = 0
        Top = 76
        Width = 1172
        Height = 546
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Consolas'
        Font.Style = []
        ItemHeight = 16
        ParentFont = False
        TabOrder = 2
        Visible = False
      end
    end
    object tsManual: TTabSheet
      Caption = #1056#1091#1095#1085#1086#1081' '#1092#1080#1083#1100#1090#1088' '#1087#1086' '#1076#1077#1083#1072#1084
      ImageIndex = 1
      object pnlManualTop: TPanel
        Left = 0
        Top = 0
        Width = 1172
        Height = 76
        Align = alTop
        BevelOuter = bvNone
        Color = 16382457
        ParentBackground = False
        TabOrder = 0
        object lblDocNum: TLabel
          Left = 14
          Top = 10
          Width = 225
          Height = 15
          Caption = #1053#1086#1084#1077#1088' '#1076#1077#1083#1072' ('#1080#1083#1080' '#1089#1087#1080#1089#1086#1082' '#1095#1077#1088#1077#1079' '#1079#1072#1087#1103#1090#1091#1102'):'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 3355443
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblDate: TLabel
          Left = 320
          Top = 10
          Width = 150
          Height = 15
          Caption = #1044#1072#1090#1072' '#1088#1077#1096#1077#1085#1080#1103' ('#1044#1044'.'#1052#1052'.'#1043#1043#1043#1043'):'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 3355443
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lblManualStats: TLabel
          Left = 860
          Top = 32
          Width = 165
          Height = 15
          Anchors = [akTop, akRight]
          Caption = #1054#1090#1086#1073#1088#1072#1078#1077#1085#1086' '#1079#1072#1087#1080#1089#1077#1081': 0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 3355443
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object edtDocNum: TEdit
          Left = 14
          Top = 30
          Width = 290
          Height = 26
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Text = '100101, 200202, 300303'
        end
        object edtDate: TEdit
          Left = 320
          Top = 30
          Width = 170
          Height = 26
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
        object btnFilterManual: TButton
          Left = 510
          Top = 27
          Width = 160
          Height = 32
          Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100' '#1092#1080#1083#1100#1090#1088
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          OnClick = btnFilterManualClick
        end
        object btnResetManual: TButton
          Left = 680
          Top = 27
          Width = 150
          Height = 32
          Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' ('#1057#1073#1088#1086#1089')'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = btnResetManualClick
        end
      end
      object gridManual: TStringGrid
        Left = 0
        Top = 76
        Width = 1172
        Height = 546
        Align = alClient
        ColCount = 10
        DefaultRowHeight = 24
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
        TabOrder = 1
        OnDrawCell = gridManualDrawCell
      end
    end
    object tsHelp: TTabSheet
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1080' '#1089#1090#1072#1090#1100#1080' '#1059#1055#1050' '#1056#1060
      ImageIndex = 2
      object memoHelp: TMemo
        Left = 0
        Top = 0
        Width = 1172
        Height = 622
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 726
    Width = 1180
    Height = 24
    Panels = <
      item
        Text = #1057#1090#1072#1090#1091#1089': '#1043#1086#1090#1086#1074' '#1082' '#1088#1072#1073#1086#1090#1077
        Width = 240
      end
      item
        Text = #1058#1077#1082#1091#1097#1080#1081' '#1092#1072#1081#1083': '#1053#1077' '#1074#1099#1073#1088#1072#1085
        Width = 420
      end
      item
        Text = #1057#1090#1088#1086#1082' '#1074' '#1073#1072#1079#1077': 0'
        Width = 200
      end
      item
        Text = #1056#1077#1078#1080#1084': '#1040#1074#1090#1086#1085#1086#1084#1085#1099#1081' CSV / OLE Excel'
        Width = 250
      end>
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*.csv;*.xlsx'
    Filter = 
      #1042#1089#1077' '#1087#1086#1076#1076#1077#1088#1078#1080#1074#1072#1077#1084#1099#1077' '#1090#1072#1073#1083#1080#1094#1099' (*.csv;*.xlsx;*.xls)|*.csv;*.xlsx;*.xls|'#1058#1072#1073#1083#1080#1094#1099' CSV (*.csv)|*.csv|'#1058#1072#1073#1083#1080#1094#1099' Excel (*.xlsx;*.xls)|*.xlsx;*.xls|'#1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*'
    Left = 520
    Top = 15
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'txt'
    Filter = #1058#1077#1082#1089#1090#1086#1074#1099#1081' '#1086#1090#1095#1077#1090' (*.txt)|*.txt|'#1042#1089#1077' '#1092#1072#1081#1083#1099' (*.*)|*.*'
    Left = 580
    Top = 15
  end
end

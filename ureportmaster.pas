unit UreportMaster;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LR_Class, LR_DBSet, Forms, Controls, Graphics,
  Dialogs, StdCtrls, EditBtn, Buttons, ExtCtrls, DateUtils, IBConnection, sqldb;

type

  { TfReportMaster }

  TfReportMaster = class(TForm)
    btnSearch: TBitBtn;
    btnBack: TBitBtn;
    btnReset: TBitBtn;
    btnPreview: TBitBtn;
    cbReportName: TComboBox;
    cbGroupBy: TComboBox;
    ebDateStart: TDateEdit;
    ebDateEnd: TDateEdit;
    ebName: TEdit;
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
    GroupBox1: TGroupBox;
    dbC: TIBConnection;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    rbFilter1: TRadioButton;
    rbFilter2: TRadioButton;
    rbFilter3: TRadioButton;
    rbOption1: TRadioButton;
    rbOption2: TRadioButton;
    dbQuery1: TSQLQuery;
    dbTrans: TSQLTransaction;
    procedure btnBackClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure ClearInput;
    procedure FormCreate(Sender: TObject);
    procedure rbFilter1Change(Sender: TObject);
    procedure rbFilter2Change(Sender: TObject);
    procedure rbFilter3Change(Sender: TObject);
    procedure rbOption1Change(Sender: TObject);
    procedure rbOption2Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fReportMaster: TfReportMaster;
  lvFirstDayOfYear, lvFirstDayOfMonth, lvToday: TDateTime;

implementation

{$R *.lfm}

{ TfReportMaster }

procedure TfReportMaster.ClearInput;
begin
  // Atur nilai tanggal
  lvToday := Now; // Tanggal hari ini
  lvFirstDayOfMonth := EncodeDate(YearOf(lvToday), MonthOf(lvToday), 1); // Tanggal 1 bulan ini

  // Set nilai default komponen
  cbReportName.Text := 'PILIH';
  rbFilter1.Checked := True;
  ebDateStart.Text := FormatDateTime('dd/mm/yyyy', lvFirstDayOfMonth);
  ebDateEnd.Text := FormatDateTime('dd/mm/yyyy', lvToday);
  ebDateStart.Enabled:=False;
  ebDateEnd.Enabled:=False;

  rbOption1.Checked := False;
  rbOption2.Checked := False;
  cbGroupBy.Clear;
  cbGroupBy.Enabled:=False;
  ebName.Clear;
  ebName.Enabled:=False;
  btnSearch.Enabled:=False;
end;

procedure TfReportMaster.btnResetClick(Sender: TObject);
begin
  ClearInput;
end;

procedure TfReportMaster.btnBackClick(Sender: TObject);
begin
  Close;
end;


procedure TfReportMaster.FormCreate(Sender: TObject);
begin
  ClearInput;
end;

procedure TfReportMaster.rbFilter1Change(Sender: TObject);
begin
  // Atur nilai tanggal
  lvToday := Now; // Tanggal hari ini
  lvFirstDayOfMonth := EncodeDate(YearOf(lvToday), MonthOf(lvToday), 1); // Tanggal 1 tahun ini

  ebDateStart.Text := FormatDateTime('dd/mm/yyyy', lvFirstDayOfMonth);
  ebDateEnd.Text := FormatDateTime('dd/mm/yyyy', lvToday);
  ebDateStart.Enabled:=False;
  ebDateEnd.Enabled:=False;
end;

procedure TfReportMaster.rbFilter2Change(Sender: TObject);
begin
  // Atur nilai tanggal
  lvToday := Now; // Tanggal hari ini
  lvFirstDayOfYear := EncodeDate(YearOf(lvToday), 1, 1); // Tanggal 1 tahun ini

  ebDateStart.Text := FormatDateTime('dd/mm/yyyy', lvFirstDayOfYear);
  ebDateEnd.Text := FormatDateTime('dd/mm/yyyy', lvToday);
  ebDateStart.Enabled:=False;
  ebDateEnd.Enabled:=False;
end;

procedure TfReportMaster.rbFilter3Change(Sender: TObject);
begin
  // Atur nilai tanggal
  lvToday := Now; // Tanggal hari ini
  lvFirstDayOfMonth := EncodeDate(YearOf(Today), MonthOf(Today), 1); // Tanggal 1 tahun ini

  ebDateStart.Text := FormatDateTime('dd/mm/yyyy', lvFirstDayOfMonth);
  ebDateEnd.Text := FormatDateTime('dd/mm/yyyy', lvToday);
  ebDateStart.Enabled:=True;
  ebDateEnd.Enabled:=True;
end;

procedure TfReportMaster.rbOption1Change(Sender: TObject);
begin
  cbGroupBy.Text:='PILIH';
  cbGroupBy.Enabled:=True;

  ebName.Clear;
  ebName.Enabled:=False;
  btnSearch.Enabled:=False;
end;

procedure TfReportMaster.rbOption2Change(Sender: TObject);
begin
  cbGroupBy.Clear;
  cbGroupBy.Enabled:=False;

  ebName.Clear;
  ebName.Enabled:=True;
  btnSearch.Enabled:=True;
end;

end.


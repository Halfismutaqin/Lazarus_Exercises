unit Ulat13_convertDate;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  EditBtn, DateUtils;

type

  { TfLat13 }

  TfLat13 = class(TForm)
    btnClose: TButton;
    btnProses: TButton;
    btnReset: TButton;
    btnTambah1: TButton;
    btnTambah2: TButton;
    btnTambah3: TButton;
    DTP1: TDateEdit;
    DTP2: TDateEdit;
    ebTambahBulan: TEdit;
    ebHasilBulan2: TEdit;
    ebFormat1: TEdit;
    ebFormat2: TEdit;
    ebFormat3: TEdit;
    ebFormat4: TEdit;
    ebTambahHari: TEdit;
    ebHasilHari2: TEdit;
    ebHasil: TEdit;
    ebTambahTahun: TEdit;
    ebHasilTahun2: TEdit;
    ebHasilHari: TEdit;
    ebHasilBulan: TEdit;
    ebHasilTahun: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure btnTambah2Click(Sender: TObject);
    procedure btnTambah3Click(Sender: TObject);
    procedure ClearInput;
    procedure FormShow(Sender: TObject);
    procedure HitungTanggal;
    procedure UpdateDate(IncrementType: String; Value: Integer; var ResultField: TEdit);
    procedure btnCloseClick(Sender: TObject);
    procedure btnProsesClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure btnTambah1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fLat13: TfLat13;

implementation

{$R *.lfm}

{ TfLat13 }

procedure TfLat13.ClearInput;
begin
  DTP1.Clear;
  DTP2.Clear;
  ebTambahHari.Clear;
  ebTambahBulan.Clear;
  ebTambahTahun.Clear;
  ebHasil.Clear;
  ebHasilHari.Clear;
  ebHasilBulan.Clear;
  ebHasilTahun.Clear;

  ebHasilHari2.Clear;
  ebHasilBulan2.Clear;
  ebHasilTahun2.Clear;
  ebFormat1.Clear;
  ebFormat2.Clear;
  ebFormat3.Clear;
  ebFormat4.Clear;
end;

procedure TfLat13.FormShow(Sender: TObject);
begin
  ClearInput;
end;

procedure TfLat13.HitungTanggal;
var
  hari, bulan, tahun: Integer;
  tanggal: TDateTime;
begin
  tanggal := DTP1.Date;
  //Validation DTP:
  if tanggal = 0 then
  begin
    //ShowMessage('Harap Masukkan Tanggal Terlebih Dahulu');
    Exit;
  end;
  //End Validation

  if ebTambahHari.Text = '' then
    hari := 0
  else
    hari := StrToIntDef(ebTambahHari.Text, 0); // Default to 0 if conversion fails

  if ebTambahBulan.Text = '' then
    bulan := 0
  else
    bulan := StrToIntDef(ebTambahBulan.Text, 0); // Default to 0 if conversion fails

  if ebTambahTahun.Text = '' then
    tahun := 0
  else
    tahun := StrToIntDef(ebTambahTahun.Text, 0); // Default to 0 if conversion fails

  // Add the values to the date
  tanggal := IncDay(tanggal, hari);
  tanggal := IncMonth(tanggal, bulan);
  tanggal := IncYear(tanggal, tahun);

  // Display the result
  ebHasil.Text := DateToStr(tanggal);
end;

procedure TfLat13.FormCreate(Sender: TObject);
begin
  ClearInput;
end;

procedure TfLat13.btnResetClick(Sender: TObject);
begin
  ClearInput;
end;

procedure TfLat13.UpdateDate(IncrementType: String; Value: Integer; var ResultField: TEdit);
var
  tanggal: TDateTime;
begin
  tanggal := DTP1.Date;
  // Validation for DTP1 (Ensure a valid date is selected)
  if tanggal = 0 then
  begin
    ShowMessage('Harap Masukkan Tanggal Terlebih Dahulu');
    Exit;
  end;

  // Increment the date based on the type
  case IncrementType of
    'Day':    tanggal := IncDay(tanggal, Value);
    'Month':  tanggal := IncMonth(tanggal, Value);
    'Year':   tanggal := IncYear(tanggal, Value);
  end;

  // Display the result
  ResultField.Text := DateToStr(tanggal);
end;

procedure TfLat13.btnTambah1Click(Sender: TObject);
var
  hari: Integer;
begin
  hari := StrToIntDef(ebTambahHari.Text, 0);
  UpdateDate('Day', hari, ebHasilHari);  // Pass 'Day' as the increment type
  HitungTanggal;
end;

procedure TfLat13.btnTambah2Click(Sender: TObject);
var
  bulan: Integer;
begin
  bulan := StrToIntDef(ebTambahBulan.Text, 0);
  UpdateDate('Month', bulan, ebHasilBulan);  // Pass 'Month' as the increment type
  HitungTanggal;
end;

procedure TfLat13.btnTambah3Click(Sender: TObject);
var
  tahun: Integer;
begin
  tahun := StrToIntDef(ebTambahTahun.Text, 0);
  UpdateDate('Year', tahun, ebHasilTahun);  // Pass 'Year' as the increment type
  HitungTanggal;
end;


procedure TfLat13.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfLat13.btnProsesClick(Sender: TObject);
var
  tanggal:Tdate;
begin
  tanggal := DTP2.Date;
  //Validation DTP:
  if tanggal = 0 then
  begin
    ShowMessage('Harap Masukkan Tanggal Terlebih Dahulu');
    Exit;
  end;
  //End Validation

  ebHasilHari2.Text:=FormatDateTime('dddd', tanggal);
  ebHasilBulan2.Text:=FormatDateTime('mmmm', tanggal);
  ebHasilTahun2.Text:=FormatDateTime('yyyy', tanggal);
  ebFormat1.Text:=FormatDateTime('dddd, mmmm yyyy', tanggal);
  ebFormat2.Text:=FormatDateTime('dd.mm.yyyy', tanggal);
  ebFormat3.Text:=FormatDateTime('dd mmmm yyyy', tanggal);
  ebFormat4.Text:=FormatDateTime('yyyy/mm/dd', tanggal);
end;

end.


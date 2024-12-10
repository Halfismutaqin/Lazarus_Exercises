unit Ulat11_hitungTanggal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  DateUtils, EditBtn;

type

  { TfLat11_tanggal }

  TfLat11_tanggal = class(TForm)
    btnback: TButton;
    btnhasil: TButton;
    btntambah: TButton;
    DTP1: TDateEdit;
    edbulan: TEdit;
    edhari: TEdit;
    edhasil: TEdit;
    edjam: TEdit;
    edtahun: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    L_name: TLabel;
    procedure btnbackClick(Sender: TObject);
    procedure btnhasilClick(Sender: TObject);
    procedure btntambahClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fLat11_tanggal: TfLat11_tanggal;

implementation

uses
  Ulat11_mainTanggal;

{$R *.lfm}

{ TfLat11_tanggal }

procedure TfLat11_tanggal.btnhasilClick(Sender: TObject);
var
  tanggal:Tdate;
  tgl,bulan,tahun:integer;
begin
    tanggal:=DTP1.Date;

    tgl:= DayOf(tanggal);
    bulan:=MonthOf(tanggal);
    tahun:=YearOf(tanggal);

    edhari.Text:=IntToStr(tgl);
    edbulan.Text:=IntToStr(bulan);
    edtahun.Text:=IntToStr(tahun);
end;

procedure TfLat11_tanggal.btnbackClick(Sender: TObject);
begin
  fLat11_main.Show;
  Self.Hide;
end;

procedure TfLat11_tanggal.btntambahClick(Sender: TObject);
var
  tanggal:Tdate;
  x:integer;
begin
    tanggal:=DTP1.Date;
    x:=StrToInt(edjam.Text);

    tanggal:=IncDay(tanggal,x);
    edhasil.Text:= FormatDatetIme ('DD MMMM YYYY', tanggal);

end;

procedure TfLat11_tanggal.FormCreate(Sender: TObject);
begin
  L_name.Caption:='';
end;

end.


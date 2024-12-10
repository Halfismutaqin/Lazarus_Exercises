unit Ulat12_penginapan;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics,
  Dialogs, StdCtrls;

type

  { TfLat12 }

  TfLat12 = class(TForm)
    btnHitung: TButton;
    btnSelesai: TButton;
    cbTipe: TComboBox;
    ebDiskon: TEdit;
    ebHarga: TEdit;
    ebJml: TEdit;
    ebKetDiskon: TEdit;
    ebLama: TEdit;
    ebTotal: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure btnHitungClick(Sender: TObject);
    procedure btnSelesaiClick(Sender: TObject);
    procedure cbTipeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ClearInput;
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fLat12: TfLat12;

implementation

{$R *.lfm}

{ TfLat12 }

procedure TfLat12.ClearInput;
begin
  cbTipe.ItemIndex:=-1;
  cbTipe.Text:='Pilih';
  ebHarga.Clear;
  ebLama.Clear;
  ebJml.Clear;
  ebKetDiskon.Clear;
  ebDiskon.Clear;
  ebTotal.Clear;
end;

procedure TfLat12.FormShow(Sender: TObject);
begin
  ClearInput
end;

procedure TfLat12.btnSelesaiClick(Sender: TObject);
begin
  Close;
end;

procedure TfLat12.cbTipeChange(Sender: TObject);
begin
  if cbTipe.ItemIndex = 0 then
    ebHarga.Text := '300000';

  if cbTipe.ItemIndex = 1 then
    ebHarga.Text := '350000';

  if cbTipe.ItemIndex = 2 then
    ebHarga.Text := '400000';

  if cbTipe.ItemIndex = 3 then
    ebHarga.Text := '500000';
end;

procedure TfLat12.FormCreate(Sender: TObject);
begin
  ClearInput;
end;


procedure TfLat12.btnHitungClick(Sender: TObject);
var
  hargaKamar, lama, jumlah: integer;
  diskon, totalBayar: real;
begin
  // Memeriksa apakah harga kamar sudah diinputkan
  if (ebHarga.Text = '') then
  begin
    ShowMessage('Pilih dahulu tipe kamar');
    Exit;
  end;

  // Memeriksa apakah lama menginap sudah diinputkan
  if (ebLama.Text = '') then
  begin
    ShowMessage('Masukkan lama menginap (Hari)');
    Exit;
  end;

  // Jika semua input valid, lakukan perhitungan
  hargaKamar := StrToInt(ebHarga.Text);
  lama := StrToInt(ebLama.Text);
  jumlah := hargaKamar * lama;

  // Menampilkan jumlah harga
  ebjml.Text := IntToStr(jumlah);

  // Menentukan apakah diskon berlaku
  if jumlah >= 1000000 then
    ebKetDiskon.Text := 'Diskon'
  else
    ebKetDiskon.Text := 'Tidak Diskon';

  // Menghitung diskon jika ada
  if jumlah >= 1000000 then
    diskon := jumlah * 0.1  // 10% diskon
  else
    diskon := 0;  // Tidak ada diskon

  // Menampilkan nilai diskon
  ebDiskon.Text := FloatToStr(diskon);

  // Menghitung total bayar setelah diskon
  totalBayar := jumlah - diskon;
  ebTotal.Text := FloatToStr(totalBayar);
end;


end.


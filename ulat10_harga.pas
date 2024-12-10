unit Ulat10_harga;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Windows,
  EditBtn;

type

  { TfLat10 }

  TfLat10 = class(TForm)
    btn_submit: TButton;
    btn_clear: TButton;
    btn_exit: TButton;
    cb_baju: TComboBox;
    cb_celana: TComboBox;
    eb_date: TDateEdit;
    eb_harga_baju: TEdit;
    eb_qty_baju: TEdit;
    eb_subtotal_baju: TEdit;
    eb_harga_celana: TEdit;
    eb_qty_celana: TEdit;
    eb_subtotal_celana: TEdit;
    eb_total: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure btn_clearClick(Sender: TObject);
    procedure btn_exitClick(Sender: TObject);
    procedure btn_submitClick(Sender: TObject);
    procedure cb_bajuChange(Sender: TObject);
    procedure cb_celanaChange(Sender: TObject);
    procedure clearInput;
    procedure eb_qty_bajuKeyUp(Sender: TObject; var Key: Word);
    procedure eb_qty_celanaKeyUp(Sender: TObject; var Key: Word);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fLat10: TfLat10;

implementation

{$R *.lfm}

{ TfLat10 }

procedure TfLat10.btn_exitClick(Sender: TObject);
begin
  ShowMessage('Thanks');
  Close;
end;

procedure TfLat10.btn_submitClick(Sender: TObject);
var total_baju,total_celana: Integer;
begin
  if (eb_subtotal_baju.text='') or (eb_subtotal_celana.text='')
  then
    begin
      ShowMessage('Harap Pilih Item terlebih dahulu');
    end
  else
    begin
      total_baju := StrToInt(eb_subtotal_baju.Text);
      total_celana := StrToInt(eb_subtotal_celana.Text);
      eb_total.text := IntToStr(total_baju+total_celana);
    end;
end;

procedure TfLat10.cb_bajuChange(Sender: TObject);
begin
  if cb_baju.Text='Blouse' then eb_harga_baju.Text:='60000';
  if cb_baju.Text='Gamis' then eb_harga_baju.Text:='150000';
  if cb_baju.Text='Kemeja' then eb_harga_baju.Text:='45000';
  if cb_baju.Text='Kaos' then eb_harga_baju.Text:='35000';
end;

procedure TfLat10.cb_celanaChange(Sender: TObject);
begin
  if cb_celana.Text='Formal' then eb_harga_celana.Text:='100000';
  if cb_celana.Text='Jogger' then eb_harga_celana.Text:='120000';
  if cb_celana.Text='Cargo' then eb_harga_celana.Text:='130000';
  if cb_celana.Text='Loose' then eb_harga_celana.Text:='80000';
end;

procedure TfLat10.clearInput;
begin
  eb_date.Text:=FormatDateTime('DD/MM/YYY', Date);

  cb_baju.Text:='Pilih Baju';
  cb_baju.Items.Clear;
  cb_baju.Items.Add('Blouse');
  cb_baju.Items.Add('Gamis');
  cb_baju.Items.Add('Kemeja');
  cb_baju.Items.Add('Kaos');

  cb_celana.Text:='Pilih Celana';
  cb_celana.Items.Clear;
  cb_celana.Items.Add('Formal');
  cb_celana.Items.Add('Jogger');
  cb_celana.Items.Add('Cargo');
  cb_celana.Items.Add('Loose');

  eb_harga_baju.text:='';
  eb_harga_celana.text:='';
  eb_qty_baju.text:='';
  eb_qty_celana.text:='';
  eb_subtotal_baju.text:='';
  eb_subtotal_celana.text:='';
  eb_total.text:='';
end;


procedure TfLat10.eb_qty_bajuKeyUp(Sender: TObject; var Key: Word);
var
  qty, harga, subtotal: Integer;
begin
  // Check if the entered value is a valid number
  if not (Key in [VK_BACK, VK_DELETE]) then
  begin
    if not (Char(Key) in ['0'..'9']) then
    begin
      // If the character is not a number, remove it
      Key := 0;
      ShowMessage('Hanya boleh input angka');
      eb_qty_baju.text:='';
    end;
  end;

  if TryStrToInt(eb_qty_baju.Text, qty) and TryStrToInt(eb_harga_baju.Text, harga) then
  begin
    subtotal := harga * qty;
    eb_subtotal_baju.Text := IntToStr(subtotal);
  end;
end;

procedure TfLat10.eb_qty_celanaKeyUp(Sender: TObject; var Key: Word);
var
  qty, harga, subtotal: Integer;
begin
  // Check if the entered value is a valid number
  if not (Key in [VK_BACK, VK_DELETE]) then
  begin
    if not (Char(Key) in ['0'..'9']) then
    begin
      // If the character is not a number, remove it
      Key := 0;
      ShowMessage('Hanya boleh input angka');
      eb_qty_celana.text:='';
    end;
  end;

  if TryStrToInt(eb_qty_celana.Text, qty) and TryStrToInt(eb_harga_celana.Text, harga) then
  begin
    subtotal := harga * qty;
    eb_subtotal_celana.Text := IntToStr(subtotal);
  end;
end;


procedure TfLat10.FormCreate(Sender: TObject);
begin
  clearInput;
end;

procedure TfLat10.btn_clearClick(Sender: TObject);
begin
  clearInput;
end;

end.


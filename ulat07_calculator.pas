unit Ulat07_calculator;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TfLat07 }

  TfLat07 = class(TForm)
    btn_hitung: TButton;
    btnClose: TButton;
    btnClear: TButton;
    eb_input1: TEdit;
    eb_operator: TEdit;
    eb_input2: TEdit;
    eb_result: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure btnClearClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btn_hitungClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fLat07: TfLat07;

implementation

{$R *.lfm}

{ TfLat07 }

procedure TfLat07.btn_hitungClick(Sender: TObject);
var
  angka1, angka2: integer;
  hasil: Double;
begin
  // Validate input fields
  if (eb_input1.Text = '') or (eb_input2.Text = '') or (eb_operator.Text = '') then
  begin
    ShowMessage('Harap masukkan nilai terlebih dahulu');
    Exit;
  end;

  try
    angka1 := StrToInt(eb_input1.Text);
    angka2 := StrToInt(eb_input2.Text);
  except
    on E: EConvertError do
    begin
      ShowMessage('Input harus berupa angka');
      Exit;
    end;
  end;

  case eb_operator.Text of
    '+': eb_result.Text := IntToStr(angka1 + angka2);
    '-': eb_result.Text := IntToStr(angka1 - angka2);
    '*': eb_result.Text := IntToStr(angka1 * angka2);
    '/':
      begin
        if angka2 = 0 then
        begin
          ShowMessage('Pembagian dengan nol tidak diperbolehkan');
          Exit;
        end;
        hasil := angka1 / angka2;
        eb_result.Text := FloatToStr(hasil);
      end;
  else
    ShowMessage('Operator tidak valid. Gunakan +, -, *, atau /.');
  end;
end;

procedure TfLat07.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfLat07.btnClearClick(Sender: TObject);
begin
  eb_input1.text := '';
  eb_input2.text := '';
  eb_operator.text := '';
  eb_result.text := '';
end;

procedure TfLat07.FormShow(Sender: TObject);
begin
  eb_input1.text := '';
  eb_input2.text := '';
  eb_operator.text := '';
  eb_result.text := '';
end;

end.


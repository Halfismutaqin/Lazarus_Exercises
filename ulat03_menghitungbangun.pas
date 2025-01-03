unit Ulat03_menghitungBangun;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TfLat03 }

  TfLat03 = class(TForm)
    btn_hitung: TButton;
    btn_reset: TButton;
    eb_keliling: TEdit;
    eb_lebar: TEdit;
    eb_luas: TEdit;
    eb_panjang: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure btn_hitungClick(Sender: TObject);
    procedure btn_resetClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fLat03: TfLat03;

implementation

{$R *.lfm}

{ TfLat03 }

procedure TfLat03.btn_resetClick(Sender: TObject);
begin
  eb_panjang.Text:='';
  eb_lebar.Text:='';
  eb_keliling.Text:='';
  eb_luas.Text:='';
end;

procedure TfLat03.btn_hitungClick(Sender: TObject);
var
  p, l, luas, keliling: Integer;
begin
  if (eb_panjang.Text='') or (eb_lebar.Text='') then
  begin
  ShowMessage('Input Panjang atau Lebar');
  Exit;
  end;

  p := StrToInt(eb_panjang.Text);
  l := StrToInt(eb_lebar.Text);

  keliling := 2 * (p + l);
  luas := p * l;

  eb_keliling.Text := IntToStr(keliling);
  eb_luas.Text := IntToStr(luas);
end;

procedure TfLat03.FormCreate(Sender: TObject);
begin
  eb_panjang.Text:='';
  eb_lebar.Text:='';
  eb_keliling.Text:='';
  eb_luas.Text:='';
end;

end.


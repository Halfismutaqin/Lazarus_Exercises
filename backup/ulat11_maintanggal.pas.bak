unit Ulat11_mainTanggal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons;

type

  { TfLat11_main }

  TfLat11_main = class(TForm)
    BitBtn1: TBitBtn;
    btn_submit: TButton;
    eb_input: TEdit;
    Label1: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure btn_submitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fLat11_main: TfLat11_main;

implementation

uses
  Ulat11_hitungTanggal;

{$R *.lfm}

{ TfLat11_main }

procedure TfLat11_main.FormCreate(Sender: TObject);
begin
  eb_input.text := '';
end;

procedure TfLat11_main.btn_submitClick(Sender: TObject);
begin
  fLat11_tanggal.Show;
  fLat11_tanggal.L_name.Caption:=eb_input.text;
  Self.hide;
end;

procedure TfLat11_main.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

end.


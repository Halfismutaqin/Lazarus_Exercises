unit Ulat09_rbPilih;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  { TfLat09 }

  TfLat09 = class(TForm)
    btn_select: TButton;
    Label1: TLabel;
    Label2: TLabel;
    lbPilih: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioGroup1: TRadioGroup;
    procedure btn_selectClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fLat09: TfLat09;

implementation

{$R *.lfm}

{ TfLat09 }

procedure TfLat09.btn_selectClick(Sender: TObject);
begin
  if RadioButton1.Checked then
  lbPilih.Caption:='Ya';

  if RadioButton2.Checked then
  lbPilih.Caption:='Tidak';

  if RadioButton3.Checked then
  lbPilih.Caption:='Bisa Jadi';
end;

end.


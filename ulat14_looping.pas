unit Ulat14_looping;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TfLat14_looping }

  TfLat14_looping = class(TForm)
    btnClose: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lbNilaiAwal: TLabel;
    lbNilaiAkhir: TLabel;
    memoGanjil: TMemo;
    memoGenap: TMemo;
    memoPrima: TMemo;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fLat14_looping: TfLat14_looping;

implementation

uses
  Ulat14_main;

{$R *.lfm}

{ TfLat14_looping }

procedure TfLat14_looping.FormShow(Sender: TObject);
begin
  lbNilaiAwal.caption := fLat14_main.ebNilaiAwal.text;
  lbNilaiAkhir.caption := fLat14_main.ebNilaiAkhir.text;
end;

procedure TfLat14_looping.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfLat14_looping.FormCreate(Sender: TObject);
begin

end;

end.


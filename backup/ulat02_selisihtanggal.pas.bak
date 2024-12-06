unit Ulat02_selisihTanggal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, EditBtn,
  DateUtils,
  StdCtrls;

type

  { TfLat02 }

  TfLat02 = class(TForm)
    Button1: TButton;
    btnClose: TButton;
    eDate_akhir: TDateEdit;
    eDate_awal: TDateEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Lselisih: TLabel;
    Lselisih1: TLabel;
    procedure btnCloseClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fLat02: TfLat02;

implementation

{$R *.lfm}

{ TfLat02 }

procedure TfLat02.Button1Click(Sender: TObject);
var
  Tawal, Takhir : TDateTime;
  selisih, selisih1: Integer;
begin
  Tawal := StrToDate(eDate_awal.Text);
  Takhir := StrToDate(eDate_akhir.Text);

  selisih := Trunc(Takhir - Tawal);
  selisih1:= DaysBetween(Takhir,Tawal);

  Lselisih.Caption := (IntToStr(selisih)) + ' Hari';
  Lselisih1.Caption := (IntToStr(selisih1)) + ' Hari';
end;

procedure TfLat02.FormCreate(Sender: TObject);
begin

end;

procedure TfLat02.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.


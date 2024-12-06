unit Ulat01_menghitungUmur;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  DateUtils, ExtCtrls;

type

  { TfLat01 }

  TfLat01 = class(TForm)
    btn_submit: TButton;
    btnClose: TButton;
    eb_address: TEdit;
    eb_age: TEdit;
    eb_name: TEdit;
    eb_tlp: TEdit;
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
    Laddress: TLabel;
    Lage: TLabel;
    Lname: TLabel;
    Ltlp: TLabel;
    Panel1: TPanel;
    procedure btnCloseClick(Sender: TObject);
    procedure btn_submitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fLat01: TfLat01;

implementation

{$R *.lfm}

{ TfLat01 }

procedure TfLat01.btn_submitClick(Sender: TObject);
var
  //Deklarasi Variabel tahun sekarang:
  birthYear, currentYear: Integer;
begin
  Lname.caption := eb_name.text;
  Laddress.caption := eb_address.text;
  Ltlp.caption := eb_tlp.text;

  //Start calculate age:
  birthYear := StrToInt(eb_age.text);
  currentYear := YearOf(Now);
    // Sesuaikan tanggal lahir berdasarkan bulan dan tahun
    //if (MonthOf(Now) < 1) or ((MonthOf(Now) = 1) and (DayOf(Now) < 1)) then
    //  Lage.caption := IntToStr(currentYear - birthYear - 1)
    //else
  Lage.caption := IntToStr(currentYear - birthYear);
end;

procedure TfLat01.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfLat01.FormCreate(Sender: TObject);
begin
  Lname.Caption:='';
  Laddress.caption:='';
  Ltlp.Caption:='';
  Lage.Caption:='';
end;

end.


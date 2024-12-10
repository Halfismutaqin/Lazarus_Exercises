unit Ulat05_kalender;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Calendar;

type

  { TfLat05 }

  TfLat05 = class(TForm)
    btnClose: TButton;
    Calendar1: TCalendar;
    eb_calendar: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure btnCloseClick(Sender: TObject);
    procedure Calendar1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fLat05: TfLat05;

implementation

{$R *.lfm}

{ TfLat05 }

procedure TfLat05.Calendar1Change(Sender: TObject);
begin
  eb_calendar.Text:=Calendar1.Date;
end;

procedure TfLat05.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfLat05.FormShow(Sender: TObject);
begin
  eb_calendar.text:='';
  FormatSettings.ShortDateFormat:='dd/mm/yyyy';
end;

end.


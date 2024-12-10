unit Ulat06_timer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  { TfLat06 }

  TfLat06 = class(TForm)
    Ltimmer: TLabel;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fLat06: TfLat06;

implementation

{$R *.lfm}

{ TfLat06 }



procedure TfLat06.Timer1Timer(Sender: TObject);
begin
  Ltimmer.caption := TimeToStr(time);
end;

end.


unit Ulat04_login;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TfLat04 }

  TfLat04 = class(TForm)
    btnClose: TButton;
    btn_login: TButton;
    eb_name: TEdit;
    eb_password: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure btnCloseClick(Sender: TObject);
    procedure btn_loginClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fLat04: TfLat04;

implementation

{$R *.lfm}

{ TfLat04 }

procedure TfLat04.btn_loginClick(Sender: TObject);
var
  user, pass : string;
begin
  user := 'admin';
  pass := 'admin';

  if(eb_name.text=user)and(eb_password.text=pass)
  then
    ShowMessage('Berhasil Login')
  else
    ShowMessage('Username atau password tidak cocok');
end;

procedure TfLat04.FormCreate(Sender: TObject);
begin
  eb_name.text := '';
  eb_password.text := '';
end;

procedure TfLat04.btnCloseClick(Sender: TObject);
begin
  ShowMessage('close');
  close;
end;

end.


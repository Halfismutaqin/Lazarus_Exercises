unit Umain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus;

type

  { TfMain }

  TfMain = class(TForm)
    MainMenu1: TMainMenu;
    MenuBatch1: TMenuItem;
    MenuBatch2: TMenuItem;
    MenuBatch3: TMenuItem;
    MenuExit: TMenuItem;
    menuLatihan11: TMenuItem;
    menuLatihan12: TMenuItem;
    menuLatihan13: TMenuItem;
    menuLatihan14: TMenuItem;
    menuLatihan15: TMenuItem;
    menuLatihan6: TMenuItem;
    menuLatihan7: TMenuItem;
    menuLatihan8: TMenuItem;
    menuLatihan9: TMenuItem;
    menuLatihan10: TMenuItem;
    menuLatihan1: TMenuItem;
    menuLatihan2: TMenuItem;
    menuLatihan3: TMenuItem;
    menuLatihan4: TMenuItem;
    menuLatihan5: TMenuItem;
    procedure MenuExitClick(Sender: TObject);
    procedure menuLatihan1Click(Sender: TObject);
    procedure menuLatihan2Click(Sender: TObject);
    procedure menuLatihan3Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fMain: TfMain;

implementation

uses
  Ulat01_menghitungUmur, Ulat02_selisihTanggal, Ulat03_menghitungBangun;

{$R *.lfm}

{ TfMain }

procedure TfMain.menuLatihan1Click(Sender: TObject);
begin
  fLat01.ShowModal;
end;

procedure TfMain.MenuExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfMain.menuLatihan2Click(Sender: TObject);
begin
  fLat02.ShowModal;
end;

procedure TfMain.menuLatihan3Click(Sender: TObject);
begin
  fLat03.ShowModal;
end;

end.


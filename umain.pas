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
    menuReportMaster: TMenuItem;
    menuReportInvoice: TMenuItem;
    menuReport: TMenuItem;
    menuManageInvoice: TMenuItem;
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
    procedure FormCreate(Sender: TObject);
    procedure MenuExitClick(Sender: TObject);
    procedure menuManageInvoiceClick(Sender: TObject);
    procedure menuLatihan10Click(Sender: TObject);
    procedure menuLatihan11Click(Sender: TObject);
    procedure menuLatihan12Click(Sender: TObject);
    procedure menuLatihan13Click(Sender: TObject);
    procedure menuLatihan14Click(Sender: TObject);
    procedure menuLatihan15Click(Sender: TObject);
    procedure menuLatihan1Click(Sender: TObject);
    procedure menuLatihan2Click(Sender: TObject);
    procedure menuLatihan3Click(Sender: TObject);
    procedure menuLatihan4Click(Sender: TObject);
    procedure menuLatihan5Click(Sender: TObject);
    procedure menuLatihan6Click(Sender: TObject);
    procedure menuLatihan7Click(Sender: TObject);
    procedure menuLatihan8Click(Sender: TObject);
    procedure menuLatihan9Click(Sender: TObject);
    procedure menuReportInvoiceClick(Sender: TObject);
    procedure menuReportMasterClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fMain: TfMain;

implementation

uses
  Ulat01_menghitungUmur, Ulat02_selisihTanggal, Ulat03_menghitungBangun, Ulat04_login, Ulat05_kalender,
  Ulat06_timer, Ulat07_calculator, Ulat08_rbJurusan, Ulat09_rbPilih, Ulat10_harga,
  Ulat11_mainTanggal, Ulat12_penginapan, Ulat13_convertDate, Ulat14_main, Ulat15_gradeNilai,
  UmanageInvoice, UreportInvoice, UreportMaster;

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

procedure TfMain.menuManageInvoiceClick(Sender: TObject);
begin
 fManageInvoice.ShowModal;
end;

procedure TfMain.menuLatihan10Click(Sender: TObject);
begin
  fLat10.ShowModal;
end;

procedure TfMain.menuLatihan11Click(Sender: TObject);
begin
  fLat11_main.Show;
end;

procedure TfMain.menuLatihan12Click(Sender: TObject);
begin
  fLat12.ShowModal;
end;

procedure TfMain.menuLatihan13Click(Sender: TObject);
begin
  fLat13.ShowModal;
end;

procedure TfMain.menuLatihan14Click(Sender: TObject);
begin
  fLat14_main.ShowModal;
end;

procedure TfMain.menuLatihan15Click(Sender: TObject);
begin
  fLat15.ShowModal;
end;

procedure TfMain.FormCreate(Sender: TObject);
begin

end;

procedure TfMain.menuLatihan2Click(Sender: TObject);
begin
  fLat02.ShowModal;
end;

procedure TfMain.menuLatihan3Click(Sender: TObject);
begin
  fLat03.ShowModal;
end;

procedure TfMain.menuLatihan4Click(Sender: TObject);
begin
  fLat04.ShowModal;
end;

procedure TfMain.menuLatihan5Click(Sender: TObject);
begin
  fLat05.ShowModal;
end;

procedure TfMain.menuLatihan6Click(Sender: TObject);
begin
  fLat06.ShowModal;
end;

procedure TfMain.menuLatihan7Click(Sender: TObject);
begin
  fLat07.ShowModal;
end;

procedure TfMain.menuLatihan8Click(Sender: TObject);
begin
  fLat08.ShowModal;
end;

procedure TfMain.menuLatihan9Click(Sender: TObject);
begin
  fLat09.ShowModal;
end;

procedure TfMain.menuReportInvoiceClick(Sender: TObject);
begin
  fReportInvoice.ShowModal;
end;

procedure TfMain.menuReportMasterClick(Sender: TObject);
begin
  fReportMaster.ShowModal;
end;

end.


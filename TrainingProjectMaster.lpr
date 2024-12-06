program TrainingProjectMaster;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Umain, Ulat01_menghitungUmur, Ulat02_selisihTanggal, Ulat03_menghitungBangun
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TfMain, fMain);
  Application.CreateForm(TfLat01, fLat01);
  Application.CreateForm(TfLat02, fLat02);
  Application.CreateForm(TfLat03, fLat03);
  Application.Run;
end.


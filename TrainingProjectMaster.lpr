program TrainingProjectMaster;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Umain, Ulat01_menghitungUmur, Ulat02_selisihTanggal, Ulat03_menghitungBangun,
  Ulat04_login, Ulat05_kalender, Ulat06_timer, Ulat07_calculator, Ulat08_rbJurusan,
  Ulat09_rbPilih, Ulat10_harga, Ulat11_mainTanggal, Ulat11_hitungTanggal, Ulat12_penginapan,
  Ulat13_convertDate, Ulat14_main, Ulat14_looping, Ulat15_gradeNilai
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TfMain, fMain);
  Application.CreateForm(TfLat01, fLat01);
  Application.CreateForm(TfLat02, fLat02);
  Application.CreateForm(TfLat03, fLat03);
  Application.CreateForm(TfLat04, fLat04);
  Application.CreateForm(TfLat05, fLat05);
  Application.CreateForm(TfLat06, fLat06);
  Application.CreateForm(TfLat07, fLat07);
  Application.CreateForm(TfLat08, fLat08);
  Application.CreateForm(TfLat09, fLat09);
  Application.CreateForm(TfLat10, fLat10);
  Application.CreateForm(TfLat11_main, fLat11_main);
  Application.CreateForm(TfLat11_tanggal, fLat11_tanggal);
  Application.CreateForm(TfLat12, fLat12);
  Application.CreateForm(TfLat13, fLat13);
  Application.CreateForm(TfLat14_main, fLat14_main);
  Application.CreateForm(TfLat14_looping, fLat14_looping);
  Application.CreateForm(TfLat15, fLat15);
  Application.Run;
end.


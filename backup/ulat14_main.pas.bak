unit Ulat14_main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TfLat14_main }

  TfLat14_main = class(TForm)
    btnLoop1: TButton;
    btnLoop2: TButton;
    btnLoop3: TButton;
    ebNilaiAkhir: TEdit;
    ebNilaiAwal: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure btnLoop1Click(Sender: TObject);
    procedure btnLoop2Click(Sender: TObject);
    procedure btnLoop3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Validation;
  private
    { private declarations }
  public
    function IsPrime(N: Integer): Boolean;
    { public declarations }
  end;

var
  fLat14_main: TfLat14_main;

implementation

uses
  Ulat14_looping;

{$R *.lfm}

{ TfLat14_main }

procedure TfLat14_main.Validation;
begin
  // Input Validation
  if (ebNilaiAwal.Text = '') or (ebNilaiAkhir.Text = '') then
  begin
    ShowMessage('Harap masukkan nilai awal dan akhir!');
    Exit;
  end;

  // If inputs are valid, show the looping form and clear previous results
  fLat14_looping.Show;
  fLat14_looping.lbNilaiAwal.caption := ebNilaiAwal.text;
  fLat14_looping.lbNilaiAkhir.caption := ebNilaiAkhir.text;

  fLat14_looping.memoGanjil.Clear;
  fLat14_looping.memoGenap.Clear;
  fLat14_looping.memoPrima.Clear;
end;


function TfLat14_main.IsPrime(N: Integer): Boolean;
var
  i: Integer;
begin
  Result := True;
  if N <= 1 then
    Result := False
  else
    for i := 2 to Trunc(Sqrt(N)) do
      if N mod i = 0 then
      begin
        Result := False;
        Exit;
      end;
end;


procedure TfLat14_main.FormCreate(Sender: TObject);
begin
   ebNilaiAwal.Clear;
   ebNilaiAkhir.Clear;
end;

procedure TfLat14_main.btnLoop1Click(Sender: TObject);
var
  i, ganjil, genap, prima: Integer;
  nilaiAwal, nilaiAkhir: Integer;
begin

  // Ensure the inputs are valid integers before proceeding
  if not TryStrToInt(ebNilaiAwal.Text, nilaiAwal) then
  begin
    ShowMessage('Nilai Awal harus berupa angka!');
    Exit;
  end;
  if not TryStrToInt(ebNilaiAkhir.Text, nilaiAkhir) then
  begin
    ShowMessage('Nilai Akhir harus berupa angka!');
    Exit;
  end;

  Validation;

  // Initialize counters
  ganjil := 0;
  genap := 0;
  prima := 0;

  // Loop from NilaiAwal to NilaiAkhir
  for i := StrToInt(ebNilaiAwal.Text) to StrToInt(ebNilaiAkhir.Text) do
  begin
    // Odd numbers
    if i mod 2 <> 0 then
    begin
      fLat14_looping.memoGanjil.Lines.Add(IntToStr(i));
      Inc(ganjil); // Increment odd number count
    end;

    // Even numbers
    if i mod 2 = 0 then
    begin
      fLat14_looping.memoGenap.Lines.Add(IntToStr(i));
      Inc(genap); // Increment even number count
    end;

    // Prime numbers
    if IsPrime(i) then
    begin
      fLat14_looping.memoPrima.Lines.Add(IntToStr(i));
      Inc(prima); // Increment prime number count
    end;
  end;

  // Display the total counts
  fLat14_looping.memoGanjil.Lines.Add('===========');
  fLat14_looping.memoGanjil.Lines.Add('Jumlah Bilangan Ganjil: ' + IntToStr(ganjil));

  fLat14_looping.memoGenap.Lines.Add('===========');
  fLat14_looping.memoGenap.Lines.Add('Jumlah Bilangan Genap: ' + IntToStr(genap));

  fLat14_looping.memoPrima.Lines.Add('===========');
  fLat14_looping.memoPrima.Lines.Add('Jumlah Bilangan Prima: ' + IntToStr(prima));
end;


procedure TfLat14_main.btnLoop2Click(Sender: TObject);
var
  i, ganjil, genap, prima: Integer;
  nilaiAwal, nilaiAkhir: Integer;
begin
    // Ensure the inputs are valid integers before proceeding
  if not TryStrToInt(ebNilaiAwal.Text, nilaiAwal) then
  begin
    ShowMessage('Nilai Awal harus berupa angka!');
    Exit;
  end;
  if not TryStrToInt(ebNilaiAkhir.Text, nilaiAkhir) then
  begin
    ShowMessage('Nilai Akhir harus berupa angka!');
    Exit;
  end;

  Validation;

  // Initialize counters
  ganjil := 0;
  genap := 0;
  prima := 0;

  i := StrToInt(ebNilaiAwal.Text);

  // While loop from NilaiAwal to NilaiAkhir
  while i <= StrToInt(ebNilaiAkhir.Text) do
  begin
    // Odd numbers
    if i mod 2 <> 0 then
    begin
      fLat14_looping.memoGanjil.Lines.Add(IntToStr(i));
      Inc(ganjil); // Increment odd number count
    end;

    // Even numbers
    if i mod 2 = 0 then
    begin
      fLat14_looping.memoGenap.Lines.Add(IntToStr(i));
      Inc(genap); // Increment even number count
    end;

    // Prime numbers
    if IsPrime(i) then
    begin
      fLat14_looping.memoPrima.Lines.Add(IntToStr(i));
      Inc(prima); // Increment prime number count
    end;

    Inc(i);  // Increment i
  end;
  // Display the total counts
  fLat14_looping.memoGanjil.Lines.Add('===========');
  fLat14_looping.memoGanjil.Lines.Add('Jumlah Bilangan Ganjil: ' + IntToStr(ganjil));

  fLat14_looping.memoGenap.Lines.Add('===========');
  fLat14_looping.memoGenap.Lines.Add('Jumlah Bilangan Genap: ' + IntToStr(genap));

  fLat14_looping.memoPrima.Lines.Add('===========');
  fLat14_looping.memoPrima.Lines.Add('Jumlah Bilangan Prima: ' + IntToStr(prima));
end;


procedure TfLat14_main.btnLoop3Click(Sender: TObject);
var
  i, ganjil, genap, prima: Integer;
  nilaiAwal, nilaiAkhir: Integer;
begin
    // Ensure the inputs are valid integers before proceeding
  if not TryStrToInt(ebNilaiAwal.Text, nilaiAwal) then
  begin
    ShowMessage('Nilai Awal harus berupa angka!');
    Exit;
  end;
  if not TryStrToInt(ebNilaiAkhir.Text, nilaiAkhir) then
  begin
    ShowMessage('Nilai Akhir harus berupa angka!');
    Exit;
  end;

  Validation;

  // Initialize counters
  ganjil := 0;
  genap := 0;
  prima := 0;

  i := StrToInt(ebNilaiAwal.Text);

  // Repeat-until loop from NilaiAwal to NilaiAkhir
  repeat
    // Odd numbers
    if i mod 2 <> 0 then
    begin
      fLat14_looping.memoGanjil.Lines.Add(IntToStr(i));
      Inc(ganjil); // Increment odd number count
    end;

    // Even numbers
    if i mod 2 = 0 then
    begin
      fLat14_looping.memoGenap.Lines.Add(IntToStr(i));
      Inc(genap); // Increment even number count
    end;

    // Prime numbers
    if IsPrime(i) then
    begin
      fLat14_looping.memoPrima.Lines.Add(IntToStr(i));
      Inc(prima); // Increment prime number count
    end;

    Inc(i);  // Increment i
  until i > StrToInt(ebNilaiAkhir.Text);

  // Display the total counts
  fLat14_looping.memoGanjil.Lines.Add('===========');
  fLat14_looping.memoGanjil.Lines.Add('Jumlah Bilangan Ganjil: ' + IntToStr(ganjil));

  fLat14_looping.memoGenap.Lines.Add('===========');
  fLat14_looping.memoGenap.Lines.Add('Jumlah Bilangan Genap: ' + IntToStr(genap));

  fLat14_looping.memoPrima.Lines.Add('===========');
  fLat14_looping.memoPrima.Lines.Add('Jumlah Bilangan Prima: ' + IntToStr(prima));
end;


end.


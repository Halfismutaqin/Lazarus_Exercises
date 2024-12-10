unit Ulat15_gradeNilai;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons;

type

  { TfLat15 }

  TfLat15 = class(TForm)
    btnAdd: TButton;
    btnClose: TBitBtn;
    btnProcess: TButton;
    btnClear: TButton;
    ebNilaiAkhir: TEdit;
    ebGradeNilai: TEdit;
    ebNilai: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    PanelInput: TScrollBox;
    procedure clearInput;
    procedure btnAddClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnProcessClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
    FLastInputTop: Integer; // Untuk melacak posisi terakhir input
  public
    { public declarations }
  end;

var
  fLat15: TfLat15;

implementation

{$R *.lfm}

{ TfLat15 }

procedure TfLat15.clearInput;
begin
  ebNilai.Clear;
  ebNilaiAkhir.Clear;
  ebGradeNilai.Clear;
end;

procedure TfLat15.btnAddClick(Sender: TObject);
var
  ebInputNilai: TEdit;
  lbNilai: TLabel;
  LabelIndex, MarginTop: Integer;
begin
  // Tentukan margin atas untuk input pertama
  MarginTop := 40;

  // Jika FLastInputTop belum diatur, inisialisasi dengan margin
  if FLastInputTop = 0 then
    FLastInputTop := MarginTop;

  // Hitung indeks label berdasarkan jumlah komponen di PanelInput
  LabelIndex := PanelInput.ControlCount div 2 + 1;

  // Buat label baru
  lbNilai := TLabel.Create(PanelInput);
  lbNilai.Parent := PanelInput;
  lbNilai.Width := 80;
  lbNilai.Top := FLastInputTop + 2;
  lbNilai.Left := 10;
  lbNilai.Caption := Format('Nilai %d:', [LabelIndex]); // Format angka sesuai indeks
  lbNilai.ShowHint := True;

  // Buat input baru
  ebInputNilai := TEdit.Create(PanelInput);
  ebInputNilai.Parent := PanelInput;
  ebInputNilai.Width := 158;
  ebInputNilai.Top := FLastInputTop;
  ebInputNilai.Left := lbNilai.Left + lbNilai.Width + 40; // Posisi di sebelah label
  ebInputNilai.Text := '';
  ebInputNilai.Hint := 'Masukkan nilai'; // Tooltip
  ebInputNilai.ShowHint := True;

  // Update posisi untuk input berikutnya
  FLastInputTop := FLastInputTop + ebInputNilai.Height + 10;
end;

procedure TfLat15.btnCloseClick(Sender: TObject);
begin
  Close;
end;


procedure TfLat15.btnProcessClick(Sender: TObject);
var
  i: Integer;
  InputCount: Integer;
  Total, Nilai: Double;
  Edit: TEdit;
begin
  Total := 0;
  InputCount := 0;

  // Iterasi semua komponen di PanelInput
  for i := 0 to PanelInput.ControlCount - 1 do
  begin
    if PanelInput.Controls[i] is TEdit then
    begin
      Edit := TEdit(PanelInput.Controls[i]);
      if TryStrToFloat(Edit.Text, Nilai) then
      begin
        Total := Total + Nilai;
        Inc(InputCount);
      end;
    end;
  end;

  if InputCount > 0 then
  begin
    // Hitung rata-rata dan tentukan grade
    Nilai := Total / InputCount;
    ebNilaiAkhir.Text := FloatToStr(Nilai);

    if Nilai >= 85 then
      ebGradeNilai.Text := 'Grade: A'
    else if Nilai >= 70 then
      ebGradeNilai.Text := 'Grade: B'
    else if Nilai >= 55 then
      ebGradeNilai.Text := 'Grade: C'
    else if Nilai >= 40 then
      ebGradeNilai.Text := 'Grade: D'
    else
      ebGradeNilai.Text := 'Grade: E';
  end
  else
    ebGradeNilai.Text := 'Tidak ada nilai valid.';
end;

procedure TfLat15.btnClearClick(Sender: TObject);
var
  i: Integer;
begin
  // Iterasi mundur agar penghapusan tidak menyebabkan konflik indeks
  for i := PanelInput.ControlCount - 1 downto 2 do
  begin
    if (PanelInput.Controls[i] is TLabel) or (PanelInput.Controls[i] is TEdit) then
    begin
      PanelInput.Controls[i].Free; // Hapus komponen
    end;
  end;

  // Reset posisi awal untuk input berikutnya
  FLastInputTop := 0;
  // Clear Input
  clearInput;
end;

procedure TfLat15.FormCreate(Sender: TObject);
begin
  clearInput;
end;



end.


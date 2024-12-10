unit Ulat08_rbJurusan;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls;

type

  { TfLat08 }

  TfLat08 = class(TForm)
    btn_print: TButton;
    btn_close: TButton;
    cb_jenkel: TComboBox;
    eb_biaya: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lb_jurusan: TLabel;
    lb_jenkel: TLabel;
    rb_si: TRadioButton;
    rb_ti: TRadioButton;
    rb_mi: TRadioButton;
    RadioGroup1: TRadioGroup;
    procedure btn_closeClick(Sender: TObject);
    procedure btn_printClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fLat08: TfLat08;

implementation

{$R *.lfm}

{ TfLat08 }

procedure TfLat08.btn_closeClick(Sender: TObject);
begin
  ShowMessage('thanks');
  fLat08.close;
end;

procedure TfLat08.btn_printClick(Sender: TObject);
var
  bayar: Integer;
begin
  if rb_si.Checked then
  begin
    lb_jurusan.Caption := 'Sistem Informasi';
    bayar := 11000;
  end;

  if rb_ti.Checked then
  begin
    lb_jurusan.Caption := 'Teknik Informatika';
    bayar := 12000;
  end;

  if rb_mi.Checked then
  begin
    lb_jurusan.Caption := 'Manajemen Informatika';
    bayar := 13000;
  end;

  case cb_jenkel.ItemIndex of
    0: begin
         bayar := bayar + 2000;
         lb_jenkel.Caption := 'Laki-Laki';
       end;
    1: begin
         bayar := bayar + 3000;
         lb_jenkel.Caption := 'Perempuan';
       end;
  end;

  eb_biaya.Caption := IntToStr(bayar);
end;


procedure TfLat08.FormCreate(Sender: TObject);
begin
  cb_jenkel.Items.Clear;
  cb_jenkel.Items.Add('Laki-Laki');
  cb_jenkel.Items.Add('Perempuan');

  lb_jurusan.Caption:='';
  lb_jenkel.Caption:='';
  cb_jenkel.text:='';
  eb_biaya.text:='';
end;

procedure TfLat08.FormShow(Sender: TObject);
begin
  cb_jenkel.Items.Clear;
  cb_jenkel.Items.Add('Laki-Laki');
  cb_jenkel.Items.Add('Perempuan');

  lb_jurusan.Caption:='';
  lb_jenkel.Caption:='';
  cb_jenkel.text:='';
  eb_biaya.text:='';
end;


end.


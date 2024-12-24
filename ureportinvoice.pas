unit UreportInvoice;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, IBConnection, FileUtil, LR_DBSet, LR_Class, Forms,
  Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, Buttons, EditBtn,
  Windows;

type

  { TfReportInvoice }

  TfReportInvoice = class(TForm)
    btnClose: TBitBtn;
    btnReset: TBitBtn;
    btnPreview: TBitBtn;
    cbMasterData: TComboBox;
    cbSelectYear: TComboBox;
    cbValueBy: TComboBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    DateEdit1: TDateEdit;
    DateEdit2: TDateEdit;
    dbQuery1: TSQLQuery;
    frDBDataSet: TfrDBDataSet;
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    dbC: TIBConnection;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    dbTrans: TSQLTransaction;
    dbQuery: TSQLQuery;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure btnCloseClick(Sender: TObject);
    procedure btnPreviewClick(Sender: TObject);
    procedure ClearFilter;
    procedure btnResetClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ReportPenjualanDetail;
    Procedure ReportPenjualanTahunan;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fReportInvoice: TfReportInvoice;

implementation

uses
  UmanageInvoice;

{$R *.lfm}

{ TfReportInvoice }

procedure TfReportInvoice.ClearFilter;
begin
   cbSelectYear.ItemIndex := -1;
   cbMasterData.ItemIndex := -1;
   cbValueBy.ItemIndex := -1;

   cbSelectYear.Items.Clear;
   cbMasterData.Items.Clear;
   cbValueBy.Items.Clear;

   cbSelectYear.Text:='PILIH';
   cbMasterData.Text:='PILIH';
   cbValueBy.Text:='PILIH';

   CheckBox1.Checked:=False;
   CheckBox2.Checked:=False;

   DateEdit1.Clear;
   DateEdit1.DateOrder:=doDMY;
   DateEdit2.Clear;
   DateEdit2.DateOrder:=doDMY;

  // Reset Value Combo Box:
  // FETCH INV_YEAR
  dbTrans.Commit;
  dbQuery.SQL.Text:='SELECT DISTINCT EXTRACT(YEAR FROM INV_HDR_DT) "YEAR" FROM INVOICE_HDR';
  dbQuery.Open;
  cbSelectYear.Items.Clear;
  dbQuery.First;
    WHILE not dbQuery.EOF do
      begin
        cbSelectYear.Items.Add(dbQuery.Fields.FieldByName('YEAR').AsString);
        dbQuery.Next;
      end;
  dbTrans.Commit;
  // COMBO MASTER DATA
  cbMasterData.Items.Add('CUSTOMER');
  cbMasterData.Items.Add('ITEM');
  // COMBO VALUE BY
  cbValueBy.Items.Add('QTY');
  cbValueBy.Items.Add('TOTAL');
end;

procedure TfReportInvoice.btnCloseClick(Sender: TObject);
begin
  CLOSE;
end;

procedure TfReportInvoice.btnPreviewClick(Sender: TObject);
begin
  if not CheckBox1.Checked and not CheckBox2.Checked then
  begin
    ShowMessage('Tidak ada report yang dipilih !!');
    Exit;
  end;

  if CheckBox1.Checked then
  begin
    // Validasi input tanggal
    if (DateEdit1.Text = '') or (DateEdit1.Text = '  /  /    ') or (DateEdit2.Text = '') or (DateEdit2.Text = '  /  /    ') then
    begin
      ShowMessage('Tanggal mulai dan selesai tidak boleh kosong.');
      Exit;
    end;

    // Menampilkan laporan penjualan detail
    ReportPenjualanDetail;
  end;

  if CheckBox2.Checked then
  begin
    // Menampilkan laporan penjualan detail
    ReportPenjualanTahunan;
  end;

end;


procedure TfReportInvoice.FormCreate(Sender: TObject);
begin
  btnClose.Caption:='CLOSE';
  btnPreview.Caption:='PREVIEW';
  btnReset.Caption:='RESET';
  fManageInvoice.ConnectionDB;
  if not dbTrans.Active then dbTrans.StartTransaction;

  ClearFilter;
end;



procedure TfReportInvoice.btnResetClick(Sender: TObject);
begin
  ClearFilter;
  dbQuery.Close;
  dbQuery1.Close;
end;

procedure TfReportInvoice.ReportPenjualanDetail;
var
  s: TResourceStream;
begin
  try
    s := TResourceStream.Create(HInstance, 'rptPenjualanDetail', RT_RCDATA);

    dbQuery.Active:=False;
    try
      // Pastikan transaksi dan query dalam keadaan siap
      if dbTrans.Active then
        dbTrans.Commit;
        dbQuery.Active:=True;

      dbQuery.Close;
      dbQuery.SQL.Text := 'SELECT ' +
                            'HDR.INV_HDR_NO "NO", ' +
                            'HDR.INV_HDR_DT "TGL", ' +
                            'HDR.INV_HDR_CUST_ID "CUST_ID", ' +
                            'HDR.INV_HDR_CUST_NAME "CUST_NAME", ' +
                            'DTL.INV_DTL_PROD_ID "ITEM_ID", ' +
                            'DTL.INV_DTL_PROD_NAME "ITEM_NAME", ' +
                            'DTL.INV_DTL_QTY "QTY", ' +
                            'DTL.INV_DTL_PROD_UOM "UOM", ' +
                            'DTL.INV_DTL_PRICE "PRICE", ' +
                            'DTL.INV_DTL_TOTAL "TOTAL" ' +
                          'FROM INVOICE_HDR HDR ' +
                          'LEFT JOIN INVOICE_DTL DTL ' +
                          'ON HDR.INV_HDR_NO = DTL.INV_DTL_NO ' +
                          'WHERE HDR.INV_HDR_DT BETWEEN :lvMulai AND :lvSelesai';


      dbQuery.Params.ParamByName('lvMulai').AsString:=DateEdit1.Text;
      dbQuery.Params.ParamByName('lvSelesai').AsString:=DateEdit2.Text;
      dbQuery.Open;

      // Load dan tampilkan laporan
      frReport1.LoadFromXMLStream(s);
      frReport1.ShowReport;
    finally
      s.Free;
    end;
  except
    on E: Exception do
      ShowMessage('Error: ' + E.Message);
  end;
end;


procedure TfReportInvoice.ReportPenjualanTahunan;
var
  s: TResourceStream;
  selectedYear, selectedMasterData, selectedValueBy : String;
  dynamicColumns1, dynamicColumns2, dynamicSummary : String;
begin
    dbQuery1.Active:=False;
  try
    // Inisialisasi resource stream untuk laporan
    s := TResourceStream.Create(HInstance, 'rptPenjualanRekap', RT_RCDATA);
    dbQuery1.Active:=True;

    // Mendapatkan nilai dari combo box
      selectedYear := Trim(cbSelectYear.Text); // Tahun yang dipilih
      selectedMasterData := Trim(cbMasterData.Text); // CUSTOMER atau ITEM
      selectedValueBy := Trim(cbValueBy.Text); // TOTAL atau QTY

      // Validasi input pengguna
      if (selectedYear = '') or (selectedMasterData = '') or (selectedValueBy = '') then
      begin
        ShowMessage('Semua pilihan (Tahun, Master Data, dan Value By) harus diisi.');
        Exit;
      end;
      if (selectedYear = 'PILIH') or (selectedMasterData = 'PILIH') or (selectedValueBy = 'PILIH') then
      begin
        ShowMessage('Semua pilihan (Tahun, Master Data, dan Value By) harus diisi.');
        Exit;
      end;

      // Menentukan kolom berdasarkan master data yang dipilih
      if selectedMasterData = 'CUSTOMER' then
      begin
        dynamicColumns1 := 'INV_HDR_CUST_ID';
        dynamicColumns2 := 'INV_HDR_CUST_NAME';
      end
      else if selectedMasterData = 'ITEM' then
      begin
        dynamicColumns1 := 'INV_DTL_PROD_ID';
        dynamicColumns2 := 'INV_DTL_PROD_NAME';
      end
      else
      begin
        ShowMessage('Pilihan Master Data tidak valid. Harus "CUSTOMER" atau "ITEM".');
        Exit;
      end;

       // Menentukan kolom untuk summary berdasarkan pilihan
      if selectedValueBy = 'TOTAL' then
        dynamicSummary := 'ID.INV_DTL_TOTAL'
      else if selectedValueBy = 'QTY' then
        dynamicSummary := 'ID.INV_DTL_QTY'
      else
        begin
          ShowMessage('Pilihan Value By tidak valid. Harus "TOTAL" atau "QTY".');
          Exit;
        end;

    // Pastikan dataset utama tidak aktif sebelum diatur ulang
    if dbQuery1.Active then
      dbQuery1.Close;

    // Pastikan transaksi dalam keadaan siap
    if dbTrans.Active then
      dbTrans.Commit;

    // Siapkan dan eksekusi query SQL
    dbQuery1.SQL.Text := 'SELECT'+
                #39 + selectedYear + #39 + 'AS "GET_YEAR", '+
                dynamicColumns1 + ' AS "CL_ID", ' +
                dynamicColumns2 + ' AS "CL_NAME", ' +
                'SUM(CASE WHEN EXTRACT(MONTH FROM INV_HDR_DT) = 01 THEN '+ dynamicSummary +' ELSE 0 END) AS "JANUARI", '+
                'SUM(CASE WHEN EXTRACT(MONTH FROM INV_HDR_DT) = 02 THEN '+ dynamicSummary +' ELSE 0 END) AS "FEBRUARI", '+
                'SUM(CASE WHEN EXTRACT(MONTH FROM INV_HDR_DT) = 03 THEN '+ dynamicSummary +' ELSE 0 END) AS "MARET", '+
                'SUM(CASE WHEN EXTRACT(MONTH FROM INV_HDR_DT) = 04 THEN '+ dynamicSummary +' ELSE 0 END) AS "APRIL", '+
                'SUM(CASE WHEN EXTRACT(MONTH FROM INV_HDR_DT) = 05 THEN '+ dynamicSummary +' ELSE 0 END) AS "MEI", '+
                'SUM(CASE WHEN EXTRACT(MONTH FROM INV_HDR_DT) = 06 THEN '+ dynamicSummary +' ELSE 0 END) AS "JUNI", '+
                'SUM(CASE WHEN EXTRACT(MONTH FROM INV_HDR_DT) = 07 THEN '+ dynamicSummary +' ELSE 0 END) AS "JULI", '+
                'SUM(CASE WHEN EXTRACT(MONTH FROM INV_HDR_DT) = 08 THEN '+ dynamicSummary +' ELSE 0 END) AS "AGUSTUS", '+
                'SUM(CASE WHEN EXTRACT(MONTH FROM INV_HDR_DT) = 09 THEN '+ dynamicSummary +' ELSE 0 END) AS "SEPEMBER", '+
                'SUM(CASE WHEN EXTRACT(MONTH FROM INV_HDR_DT) = 10 THEN '+ dynamicSummary +' ELSE 0 END) AS "OKTOBER", '+
                'SUM(CASE WHEN EXTRACT(MONTH FROM INV_HDR_DT) = 11 THEN '+ dynamicSummary +' ELSE 0 END) AS "NOVEMBER", '+
                'SUM(CASE WHEN EXTRACT(MONTH FROM INV_HDR_DT) = 12 THEN '+ dynamicSummary +' ELSE 0 END) AS "DESEMBER", '+
                'SUM('+ dynamicSummary +') AS TOTAL '+
            'FROM INVOICE_HDR IH '+
            'JOIN INVOICE_DTL ID ON IH.INV_HDR_NO = ID.INV_DTL_NO '+
            'WHERE EXTRACT(YEAR FROM INV_HDR_DT) = ' + selectedYear + ' ' +
            'GROUP BY ' + dynamicColumns1 + ', ' + dynamicColumns2 + ' ' +
            'ORDER BY '+ dynamicColumns2 +' ASC';

    // Buka dataset untuk mengambil data
    dbQuery1.Open;

    // Load dan tampilkan laporan
    frReport1.LoadFromXMLStream(s);
    frReport1.ShowReport;

  finally
    // Bebaskan resource stream
    if Assigned(s) then
      s.Free;
  end;
end;



end.


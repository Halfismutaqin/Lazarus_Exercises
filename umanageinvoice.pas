unit UmanageInvoice;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, sqldb, IBConnection, FileUtil, LR_DBSet, LR_Class,
  Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons, DBGrids, Menus, Windows;

type

  { TfManageInvoice }

  TfManageInvoice = class(TForm)
    btnSearch: TBitBtn;
    btnPreview: TBitBtn;
    btnAdd: TBitBtn;
    btnEdit: TBitBtn;
    btnViewReport: TBitBtn;
    btnMenu: TBitBtn;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    ebSalesNo: TEdit;
    ebCustName: TEdit;
    dbConnection: TIBConnection;
    frDBDataSet1: TfrDBDataSet;
    frDBDataSet2: TfrDBDataSet;
    frReport1: TfrReport;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    dbQuery1: TSQLQuery;
    dbQuery2: TSQLQuery;
    dbQuery3: TSQLQuery;
    dbTrans1: TSQLTransaction;
    dbTrans2: TSQLTransaction;
    dbTrans3: TSQLTransaction;
    btnDetail: TMenuItem;
    PopupMenu1: TPopupMenu;
    dbQueryDtl: TSQLQuery;
    dbQueryHdr: TSQLQuery;
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnMenuClick(Sender: TObject);
    procedure btnPreviewClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure DBGrid1CellClick;
    procedure DBGrid1DrawColumnCell(Sender: TObject);
    procedure DBGrid1KeyDown(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ConnectionDB;
    procedure CustomDisplayGrid2;
    procedure ClearInput;
    procedure FormShow(Sender: TObject);
    procedure btnDetailClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fManageInvoice: TfManageInvoice;
  vGetInvNo : String;

implementation
uses
  UmanageInvoice_add, UmanageInvoice_edit;

{$R *.lfm}

{ TfManageInvoice }

procedure TfManageInvoice.ClearInput;
begin
  ebSalesNo.Clear;
  ebCustName.Clear;
end;

procedure TfManageInvoice.FormCreate(Sender: TObject);
begin
  ClearInput;
  ConnectionDB;
end;

procedure TfManageInvoice.btnMenuClick(Sender: TObject);
begin
  Close;
end;

procedure TfManageInvoice.btnPreviewClick(Sender: TObject);
var
  s: TResourceStream;
begin
  try
    s := TResourceStream.Create(HInstance, 'rptInvoice', RT_RCDATA);

    dbQueryHdr.Active:=False;
    dbQueryDtl.Active:=False;
    try
      // Pastikan transaksi dan query dalam keadaan siap
      if dbTrans3.Active then
        dbTrans3.Commit;
        dbQueryHdr.Active:=True;
        dbQueryDtl.Active:=True;

      // Header
      dbQueryHdr.Close;
      dbQueryHdr.SQL.Text :=
        'SELECT INV_HDR_NO AS "INV_ID", INV_HDR_DT AS "INV_DATE", ' +
        'INV_HDR_TYPE AS "INV_TYPE", INV_HDR_CUST_ID AS "CUST_ID", ' +
        'INV_HDR_CUST_NAME AS "CUST_NAME", INV_HDR_CUST_ADDR AS "CUST_ADDRESS", ' +
        'INV_HDR_CUST_CITY AS "CUST_CITY", INV_HDR_CUST_PROVINCE AS "CUST_PROVINCE", ' +
        'INV_HDR_STATUS AS "INV_STATUS", INV_HDR_PPN_FLAG AS "INV_PPN" ' +
        'FROM INVOICE_HDR WHERE INV_HDR_NO = :vNO';
      dbQueryHdr.ParamByName('vNO').AsString :=
        DBGrid1.DataSource.DataSet.FieldByName('NO').AsString;
      dbQueryHdr.Open;

      // Detail
      dbQueryDtl.Close;
      dbQueryDtl.SQL.Text :=
        'SELECT ' +
        '  hdr.INV_HDR_NO AS "NO", hdr.INV_HDR_DT AS "TANGGAL", hdr.INV_HDR_TYPE AS "TYPE", ' +
        '  dtl.INV_DTL_NO AS "DETAIL_NO", dtl.INV_DTL_PROD_ID AS "PROD_ID", ' +
        '  dtl.INV_DTL_PROD_NAME AS "PROD_NAME", dtl.INV_DTL_PROD_UOM AS "PROD_UOM", ' +
        '  dtl.INV_DTL_PRICE AS "PROD_PRICE", dtl.INV_DTL_DPP AS "PROD_DPP", ' +
        '  dtl.INV_DTL_PPN AS "PROD_PPN", dtl.INV_DTL_QTY AS "PROD_QTY", ' +
        '  dtl.INV_DTL_TOTAL AS "PROD_TOTAL" ' +
        'FROM INVOICE_HDR hdr ' +
        'LEFT JOIN INVOICE_DTL dtl ON hdr.INV_HDR_NO = dtl.INV_DTL_NO ' +
        'WHERE hdr.INV_HDR_NO = :vNO';
      dbQueryDtl.ParamByName('vNO').AsString :=
        DBGrid1.DataSource.DataSet.FieldByName('NO').AsString;
      dbQueryDtl.Open;

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



procedure TfManageInvoice.btnAddClick(Sender: TObject);
//var
  //fManageInvoice_add: TfManageInvoice_add;
begin
  // Membuat instance form edit
  //fManageInvoice_add := TfManageInvoice_add.Create(Self);
  fManageInvoice_add.ShowModal;
  //fManageInvoice_add.Free;
end;

procedure TfManageInvoice.btnEditClick(Sender: TObject);
var
  fManageInvoice_edit: TfManageInvoice_edit;
begin
  if (not DBGrid1.DataSource.DataSet.IsEmpty) then
    begin
      UmanageInvoice_edit.gvInvNo:=DBGrid1.DataSource.DataSet.FieldByName('NO').AsString;
      fManageInvoice_edit:=TfManageInvoice_edit.Create(Self);
      fManageInvoice_edit.ShowModal;
      fManageInvoice_edit.Free;
    end;
end;


procedure TfManageInvoice.btnSearchClick(Sender: TObject);
begin
  // FETCH DATA INV HDR
  dbTrans1.Commit;
  dbTrans2.Commit;
  dbQuery1.SQL.Text := 'SELECT INV_HDR_NO "NO", INV_HDR_DT "DATE", ' +
                       'INV_HDR_TYPE "INV_TYPE", INV_HDR_CUST_ID "CUST ID", ' +
                       'INV_HDR_CUST_NAME "CUST NAME", INV_HDR_CUST_ADDR "CUST ADDRESS", ' +
                       'INV_HDR_CUST_CITY "CUST CITY", INV_HDR_CUST_PROVINCE "CUST PROVINCE", ' +
                       'INV_HDR_STATUS "INV STATUS", INV_HDR_PPN_FLAG "INV PPN" ' +
                       'FROM INVOICE_HDR WHERE 1=1';

  if ebSalesNo.Text <> '' then
    dbQuery1.SQL.Text := dbQuery1.SQL.Text + 'AND INV_HDR_NO = ' + #39 + ebSalesNo.Text + #39;
  if ebCustName.Text <> '' then
    dbQuery1.SQL.Text := dbQuery1.SQL.Text + 'AND INV_CUST_NAME LIKE ' + #39#37 + ebCustName.Text + #37#39;
    dbQuery1.SQL.Text := dbQuery1.SQL.Text + 'ORDER BY INV_HDR_DT DESC';
  dbQuery1.Open;

  // FETCH DATA INV DTL
  if (not DBGrid1.DataSource.DataSet.IsEmpty) then
    begin
      dbTrans2.Commit;
      dbQuery2.SQL.Text:='SELECT INV_DTL_NO "NO", INV_DTL_PROD_ID "ID", INV_DTL_PROD_NAME "NAMA PRODUK", ' +
                     'INV_DTL_PROD_UOM "UOM", INV_DTL_QTY "QTY", INV_DTL_PRICE "HARGA", INV_DTL_DPP "DPP", INV_DTL_PPN "PPN", ' +
                     'INV_DTL_TOTAL "TOTAL" FROM INVOICE_DTL WHERE INV_DTL_NO =:vNO';
      dbQuery2.Params.ParamByName('vNO').AsString := DBGrid1.DataSource.DataSet.FieldByName('NO').AsString;
      dbQuery2.Open;
      CustomDisplayGrid2;
      //dbTrans3.Commit;
    end;
end;

procedure TfManageInvoice.DBGrid1CellClick;
begin
    dbTrans2.Commit;
      dbQuery2.SQL.Text:='SELECT INV_DTL_NO "NO", INV_DTL_PROD_ID "ID", INV_DTL_PROD_NAME "NAMA PRODUK", ' +
                     'INV_DTL_PROD_UOM "UOM", INV_DTL_QTY "QTY", INV_DTL_PRICE "HARGA", INV_DTL_DPP "DPP", INV_DTL_PPN "PPN", ' +
                     'INV_DTL_TOTAL "TOTAL" FROM INVOICE_DTL WHERE INV_DTL_NO =:vNO';
      dbQuery2.Params.ParamByName('vNO').AsString:=DBGrid1.DataSource.DataSet.FieldByName('NO').AsString;
      dbQuery2.Open;
  CustomDisplayGrid2;
end;

procedure TfManageInvoice.DBGrid1DrawColumnCell(Sender: TObject);
begin
  //Loading agak lama diganti dengan event onKeyDown dan onCellClick:
  //dbTrans2.Commit;
  //    dbQuery2.SQL.Text:='SELECT SDTL_NO "NO", SDTL_PROD_ID "ID", SDTL_PROD_NAME "NAMA PRODUK", ' +
  //                   'SDTL_UOM "UOM", SDTL_QTY "QTY", SDTL_PRICE "HARGA", SDTL_DPP "DPP", SDTL_PPN "PPN", ' +
  //                   'SDTL_TOTAL "TOTAL" ' +
  //                   'FROM INVOICE_DTL WHERE SDTL_NO =:vNO';
  //    dbQuery2.Params.ParamByName('vNO').AsString:=DBGrid1.DataSource.DataSet.FieldByName('NO').AsString;
  //    dbQuery2.Open;
  //CustomDisplayGrid2;
end;

procedure TfManageInvoice.DBGrid1KeyDown(Sender: TObject);
begin
    dbTrans2.Commit;
      dbQuery2.SQL.Text:='SELECT INV_DTL_NO "NO", INV_DTL_PROD_ID "ID", INV_DTL_PROD_NAME "NAMA PRODUK", ' +
                     'INV_DTL_PROD_UOM "UOM", INV_DTL_QTY "QTY", INV_DTL_PRICE "HARGA", INV_DTL_DPP "DPP", INV_DTL_PPN "PPN", ' +
                     'INV_DTL_TOTAL "TOTAL" FROM INVOICE_DTL WHERE INV_DTL_NO =:vNO';
      dbQuery2.Params.ParamByName('vNO').AsString:=DBGrid1.DataSource.DataSet.FieldByName('NO').AsString;
      dbQuery2.Open;
  CustomDisplayGrid2;
end;

procedure TfManageInvoice.ConnectionDB;
begin
  // DATABASE CONNECTION
  dbConnection.DatabaseName := 'PWTPRDNETDB';
  dbConnection.HostName := 'LOCALHOST';
  dbConnection.UserName := 'SYSDBA';
  dbConnection.Password := 'masterkey';

  try
    // Membuka koneksi
    dbConnection.Connected := True;

    // Memulai transaksi
    if not dbTrans1.Active then dbTrans1.StartTransaction;
    if not dbTrans2.Active then dbTrans2.StartTransaction;
    if not dbTrans3.Active then dbTrans3.StartTransaction;

    // Menampilkan pesan sukses jika transaksi aktif
    if dbConnection.Connected and dbTrans1.Active then
    begin
      //ShowMessage('Connection successful!');
      btnSearchClick(Self); // Memanggil fungsi pencarian
    end;

  except
    on E: Exception do
    begin
      // Menangkap kesalahan koneksi atau transaksi
      ShowMessage('Error during connection: ' + E.Message);
      Exit;
    end;
  end;
end;

procedure TfManageInvoice.CustomDisplayGrid2;
begin
  TNumericField(dbQuery2.Fields.FieldByName('QTY')).DisplayFormat := '#,##0.#0';
  TNumericField(dbQuery2.Fields.FieldByName('HARGA')).DisplayFormat := '#,##0.#0';
  TNumericField(dbQuery2.Fields.FieldByName('DPP')).DisplayFormat := '#,##0.#0';
  TNumericField(dbQuery2.Fields.FieldByName('PPN')).DisplayFormat := '#,##0.#0';
  TNumericField(dbQuery2.Fields.FieldByName('TOTAL')).DisplayFormat := '#,##0.#0';

  dbGrid2.Columns.Items[4].Width := dbGrid2.Columns.Items[4].Width + 15;
  dbGrid2.Columns.Items[5].Width := dbGrid2.Columns.Items[5].Width + 25;
  dbGrid2.Columns.Items[6].Width := dbGrid2.Columns.Items[6].Width + 25;
  dbGrid2.Columns.Items[7].Width := dbGrid2.Columns.Items[7].Width + 25;
  dbGrid2.Columns.Items[8].Width := dbGrid2.Columns.Items[8].Width + 25;
end;

procedure TfManageInvoice.FormShow(Sender: TObject);
begin
  ClearInput;
  btnSearchClick(Self); // Memanggil fungsi pencarian
end;

procedure TfManageInvoice.btnDetailClick(Sender: TObject);
begin
  dbTrans2.Commit;
      dbQuery2.SQL.Text:='SELECT INV_DTL_NO "NO", INV_DTL_PROD_ID "ID", INV_DTL_PROD_NAME "NAMA PRODUK", ' +
                     'INV_DTL_PROD_UOM "UOM", INV_DTL_QTY "QTY", INV_DTL_PRICE "HARGA", INV_DTL_DPP "DPP", INV_DTL_PPN "PPN", ' +
                     'INV_DTL_TOTAL "TOTAL" FROM INVOICE_DTL WHERE INV_DTL_NO =:vNO';
      dbQuery2.Params.ParamByName('vNO').AsString:=DBGrid1.DataSource.DataSet.FieldByName('NO').AsString;
      dbQuery2.Open;
  CustomDisplayGrid2;
end;

end.


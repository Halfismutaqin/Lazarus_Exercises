unit UmanageInvoice_add;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, sqldb, FileUtil, Forms, Controls,
  Graphics, Dialogs, StdCtrls, Buttons, EditBtn, DBGrids, DbCtrls, ExtCtrls;

type

  { TfManageInvoice_add }

  TfManageInvoice_add = class(TForm)
    btnGenerate: TBitBtn;
    btnSelectCust: TBitBtn;
    btnSelectProduct: TBitBtn;
    btnAddItems: TBitBtn;
    btnDeleteItems: TBitBtn;
    btnReset: TBitBtn;
    btnSave: TBitBtn;
    cbInvType: TComboBox;
    cbInvStatus: TComboBox;
    cbItemPpn: TComboBox;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    ebDate: TDateEdit;
    ebInvNo: TEdit;
    ebSalesNo: TEdit;
    ebCustID: TEdit;
    ebCustType: TEdit;
    ebCustName: TEdit;
    ebCustCity: TEdit;
    ebCustProvince: TEdit;
    ebItemID: TEdit;
    ebItemName: TEdit;
    ebItemUom: TEdit;
    ebItemPrice: TEdit;
    ebItemQty: TEdit;
    ebItemTotal: TEdit;
    ebItemPpn: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    ebCustAddress: TMemo;
    dbQuery1: TSQLQuery;
    dbTrans1: TSQLTransaction;
    dbQuery: TSQLQuery;
    dbTrans: TSQLTransaction;
    procedure btnAddItemsClick(Sender: TObject);
    procedure btnDeleteItemsClick(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnSelectProductClick(Sender: TObject);
    procedure cbItemPpnChange(Sender: TObject);
    procedure ClearInput;
    procedure ClearInputDetail;
    procedure CalculatePrice;
    procedure InputNumberValidation(var Key: char);
    procedure UpdateGrid;
    procedure DisplayGrid1;
    procedure RefreshDBGridView;

    procedure ebItemPriceEditingDone(Sender: TObject);
    procedure ebItemQtyKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ebItemPriceKeyPress(Sender: TObject; var Key: char);
    procedure ebItemPriceKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ebItemQtyKeyPress(Sender: TObject; var Key: char);
    procedure btnSelectCustClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure cbInvTypeChange(Sender: TObject);
    procedure ebItemTotalKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GroupBox1Click(Sender: TObject);
    procedure SetCustomerDetails(const CustID, CustType, CustName,
      CustAddress, CustCity, CustProvince: string);
    procedure SetProductDetails(const ProductID, ProductName,
      ProductUom: string);
  private
    { private declarations }
    SelectedCustomerID: string;
    SelectedProductID: string;
    function InputValidationHeader: Boolean;
    function InputValidationDetail: Boolean;


  public
    { public declarations }
  end;

var
  fManageInvoice_add: TfManageInvoice_add;

implementation
uses
  UmanageInvoice, UmodalCustomers, UmodalProduct;

{$R *.lfm}

{ TfManageInvoice_add }

procedure TfManageInvoice_add.ClearInput;
begin
  //Inv Header:
  ebInvNo.Clear;
  ebSalesNo.Clear;
  ebDate.Clear;
  ebDate.DateOrder:=doDMY;
  ebCustID.Clear;
  ebCustType.Clear;
  ebCustName.Clear;
  ebCustAddress.Clear;
  ebCustCity.Clear;
  ebCustProvince.Clear;
  cbInvType.ItemIndex := -1;
  cbInvType.Text := 'PILIH';
  cbInvStatus.ItemIndex := -1;
  cbInvStatus.Text := 'PILIH';

  //Clear item detail:
  ClearInputDetail;
end;

procedure TfManageInvoice_add.ClearInputDetail;
begin
  //Inv Detail Item:
  ebItemID.Clear;
  ebItemName.Clear;
  ebItemUom.Clear;
  ebItemPrice.Text := '0';
  ebItemQty.Text := '0';
  ebItemPpn.Text := '0';
  ebItemTotal.Text := '0';
  cbItemPpn.ItemIndex := -1;
  cbItemPpn.Text := 'PILIH';
  cbItemPpn.ReadOnly := False;  // Ganti disabled untuk mengunci
end;

procedure TfManageInvoice_add.btnSelectProductClick(Sender: TObject);
begin
  // Commit any pending transactions
  dbTrans.Commit;

  // Prepare the SQL Query to fetch customer details
  dbQuery.SQL.Text := 'SELECT PROD_ID, PROD_NAME, PROD_UOM, ' +
                      'ITEM_PRICE_G1, ITEM_PRICE_G2, ITEM_PRICE_E1 ' +
                      'FROM PRODUCTS_2 ' +
                      'WHERE PROD_ID <> '''' ' +
                      'ORDER BY PROD_ID';
  try
    dbQuery.Open; // Open the query
    if not dbQuery.IsEmpty then
    begin
      // Open the modal customer form
      fModalProduct := TfModalProduct.Create(Self);
      try
        fModalProduct.DBGrid1.DataSource.DataSet := dbQuery; // Link DBGrid to query dataset

        // Show modal form
        if fModalProduct.ShowModal = mrOk then
        begin
          // Handle customer selection logic here
          SelectedProductID := fModalProduct.SelectedProductID;
        end;
      finally
        fModalProduct.Free;
      end;
    end
    else
      ShowMessage('No product found!');
  finally
    dbQuery.Close; // Close the query
    dbTrans.Commit; // Finalize transaction
  end;
end;

procedure TfManageInvoice_add.btnAddItemsClick(Sender: TObject);

  function CleanInputValue(Value: String): String;
  begin
    Result := StringReplace(Value, ',', '', [rfReplaceAll]);
    Result := StringReplace(Result, '.', '', [rfReplaceAll]);
  end;

var
  ItemPrice, ItemQty, ItemTotal, PpnValue, DppValue: Double;
  FlagPpn : String;
begin
  // Validasi Input - Pastikan header dan detail valid
  if not InputValidationHeader then
    Exit;  // Jika validasi header gagal, hentikan proses

  if not InputValidationDetail then
    Exit;  // Jika validasi detail gagal, hentikan proses

  // Bersihkan dan konversi input
  ItemPrice := StrToFloatDef(CleanInputValue(ebItemPrice.Text), 0);
  ItemQty := StrToFloatDef(ebItemQty.Text, 0);
  ItemTotal := ItemPrice * ItemQty;

  //Cek if ppn:
  if cbItemPpn.Text = 'PPN' then
  PpnValue := ItemTotal * 0.12
  else
  PpnValue := 0;

  DppValue := ItemTotal - PpnValue;

   if not dbTrans1.Active then
     dbTrans1.StartTransaction;

   try
     // Cek apakah data sudah ada di INVOICE_DTL
     dbTrans1.Commit;
     dbQuery1.SQL.Text:='SELECT 1 FROM INVOICE_HDR WHERE INV_HDR_NO = :vInvHdrNo';
     dbQuery1.Params.ParamByName('vInvHdrNo').AsString:=ebInvNo.Text;
     dbQuery1.Open;

     if dbQuery1.EOF then
     begin
       // Jika data tidak ada, lakukan INSERT
       dbQuery1.SQL.Text :=
         'INSERT INTO INVOICE_DTL ' +
         '(INV_DTL_NO, INV_DTL_PROD_ID, INV_DTL_PROD_NAME, INV_DTL_PROD_UOM, ' +
         'INV_DTL_QTY, INV_DTL_PRICE, INV_DTL_DPP, INV_DTL_PPN, INV_DTL_TOTAL) ' +
         'VALUES (:vInvNo, :vProdId, :vProdName, :vUom, :vQty, :vPrice, :vDpp, :vPpn, :vTotal)';

       with dbQuery1.Params do
       begin
         ParamByName('vInvNo').AsString := ebInvNo.Text;
         ParamByName('vProdId').AsString := ebItemID.Text;
         ParamByName('vProdName').AsString := ebItemName.Text;
         ParamByName('vUom').AsString := ebItemUom.Text;
         ParamByName('vQty').AsFloat := ItemQty;
         ParamByName('vPrice').AsFloat := ItemPrice;
         ParamByName('vDpp').AsFloat := DppValue;
         ParamByName('vPpn').AsFloat := PpnValue;
         ParamByName('vTotal').AsFloat := ItemTotal;
       end;

       dbQuery1.ExecSQL;
       dbTrans1.Commit;

       // Bersihkan input dan perbarui grid
       FlagPpn := cbItemPpn.Text;
       ClearInputDetail;
       UpdateGrid;

       cbItemPpn.Text:=FlagPpn;
       cbItemPpn.ReadOnly:=True;

       ShowMessage('Data berhasil ditambahkan.');
     end
     else
     begin
       // Data sudah ada
       dbTrans1.Rollback;
       ShowMessage('Data sudah ada di database.');
     end;

   except
     on E: Exception do
     begin
       dbTrans1.Rollback;
       MessageDlg('Error saat menambahkan data: ' + E.Message, mtError, [mbOK], 0);
     end;
   end;
end;

procedure TfManageInvoice_add.btnDeleteItemsClick(Sender: TObject);
begin
    if not(DBGrid1.DataSource.DataSet.Fields.FieldByName('PRODUCT NAME').IsNull)
    and (ebInvNo.Text <> '') then
    begin
    if MessageDlg('EAS Confirmation', 'Apakah Anda yakin ingin menghapus item ' +
      DBGrid1.DataSource.DataSet.Fields.FieldByName('PRODUCT NAME').AsString +
      ' ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        dbTrans.Commit;
        dbQuery.SQL.Text := 'DELETE FROM INVOICE_DTL WHERE INV_DTL_NO = :vIDTLNO ' +
                         'AND INV_DTL_PROD_ID = :vPRODID';
        dbQuery.Params.ParamByName('vIDTLNO').AsString:=ebInvNo.Text;
        dbQuery.Params.ParamByName('vPRODID').AsString:=DBGrid1.DataSource.DataSet.FieldByName('PRODUCT ID').AsString;
        dbQuery.ExecSQL;
        dbTrans.Commit;

        // DBGRID1 VIEW
        RefreshDBGridView;
      end;
    end;
end;

procedure TfManageInvoice_add.btnGenerateClick(Sender: TObject);
var
  NoInvHDR : Integer;
begin
  //CTRLTBL
  dbTrans.Commit;
  dbQuery.SQL.Text:='SELECT CTRL_VAL_1_NUM FROM CTRLTBL WHERE CTRL_NAME = :vCTRLNAME';
  dbQuery.Params.ParamByName('vCTRLNAME').AsString:='INV_NO';
  dbQuery.Open;
  NoInvHDR := 0;
  NoInvHDR := dbQuery.Fields.FieldByName('CTRL_VAL_1_NUM').AsInteger;

  ebInvNo.Text:=IntToStr(NoInvHDR);
  //btnGenerate.Enabled:=False;

  // DBGRID1 VIEW
  RefreshDBGridView;
end;

procedure TfManageInvoice_add.btnSaveClick(Sender: TObject);
begin
  // Validasi Input - Pastikan header dan detail valid
  if not InputValidationHeader then
    Exit;  // Jika validasi header gagal, hentikan proses

  if (ebInvNo.Text <> '') and (not DBGrid1.DataSource.DataSet.IsEmpty) then
    begin
      dbTrans.Commit;
      dbQuery.SQL.Text:='SELECT 1 FROM INVOICE_HDR WHERE INV_HDR_NO = :vHDRNO';
      dbQuery.Params.ParamByName('vHDRNO').AsString:=ebInvNo.Text;
      dbQuery.Open;

      if dbQuery.EOF then
        begin
          // INSERT INVOICE HDR
          dbTrans.Commit;
          dbQuery.SQL.Text := 'INSERT INTO INVOICE_HDR ' +
                          '(INV_HDR_NO, INV_HDR_DT, INV_HDR_TYPE, INV_HDR_CUST_ID, ' +
                          'INV_HDR_CUST_NAME, INV_HDR_CUST_ADDR, INV_HDR_CUST_CITY, ' +
                          'INV_HDR_CUST_PROVINCE, INV_HDR_STATUS, INV_HDR_PPN_FLAG, SHDR_NO)' +
                          'VALUES (:vNO, :vDT, :vTYPE, :vID, :vNAME, :vADDR, :vCITY, ' +
                          ':vPROVINCE,:vSTATUS, :vPPN, :vShdrNo)';
          dbQuery.Params.ParamByName('vNO').AsString:=ebInvNo.Text;
          dbQuery.Params.ParamByName('vDT').AsDate:=StrToDate(ebDate.Text);
          dbQuery.Params.ParamByName('vTYPE').AsString:=cbInvType.Text;
          dbQuery.Params.ParamByName('vID').AsString:=ebCustID.Text;
          dbQuery.Params.ParamByName('vNAME').AsString:=ebCustName.Text;
          dbQuery.Params.ParamByName('vADDR').AsString:=ebCustAddress.Text;
          dbQuery.Params.ParamByName('vCITY').AsString:=ebCustCity.Text;
          dbQuery.Params.ParamByName('vPROVINCE').AsString:=ebCustProvince.Text;
          dbQuery.Params.ParamByName('vSTATUS').AsString:=cbInvStatus.Text;
          dbQuery.Params.ParamByName('vShdrNo').AsString:=ebSalesNo.Text;
          if cbItemPpn.Text = 'PPN' then
            dbQuery.Params.ParamByName('vPPN').AsString:='Y'
          else
            dbQuery.Params.ParamByName('vPPN').AsString:='N';
          dbQuery.ExecSQL;
          dbTrans.Commit;
          MessageDlg('DATA BERHASIL DISIMPAN', mtConfirmation, [mbYes], 0);

          //Update Generate Code:
          dbQuery.SQL.Text:='UPDATE CTRLTBL SET CTRL_VAL_1_NUM = CTRL_VAL_1_NUM + 1, ' +
                            'LAST_UPDATED_DT = CURRENT_TIMESTAMP, ' +
                            'LAST_UPDATED_BY = :vUSERID WHERE CTRL_NAME = :vCTRLNAME';
          dbQuery.Params.ParamByName('vCTRLNAME').AsString:='INV_NO';
          dbQuery.ExecSQL;
          dbTrans.Commit;

          ClearInput;
          Close;
        end;
    end
    else
    begin
      ShowMessage('Minimal ada 1 data item detail!');
      exit;
    end;
end;


procedure TfManageInvoice_add.UpdateGrid;
begin
  dbQuery1.SQL.Text :=
    'SELECT INV_DTL_NO "NO", INV_DTL_PROD_ID "PRODUCT ID", INV_DTL_PROD_NAME "PRODUCT NAME", ' +
    'INV_DTL_PROD_UOM "UOM", INV_DTL_QTY "QTY", INV_DTL_PRICE "PRICE", INV_DTL_DPP "DPP", ' +
    'INV_DTL_PPN "PPN", INV_DTL_TOTAL "TOTAL" FROM INVOICE_DTL WHERE INV_DTL_NO = :vIDTLNO';
  dbQuery1.Params.ParamByName('vIDTLNO').AsString := ebInvNo.Text;
  dbQuery1.Open;

  DisplayGrid1;
end;

procedure TfManageInvoice_add.RefreshDBGridView;
begin
  // DBGRID1 VIEW
  dbTrans1.Commit;
  dbQuery1.SQL.Text := 'SELECT INV_DTL_NO "NO", INV_DTL_PROD_ID "PRODUCT ID", ' +
                       'INV_DTL_PROD_NAME "PRODUCT NAME", INV_DTL_PROD_UOM "UOM", ' +
                       'INV_DTL_QTY "QTY", INV_DTL_PRICE "PRICE", INV_DTL_DPP "DPP", ' +
                       'INV_DTL_PPN "PPN", INV_DTL_TOTAL "TOTAL" ' +
                       'FROM INVOICE_DTL WHERE INV_DTL_NO = :vIDTLNO';
  dbQuery1.Params.ParamByName('vIDTLNO').AsString:=ebInvNo.Text;
  dbQuery1.Open;

  DisplayGrid1;
end;

procedure TfManageInvoice_add.DisplayGrid1;
const
  ColWidths: array [4..8] of Integer = (15, 25, 25, 25, 25);
var
  i: Integer;
begin
  TNumericField(dbQuery1.FieldByName('QTY')).DisplayFormat := '#,##0.#0';
  TNumericField(dbQuery1.FieldByName('PRICE')).DisplayFormat := '#,##0.#0';
  TNumericField(dbQuery1.FieldByName('DPP')).DisplayFormat := '#,##0.#0';
  TNumericField(dbQuery1.FieldByName('PPN')).DisplayFormat := '#,##0.#0';
  TNumericField(dbQuery1.FieldByName('TOTAL')).DisplayFormat := '#,##0.#0';

  // Atur lebar kolom
  for i := 4 to 8 do
    dbGrid1.Columns[i].Width := dbGrid1.Columns[i].Width + ColWidths[i];
end;

procedure TfManageInvoice_add.cbItemPpnChange(Sender: TObject);
begin
  CalculatePrice;
end;

procedure TfManageInvoice_add.InputNumberValidation(var Key: char);
begin
  if not (key in['0'..'9',#8,#13,#46]) then
  begin
    MessageDlg('Maaf yang anda isikan bukan angka', mtWarning,[mbok],0);
    key:=#0;
  end;
end;

function TfManageInvoice_add.InputValidationHeader: Boolean;
begin
  // INPUT VALIDATION : Memastikan semua field terisi
  Result := True;  // Default validasi berhasil

  if ebInvNo.Text = '' then
  begin
    MessageDlg('Pastikan Inv No terisi', mtWarning, [mbOK], 0);
    Result := False;  // Validasi gagal
  end
  else if ebSalesNo.Text = '' then
  begin
    MessageDlg('Mohon isikan Sales No terlebih dahulu', mtWarning, [mbOK], 0);
    Result := False;
  end
  else if ebDate.Text = '' then
  begin
    MessageDlg('Mohon pilih Inv Date terlebih dahulu', mtWarning, [mbOK], 0);
    Result := False;
  end
  else if (cbInvType.Text = '') or (cbInvType.Text = 'PILIH') then
  begin
    MessageDlg('Mohon pilih Inv Type terlebih dahulu', mtWarning, [mbOK], 0);
    Result := False;
  end
  else if ebCustID.Text = '' then
  begin
    MessageDlg('Mohon pilih Cust ID terlebih dahulu', mtWarning, [mbOK], 0);
    Result := False;
  end
  else if (cbInvStatus.Text = '') or (cbInvStatus.Text = 'PILIH') then
  begin
    MessageDlg('Mohon pilih Inv Status terlebih dahulu', mtWarning, [mbOK], 0);
    Result := False;
  end;
end;

function TfManageInvoice_add.InputValidationDetail: Boolean;
begin
  // INPUT VALIDATION : Memastikan semua field detail terisi
  Result := True;  // Default validasi berhasil

  if ebItemID.Text = '' then
  begin
    MessageDlg('Mohon pilih Product terlebih dahulu', mtWarning, [mbOK], 0);
    Result := False;  // Validasi gagal
  end
  else if ebItemTotal.Text = '' then
  begin
    MessageDlg('Total price belum diketahui', mtWarning, [mbOK], 0);
    Result := False;
  end
  else if (cbItemPpn.Text = '') or (cbItemPpn.Text = 'PILIH') then
  begin
    MessageDlg('Mohon pilih PPN terlebih dahulu', mtWarning, [mbOK], 0);
    Result := False;
  end;
end;

procedure TfManageInvoice_add.ebItemPriceKeyPress(Sender: TObject; var Key: char);
begin
  InputNumberValidation(Key);
end;

procedure TfManageInvoice_add.ebItemPriceKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  RawInput: string;
  NumericValue: Int64;
  FormattedPrice: string;
begin
  // Ambil input dari EditText
  RawInput := ebItemPrice.Text;

  // Hapus karakter non-angka (selain angka 0-9)
  RawInput := StringReplace(RawInput, '.', '', [rfReplaceAll]); // Hilangkan titik pemisah ribuan lama
  RawInput := StringReplace(RawInput, ',', '', [rfReplaceAll]); // Hilangkan koma

  // Konversi string ke angka
  if TryStrToInt64(RawInput, NumericValue) then
  begin
    // Format ulang ke format angka dengan separator ribuan
    FormattedPrice := FormatFloat('#,##0', NumericValue);

    // Set teks yang diformat kembali ke EditText
    ebItemPrice.Text := FormattedPrice;

    // Pindahkan kursor ke akhir teks agar tetap nyaman diinput
    ebItemPrice.SelStart := Length(FormattedPrice);
  end
  else
  begin
    // Jika input kosong atau invalid, kosongkan input
    ebItemPrice.Text := '0';
  end;
end;

procedure TfManageInvoice_add.CalculatePrice;
var
  ItemPrice, ItemQty, PpnValue, ItemTotal: Double;
  CleanedPrice: string;
begin
  // Mengambil teks dari ebItemPrice
  CleanedPrice := ebItemPrice.Text;

  // Menghapus koma ribuan jika ada
  CleanedPrice := StringReplace(CleanedPrice, ',', '', [rfReplaceAll]);

  // Pastikan input harga valid (angka)
  if not TryStrToFloat(CleanedPrice, ItemPrice) then
    ItemPrice := 0;

  // Pastikan input kuantitas valid (angka)
  if not TryStrToFloat(ebItemQty.Text, ItemQty) then
    ItemQty := 0;

  // Hitung total harga sebelum PPN
  ItemTotal := ItemPrice * ItemQty;

  // Jika PPN, kurangi 12% dari total
  if cbItemPpn.Text = 'PPN' then
  begin
    //ItemTotal := ItemTotal + (ItemTotal * 0.12);
    PpnValue := ItemTotal * 0.12;
    ebItemPpn.Text := FormatFloat('#,##0.00', PpnValue);
  end
  else
    ebItemPpn.Text := '0';

  // Tampilkan hasil ke ebItemTotal
  ebItemTotal.Text := FormatFloat('#,##0.00', ItemTotal);
end;

procedure TfManageInvoice_add.ebItemPriceEditingDone(Sender: TObject);
begin
  CalculatePrice;
end;

procedure TfManageInvoice_add.ebItemQtyKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  CalculatePrice;
end;

procedure TfManageInvoice_add.ebItemQtyKeyPress(Sender: TObject; var Key: char);
begin
  InputNumberValidation(Key);
end;


procedure TfManageInvoice_add.btnResetClick(Sender: TObject);
begin
  ClearInputDetail;
  RefreshDBGridView;
end;

procedure TfManageInvoice_add.SetCustomerDetails(
  const CustID, CustType, CustName, CustAddress, CustCity, CustProvince: string);
begin
  // Assign values to the appropriate controls
  ebCustID.Text := CustID;
  ebCustType.Text := CustType;
  ebCustName.Text := CustName;
  ebCustAddress.Text := CustAddress;
  ebCustCity.Text := CustCity;
  ebCustProvince.Text := CustProvince;
end;

procedure TfManageInvoice_add.SetProductDetails(
  const ProductID, ProductName, ProductUom: string);
begin
  // Assign values to the appropriate controls
  ebItemID.Text := ProductID;
  ebItemName.Text := ProductName;
  ebItemUom.Text := ProductUom;
end;

procedure TfManageInvoice_add.btnSelectCustClick(Sender: TObject);
begin
  // Commit any pending transactions
  dbTrans.Commit;

  // Prepare the SQL Query to fetch customer details
  dbQuery.SQL.Text := 'SELECT CUST_ID, CUST_TYPE, CUST_NAME, CUST_ADDRESS, ' +
                      'CUST_CITY, CUST_PROVINCE, CUST_DEL_ADDRESS ' +
                      'FROM CUSTOMER ' +
                      'WHERE CUST_ID <> '''' ' +
                      'ORDER BY CUST_ID';
  try
    dbQuery.Open; // Open the query
    if not dbQuery.IsEmpty then
    begin
      // Open the modal customer form
      fModalCustomers := TfModalCustomers.Create(Self);
      try
        fModalCustomers.DBGrid1.DataSource.DataSet := dbQuery; // Link DBGrid to query dataset

        // Show modal form
        if fModalCustomers.ShowModal = mrOk then
        begin
          // Handle customer selection logic here
          SelectedCustomerID := fModalCustomers.SelectedCustomerID;
        end;
      finally
        fModalCustomers.Free;
      end;
    end
    else
      ShowMessage('No customers found!');
  finally
    dbQuery.Close; // Close the query
    dbTrans.Commit; // Finalize transaction
  end;
end;

procedure TfManageInvoice_add.FormCreate(Sender: TObject);
begin
   fManageInvoice.ConnectionDB;
   if not dbTrans.Active then dbTrans.StartTransaction;
   if not dbTrans1.Active then dbTrans1.StartTransaction;

   ClearInput;

   // FETCH INV_HDR_TYPE
   dbTrans.Commit;
   dbQuery.SQL.Text:='SELECT DISTINCT INV_HDR_TYPE FROM INVOICE_HDR';
   dbQuery.Open;
   cbInvType.Items.Clear;
   dbQuery.First;
   WHILE not dbQuery.EOF do
     begin
       cbInvType.Items.Add(dbQuery.Fields.FieldByName('INV_HDR_TYPE').AsString);
       dbQuery.Next;
     end;
   dbTrans.Commit;

   // FETCH INV_HDR_STATUS
   dbTrans.Commit;
   dbQuery.SQL.Text:='SELECT DISTINCT INV_HDR_STATUS FROM INVOICE_HDR   ';
   dbQuery.Open;
   cbInvStatus.Items.Clear;
   dbQuery.First;
   WHILE not dbQuery.EOF do
     begin
       cbInvStatus.Items.Add(dbQuery.Fields.FieldByName('INV_HDR_STATUS').AsString);
       dbQuery.Next;
     end;
   dbTrans.Commit;

end;

procedure TfManageInvoice_add.FormShow(Sender: TObject);
begin
  ClearInput;
end;

procedure TfManageInvoice_add.GroupBox1Click(Sender: TObject);
begin

end;

procedure TfManageInvoice_add.cbInvTypeChange(Sender: TObject);
begin

end;

procedure TfManageInvoice_add.ebItemTotalKeyPress(Sender: TObject; var Key: char);
begin
  InputNumberValidation(Key);
end;

end.


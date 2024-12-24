unit UmanageInvoice_edit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, IBConnection, sqldb, FileUtil, Forms, Controls,
  Graphics, Dialogs, StdCtrls, EditBtn, DBGrids, Buttons;

type

  { TfManageInvoice_edit }

  TfManageInvoice_edit = class(TForm)
    btnReset: TBitBtn;
    btnUpdateItem: TBitBtn;
    btnUpdate: TBitBtn;
    cbInvType: TComboBox;
    cbInvStatus: TComboBox;
    cbItemPpn: TComboBox;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    ebInvDate: TDateEdit;
    ebInvNo: TEdit;
    ebCustID: TEdit;
    ebCustName: TEdit;
    ebCustType: TEdit;
    dbC: TIBConnection;
    dbQuery1: TSQLQuery;
    dbQuery: TSQLQuery;
    dbTrans1: TSQLTransaction;
    dbTrans: TSQLTransaction;
    ebCustCity: TEdit;
    ebCustProvince: TEdit;
    ebItemID: TEdit;
    ebItemName: TEdit;
    ebItemUom: TEdit;
    ebItemPrice: TEdit;
    ebItemPpn: TEdit;
    ebItemQty: TEdit;
    ebItemTotal: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    emCustAddress: TMemo;
    procedure btnResetClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnUpdateItemClick(Sender: TObject);
    procedure ConnectionDB;
    procedure ClearInput;
    procedure ClearInputDetail;
    procedure DisplayGrid1;
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fManageInvoice_edit: TfManageInvoice_edit;
  gvInvNo : string;

implementation
uses UmanageInvoice;

{$R *.lfm}

{ TfManageInvoice_edit }

procedure TfManageInvoice_edit.ConnectionDB;
begin
  // DATABASE CONNECTION
  dbC.DatabaseName := 'PWTPRDNETDB';
  dbC.HostName := 'LOCALHOST';
  dbC.UserName := 'SYSDBA';
  dbC.Password := 'masterkey';

  try
    // Membuka koneksi
    dbC.Connected := True;

    // Memulai transaksi
    if not dbTrans.Active then dbTrans.StartTransaction;
    if not dbTrans1.Active then dbTrans1.StartTransaction;

  except
    on E: Exception do
    begin
      // Menangkap kesalahan koneksi atau transaksi
      ShowMessage('Error during connection: ' + E.Message);
      Exit;
    end;
  end;
end;

procedure TfManageInvoice_edit.btnResetClick(Sender: TObject);
begin
  ClearInputDetail;
end;

procedure TfManageInvoice_edit.btnUpdateClick(Sender: TObject);
begin
  if ebInvNo.Text <> '' then
  begin
    dbTrans.Commit;
    dbQuery.SQL.Text:='UPDATE INVOICE_HDR SET INV_HDR_DT = :vDT, INV_HDR_STATUS = :vSTATUS ' +
                  'WHERE INV_HDR_NO = :vNO';
    dbQuery.Params.ParamByName('vNO').AsString:=GvInvNo;
    dbQuery.Params.ParamByName('vDT').AsDate:=StrToDate(ebInvDate.Text);
    dbQuery.Params.ParamByName('vSTATUS').AsString:=cbInvStatus.Text;
    dbQuery.ExecSQL;
    dbTrans.Commit;
    MessageDlg('DATA BERHASIL DISIMPAN', mtConfirmation, [mbYes], 0);
    Close;

    fManageInvoice.btnSearchClick(Self);
  end;
end;

procedure TfManageInvoice_edit.btnUpdateItemClick(Sender: TObject);
function CleanInputValue(Value: String): String;
 begin
   Result := StringReplace(Value, ',', '', [rfReplaceAll]);
   Result := StringReplace(Result, '.', '', [rfReplaceAll]);
 end;

var
  ItemPrice, ItemQty, ItemTotal, PpnValue, DppValue: Double;
  FlagPpn : String;

begin
  if (ebInvNo.Text <> '') and (ebItemID.Text <> '') then
    begin
      dbTrans.Commit;
      dbQuery.SQL.Text:='SELECT 1 FROM INVOICE_DTL WHERE INV_DTL_NO = :vNO AND INV_DTL_PROD_ID = :vID';
      dbQuery.Params.ParamByName('vNO').AsString:=ebInvNo.Text;
      dbQuery.Params.ParamByName('vID').AsString:=ebItemID.Text;
      dbQuery.Open;

      if not dbQuery.EOF then
        begin
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

          // UPDATE INVOICE DTL
          dbTrans.Commit;
          dbQuery.SQL.Text:='UPDATE INVOICE_DTL SET INV_DTL_PROD_ID = :vID, ' +
                        'INV_DTL_PROD_NAME = :vNAME, INV_DTL_PROD_UOM = :vUOM, ' +
                        'INV_DTL_QTY = :vQTY, INV_DTL_PRICE = :vPRICE, ' +
                        'INV_DTL_DPP = :vDPP, INV_DTL_PPN = :vPPN, INV_DTL_TOTAL = :vTOTAL '+
                        'WHERE INV_DTL_NO = :vNO AND INV_DTL_PROD_ID = :vID';
          dbQuery.ParamByName('vNO').AsString:=gvInvNo;
          dbQuery.ParamByName('vID').AsString:=ebItemID.Text;
          dbQuery.ParamByName('vNAME').AsString:=ebItemName.Text;
          dbQuery.ParamByName('vUOM').AsString:=ebItemUom.Text;
          dbQuery.ParamByName('vQTY').AsFloat := ItemQty;
          dbQuery.ParamByName('vPRICE').AsFloat := ItemPrice;
          dbQuery.ParamByName('vDPP').AsFloat := DppValue;
          dbQuery.ParamByName('vPPN').AsFloat := PpnValue;
          dbQuery.ParamByName('vTOTAL').AsFloat := ItemTotal;
          dbQuery.ExecSQL;
          dbTrans.Commit;
          MessageDlg('DATA BERHASIL DIUBAH',mtConfirmation,[mbYes],0);
        end
      else
        begin
          // INSERT INVOICE DTL
          dbTrans.Commit;
          dbQuery.SQL.Text:='INSERT INTO INVOICE_DTL (INV_DTL_NO, INV_DTL_PROD_ID, INV_DTL_PROD_NAME, INV_DTL_PROD_UOM, ' +
                        'INV_DTL_QTY, INV_DTL_PRICE, INV_DTL_DPP, INV_DTL_PPN, INV_DTL_TOTAL) ' +
                        'VALUES(:vNO, :vID, :vNAME, :vUOM, :vQTY, :vPRICE, :vDPP, :vPPN, :vTOTAL)';
          dbQuery.ParamByName('vNO').AsString:=gvInvNo;
          dbQuery.ParamByName('vID').AsString:=ebItemID.Text;
          dbQuery.ParamByName('vNAME').AsString:=ebItemName.Text;
          dbQuery.ParamByName('vUOM').AsString:=ebItemUom.Text;
          dbQuery.ParamByName('vQTY').AsFloat := ItemQty;
          dbQuery.ParamByName('vPRICE').AsFloat := ItemPrice;
          dbQuery.ParamByName('vDPP').AsFloat := DppValue;
          dbQuery.ParamByName('vPPN').AsFloat := PpnValue;
          dbQuery.ParamByName('vTOTAL').AsFloat := ItemTotal;
          dbQuery.ExecSQL;
          dbTrans.Commit;
          MessageDlg('DATA BERHASIL DITAMBAHKAN',mtConfirmation,[mbYes],0);
        end;

        // DBGRID INVOICE DTL
      dbTrans1.Commit;
    dbQuery1.SQL.Text := 'SELECT INV_DTL_NO "NO", INV_DTL_PROD_ID "ID", ' +
                     'INV_DTL_PROD_NAME "NAMA PRODUK", INV_DTL_PROD_UOM "UOM", ' +
                     'INV_DTL_QTY "QTY", INV_DTL_PRICE "PRICE", INV_DTL_TOTAL "TOTAL", ' +
                     'INV_DTL_DPP "DPP", INV_DTL_PPN "PPN"' +
                     'FROM INVOICE_DTL WHERE INV_DTL_NO = :vNO';
      dbQuery1.Params.ParamByName('vNO').AsString:= gvInvNo;
      dbQuery1.Open;
      DisplayGrid1;

      // CLEAR
      ClearInputDetail;
    end;
end;

procedure TfManageInvoice_edit.ClearInput;
begin
  //Inv Header:
  ebInvNo.Clear;
  ebInvNo.Text := gvInvNo;
  ebInvDate.Clear;
  ebInvDate.DateOrder:=doDMY;
  ebCustID.Clear;
  ebCustType.Clear;
  ebCustName.Clear;
  emCustAddress.Clear;
  ebCustCity.Clear;
  ebCustProvince.Clear;
  cbInvType.ItemIndex := -1;
  cbInvType.Text := 'PILIH';
  cbInvStatus.ItemIndex := -1;
  cbInvStatus.Text := 'PILIH';

  //Clear item detail:
  ClearInputDetail;
end;

procedure TfManageInvoice_edit.ClearInputDetail;
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

  ebItemID.Enabled:=True;
  ebItemName.Enabled:=True;
  ebItemUom.Enabled:=True;
  ebItemPrice.Enabled:=True;
end;

procedure TfManageInvoice_edit.DisplayGrid1;
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

procedure TfManageInvoice_edit.DBGrid1DblClick(Sender: TObject);
begin
  if not DBGrid1.DataSource.DataSet.Fields.FieldByName('ID').IsNull then
  begin
    ebItemID.Text:=DBGrid1.DataSource.DataSet.Fields.FieldByName('ID').AsString;
    ebItemName.Text:=DBGrid1.DataSource.DataSet.Fields.FieldByName('NAMA PRODUK').AsString;
    ebItemUom.Text:=DBGrid1.DataSource.DataSet.Fields.FieldByName('UOM').AsString;
    ebItemPrice.Text:=DBGrid1.DataSource.DataSet.Fields.FieldByName('PRICE').AsString;
    ebItemPpn.Text:=DBGrid1.DataSource.DataSet.Fields.FieldByName('PPN').AsString;
    ebItemQty.Text:=DBGrid1.DataSource.DataSet.Fields.FieldByName('QTY').AsString;
    ebItemTotal.Text:=DBGrid1.DataSource.DataSet.Fields.FieldByName('TOTAL').AsString;

    ebItemID.Enabled:=False;
    ebItemName.Enabled:=False;
    ebItemUom.Enabled:=False;
    ebItemPrice.Enabled:=False;

    if StrToFloat(ebItemPpn.Text) <> 0 then
    cbItemPpn.Text := 'PPN'
    else
    cbItemPpn.Text := 'NON PPN';
  end;
end;

procedure TfManageInvoice_edit.FormCreate(Sender: TObject);
begin
  ConnectionDB;

  ClearInput;
  ClearInputDetail;

  // SALES HDR IN FIELD
  dbTrans.Commit;
  dbQuery.SQL.Text:='SELECT * FROM INVOICE_HDR WHERE INV_HDR_NO = :VIHDRNO';
  dbQuery.Params.ParamByName('VIHDRNO').AsString:=gvInvNo;
  dbQuery.Open;

  If NOT dbQuery.EOF then
  begin
    ebInvNo.Text:=dbQuery.Fields.FieldByName('INV_HDR_NO').AsString;
    ebInvDate.Text:=FormatDateTime('DD/MM/YYYY', dbQuery.Fields.FieldByName('INV_HDR_DT').AsDateTime);
    cbInvType.Text:=dbQuery.Fields.FieldByName('INV_HDR_TYPE').AsString;
    ebCustID.Text:=dbQuery.Fields.FieldByName('INV_HDR_CUST_ID').AsString;
    ebCustName.Text:=dbQuery.Fields.FieldByName('INV_HDR_CUST_NAME').AsString;
    emCustAddress.Text:=dbQuery.Fields.FieldByName('INV_HDR_CUST_ADDR').AsString;
    ebCustCity.Text:=dbQuery.Fields.FieldByName('INV_HDR_CUST_CITY').AsString;
    ebCustProvince.Text:=dbQuery.Fields.FieldByName('INV_HDR_CUST_PROVINCE').AsString;
    cbInvStatus.Text:=dbQuery.Fields.FieldByName('INV_HDR_STATUS').AsString;

    // INVOICE DTL IN DBGRID
    dbTrans1.Commit;
    dbQuery1.SQL.Text := 'SELECT INV_DTL_NO "NO", INV_DTL_PROD_ID "ID", ' +
                     'INV_DTL_PROD_NAME "NAMA PRODUK", INV_DTL_PROD_UOM "UOM", ' +
                     'INV_DTL_QTY "QTY", INV_DTL_PRICE "PRICE", INV_DTL_TOTAL "TOTAL", ' +
                     'INV_DTL_DPP "DPP", INV_DTL_PPN "PPN"' +
                     'FROM INVOICE_DTL WHERE INV_DTL_NO = :vNO';
    dbQuery1.Params.ParamByName('vNO').AsString:=gvInvNo;
    dbQuery1.Open;
    DisplayGrid1;
  end;

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

end.


unit UmodalCustomers;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs, DBGrids,
  Buttons, StdCtrls;

type

  { TfModalCustomers }

  TfModalCustomers = class(TForm)
    btnSelect: TBitBtn;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    procedure btnSelectClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure SelectItems;
  private
    { private declarations }
  public
    { public declarations }
    SelectedCustomerID: string;
  end;

var
  fModalCustomers: TfModalCustomers;

implementation
uses
  UmanageInvoice_add;

{$R *.lfm}

{ TfModalCustomers }

procedure TfModalCustomers.btnSelectClick(Sender: TObject);
begin
  SelectItems;
end;

procedure TfModalCustomers.DBGrid1DblClick(Sender: TObject);
begin
  SelectItems;
end;

procedure TfModalCustomers.SelectItems;
begin
  if not DBGrid1.DataSource.DataSet.IsEmpty then
  begin
    // Fetch values from the selected row
    SelectedCustomerID := DBGrid1.DataSource.DataSet.FieldByName('CUST_ID').AsString;

    // Send values to fManageInvoice_add through public methods or properties
    fManageInvoice_add.SetCustomerDetails(
      DBGrid1.DataSource.DataSet.FieldByName('CUST_ID').AsString,
      DBGrid1.DataSource.DataSet.FieldByName('CUST_TYPE').AsString,
      DBGrid1.DataSource.DataSet.FieldByName('CUST_NAME').AsString,
      DBGrid1.DataSource.DataSet.FieldByName('CUST_ADDRESS').AsString,
      DBGrid1.DataSource.DataSet.FieldByName('CUST_CITY').AsString,
      DBGrid1.DataSource.DataSet.FieldByName('CUST_PROVINCE').AsString
    );

    ModalResult := mrOk; // Close the modal form
  end
  else
    ShowMessage('No customer selected!');
end;


end.


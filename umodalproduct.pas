unit UmodalProduct;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs, DBGrids,
  Buttons, StdCtrls;

type

  { TfModalProduct }

  TfModalProduct = class(TForm)
    btnSelect: TBitBtn;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    procedure DBGrid1DblClick(Sender: TObject);
    procedure SelectItems;
    procedure btnSelectClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    SelectedProductID: string;
  end;

var
  fModalProduct: TfModalProduct;

implementation
uses
  UmanageInvoice_add;

{$R *.lfm}

{ TfModalProduct }

procedure TfModalProduct.SelectItems;
begin
  if not DBGrid1.DataSource.DataSet.IsEmpty then
  begin
    // Fetch values from the selected row
    SelectedProductID := DBGrid1.DataSource.DataSet.FieldByName('PROD_ID').AsString;

    // Send values to fManageInvoice_add through public methods or properties
    fManageInvoice_add.SetProductDetails(
      DBGrid1.DataSource.DataSet.FieldByName('PROD_ID').AsString,
      DBGrid1.DataSource.DataSet.FieldByName('PROD_NAME').AsString,
      DBGrid1.DataSource.DataSet.FieldByName('PROD_UOM').AsString
    );

    ModalResult := mrOk; // Close the modal form
  end
  else
    ShowMessage('No customer selected!');
end;

procedure TfModalProduct.DBGrid1DblClick(Sender: TObject);
begin
  SelectItems;
end;

procedure TfModalProduct.btnSelectClick(Sender: TObject);
begin
  SelectItems;
end;

end.


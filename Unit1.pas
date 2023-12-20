unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  System.Rtti, System.Bindings.Outputs, FMX.Bind.Editors, Data.Bind.EngExt,
  FMX.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  FireDAC.Phys.IB, FireDAC.Phys.IBLiteDef, FireDAC.FMXUI.Wait, System.IOUtils,
  FMX.MultiView, FMX.Edit, FMX.Layouts, FMX.ListBox, FMX.SearchBox
{$IFDEF ANDROID}, FMX.DialogService{$ENDIF};

type
  TForm1 = class(TForm)
    ToolBar1: TToolBar;
    add: TButton;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    FDQuery1: TFDQuery;
    FDConnection1: TFDConnection;
    MultiView1: TMultiView;
    Edit1: TEdit;
    addqarzol: TButton;
    ListBox1: TListBox;
    SearchBox1: TSearchBox;
    Label1: TLabel;
    TabItem2: TTabItem;
    ToolBar2: TToolBar;
    FDQuery2: TFDQuery;
    Button1: TButton;
    Button2: TButton;
    StatusBar1: TStatusBar;
    Label2: TLabel;
    ListBox3: TListBox;
    Label3: TLabel;
    Button3: TButton;
    MultiView3: TMultiView;
    Edit2: TEdit;
    Button4: TButton;
    Edit3: TEdit;
    MetropolisUIListBoxItem1: TMetropolisUIListBoxItem;
    procedure FormCreate(Sender: TObject);
    procedure addqarzolClick(Sender: TObject);
    procedure ListBox1ItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Edit3ChangeTracking(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    procedure Data;
    Function Format(number: string): string;
    procedure updatasql(value: int64);
    Function deformat(value: string): string;
  public
    Procedure listqarzlar(str: string);
  end;

var
  Form1: TForm1;
  jami: int64;
  i64: int64;
  form: string;
  itlist: integer;

implementation

{$R *.fmx}

uses Item;

procedure TForm1.addqarzolClick(Sender: TObject);
var
  i: integer;
begin
  if Edit1.Text <> '' then
  begin
    if not(FDQuery1.IsEmpty) then
    begin
      for i := 1 to FDQuery1.RecordCount do
      begin
        FDQuery1.RecNo := i;
        if uppercase(FDQuery1.FieldList[0].AsString) = uppercase(Edit1.Text)
        then
        begin
          ShowMessage(Edit1.Text + ' avval sqalangan.');
          exit;
        end;
      end;
    end;
    FDQuery1.SQL.Text :=
      'INSERT INTO qarzdor (QARZOLGAN, UMUMIY_NARX) VALUES (:Value1, :Value2)';
    FDQuery1.ParamByName('Value1').value := Edit1.Text;
    FDQuery1.ParamByName('Value2').value := 0;
    FDQuery1.ExecSQL;
    FDQuery1.SQL.Text := 'SELECT * FROM qarzdor';
    FDQuery1.Open;
    Data;
    MultiView1.HideMaster;
    Edit1.Text := '';
  end;

end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i: integer;
begin
  for i := 1 to ListBox3.Count do
    FindComponent('items' + inttostr(i)).Free;
  TabControl1.ActiveTab := TabItem1;
  updatasql(i64);
  Data;
end;

procedure TForm1.Button2Click(Sender: TObject);
{$IFDEF MSWINDOWS}
begin
  case MessageDlg(Label3.Text + ' o`chirmoqchimisiz ?',
    TMsgDlgType.mtInformation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) of
    mrYes:
      begin
        if not(FDQuery1.IsEmpty) then
        begin
          FDQuery1.SQL.Text := 'DELETE FROM qarzdor WHERE QARZOLGAN = :ID';
          FDQuery2.SQL.Text := 'DELETE FROM QARZ_O WHERE ISM = :ID';
          FDQuery1.ParamByName('ID').AsString := Label3.Text;
          FDQuery2.ParamByName('ID').AsString := Label3.Text;
          FDQuery1.ExecSQL;
          FDQuery2.ExecSQL;
          FDQuery1.SQL.Text := 'SELECT * FROM qarzdor';
          FDQuery2.SQL.Text := 'SELECT * FROM QARZ_O';
          FDQuery1.Open;
          FDQuery2.Open;
          TabControl1.ActiveTab := TabItem1;
          Data;
        end;
      end;
  end;
end;
{$ELSE}

begin
  TDialogService.MessageDialog(Label3.Text + 'ni o`chirmoqchimisiz ?',
    TMsgDlgType.mtInformation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
    TMsgDlgBtn.mbNo, 0,
    procedure(const AResult: TModalResult)
    begin
      case AResult of
        mrYes:
          begin
            if not(FDQuery1.IsEmpty) then
            begin
              FDQuery1.SQL.Text := 'DELETE FROM qarzdor WHERE QARZOLGAN = :ID';
              FDQuery2.SQL.Text := 'DELETE FROM QARZ_O WHERE ISM = :ID';
              FDQuery1.ParamByName('ID').AsString := Label3.Text;
              FDQuery2.ParamByName('ID').AsString := Label3.Text;
              FDQuery1.ExecSQL;
              FDQuery2.ExecSQL;
              FDQuery1.SQL.Text := 'SELECT * FROM qarzdor';
              FDQuery2.SQL.Text := 'SELECT * FROM QARZ_O';
              FDQuery1.Open;
              FDQuery2.Open;
              TabControl1.ActiveTab := TabItem1;
              Data;
            end;
          end;
        mrNo:
          exit;
      end;
    end);
end;

{$ENDIF}

procedure TForm1.Button3Click(Sender: TObject);
begin
  MultiView3.ShowMaster;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  i: integer;
begin
  if (Edit2.Text = '') and (Edit3.Text = '') then
  begin
    ShowMessage('Maydonlar bo`sh bo`lishi mumkin emas !');
  end
  else
  begin
    if not(FDQuery2.IsEmpty) then
    begin
      for i := 1 to FDQuery2.RecordCount do
      begin
        FDQuery2.RecNo := i;
        if uppercase(FDQuery2.FieldList[1].AsString) = uppercase(Edit2.Text)
        then
        begin
          ShowMessage(Edit2.Text + ' avval sqalangan.');
          exit;
        end;
      end;
    end;
    FDQuery2.SQL.Text :=
      'INSERT INTO QARZ_O (ISM, NIMA, O_SUMMA, VAQTI, SANASI) VALUES (:Value1, :Value2, :Value3, :Value4, :Value5)';
    FDQuery2.ParamByName('Value1').value := Label3.Text;
    FDQuery2.ParamByName('Value2').value := Edit2.Text;
    FDQuery2.ParamByName('Value3').value := deformat(Edit3.Text);
    FDQuery2.ParamByName('Value4').value := Time;
    FDQuery2.ParamByName('Value5').value := Date;
    FDQuery2.ExecSQL;
    FDQuery2.SQL.Text := 'SELECT * FROM QARZ_O';
    FDQuery2.Open;
    Data;
    MultiView3.HideMaster;
    Edit2.Text := '';
    Edit3.Text := '';
    listqarzlar(Label3.Text);
  end;
end;

procedure TForm1.Data;
var
  int: integer;
  i: integer;
begin
  ListBox1.Clear;
  jami := 0;
  if not(FDQuery1.IsEmpty) then
  begin
    FDQuery1.Last;
    int := FDQuery1.RecordCount;
    for i := 1 to int do
    begin
      FDQuery1.RecNo := i;
      ListBox1.Items.add(FDQuery1.FieldList[0].AsString);
      ListBox1.ItemByIndex(ListBox1.Count - 1).ItemData.Accessory :=
        TListBoxItemData.TAccessory.aMore;
      ListBox1.ItemByIndex(ListBox1.Count - 1).StyleLookup :=
        'listboxitemrightdetail';
      ListBox1.ItemByIndex(ListBox1.Count - 1).ItemData.Detail :=
        Format(FDQuery1.FieldList[1].AsString) + ' so`m';
      jami := jami + StrToInt64(FDQuery1.FieldList[1].AsString)
    end;
  end;
  Label1.Text := 'Jami qarz ' + Format(inttostr(jami)) + ' so`m';
end;

function TForm1.deformat(value: string): string;
var
  i: integer;
begin
  Result := '';
  for i := 1 to length(value) do
  begin
    if value[i] <> ' ' then
      Result := Result + value[i]
  end;
end;

procedure TForm1.Edit3ChangeTracking(Sender: TObject);
begin
  Edit3.Text := Format(deformat(Edit3.Text));
end;

function TForm1.Format(number: string): string;
var
  asos, j: string;
  i, l: integer;
begin
  l := -1;
  for i := length(number) downto 1 do
  begin
    l := l + 1;
    if l = 3 then
    begin
      asos := asos + ' ';
      l := 0;
    end;
    asos := asos + number[i];
  end;
  for i := length(asos) downto 1 do
    j := j + asos[i];
  Result := j;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  TabControl1.ActiveTab := TabItem1;
{$IFDEF ANDROID}
  FDConnection1.Params.Database := Tpath.Combine(Tpath.GetDocumentsPath,
    'DATA.IB');
  FDConnection1.Connected := True;
{$ENDIF}
  FDQuery1.Open;
  FDQuery2.Open;
  Data;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
Shift: TShiftState);
var
  i: integer;
begin
  if (TabControl1.ActiveTab = TabItem2) and (Key = vkHardwareBack) then
  begin
    Key := 0;
    TabControl1.ActiveTab := TabItem1;
    for i := 1 to ListBox3.Count do
      FindComponent('items' + inttostr(i)).Free;
    TabControl1.ActiveTab := TabItem1;
    updatasql(i64);
    Data;
  end;
end;

procedure TForm1.ListBox1ItemClick(const Sender: TCustomListBox;
const Item: TListBoxItem);
begin
  Label3.Text := Item.Text;
  listqarzlar(Item.Text);
  TabControl1.ActiveTab := TabItem2;
  itlist := -1;
end;

procedure TForm1.listqarzlar(str: string);
var
  i, j: integer;
  itemss: TListBoxItem;
begin
  ListBox3.Clear;
  i64 := 0;
  j := 0;
  if not(FDQuery2.IsEmpty) then
  begin
    FDQuery2.First;
    for i := 1 to FDQuery2.RecordCount do
    begin
      FDQuery2.RecNo := i;
      if FDQuery2.FieldList[0].AsString = str then
      begin
        j := j + 1;
        SetLength(it, j + 1);
        it[j] := TFrame2.Create(Application);
        itemss := TListBoxItem.Create(Application);
        it[j].name := 'items' + inttostr(i);
        it[j].Text.Text := FDQuery2.FieldList[1].AsString;
        it[j].detil.Text := Format(FDQuery2.FieldList[2].AsString) + ' so`m';
        it[j].Time := FDQuery2.FieldList[3].AsString;
        it[j].Date := FDQuery2.FieldList[4].AsString;
        i64 := i64 + StrToInt64(FDQuery2.FieldList[2].AsString);
        it[j].Parent := itemss;
        ListBox3.AddObject(itemss)
      end;
    end;
  end;
  Label2.Text := 'Jami qarz ' + Format(inttostr(i64)) + ' so`m'
end;

procedure TForm1.updatasql(value: int64);
var
  i: integer;
begin
  if not(FDQuery1.IsEmpty) then
  begin
    for i := 1 to FDQuery1.RecordCount do
    begin
      FDQuery1.RecNo := i;
      if uppercase(Label3.Text) = uppercase(FDQuery1.FieldList[0].AsString) then
      begin
        FDQuery1.Edit;
        FDQuery1.FieldList[1].value := value;
        break;
      end;
    end;
  end;
end;

end.

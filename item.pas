unit item;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ListBox {$IFDEF ANDROID},
  FMX.DialogService{$ENDIF};

type
  TFrame2 = class(TFrame)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    text: TLabel;
    detil: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    procedure clear;
  public
    date, time: string;
  end;

var
  it: array of TFrame2;

implementation

{$R *.fmx}

uses Unit1;

procedure TFrame2.Button1Click(Sender: TObject);
var
  metul: TMetropolisUIListBoxItem;
  i: integer;
begin // arrowdowntoolbutton        //arrowuptoolbutton
  if Button1.StyleLookup = 'arrowuptoolbutton' then
  begin
    clear;
  end
  else if Button1.StyleLookup = 'arrowdowntoolbutton' then
  begin
    clear;
    Button1.StyleLookup := 'arrowuptoolbutton';
  end;
  for i := 1 to High(it) do
    if it[i].Button1.StyleLookup = 'arrowuptoolbutton' then
    begin
      metul := TMetropolisUIListBoxItem.Create(Application);
      if itlist <> -1 then
        Form1.ListBox3.Items.Delete(itlist);
      metul.Title := text.text;
      metul.SubTitle := 'Qarz :' + detil.text;
      metul.Description := 'Sana: ' + date + ' ' + 'Vaqt: ' + time;
      Form1.ListBox3.InsertObject(i, metul);
      itlist := i;
      Break;
    end
    else
    begin
      if itlist <> -1 then
      begin
        Form1.ListBox3.Items.Delete(itlist);
        itlist := -1
      end;
    end;
end;

procedure TFrame2.Button2Click(Sender: TObject);
{$IFDEF MSWINDOWS}
begin
  case MessageDlg(text.text + 'ni o`chirmoqchimisiz ?',
    TMsgDlgType.mtInformation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) of
    mrYes:
      begin
        if not(Form1.FDQuery2.IsEmpty) then
        begin
          Form1.FDQuery2.SQL.text := 'DELETE FROM QARZ_O WHERE NIMA = :ID';
          Form1.FDQuery2.ParamByName('ID').AsString := text.text;
          Form1.FDQuery2.ExecSQL;
          Form1.FDQuery2.SQL.text := 'SELECT * FROM QARZ_O';
          Form1.FDQuery2.Open;
          Form1.listqarzlar(Form1.Label3.text);
        end;
      end;
  end;
end;
{$ELSE}

begin
  TDialogService.MessageDialog(text.text + 'ni o`chirmoqchimisiz ?',
    TMsgDlgType.mtInformation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
    TMsgDlgBtn.mbNo, 0,
    procedure(const AResult: TModalResult)
    begin
      case AResult of
        mrYes:
          begin
            if not(Form1.FDQuery2.IsEmpty) then
            begin
              Form1.FDQuery2.SQL.text := 'DELETE FROM QARZ_O WHERE NIMA = :ID';
              Form1.FDQuery2.ParamByName('ID').AsString := text.text;
              Form1.FDQuery2.ExecSQL;
              Form1.FDQuery2.SQL.text := 'SELECT * FROM QARZ_O';
              Form1.FDQuery2.Open;
              Form1.listqarzlar(Form1.Label3.text);
            end;
          end;
        mrNo:
          exit;
      end;
    end);
end;
{$ENDIF}

procedure TFrame2.clear;
var
  i: integer;
begin
  for i := 1 to High(it) do
    it[i].Button1.StyleLookup := 'arrowdowntoolbutton';
end;

end.

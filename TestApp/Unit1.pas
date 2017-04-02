unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, System.Messaging,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, Androidapi.Helpers, FMX.Helpers.Android, CustomActivityEvent,
  Androidapi.JNI.JavaTypes, Androidapi.JNIBridge, Androidapi.JNI.Os, Androidapi.JNI.GraphicsContentViewText,
  FMX.ScrollBox, FMX.Memo;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure onReceivePermissionsResult(const ASender: TObject; const AMessage: TMessage);
  public
    { Public declarations }
  end;

const
  PERMISSION_REQUEST_CODE: Integer = 123;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
begin
  if (TJBuild_VERSION.JavaClass.SDK_INT >= 23) then
  begin
    if (TAndroidHelper.context.checkSelfPermission(StringToJString('android.permission.ACCESS_COARSE_LOCATION'))
      = TJPackageManager.JavaClass.PERMISSION_DENIED) then
    begin
      TAndroidHelper.Activity.requestPermissions(CreateJavaStringArray(['android.permission.ACCESS_COARSE_LOCATION']),
        PERMISSION_REQUEST_CODE);
    end
    else
    begin
      Memo1.Lines.Clear;
      Memo1.Lines.Add('Права уже выданы!');
    end;
  end;
end;

procedure TForm1.onReceivePermissionsResult(const ASender: TObject; const AMessage: TMessage);
var
  RequestCode: Integer;
  Permissions: TJavaObjectArray<JString>;
  GrantResults: TJavaArray<Integer>;
  I: Integer;
  J: Integer;
begin
  Label1.Text := '1';

  if (AMessage <> nil) and (AMessage is TMessageResultPermissions) then
  begin
    RequestCode := TMessageResultPermissions(AMessage).Value;
    Permissions := TMessageResultPermissions(AMessage).Permissions;
    GrantResults := TMessageResultPermissions(AMessage).GrantResults;

    Label1.Text := 'RequestCode: ' + RequestCode.ToString;

    Memo1.Lines.Add('Permissions:');
    for I := 0 to Permissions.Length - 1 do
      Memo1.Lines.Add(JStringToString(Permissions.Items[I]));

    Memo1.Lines.Add('GrantResults:');
    for J := 0 to GrantResults.Length - 1 do
      if GrantResults.Items[0] = TJPackageManager.JavaClass.PERMISSION_DENIED then
        Memo1.Lines.Add('False')
      else
        Memo1.Lines.Add('True');
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  TMessageManager.DefaultManager.SubscribeToMessage(TMessageResultPermissions, onReceivePermissionsResult);
end;

end.

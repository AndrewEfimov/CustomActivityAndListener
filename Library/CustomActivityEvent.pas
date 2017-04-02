{ *********************************************************************
  *
  * Autor: Efimov A.A.
  * E-mail: infocean@gmail.com
  * GitHub: https://github.com/AndrewEfimov
  * Requirements: -
  * Platform: Android
  * IDE: Delphi 10.1 Berlin +
  *
  ******************************************************************** }
unit CustomActivityEvent;

interface

uses
  Androidapi.JNIBridge, Androidapi.JNI.JavaTypes, Androidapi.JNI.GraphicsContentViewText,
  System.Classes, System.Messaging, FMX.Platform.Android, Androidapi.Helpers,
  Androidapi.NativeActivity, Androidapi.JNI.App;

type

  JOnCustomListener = interface;
  JCustomActivity = interface;

  JCustomActivityClass = interface(JNativeActivityClass)
    ['{1BD49767-574A-44E6-A2A4-563A291F5A2E}']
  end;

  [JavaSignature('com/embarcadero/firemonkey/CustomActivity')]
  JCustomActivity = interface(JNativeActivity)
    ['{69190A79-B3EB-46D5-964C-D37FA7D30A13}']
    procedure setCustomListener(listener: JOnCustomListener); cdecl;
  end;
  TCustomActivity = class(TJavaGenericImport<JCustomActivityClass, JCustomActivity>) end;

  JOnActivityListenerClass = interface(IJavaClass)
    ['{1FDB05BF-5F1E-48F3-8C6B-61AA730D0EAB}']
  end;

  [JavaSignature('com/embarcadero/firemonkey/OnCustomListener')]
  JOnCustomListener = interface(IJavaInstance)
    ['{2C70C66B-89CB-4199-ACA7-015E06850D75}']
    procedure onReceivePermissionsResult(requestCode: Integer; permissions: TJavaObjectArray<JString>; grantResults: TJavaArray<Integer>); cdecl;
  end;
  TJOnActivityListener = class(TJavaGenericImport<JOnActivityListenerClass, JOnCustomListener>) end;

  TCustomListener = class (TJavaLocal, JOnCustomListener)
  public
    procedure onReceivePermissionsResult(ARequestCode: Integer; APermissions: TJavaObjectArray<JString>; AGrantResults: TJavaArray<Integer>); cdecl;
  end;

  TMessageResultPermissions = class(TMessage<Integer>)
  public
    //RequestCode: Integer;
    Permissions: TJavaObjectArray<JString>;
    GrantResults: TJavaArray<Integer>
  end;

implementation

{ TCustomListener }

procedure TCustomListener.onReceivePermissionsResult(
  ARequestCode: Integer; APermissions: TJavaObjectArray<JString>;
  AGrantResults: TJavaArray<Integer>);
var
  Msg: TMessageResultPermissions;
begin
  Msg := TMessageResultPermissions.Create(ARequestCode);
  Msg.Permissions := APermissions;
  Msg.GrantResults := AGrantResults;
  TMessageManager.DefaultManager.SendMessage(nil, Msg);
end;

var
  FActivityListener: TCustomListener ;

initialization
  FActivityListener := TCustomListener.Create;
  TCustomActivity.Wrap(PANativeActivity(System.DelphiActivity)^.clazz).setCustomListener(FActivityListener);

finalization
  FActivityListener.Free;

end.

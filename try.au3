#include <Constants.au3>

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

$Var032F = "A0P52MA78LS9O7EN1UI89A7B9NP6254FU1E3NA2S154HQ987"
MsgBox($MB_SYSTEMMODAL, "decode", Fn00A8(0, "408178571CB7BBE0DC1D7B2D0C42B9AEF2F90AEEB154D0C5BCB810754193958D1C9234AC0EB673C35FCEFCF5EC31261C8620D05C1ED50CC881A5F1D67A7E1A9DE650DA209AF6EF57624A6F9A95749C554A8E1CF9DA73D1F96262E7B3C1D9B0EEC73E35463F9FD714317F48D7134E31AFBED7B1DC974FDD160BCA2B4D", $Var032F, 2))

MsgBox($MB_SYSTEMMODAL, "decode", Fn00A8(0, "408178571CB7BBE0DC1D7B2D0C42B9AEF2F90AEEB154D0C5BCB81075419395F01C924ADC0EB60FB75FCAFBF1EC30271C8620D05C1ED40BCD86D78DA37A791A9AE124A6239AF6EF24624E6E9D95749C554A8E1CF9DA73D1F96262E7B3C1D9B0EEC73D35343F9FD714317F48D7134E31AFBED7B1DC974FDD160BCA2B4D", $Var032F, 2))

MsgBox($MB_SYSTEMMODAL, "decode", Fn00A8(0, "408178571CB7BBE0DC1D7B2D0C42B9AEF2F90AEEB154D0C5BCB81075419395F01C914AD60EB673C15FCBFBF3EC34271B8624D15A1ED50CCE86D48DD77A7A1A99E657A6519AF6EF25624E6F9A95749C544AF41CF9DA73D1FA6263E0C3C1D9B0EFC73D35463F9CD017317C48D3", $Var032F, 2))

MsgBox($MB_SYSTEMMODAL, "decode", Fn00A8(0, "408178571CB7BBE0DC1D7B2D0C42B9AEF2F90AEEB154D0C5BCB81075419290F51C914ADC0EB60FC35FCAFCF2EC30271C8620D1591ED40CC886D78DD47A7D649CE123DA239AF6EF5962496E9A92049C564A8E1C8BDA72AF8F1E10E0C2C1DDB799C73E35333F9FD711", $Var032F, 2))

MsgBox($MB_SYSTEMMODAL, "decode", Fn00A8(0, "408178571CB7BBE0DC1D7B2D0C42B9AEF2F90AEEB154D0C5BCB81075419295F262E634A80EB573C55FCBFCF3EC30271C8620D0591ED50BCA86D7F1D17A7D649CE123DA259AF1EA2662496E9A92039C524A8E1C8BDA72AF8F1E10E0C2C1DDB799C73E35333F9FD711", $Var032F, 2))

MsgBox($MB_SYSTEMMODAL, "decode", Fn00A8(0, "408178571CB7BBE0DC1D7B2D0C42B9AEF2F90AEEB154D0C5BCB810754192908C1C914AAB0EB60FB75FCEFCF5EC31276E8627D1291ED70CC881A58DD67A7B1A9EE121A6259D81EA58624A6F9A95749C554AF31CF9DA08D1F91E6BE7B3C1D9B0EEC73E32473F9FD714317F48D7134E31AFBED7B1DC974FDD160BCA2B4D", $Var032F, 2))

MsgBox($MB_SYSTEMMODAL, "decode", Fn00A8(0, "408178571CB7BBE0DC1D7B2D0C42B9AEF2F90AEEB154D0C5BCB81075419290F71C9134D70EB60FB75FCBFCF2EC30271C8620D15B1ED40BCA86D48DD67A79649DE123DA249AF6EA5862496E9B92049D574AF41DF9DA0ED1F96262E0C5C1DDB0EFC73E35473AEBD714317C48D4133230ACBED7B1DB", $Var032F, 2))

MsgBox($MB_SYSTEMMODAL, "decode", Fn00A8(0, "408178571CB7BBE0DC1D7B2D0C42B9AEF2F90AEEB154D0C5BCB810754193958D1C9234AC0EB673C35FCEFCF5EC31261C8620D05C1ED50CC881A5F1D67A7E1A9DE650DA209AF6EF57624A6F9A95749C554A8E1CF9DA73D1F96262E7B3C1D9B0EFC73D32443F9FD714317848D5133231ABBED7B1DA974FD8100BCE2C3E502C8EC3FAE8D5B7E327E509", $Var032F, 2))
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"


********************************************************************
* Autor			: EV Solution System
* Descrição		: Conciliação Bancária
* Data			: 01/11/2015
********************************************************************
User Function VFFINA03()

Local oDlgMain     := Nil
Local oListBox     := Nil
Local oCheck       := Nil
Local aCoordenadas := MsAdvSize(.T.)
Local nOpcClick    := 0
Local cDesOrigem   := ""
Local cDesDestino  := ""
Local lEdicao      := .T.
Local lMarcaDesm   := .F.
Local aExtrato     := {}
Local aMovim       := {}

Private cPerg      := ""
Private cTotExt    := ""
Private cTotMov    := ""
Private cSaldoAt   := ""
Private cSaldoAnt  := ""
Private cSaldoC    := ""
Private cDifer     := ""

Private oGet1 		:= Nil
Private oGet2 		:= Nil
Private oGet3 		:= Nil

Private dMvPar01   := ""
Private dMvPar02   := ""
Private cMvPar03   := ""
Private cMvPar04   := ""
Private cMvPar05   := ""
Private nMvPar06   := ""

cPerg := "EVFINA03"

ValidPerg(cPerg)
If !Pergunte(cPerg,.T.)
	Return
Endif

dMvPar01 := MV_PAR01
dMvPar02 := MV_PAR02
cMvPar03 := MV_PAR03
cMvPar04 := MV_PAR04
cMvPar05 := MV_PAR05
nMvPar06 := MV_PAR06

//Desenha a Tela
oDlgMain := TDialog():New(aCoordenadas[7],000,aCoordenadas[6],aCoordenadas[5],OemToAnsi("Conciliação Bancária"),,,,,,,,oMainWnd,.T.)

	TGroup():New(014,003,150,315,"Dados do Extrato",oDlgMain,,,.T.)
		aExtrato := {{.F.,"","","","",0,""}}

		oListBox  := TWBrowse():New(024,008,300,120,,{" ","Dt. Balancete","Lote","Documento","Historico","Valor","Recno"},,oDlgMain,,,,,,,,,,,,.F.,,.T.,,.F.,,,)

		UpDtList(@aExtrato, @oListBox, 1)
		/*
		oListBox:SetArray(aExtrato)
		oListBox:bLine := {||{ 		IIf(aExtrato[oListBox:nAt][1],LoadBitmap( GetResources(), "CHECKED" ),LoadBitmap( GetResources(), "UNCHECKED" )),;
										aExtrato[oListBox:nAt][2],;
										aExtrato[oListBox:nAt][3],;
										aExtrato[oListBox:nAt][4],;
										aExtrato[oListBox:nAt][5],;
										aExtrato[oListBox:nAt][6],;
										aExtrato[oListBox:nAt][7] }}
										*/
		oListBox:bLDblClick := {|| aExtrato[oListBox:nAt,1] := !aExtrato[oListBox:nAt,1], EVFINA3C(@aExtrato,@oListBox),oListBox:Refresh()}

		Processa(EVFINA3A(@aExtrato,@oListBox))

		TSay():New(155,008,{||"Total Marcado Extrato: "},oDlgMain,,,.F.,.F.,.F.,.T.,CLR_HBLUE,,100,009)
		@ 165,008 MsGet oGet1 VAR cTotExt Of oDlgMain PIXEL SIZE 080,010 When .F.

		TSay():New(200,008,{||"Saldo Inicial: "},oDlgMain,,,.F.,.F.,.F.,.T.,CLR_HBLUE,,100,009)
		@ 210,008 MsGet cSaldoAnt Of oDlgMain PIXEL SIZE 080,010 When .F.

		TSay():New(200,088,{||"Saldo Final: "},oDlgMain,,,.F.,.F.,.F.,.T.,CLR_HBLUE,,100,009)
		@ 210,088 MsGet cSaldoAt Of oDlgMain PIXEL SIZE 080,010 When .F.

	TGroup():New(014,320,150,630,"Dados da Movimentação",oDlgMain,,,.T.)
		aMovim := {{.F.,"","","",0}}

		oListBox1 := TWBrowse():New(024,326,300,120,,{" ","Dt. Movimento","Historico","D/C","Valor"},,oDlgMain,,,,,,,,,,,,.F.,,.T.,,.F.,,,)

		UpDtList(@aMovim, @oListBox1, 2)
		/*
		oListBox1:SetArray(aMovim)
		oListBox1:bLine := {||{ 	IIf(aMovim[oListBox1:nAt][1],LoadBitmap( GetResources(), "CHECKED" ),LoadBitmap( GetResources(), "UNCHECKED" )),;
										aMovim[oListBox1:nAt][2],;
										aMovim[oListBox1:nAt][3],;
										aMovim[oListBox1:nAt][4],;
							  			aMovim[oListBox1:nAt][5] }}
*/
		oListBox1:bLDblClick := {|| aMovim[oListBox1:nAt,1] := !aMovim[oListBox1:nAt,1], EVFINA3D(@aMovim,@oListBox1), oListBox1:Refresh() }

		Processa(EVFINA3B(@aMovim,@oListBox1))

		TSay():New(155,320,{||"Total Marcado Movimento: "},oDlgMain,,,.F.,.F.,.F.,.T.,CLR_HBLUE,,100,009)
		@ 165,320 MsGet oGet2 VAR cTotMov Of oDlgMain PIXEL SIZE 080,010 When .F.

		TSay():New(200,320,{||"Saldo Conciliado: "},oDlgMain,,,.F.,.F.,.F.,.T.,CLR_HBLUE,,100,009)
		@ 210,320 MsGet oGet3 VAR cSaldoC Of oDlgMain PIXEL SIZE 080,010 When .F.

	TButton():New(250,008,"Fechar",			oDlgMain,{|| oDlgMain:End() },045,011,,,,.T.,,"",,,,.F. )
	TButton():New(250,058,"Conciliar",		oDlgMain,{|| EVFINA3E(@aMovim,@oListBox1,@aExtrato,@oListBox) },045,011,,,,.T.,,"",,,,.F. )
	TButton():New(250,108,"Desfaz Conc.",	oDlgMain,{|| EVFINA3F(@aMovim,@oListBox1) },045,011,,,,.T.,,"",,,,.F. )
	TButton():New(250,158,"Exclui Extrato", oDlgMain,{|| EVFINA3G(@aExtrato,@oListBox) },045,011,,,,.T.,,"",,,,.F. )
	TButton():New(250,208,"Conc. Movimento",oDlgMain,{|| EVFINA3H(@aMovim,@oListBox1) },045,011,,,,.T.,,"",,,,.F. )

oDlgMain:Activate(,,,.T.)

Return(Nil)




********************************************************************
* Autor			: EV Solution System
* Descrição		: Criação de Pergunta
* Data			: 01/11/2015
********************************************************************
Static Function EVFINA3A(aExtrato,oListBox,oGet1,oGet2,oGet3)

Local nSaldoC := 0
Local cQuery  := ""

aExtrato := {}

cQuery := " SELECT *,R_E_C_N_O_ AS RECZZN FROM "+RetSqlName("ZZN")
cQuery += " WHERE D_E_L_E_T_ = '' "
cQuery += " AND ZZN_BANCO = '"+cMvPar03+"' "
cQuery += " AND ZZN_AGENCI = '"+cMvPar04+"' "
cQuery += " AND ZZN_CONTA = '"+cMvPar05+"' "
cQuery += " AND ZZN_DTBALA BETWEEN '"+DtoS(dMvPar01)+"' AND '"+DtoS(dMvPar02)+"' "
If nMvPar06 == 1 //NAO CONCILIADOS
	cQuery += " AND ZZN_CONCIL = '' "
ElseIf nMvPar06 == 2 //CONCILIADOS
	cQuery += " AND ZZN_CONCIL = 'X' "
EndIf

TcQuery cQuery New Alias "TMP"
TcSetField("TMP","ZZN_DTBALA","D")
TcSetField("TMP","ZZN_VALOR","N",12,2)

DbSelectArea("TMP")
DbGoTop()

While !Eof()

	AAdd(aExtrato,{.F., DtoC(TMP->ZZN_DTBALA), AllTrim(TMP->ZZN_LOTE), AllTrim(TMP->ZZN_DOCTO), AllTrim(TMP->ZZN_HISTOR), TMP->ZZN_VALOR, TMP->RECZZN })

	DbSelectArea("TMP")
	DbSkip()

End

DbSelectArea("TMP")
DbCloseArea()

aExtrato := aSort(aExtrato,,, { |x, y| x[2] < y[2] })

If Len(aExtrato) = 0
	aExtrato := {{.F.,"","","","",0,""}}
EndIf

UpDtList(@aExtrato, @oListBox, 1)
/*
oListBox:SetArray(aExtrato)
oListBox:bLine := {||{ 		IIf(aExtrato[oListBox:nAt][1],LoadBitmap( GetResources(), "CHECKED" ),LoadBitmap( GetResources(), "UNCHECKED" )),;
								aExtrato[oListBox:nAt][2],;
								aExtrato[oListBox:nAt][3],;
								aExtrato[oListBox:nAt][4],;
								aExtrato[oListBox:nAt][5],;
								aExtrato[oListBox:nAt][6],;
								aExtrato[oListBox:nAt][7]}}
oListBox:Refresh()
*/
//ATUALIZA DADOS DO EXTRATO
DbSelectArea("SE8")
DbSetOrder(1)
DbSeek(xFilial("SE8") + cMvPar03 + cMvPar04 + cMvPar05 + DTOS(dMvPar01) )

cSaldoAnt  := AllTrim(Str(Round(SE8->E8_SALANT,2)))

DbSelectArea("SE8")
DbSetOrder(1)
DbSeek(xFilial("SE8") + cMvPar03 + cMvPar04 + cMvPar05 + DTOS(dMvPar02) )

cSaldoAt   := AllTrim(Str(Round(SE8->E8_SALATUA,2)))

cQuery := " SELECT ROUND(SUM(E5_VALOR),2) AS E5_VALOR, E5_HISTOR, E5_RECPAG  FROM "+RetSqlName("SE5")
cQuery += " WHERE D_E_L_E_T_ = '' "
cQuery += " AND E5_RECPAG = 'R' AND E5_TIPODOC NOT IN ('TR','JR', 'MT') "
cQuery += " AND E5_DTDISPO BETWEEN '"+DtoS(dMvPar01)+"' AND '"+DtoS(dMvPar02)+"' "
cQuery += " AND E5_BANCO = '"+cMvPar03+"' "
cQuery += " AND E5_CONTA = '"+cMvPar05+"' "
cQuery += " AND E5_RECONC = 'X' "
cQuery += " GROUP BY E5_HISTOR, E5_RECPAG "

cQuery += " UNION "

cQuery += " SELECT ROUND(SUM(E5_VALOR),2) AS E5_VALOR, E5_HISTOR, E5_RECPAG  FROM "+RetSqlName("SE5")
cQuery += " WHERE D_E_L_E_T_ = '' "
cQuery += " AND E5_RECPAG = 'R' AND E5_TIPODOC = 'TR' "
cQuery += " AND E5_DTDISPO BETWEEN '"+DtoS(dMvPar01)+"' AND '"+DtoS(dMvPar02)+"' "
cQuery += " AND E5_BANCO = '"+cMvPar03+"' "
cQuery += " AND E5_CONTA = '"+cMvPar05+"' "
cQuery += " AND E5_RECONC = 'X' "
cQuery += " GROUP BY E5_HISTOR, E5_RECPAG "

cQuery += " UNION "

cQuery += " SELECT ROUND(SUM(E5_VALOR),2) AS E5_VALOR, E5_HISTOR, E5_RECPAG  FROM "+RetSqlName("SE5")
cQuery += " WHERE D_E_L_E_T_ = '' "
cQuery += " AND E5_RECPAG = 'P' "
cQuery += " AND E5_DTDISPO BETWEEN '"+DtoS(dMvPar01)+"' AND '"+DtoS(dMvPar02)+"' "
cQuery += " AND E5_BANCO = '"+cMvPar03+"' "
cQuery += " AND E5_CONTA = '"+cMvPar05+"' "
cQuery += " AND E5_RECONC = 'X' "
cQuery += " GROUP BY E5_HISTOR, E5_RECPAG "
TcQuery cQuery New Alias "TMP"

DbSelectArea("TMP")
DbGoTop()

While !Eof()

	If TMP->E5_RECPAG == "R"
		nSaldoC += TMP->E5_VALOR
	Else
		nSaldoC -= TMP->E5_VALOR
	EndIf

	DbSelectArea("TMP")
	DbSkip()

End

DbSelectArea("TMP")
DbCloseArea()

cSaldoC := AllTrim(Str(Round(SE8->E8_SALANT+nSaldoC,2)))

Return





********************************************************************
* Autor			: EV Solution System
* Descrição		: Monta Lista da Conciliação
* Data			: 01/11/2015
********************************************************************
Static Function EVFINA3B(aMovim,oListBox1)

Local cQuery := ""
aMovim := {}

cQuery := " SELECT ROUND(SUM(E5_VALOR),2) AS E5_VALOR, E5_DTDISPO, E5_HISTOR, E5_RECPAG  FROM "+RetSqlName("SE5")
cQuery += " WHERE D_E_L_E_T_ = '' "
cQuery += " AND E5_RECPAG = 'R' AND E5_TIPODOC NOT IN ('TR','JR', 'MT') "
cQuery += " AND E5_DTDISPO BETWEEN '"+DtoS(dMvPar01)+"' AND '"+DtoS(dMvPar02)+"' "
cQuery += " AND E5_BANCO = '"+cMvPar03+"' "
cQuery += " AND E5_CONTA = '"+cMvPar05+"' "

If nMvPar06 == 1 //NAO CONCILIADOS
	cQuery += " AND E5_RECONC = '' "
ElseIf nMvPar06 == 2 //CONCILIADOS
	cQuery += " AND E5_RECONC = 'X' "
EndIf
cQuery += " GROUP BY E5_DTDISPO, E5_HISTOR, E5_RECPAG "

cQuery += " UNION "

cQuery += " SELECT ROUND(SUM(E5_VALOR),2) AS E5_VALOR, E5_DTDISPO, E5_HISTOR, E5_RECPAG  FROM "+RetSqlName("SE5")
cQuery += " WHERE D_E_L_E_T_ = '' "
cQuery += " AND E5_RECPAG = 'R' AND E5_TIPODOC = 'TR' "
cQuery += " AND E5_DTDISPO BETWEEN '"+DtoS(dMvPar01)+"' AND '"+DtoS(dMvPar02)+"' "
cQuery += " AND E5_BANCO = '"+cMvPar03+"' "
cQuery += " AND E5_CONTA = '"+cMvPar05+"' "

If nMvPar06 == 1 //NAO CONCILIADOS
	cQuery += " AND E5_RECONC = '' "
ElseIf nMvPar06 == 2 //CONCILIADOS
	cQuery += " AND E5_RECONC = 'X' "
EndIf
cQuery += " GROUP BY E5_DTDISPO, E5_HISTOR, E5_RECPAG "

cQuery += " UNION "

cQuery += " SELECT ROUND(SUM(E5_VALOR),2) AS E5_VALOR, E5_DTDISPO, E5_HISTOR, E5_RECPAG  FROM "+RetSqlName("SE5")
cQuery += " WHERE D_E_L_E_T_ = '' "
cQuery += " AND E5_RECPAG = 'P' "
cQuery += " AND E5_DTDISPO BETWEEN '"+DtoS(dMvPar01)+"' AND '"+DtoS(dMvPar02)+"' "
cQuery += " AND E5_BANCO = '"+cMvPar03+"' "
cQuery += " AND E5_CONTA = '"+cMvPar05+"' "

If nMvPar06 == 1 //NAO CONCILIADOS
	cQuery += " AND E5_RECONC = '' "
ElseIf nMvPar06 == 2 //CONCILIADOS
	cQuery += " AND E5_RECONC = 'X' "
EndIf
cQuery += " GROUP BY E5_DTDISPO, E5_HISTOR, E5_RECPAG "
TcQuery cQuery New Alias "TMP"

DbSelectArea("TMP")
DbGoTop()

While !Eof()

	AAdd(aMovim,{.F., DtoC(StoD(TMP->E5_DTDISPO)), TMP->E5_HISTOR, Iif(AllTrim(TMP->E5_RECPAG) == "P","D","C"), TMP->E5_VALOR })

	DbSelectArea("TMP")
	DbSkip()

End

DbSelectArea("TMP")
DbCloseArea()

aMovim := aSort(aMovim,,, { |x, y| x[2] < y[2] })

If Len(aMovim) = 0
	aMovim := {{.F.,"","","",0}}
EndIf

UpDtList(@aMovim, @oListBox1, 2)

/*
oListBox1:SetArray(aMovim)
oListBox1:bLine := {||{ 	IIf(aMovim[oListBox1:nAt][1],LoadBitmap( GetResources(), "CHECKED" ),LoadBitmap( GetResources(), "UNCHECKED" )),;
								aMovim[oListBox1:nAt][2],;
								aMovim[oListBox1:nAt][3],;
								aMovim[oListBox1:nAt][4],;
								aMovim[oListBox1:nAt][5]}}
oListBox1:Refresh()
*/
Return




********************************************************************
* Autor			: EV Solution System
* Descrição		: Atualiza Gets e Totais
* Data			: 01/11/2015
********************************************************************
Static Function EVFINA3C(aExtrato,oListBox)

Local nSoma := 0

For i := 1 To Len(aExtrato)
	If aExtrato[i,1]
		nSoma += aExtrato[i,6]
	EndIf
Next i

cTotExt := AllTrim(Str(nSoma))

oGet1:Refresh()
oGet2:Refresh()
oGet3:Refresh()

Return(cTotExt)

********************************************************************
* Autor			: EV Solution System
* Descrição		: Atualiza Gets e Totais
* Data			: 01/11/2015
********************************************************************
Static Function EVFINA3D(aMovim,oListBox1)

Local nSoma := 0

For i := 1 To Len(aMovim)
	If aMovim[i,1]
		nSoma += aMovim[i,5]
	EndIf
Next i

cTotMov := AllTrim(Str(nSoma))

oGet1:Refresh()
oGet2:Refresh()
oGet3:Refresh()

Return(cTotMov)





********************************************************************
* Autor			: EV Solution System
* Descrição		: Atualiza Movimentação
* Data			: 01/11/2015
********************************************************************
Static Function EVFINA3F(aMovim,oListBox1)

Local nSoma := 0
Local aMatriz2 := {}

aMatriz2 := ACLONE(aMovim)

For i := 1 To Len(aMovim)
	If aMovim[i,1]

		cQuery := " UPDATE "+RetSqlName("SE5")
		cQuery += " SET E5_RECONC = '' "
		cQuery += " WHERE D_E_L_E_T_ = '' "
		cQuery += " AND E5_DTDISPO = '"+DtoS(CtoD(aMovim[i,2]))+"' "
		cQuery += " AND E5_BANCO = '"+cMvPar03+"' "
		cQuery += " AND E5_CONTA = '"+cMvPar05+"' "
		cQuery += " AND E5_HISTOR = '"+aMovim[i,3]+"' "
		TCSQLExec(cQuery)

	EndIf
Next i

aMovim   := {}

For i := 1 To Len(aMatriz2)
	If !aMatriz2[i,1]
		AAdd(aMovim,{aMatriz2[i,1], aMatriz2[i,2], aMatriz2[i,3], aMatriz2[i,4], aMatriz2[i,5] })
	EndIf
Next i

UpDtList(@aMovim, @oListBox1, 2)
/*
oListBox1:SetArray(aMovim)
oListBox1:bLine := {||{ 	IIf(aMovim[oListBox1:nAt][1],LoadBitmap( GetResources(), "CHECKED" ),LoadBitmap( GetResources(), "UNCHECKED" )),;
								aMovim[oListBox1:nAt][2],;
								aMovim[oListBox1:nAt][3],;
								aMovim[oListBox1:nAt][4],;
								aMovim[oListBox1:nAt][5]}}
oListBox1:Refresh()
*/

oGet1:Refresh()
oGet2:Refresh()
oGet3:Refresh()

Return




********************************************************************
* Autor			: EV Solution System
* Descrição		: Apresenta Item conciliado
* Data			: 01/11/2015
********************************************************************
Static Function EVFINA3E(aMovim,oListBox1,aExtrato,oListBox)

Local nSoma := 0
Local nSaldoC := 0
Local aMatriz1 := {}
Local aMatriz2 := {}

aMatriz1 := ACLONE(aExtrato)
aMatriz2 := ACLONE(aMovim)

If cTotExt == cTotMov

	For i := 1 To Len(aMovim)
		If aMovim[i,1]
			If aMovim[i,4] == "C"
				nSoma += aMovim[i,5]
			Else
				nSoma -= aMovim[i,5]
			EndIf

			cQuery := " UPDATE "+RetSqlName("SE5")
			cQuery += " SET E5_RECONC = 'X' "
			cQuery += " WHERE D_E_L_E_T_ = '' "
			cQuery += " AND E5_DTDISPO = '"+DtoS(CtoD(aMovim[i,2]))+"' "
			cQuery += " AND E5_BANCO = '"+cMvPar03+"' "
			cQuery += " AND E5_CONTA = '"+cMvPar05+"' "
			cQuery += " AND E5_HISTOR = '"+aMovim[i,3]+"' "
			TCSQLExec(cQuery)

		EndIf
	Next i

	For i := 1 To Len(aExtrato)
		If aExtrato[i,1]

			cQuery := " UPDATE "+RetSqlName("ZZN")
			cQuery += " SET ZZN_CONCIL = 'X' "
			cQuery += " WHERE D_E_L_E_T_ = '' "
			cQuery += " AND R_E_C_N_O_ = '"+AllTrim(Str(aExtrato[i,7]))+"' "
			TCSQLExec(cQuery)

		EndIf
	Next i

	cQuery := " SELECT ROUND(SUM(E5_VALOR),2) AS E5_VALOR, E5_HISTOR, E5_RECPAG  FROM "+RetSqlName("SE5")
	cQuery += " WHERE D_E_L_E_T_ = '' "
	cQuery += " AND E5_RECPAG = 'R' AND E5_TIPODOC NOT IN ('TR','JR', 'MT') "
	cQuery += " AND E5_DTDISPO BETWEEN '"+DtoS(dMvPar01)+"' AND '"+DtoS(dMvPar02)+"' "
	cQuery += " AND E5_BANCO = '"+cMvPar03+"' "
	cQuery += " AND E5_CONTA = '"+cMvPar05+"' "
	cQuery += " AND E5_RECONC = 'X' "
	cQuery += " GROUP BY E5_HISTOR, E5_RECPAG "

	cQuery += " UNION "

	cQuery += " SELECT ROUND(SUM(E5_VALOR),2) AS E5_VALOR, E5_HISTOR, E5_RECPAG  FROM "+RetSqlName("SE5")
	cQuery += " WHERE D_E_L_E_T_ = '' "
	cQuery += " AND E5_RECPAG = 'R' AND E5_TIPODOC = 'TR' "
	cQuery += " AND E5_DTDISPO BETWEEN '"+DtoS(dMvPar01)+"' AND '"+DtoS(dMvPar02)+"' "
	cQuery += " AND E5_BANCO = '"+cMvPar03+"' "
	cQuery += " AND E5_CONTA = '"+cMvPar05+"' "
	cQuery += " AND E5_RECONC = 'X' "
	cQuery += " GROUP BY E5_HISTOR, E5_RECPAG "

	cQuery += " UNION "

	cQuery += " SELECT ROUND(SUM(E5_VALOR),2) AS E5_VALOR, E5_HISTOR, E5_RECPAG  FROM "+RetSqlName("SE5")
	cQuery += " WHERE D_E_L_E_T_ = '' "
	cQuery += " AND E5_RECPAG = 'P' "
	cQuery += " AND E5_DTDISPO BETWEEN '"+DtoS(dMvPar01)+"' AND '"+DtoS(dMvPar02)+"' "
	cQuery += " AND E5_BANCO = '"+cMvPar03+"' "
	cQuery += " AND E5_CONTA = '"+cMvPar05+"' "
	cQuery += " AND E5_RECONC = 'X' "
	cQuery += " GROUP BY E5_HISTOR, E5_RECPAG "
	TcQuery cQuery New Alias "TMP"

	DbSelectArea("TMP")
	DbGoTop()

	While !Eof()

		If TMP->E5_RECPAG == "R"
			nSaldoC += TMP->E5_VALOR
		Else
			nSaldoC -= TMP->E5_VALOR
		EndIf

		DbSelectArea("TMP")
		DbSkip()

	End

	DbSelectArea("TMP")
	DbCloseArea()

	//ATUALIZA DADOS DO EXTRATO
	DbSelectArea("SE8")
	DbSetOrder(1)
	DbSeek(xFilial("SE8") + cMvPar03 + cMvPar04 + cMvPar05 + DTOS(dMvPar01) )

	RecLock("SE8",.F.)
	SE8->E8_SALRECO := SE8->E8_SALANT+nSaldoC
	MsUnLock()

	cSaldoC    := AllTrim(Str(Round(SE8->E8_SALANT+nSaldoC,2)))

	aExtrato := {}
	aMovim   := {}

	For i := 1 To Len(aMatriz1)
		If !aMatriz1[i,1]
			AAdd(aExtrato,{aMatriz1[i,1], aMatriz1[i,2], aMatriz1[i,3], aMatriz1[i,4], aMatriz1[i,5], aMatriz1[i,6], aMatriz1[i,7] })
		EndIf
	Next i

	For i := 1 To Len(aMatriz2)
		If !aMatriz2[i,1]
			AAdd(aMovim,{aMatriz2[i,1], aMatriz2[i,2], aMatriz2[i,3], aMatriz2[i,4], aMatriz2[i,5] })
		EndIf
	Next i

	UpDtList(@aExtrato, @oListBox, 1)
	/*
	oListBox:SetArray(aExtrato)
	oListBox:bLine := {||{ 		IIf(aExtrato[oListBox:nAt][1],LoadBitmap( GetResources(), "CHECKED" ),LoadBitmap( GetResources(), "UNCHECKED" )),;
									aExtrato[oListBox:nAt][2],;
									aExtrato[oListBox:nAt][3],;
									aExtrato[oListBox:nAt][4],;
									aExtrato[oListBox:nAt][5],;
									aExtrato[oListBox:nAt][6],;
									aExtrato[oListBox:nAt][7]}}
	oListBox:Refresh()
	*/
	UpDtList(@aMovim, @oListBox1, 2)
	/*
	oListBox1:SetArray(aMovim)
	oListBox1:bLine := {||{ 	IIf(aMovim[oListBox1:nAt][1],LoadBitmap( GetResources(), "CHECKED" ),LoadBitmap( GetResources(), "UNCHECKED" )),;
									aMovim[oListBox1:nAt][2],;
									aMovim[oListBox1:nAt][3],;
									aMovim[oListBox1:nAt][4],;
									aMovim[oListBox1:nAt][5]}}
	oListBox1:Refresh()
	*/
Else

	MsgInfo("Diferença de valores marcados entre Extrato x Movimento, não será conciliado","Valores Conciliação")

EndIf

oGet1:Refresh()
oGet2:Refresh()
oGet3:Refresh()

Return




********************************************************************
* Autor			: EV Solution System
* Descrição		: Marca Registro como Deletado
* Data			: 01/11/2015
********************************************************************
Static Function EVFINA3G(aExtrato,oListBox)

Local aMatriz1 := {}

aMatriz1 := ACLONE(aExtrato)

For i := 1 To Len(aExtrato)
	If aExtrato[i,1]

		cQuery := " UPDATE "+RetSqlName("ZZN")
		cQuery += " SET D_E_L_E_T_ = '*' "
		cQuery += " WHERE D_E_L_E_T_ = '' "
		cQuery += " AND R_E_C_N_O_ = '"+AllTrim(Str(aExtrato[i,7]))+"' "
		TCSQLExec(cQuery)

	EndIf
Next i

aExtrato := {}

For i := 1 To Len(aMatriz1)
	If !aMatriz1[i,1]
		AAdd(aExtrato,{aMatriz1[i,1], aMatriz1[i,2], aMatriz1[i,3], aMatriz1[i,4], aMatriz1[i,5], aMatriz1[i,6], aMatriz1[i,7] })
	EndIf
Next i

UpDtList(@aExtrato, @oListBox, 1)
/*
oListBox:SetArray(aExtrato)
oListBox:bLine := {||{ 		IIf(aExtrato[oListBox:nAt][1],LoadBitmap( GetResources(), "CHECKED" ),LoadBitmap( GetResources(), "UNCHECKED" )),;
								aExtrato[oListBox:nAt][2],;
								aExtrato[oListBox:nAt][3],;
								aExtrato[oListBox:nAt][4],;
								aExtrato[oListBox:nAt][5],;
								aExtrato[oListBox:nAt][6],;
								aExtrato[oListBox:nAt][7]}}
oListBox:Refresh()
*/
oGet1:Refresh()
oGet2:Refresh()
oGet3:Refresh()

Return

********************************************************************
* Autor			: EV Solution System
* Descrição		: Marca SE5 como conciliado
* Data			: 01/11/2015
********************************************************************
Static Function EVFINA3H(aMovim,oListBox1)

Local nSoma := 0
Local aMatriz2 := {}

aMatriz2 := ACLONE(aMovim)

For i := 1 To Len(aMovim)
	If aMovim[i,1]
		If aMovim[i,4] == "C"
			nSoma += aMovim[i,5]
		Else
			nSoma -= aMovim[i,5]
		EndIf

		cQuery := " UPDATE "+RetSqlName("SE5")
		cQuery += " SET E5_RECONC = 'X' "
		cQuery += " WHERE D_E_L_E_T_ = '' "
		cQuery += " AND E5_DTDISPO = '"+DtoS(CtoD(aMovim[i,2]))+"' "
		cQuery += " AND E5_BANCO = '"+cMvPar03+"' "
		cQuery += " AND E5_CONTA = '"+cMvPar05+"' "
		cQuery += " AND E5_HISTOR = '"+aMovim[i,3]+"' "
		TCSQLExec(cQuery)

	EndIf
Next i

aMovim := {}

For i := 1 To Len(aMatriz2)
	If !aMatriz2[i,1]
		AAdd(aMovim,{aMatriz2[i,1], aMatriz2[i,2], aMatriz2[i,3], aMatriz2[i,4], aMatriz2[i,5] })
	EndIf
Next i

UpDtList(@aMovim, @oListBox1, 2)
/*oListBox1:SetArray(aMovim)
oListBox1:bLine := {||{ 	IIf(aMovim[oListBox1:nAt][1],LoadBitmap( GetResources(), "CHECKED" ),LoadBitmap( GetResources(), "UNCHECKED" )),;
								aMovim[oListBox1:nAt][2],;
								aMovim[oListBox1:nAt][3],;
								aMovim[oListBox1:nAt][4],;
								aMovim[oListBox1:nAt][5]}}
oListBox1:Refresh()
*/
oGet1:Refresh()
oGet2:Refresh()
oGet3:Refresh()

Return


********************************************************************
* Autor			: EV Solution System
* Descrição		: Monta Registro de Perguntas
* Data			: 01/11/2015
********************************************************************
Static Function ValidPerg(cPerg)

Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,len(SX1->X1_GRUPO))

// Grupo/Ordem/Pergunta/Perg.Spa/Perg.Eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSpa01/DefEng01/Cnt01/Var02/Def02/DefSpa02/DefEng02/Cnt02/Var03/Def03/DefSpa03/DefEng03/Cnt03/Var04/Def04/DefSpa04/DefEng04/Cnt04/Var05/Def05/DefSpa05/DefEng05/Cnt05/F3/PYME/GRPSXG/HELP/PICTURE/IDFIL
AADD(aRegs,{cPerg,"01","Dt. Conc. De ?" ,"","","mv_ch1","D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Dt. Conc. Ate?" ,"","","mv_ch2","D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Banco?"         ,"","","mv_ch3","C",03,0,0,"C","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Agencia?"       ,"","","mv_ch4","C",05,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Conta?"         ,"","","mv_ch5","C",10,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Visibilidade?"  ,"","","mv_ch6","N",01,0,0,"C","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

Return


Static Function UpDtList(paArray, oListBox ,pTipo)

	oListBox:SetArray(paArray)
	if pTipo ==1
		oListBox:bLine := {||{ 	IIf(paArray[oListBox:nAt][1],LoadBitmap( GetResources(), "CHECKED" ),LoadBitmap( GetResources(), "UNCHECKED" )),;
									paArray[oListBox:nAt][2],;
									paArray[oListBox:nAt][3],;
									paArray[oListBox:nAt][4],;
									paArray[oListBox:nAt][5],;
									paArray[oListBox:nAt][6],;
									paArray[oListBox:nAt][7] }}
    else
	    oListBox:bLine := {||{ 	IIf(paArray[oListBox:nAt][1],LoadBitmap( GetResources(), "CHECKED" ),LoadBitmap( GetResources(), "UNCHECKED" )),;
									paArray[oListBox:nAt][2],;
									paArray[oListBox:nAt][3],;
									paArray[oListBox:nAt][4],;
									paArray[oListBox:nAt][5]}}
    endif
	oListBox:Refresh()

Return
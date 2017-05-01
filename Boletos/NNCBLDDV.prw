#include "rwmake.ch"
#INCLUDE "topconn.ch"
#DEFINE ENTER CHR(13) + CHR(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³MTBCO     º Autor ³Eduardo / Valdemir  º Data ³  17/02/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa para calcular Digitos Verficadores, Montagem da   º±±
±±º          ³ Linha Digitavel, Codigo de Barras e Nosso Numer.			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ EV Solution System                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º							                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                                                                       º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function NNCBLDDV(_aBoletos)

Local _aArea   := GetArea()
Local _aImpBol := {}
Local _nXx
	For _nXx:=1 To Len(_aBoletos)
		If Empty(_aBoletos[_nXx][6])
			SF2->(DbGoto(_aBoletos[_nXx][1]))
			SC5->(DbGoto(_aBoletos[_nXx][4]))
			U_fProcCodBco(_aBoletos[_nXx,2],_aBoletos[_nXx,3])
			_aBoletos[_nXx][6]:="OK"
			aAdd(_aImpBol,{_aBoletos[_nXx,3],_aBoletos[_nXx,2]}) //serie/doc
		EndIf
	Next _nXx
Restarea(_aArea)

Return

User Function fProcCodBco(_cNumeIni)

Local _vAmbSa1		:= SA1->(GetArea())
Local _cNumBar		:= ""
Local _cNossoNum	:= ""
Private _cBanco		:= _cBanco
Private _cDigBar	:= ""
Private _cDigCor	:= ""
Private _nDigtc3	:= 0
Private cQuery		:=""
Private _cDig1bar	:= 0
cSelect		:= " SELECT  * "										+ ENTER
cFrom 		:= " FROM "+ RetSqlName("SEE") +" SEE "					+ ENTER
cWhere 		:= " WHERE SEE.EE_FILIAL 	= '"+ xFilial("SEE")  +"' "	+ ENTER
cWhere 		+= "   AND SEE.D_E_L_E_T_ 	= ' ' "						+ ENTER
cWhere 		+= "   AND SEE.EE_CODIGO='"+ _cBanco +"' "				+ ENTER
//³Monta Query para SELECAO dos registros				                		³
cQuery := cSelect + cFrom + cWhere
If Select( "TMP" ) > 0
	DbSelectArea( "TMP" )
	DbCloseArea()
EndIf
MemoWrite( "rfatr01b.sql" , cQuery )
TcQuery cQuery New Alias "TMP"
_cParcIni := SE1->E1_PARCELA
_cPrefixo := SE1->E1_PREFIXO
_cNum     := SE1->E1_NUM
_cParcFim := SE1->E1_PARCELA
If Empty(_cBanco)
	_cBanco   := TMP->EE_CODIGO
	_cAgencia := TMP->EE_AGENCIA
	_cConta   := TMP->EE_CONTA
	_cDvCta   := TMP->EE_DVCTA	
EndIf
_cNossoNum	:= ""
If Mv_Par05 == 2 .And. !Empty(SE1->E1_XNUMBCO)
	_cNossoNum := SE1->E1_XNUMBCO
Else
	Do Case
		Case _cBanco == "001"
			_cNossoNum := Nosso001()
		Case _cBanco == "341"
			_cNossoNum := Nosso341()
		Case _cBanco == "033"
			_cNossoNum := Nosso033()
		Case _cBanco == "399"
			_cNossoNum := Nosso399()
		Case _cBanco == "237"
			_cNossoNum := Nosso237()
		Case _cBanco == "422"
			_cNossoNum := Nosso422()
	EndCase
EndIf
If _cBanco == "033"
	_cNossoNum := Alltrim(_cNossoNum)
	_cNossoDig := Right(_cNossoNum,1)	
	_cDigBar := ""
	_cNumBar := _fNumBar(_cBanco,_cAgencia,_cConta,_cNossoNum,@_cDigBar,_cNossoDig)
	_cNumBol := _fNumBol(_cBanco,_cAgencia,_cConta,_cNossoNum,_cNumBar)	
ElseIf _cBanco == "399"
	_cNossoNum := Alltrim(_cNossoNum)
	_cNossoDig := Right(_cNossoNum,1)	
	_cDigBar := ""
	_cNumBar := _fNumBar(_cBanco,_cAgencia,_cConta,_cNossoNum,@_cDigBar,_cNossoDig)
	_cNumBol := _fNumBol(_cBanco,_cAgencia,_cConta,_cNossoNum,_cNumBar)
ElseIf  _cBanco == "001"
	_cNossoNum := Alltrim(_cNossoNum)
	_cNossoDig := ""//right(_cNossoNum1,1)
	_cDigBar := ""
	_cNumBar := _fNumBar(_cBanco,_cAgencia,_cConta,_cNossoNum,@_cDigBar,_cNossoDig)
	_cNumBol := _fNumBol(_cBanco,_cAgencia,_cConta,_cNossoNum,_cNumBar)
Else
	_cNossoNum := Alltrim(_cNossoNum)
	_cNossoDig := Right(_cNossoNum,1)
	_cNossoNum := Left(_cNossoNum,Len(_cNossoNum)-1)
	_cDigBar := ""
	_cNumBar := _fNumBar(_cBanco,_cAgencia,_cConta,_cNossoNum,@_cDigBar,_cNossoDig)
	_cNumBol := _fNumBol(_cBanco,_cAgencia,_cConta,_cNossoNum,_cNumBar)
EndIf
If !Empty(_cNossoNum) .Or. !Empty(_cNumBar) .Or. !Empty(_cNumbol)
	If SE1->(RecLock(Alias(),.F.))
		If _cBanco == "033"
			SE1->E1_NUMBCO := _cNossoNum 
		ElseIf _cBanco == "399"
			SE1->E1_NUMBCO := _cNossoNum
		ElseIf _cBanco == "001"
			SE1->E1_NUMBCO := _cNossoNum 
		ElseIf _cBanco == "341"
			SE1->E1_NUMBCO :=_cNossoNum + _cNossoDig
		Else
			SE1->E1_NUMBCO :=_cNossoNum + _cNossoDig
			If Empty(SE1->E1_NUMBCO)
				SE1->E1_NUMBCO := _cNossoNum + _cNossoDig
			Else
				SE1->E1_NUMBCO := SE1->E1_NUMBCO
			EndIf
		EndIf
			SE1->E1_PORTADO	:= _cBanco
			SE1->E1_AGEDEP	:= _cAgencia
			SE1->E1_CONTA	:= _cConta			
			SE1->E1_CODBAR  := _cNumBar
			SE1->E1_CODDIG  := _cNumBol
			SE1->E1_SITUACA := "0"
			SE1->E1_XNUMBCO := _cNossoNum
			If Empty(SE1->E1_XNUMBCO) // Vazio
				SE1->E1_XNUMBCO := SE1->E1_NUMBCO
			Else // Ja gravaDo
				If Mv_Par05 == 2 .And. !Empty(SE1->E1_XNUMBCO)
					SE1->E1_NUMBCO := SE1->E1_XNUMBCO // Usa o original
				Else
					_cNossoNum := SE1->E1_XNUMBCO
				EndIf
			EndIf
			SE1->(msunlock())
	EndIf
EndIf
RetIndex("SA1")

Return

// Função para Montagem da Linha Digitavel
Static Function _fNumBol(_cBanco,_cAgencia,_cConta,_cNossoNum,_cNumBar)

Local _cNumBol,_cNossoNu1:=_cNossoNum,_nVez

For _nVez := 1 To Len(_cNossoNum)
	If Substr(_cNossoNum,_nVez,1) == "0"
		_cNossoNu1 := Right(_cNossoNu1,Len(_cNossoNu1)-1)
	Else
		Exit
	EndIf
Next
Do Case
	Case _cBanco == "001" //Bco do Brasil
		_cCampo1 := _cBanco + "9" + Substr(_cNumBar,20,5)
		_cDig1	 := _fDigVer(_cCampo1,_cBanco)

		_cCampo2 := Substr(_cNumBar,25,10)
		_cDig2	 := _fDigVer(_cCampo2,_cBanco)
		
		_cCampo3 := Substr(_cNumBar,35,10)
		_cDig3	 := _fDigVer(_cCampo3,_cBanco)
		
		_cCampo4 := _cDigBar
		
		_cCampo5 := Substr(_cNumBar,06,4) + Strzero(SE1->E1_VALOR*100,10)
		
		_cNumBol :=_cCampo1+_cDig1+_cCampo2+_cDig2+_cCampo3+_cDig3+_cCampo4+_cCampo5

	Case _cBanco == "341" // Itau
		_cCampo1 := _cBanco + "9" + "109" + Left(_cNossoNum,2)
		_cDig1	 := _fDigVer(_cCampo1,_cBanco)
		
		_cCampo2 := Substr(_cNossoNum,3) + _cNossoDig + Left(_cAgencia,3)
		_cDig2	 := _fDigVer(_cCampo2,_cBanco)
		
		_cCampo3 := Substr(_cAgencia,4,1) + Strzero(Val(Alltrim(_cConta)),5) + Alltrim(_cDvCta) + "000"
		_cDig3	 := _fDigVer(_cCampo3,_cBanco)
		
		_cCampo4 := _cDigBar
		_cCampo5 := Strzero(se1->e1_vencto-ctod("07/10/1997"),4) + Strzero(se1->e1_valor*100,10)
		
		_cNumBol := _cCampo1+_cDig1+_cCampo2+_cDig2+_cCampo3+_cDig3+_cCampo4+_cCampo5

	Case _cBanco == "033" // SANTANDER
		cCpo01 := _cBanco
		cCpo02 := "9" // Moeda "9"=Real
		cCpo03 := "9" // Fixo "9"
		cCpo04 := Substr(_cCodemp,9,4) // Codigo Padrao Cedenteo Banco Santander
		cDig_4 := _fDigVer(_cBanco + "99" + cCpo04,cCpo01)
		
		cCpo05 := Substr(_cCodemp,13,3) + SubStr(_cNossoNum,1,7) // Restante do Cod Cedente
		cDig_5 := _fDigVer2(cCpo05, _cBanco)
		
		cCpo06 := SubStr(_cNossoNum,8,6) // Restante do Nosso Numero
		cCpo07 := "0" // IOS
		cCpo08 := "101" // "101"=Cobranca Simples Com Registro
		cDig_8 := _fDigVer3(cCpo06 + cCpo07 + cCpo08, _cBanco)
		
		cDig_9 := _cDig1bar
		
		cCpo10 := StrZero(SE1->E1_VENCTO - CtoD("07/10/1997"),4) // Fator de Vencimento
		cCpo11 := strzero((IIF(SE1->E1_PREFIXO<>"RPS",SE1->E1_SALDO,SE1->E1_SALDO-(If(SE1->E1_SABTCSL>0,0,SE1->E1_CSLL) +if(SE1->E1_SABTCOF>0,0,SE1->E1_COFINS)+IF(SE1->E1_SABTPIS>0,0,SE1->E1_PIS)+SE1->E1_IRRF +SE1->E1_ISS+SE1->E1_INSS)))*100,10)
		
		_cNumBol := cCpo01 + cCpo02 + cCpo03 + cCpo04 + cDig_4
		_cNumBol += cCpo05 + cDig_5
		_cNumBol += cCpo06 + cCpo07 + cCpo08 + cDig_8
		_cNumBol += cDig_9
		_cNumBol += cCpo10 + cCpo11

	Case _cBanco == "399" // HSBC
		cCpo01 := _cBanco
		cCpo02 := "9" // Moeda "9"=Real
		cCpo03 := Substr(_cNossoNum,1,5) // Inicio do Nosso Numero Banco HSBC
		cDig_3 := _fDigVer(_cBanco + "9" + cCpo03,cCpo01)
		
		cCpo04 := Substr(_cNossoNum,6,6) + Alltrim(_cAgencia) // Fim do Nosso Numero Banco HSBC + Agencia
		cDig_4 := _fDigVer2(cCpo04, _cBanco)
		
		cCpo05 :=  Alltrim(_cConta) + Alltrim(_cDvCta)	// Conta Corrente + Digito da Conta Corrente
		cCpo06 := "00"	// Codigo da Carteira
		cCpo07 := "1"	// Codigo Aplicativo 
		cDig_7 := _fDigVer3(cCpo05 + cCpo06 + cCpo07, _cBanco)
		
		cDig_8 := _cDig1bar
		
		cCpo09 := StrZero(SE1->E1_VENCTO - CtoD("07/10/1997"),4) // Fator de Vencimento
		cCpo10 := strzero((IIF(SE1->E1_PREFIXO<>"RPS",SE1->E1_SALDO+SE1->E1_ACRESC-SE1->E1_DECRESC,(SE1->E1_SALDO+SE1->E1_ACRESC-SE1->E1_DECRESC)-(If(SE1->E1_SABTCSL>0,0,SE1->E1_CSLL) +if(SE1->E1_SABTCOF>0,0,SE1->E1_COFINS)+IF(SE1->E1_SABTPIS>0,0,SE1->E1_PIS)+SE1->E1_IRRF +SE1->E1_ISS+SE1->E1_INSS)))*100,10)	// Valor do Titulo
		
		_cNumBol := cCpo01 + cCpo02 + cCpo03 + cDig_3
		_cNumBol += cCpo04 + cDig_4
		_cNumBol += cCpo05 + cCpo06 + cCpo07 + cDig_7
		_cNumBol += cDig_8
		_cNumBol += cCpo09 + cCpo10

	Case _cBanco == "422" // Safra
		_cCampo1 := _cBanco + "9" + Substr(_cNumBar,20,5)
		_cDig1	 := _fDigVer(_cCampo1,_cBanco)
		
		_cCampo2 := Substr(_cNumBar,25,10)
		_cDig2	 := _fDigVer(_cCampo2,_cBanco)
		
		_cCampo3 := Substr(_cNumBar,35,10)
		_cDig3	 := _fDigVer(_cCampo3,_cBanco)
		
		_cCampo4 := _cDigBar
		
		_cCampo5 := Substr(_cNumBar,06,14)
		
		_cNumBol := _cCampo1+_cDig1+_cCampo2+_cDig2+_cCampo3+_cDig3+_cCampo4+_cCampo5
		
	Case _cBanco == "237" // Bradesco
		_cCampo1 := _cBanco + "9" + Substr(_cNumBar,20,5)
		_cDig1	 :=_fDigVer(_cCampo1,_cBanco)
		
		_cCampo2 := Substr(_cNumBar,25,10)
		_cDig2	 := _fDigVer(_cCampo2,_cBanco)
		
		_cCampo3 := Substr(_cNumBar,35,10)
		_cDig3	 := _fDigVer(_cCampo3,_cBanco)
		
		_cCampo4 := _cDigBar
		
		_cCampo5 := Substr(_cNumBar,06,14)
		
		_cNumBol := _cCampo1+_cDig1+_cCampo2+_cDig2+_cCampo3+_cDig3+_cCampo4+_cCampo5
EndCase

Return _cNumBol

// Função para Montagem do Codigo de Barras
Static Function _fNumBar(_cBanco,_cAgencia,_cConta,_cNossoNum,_cDigBar,_cNossoDig)

Local _cNumBar,_cNossoNu1:=_cNossoNum,_nVez
Private _cDigcor := ""

For _nVez:=1 To Len(_cNossoNum)
	If Substr(_cNossoNum,_nVez,1)=="0"
		_cNossoNu1:=right(_cNossoNu1,len(_cNossoNu1)-1)
	Else
		Exit
	EndIf
Next
Do Case
	Case _cBanco == "001" // Bco do Brasil
		_cCampo1 := _cBanco + "9" + _cDigBar + Strzero(SE1->E1_VENCTO-CtoD("07/10/1997"),4) + Strzero(SE1->E1_VALOR*100,10) +;
		STRZERO(0,6) + SUBSTR(SEE->EE_CODEMP,3,7) + _cNossoNum + SEE->EE_CODCART		
		
		_cNumBar := Left(_cCampo1,4)+(_cDigBar:=_fDigBar(_cCampo1,_cBanco)) + Substr(_cCampo1,5)
		
	Case _cBanco == "341" // Itau
		_cCampo1 := _cBanco + "9" + Strzero(SE1->E1_VENCTO-CtoD("07/10/1997"),4) + Strzero(SE1->E1_VALOR*100,10) + "109" + _cNossoNum + _cNossoDig +;
		Strzero(Val(Alltrim(_cAgencia)),4) + Strzero(Val(Alltrim(_cConta)),5) + Alltrim(_cDvCta) + "000"

		_cNumBar := Left(_cCampo1,4)+(_cDigBar:=_fDigBar(_cCampo1,_cBanco)) + Substr(_cCampo1,5)

  	 Case _cBanco == "033" // BANESPA / SANTANDER		
		_cCampo1 := _cBanco + "9" + Strzero(SE1->E1_VENCTO-CtoD("07/10/1997"),4) + Strzero(SE1->E1_VALOR*100,10) + "9" + Substr(_cCodemp,9,7) + _cNossoNum + "0" + "101"
		_cDig1bar:= _fDigBar(_cCampo1,_cBanco)
		 
		_cCampo2 := _cBanco + "9" + _cDig1bar + Strzero(SE1->E1_VENCTO-CtoD("07/10/1997"),4) +;
		Strzero((IIF(SE1->E1_PREFIXO<>"RPS",SE1->E1_SALDO,SE1->E1_SALDO-(If(SE1->E1_SABTCSL>0,0,SE1->E1_CSLL) +if(SE1->E1_SABTCOF>0,0,SE1->E1_COFINS)+IF(SE1->E1_SABTPIS>0,0,SE1->E1_PIS)+SE1->E1_IRRF +SE1->E1_ISS+SE1->E1_INSS)))*100,10)+;
		"9" + Substr(_cCodemp,9,7) + _cNossoNum + "0" + "101"	
		
		_cNumBar:=_cCampo2
	
   	 Case _cBanco == "399" // HSBC
		_cCampo1 := _cBanco+"9"+strzero(SE1->E1_VENCTO-CtoD("07/10/1997"),4)+strzero((IIF(SE1->E1_PREFIXO<>"RPS",SE1->E1_SALDO+SE1->E1_ACRESC-SE1->E1_DECRESC,(SE1->E1_SALDO+SE1->E1_ACRESC-SE1->E1_DECRESC)-(If(SE1->E1_SABTCSL>0,0,SE1->E1_CSLL) +if(SE1->E1_SABTCOF>0,0,SE1->E1_COFINS)+IF(SE1->E1_SABTPIS>0,0,SE1->E1_PIS)+SE1->E1_IRRF +SE1->E1_ISS+SE1->E1_INSS)))*100,10)+;
		_cNossoNum + Substr(Alltrim(_cAgencia),1,4) + Substr(Alltrim(_cConta),1,5) + Alltrim(_cDvCta) + "00" + "1"	
	  
		_cDig1bar:= _fDigBar(_cCampo1,_cBanco)
		 
		 _cCampo2 := _cBanco + "9" + _cDig1bar + Strzero(SE1->E1_VENCTO-CtoD("07/10/1997"),4) +;
		Strzero((IIF(SE1->E1_PREFIXO<>"RPS",SE1->E1_SALDO+SE1->E1_ACRESC-SE1->E1_DECRESC,(SE1->E1_SALDO+SE1->E1_ACRESC-SE1->E1_DECRESC)-(If(SE1->E1_SABTCSL>0,0,SE1->E1_CSLL) +if(SE1->E1_SABTCOF>0,0,SE1->E1_COFINS)+IF(SE1->E1_SABTPIS>0,0,SE1->E1_PIS)+SE1->E1_IRRF +SE1->E1_ISS+SE1->E1_INSS)))*100,10)+;
		_cNossoNum + Substr(Alltrim(_cAgencia),1,4) + Substr(Alltrim(_cConta),1,5) + Alltrim(_cDvCta) + "00" + "1"
		
		_cNumBar := _cCampo2
				
	Case _cBanco == "422" // Safra
		_cCampo1 := _cBanco + "9" + Strzero(SE1->E1_VENCTO-CtoD("07/10/1997"),4) + Strzero(SE1->E1_VALOR*100,10) + "7" + Strzero(Val(Alltrim(_cAgencia)),5) +;
		Strzero(Val(Alltrim(_cConta)),9) + _cNossoNum + _cNossoDig + "2"
		
		_cNumBar := Left(_cCampo1,4)+(_cDigBar:=_fDigBar(_cCampo1,_cBanco)) + Substr(_cCampo1,5)

		
	Case _cBanco == "237" // Bradesco
		_cCampo1 := _cBanco + "9" + Strzero(SE1->E1_VENCTO-CtoD("07/10/1997"),4) + Strzero(SE1->E1_VALOR*100,10) + Substr(_cAgencia,1,4) +;
		Substr(SEE->EE_CODCART,2,2) + _cNossoNum + Strzero(Val(_cConta),7) + "0"
		
		_cNumBar := Left(_cCampo1,4)+(_cDigBar:=_fDigBar(_cCampo1,_cBanco)) + Substr(_cCampo1,5)
EndCase

Return _cNumBar

Static Function _fDigVer(_cCampo,_cBanco)

Local _nVez,_nVez1,_nFator,_nPeso,_nReturn,_nResult,_cResult
If _cBanco == "001" // Brasil
	_nFator := 0
	_nPeso  := 2
	_nReturn:= 0
	For _nVez := Len(_cCampo) To 1 Step -1
		_nResult := Val(Substr(_cCampo,_nVez,1))*_nPeso
		_cResult := Strzero(_nResult,2)
		_nFator  += Val(Substr(_cResult,1,1))
		_nFator  += Val(Substr(_cResult,2,1))
		_nPeso   := If(_nPeso==2,1,2)
	Next
	_nReturn := Mod(_nFator,10)
	If _nReturn > 0
		_nReturn := 10-_nReturn
	EndIf
ElseIf _cBanco == "341" // Itau
	_nFator := 0
	_nPeso  := 2
	_nReturn:= 0
	For _nVez := Len(_cCampo) To 1 Step -1
		_nResult := Val(Substr(_cCampo,_nVez,1))*_nPeso
		_cResult := Strzero(_nResult,2)
		_nFator  += Val(Substr(_cResult,1,1))
		_nFator  += Val(Substr(_cResult,2,1))
		_nPeso   := If(_nPeso==2,1,2)
	Next
	_nReturn := Mod(_nFator,10)
	If _nReturn > 0
		_nReturn := 10-_nReturn
	EndIf
ElseIf _cBanco == "033" // Banespa
	_nFator := 0
	_nPeso  := 2
	_nReturn:= 0
	For _nVez := Len(_cCampo) To 1 Step -1
		_nResult := Val(Substr(_cCampo,_nVez,1))*_nPeso
		_cResult := Strzero(_nResult,2)
		_nFator  += Val(Substr(_cResult,1,1))
		_nFator  += Val(Substr(_cResult,2,1))
		_nPeso   := If(_nPeso==2,1,2)
	Next
	_nReturn := Mod(_nFator,10)
	If _nReturn > 0
		_nReturn := 10-_nReturn
	EndIf
ElseIf _cBanco == "399" // Hsbc
	_nFator := 0
	_nPeso  := 2
	_nReturn:= 0
	For _nVez := Len(_cCampo) To 1 Step -1
		_nResult := Val(Substr(_cCampo,_nVez,1))*_nPeso
		_cResult := Strzero(_nResult,2)
		_nFator  += Val(Substr(_cResult,1,1))
		_nFator  += Val(Substr(_cResult,2,1))
		_nPeso   := If(_nPeso==2,1,2)
	Next
	_nReturn := Mod(_nFator,10)
	If _nReturn > 0
		_nReturn := 10-_nReturn
	EndIf
ElseIf _cBanco=="422" // Safra
	_nFator := 0
	_nPeso  := 2
	_nReturn:= 0
	For _nVez := Len(_cCampo) To 1 Step -1
		_nResult := Val(Substr(_cCampo,_nVez,1))*_nPeso
		_cResult := Strzero(_nResult,2)
		_nFator  += Val(Substr(_cResult,1,1))
		_nFator  += Val(Substr(_cResult,2,1))
		_nPeso   := If(_nPeso==2,1,2)
	Next
	_nReturn := Mod(_nFator,10)
	If _nReturn > 0
		_nReturn := 10-_nReturn
	EndIf
ElseIf _cBanco == "237" // Bradesco
	_nFator := 0
	_nPeso  := 2
	_nReturn:= 0
	For _nVez := Len(_cCampo) To 1 Step -1
		_nResult := Val(Substr(_cCampo,_nVez,1))*_nPeso
		_cResult := Strzero(_nResult,2)
		_nFator  += Val(Substr(_cResult,1,1))
		_nFator  += Val(Substr(_cResult,2,1))
		_nPeso   := If(_nPeso==2,1,2)
	Next
	_nReturn := Mod(_nFator,10)
	If _nReturn > 0
		_nReturn := 10-_nReturn
	EndIf
EndIf
SEE->(DbCloseArea())

Return str(_nReturn,1)

Static Function _fDigBar(_cCampo,_cBanco)

Local _nVez,_nPeso,_nFator,_nResto, w
If _cBanco == "001" // Banco do Brasil
	_nPeso := 2
	_nFator:= 0
	_nResto:= 0
	For _nVez := Len(_cCampo) To 1 Step -1
		_nFator += Val(Substr(_cCampo,_nVez,1))*_nPeso
		_nPeso  := If(_nPeso<9,_nPeso+1,2)
	Next
	_nResto := Mod(_nFator,11)
	if _nResto == 0 .Or. _nResto == 1 .Or. _nResto > 9
		_nResto := 1
	Else
		_nResto := 11-_nResto
	EndIf
ElseIf _cBanco == "341" // Itau
	_nPeso  := 2
	_nFator := 0
	_nResto := 0
	For _nVez := Len(_cCampo) To 1 Step -1
		_nFator += Val(Substr(_cCampo,_nVez,1))*_nPeso
		_nPeso  := If(_nPeso<9,_nPeso+1,2)
	Next
	_nResto := Mod(_nFator,11)
	if _nResto == 0 .Or. _nResto == 1 .Or. _nResto == 10 .Or. _nResto == 11
		_nResto := 1
	Else
		_nResto := 11-_nResto
	EndIf
ElseIf _cBanco == "033" // BANESPA
	_nPeso	 := 2
	_nFator_ := 0
	_nFator  :=0
	_nFatorAux := 0
	_nResto  :=0
	_nVez    :=1
	nSoma    := 0
	nPeso	 := 2
	For w := Len(_cCampo) To 1 Step -1
		nCalc := Val(Substr(_cCampo,w,1)) * nPeso
		nSoma += nCalc
		nPeso := Iif(nPeso == 9, 2, ++nPeso)
	Next
	nSoma *= 10
	_nResto := Mod(nSoma,11)
	If _nResto == 0 .Or. _nResto == 1 .Or. _nResto == 10
		_nResto := 1
	EndIf
ElseIf _cBanco == "399" // HSBC
	_nPeso		:= 2
	_nFator_	:= 0
	_nFator		:= 0
	_nFatorAux	:= 0
	_nResto		:= 0
	_nVez		:= 1
	nSoma		:= 0
	nPeso		:= 2
	For w := Len(_cCampo) To 1 Step -1
		nCalc := Val(Substr(_cCampo,w,1)) * nPeso
		nSoma += nCalc
		nPeso := Iif(nPeso == 9, 2, ++nPeso)
	Next
	nSoma *= 10
	_nResto := Mod(nSoma,11)
	If _nResto == 0 .Or. _nResto == 1 .Or. _nResto == 10
		_nResto := 1
	EndIf
ElseIf _cBanco == "422" // Safra
	_nPeso := 2
	_nFator:= 0
	_nResto:= 0
	For _nVez := Len(_cCampo) To 1 Step -1
		_nFator += Val(Substr(_cCampo,_nVez,1))*_nPeso
		_nPeso  := If(_nPeso<9,_nPeso+1,2)
	Next
	_nResto := Mod(_nFator,11)
	If _nResto == 0 .Or. _nResto == 1 .Or. _nResto == 10
		_nResto := 1
	Else
		_nResto := 11-_nResto
	EndIf
ElseIf _cBanco == "237" // Bradesco
	_nPeso := 2
	_nFator:= 0
	_nResto:= 0
	For _nVez := Len(_cCampo) To 1 Step -1
		_nFator += Val(Substr(_cCampo,_nVez,1))*_nPeso
		_nPeso  := If(_nPeso<9,_nPeso+1,2)
	Next
	_nResto := Mod(_nFator,11)
	If _nResto == 0 .Or. _nResto == 1 .Or. _nResto > 9
		_nResto := 1
	Else
		_nResto := 11-_nResto
	EndIf
EndIf
SEE->(DbCloseArea())

Return Str(_nResto,1)

// Função para calcular o Digito do Nosso Numero 341
Static Function Nosso341()

Local _xDvcta     := ""
Local _xConta     := ""
Local _xAgencia   := ""
Local _xCart      := ""
Local _xNosso_num := ""
Local _xVariavel  := ""
Local _nPeso      := 2
Local _nResult    := 0
Local _cResult    := ""
Local _nFator     := 0
Local _nReturn    := 0
Local _nVez

If Empty(SE1->E1_NUMBCO)
	DbSelectArea("SEE")
	DbSetOrder(1)       
	DbSeek(xFilial("SEE") + _cBanco + _cAgencia + _cConta + "R",.T.)
	RecLock("SEE",.F. )
		SEE->EE_FAXATU := Soma1(SEE->EE_FAXATU,8)
	MsUnlock()
	_xConta   	:= Alltrim(SEE->EE_CONTA)
	_xAgencia 	:= Left(SEE->EE_AGENCIA,4)
	_xCart    	:= "109"
	_xNosso_num := Right(see->ee_faxatu,8)//Right(TMP->EE_FAXATU,8)
	_xVariavel	:= _xAgencia+_xConta+_xCart+_xNosso_num
	For _nVez := Len(Alltrim(_xVariavel)) To 1 Step -1
		_nResult := Val(Substr(_xVariavel,_nVez,1))*_nPeso
		_cResult := Strzero(_nResult,2)
		_nFator  += Val(Substr(_cResult,1,1))
		_nFator  += Val(Substr(_cResult,2,1))
		_nPeso   := If(_nPeso==2,1,2)
	Next
	_nReturn := Mod(_nFator,10)
	If _nReturn > 0
		_nReturn := 10-_nReturn
	EndIf
	_cRet := _xNosso_num + Str(_nReturn,1)
Else
	_cRet := SE1->E1_NUMBCO
EndIf

Return(_cRet)

// Função para calcular o Digito do Nosso Numero 001
Static Function Nosso001()

Local _xConta     := ""
Local _xAgencia   := ""
Local _xCart      := ""
Local _xNosso_num := ""
Local _xVariavel  := ""
Local _nPeso      := 9
Local _nResult    := 0
Local _cResult    := ""
Local _nFator     := 0
Local _nReturn    := 0
Local _nVez

If Empty(SE1->E1_NUMBCO)
	DbSelectArea("SEE")
	DbSetOrder(1)           	
	DbSeek(xFilial("SEE") + _cBanco + _cAgencia + _cConta + "R",.T.)
	RecLock("SEE",.F.)
		SEE->EE_FAXATU := Soma1(SEE->EE_FAXATU,12)
	MsUnlock()
	_xNosso_num := Strzero(Val(Substr(SEE->EE_FAXATU,3,10)),10)
	_xVariavel	:= _xNosso_num
	For _nVez := Len(Alltrim(_xVariavel)) To 1 Step -1
		_nFator += Val(Substr(_xVariavel,_nVez,1))*_nPeso
		_nPeso  := _nPeso - 1
		If _nPeso == 1
			_nPeso := 9
		Else
			_nPeso := _nPeso
		EndIf
	Next
	_nResto := Mod(_nFator,11)
	If _nResto = 10
		_cResult := "X"
	ElseIf _nResto = 0
		_cResult := "0"
	Else
		_nResto < 10
		_nResto := _nResto
		_cResult := Str(_nResto,1)
	EndIf
	_cRet := _xNosso_num
Else
	_cRet := SE1->E1_NUMBCO
EndIf

Return(_cRet)

// Função para calcular o Digito do Nosso Numero 033
Static Function Nosso033()

Private cNumero	:=SPACE(12)
Private cDig	:=SPACE(01)
If Empty(SE1->E1_NUMBCO)
	DbSelectArea("SEE")
	DbSetOrder(1)
	DbSeek(xFilial("SEE") + _cBanco + _cAgencia + _cConta + "R",.T.)
	cNumero:= Strzero(Val(StrZero(Val(SEE->EE_FAXATU),Len(SEE->EE_FAXATU))),12)
	cDig	:= NnumPlas(cNumero)
	cNumero2:= cNumero+cDig
	DbSelectArea("SEE")
	RecLock("SEE",.F.)
		Replace EE_FAXATU With Soma1(cNumero,Len(SEE->EE_FAXATU))
	SEE->( MsUnlock() )
	_cRet := cNumero2
Else
	_cRet := SE1->E1_NUMBCO
EndIf	

Return(_cRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºFuncao    ³ NNUMPLAS º Autor ³ Gines              º Data ³  11/05/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Calculo do Digito Verificador Codigo de Barras - MOD(11)   º±±
±±º          ³ Pesos (2 a 9)                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

//Continua processo de analise do digito do Santander
Static Function NnumPlas(_cCampo)

Local _nCnt   := 0
Local _nPeso  := 2
Local _nJ     := 1
Local _nResto := 0
For _nJ := Len(_cCampo) To 1 Step -1
	_nCnt  := _nCnt + Val(Substr(_cCampo,_nJ,1))*_nPeso
	_nPeso := _nPeso + 1
	If _nPeso > 9
		_nPeso := 2
	EndIf
Next _nJ
_nResto := (_nCnt%11)
If _nResto == 0 .Or. _nResto == 1 
	_nDig := '0'
ElseIf _nResto == 10
	_nDig := '1'
Else
	_nResto := 11-_nResto
	_nDig   := Str(_nResto,1)
EndIf

Return(_nDig)

// Função para calcular o Digito do Nosso Numero 399
Static Function Nosso399()

Private cNumero	:=SPACE(12)
Private cDig	:=SPACE(01)
If Empty(SE1->E1_NUMBCO)
	//dbSelectArea("SEE")
	//DbSetOrder(1)
	//DbSeek(xFilial("SEE")+_cBanco+_cAgencia+_cConta+"R",.T.)
	
	cNumero := Strzero(Val(Substr(SEE->EE_FAXATU,3,10)),10)
//	cNumero:= Strzero(val(StrZero(Val(SEE->EE_FAXATU),Len(SEE->EE_FAXATU))),10)
	cDig	:= NnumPla(cNumero)
	cNumero2:= cNumero+cDig
	DbSelectArea("SEE")
	RecLock("SEE",.F.)
		//Replace EE_FAXATU With Soma1(cNumero,Len(SEE->EE_FAXATU))
		Replace EE_FAXATU With StrZero(Val(Soma1(cNumero)),12)
	SEE->( MsUnlock() )             
	_cRet := cNumero2
Else
	_cRet := SE1->E1_NUMBCO
EndIf	

Return(_cRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºFuncao    ³ NNUMPLA  º Autor ³ Eduardo / Valdemir º Data ³  11/05/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Calculo do Digito Verificador Codigo de Barras - MOD(11)   º±±
±±º          ³ Pesos (2a7) Continua processo de analise do digito do Hsbc º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹*/

Static Function NnumPla(_cCampo)

Local _nCnt   := 0
Local _nPeso  := 2
Local _nJ     := 1
Local _nResto := 0
For _nJ := Len(_cCampo) To 1 Step -1
	_nCnt  := _nCnt + Val(SUBSTR(_cCampo,_nJ,1))*_nPeso
	_nPeso :=_nPeso+1
	If _nPeso > 7
		_nPeso := 2
	EndIf
Next _nJ
_nResto := (_nCnt%11)
If _nResto == 0 .Or. _nResto == 1 
	_nDig := '0'
//Elseif _nResto == 10
//	_nDig:='1'
Else
	_nResto := 11-_nResto
	_nDig   := Str(_nResto,1)
EndIf

Return(_nDig)

// Função para calcular o Digito do Nosso Numero 237
Static Function Nosso237()

Local _xCart      := ""
Local _xNosso_num := ""
Local _xVariavel  := ""
Local _nPeso      := 2
Local _cResult    := ""
Local _nFator     := 0
Local _nVez

DbSelectArea("SEE")
RecLock("SEE",.F.)
SEE->EE_FAXATU := Soma1(SEE->EE_FAXATU,11)
MsUnlock()
_xCart    	:= Substr(StrZero(Val(SEE->EE_CODCART),3),2,2)
_xNosso_num := StrZero(Val(SEE->EE_FAXATU),11)
_xVariavel	:= _xCart+_xNosso_num
_nPeso := 2
_nFator:= 0
_nResto:= 0
For _nVez := Len(_xVariavel) To 1 Step -1
	_nFator += Val(Substr(_xVariavel,_nVez,1))*_nPeso
	_nPeso  := If(_nPeso<7,_nPeso+1,2)
Next
_nResto := Mod(_nFator,11)
If _nResto = 1
	_cResult := "P"
ElseIf _nResto = 0
	_cResult := "0"
Else
	_nResto  := 11-_nResto
	_cResult := Str(_nResto,1)
EndIf

Return(_xNosso_num+_cResult)

// Função para calcular o Digito Verrificador da Linha Digitavel
Static Function _fDigVer2(_cCampo2,_cBanco)

Local _nVez,_nVez1,_nFator,_nPeso,_nReturn,_nResult,_cResult
If _cBanco == "033" // Santander
	_nFator := 0
	_nPeso  := 2
	_nReturn:= 0
	_cCampo := _cCampo2
	For _nVez := Len(_cCampo) To 1 Step -1
		_nResult := Val(Substr(_cCampo,_nVez,1))*_nPeso
		_cResult := Strzero(_nResult,2)
		_nFator  += Val(Substr(_cResult,1,1))
		_nFator  += Val(Substr(_cResult,2,1))
		_nPeso   := If(_nPeso==2,1,2)
	Next	
	_nReturn := Mod(_nFator,10)
	If _nReturn > 0
		_nReturn := 10-_nReturn
	Else
		_nReturn := 0
	EndIf
ElseIf _cBanco == "399" // Hsbc
	_nFator := 0
	_nPeso  := 2
	_nReturn:= 0
	_cCampo := _cCampo2
	For _nVez := Len(_cCampo) To 1 Step -1
		_nResult := Val(Substr(_cCampo,_nVez,1))*_nPeso
		_cResult := Strzero(_nResult,2)
		_nFator  += Val(Substr(_cResult,1,1))
		_nFator  += Val(Substr(_cResult,2,1))
		_nPeso   := If(_nPeso==2,1,2)
	Next	
	_nReturn := Mod(_nFator,10)
	If _nReturn > 0
		_nReturn := 10-_nReturn
	Else
		_nReturn := 0
	EndIf
EndIf

Return Str(_nReturn,1)

// Função para calcular o Digito Verificador da Linha Digitavel
Static Function _fDigVer3(_ccampo3,_cBanco)

Local _nVez,_nVez1,_nFator,_nPeso,_nReturn,_nResult,_cResult
If _cBanco == "033" // Banespa
	_nFator := 0
	_nPeso  := 2
	_nReturn:= 0
	_cCampo := _ccampo3
	For _nVez := Len(_cCampo) To 1 Step -1
		_nResult := Val(Substr(_cCampo,_nVez,1))*_nPeso
	 	_cResult := Strzero(_nResult,2)
		_nFator  += Val(Substr(_cResult,1,1))
		_nFator  += Val(Substr(_cResult,2,1))
		_nPeso   := If(_nPeso==2,1,2)
	Next
	_nReturn := Mod(_nFator,10)
	If _nReturn > 0
		_nReturn := 10-_nReturn
	EndIf
ElseIf _cBanco == "399" // Hsbc
	_nFator := 0
	_nPeso  := 2
	_nReturn:= 0
	_cCampo := _ccampo3
	For _nVez := Len(_cCampo) To 1 Step -1
		_nResult := Val(Substr(_cCampo,_nVez,1))*_nPeso
		_cResult := Strzero(_nResult,2)
		_nFator  += Val(Substr(_cResult,1,1))
		_nFator  += Val(Substr(_cResult,2,1))
		_nPeso   := If(_nPeso==2,1,2)
	Next
	_nReturn := Mod(_nFator,10)
	If _nReturn > 0
		_nReturn := 10-_nReturn
	EndIf
EndIf

Return Str(_nReturn,1)

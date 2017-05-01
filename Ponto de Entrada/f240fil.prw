#Include "Rwmake.ch" 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF240FIL   บAutor  ณEduardo Augusto     บ Data ณ  07/12/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada para filtrar os titulos do contas a pagar บฑฑ
ฑฑบ          ณ conforme modelo e tipo de pagamento do bordero.			  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRotina    ณ Ponto de entrada da rotina FINA090						  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบUso       ณ Siva										  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/                                                                

User Function F240fil()                                                                       

SetPrvt("_cFiltro")

_cFiltro:=""
If cModPgto == "30" 												// Modelo "Pagametno de Boletos mesmo banco"
   If Alltrim(cPort240) $ "001/033/341/353/422/745" 				// Banco do Brasil/Santander/Itau/Santander/Safra/Citibank
      _cFiltro := " SUBS(E2_CODBAR,1,3)==" + "'" + cPort240 + "'"
   Else   
      _cFiltro := " !EMPTY(E2_CODBAR) "
   EndIf                                                                                                  
   _cFiltro += " .AND. SUBS(E2_CODBAR,1,1)<>'8' "  

ElseIf cModPgto == "31" 											// Modelo "Pagamento de Boletos outros bancos" 
   _cFiltro := " !EMPTY(E2_CODBAR)"   
   If Alltrim(cPort240) $ "001/033/341/353/422/745" 				// Banco do Brasil/Santander/Itau/Santander/Safra/Citibank
      _cFiltro += " .AND. SUBS(E2_CODBAR,1,3)<>" + "'" + cPort240 + "'"
   _cFiltro += " .AND. SUBS(E2_CODBAR,1,1)<>'8' "
   ElseIf Alltrim(cPort240) == "237" 								// Banco do Bradesco
      _cFiltro += " .AND. SUBS(E2_CODBAR,1,1)<>'8' "
   EndIf
ElseIf cModPgto == "01"
   _cFiltro := " Empty(E2_CODBAR)  .AND. (Alltrim(SA2->A2_XTPCONT) == '1') .AND. " 
   _cFiltro += "  GetAdvFval('SA2','A2_BANCO',xFilial('SA2')+E2_FORNECE+E2_LOJA,1)  ==" + " '" + cPort240 + "'" 
ElseIf cModPgto == "05"
   _cFiltro := " Empty(E2_CODBAR)  .AND. (Alltrim(SA2->A2_XTPCONT) == '2') .AND.  " 
   _cFiltro += "  GetAdvFval('SA2','A2_BANCO',xFilial('SA2')+E2_FORNECE+E2_LOJA,1)  ==" + " '" + cPort240 + "'" 
ElseIf cModPgto == "03"  											// DOC "C" - Outra titularidade
   _cFiltro := " Empty(E2_CODBAR) .AND. "// .AND. "
   If Alltrim(cPort240) $ "001/033/341/353/422/745" 				// Banco do Brasil/Santander/Itau/Santander/Safra/Citibank
      _cFiltro +=  " E2_SALDO < 0.01 .AND. "  
   EndIf
   _cFiltro += " (  !Empty(GetAdvFval('SA2','A2_BANCO',xFilial('SA2')+E2_FORNECE+E2_LOJA,1))  "
   _cFiltro += "  .AND. GetAdvFval('SA2','A2_BANCO'  ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1)  <>" + "'" + cPort240 + "'  )"
ElseIf cModPgto == "41" .Or. cModPgto == "43" 						// TED 41=Outra titularidade / 43=Mesma titularidade
   _cFiltro := " Empty(E2_CODBAR) .AND. " 
   If cPort240 == "341"                                         
      _cFiltro += " E2_SALDO > 0.01 .AND. "   
   EndIf
   _cFiltro += " (  !Empty(GetAdvFval('SA2','A2_BANCO',xFilial('SA2')+E2_FORNECE+E2_LOJA,1))  "
   _cFiltro += "  .AND. GetAdvFval('SA2','A2_BANCO'  ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1)  <>" + "'" + cPort240 + "'  )"  
   
ElseIf cModPgto == "08" 											// TED 08 = TED Bradesco
   _cFiltro := " Empty(E2_CODBAR) .AND. " 
   If cPort240 == "237"                                         
      _cFiltro += " E2_SALDO >= 0.01 .AND. "   
   EndIf
   _cFiltro += " (  !Empty(GetAdvFval('SA2','A2_BANCO',xFilial('SA2')+E2_FORNECE+E2_LOJA,1))  "
   _cFiltro += "  .AND. GetAdvFval('SA2','A2_BANCO'  ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1)  <>" + "'" + cPort240 + "'  )"   
     
ElseIf cModPgto == "11"  											//--- Pagamento de contas de consumo e tributos com codigo de barras
	If	Alltrim(cPort240) $ "001/033/353" 
		If 	cTipoPag $ "22/98"										// Tipo: Pagamento Tributos Santander / Banco do Brasil
		   	_cFiltro := " E2_TIPO == 'PIS' .OR. E2_TIPO == 'COF' .OR. E2_TIPO == 'CSL' .OR. E2_TIPO == 'IPI' .OR. E2_TIPO == 'IRP' .OR. E2_TIPO == 'GNR' .OR. E2_TIPO == 'ICM' .OR. E2_TIPO == 'INS' .OR. E2_TIPO == 'IRF' .AND. !EMPTY(E2_CODBAR) .AND. SUBS(E2_CODBAR,1,1)=='8' " // E2_TIPO IN ('GNR','PIS','COF','CSL','INS','IRP','ICM') "// .AND. !EMPTY(E2_CODBAR) .AND. SUBS(E2_CODBAR,1,1)=='8'"
		Else
			MsgAlert( "Tipo de pagamento incompatํvel com o Banco do Brasil e Santander. Favor utilizar os tipos: 22 (Santander) ou 98 (Banco do Brasil).")
		EndIf
	EndIf
ElseIf cModPgto == "13"  //--- Concessionarias
	If	cPort240 == "341" 
		If 	cTipoPag == "20"	// Tipo: Pagamento
			_cFiltro := " !EMPTY(E2_CODBAR) .AND. SUBS(E2_CODBAR,1,1)=='8'"
		Else
			MsgAlert( "Tipo de pagamento incompatํvel com o banco 341-Itau๚. Favor utilizar o tipo 20 (Fornecedores).")
		EndIf
	EndIf
ElseIf cModPgto == "18"  //--- Darf Simples - DAS - Selecionar com codigo de retencao e tipo TX              
	_cFiltro := " Str(Val(E2_ESCRT)) == '6106' .AND. E2_TIPO == 'DAS'"
ElseIf cModPgto == "19"  //--- ISS  
	If	cPort240 == "341" // Itau
		If 	cTipoPag == "22"	// Tipo: Pagamento Tributos
			_cFiltro := " E2_TIPO == 'ISS' .AND. !EMPTY(E2_CODBAR) .AND. SUBS(E2_CODBAR,1,1)=='8'"
		EndIf
	EndIf
ElseIf Alltrim(cModPgto) == "16"  //--- DARF Normal
   	If	Alltrim(cPort240) $ "001/033/341/353" 
		If 	cTipoPag $ "22/98"	// Tipo: Pagamento Tributos Santander / Banco do Brasil
   			_cFiltro := " !Empty(E2_ESCRT) .AND. EMPTY(E2_CODBAR) .AND. E2_TIPO == 'PIS' .OR. E2_TIPO == 'COF' .OR. E2_TIPO == 'CSL' .OR. E2_TIPO == 'IPI' .OR. E2_TIPO == 'IRP' "
   		EndIf
   EndIf
ElseIf Alltrim(cModPgto) == "17"  //--- DARF Normal
   	If	Alltrim(cPort240) $ "001/033/341/353" 
		If 	cTipoPag $ "22/98"	// Tipo: Pagamento Tributos Santander / Banco do Brasil
   			_cFiltro := " !Empty(E2_ESCRT) .AND. EMPTY(E2_CODBAR) .AND. E2_TIPO == 'INS' .AND. !Empty(E2_XCOMPET)"       
   		EndIf
   EndIf
ElseIf Alltrim(cModPgto) == "21"  //--- DARJ
   _cFiltro := " !Empty(E2_ESCRT) .AND. EMPTY(E2_CODBAR) .AND. E2_TIPO == 'IRP'"
ElseIf Alltrim(cModPgto) == "22"  //--- GARE
   	If	Alltrim(cPort240) $ "001/033/341/353" 
		If 	cTipoPag $ "22/98"	// Tipo: Pagamento Tributos Santander / Banco do Brasil
   			_cFiltro := " !Empty(E2_ESCRT) .AND. EMPTY(E2_CODBAR) .AND. E2_TIPO == 'ICM'" 
  		EndIf
  EndIf
ElseIf Alltrim(cModPgto) == "26"  //--- LICENCIAMENTO
	If	cPort240 <> "341" // Nao pode ser Itau
		If 	Alltrim(cTipoPag) $ "22/98"	// Tipo: Pagamento Tributos
			_cFiltro := " E2_TIPO == 'LIC' .AND. !EMPTY(E2_CODBAR) .AND. SUBS(E2_CODBAR,1,1)=='8'"
		EndIf
	EndIf
ElseIf Alltrim(cModPgto) $ "25/27"  //--- IPVA/DPVAT
	If	Alltrim(cPort240) $ "001/033/341/353" 
		If 	Alltrim(cTipoPag) $ "22/98"	// Tipo: Pagamento Tributos
			_cFiltro := " E2_TIPO == 'IPV' .OR. E2_TIPO == 'DPV' .AND. !EMPTY(E2_CODBAR) .AND. SUBS(E2_CODBAR,1,1)=='8'"
		EndIf
	EndIf
ElseIf cModPgto == "35"  //--- FGTS
	If	cPort240 == "341" // Itau
		If 	cTipoPag == "22"	// Tipo: Pagamento Tributos
			_cFiltro := " E2_TIPO == 'FGT' .AND. !EMPTY(E2_CODBAR) .AND. SUBS(E2_CODBAR,1,1)=='8'"
		EndIf
	EndIf
ElseIf cModPgto == "91"  //--- GNRE e TRibutos com codigo de barras
	If	cPort240 == "341" // Itau
		If 	cTipoPag == "22"	// Tipo: Pagamento Tributos
			_cFiltro := " E2_TIPO == 'GNR' .OR. E2_TIPO == 'TX ' .OR. E2_TIPO == 'IRF' .OR. E2_TIPO == 'PIS' .AND. !EMPTY(E2_CODBAR) .AND. SUBS(E2_CODBAR,1,1)=='8'"
		EndIf
	EndIf
EndIf   

Return(_cFiltro)        

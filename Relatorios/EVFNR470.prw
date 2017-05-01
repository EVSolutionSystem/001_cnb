#include "PROTHEUS.CH"
#DEFINE REC_NAO_CONCILIADO 1                                 
#DEFINE REC_CONCILIADO		2
#DEFINE PAG_NAO_CONCILIADO 3
#DEFINE PAG_CONCILIADO		4

Static lFWCodFil := FindFunction("FWCodFil")
Static lE5TXMoeda

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FINR470  ³ Autor ³ Valdemir/Eduardo      ³ Data ³ 01/10/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Extrato Banc rio.		 					              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR470(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function EVFNR470(paPar)
Local lExec			:= .T.
Private lTReport	:= .F.

/*
Verifica se o ambiente esta configurada para as rotina de "modelo II" */
If cPaisLoc == "ARG" .And. FindFunction("FinModProc")
	lExec := FinModProc()
Else
	lExec := .T.
Endif
If lExec
	If FindFunction("TRepInUse") .And. TRepInUse() 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Interface de impressao                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lTReport := .T.
		oReport := ReportDef(paPar)                         
		If !Empty(oReport:uParam) .AND. !isblind()
			Pergunte(oReport:uParam,.F.)
		EndIf
		oReport:PrintDialog()
	Else
	    //Return FinR470R3() // Executa versão anterior do fonte
	Endif
Endif

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Valdemir / Eduardo    ³ Data ³01/10/15  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef(paPar)

Local oReport 
Local oBanco
Local oMovBanc           
Local nTamChave	 := TamSX3("E5_PREFIXO")[1]+TamSX3("E5_NUMERO")[1]+TamSX3("E5_PARCELA")[1] + 3

AjustaSX1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros	 			        ³
//³ mv_par01				// Banco 							³
//³ mv_par02				// Agencia							³
//³ mv_par03				// Conta 							³
//³ mv_par04				// a partir de 						³
//³ mv_par05				// ate								³
//³ mv_par06				// Qual Moeda						³
//³ mv_par07				// Demonstra Todos/Conciliados/Nao Conc.³
//³ mv_par08				// Linhas por Pagina  ?			    ³
//³ mv_par09				// Converte Valores pelas ?        
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
fAtuSX1(paPar)
Pergunte("FIN470",.F.)

MV_PAR01 := paPar[1]
MV_PAR02 := paPar[2]
MV_PAR03 := paPar[3]
MV_PAR04 := ddatabase
MV_PAR05 := MV_PAR04
MV_PAR06 := 1
MV_PAR07 := 1
MV_PAR08 := 55
MV_PAR09 := 1
MV_PAR10 := 1

MV_DATADE  := MV_PAR04
MV_DATAATE := MV_PAR04
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na admin		 da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
//"EXTRATO BANCARIO"
//"Este programa ir  emitir o relat¢rio de movimenta‡”es" "banc rias em ordem de data. Poder  ser utilizado para""conferencia de extrato."
oReport := TReport():New("FINR470","EXTRATO BANCARIO","FIN470", {|oReport| ReportPrint(oReport)},"Este programa ir  emitir o relat¢rio de movimenta‡”es"+" "+"banc rias em ordem de data. Poder  ser utilizado para"+" "+"conferencia de extrato.") 
//desabilita o botao GESTAO CORPORATIVA do relatório
oReport:SetUseGC(.f.)
oBanco := TRSection():New(oReport,"Dados Bancarios",{"SA6"},/*[Ordem]*/ )//"Dados Bancarios"
TRCell():New(oBanco,"A6_COD" 		,"SA6","BANCO",,23,.F.)//             
TRCell():New(oBanco,"A6_AGENCIA"	,"SA6","   AGENCIA ") //
TRCell():New(oBanco,"A6_NUMCON"	,"SA6","   CONTA ")//
TRCell():New(oBanco,"SALDOINI"	,		,"SALDO INICIAL",,20,,)//

oMovBanc := TRSection():New(oBanco,"Movimentos Bancarios",{"SE5"})//"Movimentos Bancarios"
TRCell():New(oMovBanc,"E5_DTDISPO" ,"SE5","DATA"	,/*Picture*/,13,/*lPixel*/,{|| DtoC(E5_DTDISPO)}) //"DATA"
TRCell():New(oMovBanc,"E5_HISTOR"	,"SE5","OPERACAO"	,,TamSX3("E5_HISTOR")[1]+3,,{|| SubStr(E5_HISTOR,1,TamSX3("E5_HISTOR")[1])})//
TRCell():New(oMovBanc,"E5_NUMCHEQ"	,"SE5","DOCUMENTO"	,,36,,{|| If(Len(Alltrim(E5_DOCUMEN)) + Len(Alltrim(E5_NUMCHEQ)) > 35,;  //"DOCUMENTO"
																		Alltrim(SUBSTR(E5_DOCUMEN,1,20)) + If(!empty(Alltrim(E5_DOCUMEN)),"-"," ") + Alltrim(E5_NUMCHEQ ),;
																		If(Empty(E5_NUMCHEQ),E5_DOCUMEN,E5_NUMCHEQ))})
TRCell():New(oMovBanc,"PREFIXO/TITULO"	,"SE5","PREFIXO/TITULO"	,,nTamChave+5,,{|| If(E5_TIPODOC="CH",ChecaTp(E5_NUMCHEQ+E5_BANCO+E5_AGENCIA+E5_CONTA),;
                                                                    E5_PREFIXO+If(Empty(E5_PREFIXO)," ","-")+E5_NUMERO+; //"PREFIXO/TITULO"
																	   	             If(Empty(E5_PARCELA)," ","-")+E5_PARCELA)})  

TRCell():New(oMovBanc,"E5_VALOR-ENTRAD","SE5"	,"ENTRADAS"		,,20)//"ENTRADAS"
TRCell():New(oMovBanc,"E5_VALOR-SAIDA" ,"SE5"	,"SAIDAS"	    ,,20)//"SAIDAS"

TRCell():New(oMovBanc,"SALDO ATUAL"		,"SE5"	,"SALDO ATUAL"	,,20,,{|| nSaldoAtu})//"SALDO ATUAL"
TRCell():New(oMovBanc,"TAXA"			,		,"CONCILIADOS"	,,12)//"CONCILIADOS"
TRCell():New(oMovBanc,"x-CONCILIADOS"	,"SE5"	,"CONCILIADOS"	,,3)//"CONCILIADOS"

oTotal := TRSection():New(oMovBanc,"Totais",{"SE5"},/*[Ordem]*/ )//"Totais"

TRCell():New(oTotal,"DESCRICAO"		,,"DESCRICAO" 			,,30,,)//"DESCRICAO"
TRCell():New(oTotal,"NAOCONC"  		,,"NAO CONCILIADOS"  	,,20,,)//"NAO CONCILIADOS" 
TRCell():New(oTotal,"CONC"		 	,,"CONCILIADOS" 		,,20,,)//"CONCILIADOS"
TRCell():New(oTotal,"TOTAL" 	 	,,"TOTAL" 				,,20,,)//"TOTAL"

oTotal:SetLeftMargin(35)

Return(oReport)       

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³ Valdemir / Eduardo    ³ Data ³01/10/2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os  ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport)

Local oBanco	:= oReport:Section(1)
Local oMovBanc	:= oReport:Section(1):Section(1)    
Local oTotal	:= oReport:Section(1):Section(1):Section(1)
Local cAlias
Local lAllFil	:= .F.
Local cChave	:= ""
Local cAliasSA6	:= "SA6"
Local cAliasSE5	:= "SE5"
Local cSql1:= cSql2	:= ""
Local nMoeda	:= GetMv("MV_CENT"+(IIF(mv_par06 > 1 , STR(mv_par06,1),"")))            
Local lSpbInUse	:= SpbInUse()        
Local nSaldoAtu	:= 0    
Local cTabela14	:= ""   
Local nCol		:= 0      
Local aRecon 	:= {}     
Local nTotEnt	:= 0 
Local nTotSaida	:= 0    
Local nLimCred	:= 0     
Local nRecebNCon:= 0
Local nRecebConc:= 0   
Local cPictVlr	:=	tm(SE5->E5_VALOR,15,nMoeda)
Local nX
Local aTotais := {}
Local nLinReport 	:= 8
Local nLinPag		:= mv_par08 
Local cExpMda		:= ""
Local nCont 		:= 0
Local cCampos 		:= ""
Local nTaxa 		:= 0  
Local lMultSld    	:= (FindFunction( "FXMultSld" ) .AND. FXMultSld())
Local lMsmMoeda   	:= .F.
Local lGestao		:= Iif( lFWCodFil, FWSizeFilial() > 2, .F. )	// Indica se usa Gestao Corporativa
Local cAliasTmp
Local cFilSE5 := IIf(lGestao, FwFilial("SE5"), xFilial("SE5")) 
Local cFilSE8 := IIf(lGestao, FWFilial("SE8"), xFilial("SE8"))
Local	nSaldoIni	:=0
Local aAreaSE5
Local lTop := .t.
Local lOracle := "ORACLE"$Upper(TCGetDB())

#IFNDEF TOP
	Local cCondicao := ""
	Local cFiltSE5 := oReport:Section(1):GetAdvplExp("SE5")
	Local lTop		:= .f.
#ENDIF                       

Private nTxMoedBc := 0
Private nMoedaBco := 1

AAdd( aRecon, {0,0,0,0} )   

If !Empty(mv_par08)
	nLinPag := IIf(MV_PAR08>=80,80,MV_PAR08)
Else
	nLinPag := 80	
EndIf	

dbSelectArea("SA6")
dbSetOrder(1)
IF !(dbSeek(cFilial+mv_par01+mv_par02+mv_par03))
	Help(" ",1,"BCONOEXIST")
	Return
EndIF

nMoedaBco	:=	Max(A6_MOEDA,1)

// Carrega a tabela 14
cTabela14 := FR470Tab14() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Saldo de Partida 											 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE8")
dbSetOrder(1)			

If lTop .and. Mv_par10 == 2 .AND. FWModeAccess("SA6",3,) == 'C' .and. FWModeAccess("SE8",3,) == 'E' // recompor saldo por Banco

	cSaldo := GetNextAlias()
	lJan	:= month(mv_par04) == 1
	
	cQry :=	 "SELECT E8_FILIAL, E8_BANCO, E8_AGENCIA, E8_CONTA, E8_MOEDA, E8_DTSALAT, E8_SALATUA, E8_DTSALAN, E8_SALANT, E8_SALRECO, "
	cQry += " SUM(REC.E5_VALOR) - ( " 
	cQry +=	 "		SELECT SUM(PAG.E5_VALOR) "
	cQry += "		FROM " + RetSqlName("SE5") + " PAG " 
	cQry +=	 "			WHERE PAG.E5_FILIAL LIKE '" + AllTrim(xFilial("SA6")) + "%' "  
	cQry +=	 "				AND PAG.E5_BANCO 		= '" + mv_par01 + "' " 
	cQry +=	 "				AND PAG.E5_AGENCIA 	= '" + mv_par02 + "' "
	cQry +=	 "				AND PAG.E5_CONTA 		= '" + mv_par03 + "' "
	cQry +=	 "				AND PAG.E5_RECPAG 	= 'P' "
	cQry += "				AND PAG.E5_SITUACA = '' "
	If lOracle
		If lJan
			cQry += " AND SUBSTR(PAG.E5_DATA,5,2) = '12' AND SUBSTR(PAG.E5_DATA,1,4) = SUBSTR('" + DTOS(mv_par04) + "',1,4)-1 "
		Else
			cQry +=	 "				AND SUBSTR(PAG.E5_DATA,5,2) = SUBSTR('" + DTOS(mv_par04) + "',5,2)-1 AND SUBSTR(PAG.E5_DATA,1,4) = SUBSTR('" + DTOS(mv_par04) + "',1,4) "
		EndIf
	Else
		If lJan
			cQry += " AND SUBSTRING(PAG.E5_DATA,5,2) = '12' AND SUBSTRING(PAG.E5_DATA,1,4) = SUBSTRING('" + DTOS(mv_par04) + "',1,4)-1 "
		Else
			cQry +=	 "				AND SUBSTRING(PAG.E5_DATA,5,2) = SUBSTRING('" + DTOS(mv_par04) + "',5,2)-1 AND SUBSTRING(PAG.E5_DATA,1,4) = SUBSTRING('" + DTOS(mv_par04) + "',1,4) "
		EndIf
	EndIf 
	cQry +=	 "				AND PAG.D_E_L_E_T_ = '' "
	cQry +=	 "			) SLDINI, SUM(E8_SALRECO) VLREC "
	cQry +=	 "		FROM " + RetSqlName("SE5") + " REC, " + RetSqlName("SE8") + " SE8 "
	cQry +=	 "		WHERE REC.E5_FILIAL LIKE '" + AllTrim(xFilial("SA6")) + "%' "  
	cQry +=	 "			AND REC.E5_BANCO			= '" + mv_par01 + "' " 
	cQry += "			AND REC.E5_AGENCIA 		= '" + mv_par02 + "' "
	cQry += "			AND REC.E5_CONTA 			= '" + mv_par03 + "' "
	cQry += "			AND REC.E5_RECPAG 		= 'R' "
	cQry += "			AND REC.E5_SITUACA = '' "
	If lOracle
		If lJan
			cQry += " AND SUBSTR(REC.E5_DATA,5,2) = '12' AND SUBSTR(REC.E5_DATA,1,4) = SUBSTR('" + DTOS(mv_par04) + "',1,4)-1 "
		Else
			cQry += "			AND SUBSTR(REC.E5_DATA,5,2) = SUBSTR('" + DTOS(mv_par04) + "',5,2)-1 AND SUBSTR(REC.E5_DATA,1,4) = SUBSTR('" + DTOS(mv_par04) + "',1,4) "
		EndIf
	Else
		If lJan
			cQry += " AND SUBSTRING(REC.E5_DATA,5,2) = '12' AND SUBSTRING(REC.E5_DATA,1,4) = SUBSTRING('" + DTOS(mv_par04) + "',1,4)-1 "
		Else	
			cQry += "			AND SUBSTRING(REC.E5_DATA,5,2) = SUBSTRING('" + DTOS(mv_par04) + "',5,2)-1 AND SUBSTRING(REC.E5_DATA,1,4) = SUBSTRING('" + DTOS(mv_par04) + "',1,4) "
		EndIf
	EndIf
	cQry += "			AND REC.D_E_L_E_T_ = '' "
	cQry += "			AND E8_FILIAL LIKE '" + AllTrim(xFilial("SA6")) + "%' "
	cQry += "			AND E8_BANCO				= REC.E5_BANCO "
	cQry += "			AND E8_AGENCIA			= REC.E5_AGENCIA "
	cQry += "			AND E8_CONTA 				= REC.E5_CONTA "
	If lOracle
		If lJan
			cQry += " AND SUBSTR(E8_DTSALAT,5,2) = '12' AND SUBSTR(E8_DTSALAT,1,4) = SUBSTR('" + DTOS(mv_par04) + "',1,4)-1 "
		Else
			cQry += "			AND SUBSTR(E8_DTSALAT,5,2) = SUBSTR('" + DTOS(mv_par04) + "',5,2)-1 AND SUBSTR(E8_DTSALAT,1,4) = SUBSTR('" + DTOS(mv_par04) + "',1,4) "
		EndIf
	Else
		If lJan
			cQry += " AND SUBSTRING(E8_DTSALAT,5,2) = '12' AND SUBSTRING(E8_DTSALAT,1,4) = SUBSTRING('" + DTOS(mv_par04) + "',1,4)-1 "
		Else
			cQry += "			AND SUBSTRING(E8_DTSALAT,5,2) = SUBSTRING('" + DTOS(mv_par04) + "',5,2)-1 AND SUBSTRING(E8_DTSALAT,1,4) = SUBSTRING('" + DTOS(mv_par04) + "',1,4) "
		EndIf
	EndIf
	cQry += "			AND SE8.D_E_L_E_T_ = '' "
	cQry += "		GROUP BY E8_FILIAL, E8_BANCO, E8_AGENCIA, E8_CONTA, E8_MOEDA, E8_DTSALAT, E8_SALATUA, E8_DTSALAN, E8_SALANT, E8_SALRECO "
	
	cQry := ChangeQuery(cQry)
	
	dbSelectArea("SE8")
	dbCloseArea()

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), cSaldo, .T., .T.)

If mv_par07 == 1  //Todos
	nSaldoAtu:=Round(xMoeda((cSaldo)->SLDINI,nMoedaBco,mv_par06,SE8->E8_DTSALAT),nMoeda)
	nSaldoIni:=Round(xMoeda((cSaldo)->SLDINI,nMoedaBco,mv_par06,SE8->E8_DTSALAT),nMoeda)
ElseIf mv_par07 == 2 //Conciliados
	nSaldoAtu:=Round(xMoeda((cSaldo)->VLREC,nMoedaBco,mv_par06,SE8->E8_DTSALAT),nMoeda)
	nSaldoIni:=Round(xMoeda((cSaldo)->VLREC,nMoedaBco,mv_par06,SE8->E8_DTSALAT),nMoeda)
ElseIf mv_par07 == 3	//Nao Conciliados
	nSaldoAtu:=Round(xMoeda((cSaldo)->SLDINI-E8_SALRECO,nMoedaBco,mv_par06,SE8->E8_DTSALAT),nMoeda)
	nSaldoIni:=Round(xMoeda((cSaldo)->SLDINI-E8_SALRECO,nMoedaBco,mv_par06,SE8->E8_DTSALAT),nMoeda)
Endif	

	DbCloseArea(cSaldo)
								
Else
dbSeek(xFilial("SE8")+mv_par01+mv_par02+mv_par03+Dtos(mv_par04),.T.)   // filial + banco + agencia + conta
dbSkip(-1)

IF E8_FILIAL != xFilial("SE8") .Or. E8_BANCO!=mv_par01 .or. E8_AGENCIA!=mv_par02 .or. E8_CONTA!=mv_par03 .or. BOF() .or. EOF()
	nSaldoAtu:=0
	nSaldoIni:=0
Else
	If mv_par07 == 1  //Todos
		nSaldoAtu:=Round(xMoeda(E8_SALATUA,nMoedaBco,mv_par06,SE8->E8_DTSALAT),nMoeda)
		nSaldoIni:=Round(xMoeda(E8_SALATUA,nMoedaBco,mv_par06,SE8->E8_DTSALAT),nMoeda)
	ElseIf mv_par07 == 2 //Conciliados
		nSaldoAtu:=Round(xMoeda(E8_SALRECO,nMoedaBco,mv_par06,SE8->E8_DTSALAT),nMoeda)
		nSaldoIni:=Round(xMoeda(E8_SALRECO,nMoedaBco,mv_par06,SE8->E8_DTSALAT),nMoeda)
	ElseIf mv_par07 == 3	//Nao Conciliados
		nSaldoAtu:=Round(xMoeda(E8_SALATUA-E8_SALRECO,nMoedaBco,mv_par06,SE8->E8_DTSALAT),nMoeda)
		nSaldoIni:=Round(xMoeda(E8_SALATUA-E8_SALRECO,nMoedaBco,mv_par06,SE8->E8_DTSALAT),nMoeda)
	Endif	
Endif
EndIf

// Deve considerar todas as filiais para selecao dos movimentos na query
If lGestao
	lAllFil := Empty( FWFilial( "SA6" ) ) .And. !Empty( FWFilial( "SE5" ) )
Else
	lAllFil := Empty( xFilial("SA6") ) .And. !Empty( xFilial("SE5") )
EndIf
	
If lAllFil
	cChave	:= "DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA"
Else
	cChave  := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA"
EndIf

If ExistBlock("F470ALLF")
	lAllFil := ExecBlock("F470ALLF",.F.,.F.,{lAllFil})
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtragem do relatório                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP

	cAlias := GetNextAlias()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Transforma parametros Range em expressao SQL                            ³	
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MakeSqlExpr(oReport:uParam)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query do relatório      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oBanco:BeginQuery()	     
	
	If	lAllFil
		cOrder  := "%E5_DTDISPO,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_NUMCHEQ,E5_DOCUMEN,E5_PREFIXO,E5_NUMERO, SE5.R_E_C_N_O_%"
	Else
		cSql1	:=	"E5_FILIAL = '" + xFilial("SE5") + "'" + " AND "
		If Empty(cFilSE5) .and. !Empty(cFilSE8)
			cSql1	+=	"E5_FILORIG = '" + xFilial("SE8") + "'" + " AND "
		Endif
		cOrder  := "%E5_FILIAL,E5_DTDISPO,E5_BANCO,E5_AGENCIA,E5_CONTA,E5_NUMCHEQ,E5_DOCUMEN,E5_PREFIXO,E5_NUMERO%"
	EndIf           
	If lSpbInuse	                                                
		cSql1	+=	" E5_DTDISPO >=  '"     + DTOS(mv_par04) + "' AND"
		cSql1	+=	" ((E5_DTDISPO <= '"+ DTOS(mv_par05) + "') OR "
		cSql1	+=	"  (E5_DTDISPO >= '"+ DTOS(mv_par05) + "' AND "
		cSql1	+=	"  (E5_DATA    >= '"+ DTOS(mv_par04) + "' AND " 
		cSql1	+=	"   E5_DATA    <= '"+ DTOS(mv_par05) + "'))) AND"			
	Else			                                  
		cSql1	+=	" E5_DTDISPO >= '" + DTOS(mv_par04) + "' AND"
		cSql1	+=	" E5_DTDISPO <= '" + DTOS(mv_par05) + "' AND"
	EndIf                           
	If mv_par07 == 2
		cSql1	+=	" E5_RECONC <> ' ' AND "
	ElseIf mv_par07 == 3
		cSql1	+=	" E5_RECONC = ' ' AND " 
	EndIf

	cSql1 := "%"+cSql1+"%"
	cCampos := "E5_FILIAL,  E5_DTDISPO,	E5_HISTOR,	E5_NUMCHEQ,	E5_DOCUMEN, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPODOC, E5_FILORIG, "
	cCampos += "E5_RECPAG, 	E5_VALOR, 	E5_MOEDA, 	E5_VLMOED2, E5_CLIFOR, 	E5_LOJA, 	E5_RECONC, E5_TIPO, E5_SEQ, "
	cCampos += "SE5.R_E_C_N_O_ REGSE5, " 
	
	//Necessario incluir alguns campos de acordo com a alteracao realizada para a exibicao no relatorio dos dados corretos 
	//de um titulo a pagar quando baixado como normal e com cheque. 
	cCampos += "E5_BANCO, E5_AGENCIA, E5_CONTA, "
		
	cCampos += "A6_FILIAL, 	A6_COD, 	A6_NREDUZ, 	A6_AGENCIA, A6_NUMCON, A6_LIMCRED"
	If SE5->( FieldPos("E5_TXMOEDA") > 0 )
		cCampos += ", E5_TXMOEDA "
	EndIf
	cCampos := "%"+cCampos+"%"	  
	
	cExpMda	:= "%E5_MOEDA NOT IN " + FormatIn(cTabela14+"/DO","/") + "%"
	
	BeginSql Alias cAlias  
	Select	%Exp:cCampos%
	FROM 	%table:SE5% SE5
			LEFT JOIN %table:SA6% SA6 ON
			(E5_BANCO 	= A6_COD AND
			E5_AGENCIA	= A6_AGENCIA AND
			E5_CONTA 	= A6_NUMCON) 
	WHERE 	%Exp:cSql1%     
			A6_FILIAL 	= %xFilial:SA6% AND
			E5_BANCO 	= %Exp:mv_par01% AND
			E5_AGENCIA 	= %Exp:mv_par02% AND
			E5_CONTA 	= %Exp:mv_par03% AND		
			E5_TIPODOC NOT IN ('DC','JR','MT','CM','D2','J2','M2','V2','C2','CP','TL','BA','I2','EI') AND
			NOT (E5_MOEDA IN ('C1','C2','C3','C4','C5','CH') AND E5_NUMCHEQ = '               ' AND (E5_TIPODOC NOT IN('TR','TE'))) AND	
			NOT (E5_TIPODOC IN ('TR','TE') AND ((E5_NUMCHEQ BETWEEN '*              ' AND '*ZZZZZZZZZZZZZZ') OR (E5_DOCUMEN BETWEEN '*                ' AND '*ZZZZZZZZZZZZZZZZ' ))) AND
			NOT (E5_TIPODOC IN ('TR','TE') AND E5_NUMERO = '      ' AND %Exp:cExpMda% ) AND
			E5_SITUACA <> 'C' AND
			E5_VALOR   <> 0 AND
			NOT(E5_NUMCHEQ BETWEEN '*              ' AND '*ZZZZZZZZZZZZZZ') AND//NOT LIKE '*%' AND
			(E5_VENCTO <= %Exp:DTOS(mv_par05)% OR E5_VENCTO <= E5_DATA) AND 
			SE5.%notDel% AND
			SA6.%notDel%
	ORDER BY %exp:cOrder%			
	EndSql               
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Metodo EndQuery ( Classe TRSection )                                    ³
	//³Prepara o relatório para executar o Embedded SQL.                       ³
	//³ExpA1 : Array com os parametros do tipo Range                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oBanco:EndQuery(/*Array com os parametros do tipo Range*/)

	oMovBanc:SetParentQuery()

	cAliasSA6	:= cAlias
	cAliasSE5 	:= cAlias
#ELSE

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Transforma parametros Range em expressao Advpl                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	DbSelectArea("SE5")
	DbSetOrder(1)

	MakeAdvplExpr(oReport:uParam)
                   
	If	lAllFil
		cOrder  := "DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ"
	Else
		cOrder  := "E5_FILIAL+DTOS(E5_DTDISPO)+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ"
		cCondicao := 'E5_FILIAL == "' + xFilial("SE5")+'" .And.'
		If Empty(cFilSE5) .and. !Empty(cFilSE8)
			cCondicao += 'E5_FILORIG == "' + xFilial("SE8")+'" .And.'
		Endif
	EndIf           
	If lSpbInuse	                                                
		cCondicao	+=	" ((DTOS(E5_DTDISPO) <= '"+ DTOS(mv_par05) + "') .OR. "
		cCondicao	+=	"  (DTOS(E5_DTDISPO) >= '"+ DTOS(mv_par05) + "' .And. "
		cCondicao	+=	"  (DTOS(E5_DATA)    >= '"+ DTOS(mv_par04) + "' .And. " 
		cCondicao	+=	"   DTOS(E5_DATA)    <= '"+ DTOS(mv_par05) + "'))) .And. "			
	EndIf 
	cCondicao += 'DTOS(E5_DTDISPO) >= "' + DTOS(mv_par04) + '" .And. '
	cCondicao += 'DTOS(E5_DTDISPO) <= "' + DTOS(mv_par05) + '" .And. '
	cCondicao += 'E5_BANCO   == "' + mv_par01 + '" .And. '
	cCondicao += 'E5_AGENCIA == "' + mv_par02 + '" .And. '
	cCondicao += 'E5_CONTA   == "' + mv_par03 + '" .And. '
	cCondicao += 'E5_SITUACA <> "C" .And. '   //Cancelado
	cCondicao += 'E5_VALOR   <> 0 .And. '  
	cCondicao += '!(E5_TIPODOC $ "DC/JR/MT/CM/D2/J2/M2/C2/V2/CP/TL/BA/I2/EI") .And. '  
	cCondicao += '!(E5_MOEDA $ "C1/C2/C3/C4/C5/CH" .And. E5_NUMCHEQ = "               " .And. !(E5_TIPODOC $ "TR#TE")) .And.'
  	cCondicao += '(DTOS(E5_VENCTO) <= "' + DTOS(mv_par05) + '".Or. E5_VENCTO <= E5_DATA)'
	
	//Adiciona filtro do usuário
	If !Empty(cFiltSE5)
		cCondicao += ' .And. ' + cFiltSE5
   EndIf
                    
	oMovBanc:SetFilter( cCondicao, cOrder )

	oMovBanc:SetRelation( {|| xFilial((cAliasSE5))+(cAliasSA6)->(A6_COD+A6_AGENCIA+A6_NUMCON)},cAliasSA6,1,.T.)
	oMovBanc:SetParentFilter( {|cParam| (cAliasSE5)->(E5_BANCO+E5_AGENCIA+E5_CONTA) == cParam}, { || (cAliasSA6)->(A6_COD+A6_AGENCIA+A6_NUMCON) } )
                               
#ENDIF		

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cMoeda := Upper(GetMv("MV_MOEDA"+LTrim(Str(mv_par06))))

nTxMoeda := If(nTxMoedBc > 1, nTxMoedBc,RecMoeda(iif(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO),mv_par06))
    If alltrim(oReport:title()) == alltrim ('EXTRATO BANCARIO')
	   oReport:SetTitle(OemToAnsi("EXTRATO BANCARIO ENTRE" + " " + DTOC(mv_par04) + " e " + Dtoc(mv_par05) + " EM " + cMoeda))//"EXTRATO BANCARIO ENTRE " 
	Endif
oMovBanc:Cell("E5_VALOR-ENTRAD"	):SetPicture(tm(E5_VALOR,20,nMoeda))
oMovBanc:Cell("E5_VALOR-SAIDA"	):SetPicture(tm(E5_VALOR,20,nMoeda))    
oMovBanc:Cell("TAXA"	):SetPicture(tm(E5_VALOR,12,nMoeda))
oMovBanc:Cell("SALDO ATUAL"		):SetPicture(tm(E5_VALOR,20,nMoeda))

If lMultSld .And. !Empty((cAliasSE5)->E5_TXMOEDA)
	If (cAliasSE5)->E5_RECPAG == "P"
		lMsmMoeda := Posicione("SE2",1,xFilial("SE2")+(cAliasSE5)->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO),"E2_MOEDA") == mv_par06
	Else
		lMsmMoeda := Posicione("SE1",1,xFilial("SE1")+(cAliasSE5)->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO),"E1_MOEDA") == mv_par06
	EndIf
EndIf

oMovBanc:Cell("SALDO ATUAL"		):SetBlock({|| nSaldoAtu += Round(xMoeda(F470VlMoeda(cAliasSE5);
	,Iif((cPaisLoc <> "BRA" .And. ((cAliasSE5)->E5_TIPODOC $ MVRECANT+"|ES") .and. Empty((cAliasSE5)->E5_MOEDA)) ,1, nMoedaBco );
	,mv_par06;
	,iif(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO);
	,nMoeda + 1;
	,IIf(lMultSld, /**/ IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(cAliasSE5, nMoedaBco) ) /**/	,	Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA",RecMoeda((cAliasSE5)->E5_DTDISPO,1),nTxMoedBc)));
	,IIf(lMultSld,IIf(!lMsmMoeda,RecMoeda(IIf(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO),mv_par06),(cAliasSE5)->E5_TXMOEDA),Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA",RecMoeda((cAliasSE5)->E5_DTDISPO,mv_par06),nTxMoeda))));
	,nMoeda) * (If((cAliasSE5)->E5_RECPAG == 'R',1,-1)) })
	
oMovBanc:Cell("E5_VALOR-ENTRAD"	):SetHeaderAlign("RIGHT")           
oMovBanc:Cell("E5_VALOR-SAIDA"	):SetHeaderAlign("RIGHT")
oMovBanc:Cell("SALDO ATUAL"		):SetHeaderAlign("RIGHT")
oMovBanc:Cell("TAXA"		):SetHeaderAlign("CENTER")


// Se realiza controle de saldos em multiplas moedas
If lMultSld                      

	oMovBanc:Cell("E5_VALOR-ENTRAD"  ):SetBlock({|| If((cAliasSE5)->E5_RECPAG == "R", Round(xMoeda(F470VlMoeda(cAliasSE5),;
	nMoedaBco ,;
	mv_par06,;
	iif(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO),;
	nMoeda,;
	IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(cAliasSE5, nMoedaBco) ),;
	IIf(!lMsmMoeda,RecMoeda(IIf(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO),mv_par06),(cAliasSE5)->E5_TXMOEDA)),nMoeda), nil)})

	oMovBanc:Cell("E5_VALOR-SAIDA"   ):SetBlock({|| If((cAliasSE5)->E5_RECPAG == "P",;
			Round(xMoeda(F470VlMoeda(cAliasSE5),;
			nMoedaBco,;
			mv_par06,;
			iif(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO),;
			nMoeda,;
			IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(cAliasSE5, nMoedaBco) ),;
	        IIf(!lMsmMoeda, RecMoeda(IIf(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO),mv_par06), (cAliasSE5)->E5_TXMOEDA)),nMoeda),;
	        nil)})

Else
    
	oMovBanc:Cell("E5_VALOR-ENTRAD"  ):SetBlock({||If((cAliasSE5)->E5_RECPAG == "R", Round(xMoeda(F470VlMoeda(cAliasSE5);
		,Iif((cPaisLoc<>"BRA".And.((cAliasSE5)->E5_TIPODOC $ MVRECANT+"|ES") .and. Empty((cAliasSE5)->E5_MOEDA)),1, nMoedaBco );
		,mv_par06;
		,iif(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO);
		,nMoeda+1;
		,Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA", /**/ IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(cAliasSE5, nMoedaBco) ) /**/,nTxMoedBc));
		,Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA",RecMoeda(IIf(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO),mv_par06),nTxMoeda)));
		,nMoeda);
		,nil)})

	oMovBanc:Cell("E5_VALOR-SAIDA"   ):SetBlock({||; 
		If((cAliasSE5)->E5_RECPAG == "P", ;
			Round(	xMoeda(F470VlMoeda(cAliasSE5),Iif((cPaisLoc<>"BRA".And.((cAliasSE5)->E5_TIPODOC $ MVRECANT+"|ES") .and. Empty((cAliasSE5)->E5_MOEDA)),1, nMoedaBco );
							,mv_par06;
							,iif(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO);
							,nMoeda+1;
							,Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA", /**/ IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(cAliasSE5, nMoedaBco) ) /**/ ,nTxMoedBc));
			 				,Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc,if(cPaisLoc=="BRA",RecMoeda(IIf(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO),mv_par06),nTxMoeda));
		  			);
			,nMoeda);
	 	, nil);
  	})
     

EndIf

oMovBanc:Cell("x-CONCILIADOS"		):SetBlock({|| Iif(Empty((cAliasSE5)->E5_RECONC), " ", "x")})
oMovBanc:Cell("x-CONCILIADOS"		):SetTitle("")

If cPaisLoc <> "BRA"
    If cPaisLoc<>"ANG"
		If mv_par06 <> nMoedaBco .And. mv_par06 > 1
			oMovBanc:Cell("TAXA"):SetBlock({||If(nTxMoedBc > 1, nTxMoedBc, RecMoeda(iif(MV_PAR09==1,dDataBase,E5_DTDISPO),mv_par06))})
		Else
			oMovBanc:Cell("TAXA"):Disable()
		EndIf
	Else    
	    If mv_par06 <> nMoedaBco
	        If nMoedaBco>1
				oMovBanc:Cell("TAXA"):SetBlock({||If(nTxMoedBc > 1, nTxMoedBc, RecMoeda(E5_DTDISPO,nMoedaBco))})
			Else
				oMovBanc:Cell("TAXA"):SetBlock({||If(nTxMoedBc > 1, nTxMoedBc, IIf(!lMsmMoeda,RecMoeda(E5_DTDISPO,mv_par06),(cAliasSE5)->E5_TXMOEDA))})
			EndIf
		Else
			oMovBanc:Cell("TAXA"):Disable()
		EndIf
	EndIf
Else
	oMovBanc:Cell("TAXA"):Disable()
EndIf	

oBanco:SetLineStyle()
        
If cPaisLoc == "BRA"
	nLimCred := (cAliasSA6)->(A6_LIMCRED)
Else 
	If SA6->A6_MOEDA <> 1 .and. SA6->A6_MOEDA == mv_par06
		nLimCred := (cAliasSA6)->(A6_LIMCRED)
	Else 
		nLimCred := xMoeda((cAliasSA6)->A6_LIMCRED,SA6->A6_MOEDA,1,dDataBase)
	EndIf	
EndIf	

oBanco:Init()         

oBanco:Cell("SALDOINI"):SetBlock( { || Transform(nSaldoIni,tm(nSaldoIni,16,nMoeda)) } )
oBanco:Cell("SALDOINI"):SetHeaderAlign("RIGHT")

oMovBanc:OnPrintLine( {|| F470LinPag(nLinPag, @nLinReport)})

(cAliasSE5)->(dbEval({|| nCont++}))
(cAliasSE5)->(dbGoTop())

If (cAliasSE5)->(Eof())  
	oBanco:Cell("A6_COD"):SetBlock( {|| SA6->A6_COD +" - "+AllTrim(SA6->A6_NREDUZ)} )
	oBanco:Cell("A6_AGENCIA"):SetBlock( {|| SA6->A6_AGENCIA } )
	oBanco:Cell("A6_NUMCON"):SetBlock( {|| SA6->A6_NUMCON } )
	oBanco:PrintLine()
	oMovBanc:Init()
	oMovBanc:PrintLine()
	oMovBanc:Finish()
Else
	oBanco:Cell("A6_COD"):SetBlock( {|| (cAliasSA6)->A6_COD +" - "+AllTrim((cAliasSA6)->A6_NREDUZ)} )
	oReport:OnPageBreak( { || oBanco:PrintLine() } )	
EndIf	

oReport:SetMeter(nCont)

While !oReport:Cancel() .And. (cAliasSE5)->(!Eof())          					
     
	If oReport:Cancel()
		Exit
	EndIf	

	If oBanco:Cancel()
		Exit
	EndIf
	
	lFirst := .T.

	oMovBanc:Init()               
	While !oReport:Cancel() .And. !(cAliasSE5)->(Eof())
		If oReport:Cancel()
			Exit
		EndIf               

		oReport:IncMeter()		          
		
		// Posiciona no correspondente SE5 para permitir configuracoes condicionais de colunas
		#IFDEF TOP
			SE5->( dbGoTo( (cAliasSE5)->REGSE5 ) )
		#ELSE
			If (cAliasSE5)->E5_TIPODOC $ "TR/TE" .and. Empty((cAliasSE5)->E5_NUMERO)
				If !((cAliasSE5)->E5_MOEDA $ cTabela14)
					dbSkip()
					Loop
				Endif
			Endif
			If (cAliasSE5)->E5_TIPODOC $ "TR/TE" .and. (Substr((cAliasSE5)->E5_NUMCHEQ,1,1)=="*" .or. Substr((cAliasSE5)->E5_DOCUMEN,1,1) == "*" )
				dbSkip()
				Loop
			Endif
			If !Fr470Skip(mv_par01,mv_par02,mv_par03)
				(cAliasSE5)->(dbSkip())
				Loop
			EndIf	
		#ENDIF              

		// Em ambiente Mexico a informacao Troco nao esta sendo processada		
		If (cAliasSE5)->E5_MOEDA=="TC" .and. cPaisLoc=="MEX"
			dbSkip()
			Loop	
		Endif			
		
		nTxMoedBc 	:= 0 
        
        If (cAliasSE5)->E5_TIPODOC=="ES"
        	aAreaSE5 := (cAliasSE5)->( GetArea() )
        	cAliasTmp  :=Alias()
			cChave     := (cAliasSE5)->E5_FILIAL+(cAliasSE5)->E5_PREFIXO+(cAliasSE5)->E5_NUMERO+(cAliasSE5)->E5_PARCELA+(cAliasSE5)->E5_TIPO+(cAliasSE5)->E5_CLIFOR+(cAliasSE5)->E5_LOJA+(cAliasSE5)->E5_SEQ
        	
        	DbSelectArea("SE5")
        	DbSetOrder(7)    
        	DbGoTop()
        	
        	If DbSeek(cChave)
        		If SE5->E5_TIPODOC=="V2"
	        		RestArea( aAreaSE5 )
       				DbSelectArea(cAliasTmp)
	        		(cAliasSE5)->(dbSkip())	
	        		Loop
	        	EndIf
        	EndIf
			RestArea( aAreaSE5 )
        	DbSelectArea(cAliasTmp)

        EndIf
        
		If cPaisloc<>"BRA"
			nTaxa := TxMoeda(cAliasSE5, nMoedaBco)
			If mv_par09 == 1
				nTxMoedBc := 0 //RecMoeda(dDatabase,nMoedaBco)
			Else
				nTxMoedBc := nTaxa
			Endif
		EndIf

		oMovBanc:PrintLine()          

		If Empty((cAliasSE5)->E5_RECONC) .AND. (cAliasSE5)->E5_RECPAG == "R"			
			aRecon[1][REC_NAO_CONCILIADO] += Round(xMoeda( F470VlMoeda(cAliasSE5);
			,Iif((cPaisLoc<>"BRA".And.((cAliasSE5)->E5_TIPODOC $ MVRECANT+"|ES") .and. Empty((cAliasSE5)->E5_MOEDA)),1, nMoedaBco );
			,mv_par06;
			,iif(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO);
			,nMoeda+1;
			,IIf(lMultSld, /**/ IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(cAliasSE5, nMoedaBco) ) /**/ ,Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA", /**/ IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(cAliasSE5, nMoedaBco) ) /**/ ,nTxMoedBc)));
			,IIf(lMultSld,IIf(!lMsmMoeda,RecMoeda(IIf(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO),mv_par06),(cAliasSE5)->E5_TXMOEDA),Iif(nTxMoedBc > 1 ,nTxMoedBc, if(cPaisLoc=="BRA",RecMoeda((cAliasSE5)->E5_DTDISPO,mv_par06),nTxMoedBc))));
			,nMoeda)
		ElseIf E5_RECPAG == "R"			
			aRecon[1][REC_CONCILIADO] += Round(xMoeda(F470VlMoeda(cAliasSE5);
			,Iif((cPaisLoc<>"BRA".And.((cAliasSE5)->E5_TIPODOC $ MVRECANT+"|ES") .and. Empty((cAliasSE5)->E5_MOEDA)),1, nMoedaBco );
			,mv_par06;
			,iif(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO);                                                                          
			,nMoeda+1;
			,IIf(lMultSld,/**/IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(cAliasSE5, nMoedaBco) )/**/ ,Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA",/**/IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(cAliasSE5, nMoedaBco) ) /**/ ,nTxMoedBc)));
			,IIf(lMultSld,IIf(!lMsmMoeda,RecMoeda(IIf(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO),mv_par06),(cAliasSE5)->E5_TXMOEDA),Iif(nTxMoedBc > 1 ,nTxMoedBc, if(cPaisLoc=="BRA",RecMoeda((cAliasSE5)->E5_DTDISPO,mv_par06),nTxMoedBc))));
			,nMoeda)
		ElseIf Empty( E5_RECONC ) .AND. E5_RECPAG == "P"			
			aRecon[1][PAG_NAO_CONCILIADO] += Round(xMoeda(F470VlMoeda(cAliasSE5);
			,Iif((cPaisLoc<>"BRA".And.((cAliasSE5)->E5_TIPODOC $ MVRECANT+"|ES") .and. Empty((cAliasSE5)->E5_MOEDA)),1, nMoedaBco );
			,mv_par06;
			,iif(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO);
			,nMoeda+1;
			,IIf(lMultSld,/**/IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(cAliasSE5, nMoedaBco) )/**/,Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA", /**/ IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(cAliasSE5, nMoedaBco) ) /**/ ,nTxMoedBc)));
			,IIf(lMultSld,IIf(!lMsmMoeda,RecMoeda(IIf(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO),mv_par06),(cAliasSE5)->E5_TXMOEDA),Iif(nTxMoedBc > 1 ,nTxMoedBc, if(cPaisLoc=="BRA",RecMoeda((cAliasSE5)->E5_DTDISPO,mv_par06),nTxMoeda))));
			,nMoeda)
		ElseIf E5_RECPAG == "P"			
			aRecon[1][PAG_CONCILIADO] += Round(xMoeda(F470VlMoeda(cAliasSE5);
			,Iif((cPaisLoc<>"BRA".And.((cAliasSE5)->E5_TIPODOC $ MVRECANT+"|ES") .and. Empty((cAliasSE5)->E5_MOEDA)),1, nMoedaBco );
			,mv_par06;
			,iif(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO);
			,nMoeda+1;
			,IIf(lMultSld,/**/IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(cAliasSE5, nMoedaBco) )/**/,Iif(nTxMoedBc > 1 .And. cPaisLoc <> "BRA",nTxMoedBc, if(cPaisLoc=="BRA",/**/IIF(MV_PAR09 == 1, RecMoeda(dDatabase, nMoedaBco ), TxMoeda(cAliasSE5, nMoedaBco) )/**/,nTxMoedBc)));
			,IIf(lMultSld,IIf(!lMsmMoeda,RecMoeda(IIf(MV_PAR09==1,dDataBase,(cAliasSE5)->E5_DTDISPO),mv_par06),(cAliasSE5)->E5_TXMOEDA),Iif(nTxMoedBc > 1 ,nTxMoedBc, if(cPaisLoc=="BRA",RecMoeda((cAliasSE5)->E5_DTDISPO,mv_par06),nTxMoedBc))));
			,nMoeda)
		EndIf

		(cAliasSE5)->(dbSkip())
	EndDo       
	oMovBanc:Finish()        
	oReport:SkipLine()
EndDo
oBanco:Finish()    

AADD( aTotais ,{"SALDO INICIAL...........: ",,,nSaldoIni})//"SALDO INICIAL...........: "
AADD( aTotais ,{"ENTRADAS NO PERIODO.....: ",aRecon[1][REC_NAO_CONCILIADO],aRecon[1][REC_CONCILIADO],aRecon[1][REC_NAO_CONCILIADO] +  aRecon[1][REC_CONCILIADO]})//"ENTRADAS NO PERIODO.....: "
AADD( aTotais ,{"SAIDAS NO PERIODO ......: ",aRecon[1][PAG_NAO_CONCILIADO],aRecon[1][PAG_CONCILIADO],aRecon[1][PAG_NAO_CONCILIADO] +  aRecon[1][PAG_CONCILIADO] })//"SAIDAS NO PERIODO ......: "
AADD( aTotais ,{"LIMITE DE CREDITO.......: ",,,nLimCred})//"LIMITE DE CREDITO.......: "
AADD( aTotais ,{"SALDO ATUAL ............: ",,,nSaldoAtu += nLimCred})//"SALDO ATUAL ............: "

oTotal:Init()

oTotal:Cell("DESCRICAO"):HideHeader()
oTotal:Cell("NAOCONC"):SetHeaderAlign("CENTER")
oTotal:Cell("CONC"):SetHeaderAlign("CENTER")
oTotal:Cell("TOTAL"):SetHeaderAlign("CENTER")

For nX := 1 to 5
	oTotal:Cell("DESCRICAO"):SetBlock( { || aTotais[nX][1] } )
	oTotal:Cell("NAOCONC"):SetBlock( { || If(nX == 2 .Or. nX == 3,Transform(aTotais[nX][2],tm(aTotais[nX][2],16,nMoeda)),"")} )
	oTotal:Cell("CONC"):SetBlock( { || If(nX == 2 .Or. nX == 3,Transform(aTotais[nX][3],tm(aTotais[nX][3],16,nMoeda)),"")} )
	oTotal:Cell("TOTAL"):SetBlock( { || Transform(aTotais[nX][4],tm(aTotais[nX][4],16,nMoeda))} )
	If nX == 2 .Or. nX == 5
		oReport:SkipLine()
	EndIf
	oTotal:PrintLine()
Next

oReport:Title("EXTRATO BANCARIO") 
oTotal:Finish()

Return NIL          

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  | F470VlMoeda  ºAutor ³Valdemir/Eduardo  º Data ³ 01/10/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Retorno o campo de valor a ser utilizado para conversão    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ cAliasSE5												  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ nVlMoeda = Retorna o campo E5_VALOR ou E5_VLMOED2          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ EV Solucoes Inteligentes                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function F470VlMoeda(cAliasSE5)                                
Local nVlMoeda:=0
Local cMoeda                    
Local lSpbInUse := SpbInUse()                 

cMoeda := Iif((cPaisLoc<>"BRA" .And. ((cAliasSE5)->E5_TIPODOC $ MVRECANT+"|ES") .And. Empty((cAliasSE5)->E5_MOEDA)),1, nMoedaBco )

If cPaisLoc $ "ARG|COL|DOM|EQU|MEX|VEN" //Gravaçao do SE5 nas rotinas localizadas são diferentes do Brasil.
	If cMoeda <> 1 
	   If (mv_par06 == 1) .OR. (mv_par06 == cMoeda)
		    nVlMoeda := (cAliasSE5)->E5_VALOR
		Else 
			If (cAliasSE5)->E5_VLMOED2 > 0
			   nVlMoeda := (cAliasSE5)->E5_VLMOED2   
			Else
				nVlMoeda := (cAliasSE5)->E5_VALOR
			EndIf
		EndIf
	Else
		nVlMoeda := (cAliasSE5)->E5_VALOR
	EndIf

Else

	If lSpbInUse .And. !lTReport
   	cAliasSE5 := "TRB"
	EndIf
	
	If cMoeda <> 1 
	   nVlMoeda := (cAliasSE5)->E5_VALOR
	   //***********************************************
	   // Bloco comentado pois a movimentação bancaria *
	   // é sempre feita na moeda do banco.            *
	   //***********************************************	
	   /*If mv_par06 == 1 .and. (mv_par06 == cMoeda)
		    nVlMoeda := (cAliasSE5)->E5_VALOR
		Else  
			If (cAliasSE5)->E5_VLMOED2 > 0 .AND. !((cAliasSE5)->E5_TIPO $ MVRECANT ) // MOVIMENTO DE RA TEM COMPORTAMENTO DIFERENTE NA GRAVAÇÃO DA SE5
			   nVlMoeda := (cAliasSE5)->E5_VLMOED2   
			Elseif (cAliasSE5)->E5_TIPO $ MVRECANT .and. (cAliasSE5)->E5_RECPAG == "P" // MOVIMENTO DE RA TEM COMPORTAMENTO DIFERENTE NA GRAVAÇÃO DA SE5
				nVlMoeda := (cAliasSE5)->E5_VLMOED2   
			Else
				nVlMoeda := (cAliasSE5)->E5_VALOR
			EndIf
		EndIf*/
	Else
		nVlMoeda := (cAliasSE5)->E5_VALOR
	EndIf

Endif	
Return (nVlMoeda)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  | F470LinPag   ºAutor ³Valdemir/ Eduardo º Data ³ 01/10/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Faz a quebra de pagina de acordo com o parametro "Linhas   º±±
±±º          ³ por Pagina?" (mv_par08)                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ EXPL1 - Numero maximo de linhas definido no relatorio      º±±
±±º          ³ EXPL2 - Contador de linhas impressas no relatorio          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ nil                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ EV Solucoes Inteligentes                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function F470LinPag(nLinPag, nLinReport)

nLinReport++

If nLinReport > (nLinPag + 8)
	oReport:EndPage()
	nLinReport := 9
EndIf

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSX1 ºAutor  ³Valdemir / Eduardo  º Data ³01/10/2015   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Insere novas perguntas ao sx1                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINA040                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()

Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}
Local aArea := GetArea()

Aadd( aHelpPor, "Informe o numero de linhas que serao "    )
Aadd( aHelpPor, "impressas .     "    )

Aadd( aHelpSpa, "Informe el numero de lineas que se "    )
Aadd( aHelpSpa, "imprimiran.      "    )

Aadd( aHelpEng, "Enter the number of lines to be "    )
Aadd( aHelpEng, "printed .  "    )

PutSx1( "FIN470", "08","Linhas por Pagina  ?","Lineas por Pagina  ?","Lines per Page  ?","mv_ch8","N",2,0,0,"G","","","","",;
	"mv_par08"," ","","","55","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

//Incluso pergunta para considerar a taxa contratada ou taxa da data base	
Aadd( aHelpPor, "Selecione qual a taxa sera utilizada "    )
Aadd( aHelpPor, "para a conversao do valores .     "    )
Aadd( aHelpSpa, "Seleccione la tasa que se utilisara "    )
Aadd( aHelpSpa, "para la conversion de los valores . "    )
Aadd( aHelpEng, "Select the rate to be used in order "    )
Aadd( aHelpEng, "to convert values  .  "    )

PutSx1( "FIN470", "09","Converte valores pela  ?","Conv. valores por la","Convert values by ?","mv_ch9","C",2,0,0,"C","","","","",;
	"mv_par09","Data Base","Tasa dia","Daily Rate","","Data Movimento","Tasa Movimiento","Movement Rate","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	
PutSX1Help("P.FIN47009.",aHelpPor,aHelpEng,aHelpSpa,.T.)		
	
aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

//Incluso pergunta para considerar a taxa contratada ou taxa da data base	
Aadd( aHelpPor, "Considerado para compôr o Saldo Inicial."    )
Aadd( aHelpPor, "1- Filial: mov. bancários da filial;"    ) 
Aadd( aHelpPor, "2- Banco: todos os mov. do Banco"    ) 
Aadd( aHelpPor, " selecionado."    ) 
Aadd( aHelpSpa, "Se considera para compner el Saldo"    )
Aadd( aHelpSpa, " inicial."    )
Aadd( aHelpSpa, "1- Sucursal: mov. bancarios de la "    )
Aadd( aHelpSpa, "sucursal;"    )
Aadd( aHelpSpa, "2- Banco: todos los mov. del banco que "    )
Aadd( aHelpSpa, "se selecciono."    )
Aadd( aHelpEng, ""    )
Aadd( aHelpEng, ""    )
Aadd( aHelpEng, ""    )

	

PutSx1( "FIN470", "10",/*STR0041*/"Saldo Inicial p/ ?","¿Saldo inicial p/ ?","Initial balance for","mv_chA","C",1,0,0,"C","","","","",;
	"mv_par10",/*STR0042*/"Filial","Sucursal","","",/*STR0043*/"Banco","Banco","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	
	
PutSX1Help("P.FIN47010.",aHelpPor,aHelpEng,aHelpSpa,.T.)			
	


If cPaisLoc == "COL"
	DbSelectArea("SX1")
	dbSetOrder(1)
	If SX1->( MsSeek( PadR("FIN470", Len(SX1->X1_GRUPO) ) + "06" ) )//Dbseek(cteste) 
		RecLock("SX1",.F.)
		Replace  X1_VALID With "VerifMoeda(mv_par06)"
		MsUnlock()
	EndIf 	
ENDIF
RestArea(aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINR470   ºAutor  ³ Valdemir / Eduardo º Data ³  01/10/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carrega e retorna moedas da tabela 14                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ EV Solucoes Inteligentes                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FR470Tab14()

Local cTabela14 := ""

SX5->(DbSetOrder(1))
SX5->(MsSeek(xFilial("SX5")+"14"))
While SX5->(!Eof()) .And. SX5->X5_TABELA == "14"
	cTabela14 += (Alltrim(SX5->X5_CHAVE) + "/")
	SX5->(DbSkip())
End	
cTabela14 += If(cPaisLoc=="BRA","","/$ ")         
If cPaisLoc == "BRA"
	cTabela14 := SubStr( cTabela14, 1, Len(cTabela14) - 1 )
EndIf	         

Return cTabela14 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fAtuSX1   ºAutor  ³ Valdemir / Eduardo º Data ³  01/10/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ EV Solucoes Inteligentes                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fAtuSX1(paPar)
Local _cPerg	:= "FIN470"
Local aArea 	:= GetArea()

	DbSelectArea("SX1")
	dbSetOrder(1)
	If SX1->( MsSeek( PadR("FIN470", Len(SX1->X1_GRUPO) ) + "04" ) )//Dbseek(cteste) 
		RecLock("SX1",.F.)
		Replace  X1_CNT01 With dtos(dDATABASE)
		MsUnlock()
	EndIf 	    
	If SX1->( MsSeek( PadR("FIN470", Len(SX1->X1_GRUPO) ) + "05" ) )//Dbseek(cteste) 
		RecLock("SX1",.F.)
		Replace  X1_CNT01 With dtos(dDATABASE)
		MsUnlock()
	EndIf 	    
	If SX1->( MsSeek( PadR("FIN470", Len(SX1->X1_GRUPO) ) + "01" ) )//Dbseek(cteste) 
		RecLock("SX1",.F.)
		Replace  X1_CNT01 With paPar[1]
		MsUnlock()
	EndIf 	    
	If SX1->( MsSeek( PadR("FIN470", Len(SX1->X1_GRUPO) ) + "02" ) )//Dbseek(cteste) 
		RecLock("SX1",.F.)
		Replace  X1_CNT01 With paPar[2]
		MsUnlock()
	EndIf 	    
	If SX1->( MsSeek( PadR("FIN470", Len(SX1->X1_GRUPO) ) + "03" ) )//Dbseek(cteste) 
		RecLock("SX1",.F.)
		Replace  X1_CNT01 With paPar[3]
		MsUnlock()
	EndIf 	    
	
	RestArea( aArea )

Return()

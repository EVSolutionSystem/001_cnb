#include "Protheus.ch"
#Include "topconn.ch"
#DEFINE cENTER  CHR(13) + CHR(10)

Static lFWCodFil := FindFunction("FWCodFil")

Static nLote

Static aPswUser		:= nil
Static aPswGrupo	:= nil


/*/                                                                                
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
?????????????????????????????????????????????????????????????????????????????
??ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ???             
???Fun??o    ? FINA240v ? Autor ? Valdemir / Eduardo    ? Data ? 14/09/15 ???
??ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ???
???Descri??o ? Envia titulo para bordero de Pagamento                     ???
??ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ???
???Sintaxe   ? FINA240v()                                                 ???
??ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ???
??? Uso      ? SIGAFIN                                                    ???
??ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ??
?????????????????????????????????????????????????????????????????????????????
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                                                                     
User Function Fina240v(plDDA, aCpoSel)
Local lPanelFin := If (FindFunction("IsPanelFin"),IsPanelFin(),.F.) 
LOCAL lBrowse := ExistBlock("F240BROWSE")
LOCAL cBrowse           
Local nPosArotina := 3
Local lRET    := .F.     
Local cAlias  := ''    
Default plDDA := .F.
Private lDDA  := plDDA
//Private _xNumBor := ''


AjustaSX1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//? Carrega funcao Pergunte												  ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetKey (VK_F12,{|a,b| AcessaPerg("F240BR",.T.)})
pergunte("F240BR",.F.)

IF plDDA
   Private _EMISINI := ctod('  /  /  ')
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//? Parametros                                                   ?
//?                                                              ?
//? mv_par01   Considera t?tulos    ? Normais / Adiantamentos    ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

PRIVATE cFil240
PRIVATE c240FilBT 	:= space(60)
Private aRotina 	:= MenuDef()
Private xConteudo

Private cLoteFin	:= Space(04)
Private cPadrao 	:= ""
Private cBenef		:= CriaVar("E5_BENEF")
Private nTotAGer 	:= 0
Private nTotADesp	:= 0
Private nTotADesc	:= 0
Private nTotAMul 	:= 0
Private nTotAJur 	:= 0
Private nValPadrao	:= 0
Private nValEstrang	:= 0
Private cBanco   	:= CriaVar("E1_PORTADO")
Private cAgencia 	:= CriaVar("E1_AGEDEP")
Private cConta 		:= CriaVar("E1_CONTA")
Private cCtBaixa 	:= GetMv("MV_CTBAIXA")
Private cAgen240 	:= CriaVar("A6_AGENCIA")
Private cConta240	:= CriaVar("A6_NUMCON")
Private cModPgto  	:= CriaVar("EA_MODELO")
Private cTipoPag 	:= CriaVar("EA_TIPOPAG")
Private cMarca   	:= GetMark( )
Private cLote
Private cCadastro   
Private aGetMark := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//? Procura o Lote do Financeiro                                 ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LoteCont( "FIN" )

cCadastro := "Border? de Pagamentos"

dbSelectArea("SE2")
dbSetOrder(1)
/*
If lBrowse
	cBrowse := ExecBlock("F240BROWSE",.F.,.F.)
EndIf
*/
If nPosArotina > 0 // Sera executada uma opcao diretamento de aRotina, sem passar pela mBrowse
	dbSelectArea("SE2")
	//bBlock := &( "{ |a,b,c,d,e| " + EV240Borde('SE2',0,3) + " (a,b,c,d,e) }" )

	lRET := EV240Borde('SE2',0,3,aCpoSel)                       
	cAlias  := Alias()
	if Select(cAlias) > 0
	   (cAlias)->( Recno() )
	else
	  lRET := .F.
	endif

	//Eval( bBlock, Alias(), (Alias())->(Recno()), nPosArotina)
Else
	mBrowse( 6, 1,22,75,"SE2",,"E2_NUMBOR",,,,FA040Legenda("SE2"),,,,,,,,IIf(lBrowse, cBrowse, Nil))
Endif	

dbSelectArea("SE2")
dbSetOrder(1)  && devolve ordem principal
         
Return lRET





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
?????????????????????????????????????????????????????????????????????????????
??ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ???
??ºPrograma  ? AjustaSX1ºAutor  ?Valdemir / Eduardo  º Data ?  10/09/15   º??
??ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ???
??ºDesc.     ? Ajustes no grupo de pergunta, criacao da pergunte 08-Considº??
??º          ? ra agendamento e alteração na ordem das perguntas 08 e 09 pº??
??º          ? ra 09 e 10.                                                º??
??ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ???
??ºUso       ? FINA240 - Bordero de Pagamentos.                           º??
??ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ???
?????????????????????????????????????????????????????????????????????????????
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()
LOCAL aSavArea := GetArea()
LOCAL cPerg    := PadR("F240BR",Len(SX1->X1_GRUPO))

If SX1->(dbSeek(cPerg+"08"))
	If SX1->X1_TIPO == "D" .and. Alltrim(SX1->X1_PERGUNT)  == Alltrim("Data Agend.De")
	   	RecLock("SX1",.F.)
	   	SX1->(dbDelete())
	   	SX1->(MsUnLock())
		If SX1->(dbSeek(cPerg+"09"))
		   RecLock("SX1",.F.)
		   SX1->(dbDelete())
		   SX1->(MsUnLock())
		EndIf                        
		If SX1->(dbSeek(cPerg+"10"))
			RecLock("SX1",.F.)
			SX1->(dbDelete())
			SX1->(MsUnLock())
		EndIf
	Elseif SX1->X1_TIPO == "N" .and. Alltrim(SX1->X1_PERGUNT) == Alltrim("Considera Agendamento ?")
		RecLock("SX1",.F.)
	   	SX1->(dbDelete())
	   	SX1->(MsUnLock())
		If SX1->(dbSeek(cPerg+"09")) .and. Alltrim(SX1->X1_PERGUNT)  == Alltrim("Data Agend.De?")
		   RecLock("SX1",.F.)
		   SX1->(dbDelete())
		   SX1->(MsUnLock())
		EndIf                        
		If SX1->(dbSeek(cPerg+"10")).and. Alltrim(SX1->X1_PERGUNT)  == Alltrim("Data Agend.Ate?")
			RecLock("SX1",.F.)
			SX1->(dbDelete())
			SX1->(MsUnLock())
		EndIf
	EndIf
EndIf

RestArea(aSavArea)
Return

                                            

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
?????????????????????????????????????????????????????????????????????????????
??ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ???
???Fun??o    ?FA240Borde? Autor ? Valdemir / Eduardo    ? Data ? 21/09/15 ???
??ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ???
???Descri??o ? Define os titulos a serem incluidos no bordero do pagamento???
??ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ???
???Sintaxe   ? FA240Borde(ExpC1,ExpN1,ExpN2)                              ???
??ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ???
???Parametros? ExpC1 = Alias do arquivo                                   ???
???          ? ExpN1 = Numero do registro                                 ???
???          ? ExpN2 = Opcao selecionada no menu                          ???
??ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ???
??? Uso      ? FINA240                                                    ???
??ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ??
?????????????????????????????????????????????????????????????????????????????
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function EV240Borde(cAlias,nReg,nOpcx, aCpoSel)
Local lPanelFin := If (FindFunction("IsPanelFin"),IsPanelFin(),.F.)
Local oPanel
LOCAL cMoeda240
Local cVar 
Local lRET      := .T.
Local lInverte 	:= .F.
LOCAL aMoedas 	:= GetMoedas()
Local oFnt                                 
LOCAL cContrato	:= CriaVar("E9_NUMERO")
LOCAL nSavRec 	:= SE2->(RecNo())
LOCAL cIndex 	:= ""
LOCAL cUso,cUsoAnt
LOCAL lF240TBor := ExistBlock("F240TBOR")
LOCAL nHdlLock
Local lF240Semaf := ExistBlock("F240SEMA")
Local lF240Bord	 := ExistBlock("F240BORD")
Local nOpca := 0
Local cSetFilter := SE2->(DBFILTER()) // Salva o filtro atual, para restaurar no final da rotina
Local cOldPort240
Local lF240TDOK  := ExistBlock("F240TDOK")
Local bOk1, bOk2, bOk3
Local cMv_par01, nMv_par02   //salvar os parametros anteriores
Local aSize := {}
Local aCampos := {}
Local aStru := {}
Local aRestrict := {}
Local aUsrSE2   := {}
Local cArqNew := ""
Local lTEMP := .F.
Local aVars := {}
Local aVarsOld := {}
Local nX    := 0    
Local cIndTemp1 := CriaTrab(,.F.)
Local cIndTemp2 := CriaTrab(,.F.)
Local nEspLarg := 2 
Local	nEspLin  := 2
Local aBut240 
Local bSet16 
Local nIndice	:= 1
Local lBlqBor := .T.
Local lTop := .F.
Local lF240Qry := GetMV( "MV_F240QRY" ,.T.,.F.)  // Define se a busca no botão Pesquisa será efetuada por uma indregua com indices ou 
												  // uma Query com um indice unico, que nesse caso eh 500% mais rapida.	
Local aAltMark := {}
Local nPos := 0
Local lIntSJURI := SuperGetMv("MV_JURXFIN",.T.,.F.) 
Local aCores := {} 
Local aLegenda :={{"BR_VERDE","Disponivel"},;
						{"BR_VERMELHO","Bloqueado por Rateio"}}
Local l240Bor   := ExistBlock("F240BOR")						
Local lFinVDoc	:= IIF(GetNewPar("MV_FINVDOC","2")=="1",.T.,.F.)		//Controle de validacao de documentos obrigatorios    
Local lF240IND	:= ExistBlock("F240IND")
Local lF240BTN  := ExistBlock("F240BTN") 
Local nOrdem    := 0

//--- Tratamento Gestao Corporativa
Local lGestao   := Iif( lFWCodFil, FWSizeFilial() > 2, .F. )	// Indica se usa Gestao Corporativa
//
Local cFilFwSE2 := IIF( lGestao .And. FindFunction("FwFilial"), FwFilial("SE2") , xFilial("SE2") )
Local lPrimeiro	:=.T. //na pre marcação, indica se deve mostrar ou não o help. Para multiplas marcações, deve mostrar apenas uma vez, quando possui docs
#IFNDEF TOP
	lF240Qry := .F.
#ENDIF
Private cAliasSE2 := "SE2" 

ProcLogIni( {},"FINA240" )
ProcLogAtu("INICIO")

If !lF240Qry
	cAliasSE2 := cAlias
	ProcLogAtu("MENSAGEM","Pesquisa exeuctada sem utilização de Query") // Log "Pesquisa executado sem a utilização de Query" //
Endif

aBut240 := {{"PESQUISA",{||Fa240Pesq(oMark,cAliasSE2,nIndice,lTop)}, "Pesquisar..(CTRL-P)","Pesquisar"}} //###
bSet16 := SetKey(16,{||Fa240Pesq(oMark,cAliasSE2,nIndice,lTop)})	


Private aRetParam 	:= {}
Private nForPgto 	:= 0
Private cBancos 	:= Space(60)
Private lVldAD		:= .F.
Private nValor
Private nQtdTit 	:= 0
Private cPort240 	:= Criavar("EF_BANCO")
Private nMoeda 	:= 1
Private dVenIni240	:= dDataBase
Private dVenFim240	:= dDataBase
Private cNumBor 	:= Space(6)
Private lAuto       := .T.

Private nLimite 	:= 0
Private aIndTemp	:= {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se data do movimento n„o ‚ menor que data limite de ³
//³ movimentacao no financeiro    										  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !DtMovFin()
	Return
Endif

//------------------------------- Valdemir 02/02/2016 ------------------------------------
   aSort(aCpoSel,,, { |x, y| x < y })     // Vencimento
   dVenIni240 := aCpoSel[1]
   dVenFim240 := aCpoSel[Len(aCpoSel)]  
   
   if lDDA
	  _EmisIni := dVenIni240   
   Endif
   
//------------------------------- 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona no array aRestrict os campos que serão exibidos no  ³
//³ browse do bordero. Aline.       				 		     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SE2")                                                 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa o array aRestrict com campos que devem ser apresentados, ³
//³ independente das configuração do dicionário. Aline. 		        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aRestrict := {"E2_FILIAL","E2_NUMBOR","E2_NUMBCO","E2_SALDO","E2_VENCREA","E2_PREFIXO","E2_NUM","E2_PARCELA","E2_MOEDA",;
	"E2_FORNECE","E2_SDACRES","E2_SDDECRE","E2_TIPO","E2_LOJA","E2_NATUREZ","E2_PORTADO","E2_CODBAR","E2_NOMFOR"}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inclusão de outros campos além dos já definidos, para corrigir  ³
//³falha no filtro de alguns indices, pois alguns campos utilizados³
//³pelos mesmos não estavam disponiveis no arquivo tempora-        ³
//³rio, o que gera erro de execução.                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd(aRestrict,"E2_FATPREF")
aAdd(aRestrict,"E2_FATURA")
aAdd(aRestrict,"E2_ANOBASE")
aAdd(aRestrict,"E2_MESBASE")
aAdd(aRestrict,"E2_PLOPELT")
aAdd(aRestrict,"E2_PLLOTE")
aAdd(aRestrict,"E2_IDCNAB")
aAdd(aRestrict,"E2_ORDPAGO")
aAdd(aRestrict,"E2_NODIA")

While SX3->(!EOF()) .And. (x3_arquivo == "SE2")
	If (ascan(aRestrict,{|x| alltrim(upper(x)) == alltrim(upper(x3_campo))}) == 0) .and. X3USO(SX3->X3_USADO) .and.;
		(SX3->X3_TIPO!="M") .and. (SX3->X3_CONTEXT != "V") .and. (cNivel >= SX3->X3_NIVEL)
		aadd(aRestrict, SX3->X3_CAMPO)
	Endif
	SX3->(dbSkip())
End

aUsrSE2:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para adicionar campos de usuarios ao vetor de ³
//³ campos aRestrict                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
If ExistBlock("F240ADCM")
	aUsrSE2:= ExecBlock("F240ADCM",.F.,.F.)
	If Len(aUsrSE2) >= 0
		dbSelectArea("SX3")
		dbSetOrder(2)
		For nX := 1 to Len(aUsrSE2)
			If SX3->(dbSeek(aUsrSE2[nx])) .and. ascan(aRestrict, {|x| Alltrim(Upper(x)) == Alltrim(upper(aUsrSE2[nx])) }) == 0
				aadd( aRestrict, aUsrSE2[nX] )
			Endif
		next nX
		dbSetOrder(1)
	Endif
EndIf
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Sem foro para utiliza‡„o do Border“                             ³
//³ N„o permite o acesso simultƒneo … rotina por mais de 1 usuario. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lF240Semaf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ponto de entrada para executar o semaforo                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	/*
	If ExecBlock("F240SEMA",.F.,.F.)
		IF ( nHdlLock := MSFCREATE("FINA240.L"+cEmpAnt)) < 0
			MsgAlert("A Funcao de geracao de bordero esta sendo utilizada por"+chr(13)+chr(10)+;	// 
						"outro usuario. Por questoes de integridade de dados, nao"+chr(13)+chr(10)+;	// 
						"‚ permitida a utiliza‡„o desta rotina por mais de um usu rio"+chr(13)+chr(10)+;	// 
						"simultaneamente. Tente novamente mais tarde.","Border“ de Pagamentos")				// 
			Return
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava no sem foro informa‡”es sobre quem est  utilizando o Bordero ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		FWrite(nHdlLock,"Operador: "+cUserName+chr(13)+chr(10)+;
					"Empresa.: "+cEmpAnt+chr(13)+chr(10)+;
					"Filial..: "+cFilAnt+chr(13)+chr(10))
	Endif
	*/
Endif

dbSelectArea("SX3")
dbSetOrder(2)
dbSeek("E2_NUM")
cUso := SX3->X3_USADO

dbSelectArea("SX3")
If dbSeek("E2_SALDO")
	cUsoAnt := X3_USADO
	Reclock("SX3")
	Replace SX3->X3_USADO With cUso
	MsUnlock()
EndIf

SX3->(dbSetOrder(1))

ProclogAtu("INICIO","VERIFICAÇÃO DE NÚMERO DO ÚLTIMO BORDERÔ")//Log: VERIFICAÇÃO DE NÚMERO DO ÚLTIMO BORDERÔ //  STR0100

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica numero do ultimo Bordero Gerado                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNumBor := Soma1(Pad(GetMV("MV_NUMBORP"),Len(SE2->E2_NUMBOR)),Len(SE2->E2_NUMBOR)) //"MV_NUMBORP"
While !MayIUseCode( "E2_NUMBOR"+xFilial("SE2")+cNumBor)  //verifica se esta na memoria, sendo usado
	cNumBor := Soma1(cNumBor)										// busca o proximo numero disponivel 
EndDo                                           
ProcLogAtu("FIM","ÚLTIMO BORDERÔ GERADO")//Log: Último Borderô gerado //
If GetNewPar("MV_VLTITAD",.F.)
	Aadd(aBut240, { 'PENDENTE', { || F090VlMark(.T.,cAliasSE2,cMarca,oValor,oQtda,oMark,nValor,"FINA240")}, "Verifica se ha Titulos com Adiantamento ou Devolucao", "Validador" } ) //"Verifica se ha Titulos com Adiantamento ou Devolucao"###"Validador"
Endif
If lIntSJURI
	Aadd( aBut240, { 'BR_VERDE', { || BrwLegenda("Documento","Status",aLegenda) }, "Legenda", "Documento" } ) //######"Legenda"###"Legenda"
EndIf  
IncProc('Gerando Borderô Nº ' + cNumBor)
While .T.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa variaveis de banco, agencia e conta               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cPort240  := Criavar("A6_COD")
	cAgen240  := CriaVar("A6_AGENCIA")
	cConta240 := CriaVar("A6_NUMCON")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca por um novo numero de bordero (ainda nao usado)        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lTEMP := .F.
	
	If lF240Qry
		//Guardo o indice de entrada para a rotina de pesquisa
		nIndice := SE2->(IndexOrd())
		ProcLogAtu("MENSAGEM","Log Indice utilizado na pesquisa utilizando Query") //  //"ìndice utilizado na pesquisa da Query" STR0102

	Endif
	
	While .T.
		If !MayIUseCode("E2_NUMBOR"+xFilial("SE2")+cNumBor)  //verifica se esta na memoria, sendo usado busca o proximo numero disponivel
			Help(" ",1,"F240BORDE")
		Else
			Exit
		EndIf
	Enddo
	
	cMoeda240 := cVar := aMoedas[1]
	nOpc := 0
	IF !lAuto   //!ExistBlock("F240GAVE")
	
		aSize := MSADVSIZE()
		If lPanelFin //Chamado pelo Painel Financeiro
			dbSelectArea(cAlias)
			oPanelDados := FinWindow:GetVisPanel()
			oPanelDados:FreeChildren()
			aDim := DLGinPANEL(oPanelDados)
			DEFINE MSDIALOG oDlg OF oPanelDados:oWnd FROM 0,0 To 0,0 PIXEL STYLE nOR( WS_VISIBLE, WS_POPUP )
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Observacao Importante quanto as coordenadas calculadas abaixo: ³
			//³ -------------------------------------------------------------- ³
			//³ a funcao DlgWidthPanel() retorna o dobro do valor da area do	 ³
			//³ painel, sendo assim este deve ser dividido por 2 antes da sub- ³
			//³ tracao e redivisao por 2 para a centralizacao. 					 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nEspLarg := ((DlgWidthPanel(oPanelDados)/2) - 196) /2
			nEspLin  := 0
			
		Else
		ProcLogAtu("INICIO","Log: Utilização do Indregua para pesquisa e montagem de tela")// //"Utilização do Indregua para pesquisa e montagem de tela"  STR0103

			nEspLarg := 2
			nEspLin  := 2
			DEFINE MSDIALOG oDlg FROM  15,6 TO 219,404 TITLE "Border“s de Pagamentos" PIXEL  // STR0014
		Endif
	  
			
		oDlg:lMaximized := .F.
		oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,20,20)
		oPanel:Align := CONTROL_ALIGN_ALLCLIENT
		
		@ 00+nEspLin, nEspLarg TO 29+nEspLin, 196+nEspLarg OF oPanel  PIXEL
		@ 34+nEspLin, nEspLarg TO 63+nEspLin, 196+nEspLarg OF oPanel  PIXEL
		@ 68+nEspLin, nEspLarg TO 97+nEspLin, 196+nEspLarg OF oPanel  PIXEL
		
		nEspLarg := nEspLarg -1
		
		@ 06+nEspLin, 009+nEspLarg SAY "N£mero"	   SIZE 23, 7 OF oPanel PIXEL  // STR0015
		@ 06+nEspLin, 045+nEspLarg SAY "Vencto de"		SIZE 32, 7 OF oPanel PIXEL  // STR0016
		@ 06+nEspLin, 090+nEspLarg SAY "At‚"	SIZE 32, 7 OF oPanel PIXEL  // STR0017
		@ 06+nEspLin, 135+nEspLarg SAY "Limite Valor"		SIZE 53, 7 OF oPanel PIXEL  // STR0018
		@ 40+nEspLin, 009+nEspLarg SAY "Banco"		SIZE 23, 7 OF oPanel PIXEL  // STR0019
		@ 40+nEspLin, 045+nEspLarg SAY "Agˆncia"		SIZE 32, 7 OF oPanel PIXEL  // STR0020
		@ 40+nEspLin, 085+nEspLarg SAY "Conta"		SIZE 32, 7 OF oPanel PIXEL  // STR0021
		@ 40+nEspLin, 151+nEspLarg SAY "Contrato"		SIZE 53, 7 OF oPanel PIXEL  // STR0022
		@ 73+nEspLin, 009+nEspLarg SAY "Moeda"		SIZE 23, 7 OF oPanel PIXEL  // STR0023
		@ 73+nEspLin, 063+nEspLarg SAY "Modelo"		SIZE 22, 7 OF oPanel PIXEL  // STR0024
		@ 73+nEspLin, 097+nEspLarg SAY "Tipo Pagto"		SIZE 32, 7 OF oPanel PIXEL  // STR0025
		/*       
		IF l240Bor
			lBlqBor:= ExecBlock("F240BOR",.F.,.F.,{lBlqBor})
		Endif
		*/
		//Linha 1
		@ 15+nEspLin, 009+nEspLarg MSGET cNumBor         	SIZE 32, 10 OF oPanel PIXEL ;
		Picture "@!" Valid If(nOpc<>0,!Empty(cNumBor).And.FA240Num(cNumBor),.T.) when lBlqBor
		@ 15+nEspLin, 045+nEspLarg MSGET dVenIni240        	SIZE 45, 10 OF oPanel PIXEL  HASBUTTON
		@ 15+nEspLin, 090+nEspLarg MSGET dVenFim240        	SIZE 45, 10 OF oPanel PIXEL  HASBUTTON ;
														Valid   If(nOpc<>0,FA240DATA(dVenIni240,dVenFim240),.T.)
		@ 15+nEspLin, 135+nEspLarg MSGET nLimite         		SIZE 60, 10 OF oPanel PIXEL HASBUTTON ;
														Picture "@E 999,999,999,999.99"  Valid If(nOpc<>0,nLimite >= 0,.T.) 
		//Linha 2
		@ 49+nEspLin,   9+nEspLarg MSGET cPort240        		SIZE 10, 10 OF oPanel PIXEL HASBUTTON ;
		Picture "@!"  ;
		F3 "SA6";    
		Valid F240VldBco(@cPort240,@cAgen240,@cConta240)

		@ 49+nEspLin,  45+nEspLarg MSGET cAgen240        		SIZE 26, 10 OF oPanel PIXEL Picture "@!"  ;
														Valid CarregaSA6(@cPort240,@cAgen240,,.T.)
		@ 49+nEspLin,  85+nEspLarg MSGET cConta240       		SIZE 62, 10 OF oPanel PIXEL Picture "@!"  ;
														Valid CarregaSA6(@cPort240,@cAgen240,@cConta240,.T.,,.T.)
		@ 49+nEspLin, 151+nEspLarg MSGET cContrato       		SIZE 42, 10 OF oPanel PIXEL Picture "@S3"
	
		//Linha 3
		@ 82+nEspLin, 009+nEspLarg MSCOMBOBOX oCbx VAR cMoeda240 ITEMS aMoedas SIZE 46, 50 OF oPanel PIXEL ;
					 Valid F240VldMd(cPort240,cAgen240,cConta240,Val(cMoeda240))
		@ 82+nEspLin, 063+nEspLarg MSGET cModPgto        		SIZE 25, 10 OF oPanel PIXEL Picture "@!"  Valid If(nOpc<>0,ExistCpo("SX5", + "58" + cModPgto),.T.) F3 "58" HASBUTTON
		@ 82+nEspLin, 097+nEspLarg MSGET cTipoPag        		SIZE 25, 10 OF oPanel PIXEL Picture "@!"  Valid If(nOpc<>0,ExistCpo("SX5", + "59" + cTipoPag),.T.) F3 "59" HASBUTTON
	
	   
		If lPanelFin //Chamado pelo Painel Financeiro					
			oDlg:Move(aDim[1],aDim[2],aDim[4]-aDim[2], aDim[3]-aDim[1])			
			ACTIVATE MSDIALOG oDlg ON INIT FaMyBar(oDlg,;
			{||cVar:=cMoeda240,nOpc:=1,Iif(F240TudoOk(oDlg),oDlg:End(),nOpc:=0)},;
			{||oDlg:End()})
			
			cAlias := FinWindow:cAliasFile     
			dbSelectArea(cAlias)					
	
	   Else	
			DEFINE SBUTTON FROM 83, 140 TYPE 1 ENABLE OF oPanel ACTION (cVar:=cMoeda240,nOpc:=1,;
																		Iif(F240TudoOk(oDlg),oDlg:End(),nOpc:=0))
			DEFINE SBUTTON FROM 83, 170 TYPE 2 ENABLE OF oPanel ACTION oDlg:End() 
	
			ACTIVATE MSDIALOG oDlg CENTERED
		Endif	

	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica numero do ultimo Bordero Gerado                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cNumBor := Soma1(Pad(GetMV("MV_NUMBORP"),Len(SE2->E2_NUMBOR)),Len(SE2->E2_NUMBOR)) //"MV_NUMBORP"
		While !MayIUseCode( "E2_NUMBOR"+xFilial("SE2")+cNumBor)  //verifica se esta na memoria, sendo usado
			cNumBor := Soma1(cNumBor)										// busca o proximo numero disponivel 
		EndDo  

		//dVenIni240 := _EmisIni                   
		//dVenFim240 := _EmisFim
		cPort240   := _cBanco
		cAgen240   := _cAgencia
		cConta240  := _cConta
		// Busca campos
		/*
		aTMP     := _GetBco341('SE2')
		cModPgto := aTMP[1]    
		cTipoPag := aTMP[2]    
		*/
		nOPC       := 1
		
		IncProc('Gerando Borderô Nº ' + cNumBor)

		AADD(aVars,cNumBor)
		AADD(aVars,dVenIni240)
		AADD(aVars,dVenFim240)
		AADD(aVars,nLimite)
		AADD(aVars,cPort240)
		AADD(aVars,cAgen240)
		AADD(aVars,cConta240)
		AADD(aVars,cContrato)
		AADD(aVars,cMoeda240)
		AADD(aVars,aMoedas)
		AADD(aVars,cModPgto)
		AADD(aVars,cTipoPag)
		AADD(aVars,nOpc)
		aVarsOld := aVars
		//aVars := Execblock("F240GAVE",.F.,.F.,aVars)
		
		//Valida retorno do PE F240GAVE
		If ValType(aVars) != "A" .OR. Len(aVars) < 13
			aVars := aVarsOld
			ConOut("Retorno do PE F240GAVE invalido.")
		Endif
		
		cNumBor   := aVars[1]
		dVenIni240:= aVars[2]
		dVenFim240:= aVars[3]
		nLimite   := aVars[4]
		cPort240  := aVars[5]
		cAgen240  := aVars[6]
		cConta240 := aVars[7]
		cContrato := aVars[8]
		cMoeda240 := aVars[9]
		aMoedas   := aVars[10]
		cModPgto  := aVars[11]
		cTipoPag  := aVars[12]
		nOpc      := aVars[13]
	Endif
	
	
	fa240Perg()
	If nOpc != 1
		DbClearFilter()
		dbSetOrder(1)
		Exit
	EndIF
	nMoeda := Val(Substr(cVar,1,2))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Execblock a ser executado antes da Indregua                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//IF (ExistBlock("F240FIL"))
	/*
		cMv_par01 := mv_par01
		nMv_par02 := mv_par02
		cFil240 := ExecBlock("F240FIL",.f.,.f.)
		mv_par01 := cMv_par01
		mv_par02 := nMv_par02
	*/
	//Else
		cFIl240 := ""
	//Endif
	
	#IFDEF TOP
		lTEMP := .T.
		cAliasSE2 := "SE2TMP"
		//Funcao para montar e processar a query
		cArqNew := f240QryA(.F.,cAliasSE2, aCampos, aRestrict, @lTop, cIndTemp1, cIndTemp2, aCpoSel)
		//Incluindo o botao para atualizar a lista somente para ambientes que utilizam query
		If aScan(aBut240,{|x| x[1] == "PMSRRFSH"}) == 0
			aAdd(aBut240,{"PMSRRFSH",{|| MsAguarde({||f240QryA(.T.,cAliasSE2, aCampos, aRestrict, lTop, cIndTemp1, cIndTemp2, aCpoSel)},;
			"Atualizando","Aguarde, atualizando a lista",.F.)},"Atualizar"})
		Endif
		
		If cArqNew == "NOACESS"  // Caso o usuario não tenha nenhuma permissão aborta o processo do bordero
		   if (dDatabase <> _EmisIni) .OR. (cAliasSE2)->( EOF() )
		   	apMsgInfo('Por favor, verifique se a database é igual o vencimento','Atenção!!!')
		   else
  			Help(" ",1,"RECNO")
           endif
			Return
		EndIf
		
	#ELSE
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Filtra o arquivo                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cAliasSE2 := "SE2"
		dbSelectArea("SE2")
		cIndex := CriaTrab(nil,.f.)
		cChave  := IndexKey()
		IndRegua("SE2",cIndex,cChave,,FA240ChecF(),STR0029)  //"Selecionando Registros..."
		nIndex := RetIndex("SE2")
		dbSetIndex(cIndex+OrdBagEXt())
		dbSetOrder(nIndex+1)
		lTEMP := .T.
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Montagem dos campos na Array  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aCampos := {}
		AADD(aCampos,{"E2_OK","","  ",""})
		dbSelectArea("SX3")
		SX3->(dbSetOrder(1))
		dbSeek ("SE2")
		
		//Adiciona o campo E2_FILIAL no browse somente se o SE2 estiver exclusivo e em uso.
		If !Empty( cFilFwSE2 ) .Or. X3USO(x3_usado) .And. cNivel >= x3_nivel
			AADD(aCampos,{X3_CAMPO,"",AllTrim(X3Titulo()),X3_PICTURE})
			SX3->(dbSkip())
		EndIf
		
		While !EOF() .And. (x3_arquivo == "SE2")
			IF X3USO(x3_usado)  .AND. cNivel >= x3_nivel .and. X3_CONTEXT != "V"
				AADD(aCampos,{X3_CAMPO,"",AllTrim(X3Titulo()),X3_PICTURE})
			Endif
			SX3->(dbSkip())
		Enddo
	#ENDIF                                   
	
	If !Empty( cArqNew )
		dbselectarea(cAliasSE2)
		dbGoTop()
	EndIf	
	
	If (cAliasSE2)->( BOF() ) .and. (cAliasSE2)->( EOF() )
	    if (dDatabase <> _EmisIni) 
	   	 apMsgInfo('Por favor, verifique se a database é igual o vencimento','Atenção!!!')
	    else
	 	 Help(" ",1,"RECNO")
        Endif
		lRET := .F.
		If !Empty( cArqNew )
			dbSelectArea(cAliasSE2)
			dbCloseArea()
		EndIf	
		If lTEMP
		ProcLogAtu("INICIO","Log: MONTAGEM DO ARQUIVO TEMPORARIO")// //"MONTAGEM DO ARQUIVO TEMPORARIO" STR0104


			If lF240Qry
				TcDelFile(cArqNew)
			Else		
				If File(cArqNew+GetDBExtension())			
					FErase(cArqNew+GetDBExtension())	
				Endif	                                
				If File( cIndTemp1 + OrdBagExt() )
					FErase( cIndTemp1 + OrdBagExt() )
				EndIf              
				If File( cIndTemp2 + OrdBagExt() )
					FErase( cIndTemp2 + OrdBagExt() )
				EndIf
				fOR Nx:= 1 TO lEN(aIndTemp)
					If File( aIndTemp[Nx] + OrdBagExt() )
						FErase( aIndTemp[Nx] + OrdBagExt() )
					EndIf
				nEXT
			Endif
		EndIf	
		//Loop
		Return lRET
	EndIf
	ProcLogAtu("FIM","Log: FIM MONTAGEM DO ARQUIVO TEMPORARIO")// STR0104
	bWhile := { || !Eof() }
	
	#IFNDEF TOP
		If mv_par02 == 1  // Considera Filiais ?
			If Empty( cFilFwSE2 )
				dbSeek(xFilial("SE2"))  // Posiciono na filial atual
			Else
				dbSeek(mv_par03,.T.)  // Posiciono na primeira filial do intervalo
			EndIf
		Else
			dbSeek(xFilial("SE2"))  // Posiciono na filial atual
		Endif
	#ENDIF
	nRecSE2 :=  SE2->(Recno())
	nValor  := 0    // valor total dos titulos,mostrado no rodape do browse
	nQtdTit := 0    // quantidade de titulos,mostrado no rodape do browse
	nOpca   := 0
	
	SX3->(dbSetOrder(1))
	
	DEFINE FONT oFnt NAME "Arial" SIZE 12,14 BOLD
	
	//Realiza ou nao pre-marcacao
	(cAliasSE2)->( DBEVAL({ |a| FA240DBEVA(nLimite,dVenIni240,dVenFim240,cAliasSE2,,@lPrimeiro)},bWhile) )
/*	
	aTMP     := _GetBco341('SE2')
	cModPgto := aTMP[1]    
	cTipoPag := aTMP[2]    
*/	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³PONTO DE ENTRADA PARA ALTERAR A ORDEM DOS CAMPOS NA MARKBROWSE³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	/*
	If ExistBlock("F240MARK")
		aAltMark := ExecBlock("F240MARK",.F.,.F.,aCampos)
		nPos := Ascan(aAltMark,{|X|X[1] == "E2_OK"})
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³FORCA O PRIMEIRO CAMPO SER SEMPRE O E2_OK³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nPos != 1
			aCampos := {}
			aAdd(aCampos,{"E2_OK","","  ",""})
			aEval(aAltMark,{|Z| If(Z[1] <> "E2_OK",aAdd(aCampos,{Z[1],Z[2],Z[3],Z[4]}),NIL)})
		Else
			aCampos := aAltMark
		Endif
	Endif
	*/
	dbselectarea(cAliasSE2)
	dbGoTop()

/*	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz o calculo automatico de dimensoes de objetos     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSize := MSADVSIZE()
	DEFINE MSDIALOG oDlg1 TITLE "Border“ de Pagamentos" From aSize[7],00 To aSize[6],aSize[5] OF oMainWnd PIXEL // STR0005
	oDlg1:lMaximized := .T.
	
	////////
	// Panel
	oPanel := TPanel():New(0,0,'',oDlg1,, .T., .T.,, ,315,25,.T.,.T. )
	oPanel:Align := CONTROL_ALIGN_TOP // Somente Interface MDI
	
	@ 003 , 005 SAY "N£mero" FONT oDlg1:oFont PIXEL Of oPanel //  STR0015
	@ 003 , 060 Say cNumbor				Picture "@!";
	FONT oFnt COLOR CLR_HBLUE;
	PIXEL Of oPanel
	
	@ 012 , 005 Say "Valor Total:"  PIXEL Of oPanel // STR0030
	@ 012 , 060 Say oValor VAR nValor Picture "@E 999,999,999,999.99" SIZE 50,8  PIXEL Of oPanel
	@ 012 , 150 Say "Quantidade:"  PIXEL Of oPanel // STR0031
	@ 012 , 200 Say oQtda VAR nQtdTit Picture "@E 99999" SIZE 50,8  PIXEL Of oPanel
*/	
	// Panel
	////////
/*	
	/////////////
	// MarkBrowse
	Aadd(aCores, {'Fa240Juri(cAliasSE2)','BR_VERDE'} )
	Aadd(aCores, {'!Fa240Juri(cAliasSE2)','BR_VERMELHO'} )
	oMark := MsSelect():New(cAliasSE2,"E2_OK","!E2_SALDO",aCampos,@lInverte,@cMarca,{50,oDlg1:nLeft,oDlg1:nBottom,oDlg1:nRight},"u__Fa240Top(1)","u__Fa240Top(2)",,,aCores)
	oMark:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT // Somente Interface MDI
	
	oMark:bMark := {|| FA240Disp(cMarca,lInverte,oValor,oQtda)}
	oMark:bAval	:= {|| Fa240Mark(cMarca,oValor,oQtda,cAliasSE2)}
	oMark:oBrowse:lhasMark = .t.
	oMark:oBrowse:lCanAllmark := .t.
	oMark:oBrowse:bAllMark := { || FA240Inverte(cMarca,oValor,oQtda,,cAliasSE2) }
	oMark:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	// MarkBrowse
	/////////////                                                       
	
	
	bOk1 := {|| If( !GetNewPar("MV_VLTITAD",.F.), lVldAD := .T., Nil ) }
	bOk2 := {|| nOpca := 1,oDlg1:End()}
	bOk3 := {|| MsgInfo("Antes de confirmar as baixas, execute o botao para validar titulos cujo Fornecedor possua Adiantamento ou Devolucao.") } // STR0058
	
	If lPanelFin //Chamado pelo Painel Financeiro
		ACTIVATE MSDIALOG oDlg1 ON INIT (FaMyBar(oDlg1,{|| ( Eval(bOk1), If(lVldAd,Eval(bOk2),Eval(bOk3)) ) },;
		{|| nOpca := 2,oDlg1:End()},aBut240),IIf(lF240IND,oMark:oBrowse:Refresh(.T.),.T.))
	Else
		ACTIVATE MSDIALOG oDlg1 ON INIT (EnchoiceBar(oDlg1,{|| ( Eval(bOk1),If(F240Conf(), If(lVldAd,Eval(bOk2),Eval(bOk3)),)) },;
		{|| nOpca := 2,oDlg1:End()},,IIF(lF240BTN, aBut240 := ExecBlock("F240BTN",.F.,.F.,aBut240),aBut240)),IIf(lF240IND,oMark:oBrowse:Refresh(.T.),.T.)) CENTER
	Endif
	
	SetKey(16,bSet16)
	
	If nQtdTit == 0 .and. nValor = 0
		Exit
	EndIf

	If nValor <= 0
		Help(" ",1,"FA240VALOR")
		Loop
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Execblock para validar as informacoes para geracao do bordero³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOpca == 1
		IF lF240TDOK
			nOpca := If( ExecBlock( "F240TDOK", .f., .f., { cMarca, cAliasSE2 } ),1,2)
		Endif
	Endif
	
	If nOpcA == 2							// Redigita / Abandona
		FreeUsedCode()  //libera codigos de correlativos reservados pela MayIUseCode()
		Exit
	EndIf
*/	
	nOpcA := 1
	
	If nOpcA == 1							// Confirma
		
		BEGIN TRANSACTION
		
		nMoeda := Val(Substr(cVar,1,2))
		dbSelectArea(cAliasSE2)
		dbGotop( )                
		
		if !lDDA    
			nREG := 0   
			
			// Atualiza Selecao
			While !(cAliasSE2)->( Eof( ) )
			    nREG := aScan(aVetor, { |x| x[3]==(cAliasSE2)->E2_NUM .and. x[5]==(cAliasSE2)->E2_FORNECE .and. x[6]==(cAliasSE2)->E2_LOJA} )
			    RecLock(cAliasSE2, .F.)
			    IF nREG > 0
			    	(cAliasSE2)->E2_OK := if(aVETOR[nREG][1],'ok',' ')
			    Else                      
			    	(cAliasSE2)->E2_OK := '  '
			    Endif                 
			    MsUnlock()
				(cAliasSE2)->( dbSkip() )
		    EndDo 
		    
	    Endif

	    // Cria Arquivo Tempario SE2 para ordenar por modalidade
	    cAliasTMP := GetSE2TMP(cAliasSE2)
	    
		cModPgto := ''
		lPri     := .F.
		While !(cAliasTMP)->( Eof( ) )
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Se titulo marcado -> gera o bordero com ele.                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				#IFDEF TOP
					SE2->(MSGOTO( (cAliasTMP)->NUM_REG) )
				#ELSE
					cChave := &(IndexKey())
				#ENDIF
				
				cOldPort240 := (cAliasTMP)->E2_PORTADO	// Guarda o portador anterior para envia-lo ao PE
				SA2->( dbSetOrder(1))
				SA2->( dbSeek(xFilial('SA2')+SE2->E2_FORNECE+SE2->E2_LOJA) )

				//cTipoPag := (cAliasTMP)->E2_TIPOP
				
				// F240TBOR, caso o usuario nao queira que seja
				// alterado o portador
				if !lPri
				   _xNumBor := cNumBor
				   lPri     := .T.
				Endif
				dbSelectArea("SEA")
				RecLock("SEA",.T. )
				Replace 	EA_FILIAL  With xFilial("SEA"),;
				EA_PORTADO With cPort240,;
				EA_AGEDEP  With cAgen240,;
				EA_NUMCON  With cConta240,;
				EA_NUMBOR  With cNumBor,;
				EA_DATABOR With dDataBase,;
				EA_PREFIXO With SE2->E2_PREFIXO,;
				EA_NUM     With SE2->E2_NUM,;
				EA_PARCELA With SE2->E2_PARCELA,;
				EA_TIPO    With SE2->E2_TIPO,;
				EA_FORNECE With SE2->E2_FORNECE,;
				EA_LOJA	   With SE2->E2_LOJA,;
				EA_CART    With "P",;
				EA_MODELO  With (cAliasTMP)->E2_MODAL,;
				EA_TIPOPAG With (cAliasTMP)->E2_TIPOP,;
				EA_FILORIG With SE2->E2_FILORIG
				MsUnlock()
				FKCOMMIT()

				ProcLogAtu("INICIO","GRAVAÇÃO DO NÚMERO DE BORDERÔ NA SE2") 			// STR0105
				RecLock("SE2",.F.)
				Replace E2_NUMBOR  With cNumBor
				Replace E2_PORTADO With cPort240
				MsUnlock( )
				FKCOMMIT()
				ProcLogAtu("FIM",'Linha: 868' )      // STR0105

				//Envio de e-mail pela rotina de checklist de documentos obrigatorios
				IF AliasIndic("FRD") .AND. (SE2->(FieldPos("E2_TEMDOCS")) > 0) .And. FindFunction("CN062ValDocs") .And. lFinVDoc
					CN062ValDocs("06",.F.,.T.)
				EndIf

				//Abro o SE2 com outro Alias se o mesmo não estiver aberto
				If Select("__SE2") == 0
				   ChkFile("SE2",.F.,"__SE2")
				Else
			  	   DbSelectArea("__SE2")
				EndIf

				ProcLogAtu("INICIO", "Gravação do Número do Borderô nos Titulos") // STR0106
				//Gravo o numero do bordero em todos os titulos de abatimentos
				__SE2->(dbSetOrder(1))
				__SE2->(MsSeek(xFilial("SE2")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)))
				While !EOF() .And. __SE2->E2_FILIAL==xFilial("SE2") .And. __SE2->E2_PREFIXO == SE2->E2_PREFIXO .And.;
						__SE2->E2_NUM == SE2->E2_NUM .And. __SE2->E2_PARCELA == SE2->E2_PARCELA   .AND. __SE2->E2_TIPO=SE2->E2_TIPO .AND.;
						__SE2->E2_FORNECE == SE2->E2_FORNECE .AND. __SE2->E2_LOJA == SE2->E2_LOJA
					IF __SE2->E2_TIPO $ MVABATIM .And. __SE2->E2_FORNECE == SE2->E2_FORNECE
						RecLock("__SE2")
						Replace E2_NUMBOR  With cNumBor
						Replace E2_PORTADO With cPort240
						MsUnlock()
						FKCOMMIT()
					Endif
					dbSkip()
				Enddo
				ProcLogAtu("FIM", 'Linha 897')				// STR0106

				dbSelectArea("SE2")
				
				If lF240TBor
					ProcLogAtu("INICIO","EXECUÇÃO DO PONTO DE ENTRADA F240TBOR")				 //
					//ExecBlock("F240TBOR",.f.,.f.,{cOldPort240,cPort240})
					ProcLogAtu("FIM",'Linha 904')     // STR0107				
				Endif  
				
				cModPgto := (cAliasTMP)->E2_MODAL
			    
			
			#IFDEF TOP
				(cAliasTMP)->(dbskip())
			#ELSE
				dbSelectArea(cAliasTMP)
				
				If !Empty(cChave)
					(cAliasTMP)->(dbSetOrder(nIndex+1))
					(cAliasTMP)->(DbSeek(cChave,.T.))
				Else
					(cAliasTMP)->(dbskip())
				EndIf
			#ENDIF
			if (cModPgto <> (cAliasTMP)->E2_MODAL)
		    	cNumBor := SOMA1(cNumBor)                             
		    endif
		EndDo
		ProcLogAtu("INICIO","GRAVAÇÃO DO NÚMERO DE Borderô na SX6" )		 //"GRAVAÇÃO DO NÚMERO DE Borderô na SX6"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava o numero do bordero atualizado                         ³
		//³ Utilize sempre GetMv para posicionar o SX6. N„o use SEEK !!! ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SX6")
		GetMv("MV_NUMBORP")
		// Garante que o numero do bordero seja sempre superior ao numero anterior
	  	If __Language == "SPANISH" .And. SX6->X6_CONTSPA < cNumbor
	 		RecLock("SX6",.F.)
			SX6->X6_CONTSPA := cNumbor
			msUnlock()	
		ElseIf SX6->X6_CONTEUD < cNumbor
			RecLock("SX6",.F.)
			SX6->X6_CONTEUD := cNumbor
			msUnlock()
		Endif
		ProcLogAtu("FIM",'Linha 944')      // STR0108
		END TRANSACTION
	EndIf
	
	Exit
EndDo

If nOpca == 1 .AND. lF240Bord
   ExecBlock("F240Bord",.F.,.F.)
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Apaga o sem foro                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lF240Semaf
	fclose(nHdlLock)
	Ferase("FINA240.L"+cEmpAnt)
EndIf

//Libera os registros
If lTEMP		
	dbSelectArea(cAliasTMP)
	dbGoTop()
	While !EOF()
		#IFDEF TOP
			SE2->(dbGoto((cAliasTMP)->NUM_REG))
			SE2->(MsUnlock())
		#ENDIF		
		(cAliasTMP)->(MsUnlock())
		dbSkip()
	Enddo
		
	If Select(cAliasTMP) > 0
		dbSelectArea(cAliasTMP)
		dbCloseArea()		
		If lF240Qry
			TcDelFile(cArqNew)
		Else		
			If File(cArqNew+GetDBExtension())			
				FErase(cArqNew+GetDBExtension())	
			Endif	
			If File( cIndTemp1 + OrdBagExt() )
				FErase( cIndTemp1 + OrdBagExt() )
			EndIf              
			If File( cIndTemp2 + OrdBagExt() )
				FErase( cIndTemp2 + OrdBagExt() )
			EndIf
			fOR Nx:= 1 TO lEN(aIndTemp)
				If File( aIndTemp[Nx] + OrdBagExt() )
					FErase( aIndTemp[Nx] + OrdBagExt() )
				EndIf
			nEXT			
		Endif
	Endif
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura os indices                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem := SE2->(INDEXORD())
dbSelectArea("SE2")
dbSetOrder(1)
dbGoTop()

RetIndex("SE2")
dbSetOrder(1)

If !Empty(cIndex)
	Ferase (cIndex+OrdBagExt())
Endif 

dbSelectArea("SX3")
dbSetOrder(2)
dbSeek("E2_SALDO")
Reclock("SX3")
Replace SX3->X3_USADO With cUsoAnt
MsUnlock()

SX3->(dbSetOrder(1))

dbSelectArea( "SE2" )
// Restaura o filtro
Set Filter To &cSetFilter. 
dbSetOrder(1) 

dbSetOrder(nOrdem)

If nSavRec > 0; dbGoTo( nSavRec ); Endif

If lPanelFin //Chamado pelo Painel Financeiro					
	dbSelectArea(FinWindow:cAliasFile)					
	FinVisual(FinWindow:cAliasFile,FinWindow,(FinWindow:cAliasFile)->(Recno()),.T.)
Endif 

Return lRET



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GetMoedas ºAutor  ³Valdemir / Eduardo     º Data ³  15/09/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Obter as moedas utilizadas pelo sistema                       º±±
±±º          ³ Parametros:                                                   º±±
±±º          ³ Nenhum                                                        º±±
±±º          ³ Retorno:                                                      º±±
±±º          ³ aRet[n] = Codigo da moeda + Descricao                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Fina240                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetMoedas()
Local aRet     := {}
Local aArea    := GetArea()
Local aAreaSx6 := Sx6->(GetArea())
Local cFilSx6
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa array com as moedas existentes.						  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
GetMv("MV_MOEDA1")
cFilSx6 := SX6->X6_FIL
While Substr(SX6->X6_VAR,1,8) == "MV_MOEDA" .And. ;
		SX6->(!Eof()) .And. SX6->X6_FIL == cFilSx6
	If Substr(SX6->X6_VAR,9,1) != "P" .AND. Substr(SX6->X6_VAR,9,2) != "CM" // Desconsiderar plural e MV_MOEDACM
		Aadd( aRet, StrZero(Val(Substr(SX6->X6_VAR,9,2)),2) + " " + GetMv(SX6->X6_VAR) )
	Endif
	SX6->(DbSkip())
EndDo
ASort(aRet)
Sx6->(RestArea(aAreaSx6))
RestArea(aArea)

Return aRet






/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³f240QryA  ºAutor  ³Valdemir / Eduardo     º Data ³  12/09/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para consulta e atualizacao da lista de borderos       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINA240v                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function f240QryA(lAtua, cAliasSE2, aCampos, aRestrict, lTop, cIndTemp1, cIndTemp2, aCpoSel)

Local cQuery	:= ""
Local cFiltro	:= ""
Local aStru 	:= {}
Local lF240Qry	:= GetMV( "MV_F240QRY" ,.T.,.F.)  // Define se a busca no botão Pesquisa será efetuada por uma indregua com indices ou 
Local lF240IND	:= ExistBlock("F240IND")
Local cFils		:= ""

Local lAcessa	:= .T.

//--- Tratamento Gestao Corporativa
Local lGestao   := Iif( lFWCodFil, FWSizeFilial() > 2, .F. )	// Indica se usa Gestao Corporativa
//
Local cFilFwSE2 := IIF( lGestao .And. FindFunction("FwFilial"), FwFilial("SE2") , xFilial("SE2") )
ProcLogAtu("INICIO")
ProcLogAtu("MENSAGEM","inicia o processamento da query")//"INICIO DO PROCESSAMENTO DA QUERY" //
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna filiais que o usuario tem acesso                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				              
cFils := F240RetFils( mv_par03, mv_par04 )

If mv_par02 == 1 .And. !("@@" $ cFils)
	lAcessa := !Empty( cFils )
EndIf

If !lAcessa
	Return "NOACESS"
EndIf

#IFNDEF TOP
	Return ""
#ENDIF

If Select(cAliasSE2) > 0
	aGetMark := F240Markdos(cAliasSE2)
Endif

dbSelectArea("SE2")
aStru := SE2->(DbStruct())

If Empty(mv_par03)
	mv_par03 := Space( TamSX3( "E2_FILIAL" )[1] )
Endif
ProcLogAtu("INICIO","EXECUÇÃO DA QUERY")//Log Execução da Query  //

If lAtua
	If Select(cAliasSE2) # 0
		dbSelectArea(cAliasSE2)
		dbCloseArea()
		fErase(cAliasSE2 + GetDbExtension())
		fErase(cAliasSE2 + OrdBagExt())
	Endif
Endif
cFiltro := FA240Chec2()
cQuery := "SELECT E2_OK, "
aEval(aRestrict,{|x| cQuery += x + ", "})
cQuery += "R_E_C_N_O_ NUM_REG "
cQuery += "FROM " + RetSqlName("SE2") + " "
cQuery += "WHERE "

If mv_par02 == 1  // Considera Filiais ?
	If !Empty( cFils ) .and. !("@@" $ cFils)
		// Contas a pagar compartilhado deve observar FILORIG para realizar filtro
		If Empty( cFilFwSE2 )
			cQuery += "E2_FILORIG IN " + FormatIn( SubStr( cFils, 1, Len(cFils) - 1 ), "/" ) + " AND "
		Else	
			cQuery += "E2_FILIAL IN " + FormatIn( SubStr( cFils, 1, Len(cFils) - 1 ), "/" ) + " AND "
		EndIf	
	Else
		// Contas a pagar compartilhado deve observar FILORIG para realizar filtro
		If Empty( cFilFwSE2 )
			cQuery += "E2_FILORIG >= '" + mv_par03 + "' AND "
			cQuery += "E2_FILORIG <= '" + mv_par04 + "' AND "
		Else
			cQuery += "E2_FILIAL >= '" + mv_par03 + "' AND "
			cQuery += "E2_FILIAL <= '" + mv_par04 + "' AND "
		EndIf	
	EndIf
Else
	cQuery += "E2_FILIAL = '" + xFilial("SE2") + "' AND "
Endif

if lDDA
   aSort(aCpoSel,,, { |x, y| x < y })     // Vencimento
   dVenIni240 := aCpoSel[1]
   dVenFim240 := aCpoSel[Len(aCpoSel)]
endif

cQuery += "E2_VENCREA BETWEEN '" + DtoS(dVenIni240) + "' AND '" + DtoS(dVenFim240) + "' AND "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//? AAF - Titulos originados no SIGAEFF não devem ser alterados   ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery += " E2_ORIGEM <> 'SIGAEFF' AND "

cQuery += "D_E_L_E_T_ = ' ' AND "
cQuery += "E2_OK <> '' AND "
cQuery += cFiltro + " "
cQuery += "ORDER BY E2_FILIAL, E2_VENCREA, E2_NUM"
cQuery := ChangeQuery(cQuery)

if Select(cAliasSE2) > 0
	(cAliasSE2)->( dbCloseArea() )
endif
											
cArqNew := F240MTTMP(cQuery,aCampos,aRestrict,cAliasSE2,lF240Qry)
If lF240Qry		
	dbUseArea(.T.,"TOPCONN",cArqNew,cAliasSE2, .F., .F.)
	lTop	:= .T.
	ProcLogAtu("FIM",'Log')		// STR0120
Else
	dbUseArea(.T.,,cArqNew,cAliasSE2, .F., .F.)
	lTop	:= .F.
Endif	        
		
dbSelectArea(cAliasSE2)
ProcLogAtu("INICIO","UTILIZAÇÃO DO INDREGUA")//				
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//? Cria ordens de index para executar pesquisa - Aline          ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				              
IndRegua(cAliasSE2,cIndTemp2,"IND_REG",,,"Indexando arquivo....") //
IndRegua(cAliasSE2,cIndTemp1,SE2->(IndexKey()),,,"Indexando arquivo....") //  

If !lF240Qry
	dbSetIndex(cIndTemp2+OrdBagExt())
	dbSetOrder(1)
	If !Empty(cFil240)
		(cAliasSE2)->(dbsetfilter({||&cFil240},cFil240))
	Endif
EndIf		
	
If lAtua
	nValor := 0
	nQtdTit := 0
	nTotAbat := 0
	If !(cAliasSE2)->(Eof())
		dbEval({|x| fa240DbEva(nLimite,dVenIni240,dVenFim240,cAliasSE2,aGetMark)},{|| !Eof()})
		(cAliasSE2)->(dbGoTop())
	Endif
	oValor:Refresh()
	oQtda:Refresh()
	oMark:oBrowse:Refresh(.T.)
Endif
ProcLogAtu("FIM",'Log')//lOG   STR0121

Return cArqNew




/*/
?????????????????????????????????????????????????????????????????????????????
??ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ???
???Fun??o	 ?Fa240Top  ? Autor ? Valdemir / Eduardo    ? Data ?22.09.15  ???
??ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ???
???Descri??o ?Define Topo da MsSelect()   								  ???
??ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ???
??? Uso		 ? Generico 												  ???
??ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ??
?????????????????????????????????????????????????????????????????????????????
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function _Fa240Top(nTipo)

//--- Tratamento Gestao Corporativa
Local lGestao   := Iif( lFWCodFil, FWSizeFilial() > 2, .F. )	// Indica se usa Gestao Corporativa
//
Local cFilFwSE2 := IIF( lGestao .And. FindFunction("FwFilial"), FwFilial("SE2") , xFilial("SE2") )

// mv_par 02 = Considera Filiais Abaixo
// nTipo = 1 -> Verificando o topo da MsSelect
// nTipo = 2 -> Verificando o fim da Msselect
Return(IIF(mv_par02==1, IIf(nTipo==1,Iif( Empty( cFilFwSE2 ), xFilial("SE2"), mv_par03), mv_par04), xFilial("SE2") ) )





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
?????????????????????????????????????????????????????????????????????????????
??ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ???
??ºPrograma  ?TELACPGAR ºAutor  ?Valdemir / Eduardo  º Data ?  10/09/15   º??
??ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ???
??ºDesc.     ? Faz tratamento Bordero, separação da modalidade de Pagto.  º??
??º          ?                                                            º??
??ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ???
??ºUso       ? AP                                                         º??
??ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ???
?????????????????????????????????????????????????????????????????????????????
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _GetBco341(cAliasTMP)
	Local aRET := {}     
	Local nX   := 0
	
	SA2->( dbSeek(xFilial('SA2')+(cAliasTMP)->E2_FORNECE+(cAliasTMP)->E2_LOJA) )

	// PAGAMENTO A FORNECEDORES
	IF ((SA2->A2_BANCO=_cBanco) .or. (_cBanco='341') .or. (_cBanco='033') .or. (_cBanco='353')) .AND. EMPTY((cAliasTMP)->E2_CODBAR) .AND. ((cAliasTMP)->E2_TIPO $ 'NF /BON')
	    // 
	    if (SA2->(FieldPos('A2_XTPCONT')) > 0) .and. (SA2->A2_XTPCONT = '2') .and. ((cAliasTMP)->E2_PREFIXO <> 'ORD') .and. ((_cBanco='341') .or. (_cBanco='001'))
			aRET :=  {'05', '20'} 				// Transferencia Conta Poupança
	    elseif (cAliasTMP)->E2_PREFIXO == 'ORD' .and. (_cBanco == '341')
	        aRET := {'10', '20'}     			// ORDEM DE PAGAMENTO
	    elseif ((cAliasTMP)->E2_SALDO <= 500) .and. (SA2->A2_BANCO<>_cBanco)
	       IF (_cBanco='033' .AND. SA2->A2_BANCO='353')
	          aRET :=  {'01', '20'} 			// Transferencia Conta Corrente
	       ELSE
			  aRET := {'03', '20'}				// DOC                              $	    
	       Endif
		elseif (cAliasTMP)->E2_SALDO > 500 .AND. EMPTY((cAliasTMP)->E2_CODBAR) .AND. EMPTY((cAliasTMP)->E2_XESCRT) .AND. ((cAliasTMP)->E2_TIPO = 'NF ')
		      if _cBanco <> '237'
				aRET := {'41', '20'}    		// TED ou outra Titularidade
		      else
				aRET := {'08', '20'}    		// TED ou outra Titularidade
		      endif
		else
		   aRET :=  {'01', '20'} 				// Transferencia Conta Corrente
	    endif
	    
	elseif ((cAliasTMP)->E2_SALDO <= 500) .and. (SA2->A2_BANCO<>_cBanco) .AND. EMPTY((cAliasTMP)->E2_CODBAR) .AND. ((cAliasTMP)->E2_TIPO = 'NF ')
			aRET := {'03', '20'}				// DOC                              $
	elseif (cAliasTMP)->E2_SALDO > 500 .AND. EMPTY((cAliasTMP)->E2_CODBAR) .AND. EMPTY((cAliasTMP)->E2_XESCRT) .AND. ((cAliasTMP)->E2_TIPO = 'NF ')
	      if _cBanco <> '237'
			aRET := {'41', '20'}    			// TED ou outra Titularidade
	      else
			aRET := {'08', '20'}    			// TED ou outra Titularidade
	      endif
	elseif SUBSTR((cAliasTMP)->E2_CODBAR,1,1) $"8/9" .AND. (cAliasTMP)->E2_TIPO $ 'CON' .and. (_cBanco='341')
			aRET := {'13', '20'}   				// Concessionaria (Agua, Luz e Telefone)
	elseif SUBSTR((cAliasTMP)->E2_CODBAR,1,1) $"8/9" .AND. (cAliasTMP)->E2_TIPO $ 'CON/GNR' .and. (_cBanco <> '341')
			aRET := {'11', '22'}   				// Concessionaria (Agua, Luz e Telefone)
	elseif SUBSTR((cAliasTMP)->E2_CODBAR,1,3) = _cBanco .and. ((cAliasTMP)->E2_TIPO $ 'NF ')
			aRET := {'30', '20'}     			// Boleto mesmo banco
	elseIF SUBSTR((cAliasTMP)->E2_CODBAR,1,3) <> _cBanco .and. (!Left((cAliasTMP)->E2_CODBAR,1) $ '8/9') .and. ((cAliasTMP)->E2_TIPO $ 'NF ')
			aRET := {'31', '20'}     			// Boleto outros bancos
    elseIF (cAliasTMP)->E2_PREFIXO == 'ORD' .and. _cBanco == '341' 
			aRET := {'10', '20'}     			// ORDEM DE PAGAMENTO
    Endif
                               
	// PAGAMENTO DE TRIBUTOS
	IF (cAliasTMP)->E2_TIPO $ "CF-/COF/CS-/IS-/IR-/IRF/CSS/PI-/PIS" .and. EMPTY((cAliasTMP)->E2_CODBAR) .AND. ((cAliasTMP)->E2_XESCRT $ '0561  /1097  /5123  /1708  /2089  /2172  /2372  /3208  /5952  /8045  /8109  /8301  ')
			aRET :=  {'16', '22'}    		// tributos darf
	elseif (cAliasTMP)->E2_TIPO $ "IN-/INS" .and. EMPTY((cAliasTMP)->E2_CODBAR) .AND. ((cAliasTMP)->E2_XESCRT $ '1007  /1104  /1120  /1147  /1163  /1180  /1201  /1406  /1457  /1473  /1490  /1503  /1554  /1600  /1651  /1708  /1759  /2003  /2011  /2020  /2100  /2119  /2127  /2143  /2208  /2216  /2240  /2305  /2321  /2402  /2429  /2437  /2445  /2500  /2550  /2607  /2615  /2631  /2640  /2658  /2682  /2704  /2712  /2801  /2810  /2852  /2879  /2909  /2917  /2950  /2976  /3000  /3107  /3204  /4006  /4103  /4200  /4308  /4316  /4995  /5037  /5045  /5053  /5061  /5070  /5088  /5096  /5100  /5118  /5126  /5134  /6009  /6106  /6203  /6300  /6408  /6432  /6440  /6459  /6467  /6505  /6513  /6602  /6610  /6629  /6670  /6700  /6718  /6742  /6750  /7307  /7315  /8001  /8109  /8133  /8141  /8150  /8168  /8176  /8206  /8214  /8222  /8257  /8303  /8311  /8346  /8354  /8362  /8370  /8400  /8419  /8443  /8451  /8605  /8907  /8915  /8940  /8958  /9008  /9016  /9105  /9113  /9202  /9210  ') 
			aRET := {'17', '22'}    		// tributos ins
	elseif (cAliasTMP)->E2_TIPO $ "CF-/COF/CS-/IS-/IR-/IRF/ISS/CSS/PI-/PIS" .and. ((cAliasTMP)->E2_XESCRT='6106') .and. EMPTY((cAliasTMP)->E2_CODBAR)
		    aRET := {'18', '22'}    		// tributos DARF Simples
	elseif SE2->E2_TIPO $ "IP-/IPT" .and. EMPTY((cAliasTMP)->E2_CODBAR)
			aRET := {'19', '22'}    		// tributos iptu
	elseif (cAliasTMP)->E2_TIPO $ "IC-/ICM" .and. EMPTY((cAliasTMP)->E2_CODBAR) .AND. ((cAliasTMP)->E2_XESCRT $ '0462  /0607  /0632  /0759  /0772  /0784  /0814  /1065  /1107  /1120  /1144  /1156  /1170  /1200  /1235  /1284  /1375  /1417  /1466  /1545  /6403  /8928  ')
			aRET :=  {'22', '22'}    		// tributos GARE SP ICMS s/ cod. barras
		/*
	elseif SE2->E2_ESOPIP <> 0
			aRET := {'25', '22'}    // tributos IPVA
	elseif SE2->E2_ESOPIP = 0   
		
		0=Pagto DPVAT;1=Parc Unica c/ Desc;2=Parc Unica s/ Desc;3=Parc n° 1;4=Parc n° 2;5=Parc n° 3;6=Parc n° 4;7=Parc n° 5;8=Parc n° 6
		
			aRET := {'27', '22'}    // tributos DPVAT
			*/
	elseif !EMPTY((cAliasTMP)->E2_XESNFGT) .AND. !EMPTY((cAliasTMP)->E2_CODBAR)
			aRET := {'35', '22'}       		// tributos FGTS s/ e c/ cod. barrras
	elseif  !EMPTY((cAliasTMP)->E2_CODBAR) .AND. (_cBanco=='341') .AND.;
			(cAliasTMP)->E2_TIPO $ "GNR/TX " .AND. LEFT((cAliasTMP)->E2_CODBAR,1) $ '8/9'
			aRET := {'91', '22'}    		// tributos GNRE e Tributos c cod. barras
	elseif  !EMPTY((cAliasTMP)->E2_CODBAR) .AND. (_cBanco<>'341') .AND.;
			(cAliasTMP)->E2_TIPO $ "CF-/COF/CS-/IS-/IR-/IRF/ISS/CSS/PI-/PIS/IN/INS/IC-/ICM" .AND. LEFT((cAliasTMP)->E2_CODBAR,1) $ '8/9'
			aRET := {'11', '22'}    		// tributos GNRE e Tributos c cod. barras
	endif  
	
	if Len(aRET) = 0
	   cMsg := "Banco Fornecedor: "+SA2->A2_BANCO+" - Banco Parâmetro: "+_cBanco+cENTER
	   cMsg += "Tipo a Pagar: "+(cAliasTMP)->E2_TIPO+" Aceita: NF/BON/CON ou CF-/COF/CS-/IS-/IR-/IRF/CSS/PI-/PIS ou IP-/IPT ou IC-/ICM"+cENTER
	   
	   apMsgInfo(cMsg, "Mensagem")
	
	Endif

Return aRET






/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINA240E  ºAutor  ³Microsiga           º Data ³  10/08/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetSE2TMP(cAliasSE2)
	Local cArq 		:= CriaTrab(Nil,.F.)
	Local aSaveArea := GetArea() 
	Local aTMP      := {}
	Local cModPgto  := ''
	Local cTipoPag  := '' 
	Local nCont     := 0
	
	If File(cArq)  //DBF
		DestroiArq(cArq)
	endif
	//Verificar se Existe Arquivo
	If !File(cArq)  //DBF
		CriaArq(cArq, cAliasSE2)
	Endif	
	
	// Carrega Registros
	(cAliasSE2)->( dbGotop() )
	While (cAliasSE2)->(!Eof())
	
      If !Empty((cAliasSE2)->E2_OK)
		aTMP     := _GetBco341(cAliasSE2)
		if Len(aTMP)=0
		   Return 'TSE2'
		Endif
		cModPgto := aTMP[1]    
		cTipoPag := aTMP[2]
			 
		dbSelectArea("TSE2")
		dbAppend()
		For nCont := 1 To (cAliasSE2)->( FCOUNT() )
		   if TSE2->(FieldPos( (cAliasSE2)->(FieldName(nCont)) )) > 0
			  TSE2->( FieldPut(TSE2->(FieldPos( (cAliasSE2)->(FieldName(nCont)) )), (cAliasSE2)->&( FieldName(nCont) ) ) )
		   endif
		Next nCont
		TSE2->E2_MODAL := cModPgto
		TSE2->E2_TIPOP := cTipoPag
		MsUnlock()  
		               
	  endif    
	  
	  dbSelectArea(cAliasSE2)
	  dbSkip()
	EndDo
	
	RestArea(aSaveArea)  
	
	dbSelectArea('TSE2')
	dbGotop()
	
Return 'TSE2'




Static Function CriaArq(cArqTmp, pcAliasSE2)
	Local aStruc  := {}
	Local cChvTRB1 := ""
	Local cFWork2 := cChvTRB2 := ""
	
	// Prepara estrutura para arquivo temporario
	dbSelectArea(pcAliasSE2)
	aStru     := dbStruct()	

	Aadd(aStru,{"E2_MODAL","C",2,0})	
	Aadd(aStru,{"E2_TIPOP","C",2,0})	

	cFWork1 := cArqTmp

	dBCreate(cFWork1,aStru)
	
	dbUseArea(.T.,,cFWork1,"TSE2")
    
	//Chave do Indice
	cChvTRB1 := "E2_MODAL"
	
	//Criacao do Indice
	IndRegua("TSE2",cFWork1,cChvTRB1,,,"Selecionando Registros")
		
Return 
                                   


static function DestroiArq(cFWork1)
	
	If File(cFWork1 + OrdBagExt())     
		//Fecha Arquivo 
		if Select('TSE2') > 0
			TSE2->( dbCloseArea() )
		endif
		Ferase (cFWork1+OrdBagExt())
		Ferase(cFWork1+GetDBExtension())		
	Endif
	
Return


#INCLUDE "PROTHEUS.CH"

/*���������������������������������������������������������������������������
���Programa  � LISTSE1  �Autor  �Eduardo Augusto     � Data �  26/09/2014 ���
���Programa  � Alterado �Autor  �Valdemir Jose       � Data �  18/08/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � Fonte para Tratamento de tela para filtro dos titulos para ���
���          � gera��o dos boletos 										  ���
���          �     								                          ���
�������������������������������������������������������������������������͹��
���Uso       � EV Solution System                                  		  ���
���������������������������������������������������������������������������*/

User Function TELABOL()
Local oFont1 := TFont():New("MS Sans Serif",,016,,.T.,,,,,.F.,.F.)
Local oCanceTot
Local oCanceBol
Local oAjusta
Local oConfirma
Local oCancela
Local oDesconto
Local oACresc
Local oGroup1
Local nItens  := nValores := 0
Local cFilter := ""
Local bFilter := {}
Local oMenu
Local bSavKeyF12 := SetKey(VK_F12, Nil)

Private cTitulo  := "SELE��O DE BOLETOS"
Private oOk := LoadBitmap(GetResources(),"LBOK")
Private oNo := LoadBitmap(GetResources(),"LBNO")
Private cVar
Private oDlg
Private oChk
Private oChkBol
Private oChkBor
Private oChkCNB
Private oLbx
Private lChk    := .F.
Private lChkBol := .T.
Private lChkBor := .T.
Private lChkCNB := .T.
Private lMark   := .F.
Private aVetor  := {}
Private cPerg   := "TELABOL"
Private lChkVld := .F.

SetKey( VK_F12, {||  GetNewTela() } )

ValidPerg()
If !Pergunte(cPerg,.T.)	// SELECIONE O BANCO
	Return
EndIf

Private _cBanco		:= Mv_Par01
Private _cAgencia	:= Mv_Par02
Private _cConta		:= Mv_Par03
Private _cSubcta	:= Mv_Par04
Private _Tipo		:= Mv_Par05
Private _nArqAbr    := _nEmail := 0
Private _EmisIni 	:= Mv_Par06
Private _EmisFim 	:= Mv_Par07
Private _cTitulo 	:= Mv_Par08

// Valida CNPJ da Empresa
if !U_ValidCNPJ()
	Return
Endif

U_VLPastas()

DbSelectArea("SEE")
SEE->(DbSetOrder(1))	// EE_FILIAL+EE_CODIGO+EE_AGENCIA+EE_CONTA+EE_SUBCTA
SEE->(DbSeek(xFilial("SEE") + _cBanco + _cAgencia + _cConta + _cSubcta ))

If Select("TMP1") > 0
	TMP1->(DbCloseArea())
EndIf
cQuery := " SELECT E1_PORTADO, E1_AGEDEP, E1_CONTA, E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_CLIENTE, E1_LOJA, E1_NOMCLI, E1_EMISSAO, E1_VALOR, E1_VENCTO, E1_VENCREA, E1_TIPO, E1_PORTADO, E1_NUMBOR, E1_NUMBCO, E1_XNUMBCO FROM "
cQuery += RetSqlName("SE1")
cQuery += " WHERE D_E_L_E_T_ = '' "
If _Tipo == 1
	cQuery += " AND E1_SALDO <> 0 "
	cQuery += " AND E1_NUMBCO = '' "
	cQuery += " AND E1_XNUMBCO = '' "
	cQuery += " AND E1_NUMBOR = '' "
	cQuery += " AND E1_TIPO IN ('NF','BOL','FT','DP','ND') "
	If !Empty(_cTitulo)
		cQuery += " AND E1_NUM = '" + _cTitulo + "' "
	Else
		cQuery += " AND E1_EMISSAO BETWEEN  '" + DtoS(_EmisIni) + "' AND '" + DtoS(_EmisFim) + "' "
	EndIf
ElseIf _Tipo == 2
	cQuery += " AND E1_PORTADO = '" + _cBanco + "' "
	cQuery += " AND E1_AGEDEP = '" + _cAgencia + "' "
	cQuery += " AND E1_CONTA = '" + _cConta + "' "
	cQuery += " AND E1_SALDO <> 0 "
	if (SEE->EE_XIMPBOL == "S")
		cQuery += " AND E1_XNUMBCO <> '' "
	endif
	cQuery += " AND E1_NUMBOR <> '' "
	cQuery += " AND E1_TIPO IN ('NF','BOL','FT','DP','ND') "
	If !Empty(_cTitulo)
		cQuery += " AND E1_NUM = '" + _cTitulo + "' "
	Else
		cQuery += " AND E1_EMISSAO BETWEEN  '" + DtoS(_EmisIni) + "' AND '" + DtoS(_EmisFim) + "' "
	EndIf
EndIf
cQuery := ChangeQuery(cQuery)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMP1', .F., .T.)
TcSetField("TMP1","E1_EMISSAO","D")
TcSetField("TMP1","E1_VENCTO" ,"D")
TcSetField("TMP1","E1_VENCREA","D")
TcSetField("TMP1","E1_VALOR"  ,"N",12,2)
DbSelectArea("TMP1")
DbGoTop()
While !Eof()
	aAdd(aVetor, { lMark, TMP1->E1_PREFIXO, TMP1->E1_NUM, TMP1->E1_PARCELA, TMP1->E1_CLIENTE, TMP1->E1_LOJA, TMP1->E1_NOMCLI, TMP1->E1_EMISSAO, AllTrim(Transform(TMP1->E1_VALOR,"@E 999,999,999.99")), TMP1->E1_VENCTO, TMP1->E1_VENCREA, TMP1->E1_TIPO, TMP1->E1_PORTADO, TMP1->E1_AGEDEP, TMP1->E1_CONTA, TMP1->E1_NUMBOR, TMP1->E1_NUMBCO, TMP1->E1_XNUMBCO, TMP1->E1_FILIAL,.f. })
	DbSelectArea("TMP1")
	DbSkip()
End
DbSelectArea("TMP1")

If Len(aVetor) == 0
	MsgAlert("N�o foi Selecionado nenhum Titulo para Impress�o de Boleto",cTitulo)
	Return
EndIf

// Valida��o de Restri��o de Datas
if !u_VldDtLim()
    Return
endif

cLogoD   := GetSrvProfString("Startpath","") + "Logo"+alltrim(Mv_Par01)+".JPG"

DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 To 570,1292 COLORS 0,16772829 PIXEL STYLE nOR( WS_VISIBLE, WS_POPUP )

oFWLMain := FWLayer():New()
oFWLMain:Init( oDlg, .T. )
oFWLMain:AddLine("LineSup",075,.T.)
oFWLMain:AddLine("LineInf",022,.T.)

oFWLMain:AddCollumn( "ColSP01", 098, .T.,"LineSup" )
oFWLMain:AddWindow( "ColSP01", "WinSP01", "Sele��o Boletos", 100, .F., .F.,/*bAction*/,"LineSup",/*bGotFocus*/)
oWinSP01 := oFWLMain:GetWinPanel('ColSP01','WinSP01',"LineSup" )

oFWLMain:AddCollumn( "Col01", 030, .T.,"LineInf" )
oFWLMain:AddCollumn( "Col02", 030, .T.,"LineInf" )
oFWLMain:AddCollumn( "Col03", 038, .T.,"LineInf" )

oFWLMain:AddWindow( "Col01", "Win01", "Logotpo Banco"      ,100, .F., .F.,/*bAction*/,"LineInf",/*bGotFocus*/)
oFWLMain:AddWindow( "Col02", "Win02", "Total Selecionado"  ,100, .F., .F.,/*bAction*/,"LineInf",/*bGotFocus*/)
oFWLMain:AddWindow( "Col03", "Win03", "Bot�es"  		   ,098, .F., .F.,/*bAction*/,"LineInf",/*bGotFocus*/)
oWin1 := oFWLMain:GetWinPanel('Col01','Win01',"LineInf" )
oWin2 := oFWLMain:GetWinPanel('Col02','Win02',"LineInf" )
oWin3 := oFWLMain:GetWinPanel('Col03','Win03',"LineInf" )

@001,010 CHECKBOX oChk    VAR lChk    Prompt "Marca/Desmarca"    SIZE 60,007 PIXEL Of oWinSP01 On Click(aEval(aVetor,{|x| x[1] := lChk}),AtuPanel(oItens, oValores, aVetor, @nItens, @nValores),oLbx:Refresh())
@001,120 Say StrZero(_Tipo,2)+" Via" Size 60,007 PIXEL Of oWinSP01 FONT oFont1 COLORS 16711680, 16777215
@009,010 LISTBOX oLbx VAR cVar FIELDS Header " ", "Prefixo", "N� Titulo", "Parcela", "Cod. Cliente", "Loja", "Nome Cliente", "Data Emiss�o", "Valor R$", "Vencimento", "Vencimento Real", "Tipo", "Portador", "Agencia", "Conta", "Bordero", "Nosso N� Sistema", "Nosso N� Backup", "Filial" SIZE 610,165 Of oWinSP01 PIXEL ON dblClick(aVetor[oLbx:nAt,1] := (!aVetor[oLbx:nAt,1] ) ,, AtuPanel(oItens, oValores, aVetor, @nItens, @nValores),oLbx:Refresh())

oLbx:SetArray(aVetor)
oLbx:bLine := {|| { Iif(aVetor[oLbx:nAt,1],oOk,oNo), aVetor[oLbx:nAt,2], aVetor[oLbx:nAt,3], aVetor[oLbx:nAt,4], aVetor[oLbx:nAt,5], aVetor[oLbx:nAt,6], aVetor[oLbx:nAt,7], aVetor[oLbx:nAt,8], aVetor[oLbx:nAt,9], aVetor[oLbx:nAt,10], aVetor[oLbx:nAt,11], aVetor[oLbx:nAt,12], aVetor[oLbx:nAt,13], aVetor[oLbx:nAt,14], aVetor[oLbx:nAt,15], aVetor[oLbx:nAt,16], aVetor[oLbx:nAt,17], aVetor[oLbx:nAt,18], aVetor[oLbx:nAt,19], aVetor[oLbx:nAt,20] }}

// Apresenta banco selecionado
@ 005,015 BITMAP oBitmap1 SIZE 078, 037 OF oWin1 FILENAME cLogoD NOBORDER PIXEL

// Apresenta dados do banADMINco informado nos parametros
@ 005,0105 SAY "Banco: 	 "   SIZE 025, 007 OF oWin1  COLORS 0, 16777215 PIXEL
@ 014,0105 SAY "Ag�ncia: " 	 SIZE 025, 007 OF oWin1  COLORS 0, 16777215 PIXEL
@ 023,0105 SAY "Conta: 	 "   SIZE 025, 007 OF oWin1  COLORS 0, 16777215 PIXEL

@ 005,0135 SAY _cBanco	 SIZE 025, 007 OF oWin1  FONT oFont1 COLORS 16711680, 16777215 PIXEL
@ 014,0135 SAY _cAgencia SIZE 025, 007 OF oWin1  FONT oFont1 COLORS 16711680, 16777215 PIXEL
@ 023,0135 SAY _cConta	 SIZE 025, 007 OF oWin1  FONT oFont1 COLORS 16711680, 16777215 PIXEL

// Apresenta Quantidade e Valores selecionado
//@ 245,0175 GROUP oGroup1 TO 273, 350 PROMPT "Total Sele��o" OF oDlg COLOR 0, 16777215 PIXEL   //400
@ 005,060 SAY "Iten(s): 	 "   SIZE 025, 007 OF oWin2  COLORS 0, 16777215 PIXEL
@ 017,060 SAY "Valor(es): 	 "   SIZE 025, 007 OF oWin2  COLORS 0, 16777215 PIXEL
@ 005,105 SAY oItens   PROMPT  nItens	Picture "@E 999999999999"	 SIZE 040, 007 OF oWin2  FONT oFont1 COLORS 16711680, 16777215 PIXEL
@ 017,105 SAY oValores PROMPT  nValores	Picture "@E 999,999,999.99"  SIZE 040, 007 OF oWin2  FONT oFont1 COLORS 16711680, 16777215 PIXEL

nColb := 0
@002,010+nColb BUTTON oCanceTot PROMPT "Cancel.Bord" 	SIZE 050, 014 Font oDlg:oFont ACTION {Sob060(), Fa060Canc(), CanceTot(),AtuaTela("TMP1",@nItens, @nValores), SobPerg() } OF oWin3 PIXEL
//@243,410+nColb BUTTON oDesconto PROMPT "Desconto"   		SIZE 050, 014 Font oDlg:oFont ACTION {TelaAjuste('D',aVetor, oLbx:nAt), AtuaTela("TMP",@nItens, @nValores),	u_AbrirTela()}  OF oDlg PIXEL
//@243,460+nColb BUTTON oACresc   PROMPT "Acr�scimo"  SIZE 050, 014 Font oDlg:oFont ACTION {TelaAjuste('A',aVetor, oLbx:nAt),	u_AbrirTela()} OF oDlg PIXEL
@002,060+nColb BUTTON oConsulta PROMPT "Consulta"   	SIZE 050, 014 Font oDlg:oFont ACTION VisuSE1()  OF oWin3 PIXEL
@002,110+nColb BUTTON oCancela PROMPT  "Sair"		  	SIZE 050, 014 Font oDlg:oFont ACTION oDlg:End() OF oWin3 PIXEL
@002,160+nColb BUTTON oAjusta   PROMPT "Ajustar" 	  	SIZE 050, 014 Font oDlg:oFont ACTION {if(_Tipo=1,MsgRun("Ajuste utilizado somente para 2� via.",,{|| Sleep(2000) }), TelaAjuste('J',aVetor, oLbx:nAt)), ,AtuaTela("TMP1",@nItens, @nValores)} OF oWin3 PIXEL

@019,010+nColb BUTTON oConfirma PROMPT "Confirmar"  SIZE 050, 014 Font oDlg:oFont ACTION {ValidSel(),u_BOLETOS(aVetor,lChkBol,lChkBor),u_Abrirtela(), AtuaTela("TMP1",@nItens, @nValores)} Of oWin3 PIXEL
@019,060+nColb BUTTON oCancela PROMPT  "Abatimento" SIZE 050, 014 Font oDlg:oFont ACTION {TelaAjuste('B',aVetor, oLbx:nAt),AtuaTela("TMP1",@nItens, @nValores),	u_AbrirTela()} OF oWin3 PIXEL
//@260,460+nColb BUTTON oConsulta PROMPT "Consulta"   SIZE 050, 014 Font oDlg:oFont ACTION VisuSE1()  OF oDlg PIXEL
@019,110+nColb BUTTON oCancela PROMPT  "Sair"		  SIZE 050, 014 Font oDlg:oFont ACTION oDlg:End() OF oWin3 PIXEL
//@260,510+nColb BUTTON oAjusta   PROMPT "Ajustar" 	  	SIZE 050, 014 Font oDlg:oFont ACTION {if(_Tipo=1,MsgRun("Ajuste utilizado somente para 2� via.",,{|| Sleep(2000) }), TelaAjuste('J',aVetor, oLbx:nAt)), ,AtuaTela("TMP",@nItens, @nValores)} OF oDlg PIXEL

oChk:cToolTip 		:= "Marca ou Desmarca todos os registros"
oCanceTot:cToolTip 	:= "Cancela todos os boletos que estiverem marcados"       //
oAjusta:cToolTip 	:= "Abre tela de ajuste para o registro corrente"
oConfirma:cToolTip 	:= "Confirma inicializa��o de processo selecionado"
oConsulta:cToolTip 	:= "Consulta titulos com base no registro corrente selecionado"
oCancela:cToolTip 	:= "Retorna para tela anterior"
//oAcresc:cToolTip 	:= "Informar o Acr�scimo a ser adicionado no boleto"
//oDesconto:cToolTip 	:= "Informar o desconto a ser informado no boleto"
oCancela:cToolTip 	:= "Saira da tela de aumatiza��o de CNAB"

ACTIVATE MSDIALOG oDlg CENTER

SetKey(VK_F12,bSavKeyF12)

Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TelaAjuste�Autor  �Eduardo/Valdemir    � Data �  01/08/15   ���
��������������������������������*�����������������������������������������͹��
���Desc.     � Ajuste de Boleto                                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � EV Solution System                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function TelaAjuste(pTipo, aVetor, nAT)
Local nConta := 0
Local oDlgAJ
Local oltAcres
Local oltDecres
Local oltVencto
Local oltAbat
Local ogAcre
Local ogABat
Local ogDecres
Local ogVencto
Local aArea 	 := GetArea()
Local nDif  	 := 50	//if(_Tipo=2,50,0)
Local nDif2 	 := 28	//if(_Tipo=2,28,0)

Private cgAcre   := cgDecres := cgAbat := 0
Private cgVencto := ctod('  /  /  ')
PRIVATE lAtu2Via := .F.

	aEval(aVetor, { |X| if( X[1], nConta++,0)} )

	if nConta=0
	   MsgRun("N�o foi selecionado nenhum registro...",,{|| Sleep(2000) })
	   Return
	Endif


	DEFINE MSDIALOG oDlgAJ TITLE "Ajuste de Dados" FROM 000, 000  TO 260-(nDif+nDif2), 350 COLORS 0, 16777215 PIXEL  // Valdemir

	// Carrega Variavis
	dbSelectArea('SE1')      // E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO
	dbSetOrder(1)
	if dbSeek(xFilial('SE1')+aVetor[nAT][2] + aVetor[nAT][3] + aVetor[nAT][4] )
		cgAcre   := SE1->E1_ACRESC
		cgDecres := SE1->E1_DECRESC
		cgVencto := SE1->E1_VENCREA
	Endif
	@ 012, 018 GROUP ogGraud TO 103-nDif, 156 OF oDlgAJ COLOR 0, 16777215 PIXEL
	if (pTipo='A') .or. (pTipo='D') .or. (pTipo='B')
	   //if (pTipo='A')
	//	  @ 025, 028 SAY oltAcres 	PROMPT "Acr�scimo" 		SIZE 035, 007 OF oDlgAJ COLORS 0, 16777215 PIXEL
	//   endif
	//   if (pTipo = 'D')
	//	  @ 025, 028 SAY oltDecres    PROMPT "Descr�scimo" 	SIZE 035, 007 OF oDlgAJ COLORS 0, 16777215 PIXEL   // lin 051
	//   endif
	   if (pTipo='B')
		  @ 025, 028 SAY oltAbat 	PROMPT "Abatimento" 		SIZE 035, 007 OF oDlgAJ COLORS 0, 16777215 PIXEL
	   endif
	Endif

	if (pTipo = 'J')
		@ 075-nDif, 028 SAY oltVencto    PROMPT "Venc. Real" 	SIZE 035, 007 OF oDlgAJ COLORS 0, 16777215 PIXEL
    ENDIF
	if (pTipo='A') .or. (pTipo='D')  .or. (pTipo='B')
	  // if (pTipo='A')
		//@ 024, 068 MSGET  ogAcre    VAR cgAcre    Picture "@E 999,99,999.99"	SIZE 060, 010 OF oDlgAJ COLORS 0, 16777215 PIXEL
	   //endif
	   //if (pTipo='D')
	//	@ 024, 068 MSGET  ogDecres  VAR cgDecres  Picture "@E 999,99,999.99" 	SIZE 060, 010 OF oDlgAJ COLORS 0, 16777215 PIXEL  // lin 050
	//   endif
	   if (pTipo='B')
		@ 024, 068 MSGET  ogAbat    VAR cgAbat    Picture "@E 999,99,999.99"	SIZE 060, 010 OF oDlgAJ COLORS 0, 16777215 PIXEL
	   endif
	endif
	if (pTipo = 'J')
	   @ 074-nDif, 068 MSGET  ogVencto  VAR cgVencto  Picture "@D 99/99/9999" SIZE 060, 010 OF oDlgAJ COLORS 0, 16777215 PIXEL
	endif
	@ 109-nDif, 046 BUTTON oButton1 PROMPT "Ok" 		SIZE 037, 012 ACTION { VALVENC(cgVencto,oButton1),GrvDados(pTipo,aVetor,nAT,cgAcre, cgDecres,cgVencto,cgAbat),	u_AbrirTela(), oDlgAJ:end() } OF oDlgAJ PIXEL
	@ 109-nDif, 094 BUTTON oButton2 PROMPT "Sair" 	SIZE 037, 012 ACTION oDlgAJ:end() OF oDlgAJ PIXEL

	ACTIVATE MSDIALOG oDlgAJ CENTERED

	RestArea( aArea )

Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VALVENC   �Autor  �Eduardo/Valdemir    � Data �  18/08/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida Vencimento                                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � EV Solution System                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function VALVENC(cgVencto,poButton1)
Local lRET := .T.

	if _Tipo = 2
		lAtu2Via := apMsgYesNO('Deseja atualizar os valores do boleto','Aten��o!!!')
	Endif

	poButton1:SetFocus()

Return lRET

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GrvDados  �Autor  �Eduardo/Valdemir    � Data �  08/01/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Efetua atualiza��o da List e atualiza a tabela SE1         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � EV Solution System                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GrvDados(pTipo, aVetor, nAT, cgAcre, cgDecres, cgVencto, cgAbat)
	Local pE1_VENCREA:= cgVencto
	Local pE1_XMULTA := 0
	Local pE1_XJUROS := 0
	Local pE1_ACRESC := 0
	Local pE1_HIST	 := ""
	Local dVenc      := ctod('  /  /  ')
	Local lTelaOcor  := .F.

	Private aCposAlter
	Private lIntegracao := IF(GetMV("MV_EASY")=="S",.T.,.F.)
	Private cCADASTRO   := 'ALTERA��O'

	U_VLPastas()

	dbSelectArea('SE1')      // E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO
	dbSetOrder(1)
	if dbSeek(xFilial('SE1') + aVetor[nAT][2] + aVetor[nAT][3] + aVetor[nAT][4] )
	  if pTipo = 'J'
	    dVenc      := SE1->E1_VENCREA
		XJURO(@pE1_VENCREA, @pE1_XMULTA, @pE1_XJUROS, @pE1_ACRESC, @pE1_HIST)
	    RecLock('SE1',.F.)
	    if (_Tipo=2 .AND. lAtu2Via) //.or. (lAtu2Via)
			SE1->E1_ACRESC  := pE1_ACRESC
			//SE1->E1_DECRESC := cgDecres
			SE1->E1_XJUROS  := pE1_XJUROS
			SE1->E1_XMULTA  := pE1_XMULTA
			SE1->E1_HIST	:= pE1_HIST
			//SE1->E1_VALOR   := SE1->E1_VALOR+pE1_XJUROS+pE1_XMULTA
			//SE1->E1_SALDO   := SE1->E1_VALOR      - 16/07/2016 para n�o alterar o valor do titulo no arquivo
		Endif
		SE1->E1_VENCREA := pE1_VENCREA
		MsUnlock()
		// Ira atualizar instru��o caso tenha sido alterado vencimento
		if (dVenc <> SE1->E1_VENCREA) .and. (_Tipo=2)
			TelaAOcor()
			lTelaOcor  := .T.
		endif
		aVetor[nAT][13] := .T.
	  else
	    // Controla se teve acrescimo e desconto
	    RecLock('SE1',.F.)
	    if pTipo = 'D'
			SE1->E1_DECRESC := cgDecres
	    elseif pTipo = 'B'
			SE1->E1_XABATIM := cgAbat
	    elseif pTipo = 'A'
			SE1->E1_ACRESC  := pE1_ACRESC     //SE1->E1_ACRESC + cgAcre
	    	//SE1->E1_VALOR   := SE1->E1_VALOR + cgAcre
	    	//SE1->E1_SALDO   := SE1->E1_VALOR - 16/07/2016 para n�o alterar o valor do titulo no arquivo
	    endif
	    msUnlock()
	    if pTipo = 'B' .or. pTipo = 'D'        // B - Abatimento / D - Desconto
	       TelaAOcor()
	       lTelaOcor  := .T.
	    Endif
	  endif
	Endif
	if lTelaOcor
     	u_AbrirTela()
	endif

Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �XJUROS    �Autor  �Eduardo/Valdemir    � Data �  08/01/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � EV Solution System                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function XJURO(pE1_VENCREA, pE1_XMULTA, pE1_XJUROS, pE1_ACRESC, pE1_HIST)
Local nValor	:= SE1->E1_VALOR
Local nJuro		:= GetMV("MV_XJUROS")/100 // Multa 1,5% ao M�s.    GetMV("MV_XJUROS")
Local nMulta	:= GetMV("MV_XMULTA")/100 // Multa 10% por atraso. GetMV("MV_XMULTA")
Local nJRata	:= 0
Local cHistor	:= ""
Local lCampos	:= SE1->(FieldPos("E1_XJUROS")) > 0 .And. SE1->(FieldPos("E1_XMULTA")) > 0

U_VLPastas()

If ALLTRIM(SE1->E1_TIPO) $ "NF|BOL|FT|DP|ND" .And.  lCampos
	If pE1_VENCREA <> SE1->E1_VENCREA
	        nJRata 			:= PrRata(pE1_VENCREA)
			pE1_XMULTA	:= NOROUND( (nValor*nMulta) , 2 )
	       	pE1_XJUROS 	:= NOROUND( nValor*(nJuro*(nJRata)) , 4 )
	       	cHistor		:=" Juros R$ " +ALLTRIM( cValToChar(  TransForm( pE1_XJUROS ,PesqPict('SE1','E1_XJUROS')  ) ) )
		    pE1_ACRESC	:= NOROUND( pE1_XMULTA + pE1_XJUROS , 2 )
		    pE1_HIST 	:= "Multa R$ "+ALLTRIM( cValToChar(  TransForm( NOROUND( (nValor*nMulta) , 2 ) ,PesqPict('SE1','E1_XMULTA')  ) ) ) + cHistor
	EndIf
EndIf


Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ProRata   �Autor  �Eduardo/Valdemir    � Data �  18/08/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para calcular o dias da prorata conforme            ���
���          � regra pro rata ( SIMPLES )                                 ���
�������������������������������������������������������������������������͹��
���Uso       � EV Solution System                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
 */
Static Function PrRata(pE1_VENCREA)
//Fonte : http://calculoexato.com.br/result.aspx?codMenu=FinanJurosSobreValor&cce=011
Local nProrata	:= 0

	If  DateDiffMonth(SE1->E1_VENCTO, pE1_VENCREA) == 0
		nProrata := (DateDiffDay (SE1->E1_VENCTO, pE1_VENCREA) +1)/Last_Day(pE1_VENCREA)
	ElseIf DateDiffMonth(SE1->E1_VENCTO, pE1_VENCREA) == 1
   		nProrata := ( (Last_Day(SE1->E1_VENCTO) - ( Day(SE1->E1_VENCTO) ) )+1) /Last_Day(SE1->E1_VENCTO)  +  ( Day(pE1_VENCREA)-1 ) / Last_Day(pE1_VENCREA)
	ElseIf DateDiffMonth(SE1->E1_VENCTO,pE1_VENCREA) > 1
		nProrata := ( (Last_Day(SE1->E1_VENCTO) - ( Day(SE1->E1_VENCTO) ) )+1) /Last_Day(SE1->E1_VENCTO)  +  ( Day(pE1_VENCREA)-1 ) / Last_Day(pE1_VENCREA)+ DateDiffMonth(SE1->E1_VENCTO, pE1_VENCREA)-1
	EndIf

Return(nProrata)




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TELABOL   �Autor  �Eduardo/Valdemir    � Data �  08/01/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza Painel de Totais Selecionados                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � EV Solution System                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AtuPanel(oItens, oValores, aVetor, nQuant, pnValor)
Local nX := 0

nQuant := 0
pnValor := 0

For nX := 1 To Len(aVetor)
	if aVetor[nX][1]
		nQuant += 1
		pnValor += val(StrTran(StrTran(aVetor[nX][9],'.',''),',','.'))
	Endif
Next

oItens:Refresh()
oValores:Refresh()

Return




/*���������������������������������������������������������������������������
���Programa  � VisuSE1  �Autor  �Eduardo Augusto     � Data �  22/10/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para Chamada do mBrowse da Tela de Inlcusao do      ���
���          � Contas a Receber (Somente Consulta)             			  ���
�������������������������������������������������������������������������͹��
���Uso       � EV Solution System                                   ���
���������������������������������������������������������������������������*/

Static Function VisuSE1()
Private cCadastro := "Tela do Contas a Receber"
Private aRotina := { {"Pesquisar","AxPesqui",0,1}, {"Visualizar","AxVisual",0,2} }
Private cDelFunc := ".T."

if !ValidSel()
	Return
Endif

Private cString := "SE1"
DbSelectArea("SE1")
SE1->(DbSetOrder(1)) // E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO
DbSelectArea(cString)
mBrowse(6,1,22,75,cString)

Return

/*���������������������������������������������������������������������������
���Programa  �Marca     �Autor  �EV Solution System  � Data �  22/10/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao que Marca ou Desmarca todos os Objetos.             ���
���������������������������������������������������������������������������*/

Static Function Marca(lMarca)
For i := 1 To Len(aVetor)
	aVetor[i][1] := lMarca
Next
oLbx:Refresh()
Return

/*���������������������������������������������������������������������������
���Programa  �CANCEBOL  �Autor  �EV Solution System  � Data �  22/10/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para Limpar os campos da Tabela SE1 quando o Boleto ���
���		     � sofrer Altera��o p/ gerar novamente 2� Via...			  ���
���������������������������������������������������������������������������*/

Static Function CanceBol()
Local nConta := 0

U_VLPastas()

aEval(aVetor, { |X| if( X[1], nConta++,0)} )

if nConta=0
   MsgRun("N�o foi selecionado nenhum registro...",,{|| Sleep(2000) })
   Return
Endif

For i := 1 To Len(aVetor)
	If aVetor [i][1] == .T.
		DbSelectArea("SE1")
		DbSetOrder(1)
		If DbSeek(xFilial("SE1") + aVetor[i][2] + aVetor[i][3] + aVetor[i][4])
			RecLock("SE1",.F.)
			SE1->E1_NUMBCO := ""
			SE1->E1_CODBAR := ""
			SE1->E1_CODDIG := ""
			MsUnLock()
		EndIf
	EndIf
Next
MsgRun("Cancelamento de Boleto p/ 2� Via Finalizado com Sucesso",,{|| Sleep(2000) })
Return



/*���������������������������������������������������������������������������
���Programa  �CANCETOT  �Autor  �EV Solution System  � Data �  22/10/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para Limpar os campos da Tabela SE1 quando o Boleto ���
���		     � sofrer cancelamento total das informa��es...				  ���
���������������������������������������������������������������������������*/
Static Function CanceTot()
Local nConta := 0

U_VLPastas()

aEval(aVetor, { |X| if( X[1], nConta++,0)} )

if nConta=0
   MsgRun("N�o foi selecionado nenhum registro...",,{|| Sleep(2000) })
   Return
Endif

For i := 1 To Len(aVetor)
	If aVetor [i][1] == .T.
		DbSelectArea("SE1")
		DbSetOrder(1)
		If DbSeek(xFilial("SE1") + aVetor[i][2] + aVetor[i][3] + aVetor[i][4])
		    // Verifica se existe Bordero, caso tenha deleta
		    if !Empty(SE1->E1_NUMBOR)
			    if SEA->( dbSeek(xFilial('SEA')+SE1->E1_NUMBOR) )
			       RecLock('SEA',.F.)
			       SEA->( dbDelete() )
			       MsUnlock()
			    endif
		    endif
		    // Libera Titulo para efetuar novo procedimento
			RecLock("SE1",.F.)
			//SE1->E1_NUMBCO  := ""
			SE1->E1_XNUMBCO := ""
			SE1->E1_CODBAR  := ""
			SE1->E1_CODDIG  := ""
			//SE1->E1_NUMBOR  := ""
			//SE1->E1_DATABOR	:= ctod('  /  /  ')
			//SE1->E1_SITUACA := '0'
			//SE1->E1_ACRESC  := 0
			//SE1->E1_XJUROS  := 0
			//SE1->E1_XMULTA  := 0
			MsUnLock()
		EndIf
	EndIf
Next
MsgRun("Cancelamento Total do CNAB Finalizado com Sucesso",,{|| Sleep(2000) })
Return


/*���������������������������������������������������������������������������
���Programa  �Marca     �Autor  �EV Solution System  � Data �  22/10/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao que Perguntas do SX1.					              ���
���������������������������������������������������������������������������*/
Static Function ValidPerg()
_sAlias := Alias()
DBSelectArea("SX1")
DBSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs:={}
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Banco              :","","","mv_chB","C",03,0,0,"G","","Mv_Par01",""    ,"","",""      ,"","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Agencia            :","","","mv_chC","C",05,0,0,"G","","Mv_Par02",""    ,"","",""      ,"","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Conta              :","","","mv_chD","C",10,0,0,"G","","Mv_Par03",""    ,"","",""      ,"","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","SubCta             :","","","mv_chE","C",03,0,0,"G","U_VALSUBCT()","Mv_Par04",""    ,"","",""      ,"","","","","","","","","","",""})

//aAdd(aRegs,{cPerg,"04","SubCta             :","","","mv_chE","C",03,0,0,"G","","Mv_Par04",""    ,"","",""      ,"","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Tipo de Impressao  :","","","mv_chF","N",01,0,0,"C","","Mv_Par05","1� Via","1� Via","1� Via","","","2� Via","2� Via","2� Via","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Emissao de         :","","","mv_chG","D",08,0,0,"G","","Mv_Par06",""    ,"","",""      ,"","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Emissao ate        :","","","mv_chH","D",08,0,0,"G","","Mv_Par07",""    ,"","",""      ,"","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","N� do Titulo       :","","","mv_chI","C",09,0,0,"G","","Mv_Par08",""    ,"","",""      ,"","","","","","","","","","",""})
For i:=1 to Len(aRegs)
	If ! DBSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to Len(aRegs[i])
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
	EndIf
Next
DBSkip()
DBSelectArea(_sAlias)
Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TelaAOcor �Autor  �Eduardo/Valdemir    � Data �  01/08/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Interface de Ocorrencia                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � EV Solution System                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function TelaAOcor()
Local oDlgO
Local oltOcor
Local ogOcor
Local cgOcor := Space(3)
Local oltDescr
Local cDescr := space(30)
Local aArea := GetArea()
Local nDif  := 50
Local nDif2 := 28

	U_VLPastas()

	DEFINE MSDIALOG oDlgO TITLE "Informe Instru��o" FROM 000, 000  TO 260-(nDif+nDif2), 350 COLORS 0, 16777215 PIXEL  // Valdemir

	@ 012, 018 GROUP ogGraud TO 103-nDif, 156 OF oDlgO COLOR 0, 16777215 PIXEL

	@ 075-nDif, 028 SAY oltOcor    PROMPT "Ocorrencia" 	SIZE 035, 007 OF oDlgO COLORS 0, 16777215 PIXEL

	@ 074-nDif, 068 MSGET  oltOcor  VAR cgOcor  Picture "@!" F3 "X5OCOR"	VALID VLIDOCOR(cgOcor, @cDescr) SIZE 060, 010 OF oDlgO COLORS 0, 16777215 PIXEL
	@ 090-nDif, 028 SAY oltDescr    PROMPT cDescr 	SIZE 100, 007 OF oDlgO COLORS 0, 16777215 PIXEL

	@ 109-nDif, 046 BUTTON oButton1 PROMPT "Ok" 		SIZE 037, 012 ACTION { GrvOcor(cgOcor, cDescr), oDlgO:end() } OF oDlgO PIXEL
	@ 109-nDif, 094 BUTTON oButton2 PROMPT "Sair" 	SIZE 037, 012 ACTION oDlgO:end() OF oDlgO PIXEL

	ACTIVATE MSDIALOG oDlgO CENTERED

	RestArea( aArea )

Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VLIDOCOR  �Autor  �Eduardo/Valdemir    � Data �  18/08/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida Ocorrencia                                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � EV Solution System                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function VLIDOCOR(pcgOcor, pcDescr)
Local lRET := .T.
Local cReg := Posicione('SX5',1,xFilial('SX5')+'10'+pcgOcor,"X5_DESCRI")

lRET := (!Empty(cREG))

if !lRET
	ApMsgInfo('Registro n�o encontrado, por favor verifique.')
Endif

pcDescr := cREG

Return lRET


/*

*/
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GrvOcor   �Autor  �Eduardo/Valdemir    � Data �  18/08/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Grava Ocorrencia                                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � EV Solution System                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GrvOcor(pcgOcor, cDescr)
	Local aArea := GetArea()
	//��������������������������������������Ŀ
	//� Variaveis utilizadas para parametros �
	//� mv_par01		 // Do Bordero 		  �
	//� mv_par02		 // Ate o Bordero 	  �
	//� mv_par03		 // Arq.Config 		  �
	//� mv_par04		 // Arq. Saida    	  �
	//� mv_par05		 // Banco  			  �
	//� mv_par06		 // Agenciao   		  �
	//� mv_par07		 // Conta   		  �
	//� mv_par08		 // Sub-Conta  		  �
	//� mv_par09		 // Cnab 1 / Cnab 2   �
	//� mv_par10		 // Considera Filiais �
	//� mv_par11		 // De Filial   	  �
	//� mv_par12		 // Ate Filial        �
	//� mv_par13		 // De data ocorrencia�
	//� mv_par14		 // Ate Data ocorrencia�
	//� mv_par15		 // Mostra ja gerados? �
	//����������������������������������������

	PRIVATE cBanco,cAgencia,xConteudo
	PRIVATE cPerg      := "AFI151"
	PRIVATE nHdlBco    := 0
	PRIVATE nHdlSaida  := 0
	PRIVATE nSeq       := 0
	PRIVATE nSomaValor := 0
	PRIVATE xBuffer,nLidos := 0
	PRIVATE nTotCnab2 := 0 // Contador de Lay-out nao deletar
	PRIVATE nLinha := 0 // Contador de Linhas nao deletar

	U_VLPastas()

	u_BOLETOS(aVetor)

	AcessaPerg("AFI151",.F.)

	MV_PAR01 := SE1->E1_NUMBOR
	MV_PAR02 := SE1->E1_NUMBOR
	MV_PAR03 := alltrim(_cBanco)+'.rem'   // 341
	MV_PAR04 := 'C:\EVAUTO\AReceber\Cnabs\341cob'+DTOS(DDATABASE)
	MV_PAR05 := _cBanco
	MV_PAR06 := _cAgencia
	MV_PAR07 := _cConta
	MV_PAR08 := _cSubCTA
	MV_PAR09 := 1
	MV_PAR10 := 2
	MV_PAR11 := ''
	MV_PAR12 := 'ZZ'
	MV_PAR13 := dDatabase
	MV_PAR14 := dDatabase
	MV_PAR15 := 2
	MV_PAR16 := 2


	//��������������������������������������������������������������Ŀ
	//� Recupera a Integridade dos dados                             �
	//����������������������������������������������������������������
	dbSelectArea("FI2")
	IncluiFI2(pcgOcor, cDescr)
	RegToMemory('FI2',.F.,.T.)
	FA151AxInc('FI2')
	fa151Gera('FI2')

	RestArea( aArea )
	if File(MV_PAR04)
	   _nArqAbr++
		MsgRun('Arquivo CNAB Gerado Sucesso!!!',,{|| Sleep(2000) })
	Endif

Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AbrirTela �Autor  �Eduardo/Valdemir    � Data �  18/08/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Abrir tela ap�s gerar boleto / arquivo                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � EV Solution System                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function AbrirTela()

IF (_nArqAbr > 0)
	MsgRun("Boletos Salvo na pasta que est� sendo aberto",,{|| Sleep(2000) })
	WinExec( "Explorer.exe C:\EVAUTO\AReceber"  )
	_nArqAbr := 0
Endif

Return




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IncluiFI2 �Autor  �Eduardo/Valdemir    � Data �  18/08/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Inclui registro na tabela FI2                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � EV Solution System                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function IncluiFI2(pcgOcor, cDescr)

	Reclock('FI2', .T.)
	Replace FI2_FILIAL  WITH XFILIAL('FI2')
	Replace FI2_OCORR   WITH pcgOcor
	Replace FI2_DESCOC  WITH cDescr
	Replace FI2_NUMBOR 	WITH SE1->E1_NUMBOR
	Replace FI2_PREFIX	WITH SE1->E1_PREFIXO
	Replace FI2_TITULO	WITH SE1->E1_NUM
	Replace FI2_PARCEL	WITH SE1->E1_PARCELA
	Replace FI2_TIPO  	WITH SE1->E1_TIPO
	Replace FI2_CODCLI	WITH SE1->E1_CLIENTE
	Replace FI2_LOJCLI	WITH SE1->E1_LOJA
	Replace FI2_DTOCOR	WITH dDataBase
	Replace FI2_DTGER   WITH dDataBase
	Replace FI2_VALANT  WITH dtoc(SE1->E1_VENCTO)
	Replace FI2_VALNOV  WITH dtoc(SE1->E1_VENCREA)
	Replace FI2_CAMPO   WITH 'E1_VENCREA'
	Replace FI2_TIPCPO  WITH 'D'

	Replace FI2_CARTEI	WITH "1"
	Replace FI2_GERADO  WITH "2"
	MsUnlock()

Return




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AtuaTela  �Autor  �Eduardo/Valdemir    � Data �  18/08/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza Tela                                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � EV Solution System                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AtuaTela(pAlias,pnItens, pnValores)

// Limpa array de apresenta��o
aVetor := {}
lMark  := .F.

DbSelectArea(pAlias)
DbGoTop()
While !Eof()
	aAdd(aVetor, { lMark, (pAlias)->E1_PREFIXO, (pAlias)->E1_NUM, (pAlias)->E1_PARCELA, (pAlias)->E1_CLIENTE, (pAlias)->E1_LOJA, (pAlias)->E1_NOMCLI, (pAlias)->E1_EMISSAO, AllTrim(Transform((pAlias)->E1_VALOR,"@E 999,999,999.99")), (pAlias)->E1_VENCTO, (pAlias)->E1_VENCREA, (pAlias)->E1_TIPO, (pAlias)->E1_PORTADO, (pAlias)->E1_AGEDEP, (pAlias)->E1_CONTA, (pAlias)->E1_NUMBOR, (pAlias)->E1_NUMBCO, (pAlias)->E1_XNUMBCO, (pAlias)->E1_FILIAL,.f. })
	DbSelectArea(pAlias)
	DbSkip()
End

pnValores := 0
pnItens   := 0
oLbx:SetArray(aVetor)
oLbx:bLine := {|| { Iif(aVetor[oLbx:nAt,1],oOk,oNo), aVetor[oLbx:nAt,2], aVetor[oLbx:nAt,3], aVetor[oLbx:nAt,4], aVetor[oLbx:nAt,5], aVetor[oLbx:nAt,6], aVetor[oLbx:nAt,7], aVetor[oLbx:nAt,8], aVetor[oLbx:nAt,9], aVetor[oLbx:nAt,10], aVetor[oLbx:nAt,11], aVetor[oLbx:nAt,12], aVetor[oLbx:nAt,13], aVetor[oLbx:nAt,14], aVetor[oLbx:nAt,15], aVetor[oLbx:nAt,16], aVetor[oLbx:nAt,17], aVetor[oLbx:nAt,18], aVetor[oLbx:nAt,19], aVetor[oLbx:nAt,20] }}
oLbx:Refresh()

Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValidSel  �Autor  �Eduardo/Valdemir    � Data �  08/18/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida Sele��o                                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � EV Solution System                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ValidSel()
Local nConta := 0
Local lRET   := .T.

if !u_VldCNPJ()
	Return
endif

aEval(aVetor, { |X| if( X[1], nConta++,0)} )

if nConta=0
   MsgRun("N�o foi selecionado nenhum registro...",,{|| Sleep(2000) })
   lRET   := .F.
   Return
Endif

Return lRET




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VALIDCNPJ �Autor  �Eduardo/Valdemir    � Data �  17/08/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida CNPJ da Empresa                                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � EV Solution System                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER Function ValidCNPJ()
Local lRET  := .T.
Local _cCGC := GetSenha('totvs'+cFilAnt+'.xml')
Local aArea := GetArea()
Local lArq  := File(GetSrvProfString( 'STARTPATH', '' )+'evvalid.ev')
Local nResp := if(!lArq,u_NNENV(),.F.)

	dbSelectArea( 'SM0' )   		// minha base 08255976000117
	SM0->( dbSetOrder( 1 ) )
	if SM0->( dbSeek( cEmpAnt+cFilAnt, .T. ) )
	   lRET := (ALLTRIM(SM0->M0_CGC)==LEFT(_cCGC, LEN(ALLTRIM(SM0->M0_CGC))))
	   if !lRET
		   MsgRun("Pacth aplicada n�o dispon�vel para este CNPJ. Entre em contato com EV Solu��es Inteligentes...",,{|| Sleep(2000) })
		   lRET := .F.
	   endif
	endif

	RestArea( aArea )

Return lRET



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Descript  �Autor  �Valdemir / Eduardo  � Data �  17/08/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � DesCriptografa  Senha                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � EV Solution System                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function DesCriptografa(sCodigo, iTamCodigo)
Local sCriptografa := ""
Local sPos  := ""
Local iCont := ""
Local iChv  := 369
Local cRET  := ""

 For iCont := 1 To iTamCodigo
   sPos    := Substr(sCodigo,iCont,1)
   If sPos <> ''
      sCriptografa := sCriptografa + Chr( U_TransfASC2( sPos )-iCont )
   endif
 Next

 cRET := Left(sCriptografa,14)

Return cRET



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TELABOL   �Autor  �Eduardo / Valdemir  � Data �  08/24/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Chamada de senha                                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � EV Solution System                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GetSenha(pArquivo)
	Local cLinha := LerArq(pArquivo)
	Local cRET   := ""

	cRET   := DesCriptografa(cLinha, 30)

Return cRET




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TELABOL   �Autor  �Eduardo / Valdemir  � Data �  24/08/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ler Arquivos                                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � EV Solution System                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function LerArq(cArquivo)
	Local cLinha 	   		:= ""
	Local nHdl 	:= nTotReg	:= 0

	if !File(cArquivo)
		Alert('Arquivo n�o encontrado')
	Endif

	nHdl := FT_FUSE(cArquivo)
	nTotReg := FT_FLASTREC()
	ProcRegua(nTotReg)
	FT_FGOTOP()
	ProcRegua(nTotReg)
	While (!FT_FEOF())	.and. (nTotReg > 0)
		cLinha := FT_FREADLN()
		cLinha := Alltrim(cLinha)
		IncProc()
		FT_FSKIP()
	End

	FT_FUSE()

Return cLinha



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VLPastas  �Autor  �Eduardo / Valdemir  � Data �  24/08/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida a cria��o de pastas para arquivos gerado pela       ���
���          � automa��o                                                  ���
�������������������������������������������������������������������������͹��
���Uso       � EV Solution System                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function VLPastas()
Local cDestino := ''

	If !ExistDir("C:\EVAUTO")
	    FWMakeDir( "C:\EVAUTO\", .T. )
		//MontaDir("C:\EVAUTO\")
		//MontaDir("C:\EVAUTO\Boletos\")
	EndIf
	If !ExistDir("C:\EVAUTO\AReceber")
	    FWMakeDir( "C:\EVAUTO\AReceber\", .T. )
	EndIf
	if !ExistDir("C:\EVAUTO\AReceber\Relatorios")
		FWMakeDir( "C:\EVAUTO\AReceber\Relatorios\", .T. )
	endif
	If !ExistDir("C:\EVAUTO\AReceber\Boletos")
		FWMakeDir( "C:\EVAUTO\AReceber\Boletos\", .T. )
	endif
	if !ExistDir("C:\EVAUTO\AReceber\Cnabs")
		FWMakeDir( "C:\EVAUTO\AReceber\Cnabs\", .T. )
	endif
	if !ExistDir("C:\EVAUTO\AReceber\Retorno Cnab")
		FWMakeDir( "C:\EVAUTO\AReceber\Retorno Cnab\", .T. )
	endif
	If !ExistDir("C:\EVAUTO\APagar")
	    FWMakeDir( "C:\EVAUTO\APagar\", .T. )
	EndIf
	if !ExistDir("C:\EVAUTO\APagar\Retorno Cnab")
		FWMakeDir("C:\EVAUTO\APagar\Retorno Cnab\", .T. )
	endif
	if !ExistDir("C:\EVAUTO\LOG")
		FWMakeDir("C:\EVAUTO\LOG\", .T. )
	Endif
    cDestino := GetSrvProfString( 'STARTPATH', '' )+"EMail"
    If !ExistDir(cDestino)
		FWMakeDir(cDestino, .T. )
	endif

Return


/*���������������������������������������������������������������������������
���Programa  �VALSUBCT   �Autor  �Valdemir Jos�      � Data �  28/08/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa de validador da Subconta.       				  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � EV Solution System                                         ���
���������������������������������������������������������������������������*/

User Function VALSUBCT()

Local lRet := .T.
DbSelectArea("SEE")
SEE->(DbSetOrder(1)) // EE_FILIAL + EE_CODIGO + EE_AGENCIA + EE_CONTA + EE_SUBCTA
lRet := SEE->(DbSeek(xFilial("SEE") + Mv_Par01 + Mv_Par02 + Mv_Par03 + Mv_Par04 ))

If !lRet
 MsgAlert("Subconta n�o relacionada com o Banco informado no Par�metro, favor informar a Subconta correta!!!")
 lRet := .F.
EndIf

Return lRet





/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TransfASC2�Autor  �Eduardo / Valdemir  � Data �  18/08/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � Transforme Caracter em ASC                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � EV Solution System								    	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TransfASC2(sCaracter)
 Local nRET := 0

 If     sCaracter = '0' ; nRET := 48
 ElseIf sCaracter = '1' ; nRET := 49
 ElseIf sCaracter = '2' ; nRET := 50
 ElseIf sCaracter = '3' ; nRET := 51
 ElseIf sCaracter = '4' ; nRET := 52
 ElseIf sCaracter = '5' ; nRET := 53
 ElseIf sCaracter = '6' ; nRET := 54
 ElseIf sCaracter = '7' ; nRET := 55
 ElseIf sCaracter = '8' ; nRET := 56
 ElseIf sCaracter = '9' ; nRET := 57
 ElseIf sCaracter = ':' ; nRET := 58
 ElseIf sCaracter = ';' ; nRET := 59
 ElseIf sCaracter = '<' ; nRET := 60
 ElseIf sCaracter = '=' ; nRET := 61
 ElseIf sCaracter = '>' ; nRET := 62
 ElseIf sCaracter = '?' ; nRET := 63
 ElseIf sCaracter = '@' ; nRET := 64
 ElseIf sCaracter = 'A' ; nRET := 65
 ElseIf sCaracter = 'B' ; nRET := 66
 ElseIf sCaracter = 'C' ; nRET := 67
 ElseIf sCaracter = 'D' ; nRET := 68
 ElseIf sCaracter = 'E' ; nRET := 69
 ElseIf sCaracter = 'F' ; nRET := 70
 ElseIf sCaracter = 'G' ; nRET := 71
 ElseIf sCaracter = 'H' ; nRET := 72
 ElseIf sCaracter = 'I' ; nRET := 73
 ElseIf sCaracter = 'J' ; nRET := 74
 ElseIf sCaracter = 'K' ; nRET := 75
 ElseIf sCaracter = 'L' ; nRET := 76
 ElseIf sCaracter = 'M' ; nRET := 77
 ElseIf sCaracter = 'N' ; nRET := 78
 ElseIf sCaracter = 'O' ; nRET := 79
 ElseIf sCaracter = 'P' ; nRET := 80
 ElseIf sCaracter = 'Q' ; nRET := 81
 ElseIf sCaracter = 'R' ; nRET := 82
 ElseIf sCaracter = 'S' ; nRET := 83
 ElseIf sCaracter = 'T' ; nRET := 84
 ElseIf sCaracter = 'U' ; nRET := 85
 ElseIf sCaracter = 'V' ; nRET := 86
 ElseIf sCaracter = 'W' ; nRET := 87
 ElseIf sCaracter = 'X' ; nRET := 88
 ElseIf sCaracter = 'Y' ; nRET := 89
 ElseIf sCaracter = 'Z' ; nRET := 90
 ElseIf sCaracter = '[' ; nRET := 91
 ElseIf sCaracter = '\' ; nRET := 92
 ElseIf sCaracter = ']' ; nRET := 93
 ElseIf sCaracter = '^' ; nRET := 94
 ElseIf sCaracter = '_' ; nRET := 95
 ElseIf sCaracter = '`' ; nRET := 96
 ElseIf sCaracter = 'a' ; nRET := 97
 ElseIf sCaracter = 'b' ; nRET := 98
 ElseIf sCaracter = 'c' ; nRET := 99
 ElseIf sCaracter = 'd' ; nRET := 100
 ElseIf sCaracter = 'e' ; nRET := 101
 ElseIf sCaracter = 'f' ; nRET := 102
 ElseIf sCaracter = 'g' ; nRET := 103
 ElseIf sCaracter = 'h' ; nRET := 104
 ElseIf sCaracter = 'i' ; nRET := 105
 ElseIf sCaracter = 'j' ; nRET := 106
 ElseIf sCaracter = 'k' ; nRET := 107
 ElseIf sCaracter = 'l' ; nRET := 108
 ElseIf sCaracter = 'm' ; nRET := 109
 ElseIf sCaracter = 'n' ; nRET := 110
 ElseIf sCaracter = 'o' ; nRET := 111
 ElseIf sCaracter = 'p' ; nRET := 112
 ElseIf sCaracter = 'q' ; nRET := 113
 ElseIf sCaracter = 'r' ; nRET := 114
 ElseIf sCaracter = 's' ; nRET := 115
 ElseIf sCaracter = 't' ; nRET := 116
 ElseIf sCaracter = 'u' ; nRET := 117
 ElseIf sCaracter = 'v' ; nRET := 118
 ElseIf sCaracter = 'w' ; nRET := 119
 ElseIf sCaracter = 'x' ; nRET := 120
 ElseIf sCaracter = 'y' ; nRET := 121
 ElseIf sCaracter = 'z' ; nRET := 122
 ElseIf sCaracter = '{' ; nRET := 123
 ElseIf sCaracter = '|' ; nRET := 124
 ElseIf sCaracter = '}' ; nRET := 125
 ElseIf sCaracter = '~' ; nRET := 126
 ElseIf sCaracter = '�' ; nRET := 127
 ElseIf sCaracter = '�' ; nRET := 128
 ElseIf sCaracter = '�' ; nRET := 129
 ElseIf sCaracter = '�' ; nRET := 130
 ElseIf sCaracter = '�' ; nRET := 131
 ElseIf sCaracter = '�' ; nRET := 132
 ElseIf sCaracter = '�' ; nRET := 133
 ElseIf sCaracter = '�' ; nRET := 134
 ElseIf sCaracter = '�' ; nRET := 135
 ElseIf sCaracter = '�' ; nRET := 136
 ElseIf sCaracter = '�' ; nRET := 137
 ElseIf sCaracter = '�' ; nRET := 138
 ElseIf sCaracter = '�' ; nRET := 139
 ElseIf sCaracter = '�' ; nRET := 140
 Else                   ; nRET := 141
 endif

Return nRET



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TELABOL   �Autor  �Valdemir / Eduardo  � Data �  22/09/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Apoio a tecla de atalho F12                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � EV Solution System								          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GetNewTela()

	if oDlg <> nil
		oDlg:End()
	endif
	u_TelaBol()

Return



Static Function SobPerg()

	ValidPerg()
	Pergunte(cPerg,.F.)	// SELECIONE O BANCO

Return


Static Function Sob060()
	Pergunte("AFIC60" ,.F.)
	mv_par10 := 0
Return


Static Function VldBor(pcNumBor)
	Local lRET := .T.

	lRET := Empty(pcNumBor)

	if !lRET
	   apMsgInfo('Sele��o n�o permitida. T�tulo j� em border�')
	endif

Return lRET


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SelAll    �Autor  �Valdemir Jos�       � Data �  21/12/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Seleciona Todos os Registros que est�o sem bordero         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function SelAll(lSel)
	Local nX := 0

	For nX := 1 to Len(aVetor)
	  if Empty(aVetor[nX][16])
		aVetor[nX][1] := lSel
	  endif
	Next

Return

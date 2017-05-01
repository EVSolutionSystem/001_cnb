#INCLUDE "PROTHEUS.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#INCLUDE "FILEIO.CH"

Static __nExeProc := 0
Static lFWCodFil  := FindFunction("FWCodFil")

#DEFINE cENTER CHR(13)+CHR(10)
#DEFINE DS_MODALFRAME   128

/*�������������������������������������������������������������������������������������������
����� Programa      � GerArqRet		� Data  	� 13/08/2015							����� 
���������������������������������������������������������������������������������������������
����� Descricao     � Funcao CNAB ITAU 400 posicoes a receber							����� 
���������������������������������������������������������������������������������������������
����� Desenvolvedor � Eduardo Augusto / Valdemir Rabelo	� Empresa � EV Solu��es         ����� 
���������������������������������������������������������������������������������������������
����� Linguagem     � Advpl		� Versao 	� 11	� Sistema � Microsiga				����� 
���������������������������������������������������������������������������������������������
����� Modulo(s)     � SIGAFIN															����� 
���������������������������������������������������������������������������������������������
����� Observacao    �  Possui funcao Carregar Arquivo de Retorno						����� 
���������������������������������������������������������������������������������������������
����� Desenvolvedor		� Data             	  � Alteracao								����� 
���������������������������������������������������������������������������������������������
�����			�        					   �										����� 
�������������������������������������������������������������������������������������������*/  
User Function GetArqRet()                        
	Local cTitulo    	:= "Carrega Arquivo Retorno"
	Local nPosBCO    	:= 77
	Local nPosCC     	:= 27
	Local nPosCDC    	:= 33
	Local aLocalDir     := {}
	
	Private aPosGet  	:= {}                
	Private cPerg    	:= "AFI200"	
	Private cArqDir  	:= ""
	Private ALTERA   	:= .T.
	Private __nExeProc  := 0
	PRIVATE cLotefin 	:= Space(TamSX3("EE_LOTE")[1]),nTotAbat := 0,cConta := " "
	PRIVATE nHdlBco		:= 0,nHdlConf := 0,nSeq := 0 ,cMotBx := "NOR"
	PRIVATE nValEstrang := 0
	PRIVATE cMarca 		:= GetMark()
	PRIVATE aRotina 	:= MenuDef()
	PRIVATE VALOR  		:= 0
	PRIVATE nHdlPrv 	:= 0
	PRIVATE nOtrGa		:= 0
	PRIVATE nTotAGer	:= 0
	PRIVATE ABATIMENTO 	:= 0
	Private lOracle		:= "ORACLE"$Upper(TCGetDB())
	Private CCADASTRO   := 'Concilia��o Banc�rio' 
	Private CBCO380     := '' 
	Private cAge380     := ''
	Private cCta380     := ''
	Private dFimDt380   := dDataBase
	PRIVATE dIniDt380	:= dDataBase
	Private lPanelFin   := .T.
	Private LMVCNABIMP
	Private pTipoR       := "R"

	Static oDlg   
	
	// Valida��o de Restri��o de Datas
	if !u_VldDtLim()
	    Return
	endif	

/*
 ___________________________________
| Perguntas:						|
| __________________________________|
|									|
| 01	Mostra Lanc Contab ?		|
| 02	Aglut Lancamentos ?			|
| 03	Atualiza Moedas por ?		|
| 04	Arquivo de Entrada ?		|
| 05	Arquivo de Config ?			|
| 06	Codigo do Banco ?			|
| 07	Codigo da Agencia ?			|
| 08	Codigo da Conta ?			|
| 09	Codigo da Sub-Conta ?		|
| 10	Abate Desc Comissao ?		|
| 11	Contabiliza On Line ?		|
| 12	Configuracao CNAB ?			|
| 13	Processa Filial?			|
| 14	Contabiliza Transferencia ?	|
| 15	Considera Dias de Retencao ?|
|___________________________________|
*/                                         

// Configuracao padr�o
MV_PAR01 := 2  // n�O
MV_PAR02 := 1  // sIM
MV_PAR03 := 1  // 1 - Vencimento
MV_PAR10 := 2
MV_PAR11 := 2
MV_PAR13 := 1
MV_PAR14 := 1
MV_PAR15 := 2
MV_PAR16 := 2
    
aPar := {}
// Varre diretorio local - Valdemir Jos�
aLocalD0 := DIRECTORY("C:\EVAUTO\AReceber\Retorno Cnab\*.txt")
aLocalD1 := DIRECTORY("C:\EVAUTO\AReceber\Retorno Cnab\*.ret")         
cCaminho := "C:\EVAUTO\AReceber\Retorno Cnab\"
aEVal(aLocalD0, { |X| aAdd(aLocalDir, X) } )
aEVal(aLocalD1, { |X| aAdd(aLocalDir, X) } )

nFiles := len(aLocalDir) 

if nFiles = 0
   apMsgInfo('N�o foi localizado nenhum arquivo de retorno'+cENTER+'Verifique se o arquivo encontra-se na pasta C:\evauto\areceber\retorno cnab','Aten��o!!!')
   Return
endif

FOR nX := 1 To nFiles

	cArqDir := lower(aLocalDir[nX][1])      // Carrega, adicionando o nome do arquivo - Valdemir 28/05/09
                
	aDados := LerArq(cCaminho+cArqDir)  	 // Leitura de parametro do banco
	
    // Arquivo Retorno           
	MV_PAR04 := cCaminho+cArqDir
	
	// Seleciona arquivo configuracao
	IF aDados[1] == '341'
		MV_PAR05 := aDados[1]+'R.RET'
	elseif aDados[1] $ '001/033/422/745'
		MV_PAR05 := aDados[1]+'R.2RR'
	elseif aDados[1] == '237'
		MV_PAR05 := aDados[1]+'.rem'
	Endif                            
	
	// 
	MV_PAR06 := aDados[1]
	MV_PAR07 := u_RemoveC(aDados[2],'',MV_PAR06)
	MV_PAR08 := u_RemoveC(aDados[3],MV_PAR07,MV_PAR06)
	MV_PAR09 := 'RSB'
	MV_PAR12 := if(aDados[4]=400, 1,2) 				// - tratamento layout de arquivo

	// variavel para Conciliacao
	CBCO380   := MV_PAR06  
	cAge380   := MV_PAR07
	cCta380   := MV_PAR08
	aPar 	  := {CBCO380, cAge380, cCta380}
	
	//fa200Gera('SE1')
	f200Ger('SE1')           	

    FT_FUSE()    // forca fechamento do arquivo, caso esteja aberto

	dbSelectArea("SE5")
	dbSetOrder(1)
	lImp      := .F.            
	lPanelFin := .F.
	
	// Conciliacao Bancaria
	lImp := .T.		//u_EV380Rec()   - Removido Concilia��o 22/07/2016
	//             
	// Renomeia arquivo
    if file(cCaminho+cArqDir)
       FT_FUSE()    // forca fechamento do arquivo, caso esteja aberto
       FClose()
   	   cFileName := cCaminho+cArqDir
       cDestino  :=  cCaminho+Substr(cArqDir,1,at('.',cArqDir)-1)+'.proc'

	  // Renomeando um arquivo no Client  
	  if lImp
		nStatus1 := frename(cFileName , cDestino)
		IF nStatus1 == -1
		   MsgStop('Falha ao renomear o arquivo : FError '+str(ferror(),4))
		Endif  
	  endif			

    endif
	
	        
Next

// Relatorio de extrato do banco
if Len(aPar) > 0
	U_EVFNR470(aPar)
Endif

                       
//MsgInfo('Processamento de retorno autom�tico finalizado com sucesso ')

Return









//-------------------------------------------------- concilia��o --------------------------------------------------------



Static Function LerArq(pArquivo)
	Local aRET := {}
	Local nTamFile, nTamLin, cBuffer, nBtLidos

	FT_FUse(pArquivo)
	FT_FGOTOP()
	cBuffer := FT_FREADLN() 
	
	nPosLayOut := Len(cBuffer)
	
               // Banco                    Agencia               Conta   
   //aRET := {SubStr(cBuffer, 77,3), SubStr(cBuffer, 27,4), SubStr(cBuffer, 33,5), Len(cBuffer) }  //antigo
            
	if nPosLayOut = 240
    		           // Banco                    Agencia               Conta   
    	aRET := {SubStr(cBuffer, 1,3), SubStr(cBuffer, 53,5), SubStr(cBuffer, 59,12), Len(cBuffer)  }
	else
    		           // Banco                    Agencia               Conta   
    	aRET := {SubStr(cBuffer,77,3), SubStr(cBuffer, 27,4), SubStr(cBuffer, 33,5), Len(cBuffer)  }
	Endif  

	//Fechamento do Arquivo Texto
	FT_FUSE()

Return aRET





/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � fA200Gera� Autor � Valdemir / Eduardo    � Data � 16/09/15 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Comunicacao Bancaria - Retorno                             ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � fA200Ger()                                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � FinA200                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function f200Ger(cAlias)
Local lPosNum  :=.f.,lPosData:=.f.,lPosMot  :=.f.
Local lPosDesp :=.f.,lPosDesc:=.f.,lPosAbat :=.f.
Local lPosPrin :=.f.,lPosJuro:=.f.,lPosMult :=.f.
Local lPosOcor :=.f.,lPosTipo:=.f.,lPosOutrD:= .F.
Local lPosCC   :=.f.,lPosDtCC:=.f.,lPosNsNum:=.f.
Local cArqConf,cArqEnt,xBuffer
Local lDesconto,lContabiliza
Local cData
Local cPosNsNum , nLenNsNum
Local lUmHelp 	:= .F.
Local cTabela 	:= "17"
Local lPadrao 	:= .f.
Local lBaixou 	:= .f.
Local nSavRecno	:= Recno()
Local nPos
Local aTabela 	:= {}
Local lRecicl	:= GetMv("MV_RECICL")
Local lNaoExiste:= .F.
Local cIndex	:= " "
LOCAL lFina200 	:= ExistBlock("FINA200" )
LOCAL l200Pos  	:= ExistBlock("FA200POS" )
LOCAL lT200Pos 	:= ExistTemplate("FA200POS" )
LOCAL lFa200Fil	:= ExistBlock("FA200FIL")
LOCAL lFa200F1 	:= ExistBlock("FA200F1" )
LOCAL lF200Tit 	:= ExistBlock("F200TIT" )
LOCAL lF200Fim 	:= ExistBlock("F200FIM" )
LOCAL lTF200Fim := ExistTemplate("F200FIM" )
LOCAL lF200Var 	:= ExistBlock("F200VAR" )
LOCAL lF200Avl 	:= ExistBlock("F200AVL" )
LOCAL l200Fil  	:= .F.
LOCAL lFirst	:= .F.
Local cMotBan	:= Space(10)				// motivo da ocorrencia no banco
Local nCont, cMotivo, lSai := .f.
Local aLeitura 	:= {}
Local lFa200_02 := ExistBlock("FA200_02")
Local aValores 	:= {}
LOCAL lBxCnab  	:= GetMv("MV_BXCNAB") == "S"
LOCAL cNomeArq
LOCAL aCampos  	:= {}
Local lAchouTit	:= .F.
Local nX 		:= 0
Local nRegSE5 	:= 0
Local lPosDtVc 	:= .F.
Local nLenDtVc
Local cPosDtVc
Local lF200ABAT := ExistBlock("F200ABAT")
Local lFI0InDic := AliasInDic("FI0")
Local nLastLn	:= 0
Local nUltLinProc := 1
Local lReproc 	:= .T.
Local cTrailler
Local cIdArq
Local nRegEmp	:= SM0->(Recno())
Local lF200PORT := ExistBlock("F200PORT")
Local lAltPort 	:= .T.
Local nTotAbImp := 0
Local cFilOrig  := cFilAnt	// Salva a filial para garantir que nao seja alterada em customizacao
Local lNewIndice:= FaVerInd()  //Verifica a existencia dos indices de IDCNAB sem filial
Local nTamPre	:= TamSX3("E1_PREFIXO")[1]
Local nTamNum	:= TamSX3("E1_NUM")[1]
Local nTamPar	:= TamSX3("E1_PARCELA")[1]
Local nTamTit	:= nTamPre+nTamNum+nTamPar
Local aArqConf	:= {}		// Atributos do arquivo de configuracao
// Local lCtbExcl	:= !Empty(xFilial("CT2"))
Local lProcessa := .T.   
Local nValTot	:= 0

Local lAltera   := Iif(IsBlind(), .F. , ALTERA)

//--- Tratamento Gestao Corporativa
Local lGestao   := Iif( lFWCodFil, FWSizeFilial() > 2, .F. )	// Indica se usa Gestao Corporativa
//
Local cFilFwSE1 := IIF( lGestao .And. FindFunction("FwFilial"), FwFilial("SE1") , xFilial("SE1") )
//
Local cFilFwCT2 := IIF( lGestao .And. FindFunction("FwFilial"), FwFilial("CT2") , xFilial("CT2") )
//
Local lCtbExcl	:= !Empty( cFilFwCT2 )

Local lMulNatBx := SuperGetMV("MV_MULNATB",.F.,.F.)
Local lJurComis := (mv_par16 == 1)

If ExistBlock("F200CNAB")
	lBxCnab:=ExecBlock("F200CNAB",.F.,.F.,{lBxCnab,cAlias})
EndIf

nHdlBco   	:= 0
nHdlConf   	:= 0
nSeq       	:= 0
cMotBx     	:= "NOR"
nTotAGer   	:= 0
nTotDesp   	:= 0 // Total de Despesas para uso com MV_BXCNAB
nTotOutD   	:= 0 // Total de outras despesas para uso com MV_BXCNAB
nTotValCC   := 0 // Total de outros creditos para uso com MV_BXCNAB
nValEstrang := 0
VALOR    	:= 0
nHdlPrv  	:= 0
ABATIMENTO  := 0

Private cBanco
Private cAgencia
Private cConta
Private cHist070
Private lAut:=.f.,nTotAbat := 0
Private cArquivo
Private dDataCred
Private lCabec := .f.
Private cPadrao
Private nTotal := 0
Private cModSpb := "1"  // Informado apenas para nao dar problemas nas rotinas de baixa
Private nAcresc
Private nDecresc
Private aFlagCTB		:= {}
Private lUsaFlag		:= SuperGetMV( "MV_CTBFLAG" , .T. /*lHelp*/, .F. /*cPadrao*/)
Private nLidos,nLenNum,nLenData,nLenDesp,nLenDesc,nLenAbat,nLenMot, nTamDet
Private nLenPrin,nLenJuro,nLenMult,nLenOcor,nLenTipo,nLenCC,nLenDtCC, nLenOutrD
Private cPosNum,cPosData,cPosDesp,cPosDesc,cPosAbat,cPosPrin,cPosJuro,cPosMult
Private cPosOcor,cPosTipo,cPosCC,cPosDtCC,cPosMot, cPosOutrD

//��������������������������������������������������������������Ŀ
//� Deleta Chave Unica do Arquivo Log de Detalhes do CNAB        �
//����������������������������������������������������������������
AjustaSX2()

// Se existir o arquivo de LOG, forca sua abertura antes do inicio da transacao
If lFI0InDic
	DbSelectArea("FI0")
	DbSelectArea("FI1")
Endif

//��������������������������������������������������������������Ŀ
//� Posiciona no Banco indicado                                  �
//����������������������������������������������������������������
cBanco  := mv_par06
cAgencia:= mv_par07
cConta  := mv_par08
cSubCta := mv_par09
lDigita := IIF(mv_par01==1,.T.,.F.)
lAglut  := IIF(mv_par02==1,.T.,.F.)

//���������������������������������������������������������Ŀ
//� Verifica se existe inidce IDCNAB para multiplas filiais �
//�����������������������������������������������������������
If mv_par13 == 2

	If !lNewIndice

		// N�o foi encontrado o �ndice por IDCNAB sem Filial. ### Executar o compatibizador do ambiente Financeiro (U_UPDFIN).
		PutHelp( "PNOIDCNAB",	{"N�o foi encontrado o �ndice por IDCNAB", "sem Filial."},;
								{"The index IDCNAB without Branch not found." },;
								{"No encontro el indice por IDCNAB sin", "Sucursal."} )

		PutHelp( "SNOIDCNAB",	{"Executar o compatibizador do ambiente", "Financeiro (U_UPDFIN)."},;
								{"Run the compatibility Financial ", "(U_UPDFIN)." },;
								{"Ejecutar el compatibilizador del entorno", "Financeiro (U_UPDFIN)."} )

		Help( "  ", 1, "NOIDCNAB" )


		// Retorno Automatico via Job
		if ExecSchedule()
			Aadd(aMsgSch, "N�o foi encontrado o �ndice por IDCNAB sem Filial. Executar o compatibizador do ambiente Financeiro (U_UPDFIN).") // 
		Endif

		Return .F.

	Else

		If lCtbExcl
		    _cMsg := ""
			// A Contabilidade est� em modo exclusivo e foi solicitado o processamento de todas as filiais.
			// Neste caso, o sistema n�o realiza a contabiliza��o on-line. Confirma mesmo assim?
			_cMsg += "A Contabilidade est� em modo exclusivo e foi solicitado o processamento de todas as filiais." + Chr(13) + Chr(10)
			_cMsg += "Neste caso, o sistema n�o realiza a contabiliza��o on-line. Confirma mesmo assim?"
			if ! ExecSchedule() // Retorno Automatico via Job - parametro que controla execucao via Job
				If ! MsgYesNo( _cMsg, "Retorno Automatico via Job" )
					Return .F.
				Endif
			EndIf
		EndIf
	EndIf

EndIf

dbSelectArea("SA6")
DbSetOrder(1)
SA6->( dbSeek(xFilial("SA6")+cBanco+cAgencia+cConta) )

dbSelectArea("SEE")
DbSetOrder(1)
SEE->( dbSeek(xFilial("SEE")+cBanco+cAgencia+cConta+cSubCta) )
If !SEE->( found() )
	Help(" ",1,"PAR150")

	// Retorno Automatico via Job
	if ExecSchedule()
		Aadd(aMsgSch, "Parametros de Bancos nao encontrados para o Banco:"+cBanco+"  "+"Agencia:"+cAgencia+"  "+"Conta:"+cConta+"  "+"Sub-Conta:"+cSubCta) //  #  #  # 
   Endif

	Return .F.
Endif

If lBxCnab // Baixar arquivo recebidos pelo CNAB aglutinando os valores
	If Empty(SEE->EE_LOTE)
		cLoteFin := StrZero( 1, TamSX3("EE_LOTE")[1] )
	Else
		cLoteFin := If (FindFunction("FinSomaLote"),FinSomaLote(SEE->EE_LOTE),Soma1(SEE->EE_LOTE))
	EndIf
EndIf
nTamDet := Iif( Empty (SEE->EE_NRBYTES), 400 , SEE->EE_NRBYTES )
nTamDet	+= 2  // ajusta tamanho do detalhe para ler o CR+LF
cTabela := Iif( Empty(SEE->EE_TABELA), "17" , SEE->EE_TABELA )

//���������������������������������������Ŀ
//� Verifica se a tabela existe           �
//�����������������������������������������
dbSelectArea( "SX5" )
If !SX5->( dbSeek( cFilial + cTabela ) )
	Help(" ",1,"PAR150")

	// Retorno Automatico via Job
	if ExecSchedule()
		Aadd(aMsgSch, "Tabela 17 nao localizada no arquivo de tabelas SX5") // 
   Endif

   Return .F.
Endif

//Altero banco da baixa pelo portador ?
If lF200PORT
	lAltPort := ExecBlock("F200PORT",.F.,.F.)
Endif

While !SX5->(Eof()) .and. SX5->X5_TABELA == cTabela
	AADD(aTabela,{Alltrim(X5Descri()),AllTrim(SX5->X5_CHAVE)})
	SX5->(dbSkip( ))
Enddo

//��������������������������������������������������������������Ŀ
//� Verifica o numero do Lote                                    �
//����������������������������������������������������������������
PRIVATE cLote
dbSelectArea("SX5")
dbSeek(cFilial+"09FIN")
cLote := Substr(X5Descri(),1,4)

//������������������������������������������������������������������������Ŀ
//� Verifica se � um EXECBLOCK e caso sendo, executa-o							�
//��������������������������������������������������������������������������
If At(UPPER("EXEC"),X5Descri()) > 0
	cLote := &(X5Descri())
Endif

If ( MV_PAR12 == 1 )
	//������������������������������Ŀ
	//� Abre arquivo de configuracao �
	//��������������������������������
	cArqConf:=mv_par05
	IF !FILE(cArqConf)
		Help(" ",1,"NOARQPAR")

		// Retorno Automatico via Job
		if ExecSchedule()
			Conout("Arquivo de configuracao "+cArqConf+" nao localizado.") //  # 
			Aadd(aMsgSch, "Arquivo de configuracao "+cArqConf+" nao localizado.") //  # 
      Endif

		Return .F.
	Else
		nHdlConf:=FOPEN(cArqConf,0+64)
	EndIF

	//����������������������������Ŀ
	//� L� arquivo de configuracao �
	//������������������������������
	nLidos:=0
	FSEEK(nHdlConf,0,0)
	nTamArq:=FSEEK(nHdlConf,0,2)
	FSEEK(nHdlConf,0,0)

	While nLidos <= nTamArq

		//�������������������������������������������Ŀ
		//� Verifica o tipo de qual registro foi lido �
		//���������������������������������������������
		xBuffer:=Space(85)
		FREAD(nHdlConf,@xBuffer,85)
		IF SubStr(xBuffer,1,1) == CHR(1)
			nLidos+=85
			Loop
		EndIF
		IF SubStr(xBuffer,1,1) == CHR(3)
			nLidos+=85
			Exit
		EndIF

		IF !lPosNum
			cPosNum:=Substr(xBuffer,17,10)
			nLenNum:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosNum:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosData
			cPosData:=Substr(xBuffer,17,10)
			nLenData:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosData:=.t.
			nLidos+=85
			Loop
		End
		IF !lPosDesp
			cPosDesp:=Substr(xBuffer,17,10)
			nLenDesp:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosDesp:=.t.
			nLidos+=85
			Loop
		End
		IF !lPosDesc
			cPosDesc:=Substr(xBuffer,17,10)
			nLenDesc:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosDesc:=.t.
			nLidos+=85
			Loop
		End
		IF !lPosAbat
			cPosAbat:=Substr(xBuffer,17,10)
			nLenAbat:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosAbat:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosPrin
			cPosPrin:=Substr(xBuffer,17,10)
			nLenPrin:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosPrin:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosJuro
			cPosJuro:=Substr(xBuffer,17,10)
			nLenJuro:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosJuro:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosMult
			cPosMult:=Substr(xBuffer,17,10)
			nLenMult:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosMult:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosOcor
			cPosOcor:=Substr(xBuffer,17,10)
			nLenOcor:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosOcor:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosTipo
			cPosTipo:=Substr(xBuffer,17,10)
			nLenTipo:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosTipo:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosOutrD
			cPosOutrD:=Substr(xBuffer,17,10)
			nLenOutrD:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosOutrD:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosCC
			cPosCC:=Substr(xBuffer,17,10)
			nLenCC:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosCC:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosDtCc
			cPosDtCc:=Substr(xBuffer,17,10)
			nLenDtCc:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosDtCc:=.t.
			nLidos+=85
			Loop
		EndIF
		IF !lPosNsNum
			cPosNsNum := Substr(xBuffer,17,10)
			nLenNsNum := 1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosNsNum := .t.
			nLidos += 85
			Loop
		EndIF
		IF !lPosMot									// codigo do motivo da ocorrencia
			cPosMot:=Substr(xBuffer,17,10)
			nLenMot:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosMot:=.t.
			nLidos+=85
			Loop
		EndIF
		If !lPosDtVc
			cPosDtVc:=Substr(xBuffer,17,10)
			nLenDtVc:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosDtVc:=.t.
			nLidos+=85
			Loop
		Endif
	EndDo

	//�������������������������������Ŀ
	//� fecha arquivo de configuracao �
	//���������������������������������
	Fclose(nHdlConf)
EndIf
//���������������������������������Ŀ
//� Abre arquivo enviado pelo banco �
//�����������������������������������
cArqEnt:=mv_par04


IF !FILE(cArqEnt)
	Help(" ",1,"NOARQENT")

	// Retorno Automatico via Job
	if ExecSchedule()
		Aadd(aMsgSch, "Arquivo de entrada "+cArqEnt+" nao localizado.") //  # 
   Endif

	Return .F.
Else
	nHdlBco:=FOPEN(cArqEnt,0+64)
EndIF

If lRecicl
	//��������������������������������������������������������������Ŀ
	//� Filtra o arquivo por E1_NUMBCO - caso exista reciclagem      �
	//����������������������������������������������������������������
	dbSelectArea("SE1")
	cIndex	:= CriaTrab(nil,.f.)
	cChave	:= IndexKey()
	IndRegua("SE1",cIndex,"E1_FILIAL+E1_NUMBCO",,Fa200ChecF(),OemToAnsi("Selecionando Registros..."))  //
	nIndex 	:= RetIndex("SE1")
	dbSelectArea("SE1")
	#IFNDEF TOP
		dbSetIndex(cIndex+OrdBagExt())
	#ENDIF
	dbSetOrder(nIndex+1)

	dbGoTop()
	IF BOF() .and. EOF()
		Help(" ",1,"RECNO")

		// Retorno Automatico via Job
		if ExecSchedule()
			Aadd(aMsgSch, "Nao foram localizados registros na tabela SE1.")  // 
      Endif

		Return
	EndIf
EndIf

// Se nao tiver o arquivo de LOG no dicionario, verifica se o arquivo ja foi processado anteriormente
If ! lFI0InDic
	If !(Chk200File())
		Return .F.
	Endif
Endif

//����������������������������������������������������������������������Ŀ
//� Chama a SumAbatRec antes do Controle de transa��o para abrir o alias �
//� auxiliar __SE1																		 �
//������������������������������������������������������������������������
//Cria Alias __SE1 caso n�o exista
If Select("__SE1") == 0
	SumAbatRec( "", "", "", 1, "")
EndIf

//��������������������������������������������������������������Ŀ
//� Gera arquivo de Trabalho                                     �
//����������������������������������������������������������������
AADD(aCampos,{"FILMOV","C",IIf( lFWCodFil, FWGETTAMFILIAL, 2 ),0})
AADD(aCampos,{"DATAC","D",08,0})
AADD(aCampos,{"TOTAL","N",17,2})

// para evitar abortar por area ja existente
if Select("TRB") > 0
	TRB->( dbCloseArea())
Endif
cNomeArq:=CriaTrab(aCampos)
dbUseArea( .T., __cRDDNTTS, cNomeArq, "TRB", if(.F. .Or. .F., !.F., NIL), .F. )
IndRegua("TRB",cNomeArq,"FILMOV+Dtos(DATAC)",,,"")

//�������������������������������Ŀ
//� L� arquivo enviado pelo banco �
//���������������������������������
nLidos:=0
FSEEK(nHdlBco,0,0)
nTamArq:=FSEEK(nHdlBco,0,2)
FSEEK(nHdlBco,0,0)
//����������������������������������������������������Ŀ
//� Desenha o cursor e o salva para poder moviment�-lo �
//������������������������������������������������������
ProcRegua( nTamArq/nTamDet , 24 )

//��������������������������������������������������������������Ŀ
//� Carrega atributos do arquivo de configuracao                 �
//����������������������������������������������������������������
aArqConf := Directory(MV_PAR05)

lFirst := .F.
nTotAger := 0
nCtDesp := 0
nCtOutCrd := 0

// Se existir o arquivo de LOG, grava as informacoes pertinentes, referente ao cabecalho do arquivo
// Para futuro reprocessamento se preciso for.
If lFI0InDic
	cTrailler := LeTrailler(nHdlBco) // Obtem o Trailler do Arquivo para gerar o CheckSum
	cIdArq	 := Str(MsCrc32(cTrailler),10) // Fa200ChkSum(cTrailler) // Gera o CheckSum
	lReproc	 := Fa200GrvLog(1, cArqEnt, cBanco, cAgencia, cConta, @nUltLinProc,,,,cIdArq)
Endif

//�����������������������������������������������������������Ŀ
//� Inicializa a gravacao dos lancamentos do SIGAPCO          �
//�������������������������������������������������������������
PcoIniLan("000004")
PcoIniLan("000007")

Do While lReproc .And. nLidos <= nTamArq
	IncProc()
	nLastLn ++
	// Se tiver o arquivo de LOG, avanca ate a proxima linha, apos a ultima processada
	If lFI0InDic
		If nLastLn < nUltLinProc
			If lBxCnab
				xBuffer:=Space(nTamDet)
				FREAD(nHdlBco,@xBuffer,nTamDet)

				LoadVlBx( nHdlBco, xBuffer, nTamDet, @nValtot, @nTotDesp, @nTotOutD, @nTotValCc, @nTotAGer, lBxCnab)
				nLidos+=nTamDet
			Else
				// Avanca uma linha do arquivo retorno
				nLidos+=nTamDet
				fReadLn(nHdlBco,,(nTamDet)) // Posiciona proxima linha
			Endif
			Loop
		Endif
		// Grava a ultima linha lida do arquivo
		FI0->(RecLock("FI0"))
		FI0->FI0_LASTLN	:= nLastLn
		MsUnlock()
	Endif

	nDespes :=0
	nDescont:=0
	nAbatim :=0
	nValRec :=0
	nJuros  :=0
	nMulta  :=0
	nValCc  :=0
	nCM     :=0
	nOutrDesp :=0

	// Template GEM
	nCm1     := 0
	nProRata := 0

	cFilAnt := cFilOrig					// sempre restaura a filial original

	If ( MV_PAR12 == 1 )
		//�����������������������������Ŀ
		//� Tipo qual registro foi lido �
		//�������������������������������
		xBuffer:=Space(nTamDet)
		FREAD(nHdlBco,@xBuffer,nTamDet)

		IF SubStr(xBuffer,1,1) $ "0#A"
			nLidos+=nTamDet
			Loop
		EndIF
		IF SubStr(xBuffer,1,1) $ "1#F#J#7#2"
			//����������������������������������Ŀ
			//� L� os valores do arquivo Retorno �
			//������������������������������������
			cNumTit :=Substr(xBuffer,Int(Val(Substr(cPosNum, 1,3))),nLenNum )
			cData   :=Substr(xBuffer,Int(Val(Substr(cPosData,1,3))),nLenData)
			cData   :=ChangDate(cData,SEE->EE_TIPODAT)
			dBaixa  :=Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5,2),"ddmmyy")
			cTipo   :=Substr(xBuffer,Int(Val(Substr(cPosTipo, 1,3))),nLenTipo )
			cTipo   := Iif(Empty(cTipo),"NF ",cTipo)		// Bradesco
			cNsNum  := " "
			cEspecie:= "   "
			dDataCred := Ctod("//")
			dDtVc := Ctod("//")
			IF !Empty(cPosDesp)
				nDespes:=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosDesp,1,3))),nLenDesp))/100,2)
			EndIF
			IF !Empty(cPosDesc)
				nDescont:=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosDesc,1,3))),nLenDesc))/100,2)
			EndIF
			IF !Empty(cPosAbat)
				nAbatim:=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosAbat,1,3))),nLenAbat))/100,2)
			EndIF
			IF !Empty(cPosPrin)
				nValRec :=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosPrin,1,3))),nLenPrin))/100,2)
			EndIF
			IF !Empty(cPosJuro)
				nJuros  :=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosJuro,1,3))),nLenJuro))/100,2)
			EndIF
			IF !Empty(cPosMult)
				nMulta  :=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosMult,1,3))),nLenMult))/100,2)
			EndIF
			IF !Empty(cPosOutrd)
				nOutrDesp  :=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosOutrd,1,3))),nLenOutrd))/100,2)
			EndIF
			IF !Empty(cPosCc)
				nValCc :=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosCc,1,3))),nLenCc))/100,2)
			EndIF
			IF !Empty(cPosDtCc)
				cData  :=Substr(xBuffer,Int(Val(Substr(cPosDtCc,1,3))),nLenDtCc)
				cData    := ChangDate(cData,SEE->EE_TIPODAT)
				dDataCred:=Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5,2),"ddmmyy")
				dDataUser:=dDataCred
			End
			IF !Empty(cPosNsNum)
				cNsNum  :=Substr(xBuffer,Int(Val(Substr(cPosNsNum,1,3))),nLenNsNum)
			End
			If nLenOcor == 2
				cOcorr  :=Substr(xBuffer,Int(Val(Substr(cPosOcor,1,3))),nLenOcor) + " "
			Else
				cOcorr  :=Substr(xBuffer,Int(Val(Substr(cPosOcor,1,3))),nLenOcor)
			EndIf
			If !Empty(cPosMot)
				cMotBan:=Substr(xBuffer,Int(Val(Substr(cPosMot,1,3))),nLenMot)
			EndIf
			IF !Empty(cPosDtVc)
				cDtVc :=Substr(xBuffer,Int(Val(Substr(cPosDtVc,1,3))),nLenDtVc)
				cDtVc := ChangDate(cDtVc,SEE->EE_TIPODAT)
				dDtVc :=Ctod(Substr(cDtVc,1,2)+"/"+Substr(cDtVc,3,2)+"/"+Substr(cDtVc,5,2),"ddmmyy")
			EndIf


			//�������������������������������Ŀ
			//� o array aValores ir� permitir �
			//� que qualquer exce��o ou neces-�
			//� sidade seja tratado no ponto  �
			//� de entrada em PARAMIXB        �
			//���������������������������������
			// Estrutura de aValores
			//	Numero do T�tulo	- 01
			//	data da Baixa		- 02
			// Tipo do T�tulo		- 03
			// Nosso Numero			- 04
			// Valor da Despesa		- 05
			// Valor do Desconto	- 06
			// Valor do Abatiment	- 07
			// Valor Recebido    	- 08
			// Juros				- 09
			// Multa				- 10
			// Outras Despesas		- 11
			// Valor do Credito		- 12
			// Data Credito			- 13
			// Ocorrencia			- 14
			// Motivo da Baixa 		- 15
			// Linha Inteira		- 16
			// Data de Vencto	   	- 17

			aValores := ( { cNumTit, dBaixa, cTipo, cNsNum, nDespes, nDescont, nAbatim, nValRec, nJuros, nMulta, nOutrDesp, nValCc, dDataCred, cOcorr, cMotBan, xBuffer,dDtVc,{} })

			If ExistBlock("200GEMBX")
				ExecBlock("200GEMBX", .F., .F., {aValores})
			EndIf

			// Template GEM
			If lF200Var
				ExecBlock("F200VAR",.F.,.F.,{aValores})
			ElseIf ExistTemplate("GEMBaixa")
				ExecTemplate("GEMBaixa",.F.,.F.,)
			Endif

			If Empty(cNumTit)
				nLidos += nTamDet
				Loop
			EndIf

			//�������������������������������Ŀ
			//� Verifica especie do titulo    �
			//���������������������������������
			nPos := Ascan(aTabela, {|aVal|aVal[1] == Substr(cTipo,1,2)})
			If nPos != 0
				cEspecie := aTabela[nPos][2]
			Else
				cEspecie	:= "  "
			EndIf
			If cEspecie $ MVABATIM			// Nao l� titulo de abatimento
				nLidos += nTamDet
				Loop
			Endif
		Else
			nLidos += nTamDet
			Loop
		Endif
	Else
		aLeitura := ReadCnab2(nHdlBco,MV_PAR05,nTamDet,aArqConf)
		cNumTit  := SubStr(aLeitura[1],1,nTamTit)
		cData    := aLeitura[04]
		cData    := ChangDate(cData,SEE->EE_TIPODAT)
		dBaixa   := Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5,2),"ddmmyy")
		cTipo    := aLeitura[02]
		cTipo    := Iif(Empty(cTipo),"NF ",cTipo)		// Bradesco
		cNsNum   := aLeitura[11]
		nDespes  := aLeitura[06]
		nDescont := aLeitura[07]
		nAbatim  := aLeitura[08]
		nValRec  := aLeitura[05]
		nJuros   := aLeitura[09]
		nMulta   := aLeitura[10]
		cOcorr   := PadR(aLeitura[03],3)
		nValOutrD:= aLeitura[12]
		nValCC   := aLeitura[13]
		cData    := aLeitura[14]
		cData    := ChangDate(cData,SEE->EE_TIPODAT)
		dDataCred:= Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5,2),"ddmmyy")
		dDataUser:= dDataCred
		cMotBan  := aLeitura[15]
		xBuffer  := aLeitura[17] // Segmentos concatenados
		aBuffer  := aLeitura[19] // Segmentos separados
		dDtVc		:= CTOD("//")

		aValores := ( { cNumTit, dBaixa, cTipo, cNsNum, nDespes, nDescont, nAbatim, nValRec, nJuros, nMulta, nVaLOutrD, nValCc, dDataCred, cOcorr, cMotBan, xBuffer, dDtVc, aBuffer })


		If ExistBlock("200GEMBX")
  			ExecBlock("200GEMBX", .F., .F., {aValores})
		EndIf

		// Template GEM
		If lF200Var
			ExecBlock("F200VAR",.F.,.F.,{aValores})
		ElseIf ExistTemplate("GEMBaixa")
			ExecTemplate("GEMBaixa",.F.,.F.,)
		Endif

		If Empty(cNumTit)
			nLidos += nTamDet
			Loop
		Endif

		//�������������������������������Ŀ
		//� Verifica especie do titulo    �
		//���������������������������������
		nPos := Ascan(aTabela, {|aVal|aVal[1] == Alltrim(Substr(cTipo,1,3))})
		If nPos != 0
			cEspecie := aTabela[nPos][2]
		Else
			cEspecie	:= "  "
		EndIf
		If cEspecie $ MVABATIM			// Nao l� titulo de abatimento
			Loop
		EndIf
	EndIf
	If lF200Avl .And. !ExecBlock("F200AVL",.F.,.F.,{aValores} )
		Loop
	Endif
	//�������������������������������Ŀ
	//� Verifica codigo da ocorrencia �
	//� �ndice: Filial+banco+cod banco�
	//� +tipo                         �
	//���������������������������������
	dbSelectArea("SEB")
	dbSetOrder(1)
	If !(dbSeek(xFilial("SEB")+mv_par06+cOcorr+"R"))
		Help(" ",1,"FA200OCORR",,mv_par06+"-"+cOcorr+"R",4,1)

		// Retorno Automatico via Job
		if ExecSchedule()
			Aadd(aMsgSch, "Ocorrencia "+mv_par06+" "+cOcorr+" nao localizada na tabela SEB.") //  # 
		Endif
	Endif
	lHelp 		:= .F.
	lNaoExiste  := .F.				// Verifica se registro de reciclagem existe no SE1
	If lT200pos
		ExecTemplate("FA200POS",.F.,.F.,{aValores})
	Endif
	If l200pos
		Execblock("FA200POS",.F.,.F.,{aValores})
	Endif
	//���������������������������������������������������������������Ŀ
	//� Verifica se existe o titulo no SE1. Caso este titulo nao seja �
	//� localizado, passa-se para a proxima linha do arquivo retorno. �
	//� O texto do help sera' mostrado apenas uma vez, tendo em vista �
	//� a possibilidade de existirem muitos titulos de outras filiais.�
	//� OBS: Sera verificado inicialmente se nao existe outra chave   �
	//� igual para tipos de titulo diferentes.                        �
	//�����������������������������������������������������������������
	dbSelectArea("SE1")
	IF ExistBlock("FA200SEB")
		lProcessa := ExecBlock("FA200SEB",.F.,.F.)
		lProcessa := IIF(ValType(lProcessa) != "L",.T., lProcessa)
	ENDIF

	IF lProcessa
		If SEB->EB_OCORR != "39"		// cod 39 -> indica reciclagem
			SE1->(dbSetOrder(1))
			lAchouTit := .F.

			If lFa200Fil
				l200Fil := .T.
				Execblock("FA200FIL",.F.,.F.,aValores)
			Else

				If (mv_par13 == 2 .And. lNewIndice) .And. !Empty( cFilFwSE1 )
					//Busca por IdCnab (sem filial)
					SE1->(dbSetOrder(19)) // IdCnab
					If SE1->(MsSeek(Substr(cNumTit,1,10)))
						cFilAnt	:= SE1->E1_FILIAL
						If lCtbExcl
							mv_par11 := 2  //Desligo contabilizacao on-line
						Endif
					Endif
				Else
					//Busca por IdCnab
					SE1->(dbSetOrder(16)) // Filial+IdCnab
					SE1->(MsSeek(xFilial("SE1")+	Substr(cNumTit,1,10)))
				Endif

				//Se nao achou, utiliza metodo antigo (titulo)
				If SE1->(!Found())
					SE1->(dbSetOrder(1))
					// Busca por chave antiga como retornado pelo banco
					If dbSeek(xFilial("SE1")+Substr(cNumTit,1,nTamTit)+cEspecie)
						lAchouTit := .T.
						nPos   := 1
					Endif

					While !lAchouTit
						// Busca por chave antiga
						dbSetOrder(1)
						If !dbSeek(xFilial("SE1")+Pad(cNumTit,nTamTit)+cEspecie)
							nPos := Ascan(aTabela, {|aVal|aVal[1] == Substr(cTipo,1,2)},nPos+1)
							If nPos != 0
								cEspecie := aTabela[nPos][2]
							Else
								Exit
							Endif
						Else
							lAchouTit := .T.
						Endif
					Enddo

					If !lAchouTit
						// Busca por chave antiga adaptada para o tamanho de 9 posicoes para numero de NF
			  			// Isto ocorre quando titulo foi enviado com 6 posicoes para numero de NF e retornou com o
			   			// campo ja atualizado para 9 posicoes
						cNumTit := SubStr(cNumTit,1,nTamPre)+Padr(Substr(cNumtit,4,6),nTamNum)+SubStr(cNumTit,10,nTamPar)
						If !Empty(cNumTit) .And. dbSeek(xFilial("SE1")+Substr(cNumTit,1,nTamTit))
							cEspecie := SE1->E1_TIPO
							lAchouTit := .T.
							nPos   := 1
		    			Endif


						While !lAchouTit
							// Busca por chave antiga
							dbSetOrder(1)
							If !dbSeek(xFilial("SE1")+Pad(cNumTit,nTamTit)+cEspecie)
								nPos := Ascan(aTabela, {|aVal|aVal[1] == Substr(cTipo,1,2)},nPos+1)
								If nPos != 0
									cEspecie := aTabela[nPos][2]
								Else
									Exit
								Endif
							Else
								lAchouTit := .T.
							Endif
						Enddo
					Endif
				Else
					nPos := 1
				Endif

				If nPos == 0
					lHelp := .T.
				EndIF
				If !lUmHelp .And. lHelp
					Help(" ",1,"NOESPECIE",,cNumTit+" "+cEspecie,5,1)
					lUmHelp := .T.

					// Retorno Automatico via Job
					if ExecSchedule()
						Aadd(aMsgSch, "Especie "+cEspecie+" nao localizada para o titulo "+cNumTit) //  # 
					Endif
				Endif
			EndIf
		Else
			If lRecicl
				//���������������������������������������������������������������Ŀ
				//� Mesmo que nao exista o registro no SE1, ele ser� criado no 	�
				//� arquivo de reclicagem                                         �
				//�����������������������������������������������������������������
				dbSetOrder(nIndex+1)
				If !dbSeek(xFilial("SE1")+cNsNum)
					If !lFirst
						Fa200Recic()				// Abre arquivo de reciclagem
						lFirst := .T.
					EndIf
					Fa200GrRec(cNsNum)
					lNaoExiste := .T.				// Registro nao existente no SE1 -> portanto nao deve gravar nada no SE1!!
				Endif
			Else			//  uma rejeicao porem o registro nao foi cadastrado no SE1
				Help(" ",1,"NOESPECIE",,cNumTit+" "+cEspecie,5,1)
				lNaoExiste := .T.

				// Retorno Automatico via Job
				if ExecSchedule()
					Aadd(aMsgSch, "Especie "+cEspecie+" nao localizada para o titulo "+cNumTit) //  # 
				Endif
			EndIf
		EndIF
	ENDIF

	BEGIN TRANSACTION

	// Retorno Automatico via Job
	// controla o status para emissao do relatorio de processamento
	if ExecSchedule()
		cStProc := ""
		if lNaoExiste
			cStProc := "Titulo Inexistente" // 
	     	Aadd(aFa205R,{cNumTit,"", "", dBaixa,	0, nValRec, cStProc })
		Elseif lHelp
			if SE1->E1_SALDO = 0
				cStProc := "Baixado anteriormente" // 
			Else
				cStProc := "Titulo com Erro" // 
			Endif
		Endif
	Endif

	If !lHelp .And. !lNaoExiste
		// Retorno Automatico via Job
		// controla o status para emissao do relatorio de processamento do FINA205
		if ExecSchedule() .and. SE1->E1_SALDO = 0
			cStProc := "Baixado anteriormente" // 
		Endif

		lSai := .f.
		IF SEB->EB_OCORR $ "03�15�16�17�40�41�42�52�53"		//Registro rejeitado
			// Retorno Automatico via Job
			// controla o status para emissao do relatorio de processamento do FINA205
			if ExecSchedule()
				cStProc := "Entrada confirmada" // 
			Endif

			For nCont := 1 To Len(cMotBan) Step 2
				cMotivo := Substr(cMotBan,nCont,2)
				If fa200Rejei(cMotivo,cOcorr)
					lSai := .T.
					//������������������������������������������������Ŀ
					//� Trata tarifas da retirada do titulo do banco	�
					//��������������������������������������������������
			      If lBxCnab
			      	nTotDesp += nDespes
					nTotOutD += nOutrDesp
			      Else
						IF nDespes > 0 .or. nOutrDesp > 0		//Tarifas diversas
							Fa200Tarifa()
						Endif
					Endif
					Exit
				EndIf
			Next nCont
			If lSai .And. ( MV_PAR12 == 1 )
				nLidos += nTamDet
			Endif
		Endif

		If !lSai
			IF SEB->EB_OCORR $ "06�07�08�36�37�38�39"		//Baixa do Titulo
				cPadrao:=fA070Pad()
				lPadrao:=VerPadrao(cPadrao)
				lContabiliza:= Iif(mv_par11==1,.T.,.F.)

				//�������������������������������Ŀ
				//� Monta Contabilizacao.         �
				//���������������������������������
				If !lCabec .and. lPadrao .and. lContabiliza
					nHdlPrv := HeadProva( cLote,;
					                      "FINA200",;
					                      substr( cUsuario, 7, 6 ),;
					                      @cArquivo )

					lCabec := .T.
				End
				nValEstrang := SE1->E1_SALDO
				lDesconto   := Iif(mv_par10==1,.T.,.F.)

				nTotAbImp	:= 0
				nTotAbat	:= SumAbatRec(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA, SE1->E1_MOEDA,"S",dBaixa,@nTotAbImp)
				ABATIMENTO 	:= nTotAbat
				
				If lAltPort
					cBanco      := Iif(Empty(SE1->E1_PORTADO),MV_PAR06,SE1->E1_PORTADO)
					cAgencia    := Iif(Empty(SE1->E1_AGEDEP),MV_PAR07,SE1->E1_AGEDEP)
					cConta      := Iif(Empty(SE1->E1_CONTA),MV_PAR08,SE1->E1_CONTA)
				Endif

				cHist070    := OemToAnsi("Valor recebido s/ Titulo")  //

				//Ponto de entrada para tratamento de abatimento e desconto que voltam na mesma posicao
				//Bradesco
				If lF200ABAT
					ExecBlock("F200ABAT",.F.,.F.)
				Endif

				SA6->(DbSetOrder(1))
				SA6->(MSSeek(xFilial("SA6")+cBanco+cAgencia+cConta))

				//�������������������������������Ŀ
				//� Verifica se a despesa est�    �
				//� descontada do valor principal �
				//���������������������������������
				If SEE->EE_DESPCRD == "S"
					nValRec := nValRec+nDespes + nOutrDesp - nValCC
				EndIf
				// Calcula a data de credito, se esta estiver vazia
				If dDataCred == Nil .Or. Empty(dDataCred)
					dDataCred := dBaixa // Assume a data da baixa
					For nX := 1 To SA6->A6_Retenca // Para todos os dias de retencao
															 // valida a data

						// O calculo eh feito desta forma, pois os dias de retencao
						// sao dias uteis, e se fosse apenas somado dDataCred+A6_Retenca
						// nao sera verdadeiro quando a data for em uma quinta-feira, por
						// exemplo e, tiver 2 dias de retencao.
						dDataCred := DataValida(dDataCred+1,.T.)
					Next
				EndIf
				dDataUser := dDataCred
				If dDataCred > dBaixa
					cModSpb := "3"   // COMPE
				Endif
				//����������������������������������Ŀ
				//� Possibilita alterar algumas das  �
				//� vari�veis utilizadas pelo CNAB.  �
				//������������������������������������

				If lFina200
					aValores[8] := nValRec
					ExecBlock("FINA200",.F.,.F., { aValores, nTotAbat, nTotAbImp } )
				Endif

				// Serao usadas na Fa070Grv para gravar a baixa do titulo, considerando os acrescimos e decrescimos
				nAcresc     := Round(NoRound(xMoeda(SE1->E1_SDACRES,SE1->E1_MOEDA,1,dBaixa,3),3),2)
				nDecresc    := Round(NoRound(xMoeda(SE1->E1_SDDECRE,SE1->E1_MOEDA,1,dBaixa,3),3),2)

				nDescont 	:= nDescont - nDecresc
				nJuros		:= nJuros - nAcresc

				lBaixou		:=fA070Grv(lPadrao,lDesconto,lContabiliza,cNsNum,.T.,dDataCred,lJurComis,cArqEnt,SEB->EB_OCORR)

				// evitando problemas de processamento
				if ExecSchedule()
					Sleep(500)
				Endif

				If lBaixou

					//��������������������������������������������������������Ŀ
					//� Verifica se trata Rateio Multi-Natureza na Baixa CNAB  �
					//����������������������������������������������������������
					If lMulNatBx .And. MV_MULNATR .And. SE1->E1_MULTNAT == "1"
						
						//Variaveis para uso na funcao MultNatC
						nTotLtEZ  := 0
						lOK		  := .F. 
						aColsSEV  := {}
					    aGrvLctPco := {	{"000004","09","FINA200"}, ;
							   			{"000004","10","FINA200"}  }
						
						MultNatB("SE1",.F.,"1",@lOk,@aColsSEV,.T.,.T.)
						If lOk
							MultNatC( "SE1" /*cAlias*/,;
										@nHdlPrv /*@nHdlPrv*/,;
										@nTotal /*@nTotal*/,;
										@cArquivo /*@cArquivo*/,;
										lContabiliza /*lContabiliza*/,;
										.T. /*lBxLote*/,;
										"1" /*cReplica*/,;
										nTotLtEZ /*nTotLtEZ*/,;
										lOk /*lOk*/,;
										aColsSEV /*aCols*/,;
										.T. /*lBaixou*/,;
										aGrvLctPco /*aGrvLctPco*/,;
										lUsaFlag /*lUsaFlag*/,;
										@aFlagCTB /*@aFlagCTB*/	)
						Endif 
					Endif


					// Retorno Automatico via Job
					// controla o status para emissao do relatorio de processamento do FINA205
					if ExecSchedule()
						cStProc := "Baixado Ok"
					Endif

					//����������������������������������������������������������Ŀ
					//� Grava os lancamentos nas contas orcamentarias SIGAPCO    �
					//������������������������������������������������������������
					If SE1->E1_SITUACA == "0"	// Carteira
						PcoDetLan("000004","01","FINA070")
					ElseIf SE1->E1_SITUACA == "1"	// Simples
						PcoDetLan("000004","02","FINA070")
					ElseIf SE1->E1_SITUACA == "2"	// Descontada
						PcoDetLan("000004","03","FINA070")
					ElseIf SE1->E1_SITUACA == "4"	// Vinculada
						PcoDetLan("000004","04","FINA070")
					ElseIf SE1->E1_SITUACA == "5"	// c/Advogado
						PcoDetLan("000004","05","FINA070")
					ElseIf SE1->E1_SITUACA == "6"	// Judicial
						PcoDetLan("000004","06","FINA070")
					ElseIf SE1->E1_SITUACA == "7"	// Caucionada Descontada
						PcoDetLan("000004","08","FINA070")
					EndIf

					//��������������������������������������������������Ŀ
					//�Integracao Protheus X RM Classis Net (RM Sistemas)�
					//����������������������������������������������������
					if GetNewPar("MV_RMCLASS", .F.)
						//Replica a baixa do titulo para o RM Classis Net (RM Sistemas)
						ClsProcBx(SE1->(Recno()),'1',"FIN200")
					endif

					nTotAGer+=nValRec

					//Para baixa totalizadora somente gravo o movimento de titulos que
					//nao estejam em carteira descontada (2 ou 7) pois este movimento bancario
					//j� foi gerado no momento da transferencia ou montagem do bordero
					IF !(SE1->E1_SITUACA $ "2/7")
						dbSelectArea("TRB")
						If !(dbSeek(xFilial("SE5")+Dtos(dDataCred)))
							Reclock("TRB",.T.)
							Replace FILMOV With xFilial("SE5")
							Replace DATAC With dDataCred
						Else
							Reclock("TRB",.F.)
						Endif
						Replace TOTAL WITH TOTAL + nValRec
						MsUnlock()
					Endif
				Else
					LoadVlBx( nHdlBco, xBuffer, nTamDet, @nValtot, @nTotDesp, @nTotOutD, @nTotValCc, @nTotAGer,aLeitura, lBxCnab)
					cStProc := "Problemas na Baixa"
				Endif

				If lBxCnab
					nTotValCc += nValCC
				Else
					//��������������������������������������������������������Ŀ
					//� Grava Outros Cr�ditos, se houver valor                 �
					//����������������������������������������������������������
					If nValcc > 0
						fa200Outros()
					Endif
				Endif

				If lCabec .and. lPadrao .and. lContabiliza .and. lBaixou
					nTotal += DetProva( nHdlPrv,;
					                    cPadrao,;
					                    "FINA200" /*cPrograma*/,;
					                    cLote,;
					                    /*nLinha*/,;
					                    /*lExecuta*/,;
					                    /*cCriterio*/,;
					                    /*lRateio*/,;
					                    /*cChaveBusca*/,;
					                    /*aCT5*/,;
					                    /*lPosiciona*/,;
					                    @aFlagCTB,;
					                    /*aTabRecOri*/,;
					                    /*aDadosProva*/ )
				Endif


				//�������������������������������Ŀ
				//� Credito em C.Corrente -> gera �
				//� arquivo de reciclagem         �
				//���������������������������������
				If SEB->EB_OCORR $ "39"
					If lRecicl
						If !lFirst
							Fa200Recic()
							lFirst := .T.
						EndIf
						Fa200GrRec(cNsNum)
						dbSelectArea("SE1")
						RecLock("SE1")
						Replace E1_OCORREN With "02"
						MsUnlock()
					EndIf
				EndIf
			Endif

		    If lBxCnab
		      	nTotDesp += nDespes
				nTotOutD += nOutrDesp
			Else
				IF nDespes > 0 .or. nOutrDesp > 0		//Tarifas diversas
					Fa200Tarifa()
				Endif
			Endif

			If SEB->EB_OCORR == "02"			// Confirma��o
				RecLock("SE1")
				SE1->E1_OCORREN := "01"
				If Empty(SE1->E1_NUMBCO)
					SE1->E1_NUMBCO  := cNsNUM
				EndIf
				MsUnLock()
				If lFa200_02
					ExecBlock("FA200_02",.f.,.f.)
				Endif
			Endif

			//Grava alteracao da data de vencto quando for o caso
			If SEB->EB_OCORR $ "14" .and. !Empty(dDtVc)  //Alteracao de Vencto
				RecLock("SE1")
				Replace SE1->E1_VENCTO With dDtVc
				Replace SE1->E1_VENCREA With DataValida(dDtVc,.T.)
				MsUnlock()
			Endif

       		//�����������������������������������������������������Ŀ
			//� Trecho incluido para integra��o e-commerce          �
			//�������������������������������������������������������
			
			//If  lBaixou .And. FindFunction("LJ861EC02") .And. FindFunction("LJ861EC01")
			//    If  LJ861EC01(SE1->E1_NUM, SE1->E1_PREFIXO, .T./*PrecisaTerPedido*/)
			//	    LJ861EC02(SE1->E1_NUM, SE1->E1_PREFIXO)
			//    EndIf		
			//EndIf
			
					
			// Retorno Automatico via Job
			// armazena os dados do titulo para emissao de relatorio de processamento
			if ExecSchedule()
				If lBaixou
		      		Aadd(aFa205R,{SE1->E1_NUM,		SE1->E1_CLIENTE, 	SE1->E1_LOJA, dDataCred,	SE1->E1_VALOR, nValRec, "Baixado ok" })
		      	Else
			     	Aadd(aFa205R,{SE1->E1_NUM,		SE1->E1_CLIENTE, 	SE1->E1_LOJA, dDataCred,	SE1->E1_VALOR, nValRec, cStProc })
				Endif
	     	Endif

			//Instrucao de alteracao de carteira de cobran�a
			IF SEB->EB_OCORR $ "90#91#93#94#95#96#9F#9G#9H"
				F200TRFCOB(SEB->EB_OCORR,cBanco,cAgencia,cConta)
			Endif

		EndIf
	
	Endif 
	// evitando problemas de processamento
	If ExecSchedule()
		Sleep(500)
	Endif

	END TRANSACTION

	//��������������������������������
	//�Integracao protheus X tin	�
	//��������������������������������  
	
	If FindFunction( "GETROTINTEG" ) 
	    ALTERA:=.T.
		FwIntegDef( 'FINA070' )
		ALTERA:= lAltera
	Endif

	If !lSai

		// Avanca uma linha do arquivo retorno
		nLidos+=nTamDet

		// Se baixou o titulo e existir o arquivo de LOG, grava as informacoes pertinentes
		// Para futuro reprocessamento se preciso for.
		If lBaixou .And. lFI0InDic
			Fa200GrvLog(2, cArqEnt, cBanco, cAgencia, cConta, nLastLn,If(Empty(SE1->E1_IDCNAB), SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO), SE1->E1_IDCNAB), SEB->EB_REFBAN, SEB->EB_OCORR, cIdArq )
		Endif

		//����������������������������������Ŀ
		//� Possibilita alterar algumas das  �
		//� vari�veis utilizadas pelo CNAB.  �
		//������������������������������������
		If lF200Tit
			ExecBlock("F200TIT",.F.,.F.)
		Endif

	EndIf

Enddo

//������������������������������������������������Ŀ
//� Finaliza a gravacao dos lancamentos do SIGAPCO �
//��������������������������������������������������
PcoFinLan("000004")


If lCabec .and. lPadrao .and. lContabiliza
	dbSelectArea("SE1")
	dbGoBottom()
	dbSkip()
	VALOR := nTotAger
	ABATIMENTO := 0
	//nTotal+=DetProva(nHdlPrv,cPadrao,"FINA200",cLote)
	nTotal += DetProva( nHdlPrv,;
	                    cPadrao,;
	                    "FINA200" /*cPrograma*/,;
	                    cLote,;
	                    /*nLinha*/,;
	                    /*lExecuta*/,;
	                    /*cCriterio*/,;
	                    /*lRateio*/,;
	                    /*cChaveBusca*/,;
	                    /*aCT5*/,;
	                    /*lPosiciona*/,;
	                    @aFlagCTB,;
	                    /*aTabRecOri*/,;
	                    /*aDadosProva*/ )


Endif

If l200Fil .and. lfa200F1
	Execblock("FA200F1",.f.,.f.)
Endif

If lTF200Fim
	ExecTemplate("F200FIM",.f.,.f.)
Endif
If lF200Fim
	Execblock("F200FIM",.f.,.f.)
Endif

//������������������������������������������������������Ŀ
//� Grava no SEE o n�mero do �ltimo lote recebido e gera �
//� movimentacao bancaria											�
//��������������������������������������������������������
If !Empty(cLoteFin) .and. lBxCnab
	RecLock("SEE",.F.)
	SEE->EE_LOTE := cLoteFin
	MsUnLock()
	If TRB->(Reccount()) > 0
		dbSelectArea("TRB")
		dbGoTop()
		While !Eof()
			cFilAnt := TRB->FILMOV
			Reclock( "SE5" , .T. )
			SE5->E5_FILIAL := xFilial("SE5")
			SE5->E5_DATA   := TRB->DATAC
		 	SE5->E5_VALOR  := (TRB->TOTAL + nValtot)
			SE5->E5_RECPAG := "R"
			SE5->E5_DTDIGIT:= TRB->DATAC
			SE5->E5_BANCO  := cBanco
			SE5->E5_AGENCIA:= cAgencia
			SE5->E5_CONTA  := cConta
			SE5->E5_DTDISPO:= TRB->DATAC
			SE5->E5_LOTE   := cLoteFin
			SE5->E5_HISTOR := "Baixa por Retorno CNAB / Lote :" + " " + cLoteFin // 
			If SpbInUse()
				SE5->E5_MODSPB := "1"
			Endif
			MsUnlock()

			//������������������������������������������������������Ŀ
			//� Gravacao complementar dos dados da baixa aglutinada  �
			//��������������������������������������������������������
			If ExistBlock("F200BXAG")
				Execblock("F200BXAG",.f.,.f.)
			Endif

			//�������������������������������Ŀ
			//� Atualiza saldo bancario.      �
			//���������������������������������
			AtuSalBco(cBanco,cAgencia,cConta,SE5->E5_DATA,SE5->E5_VALOR,"+")
			dbSelectArea("TRB")
			dbSkip()
		Enddo
	Endif
	If nTotDesp > 0 .Or. nTotOutD > 0
		Fa200Tarifa(nTotDesp, nTotOutD)
	Endif
	If nTotValCC > 0
		fa200Outros(nTotValCC)
	Endif
EndIf

cFilAnt := cFilOrig					// sempre restaura a filial original

//Contabilizo totalizador das despesas banc�rias e outros creditos
If !lBxCnab

	VALOR2 := nCtDesp
	VALOR3 := nCtOutCrd

	dbSelectArea("SE5")
	nRegSE5 := SE5->(Recno())
	dbGoBottom()
	dbSkip()

	lPadrao:=VerPadrao("562")		// Movimentacao Banc�ria a Pagar
	lContabiliza:= Iif(mv_par11==1,.T.,.F.)

	If !lCabec .and. lPadrao .and. lContabiliza
		nHdlPrv := HeadProva( cLote,;
		                      "FINA200",;
		                      substr( cUsuario, 7, 6 ),;
		                      @cArquivo )
		lCabec := .T.
	Endif

	If lCabec .and. lPadrao .and. lContabiliza
		//Total de Despesas e Outras despesas
		nTotal += DetProva( nHdlPrv,;
		                    "562",;
		                    "FINA200" /*cPrograma*/,;
		                    cLote,;
		                    /*nLinha*/,;
		                    /*lExecuta*/,;
		                    /*cCriterio*/,;
		                    /*lRateio*/,;
		                    /*cChaveBusca*/,;
		                    /*aCT5*/,;
		                    /*lPosiciona*/,;
		                    @aFlagCTB,;
		                    /*aTabRecOri*/,;
		                    /*aDadosProva*/ )

		//Total de Outros Cr�ditos
		nTotal += DetProva( nHdlPrv,;
		                    "563",;
		                    "FINA200" /*cPrograma*/,;
		                    cLote,;
		                    /*nLinha*/,;
		                    /*lExecuta*/,;
		                    /*cCriterio*/,;
		                    /*lRateio*/,;
		                    /*cChaveBusca*/,;
		                    /*aCT5*/,;
		                    /*lPosiciona*/,;
		                    @aFlagCTB,;
		                    /*aTabRecOri*/,;
		                    /*aDadosProva*/ )
	Endif

	PCODetLan("000007","11","FINA200")

	VALOR2 := VALOR3 := 0
	dbSelectArea("SE5")
	dbGoto(nRegSE5)
Endif

IF lCabec .and. nTotal > 0
	RodaProva(  nHdlPrv,;
				nTotal )

	//�����������������������������������������������������Ŀ
	//� Envia para Lancamento Contabil                      �
	//�������������������������������������������������������
	cA100Incl( cArquivo,;
	           nHdlPrv,;
	           3 /*nOpcx*/,;
	           cLote,;
	           lDigita,;
	           lAglut,;
	           /*cOnLine*/,;
	           /*dData*/,;
	           /*dReproc*/,;
	           @aFlagCTB,;
	           /*aDadosProva*/,;
	           /*aDiario*/ )

	aFlagCTB := {}  // Limpa o coteudo apos a efetivacao do lancamento
Endif

PcoFinLan("000007")

If lRecicl

	If lFirst
		dbSelectArea("cTemp")
		dbCloseArea()
	Endif
	If cIndex != " "
		RetIndex("SE1")
		Set Filter To
		FErase (cIndex+OrdBagExt())
	EndIf
Endif

dbSelectArea("TRB")
dbCloseArea()
if ExecSchedule()
	Sleep(2000)
Endif
Fclose(nHdlConf)
Fclose(nHdlBco)
Ferase(cNomeArq+GetDBExtension())         // Elimina arquivos de Trabalho
Ferase(cNomeArq+OrdBagExt())	 			   // Elimina arquivos de Trabalho

VALOR := 0
ABATIMENTO := 0

SM0->(dbGoTo(nRegEmp))
cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )

dbSelectArea( "SE1" )
dbSetOrder(1)
dbGoTo( nSavRecno )
If ExistBlock("F200IMP")
	ExecBlock("F200IMP",.F.,.F.)
Endif

Return .F.



/*/
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Fun��o    � AjustaSX2    � Autor � Valdemir / Eduardo	� Data � 16/09/15 ���
�����������������������������������������������������������������������������Ĵ��
���Descri��o � Ajusta campos do SX2                                           ���
�����������������������������������������������������������������������������Ĵ��
���Sintaxe   � AjustaSx2( )                                                   ���
�����������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                         ���
�����������������������������������������������������������������������������Ĵ��
���Retorno   � .T.                                                            ���
�����������������������������������������������������������������������������Ĵ��
��� Uso		 � FINA200                                                        ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
/*/
STATIC Function AjustaSx2()

Local aArea := GetArea()

DbSelectArea("SX2")
DbSetOrder(1)

//Procura e deleta chave unica do arquivo log de detalhes cnab
If MsSeek("FI1")
	If !Empty(X2_UNICO)
		RecLock("SX2",.F.)
		Replace X2_UNICO   With ""
		MsUnlock()
	Endif
Endif

RestArea(aArea)

Return .T.




/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o	 �Fa200GrvLog� Autor � Valdemir / Eduardo    � Data � 16/09/15 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Grava LOG de processamento do arquivo retorno				   ���
��������������������������������������������������������������������������Ĵ��
���Sintaxe	 �Fa200GrvLog   											   ���
��������������������������������������������������������������������������Ĵ��
��� Uso		 �Fina200													   ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function Fa200GrvLog(nTipo, cArquivo, cBanco, cAgencia, cConta, nLastLn, cIdTit,;
									 cOcoBco, cOcoSis, cIdArq)
Local cSeq := "00"
Local lRet := .T.
Local nLastRec
Local cBarra	:= If(isSrvUnix(),"/","\")
Local nBarra 	:= Rat(cBarra,cArquivo)
Local aUsuario

// Obtem o nome do arquivo apenas, desprezando o path
cArquivo := If(nBarra > 0, SubStr(cArquivo,nBarra+1), cArquivo)

If nTipo == 1 // Cabecalho
	// Se o arquivo ja foi processado, a ultima linha sera a ultima
	// gravada no arquivo
	If FI0->(MsSeek(xFilial("FI0")+Pad(cIdArq,Len(FI0_IDARQ))+cBanco+cAgencia+cConta))
		While FI0->(FI0_FILIAL+Pad(FI0_IDARQ,Len(FI0_IDARQ))+FI0_BCO+FI0_AGE+FI0_CTA) == xFilial("FI0")+Pad(cIdArq,Len(FI0->FI0_IDARQ))+cBanco+cAgencia+cConta
			nLastLn	:= FI0->FI0_LASTLN
			cSeq	  	:= FI0->FI0_SEQ
			nLastRec := FI0->(Recno())
			FI0->(DbSkip())
		End
		FI0->(MsGoto(nLastRec))
		PswOrder(1)

		// caso de usuario excluido estava dando errorlog
		if PswSeek(FI0->FI0_USU)
			aUsuario := PswRet()
			cNomeUsuario := Alltrim(aUsuario[1][2])
		Else
			cNomeUsuario := FI0->FI0_USU
		Endif

		// se estiver em modo Job nao apresenta a mensagem e sempre reprocessa
		lRet := (ExecSchedule() .or. ApMsgYesNo("Arquivo retorno j� processado anteriormente em " +;
								 DTOC(FI0->FI0_DTPRC) + " �s " + FI0->FI0_HRPRC + Chr(13)+Chr(10)+;
								 "Processado com o nome : " + AllTrim(FI0->FI0_ARQ)+ Chr(13)+Chr(10)+ ;
								 "Usu�rio que processou : " + cNomeUsuario+ Chr(13)+Chr(10)+;
								 "A ultima linha lida do arquivo foi: " +	Transform(FI0->FI0_LASTLN, "")+ Chr(13)+Chr(10) +;
								 "O arquivo j� foi processado " + Str(Val(FI0->FI0_SEQ),3) +;
								 If(Val(FI0->FI0_SEQ)<=1," vez", " vezes")+". Deseja  reprocess�-lo?"))

		// Retorno Automatico via Job
		if ExecSchedule()
			Aadd(aMsgSch, "Arquivo retorno j� processado anteriormente em " +;
							DTOC(FI0->FI0_DTPRC) + " �s " + FI0->FI0_HRPRC +;
							". Processado com o nome : " + AllTrim(FI0->FI0_ARQ)+ ;
						 	". A ultima linha lida do arquivo foi: " + Transform(FI0->FI0_LASTLN, "")+;
						 	". Verifique.")
			lRet := .F.
		Endif
	Endif
	If lRet
		RecLock("FI0", .T.)
		FI0->FI0_FILIAL	:= xFilial("FI0")
		FI0->FI0_ARQ		:= cArquivo
		FI0->FI0_IDARQ		:= cIdArq
		FI0->FI0_DTPRC		:= dDataBase
		FI0->FI0_HRPRC		:= Left(Time(), 6) // Grava a HH:MM do processamento
		FI0->FI0_BCO		:= cBanco
		FI0->FI0_AGE		:= cAgencia
		FI0->FI0_CTA		:= cConta
		FI0->FI0_USU		:= RetCodUsr()
		FI0->FI0_LASTLN		:= nLastLn
		FI0->FI0_SEQ		:= Soma1(cSeq)
		FI0->( Dbunlock())
		FKCOMMIT()
	Endif
Elseif nTipo == 2 // Detalhe dos titulos processados
	RecLock("FI1", .T.)
	FI1->FI1_FILIAL		:= xFilial("FI1")
	FI1->FI1_IDARQ		:= cIdArq
	FI1->FI1_IDTIT		:= cIdTit
	FI1->FI1_OCORB		:= cOcoBco
	FI1->FI1_OCORS		:= cOcoSis
	If FI1->(FieldPos("FI1_SEQ")) > 0
		FI1->FI1_SEQ	:= FI0->FI0_SEQ
	Endif
	FI1->( Dbunlock())
	FKCOMMIT()
Endif

Return lRet



/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �ExecSchedule� Autor � Valdemir / Eduardo           �15/09/15���
�������������������������������������������������������������������������Ĵ��
���Descricao �Retorna se o programa esta sendo executado via schedule     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function ExecSchedule()
Local lRetorno := .T.

lRetorno := IsBlind()

Return( lRetorno )

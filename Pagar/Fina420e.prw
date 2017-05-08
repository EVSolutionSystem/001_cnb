#include "Protheus.ch"
#Include "topconn.ch"
#INCLUDE "ap5mail.ch"
#INCLUDE "Fileio.ch"

#define cENTER CHR(13)+CHR(10)

//Tradução PTG 20080721
Static lFWCodFil := FindFunction("FWCodFil")

//Pontos de Entrada
Static lF420CIT    := ExistBlock("F420CIT")
Static lFIN420_1   := ExistBlock("FIN420_1")
Static lF420FIL    := ExistBlock("F420FIL")
Static lSomaValor  := ExistBlock("F420SOMA")
Static lF420SumA   := ExistBlock("F420SUMA")
Static lF420SumD   := ExistBlock("F420SUMD")
Static lF420CRP    := ExistBlock("F420CRP")
Static eFA420CRI   := ExistBlock("FA420CRI")
Static lFA420NAR   := ExistBlock("FA420NAR")
Static l420Chkfile := ExistBlock("F420CHK")
Static lF420ICNB   := ExistBlock ("F420ICNB")
Static lF420IDBP   := ExistBlock("F420IDBP")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Fina420e ³ Autor ³ Valdemir / Eduardo    ³ Data ³ 11/09/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera‡„o do Arquivo CNAB                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³  		                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Fina420v ()
Local lPanelFin := If (FindFunction("IsPanelFin"),IsPanelFin(),.F.)
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}
Local lPergunte := .F.
Local cBor1     := ''
Local cBor2     := ''
Local nPosArotina := 3

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros 	  ³
//³ mv_par01		 // Do Bordero 		  	  ³
//³ mv_par02		 // Ate Bordero   	  	  ³
//³ mv_par03		 // Arq.Configuracao   	  ³
//³ mv_par04		 // Arq. Saida			  ³
//³ mv_par05		 // Banco       		  ³
//³ mv_par06		 // Agencia 			  ³
//³ mv_par07		 // Conta       		  ³
//³ mv_par08		 // Sub-Conta			  ³
//³ mv_par09 		 // Modelo 1/Modelo 2  	  ³
//³ mv_par10		 // Cons.Filiais Abaixo	  ³
//³ mv_par11		 // Filial de     	      ³
//³ mv_par12		 // Filial Ate 		  	  ³
//³ mv_par13		 // Receita Bruta Acumulada ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lPanelFin
	lPergunte := PergInPanel("AFI420",.F.)
Else
   lPergunte := pergunte("AFI420",.F.)
Endif

Private cPerg   	:= "AFI420"
Private nHdlBco 	:=0,nHdlSaida:=0,nSeq:=0,cBanco,cAgencia,nSomaValor := 0
Private nSomaCGC	:=0,nSomaData:=0
Private aRotina 	:= MenuDef()
PRIVATE xConteudo
PRIVATE nTotCnab2  := 0 		// Contador de Lay-out nao deletar
PRIVATE nLinha 	   := 0 		// Contador de LINHAS, nao deletar
PRIVATE nSomaVlLote:= 0
PRIVATE nQtdTotTit := 0
PRIVATE nQtdTitLote:= 0
PRIVATE nQtdLinLote:= 1     // Valdemir José
PRIVATE nTotLinArq := 0
PRIVATE nLotCnab2  := 1		//Contador de lotes do CNAB2
//Private _xNumBor := ''

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de baixas                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cCadastro := OemToAnsi("Gera‡„o Arquivo Envio")  //"Gera‡„o Arquivo Envio"

Aadd(aHelpPor,"Conforme os parâmetros informados, "    )
Aadd(aHelpPor,"nenhum titulo em aberto foi encontrado" )
Aadd(aHelpPor,"para ser gerado no arquivo de envio."   )

Aadd(aHelpEng,"According to the informed parameters, " )
Aadd(aHelpEng,"no pending bill was found in order "    )
Aadd(aHelpEng,"to be generated in the sending file."   )

Aadd(aHelpSpa,"Conforme los parametros informados, no" )
Aadd(aHelpSpa,"se encontro ningun título pendiente "   )
Aadd(aHelpSpa,"para generar en el archivo de envio."   )

PutHelp("PF420NOTIT",aHelpPor,aHelpEng,aHelpSpa,.T.)

cBor1    :=  _xNumBor       //GetBorIni(1)
cBor2    :=  GetBorIni(2)


mv_par01 :=	cBor1 					 								// Do Bordero 		  	  ³
mv_par02 :=	cBor2 					 					 			// Ate Bordero   	  	  ³
IF _cBanco = '341'
	mv_par03 :=	Left('341.2PE'+Space(Len(mv_par03)),Len(mv_par03))   	// Arq.Configuracao   	  ³
ELSEIF _cBanco = '001'
	mv_par03 :=	Left('001.2PE'+Space(Len(mv_par03)),Len(mv_par03))   	// Arq.Configuracao   	  ³
ELSEIF _cBanco = '033'
	mv_par03 :=	Left('033.2PE'+Space(Len(mv_par03)),Len(mv_par03))   	// Arq.Configuracao   	  ³
ELSEIF _cBanco = '237'
	mv_par03 :=	Left('237.CPE'+Space(Len(mv_par03)),Len(mv_par03))   	// Arq.Configuracao   	  ³
ELSEIF _cBanco = '422'
	mv_par03 :=	Left('422.CPE'+Space(Len(mv_par03)),Len(mv_par03))   	// Arq.Configuracao   	  ³
ELSEIF _cBanco = '745'
	mv_par03 :=	Left('745.2pe'+Space(Len(mv_par03)),Len(mv_par03))   	// Arq.Configuracao   	  ³
ELSEIF _cBanco = '104'
	mv_par03 :=	Left('104.2pe'+Space(Len(mv_par03)),Len(mv_par03))   	// Arq.Configuracao   	  ³
ENDIF

cDtTime := dtos(dDatabase)+StrTran(time(),':','')

mv_par04 :=	"C:\EVAUTO\APagar\"+_cBanco+"-"+_cAgencia+'-'+cDtTime+".REM"		// Arq. Saida			  ³
mv_par05 :=	 _cBanco				 								// Banco       		  ³
mv_par06 :=	 _cAgencia	 			 								// Agencia 			  ³
mv_par07 :=	 _cConta	 			 								// Conta       		  ³
mv_par08 :=	 Left('P'+Space(Len(mv_par08)),Len(mv_par08))	 		// Sub-Conta			  ³
mv_par09 :=	 if(_cBanco == '422' .or. _cBanco == '237',1,2)			// Modelo 1/Modelo 2  	  ³
mv_par10 :=	 1	 													// Cons.Filiais Abaixo	  ³
mv_par11 :=  ''		 												// Filial de     	      ³
mv_par12 :=	 'ZZ'													// Filial Ate 		  	  ³
mv_par13 :=	 0	 													// Receita Bruta Acumulada ³


SEA->( dbGotop() )
SE2->( dbGotop() )
SEE->( dbGotop() )

If nPosArotina > 0 // Sera executada uma opcao diretamento de aRotina, sem passar pela mBrowse
   dbSelectArea("SE2")
   //bBlock := &( "{ |a,b,c,d,e| " + u_F420Gera('SE2') + "(aJ,b,c,d,e) }" )
   u_F420Gera('SE2')
   Alias()
   (Alias())->(Recno())
   //Eval( bBlock, Alias(), (Alias())->(Recno()),nPosArotina)
Else
	nReg:=Recno( )
	mBrowse( 6, 1,22,75,"SE2" )
	dbGoto( nReg )
Endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera a Integridade dos dados                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE2")
dbSetOrder(1)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Fina420e ³ Autor ³ Valdemir / Eduardo    ³ Data ³ 11/09/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Busca a numneracao do Bordero                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³  		                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Parametro³ (1) Inicial (2) Final                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GetBorIni(pnInic)
	Local cRET := ''
	Local cQry := "SELECT " + cENTER

	IF SELECT('TSEA') > 0
	   TSEA->( dbCloseArea() )
	ENDIF

	IF pnInic = 1
	   cQry += "MIN(EA_NUMBOR) REG" + cENTER
	Else
	   cQry += "MAX(EA_NUMBOR) REG" + cENTER
	Endif

	cQry += " FROM " + RETSQLNAME('SEA') + " SEA " + cENTER
	cQry += "WHERE SEA.D_E_L_E_T_ = ' ' " + cENTER
	cQry += " AND SEA.EA_DATABOR = '" + DTOS(DDATABASE) + "' " + cENTER
	cQry += " AND SEA.EA_PORTADO = '" + _cBanco + "' " + cENTER                       •
	cQry += " AND SEA.EA_AGEDEP = '" + _cAgencia + "' " + cENTER
	cQry += " AND SEA.EA_NUMCON = '" + _cConta+ "' " + cENTER
	cQry += " AND SEA.EA_FILIAL = '" + XFILIAL('SEA') + "'"

	TcQuery cQry New Alias 'TSEA'

	cRET :=  TSEA->REG

	IF SELECT('TSEA') > 0
	   TSEA->( dbCloseArea() )
	ENDIF

Return cRET



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Fa420Gera³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 26/05/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Sispag - Envio Banco de Boston -> Geracao Arquivo (chamada)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Fa420Gera(cAlias)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FinA420                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function F420Gera(cAlias)
Local cSetFilter := SE2->(DBFILTER()) // Salva o filtro atual, para restaurar no final da rotina

Processa({|lEnd| u_F420Ger(cAlias)})  // Chamada com regua

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha os Arquivos ASC II                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nHdlBco > 0
	FCLOSE(nHdlBco)
Endif
If nHdlSaida > 0
	FCLOSE(nHdlSaida)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de Entrada para Tratamento baixa - Citibank³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*If lF420CIT
	ExecBlock("F420CIT",.F.,.F.)
Endif
*/
dbSelectArea("SE2")
RetIndex("SE2")
// Restaura o filtro
Set Filter To &cSetFilter.
nSomaVlLote:= 0
nQtdTotTit := 0
nQtdTitLote:= 0
nTotLinArq := 0
nQtdLinLote:= 0
nTotLinArq := 0
nSomaValor := 0

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Fa420Ger ³ Autor ³ Wagner Xavier         ³ Data ³ 26/05/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Comunica‡„o Banc ria - Envio                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Fa420Ger()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FinA420                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function F420Ger(cAlias)
Local xBuffer
Local nTamArq		:= 0
Local nLidos		:= 0
Local lResp			:= .F.
Local lHeader		:= .F.
Local lFirst		:= .F.
Local lTrailler 	:= .F.
Local lTemHeader 	:= .F.
Local nTam
Local nDec
Local nUltDisco		:= 0
Local nGrava		:= 0
Local aBordero		:= {}
Local nSavRecno 	:= recno()
Local nRecEmp 		:= SM0->(RecNo())
Local cFilDe
Local cFilAte
Local cNumBorAnt 	:= CRIAVAR("E2_NUMBOR",.F.)
Local lFirstBord 	:= .T.
Local lBorBlock	 	:= .F.
Local cFiltro    	:= ""
Local lIdCnab 	 	:= .T.
Local lHeadMod2	 	:= .F.
Local cFilBor	 	:= ""
Local lMudouBordero := .F.
Local lTemTit 		:= .F.
Local nAbatim
Local bWhile
Local lNewIndice 	:= FaVerInd()
Local lGestao	 	:= Iif( lFWCodFil, ( "E" $ FWSM0Layout() .Or. "U" $ FWSM0Layout() ), .F. )	// Indica se usa Gestao Corporativa
Local lFimLin		:= 0
Local nRecnoSEA     := 0

Local lBordIni		:= .F.
Local cQuery		:= ""
Local cAliasFil		:= "SE2"
Local cAliasE2 		:= ""
Local lDefTop		:= IfDefTopCTB()
Local cFilBords		:= ""
Local aFilBords		:= {}

/* GESTAO - inicio */
Local nLenSelFil	:= 0
Local nX			:= 0

Private aSelFil	:= {}
/* GESTAO - fim */

Private nSomaAcres := 0
Private nSomaDecre := 0

nHdlBco    	:= 0
nHdlSaida  	:= 0
nSeq       	:= 0
nSomaValor 	:= 0
nSomaCGC   	:= 0
nSomaData  	:= 0
nTotCnab2  	:= 0 // Contador de Lay-out nao deletar
nSomaAbat	:= 0
nLotCnab2 	:= 1
nQtdLinLote	:= 0
nTotLinArq 	:= 0

ProcRegua(SE2->(RecCount()))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de Entrada F420FIL                                  	 ³
//³ Cria chave de filtro para titulos do bordero a nÆo serem 	 ³
//³ enviados ao arquivo bancario								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lF420Fil
	cFiltro := ExecBlock("F420FIL",.F.,.F.)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ POR MAIS ESTRANHO QUE PARE€A, ESTA FUNCAO DEVE SER CHAMADA AQUI! ³
//³                                                                  ³
//³ A fun‡„o SomaAbat reabre o SE2 com outro nome pela ChkFile para  ³
//³ efeito de performance. Se o alias auxiliar para a SumAbat() n„o  ³
//³ estiver aberto antes da IndRegua, ocorre Erro de & na ChkFile,   ³
//³ pois o Filtro do SE2 uptrapassa 255 Caracteres.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SomaAbat("","","","P")

dbSelectArea("SE2")
//Garante SXE Criado, para não ocorrer problemas na criacao do numero em uma alias com indregua.
GetSxENum("SE2", "E2_IDCNAB", "E2_IDCNAB"+cEmpAnt,Iif(lNewIndice,13,11))
RollBackSXE()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria indice temporario					                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cIndex := CriaTrab(nil,.f.)
cChave  := IndexKey()
IndRegua("SE2",cIndex,"E2_FILIAL+E2_NUMBOR+E2_FORNECE+E2_LOJA",,cFiltro,OemToAnsi("Selecionando Registros..."))  //
nIndex := RetIndex("SE2")
#IFNDEF TOP
	dbSetIndex(cIndex+ordBagExt())
#ENDIF

dbSetOrder(nIndex+1)
dbGoTop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o arquivo est  realmente vazio ou se       ³
//³ est  posicionado em outra filial.                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If EOF() .or. BOF()
	HELP(" " , 1 , "ARQVAZIO")
	Return Nil
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no Banco indicado                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cBanco  	:= mv_par05
cAgencia	:= mv_par06
cConta  	:= mv_par07
cSubCta 	:= mv_par08

// Ponto de entrada para setar o Banco, agencia e conta de acordo
// com os dados do borderô
If ExistBlock("F420PORT")
   ExecBlock("F420PORT",.f.,.f.,{cBanco,cAgencia,cConta})
Endif

// Ponto de entrada para setar a Filial de acordo com o registro do
// borderô de pagamento
If ExistBlock("F420FILIAL")
   ExecBlock("F420FILIAL",.f.,.f.,{cFilAnt})
Endif

dbSelectArea("SA6")
SA6->( dbSeek(xFilial("SA6")+cBanco+cAgencia+cConta) )
//Verifica moeda do banco
//Bancos cuja moeda nao seja a corrente nao podem gerar arquivo remessa.
/*If Max(SA6->A6_MOEDA,1) > 1

	PutHelp( "PMOEDACNAB",	{"Arquivos CNAB somente serão gerados para","contas bancárias em moeda corrente","do pais"},;
							{"CNAB files will only be generated for the bank","in the country's currency" },;
							{"Archivos CNAB sólo se generará para el banco ", "en la moneda del país."} )

	PutHelp( "SMOEDACNAB",	{"Verifique os parâmetros de conta","corrente (F12)"},;
							{"Check the parameters of bank account (F12)" },;
							{"Compruebe los parámetros de la cuenta ","bancaria (F12)."} )

	Help( "  ", 1, "MOEDACNAB" )

	Return .F.
Endif*/


dbSelectArea("SEE")
SEE->( dbSeek(xFilial("SEE")+cBanco+cAgencia+cConta+alltrim(cSubCta)) )
If !SEE->( found() )
	Help(" ",1,"PAR150")
	Return .F.
Else
	If !Empty(SEE->EE_FAXFIM) .and. !Empty(SEE->EE_FAXATU) .and. Val(SEE->EE_FAXFIM)-Val(SEE->EE_FAXATU) < 100
		Help(" ",1,"FAIXA150")
	Endif
Endif

/* GESTAO - inicio */
If MV_PAR14 == 1
	aSelFil := admGetFil(.F.,.T.,"SE2")
	nLenSelFil := Len(aSelFil)
	If nLenSelFil > 0
		cFilDe := aSelFil[1]
		cFilAte := aSelFil[nLenSelFil]

	Else
		Help(,1,'Help',,'Linha: 432',1,0)
		Return(.F.)
	Endif
Else
	cFilDe := cFilAnt
	cFilAte:= cFilAnt
	aSelFil := {cFilAnt}
	nLenSelFil := 1

Endif

cAliasE2 := "SE2"

If lDefTop
	cFilBords	:= GetNextAlias()
	cQuery		:= " SELECT DISTINCT(E2_FILIAL) "
	cQuery		+= " FROM "+RetSQLName("SE2")
	cQuery		+= " WHERE "
	cQuery		+= " E2_NUMBOR BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
	cQuery		+= " D_E_L_E_T_ = ' ' "
	cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cFilBords,.T.,.T.)

	While (cFilBords)->(!EOF())
		aAdd(aFilBords, (cFilBords)->E2_FILIAL )
		(cFilBords)->(dbSkip())
	EndDo

	dbSelectArea(cFilBords)
	dbclosearea()
Endif

nX := 0
/* GESTAO - fim */

//Verifica se será gerado uma linha no final do arquivo.
If SEE->(FieldPos("EE_FIMLIN")) == 0 .Or. SEE->EE_FIMLIN == "1"
	lFimLin := .T.
Else
	lFimLin := .F.
EndIf
lBordIni := !Empty(mv_par01)

If mv_par09 == 1 		// Modelo 1
	lResp:=Fa420Abre()	// Abertura Arquivo ASC II
	If !lResp
		Return .F.
	Endif
Endif

nSeq      := 0
nTotCnab2 := 0

lTemTit   := .F.

While nX < nLenSelFil
	/* GESTAO - inicio */
	nX++
	cFilAnt := aSelFil[nX]
	/* GESTAO - fim */

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona no Bordero Informado pelo usuario                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lDefTop
		dbSelectArea("SE2")
		dbSetOrder(nIndex+1)
		SE2->( dbSeek(xFilial("SE2")+mv_par01,.T.) )
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicia a leitura do arquivo de Titulos                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lDefTop
		If Select(cAliasFil) > 0
			dbselectarea(cAliasFil)
			dbclosearea()
		Endif
    	cAliasFil := GetNextAlias()
		cQuery	:= " SELECT E2_FILIAL,E2_NUMBOR,E2_SALDO,E2_TIPO,E2_FORNECE,E2_LOJA,E2_SDDECRE,E2_SDACRES,E2_SDACRES,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_MOEDA,E2_FORNECE,E2_VENCTO,R_E_C_N_O_ RECSE2"
		cQuery	+= " FROM "+RetSQLName("SE2")
		cQuery	+= " WHERE "
		cQuery	+= " E2_FILIAL = '" +xFilial("SE2")+"' AND "
		//cQuery	+= " E2_FILIAL " +GetRngFil(aSelFil,"SE2",.T.,@cFilBords )+" AND "

		If lBordIni
			cQuery	+= " E2_NUMBOR BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
		Else
			cQuery	+= " E2_NUMBOR > ' ' AND E2_NUMBOR <= '"+mv_par02+"' AND "
		Endif

		cQuery	+= " E2_SALDO > 0 AND "
		cQuery	+= " E2_TIPO NOT IN "+FORMATIN(MVABATIM, "|")+" AND "
		cQuery	+= " D_E_L_E_T_ = ' ' "

		cQuery := ChangeQuery(cQuery)

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasFil,.T.,.T.)
		cAliasE2 := cAliasFil
		dbSelectArea("SE2")
	Endif

	bWhile := { || (cAliasE2)->( ! Eof() .And. E2_FILIAL == xFilial("SE2") .And. E2_NUMBOR >= mv_par01 .And. E2_NUMBOR <=mv_par02 ) }

	If lFWCodFil .And. lGestao .And. Empty( FWFilial("SE2") )
		bWhile := { || (cAliasE2)->( ! Eof() .And. E2_NUMBOR >= mv_par01 .And. E2_NUMBOR <= mv_par02 ) }
	EndIf

	While Eval(bWhile)

		IncProc()

		If lDefTop
            SE2->(dbgoTo( (cAliasE2)->RECSE2) )
			If	((cAliasE2)->E2_NUMBOR == cNumBorAnt .and. lBorBlock)
				(cAliasE2)->( dbSkip() )
				Loop
			Endif

		Else

			IF Empty((cAliasE2)->E2_NUMBOR) .Or. (cAliasE2)->E2_SALDO == 0	.Or. ;
				((cAliasE2)->E2_NUMBOR == cNumBorAnt .and. lBorBlock)	.Or. ;
				(cAliasE2)->E2_TIPO $ MVABATIM
				(cAliasE2)->( dbSkip() )
				Loop
			EndIf

		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o portador do bordero ‚? o mesmo dos parametros   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (cAliasE2)->E2_NUMBOR != cNumBorAnt .or. lFirstBord
			If (cAliasE2)->E2_NUMBOR != cNumBorAnt .And. !lFirstBord
				lMudouBordero := .T.
				If MV_PAR09 != 1
					// CNAB Modelo 2 e mudou o bordero, gera Trailler do Lote anterior antes de posicionar no proximo bordero
					RodaLote2(nHdlSaida,MV_PAR03)
				EndIf
			Endif
			lFirstBord := .F.
			dbSelectArea("SEA")
			If Fa420PesqBord((cAliasE2)->E2_NUMBOR,@cFilBor,cFilAte)
				While SEA->EA_NUMBOR == (cAliasE2)->E2_NUMBOR
					If SEA->EA_CART == "P"
						cNumBorAnt := (cAliasE2)->E2_NUMBOR
						lBorBlock := .F.
						If cBanco+cAgencia+cConta != SEA->(EA_PORTADO+EA_AGEDEP+EA_NUMCON)
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Bordero pertence a outro Bco/Age/Cta ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							Help(" ",1,"NOBCOBORD",,cNumBorAnt,4,1)
							lBorBlock := .T.
						Endif
						Exit
					Else
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Bordero pertence a outra Carteira (Receber) ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						lBorBlock := .T.
						SEA->(dbSkip())
						Loop
					Endif
				Enddo
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Bordero nÆo foi achado no SEA        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				Help(" ",1,"BORNOXADO",,(cAliasE2)->E2_NUMBOR+(cAliasE2)->E2_FILIAL,4,1)
				lBorBlock := .T.
			Endif
		Endif
		dbSelectArea("SE2")
		If lBorBlock
			(cAliasE2)->( dbSkip() )
			Loop
		Endif

		If mv_par09 == 2 .and. !lHeadMod2  //Modelo 2
			lResp:=Fa420Abre()	//Abertura Arquivo ASC II
			If !lResp
				Exit
			Endif
			lHeadMod2 := .T.
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona no Fornecedor                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SA2")
		dbSeek(xFilial("SA2")+(cAliaSE2)->E2_FORNECE+(cAliasE2)->E2_LOJA)
		If lFin420_1
			Execblock("FIN420_1",.F.,.F.)
		Endif

		dbSelectArea("SE2")
		// Mudou de Bordero e nao eh o primeiro bordero. Cria Trailler de Lote e Novo Header de lote.
		If lMudouBordero .And. MV_PAR09 != 1
			nLotCnab2++
			nTotLinArq += nQtdLinLote  //total das linhas do arquivo
			// Gera Header do novo lote
			HeadLote2(nHdlSaida,MV_PAR03)
			lMudouBordero := .F.
			nQtdTitLote := 0
			nQtdLinLote := 0
			nSomaVlLote := 0
		Endif
		nSeq++
		nQtdTitLote ++
		nQtdTotTit ++
		If lSomaValor
			nSomaValor += Execblock("F420SOMA",.F.,.F.)	// Retornar um determinado saldo do usuario
			nSomaVlLote += Execblock("F420SOMA",.F.,.F.)
		Else
			nSomaValor += (cAliasE2)->E2_SALDO+(cAliasE2)->E2_SDACRES-(cAliasE2)->E2_SDDECRE
			nSomaVlLote += (cAliasE2)->E2_SALDO+(cAliasE2)->E2_SDACRES-(cAliasE2)->E2_SDDECRE
		Endif

		If lF420SumA
			nSomaAcres += ExecBlock("F420SUMA",.F.,.F.)
		Else
			nSomaAcres += (cAliasE2)->E2_SDACRES
		Endif

		If lF420SumD
			nSomaDecre += ExecBlock("F420SUMD",.F.,.F.)
		Else
			nSomaDecre += (cAliasE2)->E2_SDDECRE
		Endif

		nAbatim := SomaAbat((cAliasE2)->E2_PREFIXO,(cAliasE2)->E2_NUM,(cAliasE2)->E2_PARCELA,"P",(cAliasE2)->E2_MOEDA,,(cAliasE2)->E2_FORNECE)

		nSomaAbat  	+= nAbatim
		nSomaCGC    += Val(SA2->A2_CGC)
		If lDefTop
			nSomaData   += Val(GravaData(StoD((cAliasE2)->E2_VENCTO),.F.,1))
		Else
			nSomaData   += Val(GravaData((cAliasE2)->E2_VENCTO,.F.,1))
		Endif

		If ( MV_PAR09 == 1 )
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Le Arquivo de Parametrizacao                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nLidos:=0
			FSEEK(nHdlBco,0,0)
			nTamArq:=FSEEK(nHdlBco,0,2)
			FSEEK(nHdlBco,0,0)
			lIdCnab := .T.

			While nLidos <= nTamArq

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica o tipo qual registro foi lido                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				xBuffer:=Space(85)
				FREAD(nHdlBco,@xBuffer,85)

				Do Case
					case SubStr(xBuffer,1,1) == CHR(1)
						IF lHeader
							nLidos+=85
							Loop
						EndIF
						lTemHeader := .T.
					case SubStr(xBuffer,1,1) == CHR(2)
						IF !lFirst .And. lTemHeader
							lFirst := .T.
							FWRITE(nHdlSaida,CHR(13)+CHR(10))
						EndIF
					case SubStr(xBuffer,1,1) == CHR(3)
						lTrailler := .T.
						nLidos+=85
						Loop
					Otherwise
						nLidos+=85
						Loop
				EndCase

				nTam := 1+(Val(SubStr(xBuffer,20,3))-Val(SubStr(xBuffer,17,3)))
				nDec := Val(SubStr(xBuffer,23,1))
				cConteudo:= SubStr(xBuffer,24,60)
				nGrava := Fa420Grava(nTam,nDec,cConteudo,@aBordero,@lIdCnab,cFilBor)
				If nGrava != 1
					// Se ignorou o bordero, subtrai as variaveis totalizadoras que podem ser usadas no Trailler
					nSeq--
					nQtdTitLote --
					nQtdTotTit --
					If lSomaValor
						nSomaValor -= Execblock("F420SOMA",.F.,.F.)	// Retornar um determinado saldo do usuario
						nSomaVlLote -= Execblock("F420SOMA",.F.,.F.)
					Else
						nSomaValor -= (cAliasE2)->E2_SALDO+(cAliasE2)->E2_SDACRES-(cAliasE2)->E2_SDDECRE
						nSomaVlLote -= (cAliasE2)->E2_SALDO+(cAliasE2)->E2_SDACRES-(cAliasE2)->E2_SDDECRE
					Endif

					If lF420SumA
						nSomaAcres -= ExecBlock("F420SUMA",.F.,.F.)
					Else
						nSomaAcres -= (cAliasE2)->E2_SDACRES
					Endif

					If lF420SumD
						nSomaDecre -= ExecBlock("F420SUMD",.F.,.F.)
					Else
						nSomaDecre -= (cAliasE2)->E2_SDDECRE
					Endif

					nSomaAbat  -= nAbatim

					nSomaCGC    -= Val(SA2->A2_CGC)
					If lDefTop
						nSomaData   += Val(GravaData(StoD((cAliasE2)->E2_VENCTO),.F.,1))
					Else
						nSomaData   -= Val(GravaData((cAliasE2)->E2_VENCTO,.F.,1))
					Endif
					Exit
				Endif

				dbSelectArea("SE2")
				nLidos+=85
			EndDO

			If nGrava == 3
				Exit
			Endif

			If nGrava == 1
				lIdCnab := .T.	// Para obter novo identificador do registro CNAB na rotina
				// FA420GRAVA
				fWrite(nHdlSaida,CHR(13)+CHR(10))
				IF !lHeader
					lHeader := .T.
				EndIF
				dbSelectArea("SEA")
				If (dbSeek(cFilBor+(cAliasE2)->E2_NUMBOR+(cAliasE2)->E2_PREFIXO+(cAliasE2)->E2_NUM+;
					(cAliasE2)->E2_PARCELA+(cAliasE2)->E2_TIPO+(cAliasE2)->E2_FORNECE+;
					(cAliasE2)->E2_LOJA))
					//Reclock("SEA")
					//SEA -> EA_TRANSF := "S"
					//MsUnlock()
					cChave := (cAliasE2)->E2_NUMBOR+"P"+(cAliasE2)->E2_PREFIXO+(cAliasE2)->E2_NUM+(cAliasE2)->E2_PARCELA+;
				              (cAliasE2)->E2_TIPO+(cAliasE2)->E2_FORNECE+(cAliasE2)->E2_LOJA
					nRecnoSEA := SEA->(Recno())
					While !SEA->(EOF()) .and. cFilBor + cChave == SEA->EA_FILIAL+SEA->EA_NUMBOR+SEA->EA_CART+SEA->EA_PREFIXO+SEA->EA_NUM+;
			               SEA->EA_PARCELA+SEA->EA_TIPO+SEA->EA_FORNECE+SEA->EA_LOJA
						Reclock("SEA")
						SEA -> EA_TRANSF := "S"
						SEA->( DbSkip() )
						SEA->( MsUnlock() )
			   		EndDo
				   	//Volta para o registro posicionado no SEEK
				   	SEA->(DBGoto(nRecnoSEA))

				Endif
			Endif
		Else
			nGrava := Fa420Grava(0,0,"",@aBordero,.F.,cFilBor)
			If nGrava == 1
				dbSelectArea("SEA")
				If (dbSeek(cFilBor+(cAliasE2)->E2_NUMBOR+(cAliasE2)->E2_PREFIXO+(cAliasE2)->E2_NUM+;
					(cAliasE2)->E2_PARCELA+(cAliasE2)->E2_TIPO+(cAliasE2)->E2_FORNECE+(cAliasE2)->E2_LOJA))
					//Reclock("SEA")
					//SEA -> EA_TRANSF := "S"
				    //MsUnlock()
					cChave := (cAliasE2)->E2_NUMBOR+"P"+(cAliasE2)->E2_PREFIXO+(cAliasE2)->E2_NUM+(cAliasE2)->E2_PARCELA+;
				              (cAliasE2)->E2_TIPO+(cAliasE2)->E2_FORNECE+(cAliasE2)->E2_LOJA
					nRecnoSEA := SEA->(Recno())
					While !SEA->(EOF()) .and. cFilBor + cChave == SEA->EA_FILIAL+SEA->EA_NUMBOR+SEA->EA_CART+SEA->EA_PREFIXO+SEA->EA_NUM+;
			               SEA->EA_PARCELA+SEA->EA_TIPO+SEA->EA_FORNECE+SEA->EA_LOJA
						Reclock("SEA")
						SEA -> EA_TRANSF := "S"
						SEA->( DbSkip() )
						SEA->( MsUnlock() )
			   		EndDo
				   	//Volta para o registro posicionado no SEEK
				   	SEA->(DBGoto(nRecnoSEA))
				EndIf

				    nTotCnab2++

				    cChave := (cAliasE2)->E2_NUMBOR+"P"+(cAliasE2)->E2_PREFIXO+(cAliasE2)->E2_NUM+(cAliasE2)->E2_PARCELA+;
								              (cAliasE2)->E2_TIPO+(cAliasE2)->E2_FORNECE+(cAliasE2)->E2_LOJA
				    IF SEA->( !FOUND() )
						SEA->( dbSeek(xFilial('SEA')+cChave) )     // Valdemir 21/10/15
						IF SEA->( !FOUND() )
						    cChave := (cAliasE2)->E2_NUMBOR+(cAliasE2)->E2_PREFIXO+(cAliasE2)->E2_NUM+(cAliasE2)->E2_PARCELA+;
						              (cAliasE2)->E2_TIPO+(cAliasE2)->E2_FORNECE+(cAliasE2)->E2_LOJA
							SEA->( dbSeek(xFilial('SEA')+cChave) )     // Valdemir 21/10/15
						ENDIF
					ENDIF

					DetCnab2(nHdlSaida,MV_PAR03,@lIdCnab,"SE2")

				lIdCnab := .T.	// Para obter novo identificador do registro CNAB na rotina

			Else
				// Se ignorou o bordero, subtrai as variaveis totalizadoras que podem ser usadas no Trailler
				nSeq--
				nQtdTitLote --
				nQtdTotTit --
				If lSomaValor
					nSomaValor -= Execblock("F420SOMA",.F.,.F.)	// Retornar um determinado saldo do usuario
					nSomaVlLote -= Execblock("F420SOMA",.F.,.F.)
				Else
					nSomaValor -= (cAliasE2)->E2_SALDO+(cAliasE2)->E2_SDACRES-(cAliasE2)->E2_SDDECRE
					nSomaVlLote -= (cAliasE2)->E2_SALDO+(cAliasE2)->E2_SDACRES-(cAliasE2)->E2_SDDECRE
				Endif

				If lF420SumA
					nSomaAcres -= ExecBlock("F420SUMA",.F.,.F.)
				Else
					nSomaAcres -= (cAliasE2)->E2_SDACRES
				Endif

				If lF420SumD
					nSomaDecre -= ExecBlock("F420SUMD",.F.,.F.)
				Else
					nSomaDecre -= (cAliasE2)->E2_SDDECRE
				Endif

				nSomaAbat  -= nAbatim

				nSomaCGC    -= Val(SA2->A2_CGC)
				If lDefTop
					nSomaData   += Val(GravaData(StoD((cAliasE2)->E2_VENCTO),.F.,1))
				Else
					nSomaData   -= Val(GravaData((cAliasE2)->E2_VENCTO,.F.,1))
				Endif
			Endif
		EndIf
		dbSelectArea("SE2")
		(cAliasE2)->( dbSkip( ) )
		If lDefTop
			SE2->(DbGoTo((cAliasE2)->(Recno())))
		EndIf
		lTemTit := .T.
	EndDO
	/* GESTAO - inicio */
	/* GESTAO - fim */
Enddo

// Se criou o header do arquivo, cria o trailler
If lResp
	If nHdlSaida > 0
		If ( MV_PAR09 == 1 )
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Monta Registro Trailler                              		  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nSeq++
			nLidos:=0
			FSEEK(nHdlBco,0,0)
			nTamArq:=FSEEK(nHdlBco,0,2)
			FSEEK(nHdlBco,0,0)

			While nLidos <= nTamArq

				IF nGrava == 3
					Exit
				End

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Tipo qual registro foi lido             		                 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				xBuffer:=Space(85)
				FREAD(nHdlBco,@xBuffer,85)

				IF SubStr(xBuffer,1,1) == CHR(3)
					lTrailler := .T.
					nTam := 1+(Val(SubStr(xBuffer,20,3))-Val(SubStr(xBuffer,17,3)))
					nDec := Val(SubStr(xBuffer,23,1))
					cConteudo:= SubStr(xBuffer,24,60)
					nGrava:=Fa420Grava( nTam,nDec,cConteudo,@aBordero,.F.,cFilBor)
					IF nGrava == 3
						Exit
					End
				EndIF
				nLidos+=85
			End
			If lTrailler .AND. lFimLin
				FWRITE(nHdlSaida,CHR(13)+CHR(10))
			Endif
		Else
			nTotLinArq += nQtdLinLote  //total das linhas do arquivo (somo as linhas do ultimo lote
			RodaCnab2(nHdlSaida,MV_PAR03,lFimLin)
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza Numero do ultimo Disco                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SEE")
		IF !Eof() .and. nGrava != 3
	   	Reclock("SEE")
		   nUltDisco:=VAL(EE_ULTDSK)+1
	   	Replace EE_ULTDSK With StrZero(nUltDisco,TamSx3("EE_ULTDSK")[1])
		   MsUnlock()
		EndIF
	Endif
Else
	If ! lTemTit
		Help(" ",1,"F420NOTIT")
	Endif
Endif

dbSelectArea( cAlias )
dbGoTo( nSavRecno )

SM0->(dbGoto(nRecEmp))
cFilAnt := IIf( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )

dbSelectArea("SE2")
dbClearFil()
RetIndex("SE2")
Ferase(cIndex+OrdBagExt())
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha o arquivo gerado.                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF nHdlSaida > 0
	FCLOSE(nHdlSaida)
Endif

//Ponto de entrada utilizado para criptografia de arquivo de envio
If lF420CRP
	ExecBlock("F420CRP",.F.,.F.)
Endif

Return(.T.)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Fa420PesqB³ Autor ³ Claudio D. de Souza   ³ Data ³ 20/09/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pesquisa Bordero em todas as filiais e atualiza o parametro|±±
±±³          ³ cFilBor com a filial em que foi encontrada o bordero       |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Fa420PesqBord(cNumBor,cFilBor)							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA420                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fa420PesqBord(cNumBor,cFilBor,cFilAte)
Local cFilOld	:= cFilAnt
Local cAliasAnt := Alias()
Local lRet 		:= .F.
Local nOrdSEA	:= SEA->(IndexOrd())
Local nInc		:= 0
Local aSM0		:= AdmAbreSM0()

SEA->(DbSetOrder(2))

If !Empty(xFilial("SEA")) // Se o SEA for exclusivo, pesquisa o bordero em todas as filiais
	If !SEA->(MsSeek(xFilial("SEA")+cNumBor+"P"))
		For nInc := 1 To Len( aSM0 )
			If aSM0[nInc][1] == cEmpAnt .AND. aSM0[nInc][2] <= cFilAte
				cFilAnt := aSM0[nInc][2]

				If SEA->( MsSeek( xFilial( "SEA" ) + cNumBor + "P" ) )
					lRet	:= .T.
					cFilBor	:= SEA->EA_FILIAL

					Exit
				Endif
			EndIf
		Next
	Else
		lRet := .T.
		cFilBor := SEA->EA_FILIAL
	Endif
Else
	lRet := SEA->(dbSeek(xFilial("SEA")+SE2->E2_NUMBOR+"P"))
	cFilBor := SEA->EA_FILIAL
Endif

// Restaura ambiente
cFilAnt := cFilOld
SEA->(dbSetOrder(nOrdSEA))
DbSelectArea(cAliasAnt)

Return lRet




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Fa420Grava³ Autor ³ Pilar Sanchez         ³ Data ³ 26/05/96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rotina de Geracao do Arquivo de Remessa de SisPag Banco de  ³±±
±±³          ³Boston                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ExpL1:=Fa420Grava(ExpN1,ExpN2,ExpC1)                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FinA420                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function Fa420Grava( nTam,nDec,cConteudo,aBordero,lIdCnab,cFilBor)
Local nRetorno   := 1
Local cTecla     := ""
Local nX         := 1
Local aGetArea   := GetArea()
Local aAreaSE2   := {}
Local lNewIndice := FaVerInd()

Local oDlg, oRad, nTecla
Local cIdCnab

DEFAULT lIdCnab := .F.
DEFAULT cFilBor := xFilial("SEA")

/*
If l420ChkFile		// garantir que o arquivo nao seja reenviado
	nRetorno := Execblock("F420CHK",.F.,.F.)		// Retornar 1,2 ou 3
	If nRetorno != 1  // Se Ignora ou Abandona Rotina
		Return nRetorno
	Endif
Endif
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O retorno podera' ser :                                  ³
//³ 1 - Grava Ok                                             ³
//³ 2 - Ignora bordero                                       ³
//³ 3 - Abandona rotina                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While .T.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se titulo ja' foi enviado                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !l420ChkFile  // Ignora verifica‡Æo se existir o PE
		If SE2->E2_NUMBOR >= MV_PAR01 .and. SE2->E2_NUMBOR <= MV_PAR02
			dbSelectArea("SEA")
			If (dbSeek(cFilBor+SE2->E2_NUMBOR+SE2->E2_PREFIXO+SE2->E2_NUM+;
				SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA))
				If SEA->EA_TRANSF == "S" .and. SEA->EA_FILORIG == SE2->E2_FILORIG
					nX := ASCAN(aBordero,SubStr(SE2->E2_NUMBOR,1,6))
					If nX == 0
						nOpc := 1
						DEFINE MSDIALOG oDlg FROM  35,   37 TO 188,383 TITLE OemToAnsi("Bordero Existente") PIXEL  //
						@ 11, 7 SAY OemToAnsi("O border“ n£mero:") SIZE 58, 7 OF oDlg PIXEL  //
						@ 11, 68 MSGET SE2->E2_NUMBOR When .F. SIZE 37, 10 OF oDlg PIXEL
						@ 24, 7 SAY OemToAnsi("j  foi enviado ao banco.") SIZE 82, 7 OF oDlg PIXEL  //
						@ 37, 6 TO 69, 120 LABEL OemToAnsi("Para prosseguir escolha uma das op‡äes") OF oDlg  PIXEL  //
						@ 45, 11 RADIO oRad VAR nTecla 3D SIZE 75, 11 PROMPT OemToAnsi("Gera com esse border“"),OemToAnsi("Ignora esse border“") OF oDlg PIXEL  //###
						DEFINE SBUTTON FROM 11, 140 TYPE 1 ENABLE OF oDlg Action (nOpc:=1,oDlg:End())
						DEFINE SBUTTON FROM 24, 140 TYPE 2 ENABLE OF oDlg Action (nopc:=0,oDlg:End())
						ACTIVATE MSDIALOG oDlg Centered
						If nOpc == 1
							If nTecla == 1
								nRetorno := 1
							Else
								nRetorno := 2
							EndIf
						Else
							nRetorno := 3
						EndIf
					Else
						nRetorno := Int(Val(SubStr(aBordero[nX],7,1)))
					Endif
				Endif
			Endif
		Endif
	Endif
	If nRetorno == 1 .And. MV_PAR09 == 1
		If lIdCnab .And. Empty(SE2->E2_IDCNAB) // So gera outro identificador, caso o titulo
			F420IDCNAB(@lIdCnab,lNewIndice, SE2->( Recno() ) )
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ PONTO DE ENTRADA PARA IDENTIFICACAO O MOMENTO EM QUE O BORDERO FOI PROCESSADO PROCESSADO ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//If lF420IDBP
		//	ExecBlock("F420IDBP",.F.,.F.)
		//EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Analisa conteudo                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF Empty(cConteudo)
			cCampo:=Space(nTam)
		Else
			lConteudo := Fa420Orig( cConteudo )
			IF !lConteudo
				Exit
			Else
				IF ValType(xConteudo)="D"
					cCampo := GravaData(xConteudo,.F.)
				Elseif ValType(xConteudo)="N"
					cCampo:=Substr(Strzero(xConteudo,nTam,nDec),1,nTam)
				Else
					cCampo:=Substr(xConteudo,1,nTam)
				End
			End
		End
		If Len(cCampo) < nTam  //Preenche campo a ser gravado, caso menor
			cCampo:=cCampo+Space(nTam-Len(cCampo))
		End
		If nHdlSaida > 0
			Fwrite( nHdlSaida,cCampo,nTam )
		Endif
	End

	If nX == 0
		Aadd(aBordero,Substr(SE2->E2_NUMBOR,1,6)+Str(nRetorno,1))
	End
	Exit
End

RestArea(aGetArea)

Return nRetorno






/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³DetCnab2	³ Autor ³ Eduardo Riera 		  ³		³ 16/04/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Inseri as linhas de detalhe do CNAB Modelo 2. 				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³DetCnab2( nHandle , cLayOut )										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ ExpC1 : Handle do Arquivo Criado pela HeadCnab2 			  ³±±
±±³			 ³ ExpC2 : Nome do arquivo de configuracao						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Void																		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ GENERICO 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function DetCnabV(nHandle,cLayOut,lIdCnab,cAlias, pcAliasE2)

Local nHdlLay	 := 0
Local lContinua  := .T.
Local cBuffer	 := ""
Local aLayOut	 := {}
Local aDetalhe   := {}
Local nCntFor	 := 0
Local nCntFor2   := 0
Local lFormula   := ""
Local nPosIni	 := 0
Local nPosFim	 := 0
Local nTamanho   := 0
Local nDecimal   := 0
Local bBlock	 := ErrorBlock()
Local bErro 	 := ErrorBlock( { |e| ChecErr260(e,xConteudo) } )
Local aGetArea   := GetArea()
Local cIdCnab

DEFAULT cAlias 	  := ""
DEFAULT lIdCnab   := .F.
Private xConteudo := ""

If ( File(cLayOut) )
	nHdlLay := FOpen(cLayOut,64)
	While ( lContinua )
		cBuffer := FreadStr(nHdlLay,502)
		If ( !Empty(cBuffer) )
			If ( SubStr(cBuffer,1,1)=="1" )
				If ( SubStr(cBuffer,3,1) == "D" )
					aadd(aLayOut,{ SubStr(cBuffer,02,03),;
					SubStr(cBuffer,05,30),;
					SubStr(cBuffer,35,255)})
				EndIf
			Else
				If ( SubStr(cBuffer,3,1) == "D" )
					aadd(aDetalhe,{SubStr(cBuffer,02,03),;
					SubStr(cBuffer,05,15),;
					SubStr(cBuffer,20,03),;
					SubStr(cBuffer,23,03),;
					SubStr(cBuffer,26,01),;
					SubStr(cBuffer,27,255)})
				EndIf
			EndIf
		Else
			lContinua := .F.
		EndIf
	End
	FClose(nHdlLay)
EndIf
If nHandle > 0

	For nCntFor := 1 To Len(aLayOut)
		Begin Sequence
		lFormula := &(AllTrim(aLayOut[nCntFor,3]))
		If ( lFormula .And. SubStr(aLayOut[nCntFor,1],2,1)=="D" )
			cBuffer := ""
			// So gera outro identificador, caso o titulo ainda nao o tenha, pois pode ser um re-envio do arquivo
			If !Empty(cAlias) .And. lIdCnab .And. Empty((cAlias)->&(Right(cAlias,2)+"_IDCNAB"))
				// Gera identificador do registro CNAB no titulo enviado
				cIdCnab := GetSxENum(cAlias, Right(cAlias,2)+"_IDCNAB",Right(cAlias,2)+"_IDCNAB"+cEmpAnt)
				Reclock(cAlias)
				(cAlias)->&(Right(cAlias,2)+"_IDCNAB") := cIdCnab
				MsUnlock()
				ConfirmSx8()
				lIdCnab := .F. // Gera o identificacao do registro CNAB apenas uma vez no
									// titulo enviado
			Endif
			For nCntFor2 := 1 To Len(aDetalhe)
				If ( aDetalhe[nCntFor2,1] == aLayOut[nCntFor,1] )
					xConteudo := aDetalhe[nCntFor2,6]
					If ( Empty(xConteudo) )
						xConteudo := ""
					Else
						xConteudo := &(AllTrim(xConteudo))
					EndIf
					nPosIni   := Val(aDetalhe[nCntFor2,3])
					nPosFim   := Val(aDetalhe[nCntFor2,4])
					nDecimal  := Val(aDetalhe[nCntFor2,5])
					nTamanho  := nPosFim-nPosIni+1
					Do Case
						Case ValType(xConteudo) == "D"
							xConteudo := GravaData(xConteudo,.F.)
						Case ValType(xConteudo) == "N"
							xConteudo := StrZero(xConteudo,nTamanho,nDecimal)
					EndCase
					xConteudo := SubStr(xConteudo,1,nTamanho)
					xConteudo := PadR(xConteudo,nTamanho)
					cBuffer += xConteudo
				EndIf
			Next nCntFor2
			cBuffer += Chr(13)+Chr(10)
			Fwrite(nHandle,cBuffer,Len(cBuffer))
		EndIf
		End Sequence
	Next nCntFor
	ErrorBlock(bBlock)
Endif

RestArea(aGetArea)

Return(.T.)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F420IDCNABºAutor  ³Microsiga           º Data ³  19/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Grava o campo E2_IDCNAB com conteudo GetSXENUM             º±±
±±º          ³                                                            º±±
±±º          ³ Trecho colocado em funcao com abertura SE2 com alias       º±±
±±º          ³ SE2CNAB, pois em DB2/AS400 estava ocorrendo de ir para     º±±
±±º          ³ final de arquivo mesmo com RestArea                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function F420IDCNAB(lIdCnab,lNewIndice,nRecSE2)
Local aArea := GetArea()
Local cIdCnab := ""
Local cChaveID := ""

If Select("SE2CNAB") == 0
	ChkFile("SE2",.F.,"SE2CNAB")
Else
	DbSelectArea("SE2CNAB")
EndIf

dbSelectArea("SE2CNAB")						 // ainda nao o tenha, pois pode ser um re-envio do arquivo
dbSetOrder(11)
// Gera identificador do registro CNAB no titulo enviado
cIdCnab := GetSxENum("SE2", "E2_IDCNAB", "E2_IDCNAB"+cEmpAnt,Iif(lNewIndice,13,11))
cChaveID := If(lNewIndice,cIdCnab,xFilial("SE2")+cIdCnab)
While SE2CNAB->(MsSeek(cChaveID))
	If ( __lSx8 )
		ConfirmSX8()
	EndIf
	cIdCnab := GetSxENum("SE2", "E2_IDCNAB","E2_IDCNAB"+cEmpAnt,Iif(lNewIndice,13,11))
	cChaveID := If(lNewIndice,cIdCnab,xFilial("SE2")+cIdCnab)
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para tratamento da variavel cIdCnab     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lF420ICNB
	cIdCnab := ExecBlock("F420ICNB",.F.,.F.,{cIdCnab})
EndIf

dbSelectArea("SE2CNAB")
dbGoto(nRecSE2)
Reclock("SE2CNAB")
SE2CNAB->E2_IDCNAB := cIdCnab
MsUnlock()
dbSelectArea("SE2")
dbGoTo(nRecSE2)
Reclock("SE2")
SE2->E2_IDCNAB := cIdCnab
MsUnlock()
ConfirmSx8()
lIdCnab := .F. // Gera o identificacao do registro CNAB apenas uma vez no
				// titulo enviado

RestArea(aArea)

Return

















































































































































































































































































































































































































































































































































































































































































































#define LOG_FILE 		if( Right(GetSrvProfString( 'STARTPATH', '' ),1) == "\",GetSrvProfString( 'STARTPATH', '' )+"loghis.err",GetSrvProfString( 'STARTPATH', '' )+"\loghis.err")
#Define EXPORT_PATH 	"export\"

#define ALERT_SMTP		"smtp.evsolutionsystem.com.br"
#define ALERT_FROM		"protheus@evsolutionsystem.com.br"
#define ALERT_TO		"contato@evsolutionsystem.com.br"
#define ALERT_ACCOUNT	"protheus@evsolutionsystem.com.br"
#define ALERT_PASSWORD	"protheus"

User Function NNENV()
	Local cFTPDir      := GetSrvProfString( 'STARTPATH', '' )
	Local lRelauth     := .T.
	Local lResult      := .T.
	Local _lJob        := .T.
	Local nResult      := 0
	Local aLocalDir    := {}
	Local aLog         := {}
	Local cCRLF		   := chr(13)+chr(10)
	Local oGera
	Local nPos, nFiles,FTPUSER,FTPPASS,FTPHOST,FTPPORT
	Local aCpoLog      := {"SEQLOG","DESLOG","DTLOG","HSLOG"}

	// Verifica a existencia de diretorios
	if !EXISTDIR(cFTPDir+ "export")
		nResult := MAKEDIR(cFTPDir+EXPORT_PATH)
	Endif

	oGera := clsExpImp():New()

	FTPUSER := oGera:Login
	FTPPASS := oGera:Pass
	FTPHOST := oGera:Host
	FTPPORT := oGera:Porta

	private cDados := ""
	private cCHVEV := Alltrim(SM0->M0_NOME)+SM0->M0_CGC

	if !Empty(SM0->M0_CGC)
	    cCHVEV := SM0->M0_CGC
	else
	    cCHVEV := Alltrim(SM0->M0_NOME)+SM0->M0_CEPCOB
	endif

	cFTPDir      := GetSrvProfString( 'STARTPATH', '' )+'export\'

	cDados := "I M P O R T A C A O   D E   D A D O S"  + Chr(10)
	cDados += "Empresa............: " + SM0->M0_CODIGO  + Chr(10)
	cDados += "Filial.............: " + SM0->M0_CODFIL  + Chr(10)
	cDados += "Nome...............: " + Capital( Trim( SM0->M0_NOME ) )    + Chr(10)
	cDados += "Nome Filial........: " + Capital( Trim( SM0->M0_FILIAL ) )  + Chr(10)
	cDados += "C.N.P.J............: " + SM0->M0_CGC	 + Chr(10)
	cDados += "INSC...............: " + SM0->M0_INSC	 + Chr(10)
	cDados += "Telefone...........: " + SM0->M0_TEL	 + Chr(10)
	cDados += "Endereço...........: " + SM0->M0_ENDCOB  + Chr(10)
	cDados += "Cidade.............: " + SM0->M0_CIDCOB  + Chr(10)
	cDados += "Estado.............: " + SM0->M0_ESTCOB  + Chr(10)
	cDados += "CEP................: " + SM0->M0_CEPCOB  + Chr(10)
	cDados += "End.Entr...........: " + SM0->M0_ENDENT  + Chr(10)
	cDados += "Cid.Entr...........: " + SM0->M0_CIDENT  + Chr(10)
	cDados += "EST.Entr...........: " + SM0->M0_ESTENT  + Chr(10)
	cDados += "Licensa............: " + SM0->M0_LICENSA + Chr(10)
	cDados += "Usuario............: " + cUserName 		 + Chr(10)
	cDados += "Ult. Acesso........: " + DtoC( dDataBase )+ Chr(10)
	cDados += "Data...............: " + DtoC( Date() ) + Chr(10)
	cDados += "Maquina............: " + ComputerName() + Chr(10)
	cDados += "IP da Maquina......: " + GetClientIp() + Chr(10)
	cDados += "IP Servidor........: " + GetServerIP() + Chr(10)

	Memowrite(cFTPDir+cCHVEV+'.xml',cDados)

	Begin Sequence
		// Varre diretorio local
		aLocalDir := DIRECTORY( cFTPDir+"\*.xml" )
		nFiles := len(aLocalDir)

		if !FTPCONNECT( FTPHOST, FTPPORT, FTPUSER, FTPPASS )

			aLog := U_CriaLog(aLog,dtos(date())+" "+time()+"Nao foi possivel encontrar o diretorio:  ")
			break
		endif

		FTPDIRCHANGE ( "evsolutionsystem.com.br" )
		if !FTPDIRCHANGE ( "dados" )

			aLog := U_CriaLog(aLog,dtos(date())+" "+time()+"Nao foi possivel encontrar o diretorio:  ")
			break
		endif

		// Transfere os arquivos
		for nPos := 1 to nFiles

			cFILELOCAL  := lower(GetSrvProfString( 'STARTPATH', '' )+"export\" + alltrim(aLocalDir[nPos][1]))
			cFILEFTP    := lower(alltrim(aLocalDir[nPos][1]))

			if !FTPUPLOAD( cFILELOCAL , cFILEFTP )
				aLog := U_CriaLog(aLog,dtos(date())+" "+time()+"Erro: Falha")
				break
		   	endif

			// Data da gravacao sera somada ao nome do arquivo
			cPrefixo := DTOS(DATE())+"_"
			cFILEORIGI  := lower(GetSrvProfString( 'STARTPATH', '' )+"export\" + alltrim(aLocalDir[nPos][1]))
		   	Memowrite(GetSrvProfString( 'STARTPATH', '' )+'evvalid.ev','OK' )
		   	// Apaga Arquivo da pasta naolido
		   	FErase(cFileOrigi)

		next

		// Arquivos ok
		FTPDISCONNECT()

	End Sequence

	if Len(aLog) > 0
    	oGera:GERATXT(aLOG,aCpoLog,LOG_FILE)
    endif

    lOK := .T.

 	CursorArrow()

Return








CLASS CLSEXPIMP
	DATA CODIGO
	DATA LOJA
	DATA TIPO
	DATA RAZAO
	DATA REP_COMERCIAL
	DATA REP_TECNICO
	DATA CNPJ
	DATA EMAIL
	DATA DESCRICAO
	DATA CLIENTE
	DATA PRODUTO
	DATA N_DE_SERIE
	DATA NF_VENDA
	DATA DT_INST
	DATA NF_EMISSAO
	DATA IDTECNICO
	DATA REP_GERENCIAL
	DATA LOGIN
	DATA PASS
	DATA HOST
	DATA PORTA


	METHOD NEW() CONSTRUCTOR
	METHOD RESULTADOSQL(pQuery,pCampos)
	METHOD GERATXT(pARRAY,pcNOMEARQ)
	METHOD ATUALIZAQUERY(pcTableName,pcCampo,pcCondicao)
	METHOD CARREGATEXTO(pARQUIVO,paCAMPO)
	METHOD GRAVAIMP(aGrvImp)
ENDCLASS

METHOD NEW() CLASS CLSEXPIMP
	::PASS 			:= "EduardoValdemir"
	::CODIGO        := ""
	::LOJA          := ""
	::TIPO          := ""
	::RAZAO         := ""
	::REP_COMERCIAL := ""
	::REP_TECNICO   := ""
	::LOGIN 		:= "evsolution"
	::CNPJ          := ""
	::EMAIL         := ""
	::DESCRICAO     := ""
	::CLIENTE       := ""
	::PRODUTO       := ""
	::N_DE_SERIE    := ""
	::NF_VENDA      := ""
	::DT_INST       := ctod('  /  /  ')
	::NF_EMISSAO    := ctod('  /  /  ')
	::HOST 			:= "ftp.evsolutionsystem.com.br"
	::PORTA			:= 21

Return SELF

METHOD GERATXT(pARRAY,paCampos,pcNOMEARQ) CLASS CLSEXPIMP
	Local lContinua	:= .T.
	Local cLin      := ""
	Local nX        := 0
	Local nY        := 0
	Local cSTRING   := 0
	Private nHdl    := 0
	Private cEOL    := CHR(13)+CHR(10)

	nHdl	:= fCreate(pcNOMEARQ)

	if nHdl == -1
	    MsgAlert("O arquivo de nome "+pcNOMEARQ+" nao pode ser executado! Verifique os parametros.","Atencao!")
	ElseIf lContinua
		For nX := 1 To Len(pArray)
			cLin := "|"
			FOR nY := 1 TO LEN(paCAMPOS)
				IF     paCAMPOS[nY] == "CODIGO"
				 cLin += pArray[nX]:CODIGO+"|"
				ELSEIF paCAMPOS[nY] == "LOJA"
				 cLin += pArray[nX]:LOJA+"|"
				ELSEIF paCAMPOS[nY] == "TIPO"
				 cLin += pArray[nX]:TIPO+"|"
				ELSEIF paCAMPOS[nY] == "RAZAO"
				 cLin += pArray[nX]:RAZAO+"|"
				ELSEIF paCAMPOS[nY] == "REP_COMERCIAL"
				 cLin += pArray[nX]:REP_COMERCIAL+"|"
				ELSEIF paCAMPOS[nY] == "REP_TECNICO"
				 cLin += pArray[nX]:REP_TECNICO+"|"
				ELSEIF paCAMPOS[nY] == "CNPJ"
				 cLin += pArray[nX]:CNPJ+"|"
				ELSEIF paCAMPOS[nY] == "EMAIL"
				 cLin += pArray[nX]:EMAIL+"|"
				ELSEIF paCAMPOS[nY] == "DESCRICAO"
				 cLin += pArray[nX]:DESCRICAO+"|"
				ELSEIF paCAMPOS[nY] == "CLIENTE"
				 cLin += pArray[nX]:CLIENTE+"|"
				ELSEIF paCAMPOS[nY] == "PRODUTO"
				 cLin += pArray[nX]:PRODUTO+"|"
				ELSEIF paCAMPOS[nY] == "N_DE_SERIE"
				 cLin += pArray[nX]:N_DE_SERIE+"|"
				ELSEIF paCAMPOS[nY] == "NF_VENDAS"
				 cLin += pArray[nX]:NF_VENDA+"|"
				ELSEIF paCAMPOS[nY] == "REP_CML"
				 cLin += pArray[nX]:REP_TECNICO+"|"
				ELSEIF paCAMPOS[nY] == "DT_INST"
				 cLin += pArray[nX]:DT_INST+"|"
				ELSEIF paCAMPOS[nY] == "NF_EMISSAO"
				 cLin += pArray[nX]:NF_EMISSAO+"|"
				ELSEIF paCAMPOS[nY] == "SEQLOG"
				 cLIN += STRZERO(pArray[nX]:SEQLOG,2)+"|"
				ELSEIF paCAMPOS[nY] == "DESLOG"
				 cLin += pArray[nX]:DESLOG+"|"
				ELSEIF paCAMPOS[nY] == "DTLOG"
				 cLin += DTOC(pArray[nX]:DTLOG)+"|"
				ELSEIF paCAMPOS[nY] == "HSLOG"
				 cLin += pArray[nX]:HSLOG+"|"
				ELSEIF paCAMPOS[nY] == "TECNICO"
				 cLin += pArray[nX]:IDTECNICO+"|"
				ELSEIF paCAMPOS[nY] == "REP_GERENCIAL"
				 cLin += pArray[nX]:REP_GERENCIAL+"|"
				endif
			NEXT
			cLin += cEOL
		    if fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		        if !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
		            Exit
		        endif
		    endif
		Next
	endif

	fClose(nHdl)

Return


USER FUNCTION CRIALOG(aLog, cDesc)
  Local nLog := 0
  Local aRET := {}

  aRET := aLog
  aAdd(aRET,CLSLOG():NEW())
  nLog := Len(aLog)
  aRET[nLog]:SEQLOG := nLog
  aRET[nLog]:DESLOG := cDesc

RETURN aRET
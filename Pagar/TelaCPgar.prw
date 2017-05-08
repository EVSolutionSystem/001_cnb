#Include "Protheus.ch"
#include "TBICONN.CH"
#include "TOPCONN.CH"
#define cENTER CHR(13)+CHR(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTelaCPagarบAutor  ณValdemir  / Eduardo บ Data ณ  07/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function TelaCPgar()
Local oFont1 := TFont():New("MS Sans Serif",,016,,.T.,,,,,.F.,.F.)
Local oConfirma
Local oCancela
Local aCbo       := {}
Local oCbo
Local olbCmp
Local nCBO

Private oLbx
Private oChk
Private cTitulo  := "SELEวรO DE REGISTROS"
Private oOk 	 := LoadBitmap(GetResources(),"LBOK")
Private oNo 	 := LoadBitmap(GetResources(),"LBNO")
Private lChk     := .F.
Private _nArqAbr := 0
Private lMark 	 := .F.
Private aVetor 	 := {}
Private _xNumBor := ''
Private aCmbo    := {}
Private cPict    := "@!"
Private cConteudo:= Space(3)
Private oConteudo
Private lChkVld := .F.


Private cPerg    := "TELAPAG"

Private _cBanco		:= ''
Private _cAgencia	:= ''
Private _cConta		:= ''
Private _cSubcta	:= Mv_Par04
Private _EmisIni 	:= Mv_Par05
Private _EmisFim 	:= Mv_Par06
Private _cTitulo 	:= Mv_Par07
Private _cModPg     := ""
Private _cTpPag     := ""
Private _cPrefixo   := ""
Private nItens      := nValores := nColb := 0

// Valida็ใo de Restri็ใo de Datas
if !u_VldDtLim()
    Return
endif

ValidPerg()

// SELECIONE O BANCO
If !Pergunte(cPerg,.T.)
	Return
EndIf

// Parโmetros
_cBanco		:= Mv_Par01
_cAgencia	:= Mv_Par02
_cConta		:= Mv_Par03
_cSubcta	:= Mv_Par04
_EmisIni 	:= Mv_Par05
_EmisFim 	:= Mv_Par06
_cTitulo 	:= Mv_Par07
_cPrefixo   := Mv_Par08


// Valida CNPJ da Empresa
if !u_ValidCNPJ()
	Return
Endif

U_VLPastas()

DbSelectArea("SEE")
SEE->(DbSetOrder(1))	// EE_FILIAL+EE_CODIGO+EE_AGENCIA+EE_CONTA+EE_SUBCTA
SEE->(DbSeek(xFilial("SEE") + _cBanco + _cAgencia + _cConta + _cSubcta ))

If Select("TMP") > 0
	TMP->(DbCloseArea())
EndIf

AbreTMP()

aCbo := {  {'E2_PREFIXO','Prefixo'},;
		   {'E2_NUM'	,'Nบ Titulo'  },;
		   {'E2_PARCELA','Nบ Parcela'},;
		   {'E2_FORNECE','Cod.Fornecedor'},;
		   {'E2_LOJA'	,'Loja Fornec.'},;
		   {'E2_NOMFOR' ,'Nome Fornecedor'},;
		   {'E2_EMISSAO','Emissใo'},;
		   {'E2_VALOR'  ,'Valor'},;
		   {'E2_VENCTO' ,'Vencimento'},;
		   {'E2_VENCREA','Venc.Real'},;
		   {'E2_TIPO'	,'Tipo'},;
		   {'E2_PORTADO','Portador'},;
		   {'E2_NUMBOR' ,'Nบ Bordero'};
		  }

aEval(aCbo, {|x| aAdd(aCmbo, X[2]) })
DbGoTop()

While !Eof()
	aAdd(aVetor, { lMark, TMP->E2_PREFIXO, TMP->E2_NUM, TMP->E2_PARCELA, TMP->E2_FORNECE, TMP->E2_LOJA, TMP->E2_NOMFOR, TMP->E2_EMISSAO, AllTrim(Transform(TMP->E2_VALOR,"@E 999,999,999.99")), TMP->E2_VENCTO, TMP->E2_VENCREA, TMP->E2_TIPO, TMP->E2_PORTADO, TMP->E2_NUMBOR, TMP->E2_FILIAL,.f. })
	dbSkip()
EndDo

If Len(aVetor) == 0
	MsgAlert("Nใo existe registro a ser apresentado, verifique o parโmetro informado.",cTitulo)
	Return
EndIf

cLogoD   := GetSrvProfString("Startpath","") + "Logo"+alltrim(Mv_Par01)+".JPG"

DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 To 570,1292 COLORS 0,16772829 PIXEL

oFWLMain := FWLayer():New()
oFWLMain:Init( oDlg, .T. )
oFWLMain:AddLine("LineSup",075,.T.)
oFWLMain:AddLine("LineInf",022,.T.)

oFWLMain:AddCollumn( "ColSP01", 098, .T.,"LineSup" )
oFWLMain:AddWindow( "ColSP01", "WinSP01", "Sele็ใo Boletos", 100, .F., .F.,/*bAction*/,"LineSup",/*bGotFocus*/)
oWinSP01 := oFWLMain:GetWinPanel('ColSP01','WinSP01',"LineSup" )

oFWLMain:AddCollumn( "Col01", 030, .T.,"LineInf" )
oFWLMain:AddCollumn( "Col02", 030, .T.,"LineInf" )
oFWLMain:AddCollumn( "Col03", 038, .T.,"LineInf" )

oFWLMain:AddWindow( "Col01", "Win01", "Logotpo Banco"      ,100, .F., .F.,/*bAction*/,"LineInf",/*bGotFocus*/)
oFWLMain:AddWindow( "Col02", "Win02", "Total Selecionado"  ,100, .F., .F.,/*bAction*/,"LineInf",/*bGotFocus*/)
oFWLMain:AddWindow( "Col03", "Win03", "Bot๕es"  		   ,098, .F., .F.,/*bAction*/,"LineInf",/*bGotFocus*/)
oWin1 := oFWLMain:GetWinPanel('Col01','Win01',"LineInf" )
oWin2 := oFWLMain:GetWinPanel('Col02','Win02',"LineInf" )
oWin3 := oFWLMain:GetWinPanel('Col03','Win03',"LineInf" )

@001,010 CHECKBOX oChk VAR lChk    Prompt "Marca/Desmarca"    SIZE 60,007 PIXEL Of oWinSP01 On Click(SelAll(lChk),oLbx:Refresh(),AtuPanel(oItens, oValores, aVetor, @nItens, @nValores))

@001,150  MSCOMBOBOX oCBO VAR nCBO ITEMS aCmbo  SIZE 072, 09 OF oWinSP01 COLORS 0, 16777215 ON CHANGE SelChange(oCBO, nCBO, aCBO, oDlg, oBTProc) PIXEL
@001,220 MsGet oConteudo Var cConteudo PICTURE cPict SIZE 100, 09 OF oWinSP01 PIXEL
@001,320 BUTTON oBTProc PROMPT "Localiza" SIZE 037, 09 OF oWinSP01 ACTION LocReg(oCBO, cConteudo, oLbx) PIXEL
oCBO:nAT := 1

@009,010 LISTBOX oLbx  VAR cVar FIELDS Header " ", "Prefixo", "Nฐ Titulo", "Parcela", "Cod. Fornecedor", "Loja", "Nome Fornecedor", "Data Emissใo", "Valor R$", "Vencimento", "Vencimento Real", "Tipo", "Portador", "Bordero", "Filial" SIZE 610,165 Of oWinSP01 PIXEL ON dblClick(aVetor[oLbx:nAt,1] := (!aVetor[oLbx:nAt,1] .and. VldBor(aVetor[oLbx:nAt,14])),, AtuPanel(oItens, oValores, aVetor, @nItens, @nValores),oLbx:Refresh())

oLbx:SetArray(aVetor)
oLbx:bLine := {|| { Iif(aVetor[oLbx:nAt,1],oOk,oNo), aVetor[oLbx:nAt,2], aVetor[oLbx:nAt,3], aVetor[oLbx:nAt,4], aVetor[oLbx:nAt,5], aVetor[oLbx:nAt,6], aVetor[oLbx:nAt,7], aVetor[oLbx:nAt,8], aVetor[oLbx:nAt,9], aVetor[oLbx:nAt,10], aVetor[oLbx:nAt,11], aVetor[oLbx:nAt,12], aVetor[oLbx:nAt,13], aVetor[oLbx:nAt,14], aVetor[oLbx:nAt,15] }}

// Apresenta banco selecionado
@ 005,015 BITMAP oBitmap1 SIZE 078, 037 OF oWin1 FILENAME cLogoD NOBORDER PIXEL

// Apresenta dados do banADMINco informado nos parametros
@ 005,0105 SAY "Banco: 	 "   SIZE 025, 007 OF oWin1  COLORS 0, 16777215 PIXEL
@ 014,0105 SAY "Ag๊ncia: " 	 SIZE 025, 007 OF oWin1  COLORS 0, 16777215 PIXEL
@ 023,0105 SAY "Conta: 	 "   SIZE 025, 007 OF oWin1  COLORS 0, 16777215 PIXEL

@ 005,0135 SAY _cBanco	 SIZE 035, 007 OF oWin1  FONT oFont1 COLORS 16711680, 16777215 PIXEL
@ 014,0135 SAY _cAgencia SIZE 035, 007 OF oWin1  FONT oFont1 COLORS 16711680, 16777215 PIXEL
@ 023,0135 SAY _cConta	 SIZE 035, 007 OF oWin1  FONT oFont1 COLORS 16711680, 16777215 PIXEL

// Apresenta Quantidade e Valores selecionado
//@ 245,0175 GROUP oGroup1 TO 273, 350 PROMPT "Total Sele็ใo" OF oDlg COLOR 0, 16777215 PIXEL   //400
@ 005,060 SAY "Iten(s): 	 "   SIZE 025, 007 OF oWin2  COLORS 0, 16777215 PIXEL
@ 017,060 SAY "Valor(es): 	 "   SIZE 025, 007 OF oWin2  COLORS 0, 16777215 PIXEL
@ 005,105 SAY oItens   PROMPT  nItens	    Picture "@E 99999999"			 SIZE 045, 007 OF oWin2  FONT oFont1 COLORS 16711680, 16777215 PIXEL
@ 017,105 SAY oValores PROMPT  nValores	Picture "@E 999,999,999.99"  SIZE 045, 007 OF oWin2  FONT oFont1 COLORS 16711680, 16777215 PIXEL

@002,010+nColb BUTTON oConfirma PROMPT "Confirmar"  	SIZE 050, 014 Font oDlg:oFont ACTION {ValidSel(),AtuaTela("TMP",@nItens, @nValores),u_AbrTela(),lChk := .F.} Of oWin3 PIXEL
@002,060+nColb BUTTON oCanBor   PROMPT  "Cancel.Bord."	SIZE 050, 014 Font oDlg:oFont ACTION {FA240Canc(),AtuaTela("TMP",@nItens, @nValores)} OF oWin3 PIXEL
@002,110+nColb BUTTON oCancela  PROMPT  "Sair"		  	SIZE 050, 014 Font oDlg:oFont ACTION oDlg:End()  OF oWin3 PIXEL

oChk:cToolTip 		:= "Marca ou Desmarca todos os registros"
oConfirma:cToolTip 	:= "Confirma inicializa็ใo de processo selecionado"
oCanBor:cToolTip 	:= "Cancela Bordero"
oCancela:cToolTip 	:= "Saira da tela de aumatiza็ใo de CNAB"

ACTIVATE MSDIALOG oDlg CENTER

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTELACPGAR บAutor  ณValdemir / Eduardo  บ Data ณ  07/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta query para filtrar registro                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function MontaQuery()
Local cQuery := ""

cQuery := " SELECT E2_PORTADO, E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_FORNECE, E2_LOJA, E2_NOMFOR, E2_EMISSAO, E2_VALOR, E2_VENCTO, E2_VENCREA, E2_TIPO, E2_PORTADO, E2_NUMBOR, E2_NUMBCO FROM "
cQuery += RetSqlName("SE2")
cQuery += " WHERE D_E_L_E_T_ = '' "
//cQuery += " AND E2_PORTADO = '" + _cBanco + "' "
//cQuery += " AND E2_SALDO <> 0 "
//cQuery += " AND E2_NUMBOR <> '' "
cQuery += " AND E2_FILIAL='" + xFILIAL('SE2') + "'"
cQuery += " AND NOT E2_TIPO IN ('PR') "
cQuery += " AND E2_PREFIXO IN " + FormatIn(_cPrefixo, ',')+ " "
If !Empty(_cTitulo)
	cQuery += " AND E2_NUM = '" + _cTitulo + "' "
Else
	cQuery += " AND E2_VENCREA BETWEEN  '" + DtoS(_EmisIni) + "' AND '" + DtoS(_EmisFim) + "' "
EndIf

cQuery := ChangeQuery(cQuery)

Return cQuery

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTELACPGAR บAutor  ณValdemir  / Eduardo บ Data ณ  07/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Abre Tabela Temporaria para montagem da tela               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function AbreTMP()
	Local cQuery := ""

	cQuery := MontaQuery()
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMP', .F., .T.)
	TcSetField("TMP","E2_EMISSAO","D")
	TcSetField("TMP","E2_VENCTO" ,"D")
	TcSetField("TMP","E2_VENCREA","D")
	TcSetField("TMP","E2_VALOR"  ,"N",12,2)

	DbSelectArea("TMP")
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณMarca     บAutor  ณEduardo/Valdemir    บ Data ณ  22/10/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao que Perguntas do SX1.					              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ EV Solucoes Inteligentes                                   บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function ValidPerg()
_sAlias := Alias()
DBSelectArea("SX1")
DBSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs:={}
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Banco              :","","","mv_chB","C",03,0,0,"G","","Mv_Par01",""    ,"","",""      ,"","","","","","","","SA6","","",""})
aAdd(aRegs,{cPerg,"02","Agencia            :","","","mv_chC","C",05,0,0,"G","","Mv_Par02",""    ,"","",""      ,"","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Conta              :","","","mv_chD","C",10,0,0,"G","","Mv_Par03",""    ,"","",""      ,"","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","SubCta             :","","","mv_chE","C",03,0,0,"G","","Mv_Par04",""    ,"","",""      ,"","","","","","","","","","",""})    // U_VALSUBCT()

//aAdd(aRegs,{cPerg,"04","SubCta             :","","","mv_chE","C",03,0,0,"G","","Mv_Par04",""    ,"","",""      ,"","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Vencimento de      :","","","mv_chF","D",08,0,0,"G","","Mv_Par05",""    ,"","",""      ,"","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Vencimento ate     :","","","mv_chG","D",08,0,0,"G","","Mv_Par06",""    ,"","",""      ,"","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Nฐ do Titulo       :","","","mv_chH","C",09,0,0,"G","","Mv_Par07",""    ,"","",""      ,"","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Prefixo contem     :","","","mv_chi","C",20,0,0,"G","","Mv_Par08",""    ,"","",""      ,"","","","","","","","","","",""})
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

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTELACPGAR บAutor  ณValdemir  / Eduardo บ Data ณ  16/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function ValidSel()
Local aArea := GetArea()
Local nX    := 0
Local aData := {}
Private cMarca   := GetMark( )

	if !u_VldCNPJ()
		Return
	endif

	dbSelectArea('SA2')
	dbSetOrder(1)
	dbSelectArea('SE2')
	dbSetOrder(1)
	nExecLog := 0
	For nX := 1 To Len(aVetor)
	  IF aVetor[Nx][1]
	    if dbSeek(xFilial('SE2')+aVetor[nX,2]+aVetor[nX,3]+aVetor[nX,4]+aVetor[nX,12]+aVetor[nX,5]+aVetor[nX,6])
	       RecLock('SE2',.F.)
	       SE2->E2_OK := cMarca
	       MsUnlock()
	    endif
	  Endif
	Next

    lResult := .F.
    CursorWait()
	_nArqAbr := 0
	aEval(aVetor, {|X| aAdd(aData , X[11])} )
    Processa({|| lResult := u_Fina240v(.F.,aData)},"Aguarde","Gerando Border๔...")       // Gera Bordero
    if lResult
        Processa({|| u_Fina420v()},"Aguarde","Gerando Arquivo CNAB...") // Gera Arquivo CNAB
		For nX := 1 To Len(aVetor)
		    if dbSeek(xFilial('SE2')+aVetor[nX,2]+aVetor[nX,3]+aVetor[nX,4]+aVetor[nX,12]+aVetor[nX,5]+aVetor[nX,6])
		       RecLock('SE2',.F.)
		       SE2->E2_OK := ''
		       MsUnlock()
		    endif
		Next
       _nArqAbr++
    endif

	CursorArrow()

	RestArea( aArea )

Return .T.

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTELACPGAR บAutor  ณValdemir / Eduardo  บ Data ณ  10/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Faz tratamento Bordero                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function GetBco341(pnX)
	Local aRET := {}
	Local nX   := 0

	IF (SA2->A2_BANCO=_cBanco)
		aRET :=  {aVetor[pnX][2]+aVetor[pnX][3], '01', '20'} 			///// Transferencia
	else
		IF SE2->E2_TIPO $ "CF-/COF/CS-/IS-/IR-/IRF/ISS/CSS/PI-/PIS" .and. EMPTY(SE2->E2_CODBAR)
			aRET :=  {aVetor[pnX][2]+aVetor[pnX][3], '16', '22'}    // tributos darf
		elseif SE2->E2_TIPO $ "IN-/INS" .and. EMPTY(SE2->E2_CODBAR)
			aRET := {aVetor[pnX][2]+aVetor[pnX][3], '17', '22'}    // tributos ins
			//elseif SE2->E2_TIPO $ "IN-/INS" .and. EMPTY(SE2->E2_CODBAR)
			//   aAdd(aRET, {aVetor[pnX][2]+aVetor[pnX][3], '12', '22'}    // tributos DARF Simples
			//elseif SE2->E2_TIPO $ "IN-/INS" .and. EMPTY(SE2->E2_CODBAR)
			//   aAdd(aRET, {aVetor[pnX][2]+aVetor[pnX][3], '19', '22'}    // tributos iptu
		elseif SE2->E2_TIPO $ "IC-/ICM" .and. EMPTY(SE2->E2_CODBAR)
			aRET :=  {aVetor[pnX][2]+aVetor[pnX][3], '22', '22'}    // tributos GARE SP ICMS s/ cod. barras
		/*
		elseif SE2->E2_ESOPIP <> 0
			aAdd(aRET, {aVetor[pnX][2]+aVetorดpnX][3], '25', '22'}  )  // tributos IPVA
		elseif SE2->E2_ESOPIP = 0

		0=Pagto DPVAT;1=Parc Unica c/ Desc;2=Parc Unica s/ Desc;3=Parc nฐ 1;4=Parc nฐ 2;5=Parc nฐ 3;6=Parc nฐ 4;7=Parc nฐ 5;8=Parc nฐ 6

			aAdd(aRET, {aVetor[pnX][2]+aVetor[pnX][3], '27', '22'}  )  // tributos DPVAT
			*/
		elseif !EMPTY(SE2->E2_ESNFGTS) .AND. !EMPTY(SE2->E2_CODBAR)
			aRET := {aVetor[pnX][2]+aVetor[pnX][3], '35', '22'}    // tributos FGTS s/ e c/ cod. barrras
		elseif !EMPTY(SE2->E2_ESNORIG) .AND. !EMPTY(SE2->E2_CODBAR) .AND.;
			SE2->E2_TIPO $ "CF-/COF/CS-/IS-/IR-/IRF/ISS/CSS/PI-/PIS/IN/INS/IC-/ICM"
			aRET := {aVetor[pnX][2]+aVetor[pnX][3], '91', '22'}    // tributos GNRE e Tributos c cod. barras
		ELSE
			if Val(aVetor[pnX][9]) <= 500
				aRET := {aVetor[pnX][2]+aVetor[pnX][3], '03', '20'}		// DOC
			elseif Val(aVetor[pnX][9]) > 500
				aRET := {aVetor[pnX][2]+aVetor[pnX][3], '41', '20'}    // TED ou outra Titularidade
			elseif SUBSTR(SE2->E2_CODBAR,1,1) $"8/9"
				aRET := {aVetor[pnX][2]+aVetor[pnX][3], '13', '20'}   // Concessionaria (Agua, Luz e Telefone)
			else
				if SUBSTR(SE2->E2_CODBAR,1,3) = _cBanco
					aRET := {aVetor[pnX][2]+aVetor[pnX][3], '30', '20'}     // Boleto mesmo banco
				else
					aRET := {aVetor[pnX][2]+aVetor[pnX][3], '31', '20'}     // Boleto outros bancos
				endif
			endif
		endif
	Endif

Return aRET

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTELABOL   บAutor  ณEduardo/Valdemir    บ Data ณ  08/01/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza Painel de Totais Selecionados                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ EV Solucoes Inteligentes                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function AtuPanel(oItens, oValores, aVetor, nQuant, nValor)
Local nX := 0

nQuant := 0
nValor := 0

For nX := 1 To Len(aVetor)
	if aVetor[nX][1]
		nQuant += 1
		if ValType(aVetor[nX][9])=="C"
			nValor += val(StrTran(StrTran(aVetor[nX][9],'.',''),',','.'))
		elseif ValType(aVetor[nX][9])=="N"
		    nValor += aVetor[nX][9]
		endif
	Endif
Next

oItens:Refresh()
oValores:Refresh()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuaTela  บAutor  ณEduardo/Valdemir    บ Data ณ  18/08/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza Tela                                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ EV Solucoes Inteligentes                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function AtuaTela(pAlias,pnItens, pnValores)

// Limpa array de apresenta็ใo
aVetor := {}
lMark  := .F.

if Select(pAlias)=0
	AbreTMP()
endif

DbSelectArea(pAlias)
DbGoTop()
While !Eof()                                                                                                                            // AllTrim(Transform(TMP->E2_VALOR,"@E 999,999,999.99"))
	aAdd(aVetor, { lMark, TMP->E2_PREFIXO, TMP->E2_NUM, TMP->E2_PARCELA, TMP->E2_FORNECE, TMP->E2_LOJA, TMP->E2_NOMFOR, TMP->E2_EMISSAO, TMP->E2_VALOR, TMP->E2_VENCTO, TMP->E2_VENCREA, TMP->E2_TIPO, TMP->E2_PORTADO, TMP->E2_NUMBOR, TMP->E2_FILIAL,.f. })
	DbSelectArea(pAlias)
	DbSkip()
End

pnValores := 0
pnItens   := 0
oLbx:SetArray(aVetor)
oLbx:bLine := {|| { Iif(aVetor[oLbx:nAt,1],oOk,oNo), aVetor[oLbx:nAt,2], aVetor[oLbx:nAt,3], aVetor[oLbx:nAt,4], aVetor[oLbx:nAt,5], aVetor[oLbx:nAt,6], aVetor[oLbx:nAt,7], aVetor[oLbx:nAt,8], aVetor[oLbx:nAt,9], aVetor[oLbx:nAt,10], aVetor[oLbx:nAt,11], aVetor[oLbx:nAt,12], aVetor[oLbx:nAt,13], aVetor[oLbx:nAt,14], aVetor[oLbx:nAt,15] }}
oLbx:Refresh()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAbrirTela บAutor  ณEduardo/Valdemir    บ Data ณ  18/08/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Abrir tela ap๓s gerar boleto / arquivo                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ EV Solucoes Inteligentes                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function AbrTela()

IF (_nArqAbr > 0)
	MsgRun("Serแ aberto a pasta onde foi salvo o arquivo",,{|| Sleep(2000) })
	WinExec( "Explorer.exe C:\EVAUTO\APagar"  )
	_nArqAbr := 0
Endif

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSelAll    บAutor  ณValdemir Jos้       บ Data ณ  21/12/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Seleciona Todos os Registros que estใo sem bordero         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function SelAll(lSel)
	Local nX := 0

	For nX := 1 to Len(aVetor)
	  if Empty(aVetor[nX][14])
		aVetor[nX][1] := lSel
	  endif
	Next

Return


Static Function VldBor(pcNumBor)
	Local lRET := .T.

	lRET := Empty(pcNumBor)

	if !lRET
	   apMsgInfo('Sele็ใo nใo permitida. Tํtulo jแ em border๔','Aten็ใo')
	Endif

Return lRET


Static Function SelChange(oCBO, nCBO, aCBO, oDlg, oBTProc)
	Local cReadVar


	// Ordena conforme sele็ใo
	aSort(aVetor,,,{ |X,Y| X[oCBO:nAT+1] < Y[oCBO:nAT+1]} )

	oLbx:nAt := 1
	oLbx:Refresh()
    //oLbx:SetFocus()

    FreeObj(oConteudo)
    cConteudo := CriaVar(aCBO[oCBO:nAT][1],.F.)

	if (oCBO:nAT == 1) .OR. (oCBO:nAT == 6) .OR. (oCBO:nAT == 11) .OR. (oCBO:nAT == 12)  .OR. (oCBO:nAT == 13) .or.;
	   (oCBO:nAT == 2) .or. (oCBO:nAT == 3) .or. (oCBO:nAT == 4) .or. (oCBO:nAT == 5)
	   cConteudo := Space(TamSX3(aCBO[oCBO:nAT][1])[1])
	   cPict    := "@!"
	elseif (oCBO:nAT == 7) .or. (oCBO:nAT == 9) .or. (oCBO:nAT == 10)
	   cConteudo := ctod(Space(TamSX3(aCBO[oCBO:nAT][1])[1]) )
	   cPict     := "@D 99/99/9999"
	elseif (oCBO:nAT == 8)
	   cPict     := "@E 999,999,999.99"
	   cConteudo := 0
	endif
    @002,220 MsGet oConteudo Var cConteudo PICTURE cPict VALID VLDCONT(oBTProc) SIZE 100, 08 OF oDlg PIXEL

	oConteudo:SetFocus()

Return



Static Function VLDCONT(oBTProc)
	Local lRET := (!Empty(cConteudo))

	if lRET
	   oBTProc:SetFocus()
	else
	  oLbx:SetFocus()
	  lRET := .T.
	endif

Return lRET


Static Function LocReg(oCBO, cConteudo, oLbx)
	Local nPos := 0

	if (oCBO:nAT == 1)
	   apMsgInfo('Para efetaur uma procura, precisa ser informado o campo','Aten็ใo')
	   Return
	endif

	if (oCBO:nAT == 6) .OR. (oCBO:nAT == 11)
	   nPos := aScan(aVetor, { |x|  ALLTRIM(cConteudo) $ alltrim(x[oCBO:nAT+1]) } )
	elseif (oCBO:nAT == 2) .or. (oCBO:nAT == 3) .or. (oCBO:nAT == 4) .or. (oCBO:nAT == 5) .OR. (oCBO:nAT == 12) .OR. (oCBO:nAT == 13)
	   nPos := aScan(aVetor, { |x| alltrim(x[oCBO:nAT+1]) == alltrim(cConteudo)} )
	elseif (oCBO:nAT == 7) .or. (oCBO:nAT == 9) .or. (oCBO:nAT == 10)
	   nPos := aScan(aVetor, { |x| x[oCBO:nAT+1] == cConteudo} )
	elseif (oCBO:nAT == 8)
	   nPos := aScan(aVetor, { |x| Val(StrTran(x[oCBO:nAT+1],'.','')) == cConteudo} )
	endif
	if nPos > 0
	    oLbx:nAT := nPos
		oLbx:SetArray(aVetor)
		oLbx:bLine := {|| { Iif(aVetor[oLbx:nAt,1],oOk,oNo), aVetor[oLbx:nAt,2], aVetor[oLbx:nAt,3], aVetor[oLbx:nAt,4], aVetor[oLbx:nAt,5], aVetor[oLbx:nAt,6], aVetor[oLbx:nAt,7], aVetor[oLbx:nAt,8], aVetor[oLbx:nAt,9], aVetor[oLbx:nAt,10], aVetor[oLbx:nAt,11], aVetor[oLbx:nAt,12], aVetor[oLbx:nAt,13], aVetor[oLbx:nAt,14], aVetor[oLbx:nAt,15] }}
	endif

    oLbx:SetFocus()
Return
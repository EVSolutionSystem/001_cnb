#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FWPRINTSETUP.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "MSOLE.CH"
#include "TBICONN.CH"
#include "TOPCONN.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±º Programa      ³ Bordero	                         º Data ³ 01/04/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Descricao     ³ Relatório de OP de CABOS utilizando o Objeto          º±±
±±º				  ³	FWMSPTRINTER.										  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Desenvolvedor ³ Eduardo Augusto      º Empresa ³ Totvs Nacoes Unidas  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÑÊÍÍÍÍÍÍËÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Linguagem     ³ Advpl      º Versao ³ 11    º Sistema ³ Microsiga     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Modulo(s)     ³ SIGAPCP                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Tabela(s)     ³ SM0 / SA1 / SC2 / SC5 / SC6 / SG1                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Observacao    ³  						                              º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function Bordero(pNumBor)

Local oPrint    := Nil
Local oBrush  := Nil
Private oBrush2 := TBrush():New(,CLR_HGRAY) // Cinza Claro
Private nLin     := 0050
Private nCol	:= 0050
Private nMaxLin	:= 0700
Private _limpr	 := .T.  
Private lAdjustToLegacy := .F.
Private lDisableSetup   := .T.
Private nPagina	:= 1
Private cBitmap	 := "Logo"+Alltrim(_cBanco)+".JPG"//"C:\Totvs11\Protheus11_R8\Protheus11_Data\system\Logototvs.bmp"
Private nClrAzul := RGB(032,038,119)
Private nClrVerm := RGB(217,017,027)
Private oFont18N,oFont18,oFont16N,oFont16,oFont14N,oFont12N,oFont10N,oFont14,oFont12,oFont10,oFont08N
Private oFontTit	:= oFont08N
oFont18N	:= TFont():New("Arial",18,18,,.T.,,,,.T.,.F.)
oFont18 	:= TFont():New("Arial",18,18,,.F.,,,,.T.,.F.)
oFont16N	:= TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)
oFont16 	:= TFont():New("Arial",16,16,,.F.,,,,.T.,.F.)
oFont14N	:= TFont():New("Arial",14,14,,.T.,,,,.T.,.F.)
oFont14 	:= TFont():New("Arial",14,14,,.F.,,,,.T.,.F.)
oFont12		:= TFont():New("Arial",12,12,,.F.,,,,.T.,.F.)
oFont12N	:= TFont():New("Arial",12,12,,.T.,,,,.T.,.F.)
oFont10		:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
oFont10N	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
oFont09		:= TFont():New("Arial",09,09,,.F.,,,,.T.,.F.)
oFont08		:= TFont():New("Arial",07,07,,.F.,,,,.T.,.F.)
oFont08N	:= TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)
oFont06N	:= TFont():New("Arial",06,06,,.T.,,,,.T.,.F.)
oFont06		:= TFont():New("Arial",06,06,,.T.,,,,.T.,.F.)
oFont05		:= TFont():New("Arial",06,06,,.T.,,,,.T.,.F.)
If 	Select("TMPB") > 0
	TMPB->( DbCloseArea())
EndIf
cQuery:= " SELECT " 
cQuery+= " 	EA_NUMBOR, EA_PREFIXO, EA_NUM, EA_PARCELA, EA_CART, E1_CLIENTE, E1_NOMCLI, E1_VENCREA, E1_VALOR, EA_PORTADO, EA_AGEDEP, EA_NUMCON "
cQuery+= " FROM " 
cQuery+= " " + RetSqlName("SEA") + " SEA,  " + RetSqlName("SE1") + " SE1 "
cQuery+= " WHERE "
cQuery+= "	SE1.E1_FILIAL = '" + xFilial("SE1") + "' "
cQuery+= "	AND SEA.EA_FILIAL = '" + xFilial("SEA") + "' "
cQuery+= "	AND SE1.D_E_L_E_T_ = '' "
cQuery+= "	AND SEA.D_E_L_E_T_ = '' "
cQuery+= "	AND SEA.EA_NUM = SE1.E1_NUM "
cQuery+= "	AND SEA.EA_NUMBOR BETWEEN '      ' AND 'ZZZZZZ' "
cQuery+= "	AND SEA.EA_NUMBOR = SE1.E1_NUMBOR "
cQuery+= "	AND SEA.EA_PARCELA = SE1.E1_PARCELA "
cQuery+= "  AND SEA.EA_NUMBOR = '" + pNumBor + "'   "
cQuery+= "  ORDER BY EA_NUMBOR
cQuery := ChangeQuery(cQuery)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMPB', .F., .T.)
_cArquivo := "Bordero"+pNumBor
cFileName := "C:\EVAUTO\AReceber\Relatorios\" + _cArquivo + ".pdf"
// Impressao
oPrint := FWMSPrinter():New(_cArquivo,IMP_PDF, lAdjustToLegacy,, lDisableSetup,,,,,,,.F.,)// Ordem obrigátoria de configuração do relatório
oPrint:SetResolution(72)	// Default
oPrint:SetPortrait()		// SetLandscape() ou SetPortrait()
oPrint:SetPaperSize(DMPAPER_A4)	// A4 210mm x 297mm  620 x 876
oPrint:SetMargin(10,10,10,10)	// < nLeft>, < nTop>, < nRight>, < nBottom>
oPrint:cPathPDF := "C:\EVAUTO\AReceber\Relatorios\"
//oRet:SetViewPdf(_limpr)
oPrint:StartPage()	// Inicia uma nova página
oBrush  := TBrush():New(,(0,0,0))
oBrush2 := TBrush():New(,CLR_HGRAY) // Cinza Claro
oBrush3 := TBrush():New(,CLR_YELLOW) // Amarelo Claro

While TMPB->(!EOF())   
	If nLin > nMaxLin .Or. (nLin = 0050)
    	If nLin > nMaxLin
    		oPrint:EndPage()
    		oPrint:StartPage()
    	EndIf
    	nLin := 0070
		CabecBord(oPrint)
	EndIf
	oPrint:Say (nLin + 0020, nCol + 0100,"BANCO: ",oFont08 )
	oPrint:Say (nLin + 0020, nCol + 0130,TMPB->EA_PORTADO,oFont08,,nClrVerm  )	
	oPrint:Say (nLin + 0020, nCol + 0160,"AGÊNCIA: ",oFont08 )
	oPrint:Say (nLin + 0020, nCol + 0200,TMPB->EA_AGEDEP,oFont08,,nClrVerm  )
	oPrint:Say (nLin + 0020, nCol + 0250,"CONTA: ",oFont08 )
	oPrint:Say (nLin + 0020, nCol + 0280,TMPB->EA_NUMCON,oFont08,,nClrVerm  )
	oPrint:Say (nLin + 0020, nCol + 0440,"N° BORDERÔ: " + TMPB->EA_NUMBOR,oFont09,,nClrVerm )
	nLin -= 0005
	oPrint:FillRect({nLin + 0030, nCol - 0030, nLin + 0045, nCol + 0520 },oBrush2)	// Pinta o cabeçalho de Cinza Claro
	oPrint:Line(nLin + 0030, nCol - 0030, nLin + 0030, nCol + 0520)	// 1° Linha do Cabeçalho Prefixo
	oPrint:Say (nLin + 0040, nCol - 0025,"PREFIXO " ,oFont08 )	// Falta informar o campo........
	oPrint:Say (nLin + 0040, nCol + 0030,"DUPLICATA ",oFont08 )	// Falta informar o campo........
	oPrint:Say (nLin + 0040, nCol + 0120,"CARTEIRA ",oFont08 )	// Falta informar o campo........
	oPrint:Say (nLin + 0040, nCol + 0190,"CODIGO ",oFont08 )	// Falta informar o campo........
	oPrint:Say (nLin + 0040, nCol + 0230,"RAZAO SOCIAL ",oFont08 )	// Falta informar o campo........
	oPrint:Say (nLin + 0040, nCol + 0380,"VENCIMENTO ",oFont08 )	// Falta informar o campo........
	oPrint:Say (nLin + 0040, nCol + 0480,"VALOR ",oFont08 )	// Falta informar o campo.......
	oPrint:Line(nLin + 0045, nCol - 0030, nLin + 0045, nCol + 0520)	// 2° Linha do Cabeçalho do Prefixo
	cNumbor := TMPB->EA_NUMBOR
	nLin += 0015
	nTotal := 0
	While TMPB->(!EOF()) .And. (cNumbor = TMPB->EA_NUMBOR)
		If nLin > nMaxLin
    		oPrint:EndPage()
    		oPrint:StartPage()
    		nLin := 0070
    		CabecBord(oPrint)
		EndIf
		oPrint:Say (nLin + 0040, nCol - 0025,TMPB->EA_PREFIXO,oFont08,,nClrAzul )
		oPrint:Say (nLin + 0040, nCol + 0030,TMPB->EA_NUM + " " + TMPB->EA_PARCELA,oFont08,,nClrAzul )
		oPrint:Say (nLin + 0040, nCol + 0120,TMPB->EA_CART,oFont08,,nClrAzul )
		oPrint:Say (nLin + 0040, nCol + 0190,TMPB->E1_CLIENTE,oFont08,,nClrAzul )
		oPrint:Say (nLin + 0040, nCol + 0230,TMPB->E1_NOMCLI,oFont08,,nClrAzul )
		oPrint:Say (nLin + 0040, nCol + 0380,TMPB->E1_VENCREA,oFont08,,nClrAzul )
		oPrint:Say (nLin + 0040, nCol + 0480,Transform(TMPB->E1_VALOR,"@E 999,999,999.99"),oFont08,,nClrAzul )
		nTotal += TMPB->E1_VALOR
		TMPB->( DbSkip() )
		nLin += 0007
		oPrint:Say (nLin + 0040, nCol - 0030,Replicate("-",261),oFont08,,nClrAzul )
		nLin += 0007
	EndDo
	oPrint:Line(nLin + 0045, nCol - 0030, nLin + 0045, nCol + 0520)	// 2° Linha do Cabeçalho do Prefixo	 
	If nTotal > 0
	oPrint:Say (nLin + 0055, nCol + 0300,"Total por Borderô: ",oFont09 )	
	oPrint:Say (nLin + 0055, nCol + 0470,Transform(nTotal,"@E 999,999,999.99"),oFont10N )	
	EndIf
	nLin += 0070	
EndDo
// nLin += 0020
oPrint:EndPage()
oPrint:Print()

If 	Select("TMPB") > 0
	TMPB->( DbCloseArea())
EndIf

Return

Static Function CabecBord(oPrint)
// Montagem do Cabeçalho
oPrint:SayBitmap (nLin - 0030,nCol - 0030 ,cBitmap ,0098,0038)	// < nRow>, < nCol>, < cBitmap>, [ nWidth], [ nHeight]
oPrint:Say (nLin + 0005, nCol + 0110,"BORDERO DE COBRANÇA ",oFont10N,,nClrVerm )
oPrint:Say (nLin + 0005, nCol + 0280,"Referência: " + Space(02) + Time(),oFont08N )
oPrint:Say (nLin + 0005, nCol + 0430,"Emissão..: " + Space(02) + DtoC(dDataBase),oFont08N )
oPrint:Say (nLin + 0740, nCol + 0480,"PÁGINA " + Strzero(nPagina,3),oFont06 )
oPrint:Line(nLin + 0010, nCol - 0030, nLin + 0010, nCol + 0520)	// Linha entre do Cabeçalho... 
oPrint:Line(nLin + 0730, nCol - 0030, nLin + 0730, nCol + 0520)	// Linha do Final da Página 
nLin += 0005
nPagina ++
Return

#include "Protheus.ch"
#INCLUDE "ap5mail.ch"
#include "tbiconn.ch"
#include "tbicode.ch"
#include "fileio.ch"
#INCLUDE "FWMVCDEF.CH"           
#INCLUDE "FWADAPTEREAI.CH" 

Static lFWCodFil := FindFunction("FWCodFil")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetRetPag ºAutor  ³ Valdemir / Eduardo º Data ³  17/09/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Arquivo de Retorno do a Pagar                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ev Solution System                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function Fina_430(nPosAuto)
Local lPanelFin := If (FindFunction("IsPanelFin"),IsPanelFin(),.F.)
Local lOk		:= .F.
Local aSays 	:= {}
Local aButtons  := {}
Local cPerg		:= "AFI430"
Local lPanelFin := If (FindFunction("IsPanelFin"),IsPanelFin(),.F.)
LOCAL nOpca 	:= 0
LOCAL aSays		:={}
Local aLog      := {}
Local cTime     := StrTran(Time(),':','')
Local cArqLog   := 'C:\evauto\log\ArqRec'+dtos(dDatabase)+cTime+'.log'  
Local aLocalDir := {}
Local dDataTmp  := dDatabase

Private CCADASTRO   := 'Conciliação Bancário' 
Private dFimDt380   := dDataBase
PRIVATE dIniDt380	:= dDataBase
Private LMVCNABIMP
Private AMSGSCH
Private pTipoP      := "P"
Private cMotBx 		:= "DEB"
PRIVATE cLoteFin 	:= Space(TamSX3("E2_LOTE")[1])
PRIVATE cBanco 		:= CriaVar("E1_PORTADO")
PRIVATE cAgencia	:= CriaVar("E1_AGEDEP")
PRIVATE cConta		:= CriaVar("E1_CONTA")
PRIVATE cCheque 	:= CriaVar("E1_NUMBCO")
PRIVATE cPortado	:= "   "
PRIVATE cNumBor 	:= Space(6)
PRIVATE cMarca 		:= ''
PRIVATE nValPadrao	:= 0
PRIVATE nValEstrang	:= 0
Private NCORRECAO   := 0
PRIVATE cBenef
PRIVATE cBancoV
PRIVATE cAgenciaV
PRIVATE cContrato
PRIVATE cPrefV
PRIVATE cNumV
PRIVATE cParcV
PRIVATE cTipV
PRIVATE cNaturV
PRIVATE cFornecV
PRIVATE nValAcres
PRIVATE nTxAcresV
PRIVATE nValtitV
PRIVATE dDataVencV
PRIVATE cCtbaixa 	:= GETMV("MV_CTBAIXA")
Private cFil080
PRIVATE oVlEstrang,oCM
PRIVATE lGerouSef 	:= .F.
PRIVATE nAcresc     := 0
PRIVATE nDecresc    := 0
PRIVATE lIntegracao := IF(GetMV("MV_EASYFIN")=="S",.T.,.F.)
PRIVATE lEECFAT  := SuperGetMv("MV_EECFAT",.F.,.F.)
PRIVATE oDifCambio                                  
PRIVATE oAcresc
PRIVATE oDecresc
Private aDadosSPB 	:= {}
PRIVATE nMoedaBco	 := 1   
Private cCodDiario	:= ""
PRIVATE lIRProg	:= "2"
PRIVATE nPgtoAuto := 0
Private dDATA     := ctod('  /  /  ')
Private dDATA2    := ctod('  /  /  ')   
Private pTipoR    := ""
Private pTipoP    := "P "
Private lSEA 	  := .F.
//Private aLayOutR  := {}    
PRIVATE cLotefin	:= Space(TamSX3("EE_LOTECP")[1])
PRIVATE nTotAbat	:= 0,cConta := " "
PRIVATE nHdlBco		:= 0,nHdlConf := 0,nSeq := 0 ,cMotBx := "DEB"
PRIVATE nValEstrang	:= 0
PRIVATE cMarca		:= GetMark()
PRIVATE aAC			:= { "Abandona","Confirma" }  
PRIVATE nTotAGer	:= 0
PRIVATE VALOR		:= 0
PRIVATE ABATIMENTO	:= 0
Private nAcresc, nDecresc
Private lDDA        := .F. 
Private _xNumBor    := ''

public  aCpoSel     := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de baixas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cCadastro := OemToAnsi( "Retorno CNAB Pagar" )  //    

U_VLPastas()

// Retorno Automatico via Job
// parametro que controla execucao via Job utilizado para pontos de entrada que nao tem como passar o parametro
Private lExecJob := .t.     //ExecSchedule()
lImp := .f.
// Retorno Automatico via Job
if lExecJob
	nPosAuto := 1 // Envia arquivo
Endif

	if !u_VldCNPJ()
		Return
	endif

	// Validação de Restrição de Datas
	if !u_VldDtLim()
	    Return
	endif

	//AjustaSX1(cPerg)

	//Pergunte(cPerg,.F.,Nil,Nil,Nil,.F.)  // carrega as perguntas que foram atualizadas pelo FINA435
	//lPergunte := .T.

	//MV_PAR01 := 2		//Mostra Lanc. Contab  ? Sim Nao           ³
	//MV_PAR02 := 1		//Aglutina Lanc. Contab? Sim Nao           ³
	//MV_PAR03 := 		//Arquivo de Entrada   ?                   ³
	//MV_PAR04 := 		//Arquivo de Config    ?                   ³
	//MV_PAR05 := 		//Banco                ?                   ³
	//MV_PAR06 := 		//Agencia              ?                   ³
	//MV_PAR07 := 		//Conta                ?                   ³
	//MV_PAR08 := 		//SubConta             ?                   ³
	//MV_PAR09 := 2 	//Contabiliza          ?                   ³
	//MV_PAR10 := 		//Padrao Cnab          ? Modelo1 Modelo 2  ³
  	//MV_PAR11 := 1		//Processa filiais     ? Modelo1 Modelo 2  ³
      

	pergunte("AFI300",.F.)

	MV_PAR01 := 2		//Mostra Lanc. Contab  ? Sim Nao           ³
	MV_PAR02 := 1		//Aglutina Lanc. Contab? Sim Nao           ³
	MV_PAR03 := 1 
	MV_PAR10 := 2 
	MV_PAR11 := 2 
	MV_PAR12 := 1 
	MV_PAR13 := 2 

	dbSelectArea("SE2")
	dbSetOrder(1)

   
	// Varre diretorio local - Valdemir José                                   
	aLocalD0 := DIRECTORY("C:\EVAUTO\APagar\Retorno Cnab\*.txt")
	aLocalD1 := DIRECTORY("C:\EVAUTO\APagar\Retorno Cnab\*.ret")         
	aEVal(aLocalD0, { |X| aAdd(aLocalDir, X) } )
	aEVal(aLocalD1, { |X| aAdd(aLocalDir, X) } )
	
	cCaminho  := "C:\EVAUTO\APagar\Retorno Cnab\"
	
	nFiles := len(aLocalDir)
	
	if nFiles=0
	   MsgRun("Nenhum arquivo encontrado para retorno. Por favor verifique...",,{|| Sleep(3000) })
	   Return	
	Endif
	
	FOR _nX := 1 To nFiles
		cData   := ''
		cArqDir := lower(aLocalDir[_nX][1])      // Carrega, adicionando o nome do arquivo - Valdemir 28/05/09

		lDDA     := VerifDDA(cCaminho+cArqDir,@cData)
		if lDDA   // 02/02/2016
		   dData := ctod(Left(cData,2)+'/'+Substr(cData,3,2)+'/'+Right(cData,4))
	        if Len(cData) < 8                                                                   
	           cData := Left(cData,2)+'/'+Substr(cData,3,2)+'/'+Right(cData,2)
	        else
				cData := Left(cData,2)+'/'+Substr(cData,3,2)+'/'+Right(cData,4)
			endif
		endif 
	                
		dDatabase := cTod(cData)				// 22/07/2016
		aDados    := LerArq(cCaminho+cArqDir, lDDA)  	 // Leitura de parametro do banco

        if !file(cCaminho+cArqDir)
		   Loop
        endif    

        
        if !lDDA        
	        if Len(aDados[4]) < 8                                                                   
	           cData := Left(aDados[4],2) + '/' + Substr(aDados[4],3,2) + '/' + Right(aDados[4],2)
	        else
				cData := Left(aDados[4],2) + '/' + Substr(aDados[4],3,2) + '/' + Right(aDados[4],4)
			endif
	
			dDatabase := cTod(cData)				// 22/07/2016

			if Len(cData) < Len(dtoc(dDatabase))
			   dData := GRAVADATA(dDatabase,.F.)
			   dData := ctod(Left(dData,2) + '/' + Substr(dData,3,2) + '/' + Right(dData,2))
			else        
			   dData := dDatabase
			Endif
		Endif

        if ctod(cData) <>  dData
           cData := Left(aDados[4],2)+'/'+Substr(aDados[4],3,2)+'/'+Substr(aDados[4],5,4)
           aAdd(aLog, {'Arquivo: '+cArqDir+' - Não processado vencimento: ' +cData+' diferente da Database ( '+dtoc(dData)+' ) do sistema'} )
           Loop
        Endif
        
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³      ** Carrega Fun‡„o Pergunte **        ³
		//³ mv_par01 - Mostra lan‡amentos cont beis   ³
		//³ mv_par02 - Aglutina lan‡amentos           ³
		//³ mv_par03 - Atualiza moedas por            ³
		//³ mv_par04 - Arquivo de entrada             ³
		//³ mv_par05 - Arquivo de config              ³
		//³ mv_par06 - C¢digo do banco                ³
		//³ mv_par07 - C¢digo da agencia              ³
		//³ mv_par08 - C¢digo da conta                ³
		//³ mv_par09 - Sub-conta                      ³
		//³ mv_par10 - Abate desconto da comiss„o     ³
		//³ mv_par11 - Contabiliza On-Line            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//SetKey (VK_F12,{|a,b| AcessaPerg("AFI300",.T.)})
		
		
		if (aDados[1] == '341') .and. (!lDDA)    // SisPag
			MV_PAR04 := cCaminho+cArqDir
	       //	MV_PAR05 := aDados[1]+'R.PAG'
			MV_PAR06 := aDados[1]
			MV_PAR07 := u_RemoveC(aDados[2],'',MV_PAR06) 				//Left(u_RemoveC(aDados[2],5)+space(5),5)
			MV_PAR08 := u_RemoveC(aDados[3],MV_PAR07,MV_PAR06)         //Left(u_RemoveC(aDados[3],10)+space(10),10)        
			MV_PAR09 := 'P  ' 
			
			cBanco   := MV_PAR06
			cAgencia := MV_PAR07 
			cConta	 := MV_PAR08
			cSubCta  := MV_PAR09
	
			// variavel para Conciliacao
			CBCO380   := cBanco                            
			cAge380   := cAgencia
			cCta380   := cConta
			aPar 	  := {CBCO380, cAge380, cCta380}
		    
			dbSelectArea('SEE')
			dbSetOrder(1)
			if !dbSeek(xFilial('SEE')+CBCO380+cAge380+cCta380+cSubCta)        
				MsgInfo('Não encontrou o banco')
				Return
			Endif
			lDigita      := .F.
			lAglut       := .T.
			lContabiliza := .F.  
			
			// Se MV_PAR01 mudar para caracter, ocorreu um problema e devera ser corrigido
			IF VALTYPE(mv_par01)='C'
				MV_PAR01 := 2		//Mostra Lanc. Contab  ? Sim Nao           ³
				MV_PAR02 := 1		//Aglutina Lanc. Contab? Sim Nao           ³
				MV_PAR03 := 1 
				MV_PAR10 := 2 
				MV_PAR11 := 2 
				MV_PAR12 := 1 
				MV_PAR13 := 2 
			ENDIF
			lDigita:=IIF(mv_par01 == 1,.T.,.F.)
			lAglut :=IIF(mv_par02 == 1,.T.,.F.)
			lContabiliza:= Iif(mv_par11 == 1,.T.,.F.)
			
			//Processa({|lEnd| Fa300Processa()})  
			Processa({|lEnd| lImp := u_EVFNA300() })
			
		else 
		    
		    // Arquivo Retorno           
			MV_PAR03 := cCaminho+cArqDir 

			if !lDDA
			    if aDados[1] = '745'
					//MV_PAR04 := aDados[1]+'.2PR'
					MV_PAR04 := 'TESTE'
				Elseif aDados[1] = '422'
		  			MV_PAR04 := aDados[1]+'RR.CPR'
				Else
		  			MV_PAR04 := aDados[1]+'R.2PR'
				endif
			Else
		 		MV_PAR04 := 'DDA.2PR'			   
			Endif
			MV_PAR05 := aDados[1]
			if !lDDA
				MV_PAR06 := u_RemoveC(aDados[2],'',MV_PAR05) 
				MV_PAR07 := u_RemoveC(aDados[3],MV_PAR06,MV_PAR05)
			else
				MV_PAR06 := aDados[2]
				MV_PAR07 := aDados[3]
			Endif
			MV_PAR08 := 'P  '
			MV_PAR10 := if(!lDDA,if(aDados[5]=400, 1,2),2) 				// - tratamento layout de arquivo
			dDATA    := ctod(Left(aDados[4],2)+'/'+Substr(aDados[4],3,2)+'/'+Right(aDados[4],4))
			dDATA2   := dData

			cBanco   := MV_PAR05
			cAgencia := MV_PAR06 
			cConta	 := MV_PAR07
			cSubCta  := MV_PAR08
	
			// variavel para Conciliacao
			CBCO380   := cBanco                            
			cAge380   := cAgencia
			cCta380   := cConta
			aPar 	  := {CBCO380, cAge380, cCta380}

			if !lDDA
				dbSelectArea('SEE')
				dbSetOrder(1)
				if !dbSeek(xFilial('SEE')+CBCO380+cAge380+cCta380+cSubCta)        
					MsgInfo('Não encontrou o banco')
					Return
				Endif
            Endif
            
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza o log de processamento   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			if lExecJob
				ProcLogAtu("INICIO","Retorno Bancario Automatico (Pagar) - Arquivo:"+mv_par03) // "Retorno Bancario Automatico (Pagar)" # "Arquivo:"
			Else	
				ProcLogAtu("INICIO")
			Endif	

			//fa430gera('SE2')
			lImp := EV430Ger("SE2")   
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Fecha os Arquivos ASCII ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nHdlBco > 0
				FCLOSE(nHdlBco)
			Endif	           
			
			If nHdlConf > 0
				FCLOSE(nHdlConf)
			Endif			
		
		endif
        
		// Renomeia arquivo
        if file(cCaminho+cArqDir)
           FT_FUSE()    // forca fechamento do arquivo, caso esteja aberto
		   cFileName := cCaminho+cArqDir
		   cDestino  := cCaminho+Substr(cArqDir,1,at('.',cArqDir)-1)+'.proc'

			// Renomeando um arquivo no Client  
			if lImp .or. lDDA
				nStatus1 := frename(cFileName , cDestino)
				IF nStatus1 == -1
				   MsgStop('Falha na operação 1 : FError '+str(ferror(),4))
				Endif  
			endif			

		endif
        
		dbSelectArea("SE5")
		dbSetOrder(1)
		            
		lPanelFin := .F.
	
		if !lDDA
		    // Conciliacao Bancaria 
			//lImp := u_EV380Rec(aPar)
		Else                        
		    // Conciliacao DDA 
		    //lImp := u_FINA260V(dData)		    
		Endif
		                     
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Recupera a Integridade dos dados                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SE2")
		dbSetOrder(1)	
	   
	Next   

	dDatabase := dDataTmp				// 22/07/2016

	// Relatorio de extrato do banco
	if lImp .and. (!lDDA)
		U_EVFNR470(aPar)
    endif
	
	// Apresenta error log
	if Len(aLog) > 0
		if  U_GeraTXT(aLog, cArqLog)
			WinExec( "Explorer.exe "+cArqLog  )
		Endif           
	Endif
	   

Return
      












/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSX1    ³Autor ³  Valdemir / Eduardo  ³Data³ 04/09/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta helps de campo                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1(cPerg)
Local aHelpPor:={}
Local aHelpSpa:={}
Local aHelpEng:={} 
                               
//Inclusão de pergunta "Processa Filial?"
SX1->( dbSetOrder( 1 ) )

If !SX1->( dbSeek( PadR( cPerg, Len( X1_GRUPO 	) ) + "11" ) )

	PutSx1( cPerg, "11","Processa Filial?","¿Processa Sucursal?","Processa Branch?","mv_chB","N",1,0,1,"C","","","","",;
		"mv_par11","Filial Atual","Sucursal Atual","Actual Branch","","Todas Filiais","Todas Sucursais","All Branchs","","","","","","","","","",,,,".AFI43011.")
	
	aHelpPor := {}
	aHelpSpa := {}
	aHelpEng := {}
	
	Aadd(aHelpPor,{	"Indicar se o processamento de retorno",;
					"deve considerar somente os títulos da",;
					"Filial Atual ou os títulos de Todas as",;
					"Filiais, se utilizado o recurso IDCNAB.",;
					"Na opção Todas as Filiais, se a",;
					"contabilidade estiver em modo exclusivo, ",;
					"a contabilização deve ser realizada em",;
					"modo off-line." })
                   
	Aadd(aHelpSpa,{	"Indicar si el proceso de retorno",;
					"considerará únicamente los títulos",;
					"de la Sucursal actual o los títulos de",;
					"Todas las sucursales, si utilizar lo",;
					"recurso IDCNAB. En la opción Todas",;
					"las Sucursales, si la contabilidad ",;
					"estuviera en modo exclusivo, la ",;
					"contabilizacion debe hacerse en modo ",;
					"off-line." })
                  	
	Aadd(aHelpEng,{	"Indicates if the receipt transaction",;
					"have to consider only the bills of ",;
					"current branch or all branchs, if used",;
					"resource IDCNAB. If you select all",;
					"branchs and the accounting is in ",;
					"exclusive mode, you have to use the",;
					"off-line accounting routine." })
	
	PutHelp("P.AFI43011.",aHelpPor[1],aHelpEng[1],aHelpSpa[1])
	
EndIf

If !SX1->( dbSeek( PadR( cPerg, Len( X1_GRUPO 	) ) + "12" ) )

	PutSx1( cPerg, "12","Considera Multiplas Nat. ?","Proration of Bill´s class ?", "Prorrateo del titulo ?","mv_chC","N",1,0,2,"C","","","","",;
		"mv_par12","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",,,,".AFI43012.")

	aHelpPor := {}
	aHelpSpa := {}
	aHelpEng := {}
	//Help - campo .AFI43012.
	Aadd( aHelpPor,{"Informe SIM caso queira considerar", "as Multiplas Naturezas da Inclusão", " do Titulo."   })
	Aadd( aHelpSpa,{"Seleccione SIM Prorrateo de las", "modalidades del titulo" })
	Aadd( aHelpEng,{"Select Proration of Bill´s class"  })
	
	PutHelp("P.AFI43012.",aHelpPor[1],aHelpEng[1],aHelpSpa[1])
Else        
	dbSelectArea("SX1")
	dbSetOrder(1)
	cGrupo := PadR( "AFI430" , Len( SX1->X1_GRUPO ) , " " )	
	If dbSeek(cGrupo + "12") .And. X1_DEF02 <> "Não"
   		RecLock("SX1")
		Replace X1_DEF02 	With "Não"		 
		Replace X1_DEFSPA2 	With "No"		
		Replace X1_DEFENG2 	With "No"		
		MsUnlock()
   Endif
EndIf


//-------- Ajustes de Help -----------


//Help - campo .AFI43002.
Aadd( aHelpPor, {'Informe a opção "Sim" para',;
				'que os lançamentos contábeis',;
				'originados na movimentação de',;
				'recebimento do arquivo sejam',;
				'exibidos na tela, ou "Não",',;
				'caso contrário.'})
				
Aadd( aHelpSpa, {'Elija la opcion "Si" para',;
				 'que los asientos contables',;
				 'originados en el movimiento',;
				 'de recepcion del archivo sean',;
				 'exhibidos en la ventana, o en',; 
				 'caso contrario, elija "No".'})

Aadd( aHelpEng, {'Inform the option "Yes"',;
                 'in order to the accounting',;
                 'entries originated in the file',;
	             'receipt transaction to be',; 
                 'displayed on the screen.',; 
                 'Otherwise, select "No".'}) 

PutHelp("P.AFI43002.",aHelpPor[1],aHelpEng[1],aHelpSpa[1],.T.)

aHelpPor:={}
aHelpSpa:={}
aHelpEng:={}
//Help - campo .AFI43003.
Aadd( aHelpPor, {"Informe o nome do arquivo de entrada.",; 
				 "Geralmente os bancos tem uma forma",;
				 "padrão de nomeação dos arquivos."})

Aadd( aHelpSpa, {"Digite el nombre del archivo de",; 
				 "entrada. Generalmente los bancos",;
				 "tienen una forma estandar de",; 
				 "nombramiento de los archivos."})

Aadd( aHelpEng, {"Inform the inflow file name. Usually,",;
				 "the banks have a standard way to",; 
				 "name the files."})

PutHelp("P.AFI43003.",aHelpPor[1],aHelpEng[1],aHelpSpa[1],.T.)

aHelpPor:={}
aHelpSpa:={}
aHelpEng:={}
//Help - campo .AFI43004.
Aadd( aHelpPor, {"Informe o nome do arquivo",; 
	             "de configuração de retorno.",;
                 "Este arquivo conterá a",; 
                 "configuração para o retorno",;
                 "bancário definida no Módulo",;
                 "Configurador."})

Aadd( aHelpSpa, {"Informe el nombre del archivo",; 
                 "de configuracion de retorno.",; 
                 "Este archivo contendra la",; 
                 "configuracion para el retorno",; 
                 "bancario definido en el Modulo",;
                 "Configurador."})

Aadd( aHelpEng, {"Inform the return setup file.",; 
                 "name. This file will contain the",; 
                 "setup for the bank return defined",; 
                 "in the Configurator Module."})

PutHelp("P.AFI43004.",aHelpPor[1],aHelpEng[1],aHelpSpa[1],.T.)

Return


Static Function LerArq(pArquivo, plDDA)     // ----------------------- Verificar aqui
	Local aRET := {}
	Local nTamFile, nTamLin, cBuffer, nBtLidos

	FT_FUse(pArquivo)
	FT_FGOTOP()
	cBuffer := FT_FREADLN()

    nPosLayOut := Len(cBuffer)
              
    if !plDDA
		if nPosLayOut = 240
	    		           // Banco                    Agencia               Conta   
	    	aRET := {SubStr(cBuffer, 1,3), SubStr(cBuffer, 53,5), SubStr(cBuffer, 59,12)  }
		else
	    		           // Banco                    Agencia               Conta   
	    	aRET := {SubStr(cBuffer,77,3), SubStr(cBuffer, 40,5), SubStr(cBuffer, 28,6)  }
		Endif    
    else
	    		           // Banco                    Agencia               Conta      
	    	aRET := {SubStr(cBuffer, 1,3), SubStr(cBuffer, 53,5), SubStr(cBuffer, 59,12)  }
    endif
    
	if !plDDA
	    nLin := 1
	    While !FT_FEOF()  
		 cBuffer := FT_FREADLN()
		 if nLin = 2
		    cModelo := Substr(cBuffer,12,2)
		 Endif
	
	 	 If (nPosLayOut = 240) .and. (nLin = 3) 
	 	   if Substr(cBuffer,14,1) == 'J'
	 	     aAdd(aRET, Substr(cBuffer,145,8) )			// Boleto
	 	   elseif Substr(cBuffer,14,1) == 'N'  
	 	     if aRET[1] = '341'           
	            if cModelo = '17'    // GPS
					aAdd(aRET, Substr(cBuffer,100,8) )			// Tributos sem código de barra            
				elseif cModelo $ '16/18'    // DARF/DARF SIMPLES
					aAdd(aRET, Substr(cBuffer,128,8) )			// Tributos sem código de barra            
				elseif cModelo = '22'    // GARE
					aAdd(aRET, Substr(cBuffer,147,8) )			// Tributos sem código de barra            
				elseif cModelo = '25/27'    // DPVAT e IPVA
					aAdd(aRET, Substr(cBuffer,117,8) )			// Tributos sem código de barra            
				elseif cModelo = '35'    // FGTS
					aAdd(aRET, Substr(cBuffer,52,8) )			// Tributos sem código de barra            
				endif
	 	     else
	 	     	aAdd(aRET, Substr(cBuffer,088,8) )			// Tributos sem código de barra
	 	     endif
	 	   elseif Substr(cBuffer,14,1) == 'O'
	 	     aAdd(aRET, Substr(cBuffer,100,8) )			// Tributo com codigo Barra
	 	   else
	 	     aAdd(aRET, Substr(cBuffer,155,8) )			// Transf/Doc/TED
	 	   endif
	 	 Elseif (nLin = 2)    // 400 POSIÇÕES
	 	   if Substr(cBuffer,140,3) $ 'DOC/TED/CC /COB'   
	 	      aAdd(aRET, Substr(cBuffer,385,6) )			// DOC / TED / CC (Transf)
	 	   endif
	 	
	 	 endif
	     FT_FSKIP()
	     nLin++
	    EndDo	
	    
	    aAdd(aRET, Len(cBuffer) )			// LayOut (Tamanho)
    ELSE  
  	    nLin := 1
	    While !FT_FEOF() 
	      cBuffer := FT_FREADLN() 
          if nLin = 3
		  	 aAdd(aRET, SubStr(cBuffer, 108,8) ) 
		  	 exit
		  endif
	      FT_FSKIP()
	      nLin++
	    EndDo	
    ENDIF
	//Fechamento do Arquivo Texto
	FT_FUSE()

Return aRET



//---------------------------------------------------------------------------------------------------------------------------

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fA430Gera³ Autor ³ Wagner Xavier         ³ Data ³ 26/05/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Comunicacao Bancaria - Retorno                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fA430Ger(cAlias)                                           ³±±
±±³          ³ cAlias - Alias corrente para executar a funcao             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FinA430                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function EV430Ger(cAlias)
Local cPosNum,cPosData,cPosDesp,cPosDesc,cPosAbat,cPosPrin,cPosJuro,cPosMult,cPosForne
Local cPosOcor,cPosTipo,cPosCgc, cRejeicao, cPosDebito, cPosRejei
Local cChave430,cNumSe2,cChaveSe2
Local cArqConf,cArqEnt,cPosNsNum
Local cTabela    := "17",cPadrao,cLanca,cNomeArq
Local cFilOrig   := cFilAnt	// Salva a filial para garantir que nao seja alterada em customizacao
Local xBuffer
Local lPosNum    := .f., lPosData := .f.
Local lPosDesp   := .f., lPosDesc := .f., lPosAbat := .f.
Local lPosPrin   := .f., lPosJuro := .f., lPosMult := .f.
Local lPosOcor   := .f., lPosTipo := .f., lMovAdto := .F.
Local lPosNsNum  := .f., lPosForne:= .f., lPosRejei:= .f.
Local lPosCgc    := .f., lPosdebito:=.f.
Local lDesconto,lContabiliza,lUmHelp := .F.,lCabec := .f.
Local lPadrao    := .f., lBaixou := .f., lHeader := .f.
Local lF430VAR   := ExistBlock("F430VAR"),lF430Baixa := ExistBlock("F430BXA")
Local lF430Rej   := ExistBlock("F430REJ"),lFa430Oco  := ExistBlock("FA430OCO")
Local lFa430Se2  := ExistBlock("FA430SE2"),lFa430Pa  := ExistBlock("FA430PA")
Local lFa430Fil  := Existblock("FA430FIL")
Local lRet       := .T.
Local nLidos,nLenNum,nLenData,nLenDesp,nLenDesc,nLenAbat,nLenForne,nLenRejei
Local nLenPrin,nLenJuro,nLenMult,nLenOcor,nLenTipo,nLenCgc, nLenDebito,nLenNsNum
Local nTotal     := 0,nPos,nPosEsp,nBloco := 0,nF:=0
Local nSavRecno  := Recno()
Local nTamForn   := Tamsx3("E2_FORNECE")[1]
Local nTamOcor   := TamSx3("EB_REFBAN")[1]
Local nTamEEOcor := 2
Local aTabela    := {},aLeitura := {},aValores := {},aCampos := {}
Local dDebito
Local lNewIndice := FaVerInd()  //Verifica a existencia dos indices de IDCNAB sem filial
Local nTamPre	:= TamSX3("E1_PREFIXO")[1]
Local nTamNum	:= TamSX3("E1_NUM")[1] 
Local nTamPar	:= TamSX3("E1_PARCELA")[1]
Local nTamTit	:= nTamPre+nTamNum+nTamPar
Local lAchouTit := .F.
Local nTamBco	:= Tamsx3("A6_COD")[1]
Local nTamAge	:= TamSx3("A6_AGENCIA")[1]
Local nTamCta	:= Tamsx3("A6_NUMCON")[1]
Local lMultNat 	:= IIF(mv_par12==1,.T.,.F.)
Local aColsSEV 	:= {}
Local lOk 		:= .F. //Controla se foi confirmada a distribuicao 
Local nTotLtEZ 	:= 0	//Totalizador da Bx Lote Mult Nat CC
Local nHdlPrv	:= 0
Local aArqConf	:= {}	// Atributos do arquivo de configuracao
Local lCtbExcl	:= !Empty( xFilial("CT2") )
Local aFlagCTB	:= {}
Local lUsaFlag	:= SuperGetMV( "MV_CTBFLAG" , .T. /*lHelp*/, .F. /*cPadrao*/)
Local lF430PORT := ExistBlock("F430PORT")
Local lAltPort 	:= .F.
Local aDtMvFinOk := {} //Array para as datas de baixa válidas
Local aDtMvFinNt := {} //Array para as datas de baixa inconsistentes com o parâmetro MV_DATAFIN

//DDA - Debito Direto Autorizado
Local lUsaDDA	:= If (FindFunction("FDDAInUse"),FDDAInUse(),.F.)
Local lProcDDA	:= .F.
Local lF430COMP := ExistBlock( "F430COMP" )
Local lFA430FIG	:= ExistBlock( "FA430FIG" )
Local cFilAux	:= ""
Local lF430GRAFIL   := ExistBlock("F430GRAFIL")
Local cCGCFilHeader := ""
Local aAreaCorr     := {}
Local cCodForn      := ""
Local cQuery        := ""
Local cAliasTmp 	:= GetNextAlias()

Private cBanco, cAgencia, cConta
Private cHist070, cArquivo
Private lAut		:=.f., nTotAbat := 0
Private cCheque 	:= " ", cPortado := " ", lAdiantamento := .F.
Private cNumBor 	:= " ", cForne  := " " , cCgc := "", cDebito := ""
Private cModSpb 	:= "1"  // Colocado apenas para não dar problemas nas rotinas de baixa
Private cAutentica 	:= Space(25)  //Autenticacao retornada pelo segmento Z    /
Private cLote		:= Space(TamSX3("EE_LOTECP")[1])
Private cBenef      := ""  // JBS - 26/08/2013 - Controle da gravação do nome do beneficiario

lChqPre := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no Banco indicado                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cBanco  := mv_par05
cAgencia:= mv_par06
cConta  := mv_par07
cSubCta := mv_par08

dbSelectArea("SA6")
DbSetOrder(1)
SA6->( dbSeek(xFilial("SA6")+cBanco+cAgencia+cConta) )

dbSelectArea("SEE")
DbSetOrder(1)
SEE->( dbSeek(xFilial("SEE")+cBanco+cAgencia+cConta+cSubCta) )
nBloco := If( SEE->EE_NRBYTES==0,402,SEE->EE_NRBYTES+2)
If !SEE->( found() )
	if ! lExecJob
		Help(" ",1,"PAR150")
	Endif	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o log de processamento com o erro  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcLogAtu("ERRO","PAR150",Ap5GetHelp("PAR150"))

	lRet:= .F.
Endif

If lRet .And. GetMv("MV_BXCNAB") == "S" // Baixar arquivo recebidos pelo CNAB aglutinando os valores
	If Empty(SEE->EE_LOTECP)
		cLoteFin := StrZero( 1, TamSX3("EE_LOTECP")[1] )
	Else
		cLoteFin := FinSomaLote(SEE->EE_LOTECP)
	EndIf
EndIf

lRet := DtMovFin( dDatabase )
If !lret
    Return( .F. )
Endif

If lRet
	cTabela := Iif( Empty(SEE->EE_TABELA), "17" , SEE->EE_TABELA )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a tabela existe           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea( "SX5" )
	If !SX5->( dbSeek( xFilial("SX5")+ cTabela ) )
		if ! lExecJob
			Help(" ",1,"PAR430")
		Endif
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o log de processamento com o erro  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ProcLogAtu("ERRO","PAR430",Ap5GetHelp("PAR430"))
	
		lRet := .F.
	Endif
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existe inidce IDCNAB para multiplas filiais ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet .And. mv_par11 == 2
	If !lNewIndice                       
		// Não foi encontrado o índice por IDCNAB sem Filial. ### Executar o compatibizador do ambiente Financeiro (U_UPDFIN).
		PutHelp( "PNOIDCNAB",	{"Não foi encontrado o índice por IDCNAB", "sem Filial."},;
								{"The index IDCNAB without Branch not found." },;
								{"No encontro el indice por IDCNAB sin", "Sucursal."} )
								
		PutHelp( "SNOIDCNAB",	{"Executar o compatibizador do ambiente", "Financeiro (U_UPDFIN)."},;
								{"Run the compatibility Financial ", "(U_UPDFIN)." },;
								{"Ejecutar el compatibilizador del entorno", "Financeiro (U_UPDFIN)."} )
	
		If ! lExecJob
			Help( "  ", 1, "NOIDCNAB" )
		Endif	

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o log de processamento com o erro  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ProcLogAtu( "ERRO", "NOIDCNAB", Ap5GetHelp("NOIDCNAB"))
		lRet := .F.                                           		
	Else
		If lCtbExcl .and. ! ExecSchedule()
			// 
			//              Removido Temporariamente - Valdemir
			lRet := .T.    //MsgYesNo( "Neste caso, o sistema não realiza a contabilização on-line.", "Confirma mesmo assim?" )
		EndIf
	EndIf	
EndIf
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se arquivo ja foi processado anteriormente	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet .And. !(Chk430File())
	lRet := .F.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// Retorno Automatico via Job se o arquivo estiver	     ³
// no diretorio vai reprocessar sempre se for JOB	     ³
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
If lExecJob .and. ! lRet
	ProcLogAtu("ALERTA","Arquivo :" +Alltrim(mv_par03)+" processado anteriormente.") 	// # 	
	Aadd(aMsgSch, "Arquivo :"+Alltrim(mv_par03)+" processado anteriormente."	) 		//  # 
Endif	

//Altero banco da baixa pelo portador ?
If lF430PORT
	lAltPort := ExecBlock("F430PORT",.F.,.F.)
Endif

While lRet .And. !SX5->(Eof()) .and. SX5->X5_TABELA == cTabela
	AADD(aTabela,{Alltrim(X5Descri()),PadR(AllTrim(SX5->X5_CHAVE),3)})
	SX5->(dbSkip( ))
EndDo

If lRet
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o numero do Lote   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	LoteCont("FIN")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Abre arquivo de configuracao ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cArqConf:= mv_par04
	If !FILE(cArqConf)
		if ! lExecJob
			Help(" ",1,"NOARQPAR")
		Endif	

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o log de processamento com o erro  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//ProcLogAtu("ERRO","NOARQPAR",Ap5GetHelp("NOARQPAR"))

		//lRet:= .F. 
		lRet:= .t.
	ElseIf ( MV_PAR10 == 1 )
		nHdlConf:=FOPEN(cArqConf,0+64)
	EndIF
EndIf
	
If lRet .And. ( MV_PAR10 == 1 )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Lˆ arquivo de configuracao ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLidos:=0
	FSEEK(nHdlConf,0,0)
	nTamArq:=FSEEK(nHdlConf,0,2)
	FSEEK(nHdlConf,0,0)
	While nLidos <= nTamArq
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o tipo de qual registro foi lido ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		xBuffer:=Space(85)
		FREAD(nHdlConf,@xBuffer,85)                          

		IF SubStr(xBuffer,1,1) == CHR(1)
			nLidos+=85
			Loop
		EndIF
		IF SubStr(xBuffer,1,1) == CHR(3)
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
		IF !lPosNsNum
			cPosNsNum := Substr(xBuffer,17,10)
			nLenNsNum := 1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosNsNum := .t.
			nLidos += 85
			Loop
		EndIF
		IF !lPosRejei
      	cPosRejei := Substr(xBuffer,17,10)
			nLenRejei := 1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosRejei := .t.
			nLidos += 85
			Loop
		EndIF
		IF !lPosForne
      	cPosForne := Substr(xBuffer,17,10)
			nLenForne := 1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosForne := .t.
			nLidos += 85
			Loop
		EndIF
		IF !lPosCgc
	      	cPosCgc   := Substr(xBuffer,17,10)
			nLenCgc   := 1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosCgc   := .t.
			nLidos += 85
			Loop
		EndIF
		IF !lPosDebito
			cPosDebito:=Substr(xBuffer,17,10)
			nLenDebito:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
			lPosDebito:=.t.
			nLidos+=85
			Loop
		EndIF
	EndDo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Fecha arquivo de configuracao ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Fclose(nHdlConf)
EndIf 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre arquivo enviado pelo banco ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet
	cArqEnt:=mv_par03
	If !FILE(cArqEnt)
		If ! lExecJob
			Help(" ",1,"NOARQENT")
		Endif	

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o log de processamento com o erro  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ProcLogAtu("ERRO","NOARQENT",Ap5GetHelp("NOARQENT"))

		lRet:= .F.
	Else
		nHdlBco:=FOPEN(cArqEnt,0+64)
	EndIF
EndIf

If lRet
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Lˆ arquivo enviado pelo banco ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nLidos:=0
	FSEEK(nHdlBco,0,0)
	nTamArq:=FSEEK(nHdlBco,0,2)
	FSEEK(nHdlBco,0,0)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Desenha o cursor e o salva para poder moviment -lo ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcRegua( nTamArq/nBloco )
	               
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Certifico de que o TRB esta fechado.                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (Select("TRB")<>0)
		dbSelectArea("TRB")
		dbCloseArea()
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera arquivo de Trabalho                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aCampos,{"FILMOV"	,"C",IIf( lFWCodFil, FWGETTAMFILIAL, 2 ),0})
	AADD(aCampos,{"BANCO"	,"C",TamSx3("A6_COD")[1],0})
	AADD(aCampos,{"AGENCIA"	,"C",TamSx3("A6_AGENCIA")[1],0})
	AADD(aCampos,{"CONTA"	,"C",TamSx3("A6_NUMCON")[1],0})
	AADD(aCampos,{"DATAD"	,"D",08,0})
	AADD(aCampos,{"TOTAL"	,"N",17,2})
	
	If Select("TRB") == 0
		cNomeArq:=CriaTrab(aCampos)
		dbUseArea( .T., __cRDDNTTS, cNomeArq, "TRB", if(.F. .Or. .F., !.F., NIL), .F. )
		IndRegua("TRB",cNomeArq,"FILMOV+BANCO+AGENCIA+CONTA+Dtos(DATAD)",,,"")
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega atributos do arquivo de configuracao                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//aArqConf := Directory(mv_par04)
	
	aArqConf := {{ if(!lDDA, '745.2PR','DDA.2PR'),83834,ctod('17/10/2015'),'19:36:21','A'}}                                  
	
	
	Begin Transaction

	While nLidos <= nTamArq
		IncProc()
		nDespes :=0
		nDescont:=0
		nAbatim :=0
		nValRec :=0
		nJuros  :=0
		nMulta  :=0
		nValCc  :=0
		nValPgto:=0
		nCM     :=0
		ABATIMENTO := 0
	
		cFilAnt := cFilOrig	//Sempre restaura a filial original 
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Tipo qual registro foi lido ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ( MV_PAR10 == 1 )			// MODELO 1
			xBuffer:=Space(nBloco)
			FREAD(nHdlBco,@xBuffer,nBloco)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Considera a primeira linha sempre³
			//³ como um cabe‡alho                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lHeader .AND. SubStr(xBuffer,1,1) != "1" .AND. Substr(xBuffer,1,3) != "001" .OR. (cBanco == "409" .and. SubStr(xBuffer,1,1) == "2")  
				If lFA430FIG
					cCGCFilHeader := Substr(xBuffer, 12,14) // ler o novo cnpj do header.	
				EndIf
			EndIf			
			
			IF !lHeader
				lHeader := .T.
				nLidos	+=nBloco
				cCGCFilHeader := Substr(xBuffer, 12,14)
				Loop
			EndIF
	
			If SubStr(xBuffer,1,1) == "1" .or. Substr(xBuffer,1,3) == "001" .or.;
				(cBanco == "409" .and. SubStr(xBuffer,1,1) == "2")  // Unibanco    
								
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Lˆ os valores do arquivo Retorno ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cNumTit :=Substr(xBuffer,Int(Val(Substr(cPosNum, 1,3))),nLenNum )
				cData   :=Substr(xBuffer,Int(Val(Substr(cPosData,1,3))),nLenData)
				cData   :=ChangDate(cData,SEE->EE_TIPODAT)
				dBaixa  :=Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5),"ddmm"+Replicate("y",Len(Substr(cData,5))))
				dDebito :=dBaixa		// se nao for preenchido, usa dBaixa
				cTipo   :=Substr(xBuffer,Int(Val(Substr(cPosTipo, 1,3))),nLenTipo )
				cNsNum  := " "

				If !Empty(cPosDesp)
					nDespes:=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosDesp,1,3))),nLenDesp))/100,2)
				EndIf
				If !Empty(cPosDesc)
					nDescont:=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosDesc,1,3))),nLenDesc))/100,2)
				EndIf
				If !Empty(cPosAbat)
					nAbatim:=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosAbat,1,3))),nLenAbat))/100,2)
				EndIf
				If !Empty(cPosPrin)
					nValPgto :=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosPrin,1,3))),nLenPrin))/100,2)
				EndIF
				If !Empty(cPosJuro)
					nJuros  :=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosJuro,1,3))),nLenJuro))/100,2)
				EndIf
				If !Empty(cPosMult)
					nMulta  :=Round(Val(Substr(xBuffer,Int(Val(Substr(cPosMult,1,3))),nLenMult))/100,2)
				EndIf
				If !Empty(cPosNsNum)
					cNsNum  :=Substr(xBuffer,Int(Val(Substr(cPosNsNum,1,3))),nLenNsNum)
				EndIf
				IF !Empty(cPosRejei)
					cRejeicao  :=Substr(xBuffer,Int(Val(Substr(cPosRejei,1,3))),nLenRejei)
				End
				IF !Empty(cPosForne)
					cForne  :=Substr(xBuffer,Int(Val(Substr(cPosForne,1,3))),nLenForne)
				End
		
				nTamEEOcor := If(SEE->(!eof() ) .and. SEE->(FieldPos("EE_TAMOCOR")) > 0,SEE->EE_TAMOCOR,2) // Tamanho da Ocorrencia Bancaria retornada pelo banco.
				cOcorr := Substr(xBuffer,Int(Val(Substr(cPosOcor,1,3))),nLenOcor)
				cOcorr := PadR( Left(Alltrim(cOcorr),nTamEEOcor) , nTamOcor)

				If !Empty(cPosCgc)
					cCgc  :=Substr(xBuffer,Int(Val(Substr(cPosCgc,1,3))),nLenCgc)
				Endif
				If !Empty(cPosDebito)
					cDebito :=Substr(xBuffer,Int(Val(Substr(cPosDebito,1,3))),nLenDebito)
					cDebito :=ChangDate(cDebito,SEE->EE_TIPODAT)
					If !Empty(cDebito)
						dDebito :=Ctod(Substr(cDebito,1,2)+"/"+Substr(cDebito,3,2)+"/"+Substr(cDebito,5),"ddmm"+Replicate("y",Len(Substr(cDebito,5))))
					Endif
				Endif
				nCM     := 0

				//Processo DDA - Bradesco
				lProcDDA := .F.
				cRastro	:= Substr(xBuffer,264,2)     //Operacao de rastreamento = 30 (Fixo) 
				cDDA		:= Substr(xBuffer,279,2)		//Operacao de rastreamento = "FS" (Fixo)

				//Rastreamento DDA - Bradesco
				If lUsaDDA .and. cBanco = "237" .And. cRastro == "30" .and. cDDA == "FS"

					cBcoForn := Substr(xBuffer,096,3)		//01-03 Banco do cedente - Fornecedor
					cCodBar	:= ""							//Codigo de barras completo
					cFatorVc:= ""							//Fator de Vencimento
					cMoeda	:= "9"							//Moeda do titulo (9 = Real)
					cDV		:= ""							//Digito verificador do codigo de barras (sera calculado)
					cVencto	:= ""							//Data de vencimento
					cOcorr	:= PadR("FS",nTamOcor)			//Forco Ocorrencia pois a mesma pode voltar vazia em caso de rastreamento DDA
					
					//Calculo do Fator de Vencimento
					cVencto		:= Substr(xBuffer,166,8)
					cVencto  	:= ChangDate(cVencto,SEE->EE_TIPODAT)
					cVencto  	:= Substr(cVencto,1,2)+"/"+Substr(cVencto,3,2)+"/"+Substr(cVencto,5)
					cFatorVc	:= StrZero(ctod(cVencto) - ctod("07/10/97"),4)			//Fator de Vencimento

					//Valor do documento
					cValPgto := Substr(xBuffer,195,10)		//Valor do Titulo

					//Bando do Cedente = Bradesco
					If cBcoForn == "237"

						//Campo Livre do codigo de barras
						cCpoLivre:= Substr(xBuffer,100,4)+ ;		//Agencia
										Substr(xBuffer,137,2)+ ;	//Carteira
										Substr(xBuffer,140,11)+;	//Nosso Numero
										Substr(xBuffer,111,7)+ ;	//Conta corrente
										"0"							//Zero (fixo)
			
					//Bando do Cedente <> Bradesco	
					Else

						cCpoLivre:= Substr(xBuffer,374,25)		//Campo Livre do codigo de barras

					Endif

					//Calculo do digito verificador do codigo de barras
					cDV := DV_BarCode(cBcoForn + cMoeda + cFatorVc + cValPgto + cCpoLivre)

					//Montagem do código de barras
					cCodBar :=	cBcoForn 	+ ;		//01-03 - Codigo do banco
								cMoeda		+ ;		//04-04 - Codigo da moeda
								cDV			+ ;		//05-05 - Digito verificador
								cFatorVc	+ ;		//06-09 - Fator vencimento
								cValPgto	+ ;		//10-19 - Valor do documento	
								cCpoLivre			//20-44 - Campo Livre


					If !Empty(cCodBar)
						lProcDDA := .T.
					Endif

				Endif
	   
			   If lFa430Fil
			    	Execblock("FA430FIL",.F.,.F.,{xBuffer} )
			   Endif
			   
				If lF430Var
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ o array aValores ir  permitir ³
					//³ que qualquer exce‡„o ou neces-³
					//³ sidade seja tratado no ponto  ³
					//³ de entrada em PARAMIXB        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					// Estrutura de aValores
					//	Numero do T¡tulo	- 01
					//	data da Baixa		- 02
					// Tipo do T¡tulo		- 03
					// Nosso Numero			- 04
					// Valor da Despesa		- 05
					// Valor do Desconto	- 06
					// Valor do Abatiment	- 07
					// Valor Pagamento   	- 08
					// Juros				- 09
					// Multa				- 10
					// Fornecedor			- 11
					// Ocorrencia			- 12
					// CGC					- 13
					// nCM					- 14
					// Rejeicao				- 15
					// Linha Inteira		- 16
					
					aValores := ( { cNumTit, dBaixa, cTipo,;
										 cNsNum, nDespes, nDescont,;
										 nAbatim, nValPgto, nJuros,;
										 nMulta, cForne, cOcorr,;
										 cCGC, nCM, cRejeicao, xBuffer })
	
					ExecBlock("F430VAR",.F.,.F.,{aValores})
	
				Endif
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica especie do titulo    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nPos := Ascan(aTabela, {|aVal|aVal[1] == Alltrim(Substr(cTipo,1,3))})
				If nPos != 0
					cEspecie := aTabela[nPos][2]
				Else
					cEspecie	:= "  "
				EndIf
				If cEspecie $ MVABATIM		// Nao lˆ titulo de abatimento
					nLidos += nBloco
					Loop
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Ponto de entrada para permitir ou nao a baixa de ³
				//³ um determinadotipo de titulo. PA por exemplo.    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lFa430Pa
					If !(ExecBlock("FA430PA",.F.,.F.,cEspecie))
						nLidos += nBloco
						Loop
					Endif
				Endif
			Else
				nLidos += nBloco
				Loop
			EndIf
		Else                  
		    // modelo 2
			//aLeitura := //ReadCnab2(nHdlBco,cArqConf,nBloco,aArqConf)
			if !lDDA
				aLeitura := EVCnab3(nHdlBco,cArqConf,nBloco,aArqConf)
			else
				aLeitura := ReadCnab2(nHdlBco,cArqConf,nBloco,aArqConf)
			endif
			cNumTit  := SubStr(aLeitura[1],1, nTamTit)
			cData    := aLeitura[04] 
			if !lDDA
				cData    := ChangDate(cData,SEE->EE_TIPODAT)
			else
				cData    := ChangDate(cData,4)
			endif
			dBaixa   := Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5),"ddmm"+Replicate("y",Len(Substr(cData,5))))
			cTipo    := aLeitura[02]
			cNsNum   := aLeitura[11]
			nDespes  := aLeitura[06]
			nDescont := aLeitura[07]
			nAbatim  := aLeitura[08]
			nValPgto := aLeitura[05]
			nJuros   := aLeitura[09]
			nMulta   := aLeitura[10]
			cNsNum   := aLeitura[11]
			_nTamEE  := If(SEE->(!eof() ) .and. SEE->(FieldPos("EE_TAMOCOR")) > 0,SEE->EE_TAMOCOR,2) // Tamanho da Ocorrencia Bancaria retornada pelo banco.//
  			nTamEEOcor := _nTamEE
			cOcorr     := PadR( Left(Alltrim(aLeitura[03]),nTamEEOcor) , nTamOcor)

			cForne   := aLeitura[16]
			dDebito	 := dBaixa   
			xBuffer	 := aLeitura[17]
			
			//Segmento Z - Autenticacao
			If Len(aLeitura) > 17
				cAutentica := aLeitura[18]
			Endif
				
			//CGC
			If Len(aLeitura) > 19
				cCgc := aLeitura[20]
			Endif

			//Banco Agencia e Conta da Baixa
			If Len(aLeitura) > 20
				cBanco	 := PAD(aLeitura[21],nTamBco)
				cAgencia := PAD(aLeitura[22],nTamAge)
				cConta	 := PAD(aLeitura[23],nTamCta)
			Else
				cBanco  := mv_par05
				cAgencia:= mv_par06
				cConta  := mv_par07
			Endif

			//DDA - Debito Direto Autorizado
			If lUsaDDA .and. Len(aLeitura) > 23
				//Caso o CNPJ do Fornecedor seja retornado no Segmento H, assumo este valor
				If !Empty(aLeitura[24]) .and. Substr(aLeitura[24],1,7) != "0000000"
					cCgc := aLeitura[24]    
				Endif
				cCodBar := aLeitura[25]
				If !Empty(cCodBar)
					lProcDDA := .T.
				Endif
			
			Endif
			
			If lF430Var
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ o array aValores ir  permitir ³
				//³ que qualquer exce‡„o ou neces-³
				//³ sidade seja tratado no ponto  ³
				//³ de entrada em PARAMIXB        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				// Estrutura de aValores
				// Numero do T¡tulo		- 01
				// Data da Baixa		- 02
				// Tipo do T¡tulo		- 03
				// Nosso Numero			- 04
				// Valor da Despesa		- 05
				// Valor do Desconto	- 06
				// Valor do Abatiment	- 07
				// Valor Pagamento   	- 08
				// Juros				- 09
				// Multa				- 10
				// Fornecedor			- 11
				// Ocorrencia			- 12
				// CGC					- 13
				// nCM					- 14
				// Rejeicao				- 15
				// Linha Inteira		- 16
	         	// Autenticacao 	    - 17
	         	// Banco             	- 18	         
	         	// Agencia           	- 19
	         	// Conta             	- 20	         
				aValores := ( { cNumTit, dBaixa, cTipo,;
									 cNsNum, nDespes, nDescont,;
									 nAbatim, nValPgto, nJuros,;
									 nMulta, cForne, cOcorr,;
	                         cCGC, nCM,cRejeicao,xBuffer,;
	                         cAutentica,cBanco,cAgencia,cConta })
	
				ExecBlock("F430VAR",.F.,.F.,{aValores})
	
			Endif
	
			If Empty(cNumTit)
				nLidos += nBloco
				Loop
			Endif		

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica especie do titulo    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nPos := Ascan(aTabela, {|aVal|aVal[1] == Alltrim(Substr(cTipo,1,3))})
			If nPos != 0
				cEspecie := aTabela[nPos][2]
			Else
				cEspecie	:= "  "
			EndIf
			If cEspecie $ MVABATIM			// Nao lˆ titulo de abatimento
				Loop
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ponto de entrada para permitir ou nao a baixa de ³
			//³ um determinadotipo de titulo. PA por exemplo.    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lFa430Pa
				If !(ExecBlock("FA430PA",.F.,.F.,cEspecie))
					Loop
				Endif
			Endif
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se existe o titulo no SE2. Caso este titulo nao seja ³
		//³ localizado, passa-se para a proxima linha do arquivo retorno. ³
		//³ O texto do help sera' mostrado apenas uma vez, tendo em vista ³
		//³ a possibilidade de existirem muitos titulos de outras filiais.³
		//³ OBS: Sera verificado inicialmente se nao existe outra chave   ³
		//³ igual para tipos de titulo diferentes.                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SE2")
		dbSetOrder( 1 )
		lHelp := .F.
		lAchouTit := .F.

		/*Verifica a data de baixa do arquivo em relação ao parâmetro MV_DATAFIN*/
		If AScan( aDtMvFinOk , dBaixa ) == 0
			If AScan( aDtMvFinNt , dBaixa ) == 0 
				If !DtMovFin( dBaixa , .F. )
					aAdd( aDtMvFinNt , dBaixa )		
					If mv_par10 == 1
						nLidos+=nBloco
					EndIf
					ProcLogAtu( "ERRO" , "DTMOVFIN" , Ap5GetHelp( "DTMOVFIN" ) + " " + DtoC( dBaixa ) )
					Loop
				Else
					aAdd( aDtMvFinOk , dBaixa )
				EndIf
			Else		
				If mv_par10 == 1
					nLidos+=nBloco
				EndIf
				Loop
			EndIf
		EndIf		

		aValores := ( { cNumTit, dBaixa, cTipo, cNsNum, nDespes, nDescont, nAbatim, nValPgto, nJuros, nMulta, cForne, cOcorr, cCGC, nCM, cRejeicao, xBuffer })
		//Processamento normal - Nao se trata de processamento de arquivo de DDA
		If !lProcDDA
			// Ponto de entrada para posicionar o SE2
			If lFa430SE2 .and. !lProcDDA
				ExecBlock("FA430SE2", .F.,.F.,{aValores})
			Else
		   		// Se processa todas as filiais, tem o novo indice somente por IDCNAB e a filial da SE2 estah preenchida.
				If (mv_par11 == 2 .And. lNewIndice) .and. !Empty(xFilial("SE2"))
					//Busca por IdCnab (sem filial)
					SE2->(dbSetOrder(13)) // IdCnab
					If SE2->(MsSeek(Substr(cNumTit,1,10)))
						cFilAnt	:= SE2->E2_FILIAL
						If lCtbExcl
							mv_par09 := 2  //Desligo contabilizacao on-line				
						EndIf	
					Endif
				Else
					//Busca por IdCnab
					SE2->(dbSetOrder(11)) // Filial+IdCnab
					SE2->(MsSeek(xFilial("SE2")+	Substr(cNumTit,1,10)))
				Endif
	
				//Se nao achou, utiliza metodo antigo (titulo)
				If SE2->(!Found())
					SE2->(dbSetOrder(1))
					//Chave retornada pelo banco
					cChave430 := IIf(!Empty(cForne),Pad(cNumTit,nTamTit)+cEspecie+SubStr(cForne,1,nTamForn),Pad(cNumTit,nTamTit)+cEspecie)
					While !lAchouTit
						If !dbSeek(xFilial()+cChave430)
							nPos := Ascan(aTabela, {|aVal|aVal[1] == AllTrim(Substr(cTipo,1,3))},nPos+1)
							If nPos != 0
								cEspecie := aTabela[nPos][2]
								cChave430 := IIf(!Empty(cForne),Pad(cNumTit,nTamTit)+cEspecie+SubStr(cForne,1,nTamForn),Pad(cNumTit,nTamTit)+cEspecie)
							Else
								Exit
							Endif
						Else
							lAchouTit := .T.
						Endif
					Enddo					
	
					//Chave retornada pelo banco com a adicao de espacos para tratar chave enviada ao banco com
					//tamanho de nota de 6 posicoes e retornada quando o tamanho da nota e 9 (atual)
					If !lAchouTit
						cNumTit := SubStr(cNumTit,1,nTamPre)+Padr(Substr(cNumTit,4,6),nTamNum)+SubStr(cNumTit,10,nTamPar)					
						cChave430 := IIf(!Empty(cForne),Pad(cNumTit,nTamTit)+cEspecie+SubStr(cForne,1,nTamForn),Pad(cNumTit,nTamTit)+cEspecie)
						nPos := Ascan(aTabela, {|aVal|aVal[1] == Alltrim(Substr(cTipo,1,3))})
						While !lAchouTit
							If !dbSeek(xFilial()+cChave430)
								nPos := Ascan(aTabela, {|aVal|aVal[1] == AllTrim(Substr(cTipo,1,3))},nPos+1)
								If nPos != 0
									cEspecie := aTabela[nPos][2]
									cChave430 := IIf(!Empty(cForne),Pad(cNumTit,nTamTit)+cEspecie+SubStr(cForne,1,nTamForn),Pad(cNumTit,nTamTit)+cEspecie)
								Else
									Exit
								Endif					
							Else
								lAchouTit := .T.
							Endif
						Enddo
					Endif
	
					//Se achou o titulo, verificar o CGC do fornecedor
					If lAchouTit
						cNumSe2   := SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO
						cChaveSe2 := IIf(!Empty(cForne),cNumSe2+SE2->E2_FORNECE,cNumSe2)
						nPosEsp	  := nPos	// Gravo nPos para volta-lo ao valor inicial, caso encontre o titulo
	
						While !Eof() .and. SE2->E2_FILIAL+cChaveSe2 == xFilial("SE2")+cChave430
							nPos := nPosEsp
							If Empty(cCgc)
								Exit
							Endif
							dbSelectArea("SA2")
							If dbSeek(xFilial()+SE2->E2_FORNECE+SE2->E2_LOJA)
								If Substr(SA2->A2_CGC,1,14) == cCGC .or. StrZero(Val(SA2->A2_CGC),14,0) == StrZero(Val(cCGC),14,0)
									Exit
								Endif
							Endif
							dbSelectArea("SE2")
							dbSkip()
							cNumSe2   := SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO
							cChaveSe2 := IIf(!Empty(cForne),cNumSe2+SE2->E2_FORNECE,cNumSe2)
							nPos 	  := 0
						Enddo
					EndIF
				Else
					nPos := 1
				Endif
			
				If nPos == 0
					lHelp := .T.
				EndIF
			Endif	
			
			If !lUmHelp .And. lHelp
				if ! lExecJob
					Help(" ",1,"NOESPECIE",,cNumTit+	" "+cEspecie,5,1)
				Endif
					
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza o log de processamento com o erro  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				ProcLogAtu("ERRO","NOESPECIE",Ap5GetHelp("NOESPECIE"))
	
				lUmHelp := .T.
			Endif
		Endif

		// Retorno Automatico via Job
		// controla o status para emissao do relatorio de processamento
		if ExecSchedule()
			cStProc := ""   
			if ! lAchouTit
				cStProc := "Titulo Inexistente"   
		     	Aadd(aFa205R,{cNumTit,"", "", dBaixa,	0, nValPgto, cStProc })
			Elseif lHelp
				cStProc := "Titulo com Erro"
			Endif
		Endif		

		If !lHelp
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica codigo da ocorrencia ³
	 		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SEB")
			dbSetOrder(1)
			If !(dbSeek(xFilial("SEB")+mv_par05+cOcorr+"P"))
				if ! lExecJob
					Help(" ",1,"FA430OCORR")
				Endif
					
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza o log de processamento com o erro  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				ProcLogAtu("ERRO","FA430OCORR",Ap5GetHelp("FA430OCORR"))
	
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Reposicionar o SEB para uma chave diferente, que considere³ 
			//³ tamb‚m, campos espec¡ficos criados no SEB.                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lFa430Oco
				ExecBlock("FA430OCO", .F., .F., {aValores})
			Endif
			dbSelectArea("SE2")
			IF ( SEB->EB_OCORR $ "01#06#07#08" )      //Baixa do Titulo
				IF nF == 0
					nF:=1
					cPadrao:="530"
					lPadrao:=VerPadrao(cPadrao)
					lContabiliza:= Iif(mv_par09==1,.T.,.F.)
				Endif
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Monta Contabilizacao.         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !lCabec .and. lPadrao .and. lContabiliza
					nHdlPrv := HeadProva( cLote,;
					                      "FINA430",;
					                      substr( cUsuario, 7, 6 ),;
					                      @cArquivo )

					lCabec := .T.
				EndIf

				nValEstrang := SE2->E2_SALDO
				lDesconto   := .F.
				nTotAbat	:= SumAbatPag(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,;
								SE2->E2_FORNECE,SE2->E2_MOEDA,"S",dBaixa,SE2->E2_LOJA)
				ABATIMENTO  := nTotAbat

				If lAltPort
					dbSelectArea("SEA")
					dbSetOrder(1)
					dbSeek(xFilial()+SE2->E2_NUMBOR+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA)
					cBanco      := IiF(Empty(SEA->EA_PORTADOR),cBanco,SEA->EA_PORTADOR)
					cAgencia    := IiF(Empty(SEA->EA_AGEDEP),cAgencia,SEA->EA_AGEDEP)
					cConta      := IiF(Empty(SEA->EA_NUMCON),cConta,SEA->EA_NUMCON)
				ElseIf Empty(cBanco+cAgencia+cConta)
					cBanco      := mv_par05
					cAgencia    := mv_par06
					cConta      := mv_par07
				EndIf

				cHist070    := "Valor Pago s/ Titulo"
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se a despesa esta    ³
				//³ descontada do valor principal ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If SEE->EE_DESPCRD == "S"
					nValPgto+=nDespes
				EndIF
				nTotAger += nValPgto
				cLanca := Iif(mv_par09==1,"S","N")
				cBenef := SE2->E2_NOMFOR      
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Ponto de Entrada para Tratamento baixa           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ExistBlock("FA430LRM")
					ExecBlock("FA430LRM",.F.,.F.,{xBuffer})
				Endif
				
				If SE2->E2_TIPO $ MVPAGANT+"/"+MVTXA
					RecLock("SE5",.T.)
					SE5->E5_FILIAL	:= xFilial()
					SE5->E5_BANCO	:= cBanco
					SE5->E5_AGENCIA := cAgencia
					SE5->E5_CONTA	:= cConta
					SE5->E5_DATA	:= dBaixa
					SE5->E5_VALOR	:= SE2->E2_VLCRUZ
					SE5->E5_NATUREZ := SE2->E2_NATUREZ
					SE5->E5_RECPAG  := "P"
					SE5->E5_TIPO	:= IIF(SE2->E2_TIPO $ MVPAGANT,MVPAGANT,MVTXA)
					SE5->E5_TIPODOC := IIF(SE2->E2_TIPO $ MVPAGANT,"PA","TXA")
					SE5->E5_HISTOR  := SE2->E2_HIST
					SE5->E5_BENEF   := cBenef // JBS - 26/08/2013 - Gravação do nome do Benenficiario -   SA2->A2_NOME
					SE5->E5_PREFIXO := SE2->E2_PREFIXO
					SE5->E5_NUMERO  := SE2->E2_NUM
					SE5->E5_PARCELA := SE2->E2_PARCELA
					SE5->E5_CLIFOR  := SE2->E2_FORNECE
					SE5->E5_LOJA	:= SE2->E2_LOJA
					SE5->E5_DTDIGIT := dDataBase
					SE5->E5_MOTBX	:= "NOR"
					SE5->E5_DTDISPO := SE5->E5_DATA
					SE5->E5_VLMOED2 := SE2->E2_VALOR
					
					If SPBInUse()
						SE5->E5_MODSPB		:= SE2->E2_MODSPB
					Endif
					
					If lUsaFlag // Armazena em aFlagCTB para atualizar no modulo Contabil
						aAdd( aFlagCTB, { "E5_LA", "S", "SE5", SE5->( RecNo() ), 0, 0, 0} )
					EndIf
					
					EVSalBco( cBanco,cAgencia,cConta,SE5->E5_DTDISPO,SE5->E5_VALOR,"-" )
					lBaixou := .T.
					lMovAdto := .T.
				Else
					// Serao usadas na Fa080Grv para gravar a baixa do titulo, considerando os acrescimos e decrescimos
					nAcresc     := Round(NoRound(xMoeda(SE2->E2_SDACRES,SE2->E2_MOEDA,1,dBaixa,3),3),2)
					nDecresc    := Round(NoRound(xMoeda(SE2->E2_SDDECRE,SE2->E2_MOEDA,1,dBaixa,3),3),2)
					
					nDescont := nDescont - nDecresc
					nJuros	:= nJuros - nAcresc
				
		        	lBaixou:=EV080Grv(lPadrao,.F.,.T.,cLanca, mv_par03) // cArqEnt)  // Retorno Automatico via Job
		        	lMovAdto := .F.
				EndIf

				// Retorno Automatico via Job
				// armazena os dados do titulo para emissao de relatorio de processamento
				If ExecSchedule()
					if lBaixou
			      		Aadd(aFa205R,{SE2->E2_NUM,	SE2->E2_FORNECE,SE2->E2_LOJA,dBaixa,SE2->E2_VALOR, nValPgto, "Baixado ok" })
			  		Else
			      		Aadd(aFa205R,{SE2->E2_NUM,	SE2->E2_FORNECE,SE2->E2_LOJA,dBaixa,SE2->E2_VALOR, nValPgto, cStProc })
					Endif
		     	Endif
				
				If lBaixou .and. !lMovAdto		// somente gera pro lote quando nao for PA para nao duplicar no Extrato 
					dbSelectArea("TRB")
					If !(dbSeek(xFilial("SE5")+cBanco+cAgencia+cConta+Dtos(dDebito)))
						Reclock("TRB",.T.)
						Replace FILMOV		With xFilial("SE5")
						Replace BANCO		With cBanco
						Replace AGENCIA	With cAgencia					
						Replace CONTA		With cConta						
						Replace DATAD		With dDebito
					Else
						Reclock("TRB",.F.)
					Endif
					Replace TOTAL WITH TOTAL + nValPgto
					MsUnlock()
					lRET := .T.
		    	Endif
				
				If lF430Baixa
					Execblock("F430BXA",.F.,.F.)
				Endif 
				
				//Contabiliza Rateio Multinatureza
				If lMultNat .and. (SE2->E2_MULTNAT == "1")
					MultNatB("SE2", .F., "1", @lOk, @aColsSEV, @lMultNat, .T.)
					If lOk
						MultNatC("SE2", @nHdlPrv, @nTotal,;
						@cArquivo, (mv_par09 == 1), .T., "1",;
						@nTotLtEZ, lOk, aColsSEV, lBaixou)
					Endif
				Else
				  	//Contabiliza o que nao possuir rateio multinatureza					
					If lCabec .and. lPadrao .and. lContabiliza .and. lBaixou
						nTotal += DetProva( nHdlPrv,;
						                    cPadrao,;
						                    "FINA430" /*cPrograma*/,;
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
					EndIf
				Endif
			EndIf
			
			If ( SEB->EB_OCORR $ "03" )      //Titulo Rejeitado
				dbSelectArea("SE2")
				dbSetOrder(11)  // Filial+IdCnab
				If !DbSeek(xFilial("SE2")+	Substr(cNumTit,1,nTamTit))
					dbSetOrder(1)
					dbSeek(xFilial()+Pad(cNumTit,nTamTit)+cEspecie) // Filial+Prefixo+Numero+Parcela+Tipo
				Endif
				cFilAux := cFilAnt
				cFilAnt := cFilOrig //Restauro a filial de origem que estava logada para posicionar o borderô correto
				dbSelectArea("SEA")
				dbSetOrder(1)
				dbSeek(xFilial()+SE2->E2_NUMBOR+SE2->E2_PREFIXO+;
				SE2->E2_NUM+SE2->E2_PARCELA+;
				SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA)
				If ( Found() .And. SE2->E2_SALDO != 0 )
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ PONTO DE ENTRADA F430REJ                                     ³
					//³ Tratamento de dados de titulo rejeitado antes de "zerar" os 	³
					//³ dados do mesmo.                                               ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lF430Rej 
						Execblock("F430REJ",.F.,.F.)
					Endif	
					RecLock( "SE2" )
					SE2->E2_NUMBOR := Space(6)
					SE2->E2_PORTADO := Space(Len(SE2->E2_PORTADO))
					MsUnlock( )
					dbSelectArea("SEA")
					RecLock("SEA",.F.,.T.)
					dbDelete()
					MsUnlock( )
					cFilAnt := cFilAux
				EndIf
			EndIf

			//DDA - Debito Direto Autorizado
			If lUsaDDA .and. lProcDDA .and. SEB->EB_OCORR $ "02"      //Entrada de titulo via DDA
                      
				// Ponto de entrada para permitir alteracoes no CGC antes de posicionar o fornecedor
				// para gravacao de dados na tabela FIG                         
				If lFA430FIG				
					dbSelectArea("SA2")
					dbSetOrder(3)	
									
					if !Empty(cCGC)
						If MsSeek(xFilial("SA2")+cCGC)
							cCodForn := SA2->A2_COD
						EndIf								
					EndIf	
					
					cQuery := "SELECT SE2.E2_PREFIXO,SE2.E2_NUM,SE2.E2_PARCELA,SE2.E2_FORNECE,SE2.E2_LOJA FROM " + RetSqlName("SE2") + " SE2 " 
					cQuery += "WHERE SE2.E2_NUM = '" + cNumTit + "' AND SE2.E2_FORNECE = '" + SA2->A2_COD + "' AND SE2.D_E_L_E_T_ <> '*'" 				
					cQuery := ChangeQuery(cQuery)
					dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasTmp, .F., .T. )
					(cAliasTmp)->(DbGotop())
								
					cCGC := ExecBlock( "FA430FIG", .F., .F., { cCGC, cCodForn,(cAliasTmp)->E2_PREFIXO,cNumTit,(cAliasTmp)->E2_PARCELA})
					(cAliasTmp)->(DbCloseArea())
				EndIf

				//Posiciona cadastro de fornecedores para obter
				//- Codigo do Fornecedor
				//- Loja do Fornecedor
				//Caso nao encontre os dados do Fornecedor, os dados ficarao em branco
				//Para que o usuario possa visualizar esta falha de cadastro.
				dbSelectArea("SA2")
				dbSetOrder(3)
				MsSeek(xFilial()+cCGC)

				//Grava arquivo de conciliação DDA
				RecLock("FIG",.T.)
				FIG_FILIAL	:= xFilial("FIG") 
				FIG_DATA	:= dDataBase
				FIG_FORNEC	:= SA2->A2_COD
				FIG_LOJA	:= SA2->A2_LOJA
				FIG_NOMFOR	:= SA2->A2_NREDUZ
				FIG_TITULO	:= cNumTit
				FIG_TIPO	:= cEspecie
				FIG_VENCTO	:= dBaixa
				FIG_VALOR	:= nValPgto
				FIG_CONCIL	:= "2"
				FIG_CNPJ	:= cCGC
				FIG_CODBAR	:= cCodBar
				MsUnlock()
			Endif
			
			//Ponto de entrada para gravar na tabela fig a filial pertecente ao cnpj da linha header contido do arquivo .ret
			If lF430GRAFIL .AND. !Empty(cCGCFilHeader)
				aAreaCorr := GetArea()		
				DbSelectArea("SM0")
				SM0->(DbGoTop())
				
				While SM0->( !Eof() )
					if (cCGCFilHeader == SM0->M0_CGC)
						ExecBlock( "F430GRAFIL", .F., .F., SM0->M0_CODFIL)
						Exit												
					EndIf 
					SM0->( DbSkip() )
				EndDo		
										
				RestArea(aAreaCorr)				
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Integracao protheus X tin	³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If FindFunction( "GETROTINTEG" ) .and. FWHasEAI("FINA080",,,.T.)
			    ALTERA := .T.
			    INCLUI := .F.
				FwIntegDef( 'FINA080' )
			Endif

		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		// A funcao ReadCnab2 se encarrega de incrementar a leitura, portanto
		// a incrementacao so devera ser feita no caso do CNAB "1"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿		
		If mv_par10 == 1
			nLidos+=nBloco
		EndIf
	EndDo
	
	cFilAnt := cFilOrig		// Sempre restaura a filial original 
	
	If lCabec .and. lPadrao .and. lContabiliza 
		dbSelectArea("SE2")
		dbGoBottom()
		dbSkip()
		VALOR := nTotAger
		ABATIMENTO := 0
		nTotal += DetProva( nHdlPrv,;
		                    cPadrao,;
		                    "FINA430" /*cPrograma*/,;
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
	
	IF lPadrao .and. lContabiliza .and. lCabec
		RodaProva(  nHdlPrv,;
					nTotal )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Envia para Lancamento Contabil                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lDigita:=IIF(mv_par01==1,.T.,.F.)
		lAglut :=IIF(mv_par02==1,.T.,.F.)
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
	End
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ponto de entrada para renomear arquivo de retorno   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF (ExistBlock("FA430REN"))
		FCLOSE(nHdlBco)
		ExecBlock("FA430REN",.f.,.f.)
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava no SEE o n£mero do £ltimo lote recebido e gera ³
	//³ movimentacao bancaria											³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(cLoteFin) .and. GetMv("MV_BXCNAB") == "S"
		If TRB->(Reccount()) > 0
			RecLock("SEE",.F.)
			SEE->EE_LOTECP := cLoteFin
			MsUnLock()
			dbSelectArea("TRB")
			dbGotop()
			While !Eof()
				cFilAnt := TRB->FILMOV
				Reclock( "SE5" , .T. )
				SE5->E5_FILIAL := xFilial()
				SE5->E5_DATA   := TRB->DATAD
				SE5->E5_VALOR  := TRB->TOTAL
				SE5->E5_RECPAG := "P"
				SE5->E5_DTDIGIT:= TRB->DATAD
				SE5->E5_BANCO  := TRB->BANCO
				SE5->E5_AGENCIA:= TRB->AGENCIA
				SE5->E5_CONTA  := TRB->CONTA
				SE5->E5_DTDISPO:= TRB->DATAD
				SE5->E5_LOTE   := cLoteFin
				SE5->E5_HISTOR := "Baixa por Retorno CNAB / Lote :" + cLoteFin // 
				If SpbInUse()
					SE5->E5_MODSPB := "1"
				Endif
				MsUnlock()
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza saldo bancario.      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				EVSalBco(TRB->BANCO,TRB->AGENCIA,TRB->CONTA,SE5->E5_DATA,SE5->E5_VALOR,"-")
				dbSelectArea("TRB")
				dbSkip()
			Enddo
		Endif	
	EndIf
	
	End Transaction

	
	dbSelectArea("TRB")
	dbCloseArea()
	Ferase(cNomeArq+GetDBExtension())		// Elimina arquivos de Trabalho
	Ferase(cNomeArq+OrdBagExt())			// Elimina arquivos de Trabalho
	
	VALOR := 0
	dbSelectArea( cAlias )
	dbGoTo( nSavRecno )

	IF lF430COMP
		ExecBlock("F430COMP",.f.,.f.)
	EndIF 
	
EndIf
	
cFilAnt := cFilOrig		// Sempre restaura a filial original

Return lBaixou





/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ EVSalBco ³ Autor ³ Valdemir / Eduardo    ³ Data ³ 16/04/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Func„o para atualiza‡„o do saldo bancario				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ EVSalBco() 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ EV Solucoes Inteligentes 								  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function EVSalBco( cBanco, cAgencia, cConta, dData, nValor, cSinal,lReconc , lSalatu)
Local cAlias      := Alias()
Local nRecNo      := 0
Local lAppEnd     :=.f.
Local nSalIni     :=0
Local cMoeda 	  := "  "
Local nRecBco     := SA6->(Recno())
Local nSalIniRec  :=0
Local lFINMod9710 := FindFunction("FINMod9710")

Default lReconc  := .F.  //Atualiza saldo concilialdo
Default lSalAtu  := .T.  //Atualiza saldo principal Atual

If Empty(cBanco)
	Return
EndIf

DbSelectArea( "SA6" )
DbSetOrder(1)
If !(DbSeek( xFilial("SA6")+cBanco+cAgencia+cConta ) )
	Reclock( "SA6", .T. )
	SA6 -> A6_FILIAL := xFilial("SA6")
	SA6 -> A6_COD	  := cBanco
	SA6 -> A6_AGENCIA:= cAgencia
	SA6 -> A6_NUMCON := cConta
	SA6 -> A6_NOME   := "."
	SA6 -> A6_NREDUZ := "."
	SA6 -> A6_MOEDA  := 1
	
	IF SA6 -> (FIELDPOS("A6_DV")) > 0
		SA6 -> A6_DV := IIF(lFINMod9710,FINMod9710( cBanco + cAgencia + cConta ),"")
	ENDIF

	MsUnlock()
Endif

cMoeda := STR(MAX(SA6->A6_MOEDA,1),2)

DbSelectArea("SE8")
DbSetOrder(1)
DbSeek(xFilial("SE8")+cBanco+cAgencia+cConta+DtoS(dData),.t.)
If E8_DTSALAT != dData .or. Eof() .or. E8_BANCO+E8_AGENCIA+E8_CONTA != cBanco+cAgencia+cConta
	lAppEnd := .t.
	DbSkip(-1)
	If E8_FILIAL+E8_BANCO+E8_AGENCIA+E8_CONTA == xFIlial()+cBanco+cAgencia+cConta .and. dData >= SE8->E8_DTSALAT
		nSalIni    := E8_SALATUA
		nSalIniRec := E8_SALRECO
	Else
		nSalIni    := 0
		nSalIniRec := 0
	EndIf
Else
	nSalIni := E8_SALATUA
	nSalIniRec := E8_SALRECO
EndIf
RecLock("SE8",lAppEnd)
If lAppEnd
	SE8 -> E8_FILIAL := xFilial("SE8")
	SE8 -> E8_BANCO	:= cBanco
	SE8 -> E8_AGENCIA:= cAgencia
	SE8 -> E8_CONTA	:= cConta
	SE8 -> E8_DTSALAT:= dData
EndIf
If lSalAtu
	SE8->E8_SALATUA := nSalini + (Iif(cSinal=="+",nValor,nValor*-1))
Endif
If lReconc
	SE8->E8_SALRECO := nSaliniRec + (Iif(cSinal=="+",nValor,nValor*-1))
ElseIf SE8->E8_SALRECO == 0
	SE8->E8_SALRECO := nSaliniRec		
Endif  

SE8 -> E8_MOEDA  := cMoeda

MsUnlock()
nRecNo := RecNo()
DbSkip()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recalcula os saldos do diante em diante, se necess rio. 	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While !Eof().and.E8_FILIAL==xFilial("SE8").and.E8_BANCO+E8_AGENCIA+E8_CONTA==cBanco+cAgencia+cConta
	Reclock("SE8")
	nRecNo := RecNo()
	If cSinal == "+"
		If lSalAtu  //Atualizo todos os saldos
			SE8->E8_SALATUA += nValor
		Endif
		If lReconc
			SE8->E8_SALRECO += nValor		
		Endif	
	Else
		If lSalAtu  //Atualizo todos os saldos
			SE8->E8_SALATUA -= nValor
		Endif
		If lReconc
			SE8->E8_SALRECO -= nValor		
		Endif	
	Endif
	MsUnlock()
	DbSkip()
End
DbGoTo(nRecNo)
Reclock("SA6")
SA6->A6_SALATU  := SE8->E8_SALATUA
MsUnlock()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de Entrada para Reconciliacao Bancaria					  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (ExistBlock( "FAATUBCO" ) )
	ExecBlock("FAATUBCO",.F.,.F.)
EndIf

SA6->(DbGoTo(nRecBco))   // Reposiciona no Banco da entrada da funcao
DbSelectArea( cAlias ) 

Return




/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ExecSchedule³ Autor ³ Aldo Barbosa dos Santos      ³21/12/10³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Retorna se o programa esta sendo executado via schedule     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ExecSchedule()
Local lRetorno := .T.

lRetorno := IsBlind()

Return( lRetorno )



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	  ³ fA080Grv ³ Autor ³ Wagner Xavier 		 ³ Data ³ 26/05/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o  ³ Fun‡„o utilizada para atualizar a baixa efetuada		   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	  ³ fA080Grv(lPadraoBx,PadraoVd)		                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso	  	  ³ Generico 												   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador³ Data   ³ BOPS ³  Motivo da Alteracao                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Pedro Lima |10/12/07³137418³ Correcao para baixa de PA com ratio de Mult³±±
±±³  TI6434   |        ³ V912 ³ naturezas.                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/					    
Static Function EV080Grv(lPadraoBx,lPadraoVd,lCNAB,cLanca,cArqEnt,nTxMoeda,dDebito,nVlImpPCC,lMultNat,lUsaFlag)
Local nSaldo
Local i
Local cTpDoc:=""
Local cHistMov:=""
Local cNum
Local cPrefixo
Local cParcela
Local nSalvRec
Local cFornece
Local nRecNo:=0
Local lAdiantamento := .f.
Local nTamSeq 		:= TamSX3("E5_SEQ")[1]
Local cSequencia 	:= Replicate("0",nTamSeq)
Local aTipoSeq 		:= {}
Local lFina390 		:= Iif(SE2->E2_IMPCHEQ == "S",.T.,.F.)
Local lFa080VIR		:= ExistBlock("FA080VIR")
Local cChave_EF	
Local nOrdbx
Local nAtraso 		:= 0
Local nToler 		:= SuperGetMv("MV_TOLERCP",.F.,0)
Local lMovBcoBx 	:= .T.
Local lSpbInUse 	:= SpbInUse()
Local lSE5FI080 	:= ExistBlock("SE5FI080")
Local nLaco
Local lAcreDecre 	:= .F.
Local cModRetPIS 	:= GetNewPar( "MV_RT10925", "1" ) 
Local cGeraDirf  	:= ""
Local aArea
Local cChave		:= ""
//Considero juros multa ou desconto na base do imposto.
// 1 = Considera valores juros multa ou desconto
// 2 = Nao considera valores juros multa ou desconto
Local lJurMulDes := (SuperGetMv("MV_IMPBAIX",.t.,"2") == "1")
Local lContrRet := !Empty( SE2->( FieldPos( "E2_VRETPIS" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE2->( FieldPos( "E2_VRETCSL" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETPIS" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_PRETCOF" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETCSL" ) ) )

Local lPCCBaixa := SuperGetMv("MV_BX10925",.T.,"2") == "1"  .and. (!Empty( SE5->( FieldPos( "E5_VRETPIS" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_VRETCOF" ) ) ) .And. ; 
				 !Empty( SE5->( FieldPos( "E5_VRETCSL" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETPIS" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_PRETCOF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETCSL" ) ) ) .And. ;
				 !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. !Empty( SFQ->( FieldPos( "FQ_SEQDES"  ) ) ) )


Local nVlMinImp := GetNewPar("MV_VL10925",5000)
Local nSavRec := 0
Local lRetParc := .T.
Local aRecnos := {}
Local aRecSFQ := {}
Local nLoop := 0
Local cPrefOri  := SE2->E2_PREFIXO
Local cNumOri   := SE2->E2_NUM
Local cParcOri  := SE2->E2_PARCELA
Local cTipoOri  := SE2->E2_TIPO
Local cCfOri    := SE2->E2_FORNECE
Local cLojaOri  := SE2->E2_LOJA
Local nMoedaBco := Max( MoedaBco(cBanco,cAgencia,cConta), 1 )
Local nMoedaTit := SE2->E2_MOEDA
Local nTxModBco := If( cPaisLoc<>"BRA", aTxMoedas[Max(nMoedaBco		,1)][2]	, 0 )
Local nTxModTit := If( cPaisLoc<>"BRA", aTxMoedas[Max(SE2->E2_MOEDA	,1)][2]	, 0 )

Local lBaseSE2 := SuperGetMv("MV_BS10925",.T.,"1") == "1"  .and. ;
						(	!Empty( SE1->( FieldPos( "E1_BASEPIS" ) ) ) .And.;
							!Empty( SE1->( FieldPos( "E1_BASECOF" ) ) ) .And. ; 
							!Empty( SE1->( FieldPos( "E1_BASECSL" ) ) ) .And. ; 
							!Empty( SE2->( FieldPos( "E2_BASEPIS" ) ) ) .And.;
							!Empty( SE2->( FieldPos( "E2_BASECOF" ) ) ) .And. ; 
							!Empty( SE2->( FieldPos( "E2_BASECSL" ) ) )	)

Local nBaseRet := 0  //Base de retencao                    

//1-Cria NCC/NDF referente a diferenca de impostos entre emitidos (SE2) e retidos (SE5)
//2-Nao Cria NCC/NDF, ou seja, controla a diferenca num proximo titulo
//3-Nao Controla
Local cNccRet  := SuperGetMv("MV_NCCRET",.F.,"1")

Local lSest := SE2->(FieldPos("E2_SEST"))	> 0  //Verifica campo de SEST

Local lIRPFBaixa := IIf( ! Empty( SA2->( FieldPos( "A2_CALCIRF" ) ) ), SA2->A2_CALCIRF == "2", .F.) .And. ;
				 !Empty( SE2->( FieldPos( "E2_VRETIRF" ) ) ) .And. !Empty( SE2->( FieldPos( "E2_PRETIRF" ) ) ) .And. ;
				 !Empty( SE5->( FieldPos( "E5_VRETIRF" ) ) ) .And. !Empty( SE5->( FieldPos( "E5_PRETIRF" ) ) ) .And. ;
				 !SE2->E2_TIPO $ MVPAGANT

Local lAplVlMin := .T.
Local lRetManual:= .F.
Local cSeqCheque	:= Replicate("0",TamSX3("EF_SEQUENC")[1])
Local cContabiliza := GETMV("MV_CTBAIXA")
Local lCalcIssBx :=	IIf( ! Empty( SA2->( FieldPos( "A2_TIPO" ) ) ),Posicione("SA2",1,xFilial("SA2")+SE2->(E2_FORNECE+E2_LOJA),"A2_TIPO") == "J", .F.) .And.;
					!Empty( SE5->( FieldPos( "E5_VRETISS" ) ) ) .and. !Empty( SE2->( FieldPos( "E2_SEQBX"   ) ) ) .And. ;
					!Empty( SE2->( FieldPos( "E2_TRETISS" ) ) ) .and. GetNewPar("MV_MRETISS","1") == "2" //Retencao do ISS pela emissao (1) ou baixa (2)

Local lLibCheq := GetMv("MV_LIBCHEQ") == "S"
Local nRegSEF := 0
Local lBordero   := If (lContrRet,(SE2->E2_PRETPIS = '4' .OR. SE2->E2_PRETCOF = '4' .OR. SE2->E2_PRETCSL = '4') .And.;
				 				!Empty(SE2->E2_NUMBOR),.F.)

Local lBaseIRPF	:= If (FindFunction('F050BIRPF'),F050BIRPF(2),.F.)

Local nCentMd1	:= MsDecimais(1)
Local lAtuSldNat := FindFunction("AtuSldNat") .AND. AliasInDic("FIV") .AND. AliasInDic("FIW")
Local lTpDesc		:= SE5->(FieldPos("E5_TPDESC"))	> 0 //Verifica campo TPDESC na tabela SE5 (<C>ondicional ou <I>ncondicional)
Local lGerTXBord := .T. // .T. nao gerou os TX na geracao do bordero
Local aAreaSE2 := {}
Local aAreaSE5 := {}
Local cChaveIR := ""
Local aAreaSA2 := {}
Local cFilter  := ""
Local lBdVcImp	:= SuperGetMV("MV_BDVCIMP",.T.,.F.)
Local lE5Orig		:= SE5->(FieldPos("E5_ORIGEM"))	> 0 //Verifica campo E5_ORIGEM na tabela SE5

Local lInssBx :=	SuperGetMv("MV_INSBXCP",.F.,"2") == "1"  .And.  ;  //Inss Baixa
				 		!Empty( SE5->( FieldPos( "E5_VRETINS" ) ) )  .And. !Empty( SE5->( FieldPos( "E5_PRETINS" ) ) )				 		               
Local nLimInss 	:= 	SuperGetMv("MV_LIMINSS",.F.,0)	 
	
Local nMinINS1 	:= SuperGetMv("MV_MININSS",.F.,0) 
Local nMinINS2 	:= SuperGetMv("MV_VLRETIN",.F.,0) 
Local lInsPub 		:=	SuperGetMv("MV_INSPUB",,.F.) .And. nMinINS1 == 0 .And.;
								nLimInss == 0 .And. nMinINS2 == 0 //Inss Baixa com empresa publica. Neste caso os valores do inss não tem valor minimo ou maximo de retencao.
	
Local cCodRetIr 	:= " "
Local cModSpb		:= "1"
Local nRecOld		:= 0
Local lAcmPJ 	 	:= SuperGetMv("MV_INSACPJ",.T.,"2") == "1"  //1 = Acumula    2= Não acumula
Local lAltInss	:=	.T.
Local aBaixa		:=	{}
Local lNotBax 	:= .F.
Local lAglImp  := .F. 
Local lFina379 := IsInCallStack("FINA379")
LOCAL nTotAdto 	:= 0
LOCAL lBaixaAbat	:= .F.
Local lBxCEC 		:= .F.  //Verificador de existencia de baixa por compensacao entre carteiras
Local nTotImpost 	:= 0  //Valores de baixas de por geracao de impostos
Local nTotaIRPF   := 0
Local lBxLiq	:= .F.	
Local nParciais	:=	0

//Ponto de entrada para deletar provisorios ao inves de baixa-los
Local lF50DelPr	:= ExistBlock("F50DELPR")         
Local lDelProvis	:= If(lF50DelPr, ExecBlock("F50DELPR",.F.,.F.), .F.)
Local lSubstPR	:= IsInCallStack("Fa050Subst")
Local cNccIr		:= SuperGetMv("MV_NCCIR",.F.,"2")
Local nDifIr		:= 0
Local nValNArred	:= 0
Local lBxTxa := SuperGetMv("MV_BXTXA",.F.,"1") == "1"
Local cTipoCM := GetMV("MV_TIPOCM")

cArqEnt  := Iif(cArqEnt==Nil," ",cArqEnt)		// Oriundo do Fina430 (Arquivo Cnab)
// feita por lote.
Private cTitOrig 
Private aBaixaSE5 := {}
Private lBdImp	:= .F.

Default dDebito		:= dBaixa
Default nVlImpPCC	:= 0
Default lMultNat	:= .F.
Default lUsaFlag	:= SuperGetMV( "MV_CTBFLAG" , .T. /*lHelp*/, .F. /*cPadrao*/ )
If lSpbInUse
	cModSpb := IIf(Empty(SE2->E2_MODSPB), "1",SE2->E2_MODSPB)
Endif

If Type("aDadosRet") == "U"
	aDadosRet := Array(7)
	aFill(aDadosRet,0)
Endif

//IRRF - BAIXA
If Type("aDadosIr") == "U"
	aDadosIR := Array(3)
	aFill(aDadosIR,0)
Endif

If Type("aRecnosSE2") == "U"
	aRecnosSE2 := {}
Endif      

If Type("cTpDesc") == "U"
	cTpDesc:="I"
Endif  

//se estiver sendo chamado via rotina automática a partir da compensação entre carteiras, 
//nao deve processar ISS E IR
If Funname() == "FINA450" .and. (Type("lF080Auto")<>"U" .and. lF080Auto)
	lCalcIssBx := .F.
EndIf

lCNAB		:= Iif(lCNAB==Nil,.F.,lCnab)
nOtrGa      := If (Type("nOtrGa") != "N",0,nOtrGa)
nDifCambio  := If (Type("nDifCambio") != "N",0,nDifCambio)
nImpSubst   := If (Type("nImpSubst") != "N",0,nImpSubst)
nAcresc     := If (Type("nAcresc") != "N",0,nAcresc)
nDecresc    := If (Type("nDecresc") != "N",0,nDecresc)
cModSpb		:= If (Type("cModSpb") != "C","1",cModSpb)
cAutentica	:= If (Type("cAutentica") != "C",Space(25),cAutentica)
nPis		:= If (Type("nPis") != "N",0,nPis)
nCofins		:= If (Type("nCofins") != "N",0,nCofins)
nCsll		:= If (Type("nCsll") != "N",0,nCsll)
nVlRetPis 	:= If (Type("nVlRetPis") != "N",0,nVlRetPis)
nVlRetCof 	:= If (Type("nVlRetCof") != "N",0,nVlRetCof)
nVlRetCsl	:= If (Type("nVlRetCsl") != "N",0,nVlRetCsl)
nDiferImp	:= If (Type("nDiferImp") != "N",0,nDiferImp)
nIrrf		:= If (Type("nIrrf") != "N",0,nIrrf)
nVlRetIrf 	:= If (Type("nVlRetIrf") != "N",0,nVlRetIrf)
nBaseIrpf 	:= If (Type("nBaseIrpf") != "N",0,nBaseIrpf)
nIss		:= If (Type("nIss") != "N",0,nIss)
nInss		:= If (Type("nInss") != "N",0,nInss)

If lCnab
	lPccBaixa := .F.
Endif

//Verificar ou nao o limite de 5000 para Pis cofins Csll
// 1 = Verifica o valor minimo de retencao
// 2 = Nao verifica o valor minimo de retencao
If !Empty( SE2->( FieldPos( "E2_APLVLMN" ) ) ) .and. SE2->E2_APLVLMN == "2"
	lAplVlMin := .F.
Endif	  
If lBaseSE2 .and. SE2->(E2_BASEPIS + E2_BASECOF + E2_BASECSL) > 0
	If (nValPgto+nPis+nCofins+nCsll+nIrrf+nIss+nDescont+nTotAbat-nJuros-nMulta) < If(!Empty(SE2->E2_BASEPIS),SE2->E2_BASEPIS,If(!Empty(SE2->E2_BASECOF),SE2->E2_BASECOF,SE2->E2_BASECSL))
		nBaseRet := nValPgto+nPis+nCofins+nCsll+nDescont+nTotAbat-nJuros-nMulta
		If !lInssBx
			nBaseRet += nInss
		EndIf		
		
		If !lIRPFBaixa
			nBaseRet += nIrrf
		EndIf
		
		If !lCalcIssBx
			nBaseRet += nIss
		EndIf
		
		If STR(nBaseRet,17,2) == STR(SE2->E2_SALDO,17,2)
			nBaseRet += Iif(!lInssBx,SE2->E2_INSS,0)
			If lSest
				nBaseRet += SE2->E2_SEST
			Endif
			
			If !lIRPFBaixa
				nBaseRet += SE2->(E2_IRRF+E2_ISS) 
			EndIf
	   Endif
	Else
		nBaseRet := If(!Empty(SE2->E2_BASEPIS),SE2->E2_BASEPIS,If(!Empty(SE2->E2_BASECOF),SE2->E2_BASECOF,SE2->E2_BASECSL))
	Endif
Else			
	nBaseRet := nValPgto+nPis+nCofins+nCsll+nIrrf+nIss+nDescont+nTotAbat-nJuros-nMulta
	If STR(nBaseRet,17,2) == STR(SE2->E2_SALDO,17,2)
		nBaseRet += SE2->E2_IRRF + SE2->E2_ISS 
		
		If !lInssBx 
			nBaseRet += SE2->E2_INSS 
		Endif
		If lSest
			nBaseRet += SE2->E2_SEST
		Endif
   Endif
Endif

DEFAULT nTxMoeda := 0
If SE2->E2_SALDO + SE2->E2_SDACRES == 0
	Return .f. /*Function fA080Grv*/
Endif

lGerouSef := .F.

//verifica se existem os campos de valores de acrescimo e decrescimo no SE5
If SE5->(FieldPos("E5_VLACRES")) > 0 .and. SE5->(FieldPos("E5_VLDECRE")) > 0
	lAcreDecre := .T.
	If  nAcresc > nValPgto .And. Funname() == "FINA450"
  		nAcresc	:= nValPgto   
 	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava Dados do Vendor										 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If TrazCodMot(cMotBx) == "VEN"
	Fa080GrVen( @cTitOrig, lPadraoVd, cLanca )
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza a baixa do titulo									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lIRPFBaixa .and. nValPgto < nIrrf .and. nValPgto != 0.01 .and. cNccIr == '1'
	nValPadrao := nValPgto
ElseIf lIRPFBaixa .and. nValPgto < nIrrf .and. cNccIr == '2' 
	If nValPgto == 0
		nValPadrao := SE2->E2_SALDO
	Else
		nValPadrao := nValPgto
	EndIf
Else
	nValPadrao := nValPgto- (Iif(SE2->E2_MOEDA<=1,nCM,0)+nJuros+nMulta-nDescont+nOtrga+nImpSubst+nAcresc-nDecresc-nPis-nCoFins-nCsll-nIrrf-nIss-Iif(lInssBx,nInss,0))
EndIf
*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³Verifica se saldo estava em outra moeda, caso estiver, converte valor ³
*³recebido pela taxa diaria da moeda									³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cPaisLoc<>"BRA"
	nMoedaBco:=Iif(nMoedaBco>0,nMoedaBco,1)
	nTxMoeda:=Iif (SE2->E2_MOEDA > 1 ,aTxMoedas[SE2->E2_MOEDA][2],aTxMoedas[nMoedaBco][2])
EndIF
If SE2->E2_MOEDA<=1
	nSaldo := Round(SE2->E2_SALDO-xMoeda(nValPadrao,nMoedaBco,SE2->E2_MOEDA,dBaixa,nCentMd1+1,,nTxMoeda),nCentMd1)
Else
    If nModulo == 17 //Baixa SIGAEIC
    	nSaldo := Round(NoRound(SE2->E2_SALDO-nValEstrang,nCentMd1+1),nCentMd1)
    Else
		If cPaisLoc == "BRA"
			//Caso ainda nao exista baixa
			nValNArred	:= Round(SE2->E2_VALOR * nTxMoeda,4)
			If SE2->E2_SALDO == SE2->E2_VALOR
				nSaldo := Round(NoRound(SE2->E2_SALDO-xMoeda(Iif(nValPgto < nValNArred,nValNArred,nValPadrao),nMoedaBco,SE2->E2_MOEDA,dBaixa,nCentMd1+1,,nTxMoeda),nCentMd1+1),nCentMd1)
			Else
				nSaldo := Round(NoRound(SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_NATUREZ,"P",SE2->E2_FORNECE,1,,,SE2->E2_LOJA,,nTxMoeda) - nValPadrao, nCentMd1+1),nCentMd1)
			Endif
		Else
			nSaldo := Round(NoRound(SE2->E2_SALDO-xMoeda(nValPadrao,nMoedaBco,SE2->E2_MOEDA,dBaixa,nCentMd1+1,,nTxMoeda),nCentMd1+1),nCentMd1)
		Endif
	EndIf
EndIf
//Verifico se existe tolerancia de pagamento
If nSaldo != 0 .and. nToler > 0
	//Pagamentos a menor
	If nToler > 0 .And. nSaldo > 0
		If nSaldo <= nToler
			nDescont += nSaldo
			nSaldo   := 0	
		EndIf
	//Pagamentos a maior
	ElseIf nToler > 0 .and. nSaldo < 0
		nJuros += Abs(nSaldo)
		nSaldo += Abs(nSaldo)
	Endif
Else
	If nSaldo >= 0.01
		If cPaisLoc <> "BRA" .And. SE2->E2_MOEDA<=1  
			nSaldo := Round(NoRound(SE2->E2_SALDO-xMoeda(nValPadrao,nMoedaBco,SE2->E2_MOEDA,dBaixa,nCentMd1+1,nTxMoeda),nCentMd1+1),nCentMd1)
		Else		
			nSaldo := Round(NoRound(SE2->E2_SALDO-xMoeda(nValPadrao,nMoedaBco,SE2->E2_MOEDA,dBaixa,nCentMd1+1,,nTxMoeda),nCentMd1+1),nCentMd1)
		EndIf	
	Else
		nSaldo := 0
	Endif
Endif	

If SE2->E2_MOEDA > 1
	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³For‡a saldo = 0 quando diferen‡a == 0.01 por problema de arredondamento³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Round(NoRound(nSaldo,3),2) <= 0.01
		nSaldo := 0
	Endif
Endif

If lAtuSldNat
	// Caso seja a baixa do titulo provisório em sua subistituição não deve-se atualizar o saldo da natureza
	If !(lSubstPR .And. !lDelProvis) .And. !lMultNat
		// Nao precisa atualizar a baixa dos abatimentos, pois o valor pago jah eh liquido dos abatimentos
		AtuSldNat(SE2->E2_NATUREZ, dBaixa, SE2->E2_MOEDA, "3", "P", Iif(SE2->E2_MOEDA > 1, nValEstrang, nValpgto),Iif(SE2->E2_MOEDA > 1, nValpgto, nValEstrang) , If(SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG,"-","+"),,FunName(),"SE2",SE2->(Recno()),0)	
	EndIf
Endif

If !(SE2->E2_TIPO $ MVTXA+"#"+MVPAGANT+"#"+"INA") .or. (SE2->E2_TIPO $ MVTXA+"#"+MVPAGANT .and. lBxTxa) //Não atualiza os campos de baixa no SE2 para titulos de INSS Antecipado
	RecLock("SE2")
	nSE2Rec := Recno()
	SE2->E2_BAIXA	  := iif(SE2->E2_BAIXA <= dBaixa, dBaixa, SE2->E2_BAIXA)
	SE2->E2_LOTE	  := cLoteFin
	SE2->E2_MOVIMEN  := dBaixa
	SE2->E2_DESCONT  := nDescont + nDecresc
	SE2->E2_MULTA	  := nMulta
	If ( cPaisLoc != "BRA" )
		If SE2->E2_MOEDA<=1
			SE2->E2_VALLIQ := Round(NoRound(xMoeda(nValPgto,nMoedaBco,SE2->E2_MOEDA,dBaixa,nCentMd1+1,nTxMoeda),nCentMd1+1),nCentMd1)
		Else
			SE2->E2_VALLIQ :=Round(NoRound(xMoeda(nValPgto,nMoedaBco,SE2->E2_MOEDA,dBaixa,nCentMd1+1,,nTxMoeda),nCentMd1+1),nCentMd1)
		EndIf
	Else
	  If Type("lIntegracao")<>"U" .and. lIntegracao .And. cTipoCM =='T'
	  	SE2->E2_VALLIQ := nValTot
	  ELse
		SE2->E2_VALLIQ := nValpgto
	  Endif	
	Endif

	If  Round(NoRound(nValPgto,3),2) < Round(Noround(xMoeda(SE2->E2_SDACRES,SE2->E2_MOEDA,nMoedaBco,dDataBase,3,,nTxMoeda),3),2)
		If SE2->E2_MOEDA > 1 .And. nMoedaBco == 1 //Título em moeda estrangeira com banco em moeda 1
			SE2->E2_SDACRES  -= nValEstrang
		Else
			SE2->E2_SDACRES  -= nValPgto		
		EndIf
	Else
		SE2->E2_SDACRES  := 0
	EndIf
	
	SE2->E2_SDDECRE  := 0
	If cPaisLoc == "CHI"
		IIf (SE2->(FieldPos("E2_OTRGA"))  > 0,SE2->E2_OTRGA    := nOtrga,.T.)   
	   	IIf (SE2->(FieldPos("E2_CAMBIO")) > 0,SE2->E2_CAMBIO   := SE2->E2_CAMBIO + nDifCambio,.T.)        
	   	IIf (SE2->(FieldPos("E2_IMPSUBS")) > 0,SE2->E2_IMPSUBS := nImpSubst,.T.)
		SE2->E2_JUROS	:= nOtrga + nImpsubst
		SE2->E2_CORREC	:= nDifCambio   
	Else
		SE2->E2_JUROS	:= nJuros + nAcresc
		SE2->E2_CORREC	:= nCm
	EndIf
	If !Empty(cBanco)
		SE2->E2_BCOPAG   := cBanco
	Endif
	If !Empty(cCheque)
		SE2->E2_NUMBCO   := cCheque
	Endif
	//Para TOP limpa-se a marca.
	//Para Codebase gravo "xx" para manter o titulo no filtro e possibilitar contabilizacao
	//e baixa correta.
	#IFDEF TOP
		If TcSrvType() == "AS/400" .or. TcSrvType() == "iSeries"  //"iSeries" eh o retorno do Top4 para AS/400
			SE2->E2_OK		  := Iif(E2_OK==cMarca,"xx" ,E2_OK)	
		Else
			SE2->E2_OK		  := Iif(E2_OK==cMarca,"  " ,E2_OK)
		Endif
	#ELSE
		SE2->E2_OK		  := Iif(E2_OK==cMarca,"xx" ,E2_OK)
	#ENDIF

	If !Empty(cPortado)
		SE2->E2_PORTADO  := cPortado
	Endif
	If TrazCodMot(cMotBx) == "VEN"
		SE2->E2_TITORIG	:= cTitOrig
	Endif

	//Marco que o titulo tem os impostos calculados
	//pela baixa (Pis, Cofins e Csll)
	If lContrRet .And. lPCCBaixa .and. !(lBordero .and. nSaldo <> 0) 
		SE2->E2_PRETPIS := "3"
		SE2->E2_PRETCOF := "3"
		SE2->E2_PRETCSL := "3"
	Endif

	IF Str(nSaldo,16,2)=Str(nTotAbat,16,2)
		nSaldo := 0
	Endif
     
	//Verifica se existe solicitacao de NCP e caso exista atualiza o campo CU_DTBAIXA...
	If cPaisLoc <> "BRA" 
		A055AtuDtBx("1",SE2->E2_FORNECE,SE2->E2_LOJA,SE2->E2_NUM,SE2->E2_PREFIXO,SE2->E2_BAIXA)
	EndIf


	dbSelectArea("SE2")
	nSalvRec := SE2->( RecNo() )
	cNum	 := SE2->E2_NUM
	cPrefixo := SE2->E2_PREFIXO
	cParcela := SE2->E2_PARCELA
	cFornece := SE2->E2_FORNECE
	nOrdBx	 := IndexOrd()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Baixar titulos de abatimento se for baixa total				 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF nSaldo = 0
	
		//Atualiza status do adiantamento de viagem
		If (ALLTRIM(SE2->E2_ORIGEM) $ "FINA667|FINA677")
			FINATURES(SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA),.T.,SE2->E2_ORIGEM,"P")
		EndIf
		
		If Select("__SE2") == 0
		   ChkFile("SE2",.F.,"__SE2")
		Else
	  	   DbSelectArea("__SE2")
		EndIf
		dbSetOrder(1)
		dbSeek(xFilial("SE2")+cPrefixo+cNum+cParcela)
		While !EOF() .And. E2_FILIAL==xFilial("SE2") .And. E2_PREFIXO=cPrefixo .And. ;
				E2_NUM==cNum .And. E2_PARCELA==cParcela
			IF E2_TIPO $ MVABATIM .And. E2_FORNECE==cFornece
				RecLock("__SE2")
				Replace E2_SALDO		With 0
				Replace E2_BCOPAG		With cBanco
				Replace E2_BAIXA		With dBaixa
				Replace E2_LOTE		With cLoteFin
				Replace E2_MOVIMEN	With dBaixa
				Replace E2_SDACRES  With 0
				Replace E2_SDDECRE  With 0
			Endif
			dbSkip()
		Enddo
	Endif

	dbSelectArea("SE2")
	dbGoto(nSalvRec)
ElseIf !lBxTxa .and. SE2->E2_OK <> 'TA' 
	RecLock("SE2")	
	SE2->E2_OK := 'TA'			    		
	SE2->E2_BAIXA	  := iif(SE2->E2_BAIXA <= dBaixa, dBaixa, SE2->E2_BAIXA)
	MsUnlock()
EndIf

nSalvRec := SE2->( RecNo() )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada p/ alteracao da data de vencto do IR (Salvador) ³
//³ Guardo o Recno para caso o Rdmake nao retorne ao titulo baixado, ³
//³ o sistema force isto, evitando problemas na continuidade do pro- ³
//³ cesso de baixa do titulo.                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lFa080VIR .and. !Empty(SE2->E2_IRRF)
	nRecno := SE2->(Recno())
	Execblock("FA080VIR",.F.,.F.)
	dbGoTo(nRecno)
	nRecno := 0
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza a Movimentacao Bancaria							 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lIRPFBaixa .and. nValpgto < nIrrf
	nValPadrao:=nValPgto
Else
	nValPadrao:=nValPgto-(nJuros+nMulta+nAcresc)+(nDescont+nDecresc+nPis+nCoFins+nCsll+nIrrf+nIss) //Valor Original
EndIf
nJuros := nJuros + nAcresc
nDescont := nDescont + nDecresc
cSequencia 	:= Replicate("0",nTamSeq)

If SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG
	lAdiantamento := .t.
	fa080adiant( lPadraoBx, cLanca, nTxMoeda, lUsaFlag )
Endif

//Caso o titulo nao tenha impostos e os mesmos tenham sido digitados manualmente,
//altero variavel para gravacao dos titulos de impostos
If Empty(nVlImpPCC) .And. nPis+nCofins+nCsll > 0
	lRetManual := .T.
EndIf

If !lAdiantamento
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Para numerar as sequencias o sistema precisa procurar os   ³
	//³ registros com  tipodoc igual a vl ou ba.				   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aTipoSeq := { "VL","BA","CP" }
	dbSelectArea("SE5")
	SE5->(dbSetOrder(2))
	For nLaco := 1 to len(aTipoSeq)
		SE5->(dbSeek(xFilial("SE5") + aTipoSeq[nLaco] + SE2->E2_PREFIXO + SE2->E2_NUM + ;
			SE2->E2_PARCELA + SE2->E2_TIPO) )

		While !SE5->(Eof()) .And. ;
				SE5->E5_FILIAL == xFilial("SE5") .And. ;
				SE5->E5_TIPODOC == aTipoSeq[nLaco] .And. ;
				SE5->E5_PREFIXO == SE2->E2_PREFIXO .And. ;
				SE5->E5_NUMERO == SE2->E2_NUM .And. ;
				SE5->E5_PARCELA == SE2->E2_PARCELA .And. ;
				SE5->E5_TIPO == SE2->E2_TIPO

			If SE5->(E5_CLIFOR+E5_LOJA) == SE2->(E2_FORNECE+SE2->E2_LOJA)
				If PadL(AllTrim(cSequencia),nTamSeq,"0") < PadL(AllTrim(SE5->E5_SEQ),nTamSeq,"0")
					cSequencia := SE5->E5_SEQ
				EndIf
			EndIf

			SE5->( dbSkip() )
		Enddo
	Next
	If Len(cSequencia) < nTamSeq
		cSequencia := PadL(cSequencia,nTamSeq,"0")
	Endif
	cSequencia := Soma1(cSequencia,nTamSeq)
	For i:=1 To 6
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza a Movimentacao Bancaria 							 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF i==1
			cCpoTp := "nDescont"
			cTpDoc := "DC"
			cHistMov := OemToAnsi( "Desconto s/Pgto de Titulo" ) //
		Elseif i==2
			cCpoTp := IIf(cPaisLoc<>"CHI","nJuros","nOtrga")
			cTpDoc := "JR"
			cHistMov := OemToAnsi( "Juros s/Pgto de Titulo" ) //
		Elseif i==3
			cCpoTp := "nMulta"
			cTpDoc := "MT"
			cHistMov := OemToAnsi( "Multa s/Pgto de Titulo" ) //
		Elseif i==4
			cCpoTp := IIf(cPaisLoc<>"CHI","nCM","nDifCambio")
			cTpDoc := "CM"
			cHistMov := OemToAnsi( "Correcao Monet s/Pgto de Titulo" ) //
		Elseif i==5
			cCpoTp := "nImpSubst"
			cTpDoc := "IS"
			cHistMov := OemToAnsi( "Juros s/Pgto de Titulo" ) //
		Elseif i==6
		   If Type("lIntegracao")<>"U" .and. lIntegracao .and. Type("nValEIC")<>"U" .And. cTipoCM =='T'
		   		cCpoTp := "nValEIC"
		   Else
				cCpoTp := "nValPgto"
		   Endif	
			cTpDoc := Iif(MovBcoBx(cMotBx, .T.),"VL","BA")
			//Se o motibo de baixa gerar cheque, pelas novas especificacoes, será gravado:
			//um movimento BA para a baixa
			//um movimento CH na geração do cheque
			If ChqMotBx(cMotBx) .or.;				
				SUBSTR(cMotBx,1,3) == "CEC" .or. SE2->E2_IMPCHEQ == "S" .or. ;
				GetMv("MV_LIBCHEQ") == "N"  .or. (lCnab .and. !Empty(cLoteFin))
				cTpDoc := "BA"
			Endif
			If (lCnab .AND. Empty(cLoteFin)) .or. ;
					(cBanco $ Left(GetMv("MV_CXFIN"),TamSX3("A6_COD")[1]) .and. MovBcoBx(cMotBx, .T.)) .or. ;
					(IF("FINA430" == FunName(),GetMv("MV_BXCNAB") == "N",.T.) .And. cBanco $ GetMv("MV_CARTEIR") .and. MovBcoBx(cMotBx, .T.)) .or. ;
					(MovBcoBx(cMotBx, .T.) .and. !ChqMotBx(cMotBx) .and. !lCnab)
				cTpDoc := "VL"		// For‡a mov banc ria quando CAIXA ou Via CNAB
			Endif
			cHistMov := Iif(!Empty(cHist070),cHist070,OemToAnsi( "Valor pago s /Titulo" )) //
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se existe cheque j  relacionado anteriormente para  ³
		//³ este t¡tulo. Deve buscar pelo registro do Cheque com a se-   ³
		//³ quencia em branco (Cheque gerado pelo FINA390 - Cheque s/    ³
		//³ t¡tulo.                                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lFina390
			dbSelectArea("SEF")
			dbSetOrder(3)
			cChave_EF := xFilial("SEF")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO
			If DbSeek(cChave_EF)
				DO WHILE (cChave_EF == SEF->EF_FILIAL + SEF->EF_PREFIXO+SEF->EF_TITULO;
					+SEF->EF_PARCELA+SEF->EF_TIPO) .and. !(SEF->(EOF()))

					IF Empty(SEF->EF_SEQUENC) .and. SEF->EF_FORNECE+SEF->EF_LOJA == SE2->E2_FORNECE+SE2->E2_LOJA
						cBanco  :=SEF->EF_BANCO
						cAgencia:=SEF->EF_AGENCIA
						cConta  :=SEF->EF_CONTA
						cCheque :=SEF->EF_NUM
						nRegSEF := RECNO()
						EXIT
					Endif
					SEF->(DbSkip())
				ENDDO
			Endif
		Endif

		IF &cCpoTp != 0 .or. i == 6 
		
		    lRet := DtMovFin(dDatabase)
		    IF !lret
		       return(.f.)
		    Endif
		        
			RecLock("SE5",.T.)
			SE5-> E5_FILIAL 	:= cFilial
			SE5-> E5_BANCO		:= cBanco
			SE5-> E5_AGENCIA	:= cAgencia
			SE5-> E5_CONTA		:= cConta
			SE5-> E5_DATA		:= dBaixa
			SE5-> E5_HISTOR 	:= cHistMov
			If ( cPaisLoc <> "BRA" )
				nMoedaBco := Max( SA6->A6_MOEDA, 1)
				SE5->E5_VALOR   := Round(NoRound(xMoeda( &cCpoTp, 1, nMoedaBco,,nCentMd1+1,, nTxModBco ),nCentMd1+1),nCentMd1)
				SE5->E5_VLMOED2 := Round(NoRound(xMoeda( &cCpoTp, 1, nMoedaTit,,nCentMd1+1,, nTxModTit ),nCentMd1+1),nCentMd1)
				If( SE5->(FieldPos("E5_TXMOEDA"))>0, SE5->E5_TXMOEDA:=nTxModBco,.T. )
				SE5->E5_MOEDA := StrZero(nMoedaBco,2)
			Else
				nMoedaBco 		:= Max( SA6->A6_MOEDA, 1)
				If lIRPFBaixa .and. nValPgto < nIrrf .and. cNccIr == "1" // se o valor do imposto for maior que o valor do saldo
					SE5->E5_VALOR	:= 0.01
					If SE2->E2_MOEDA == 1
						SE5-> E5_VLMOED2 := 0.01
					EndIf
				Else
					SE5->E5_VALOR	:= &cCpoTp
				Endif
				SE5->E5_MOEDA 	:= StrZero(nMoedaBco,2)
			EndIf
			SE5-> E5_NATUREZ	:= SE2->E2_NATUREZ
			SE5-> E5_RECPAG 	:= "P"
			SE5-> E5_TIPO		:= SE2->E2_TIPO
			SE5-> E5_NUMCHEQ	:= cCheque
		   
		   If IsInCallStack("Fa050Subst") //Baixa ref. substituicao de titulo Provisorio para Efetivo.
				SE5-> E5_LA			:= "S"
		   Else		   
				SE5-> E5_LA			:= If( lPadraoBx .And. ( cLanca == "S" ), "S", "N" )
			Endif
				
			SE5-> E5_TIPODOC	:= cTpDoc
			SE5-> E5_LOTE		:= cLoteFin
			SE5-> E5_PREFIXO	:= SE2->E2_PREFIXO
			SE5-> E5_NUMERO 	:= SE2->E2_NUM
			SE5-> E5_PARCELA	:= SE2->E2_PARCELA
			SE5-> E5_FORNECE	:= SE2->E2_FORNECE
			SE5-> E5_CLIFOR 	:= SE2->E2_FORNECE
			SE5-> E5_LOJA		:= SE2->E2_LOJA
			SE5-> E5_BENEF		:= IIF(Empty(cBenef),SE2->E2_NOMFOR,cBenef)
			If lTpDesc
				SE5-> E5_TPDESC	:= cTpDesc			
			Endif
   		
			SE5-> E5_DTDIGIT	:= dDataBase
			SE5-> E5_MOTBX		:= TrazCodMot(cMotBx)
			
			If cPaisLoc = "BRA"
				If nValEstrang != 0 .and. i == 6  // VL ou BA
					If SE5-> E5_VLMOED2 != 0.01
						SE5-> E5_VLMOED2	:= nValEstrang
					EndIf
				Else
					SE5-> E5_VLMOED2	:= Iif(i!=4 .or. SE2->E2_MOEDA<=1,Round(NoRound(xMoeda(&cCpoTp.,nMoedaBco,SE2->E2_MOEDA,dBaixa,nCentMd1+1,nTxMoeda),nCentMd1+1),nCentMd1),0)
				EndIf
			EndIf
			SE5->E5_SEQ		:= cSequencia
			SE5->E5_DOCUMEN	:= If(Empty(cNumBor),SE2->E2_NUMBOR,cNumBor) // Vem do Fina240()
			If lE5Orig
				SE5->E5_ORIGEM	:= FunName()
			Endif
			SE5->E5_DTDISPO	:= dDebito
			SE5->E5_ARQCNAB	:= cArqEnt
			SE5->E5_FILORIG	:= SE2->E2_FILORIG
			If lSpbInUse
				SE5->E5_MODSPB := cModSpb
			Endif
			//Gravo Marca da MultNat
			If MV_MULNATP .and. lMultNat
				SE5->E5_MULTNAT  := "1"
			Endif
			If cPaisLoc == "BRA" .And. SE2->E2_MOEDA > 1
				SE5->E5_TXMOEDA := nTxMoeda
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava os valores agregados ao titulo no totalizador ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If i == 6		// registro totalizador
				Replace E5_VLMULTA With nMulta
				Replace E5_VLDESCO With nDescont
				If cPaisloc <> "CHI"
					Replace E5_VLJUROS With nJuros
					Replace E5_VLCORRE With nCm
				Else
					Replace E5_VLJUROS With nOtrga + nImpSubst
					Replace E5_VLCORRE With nDifcambio
				EndIf
				If lAcreDecre
					SE5->E5_VLACRES	:= nAcresc
					SE5->E5_VLDECRE := nDecresc
				Endif	
				//Autenticacao bancaria
			   	IIf (SE5->(FieldPos("E5_AUTBCO"))> 0,SE5->E5_AUTBCO := cAutentica, .T.)   
				If lCalcIssBx .AND. SA2->A2_TIPO == "J" 
					SE5->E5_VRETISS := nIss
				Endif

				nSavRec := SE5->( Recno() ) 

				If lIRPFBaixa
					//IRRF - BAIXA
					If SE2->E2_VALOR < nIrrf .and. cNccIr == "1"
						If nValPgto == 0.01
							nDifIr := Abs(SE2->E2_SALDO - nIrrf) + nValPgto
						Else
							nDifIr := Abs(nValPgto - nIrrf) + 0.01
						EndIf
						aAreaTit := SE2->(GetArea())
						ADupCredRt(nDifIr,"501",SE2->E2_MOEDA,.T.)
						RestArea(aAreaTit)
						SFQ->FQ_SEQORI := cSequencia
					Endif
					If lNewIrBx
						FGRVSFQIR(nIrrf,nBaseIrpf,aDadosIr,cSequencia)
					Else
						SE5->E5_VRETIRF := nIrrf
						If lBaseIRPF
							SE5->E5_BASEIRF := nBaseIrpf
						Endif
					Endif
					
					//Se o título estiver em bordero, verifica se gerou título IR (fina241) ou nao (fina240)
					If !Empty(SE2->E2_NUMBOR) .and. SE2->E2_VRETIRF > 0 .and. (EMPTY(SE2->E2_PRETIRF) .or. SE2->E2_PRETIRF == "1")

						aAreaSE2 := SE2->(GetArea())
						cChaveIR := SE2->(E2_PREFIXO+E2_NUM+E2_PARCIR)+MVTAXA
					
						aAreaSA2 := SA2->(GetArea()) 
						dbSelectArea("SA2")
						If (dbSeek(xFilial("SA2")+GetMV("MV_UNIAO")))
				   			cChaveIR +=SA2->(A2_COD+A2_LOJA)				
						Endif
						cFilter := SE2->(DbFilter())
						dbSelectArea("SE2")
						dbSetOrder(1)
						If !Empty(cFilter)
							//Limpa o filtro para fazer a pesquisa do titulo de IR
							//pois na baixa em lote a SE2 vem filtrada somente com os titulos selecionado
							SET FILTER TO
						EndIf
						If SE2->(dbSeek(xFilial("SE2")+cChaveIR)) 
							lGerTXBord := .F.
						Endif            
						//volta o filtro
						SET FILTER TO &cFilter.
						SE2->(RestArea(aAreaSE2))   
						SA2->(RestArea(aAreaSA2))
						If !lGerTXBord
							//grava a geracao do IR na movimentacao da baixa, para que nao seja considerado na baixa de outro titulo
							// pois já foi retido na geracao do bordero
							SE5->E5_VRETIRF := SE2->E2_VRETIRF
							SE5->E5_PRETIRF := "4"
							SE5->E5_BASEIRF := SE2->E2_BASEIRF
						Endif	
					EndIf		
					
				Endif                      
					
				If lContrRet .and. lPccBaixa

					SE5->E5_VRETPIS := nPis
					SE5->E5_VRETCOF := nCofins
					SE5->E5_VRETCSL := nCsll
					
					Do Case 
					Case cModRetPIS == "1" 
						If (aDadosRet[1] + nBaseRet	> nVlMinImp .OR. !lAplVlMin) .AND. ;
							(nPis + nCofins + nCsll > 0)
							
							lRetParc := .T. 
					
							//Rotina para gerar titulo de adiantamento
							If cNCCRet == "1" .and. nDiferImp < 0 
								FGerCredRt(Abs(nDiferImp),SE2->E2_MOEDA,SE5->E5_SEQ)						
							Endif			
							nSavRec := SE5->( Recno() ) 
								
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Exclui a Marca de "pendente recolhimento" dos demais registros   ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If aDadosRet[1] > 0
								aRecnos := aClone( aDadosRet[ 6 ] ) 
						
								cPrefOri  := SE5->E5_PREFIXO
								cNumOri   := SE5->E5_NUMERO
								cParcOri  := SE5->E5_PARCELA
								cTipoOri  := SE5->E5_TIPO
								cCfOri    := SE5->E5_CLIFOR
								cLojaOri  := SE5->E5_LOJA
										
								For nLoop := 1 to Len( aRecnos )
									
									SE5->( dbGoto( aRecnos[ nLoop ] ) )
										
									RecLock( "SE5", .F. ) 
									
									If !Empty(SE5->E5_PRETPIS) .And. !Empty(SE5->E5_PRETCOF) .And. !Empty(SE5->E5_PRETCSL);
										.and. SE5->E5_PRETPIS <> "7" .And. SE5->E5_PRETCOF <> "7" .And. SE5->E5_PRETCSL<> "7"
										SE5->E5_PRETPIS := "2"
										SE5->E5_PRETCOF := "2"
										SE5->E5_PRETCSL := "2"
									EndIf
																	
									If lIRPFBaixa .and. SE5->E5_PRETIRF == "1"
										SE5->E5_PRETIRF := "2"									
									Endif             
									
									SE5->( MsUnlock() )  																								
			
									If FindFunction("ALIASINDIC")
										If AliasIndic("SFQ") 
											If nSavRec <> aRecnos[ nLoop ] 
												dbSelectArea("SFQ")
												RecLock("SFQ",.T.)
												SFQ->FQ_FILIAL  := xFilial("SFQ")
												SFQ->FQ_ENTORI  := "SE5"
												SFQ->FQ_PREFORI := cPrefOri
												SFQ->FQ_NUMORI  := cNumOri
												SFQ->FQ_PARCORI := cParcOri
												SFQ->FQ_TIPOORI := cTipoOri										
												SFQ->FQ_CFORI   := cCfOri
												SFQ->FQ_LOJAORI := cLojaOri
												SFQ->FQ_SEQORI  := cSequencia
												
												SFQ->FQ_ENTDES  := "SE5"
												SFQ->FQ_PREFDES := SE5->E5_PREFIXO
												SFQ->FQ_NUMDES  := SE5->E5_NUMERO
												SFQ->FQ_PARCDES := SE5->E5_PARCELA                             
												SFQ->FQ_TIPODES := SE5->E5_TIPO
												SFQ->FQ_CFDES   := SE5->E5_CLIFOR
												SFQ->FQ_LOJADES := SE5->E5_LOJA
												SFQ->FQ_SEQDES  := SE5->E5_SEQ

												//Grava a filial de destino caso o campo exista
												If !Empty( SFQ->( FieldPos( "FQ_FILDES" ) ) ) 
													SFQ->FQ_FILDES := SE5->E5_FILIAL 
												EndIf 											

												MsUnlock()
											Endif								
										Endif					
									Endif	
								Next nLoop 

								aRecSFQ := aClone( aRecnosSE2 )
												
								//Emissao
								For nLoop := 1 to Len( aRecSFQ )
							
									SE2->( dbGoto( aRecSFQ[nLoop]) )
											
									RecLock( "SE2", .F. ) 
									
									SE2->E2_PRETPIS := "2"
									SE2->E2_PRETCOF := "2"
									SE2->E2_PRETCSL := "2"
																	
									SE2->( MsUnlock() )  																								
						
									If FindFunction("ALIASINDIC")
										If AliasIndic("SFQ") 
											dbSelectArea("SFQ")
											RecLock("SFQ",.T.)
											SFQ->FQ_FILIAL  := xFilial("SFQ")
											SFQ->FQ_ENTORI  := "SE2"
											SFQ->FQ_PREFORI := cPrefOri
											SFQ->FQ_NUMORI  := cNumOri
											SFQ->FQ_PARCORI := cParcOri
											SFQ->FQ_TIPOORI := cTipoOri										
											SFQ->FQ_CFORI   := cCfOri
											SFQ->FQ_LOJAORI := cLojaOri
											
											SFQ->FQ_ENTDES  := "SE2"
											SFQ->FQ_PREFDES := SE2->E2_PREFIXO
											SFQ->FQ_NUMDES  := SE2->E2_NUM
											SFQ->FQ_PARCDES := SE2->E2_PARCELA                             
											SFQ->FQ_TIPODES := SE2->E2_TIPO
											SFQ->FQ_CFDES   := SE2->E2_FORNECE
											SFQ->FQ_LOJADES := SE2->E2_LOJA 
											SFQ->FQ_SEQORI  := cSequencia
						
											//Grava a filial de destino caso o campo exista
											If !Empty( SFQ->( FieldPos( "FQ_FILDES" ) ) ) 
												SFQ->FQ_FILDES := SE2->E2_FILIAL 
											EndIf 											
											MsUnlock()
										Endif								
									EndIf
								Next nLoop
							EndIf
					
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Retorna do ponteiro do SE2 para a parcela         ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							SE5->( MsGoto( nSavRec ) ) 
							Reclock( "SE5", .F. )														 
						Else 	
							If nVlRetPis + nVlRetCof + nVlRetCsl > 0
								Reclock( "SE5", .F. ) 
								If !lRetManual
									SE5->E5_VRETPIS := nVlRetPis
									SE5->E5_VRETCOF := nVlRetCof
									SE5->E5_VRETCSL := nVlRetCsl
									SE5->E5_PRETPIS := "1"
									SE5->E5_PRETCOF := "1"
									SE5->E5_PRETCSL := "1"
								EndIf

								SE5->( MsUnlock() )  																								
							Else
								//nesse caso o titulo teve seus impostos retidos em outro título, porem sua baixa foi cancelada.
								SFQ->(DBSetOrder(2))
								If SFQ->(DbSeek(xFilial("SFQ")+"SE5"+SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)))       
									//Verifico se se trata realmente de PCC
									//Apos a implementacao do IRRF na Baixa, o campo FQ_TPIMP ficou
									//Vazio = PCC
									//Preenchido = sigla do imposto (IRF, por exemplo)
									If Empty(SFQ->FQ_TPIMP)

										Reclock( "SE5", .F. ) 
										SE5->E5_VRETPIS := SE2->E2_PIS
										SE5->E5_VRETCOF := SE2->E2_COFINS
										SE5->E5_VRETCSL := SE2->E2_CSLL
										SE5->E5_PRETPIS := "2"
										SE5->E5_PRETCOF := "2"
										SE5->E5_PRETCSL := "2"
										SE5->( MsUnlock() )
											
										//Atualiza o registro da SFQ, apontando para a baixa correta
										RecLock("SFQ", .F.)
										SFQ->FQ_SEQDES := cSequencia
										SFQ->(MsUnlock())
									EndIf
								Endif
							EndIf
							lRetParc := .F. 
						EndIf

					Case cModRetPIS == "2" 
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Efetua a retencao                                                 ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						nSavRec := SE5->( Recno() ) 
							
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Exclui a Marca de "pendente recolhimento" dos demais registros   ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If aDadosRet[1] > 0
							aRecnos := aClone( aDadosRet [ 6 ] ) 
					
							cPrefOri  := SE5->E5_PREFIXO
							cNumOri   := SE5->E5_NUMERO
							cParcOri  := SE5->E5_PARCELA
							cTipoOri  := SE5->E5_TIPO
							cCfOri    := SE5->E5_CLIFOR
							cLojaOri  := SE5->E5_LOJA
									
							For nLoop := 1 to Len( aRecnos )
								
								SE5->( dbGoto( aRecnos[ nLoop ] ) )
									
								RecLock( "SE5", .F. ) 
								
								If !Empty(SE5->E5_PRETPIS) .And. !Empty(SE5->E5_PRETCOF) .And. !Empty(SE5->E5_PRETCSL)
									SE5->E5_PRETPIS := "2"
									SE5->E5_PRETCOF := "2"
									SE5->E5_PRETCSL := "2"
								EndIf																																									
								SE5->( MsUnlock() )  																								
		
								If FindFunction("ALIASINDIC")
									If AliasIndic("SFQ") 
										If nSavRec <> aRecnos[ nLoop ] 
											dbSelectArea("SFQ")
											RecLock("SFQ",.T.)
											SFQ->FQ_FILIAL  := xFilial("SFQ")
											SFQ->FQ_ENTORI  := "SE5"
											SFQ->FQ_PREFORI := cPrefOri
											SFQ->FQ_NUMORI  := cNumOri
											SFQ->FQ_PARCORI := cParcOri
											SFQ->FQ_TIPOORI := cTipoOri										
											SFQ->FQ_CFORI   := cCfOri
											SFQ->FQ_LOJAORI := cLojaOri
											SFQ->FQ_SEQORI  := cSequencia
																						
											SFQ->FQ_ENTDES  := "SE5"
											SFQ->FQ_PREFDES := SE5->E5_PREFIXO
											SFQ->FQ_NUMDES  := SE5->E5_NUMERO
											SFQ->FQ_PARCDES := SE5->E5_PARCELA                             
											SFQ->FQ_TIPODES := SE5->E5_TIPO
											SFQ->FQ_CFDES   := SE5->E5_CLIFOR
											SFQ->FQ_LOJADES := SE5->E5_LOJA
											SFQ->FQ_SEQDES  := SE5->E5_SEQ											

											//Grava a filial de destino caso o campo exista
											If !Empty( SFQ->( FieldPos( "FQ_FILDES" ) ) ) 
												SFQ->FQ_FILDES := SE5->E5_FILIAL 
											EndIf 											

											MsUnlock()
										Endif								
									Endif					
								Endif	
							Next nLoop 

							aRecSFQ := aClone( aRecnosSE2 )
												
							//Emissao
							For nLoop := 1 to Len( aRecSFQ )
							
								SE2->( dbGoto( aRecSFQ[nLoop]) )
										
								RecLock( "SE2", .F. ) 
								
								SE2->E2_PRETPIS := "2"
								SE2->E2_PRETCOF := "2"
								SE2->E2_PRETCSL := "2"
																
								SE2->( MsUnlock() )  																								
					
								If FindFunction("ALIASINDIC")
									If AliasIndic("SFQ") 
										dbSelectArea("SFQ")
										RecLock("SFQ",.T.)
										SFQ->FQ_FILIAL  := xFilial("SFQ")
										SFQ->FQ_ENTORI  := "SE2"
										SFQ->FQ_PREFORI := cPrefOri
										SFQ->FQ_NUMORI  := cNumOri
										SFQ->FQ_PARCORI := cParcOri
										SFQ->FQ_TIPOORI := cTipoOri										
										SFQ->FQ_CFORI   := cCfOri
										SFQ->FQ_LOJAORI := cLojaOri
										
										SFQ->FQ_ENTDES  := "SE2"
										SFQ->FQ_PREFDES := SE2->E2_PREFIXO
										SFQ->FQ_NUMDES  := SE2->E2_NUM
										SFQ->FQ_PARCDES := SE2->E2_PARCELA                             
										SFQ->FQ_TIPODES := SE2->E2_TIPO
										SFQ->FQ_CFDES   := SE2->E2_FORNECE
										SFQ->FQ_LOJADES := SE2->E2_LOJA
					
										//Grava a filial de destino caso o campo exista
										If !Empty( SFQ->( FieldPos( "FQ_FILDES" ) ) ) 
											SFQ->FQ_FILDES := SE2->E2_FILIAL 
										EndIf 											
										MsUnlock()
									Endif								
								Endif	
							Next nLoop
						Endif	
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Retorna do ponteiro do SE1 para a parcela         ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						SE5->( MsGoto( nSavRec ) ) 
						Reclock( "SE2", .F. ) 
						lRetParc := .T. 
					Case cModRetPIS == "3" 			
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Grava a Marca de "pendente recolhimento" dos demais registros    ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
						If nVlRetPis + nVlRetCof + nVlRetCsl > 0
							Reclock( "SE5", .F. ) 
							SE5->E5_VRETPIS := nVlRetPis
							SE5->E5_VRETCOF := nVlRetCof
							SE5->E5_VRETCSL := nVlRetCsl
							SE5->E5_PRETPIS := "1"
							SE5->E5_PRETCOF := "1"
							SE5->E5_PRETCSL := "1"

							SE5->( MsUnlock() )  																								
						EndIf	
						lRetParc := .F.
					EndCase 			
				EndIf 					
				If lInssBx .And. cPaisLoc = "BRA" .And. !(lInsPub .And. SE2->E2_TIPO $ MVPAGANT+"/INA")//Inss Baixa			
					
					If nInss > 0.00
						cGeraDirf := Iif(SE2->( FieldPos( "E2_DIRF" )) > 0 ,SE2->E2_DIRF," ")
						cCodRetIr := Iif(SE2->( FieldPos( "E2_CODRET" ))> 0,SE2->E2_CODRET," ")
							
						DbSelectArea("SE2")
						SE2->(DbGoto(nSalvRec))
	
						aAreaSE2 := SE2->(GetArea())					
						aAreaSA2 := SA2->(GetArea()) 
						aAreaSE5 := SE5->(GetArea())
							
						//Grava titulos do imposto INSS na tabela SE2 e na tabela SFQ.					 						
						FGrvINSS(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"","",1,SED->(Recno()),SE2->(Recno()),SE2->E2_EMISSAO,dDataBase,SE2->E2_VENCREA,nInss,.F.,{},{},;
										cGeraDirf,cCodRetIr,lSpbInUse	,cModSpb)															
			
						SE2->(RestArea(aAreaSE2))   
						SA2->(RestArea(aAreaSA2))
						SE5->(RestArea(aAreaSE5))
							
						Reclock( "SE5", .F. )
						SE5->E5_VRETINS	:= nVretInss
						SE5->E5_PRETINS	:= cPretIns
						SE5->(MsUnlock())						
					ElseIf nInss == 0 .And. ((SA2->A2_TIPO == "J" .And. lAcmPJ) .Or. SA2->A2_TIPO == "F" )
						Reclock( "SE5", .F. )
						SE5->E5_VRETINS	:= nVretInss
						SE5->E5_PRETINS	:= cPretIns
						SE5->(MsUnlock())										
					Endif
					
				Endif											 					
			Endif
         
			If i = 4
				Replace E5_IDENTEE	With SE2->E2_IDENTEE
			Endif

			// Gravacao de dados complementares da baixa
			If lSE5FI080
				ExecBlock('SE5FI080',.f.,.F.)
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Caso exista cheque j  relacionado anteriormente para este    ³
			//³ titulo, atualiza sequencia .											  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lFina390	
				dbSelectArea("SEF")
				MsGoto(nRegSEF)
				If !Eof()
					RecLock("SEF",.f.)
					SEF->EF_SEQUENC := cSequencia
				Endif
			Endif
		Endif
	Next i
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza o Cadastro de Cheques Emitidos, se for em Banco				  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If MovBcoBx(cMotBx, .T.) .and. !lAdiantamento .And. !lCNAB .and. TrazCodMot(cMotBx) != "DEB" .And.;
	ChqMotBx(cMotBx)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se for cheque pre-datado, nao cria novo cheque, pois este ja'          ³
	//³ foi criado quando da emissao do pre'datado.                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lChqPre .and. nValPgto > 0 .and. SE2->E2_IMPCHEQ != "S" .And.;
			!cBanco $ Left(GetMv("MV_CXFIN"),TamSX3("A6_COD")[1]) .And. !cBanco $ GetMv("MV_CARTEIR")
		RecLock("SEF",.T.)
		SEF->EF_FILIAL  := xfilial()
		SEF->EF_NUM 	 := cCheque
		SEF->EF_BANCO	 := cBanco
		SEF->EF_AGENCIA := cAgencia
		SEF->EF_CONTA	 := cConta
		SEF->EF_VALOR	 := nValPgto
		SEF->EF_DATA	 := dBaixa
		SEF->EF_BENEF	 := IIF(Empty(cBenef),SA2->A2_NOME,cBenef)
		SEF->EF_PORTADO := cPortado
		SEF->EF_HIST	 := cHist070
		SEF->EF_PREFIXO := SE2->E2_PREFIXO
		SEF->EF_TITULO  := SE2->E2_NUM
		SEF->EF_PARCELA := SE2->E2_PARCELA
		SEF->EF_FORNECE := SE2->E2_FORNECE
		SEF->EF_LOJA	 := SE2->E2_LOJA
		SEF->EF_TIPO	 := SE2->E2_TIPO                    
		SEF->EF_IMPRESS := If(!Empty(cCheque),"A"," ")
		SEF->EF_SEQUENC := cSequencia
		SEF->EF_ORIGEM  := "FINA080"
		SEF->EF_FILORIG := SE2->E2_FILORIG 
		MsUnlock()
		lGerouSef := .T.

		If ExistBlock("FA080SEF")
			Execblock("FA080SEF",.F.,.F.)
		Endif	
	Endif 	
   
   //Gera registro no SE5 para a geracao do cheque e gera cheque no SEF.
	If lGerouSef

		cSeqCheque := Soma1(cSequencia,nTamSeq)

		//Grava movimento do cheque
		If !Empty(cCheque) .and. lLibCheq .And. Subs(cCheque,1,1)!="*"		
			RecLock("SEF")
			SEF->EF_LIBER   := "S"
			If lPadraoBx .And. cLanca == "S" .and. cContabiliza $ "BA" .and. !lUsaFlag
				SEF->EF_LA  := "S"
			EndIf
			MsUnlock()

			// Inclui registro no SE5 para a geracao do cheque
			RecLock("SE5",.T.)
			SE5->E5_FILIAL  := cFilial
			SE5->E5_AGENCIA := cAgencia
			SE5->E5_BANCO   := cBanco
			SE5->E5_BENEF   := cBenef
			SE5->E5_CONTA   := cConta
			SE5->E5_DATA    := dBaixa
			SE5->E5_NUMCHEQ := cCheque
			SE5->E5_DTDIGIT := dDataBase
			SE5->E5_HISTOR  := cHistMov
			SE5->E5_RECPAG  := "P"
			SE5->E5_TIPODOC := "CH"
			SE5->E5_VALOR   := nValPgto
			SE5->E5_DTDISPO := dDebito
			SE5->E5_NATUREZ := SE2->E2_NATUREZ
			SE5->E5_SEQ		:= cSeqCheque
			SE5-> E5_LA		:= If( lPadraoBx .And. (cLanca == "S") .and. !lUsaFlag,"S","N")
			SE5->E5_FILORIG	:= SE2->E2_FILORIG	
			If SpbInUse()
				SE5->E5_MODSPB := "3"
			Endif
			MsUnlock()
		Endif
		If !Empty(cCheque) .And. Subs(cCheque,1,1)!="*"		
			//Gera cheque
			RecLock("SEF",.T.)
			SEF->EF_FILIAL  := xfilial()
			SEF->EF_NUM 	 := cCheque
			SEF->EF_BANCO	 := cBanco
			SEF->EF_AGENCIA := cAgencia
			SEF->EF_CONTA	 := cConta
			SEF->EF_VALOR	 := nValPgto
			SEF->EF_DATA	 := dBaixa
			SEF->EF_BENEF	 := IIF(Empty(cBenef),SA2->A2_NOME,cBenef)
			SEF->EF_PORTADO := cPortado
			SEF->EF_HIST	 := cHist070
			SEF->EF_LIBER   := If(lLibCheq,"S"," ")
			SEF->EF_SEQUENC := cSeqCheque
			SEF->EF_ORIGEM  := "FINA080" 
			SEF->EF_FILORIG := SE2->E2_FILORIG 
			MsUnlock()		             
		Endif
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o totalizador												   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SubStr(cCheque,1,1) = "*" .and. nValPgto > 0 .And. SE2->E2_IMPCHEQ != "S"
		dbSelectArea("SEF")
		SEF->( dbSeek(cFilial+cBanco+cAgencia+cConta+cCheque+cSeqCheque) )
		nRecNo := 0
		While !SEF->( Eof() )	.And. SEF->EF_FILIAL	 =	 cFilial  ;
				.And. SEF->EF_BANCO	 =  cBanco	 ;
				.And. SEF->EF_AGENCIA =  cAgencia ;
				.And. SEF->EF_CONTA	 =  cConta	 ;
				.And. SEF->EF_NUM 	 =  cCheque
			nRecNo := IIf(Empty(SEF->EF_TITULO),SEF->(RecNo()),nRecNo)
			dbSkip( )
		Enddo
		If nRecNo == 0 .And.;
				!cBanco $ Left(GetMv("MV_CXFIN"),TamSX3("A6_COD")[1]) .And. !cBanco $ GetMv("MV_CARTEIR")
			RecLock("SEF",.T.)
			SEF->EF_FILIAL  := cFilial
			SEF->EF_NUM 	 := cCheque
			SEF->EF_BANCO	 := cBanco
			SEF->EF_AGENCIA := cAgencia
			SEF->EF_CONTA	 := cConta
			SEF->EF_VALOR	 := nValPgto
			SEF->EF_DATA	 := dBaixa
			SEF->EF_BENEF	 := IIf(Empty(cBenef), SA6->A6_NOME, cBenef)
			SEF->EF_SEQUENC := PadL("1",TamSX3("EF_SEQUENC")[1],"0")
			SEF->EF_ORIGEM  := "FINA080"
			MsUnlock()
		Else
			dbGoTo( nRecNo )
			RecLock("SEF")
			SEF->EF_VALOR	+= nValPgto
			SEF->EF_DATA	:= dBaixa
		Endif
	Endif
Endif

If !lAdiantamento
	lMovBcoBx := MovBcoBx(cMotBx, .T.)
	IF (!Empty(cCheque) .and. lMovBcoBx .and. Substr(cCheque,1,1) != "*") .and.;
			GetMV("MV_LIBCHEQ") == "S" .and. SE2->E2_IMPCHEQ != "S"
		EVSalBco( cBanco, cAgencia, cConta, dDebito, nValPgto, "-" )
	ElseIf lCNAB .and. Empty(cLoteFin)
		EVSalBco( cBanco, cAgencia, cConta, dDebito, nValPgto, "-" )
	ElseIf lMovBcoBx .and. (cBanco $ Left(GetMv("MV_CXFIN"),TamSX3("A6_COD")[1]) .or. cBanco $ GetMv("MV_CARTEIR"))
		EVSalBco( cBanco, cAgencia, cConta, dDebito, nValPgto, "-" )
	ElseIf lMovBcoBx .and. !ChqMotBx(cMotBx) .and. !lCnab
		EVSalBco( cBanco, cAgencia, cConta, dDebito, nValPgto, "-" )
	Endif
Endif

dbSelectArea("SEF")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza o Cadastro de Fornecedores							 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE2")
dbSetOrder(nOrdBx)
SE2->( dbGotO( nSalvRec ) )
SED->( dbSeek ( cFilial + SE2 -> E2_NATUREZ ) )
IF SA2->( dbSeek(cFilial+SE2->E2_FORNECE+SE2->E2_LOJA) )
	RecLock("SA2")
	If SE2->E2_MOEDA > 1 .Or. cPaisLoc<>"BRA"	
		//Acho valor em dolares para converter para real na data de emissao
		nSaldup := Round(NoRound(xMoeda(nValPadrao,nMoedaBco,SE2->E2_MOEDA,dBaixa,nCentMd1+1,,nTxMoeda),nCentMd1+1),nCentMd1)
		//Acho valor em reais na data da emissao
		nSaldup := Round(NoRound(xMoeda(nSalDup,SE2->E2_MOEDA,nMoedaBco,SE2->E2_EMISSAO,nCentMd1+1,,nTxMoeda),nCentMd1+1),nCentMd1)	
	Else
		nSaldup := nValPadrao
	Endif			
	If SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG
		SA2->A2_SALDUP		+= nSalDup
		SA2->A2_SALDUPM	+= xMoeda(nSaldup,nMoedaBco,Val(GetMv("MV_MCUSTO")),SE2->E2_EMISSAO,3,nTxMoeda)
	Else
		SA2->A2_SALDUP		-= nSalDup
		SA2->A2_SALDUPM	-= xMoeda(nSaldup,nMoedaBco,Val(GetMv("MV_MCUSTO")),SE2->E2_EMISSAO,3,,nTxMoeda)
	Endif
	nAtraso:=dBaixa-SE2->E2_VENCTO
	If nAtraso > 1
		IF Dow(SE2->E2_VENCTO) == 1 .Or. Dow(SE2->E2_VENCTO) == 7
			IF Dow(dBaixa) == 2 .and. nAtraso <= 2
				nAtraso := 0
			EndIF
		EndIF
		nAtraso:=IIF(nAtraso<0,0,nAtraso)
		If SA2->A2_MATR < nAtraso
			Replace A2_MATR With nAtraso
		EndIf
	Endif
	SA2->(MSUnlock())	// Destrava SA2 apos alteracoes...
	dbSelectArea("SE2")
	SE2->(dbGoTo( nSalvRec ))
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida se o titulo está em Borderô de Impostos FINA241 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select("SEA") == 0
	DbSelectArea("SEA")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Complementa grava‡Æo da baixa tit. principal  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE2")
dbGoto(nSalvRec)

SEA->(DbSetOrder(2))
If SEA->(MsSeek(xFilial("SEA")+SE2->E2_NUMBOR+"P"+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)))
	If SEA->(FieldPos("EA_ORIGEM")) > 0 .And. "FINA241" $ SEA->EA_ORIGEM
		lBdImp := .T.
	EndIf
EndIf

//Altera o vencimento dos impostos
If !lPccBaixa .Or. (lBdVcImp .And. lBdImp)
	AltVencImp(SE2->E2_BAIXA)
Endif

//Acerto dos impostos Pis, Cofins e Csll
If (cPaisLoc=="BRA") .And. !lPccBaixa .and. (nJuros > 0 .or. nDescont > 0 .or. nMulta > 0 ) .and. (SE2->E2_PIS+SE2->E2_COFINS+SE2->E2_CSLL > 0)
	F080Impost(nSalvRec,.F.,nJuros,nMulta,nDescont,nValPgto)
Endif

If lRetManual
 	lRetParc := .T.
EndIf

//Posiciono o SE5 para titulos que não sejam adiantamendo (PA/NDF)
If !lAdiantamento
	SE5->(dbGoTo(nSavRec))
EndIf

//Gravo os titulos de impostos Pis Cofins Csll quando controlados pela baixa
If (lContrRet .and. lPccBaixa .and. lRetParc ).or. ;
	(lCalcIssBx .AND. SA2->A2_TIPO == "J"  .and. nIss > 0) .OR. ;
	(lIRPFBaixa .AND. nIrrf > 0.00)

	cGeraDirf := If(Empty(SE2->E2_CODRET), "2", "1")
	If SE2->E2_IRRF > 0 .and. !lIRPFBaixa //teve IR na emissão
		aArea := SE2->(GetArea())
		cChave := SE2->(E2_PREFIXO+E2_NUM+E2_PARCIR)+MVTAXA                                                              
		//prefixo+loja do titulo de ir
		cChave += GetMV("MV_UNIAO")+Space(Len(E2_FORNECE)-Len(GetMV("MV_UNIAO")))+PadR( "00", Len( SE2->E2_LOJA ), "0" ) 
		SE2->(DBSetOrder(1))             
		If SE2->(DbSeek(xFilial("SE2")+cChave))
			cGeraDirf := If(Empty(SE2->E2_CODRET), "2", "1")
		EndIf
		RestArea(aArea)	
	EndIf

	FGrvImpPcc(@nPis,@nCofins,@nCsll,nSalvRec,.F.,lRetParc,cSequencia,"FINA080",SE2->E2_MOEDA,cGeraDirf,nIrrf,nIss)
Endif

dbSelectArea("SE2")
dbGoto(nSalvRec)
If !(SE2->E2_TIPO $ "INA") //Não atualiza os campos de baixa no SE2 para titulos de INSS Antecipado
	RecLock("SE2")
	Replace E2_SALDO	  With nSaldo
	MsUnlock()
EndIf

If lInssBx .And. cPaisLoc = "BRA" .And. !(lInsPub .And. SE2->E2_TIPO $ MVPAGANT+"/INA")//Inss Baixa			
	nParciais	:= SE2->E2_VALOR-SE2->E2_SALDO
	
	If (SA2->A2_TIPO == "J" .And. nInss > 0.00) .Or. SA2->A2_TIPO == "F"  
		RecLock("SE2",.F.)
		SE2->E2_PRETINS	:= cPretIns			
		
		If !lInsPub
			//Tratamento para baixa parcial.
			If SA2->A2_TIPO == "F" .And. nParciais > 0 .And. SE2->E2_VRETINS > 0 .And. nLimInss > 0 
			//Caso o titulo já possua baixa e o parametro de controle de valor limite de inss esteja preenchido.		
				If SE2->E2_VRETINS < nLimInss
					If (nVretInss == nLimInss) 
						SE2->E2_VRETINS	:= nVretInss
					Else			
						SE2->E2_VRETINS	:= SE2->E2_VRETINS + nVretInss
					Endif
				Endif			
			ElseIf SA2->A2_TIPO == "F" .And. nLimInss == 0
			//Caso o titulo já possua baixa e o parametro de controle de valor limite de inss tenha conteudo ZERO.		
			   If nParciais > 0
			 		SE2->E2_VRETINS	:= SE2->E2_VRETINS + nVretInss			
			 	Else
			 		SE2->E2_VRETINS	:= nVretInss
			 	Endif		
			Else
				SE2->E2_VRETINS	:= nVretInss
			Endif
		Else
			If  SE2->E2_VRETINS + nVretInss	 <= SE2->E2_INSS		
				SE2->E2_VRETINS	:= SE2->E2_VRETINS + nVretInss
			Endif				
		Endif	
		
		If !lInsPub
			//Valor calculado do inss menor que valor gravado no campo E2_INSS. Ou seja, respeitando o valor limite do parametro MV_LIMINSS.
			//Ou valor calculado maior no caso de inss acumulado.
			If SA2->A2_TIPO == "F" .And. (SE2->E2_INSS > nInss .Or. nInss > SE2->E2_INSS) .And. nLimInss > 0		
				//Tratamento para baixa parcial.		
				If nParciais > 0 .And. SE2->E2_INSS > 0//Titulo possui uma baixa.
					If SE2->E2_INSS < nLimInss				
						If nInss == nLimInss
							SE2->E2_INSS	:=	nInss
						Else
							SE2->E2_INSS	:=	SE2->E2_INSS + nInss
						Endif
					Endif	
				Else			     
					SE2->E2_INSS	:=	nInss
				Endif		
			ElseIf SA2->A2_TIPO == "F" .And. nLimInss == 0 //Nao respeita o valor limite do parametro MV_LIMINSS.		
				If nParciais > 0 //Titulo possui baixa.
					SE2->E2_INSS	:=	SE2->E2_INSS + nInss
				Else
					SE2->E2_INSS	:=	nInss				
				Endif
			Endif
		Endif
			
		SE2->(MsUnlock())
	Endif	
Endif
If SE2->E2_PREFIXO=="AGP" // Força a baixa dos títulos aglutinados na FI9 caso eles já tenham sido baixados na SE2
	dbSelectArea("FI9")
	dbSetOrder(3)
	If dbSeek(xFilial("FI9")+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO)
		RecLock("FI9") 
		Replace FI9->FI9_STATUS WITH "B"
		MsUnlock() 
	Endif
	dbSelectArea("SE2")
Endif

If FindFunction("FA373Bx")
	FA373Bx(.T.)
EndIf


Return .T. /*Function fA080Grv*/













/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ LerLinha ³ Autor ³ J£lio Wittwer         ³ Data ³ 20.12.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Le mais uma linha do Arquivo de Retorno CNAB               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ cRet := LerLinha(nHandleRet)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ ReadCnab2()                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
Static Function LerLinha(nHandle)
Local cAnt := "" , cChar := " "
Local cString := "" , nLidos := 0, nTotLidos :=0 
While .T.
	cChar:=" "	// Ler de 1 em 1 caracteres...
	nLidos := Fread(nHandle,@cChar,1)
	nTotLidos += nLidos
	If cAnt+cChar==chr(13)+chr(10) .or. nLidos<1
		cString := Substr(cString,1,len(cString)-1)
		EXIT
	EndIf
	cString += cChar
	cAnt := cChar
End
Return {cString,nTotLidos}





















//-------------------------------------------------------------------------------------------------------
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ReadCnab2 ³ Autor ³ Eduardo Riera         ³      ³ 16/04/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Realiza a Leitura da configura‡ao CNAB Modelo 2             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ReadCnab2( nHandle , cLayOut )                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ ExpC1 : Handle do Arquivo a ser lido                       ³±±
±±³          ³ ExpC2 : Nome do arquivo de configuracao                    ³±±
±±³          ³ ExpN3 : Tamanho maximo da linha                            ³±±
±±³          ³ ExpA4 : Atributos do arquivo de configuracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Matriz                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GENERICO                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                                
//            
Static Function EVCnab3(nHandle,cLayOut,nMaxLn,aLayOut,nLinRead)

Local nHdlLay   := 0
Local lContinua := .T.
Local cBuffer   := ""
Local nCntFor   := 0
Local nPosIni   := 0
Local nPosFim   := 0
Local nTamanho  := 0
Local nDecimal  := 0
Local nPosSeg   := 0
Local aSegmento := {}
Local aDetalhe  := {}
Local cLinUlt   := ""
Local cLinAtu   := ""
Local nCntFor2  := 0
Local cIdent    := ""
Local xTITULO   := ""
Local xTIPO     := ""
Local xOCORRENCI:= ""
Local xDATA     := "000000"
Local xVALOR    := 0.00
Local xDESPESA  := 0.00
Local xDESCONTO := 0.00
Local xABATIMENT:= 0.00
Local xJUROS    := 0.00
Local xMULTA    := 0.00
Local xNOSSONUM := ""
Local xRESERVADO:= ""
Local xValIof   := 0.00
Local xValCC    := 0.00
Local xDataCred := "000000"
Local xMotivo   := ""
Local xBuffer   := ""
Local nLeitura  := 0					// Numero de Leituras Efetuadas
Local lSegValido:= .F.				// Controle de Leitura de segmentos validos
Local nLidosBco := 0					// Numero de Bytes lidos do Arquivo de Retorno
Local xAUTENTICA:= ""
Local aBuffer 	 := {}
Local xCGC 		 := ""
Local cChave    := ""
Local aDirtmp   := {}
Local xBANCO	 := ""
Local xAGENCIA  := ""
Local xCONTA	 := ""
Local aHeadL	 := Array(3,5)		//Array das posicoes de Banco, Agencia e Conta no Header para a baixa
Local aBanco	 := Array(3)		//Dados bancarios para a baixa (coletados no header)
Local lHeadL	 := ( AllTrim( Upper( FunName() ) ) != "FINR650" )
Local xCGCH		 := ""
Local xCODBAR	 := "" 	
Local xContOpt   :=""
Local nPosj52	 := 0
Local cSegmento	:= ''
Local cSeg52		:= ''
Local lReadJ		:= .F.
Local aReadSeg	:= {}

Default nMaxLn 	 := 1000
Default aLayOut  := {}                                                   
Default nLinRead := 0

Private xConteudo  := ""                
Private __aLayCNAB := {}


aBuffer := GetCNAB()		// Carrega LayOut

//If ( File(cLayOut) )
	
	If Len(aLayOut) == 0
		//aDirTmp	:= Directory(cLayOut)
	ELse
		aDirTmp := AClone(aLayOut)
	EndIf	
	
	// Inicializa flag que indica se possui dados bancarios para baixa - Header de Lote
//	aHeadL[ 1, 5 ] := .F.
//	aHeadL[ 2, 5 ] := .F.
//	aHeadL[ 3, 5 ] := .F.
	
//	cChave := aDirTmp[1][1]+str(aDirTmp[1][2])+DtoC(aDirTmp[1][3])+aDirTmp[1][4]
	
	If Empty(__aLayCNAB) .Or. cChave != __aLayCNAB[1]
//	   nHdlLay := FOpen(cLayOut,64)
//	   While ( lContinua )
//			cBuffer := FreadStr(nHdlLay,502)
       For nX := 1 To Len(aBuffer)
            cBuffer := aBuffer[nX]
			If ( !Empty(cBuffer) )
				If ( SubStr(cBuffer,1,1)=="1" )
					If ( SubStr(cBuffer,3,1)=="D" )
						aadd(aSegmento,{AllTrim(SubStr(cBuffer,02,03)),;
						AllTrim(SubStr(cBuffer,35,255)),0,0,0,0})
						aadd(aDetalhe,Array(20,4))
					EndIf
				Else
					If ( SubStr(cBuffer,3,1)=="D" )
						nPosIni  := Val(SubStr(cBuffer,20,03))
						nPosFim  := Val(SubStr(cBuffer,23,03))
						nDecimal := Val(SubStr(cBuffer,26,01))
						nTamanho := nPosFim - nPosIni +1
						xConteudo:= AllTrim(SubStr(cBuffer,27,255))
						nPosSeg := AScan(aSegmento,{|x| x[1]==Alltrim(SubStr(cBuffer,02,03))})
			      	If ( nPosSeg != 0 )
							Do Case
							Case xConteudo=="TITULO"
								aDetalhe[nPosSeg,1,1] := "TITULO"
								aDetalhe[nPosSeg,1,2] := nPosIni
								aDetalhe[nPosSeg,1,3] := nTamanho
								aDetalhe[nPosSeg,1,4] := nDecimal
							Case  xConteudo=="ESPECIE"
								aDetalhe[nPosSeg,2,1] := "ESPECIE"
								aDetalhe[nPosSeg,2,2] := nPosIni
								aDetalhe[nPosSeg,2,3] := nTamanho
								aDetalhe[nPosSeg,2,4] := nDecimal
							Case xConteudo=="OCORRENCIA"
								aDetalhe[nPosSeg,3,1] := "OCORRENCIA"
								aDetalhe[nPosSeg,3,2] := nPosIni
								aDetalhe[nPosSeg,3,3] := nTamanho
								aDetalhe[nPosSeg,3,4] := nDecimal
							Case xConteudo=="DATA"
								aDetalhe[nPosSeg,4,1] := "DATA"
								aDetalhe[nPosSeg,4,2] := nPosIni
								aDetalhe[nPosSeg,4,3] := nTamanho
								aDetalhe[nPosSeg,4,4] := nDecimal
							Case xConteudo=="VALOR"
								aDetalhe[nPosSeg,5,1] := "VALOR"
								aDetalhe[nPosSeg,5,2] := nPosIni
								aDetalhe[nPosSeg,5,3] := nTamanho
								aDetalhe[nPosSeg,5,4] := nDecimal
							Case xConteudo=="DESPESA"
								aDetalhe[nPosSeg,6,1] := "DESPESA"
								aDetalhe[nPosSeg,6,2] := nPosIni
								aDetalhe[nPosSeg,6,3] := nTamanho
								aDetalhe[nPosSeg,6,4] := nDecimal
							Case xConteudo=="DESCONTO"
								aDetalhe[nPosSeg,7,1] := "DESCONTO"
								aDetalhe[nPosSeg,7,2] := nPosIni
								aDetalhe[nPosSeg,7,3] := nTamanho
								aDetalhe[nPosSeg,7,4] := nDecimal
							Case xConteudo=="ABATIMENTO"
								aDetalhe[nPosSeg,8,1] := "ABATIMENTO"
								aDetalhe[nPosSeg,8,2] := nPosIni
								aDetalhe[nPosSeg,8,3] := nTamanho
								aDetalhe[nPosSeg,8,4] := nDecimal
							Case xConteudo=="JUROS"
								aDetalhe[nPosSeg,9,1] := "JUROS"
								aDetalhe[nPosSeg,9,2] := nPosIni
								aDetalhe[nPosSeg,9,3] := nTamanho
								aDetalhe[nPosSeg,9,4] := nDecimal
							Case xConteudo=="MULTA"
								aDetalhe[nPosSeg,10,1] := "MULTA"
								aDetalhe[nPosSeg,10,2] := nPosIni
								aDetalhe[nPosSeg,10,3] := nTamanho
								aDetalhe[nPosSeg,10,4] := nDecimal
							Case xConteudo=="IOF"
								aDetalhe[nPosSeg,11,1] := "IOF"
								aDetalhe[nPosSeg,11,2] := nPosIni
								aDetalhe[nPosSeg,11,3] := nTamanho
								aDetalhe[nPosSeg,11,4] := nDecimal
							Case xConteudo=="OUTROSCREDITOS"
								aDetalhe[nPosSeg,12,1] := "OUTROSCREDITOS"
								aDetalhe[nPosSeg,12,2] := nPosIni
								aDetalhe[nPosSeg,12,3] := nTamanho
								aDetalhe[nPosSeg,12,4] := nDecimal
							Case xConteudo=="DATACREDITO"
								aDetalhe[nPosSeg,13,1] := "DATACREDITO"
								aDetalhe[nPosSeg,13,2] := nPosIni
								aDetalhe[nPosSeg,13,3] := nTamanho
								aDetalhe[nPosSeg,13,4] := nDecimal
							Case xConteudo=="MOTIVO"
								aDetalhe[nPosSeg,14,1] := "MOTIVO"
								aDetalhe[nPosSeg,14,2] := nPosIni
								aDetalhe[nPosSeg,14,3] := nTamanho
								aDetalhe[nPosSeg,14,4] := nDecimal
							Case xConteudo=="NOSSONUMERO"
								aDetalhe[nPosSeg,15,1] := "NOSSONUMERO"
								aDetalhe[nPosSeg,15,2] := nPosIni
								aDetalhe[nPosSeg,15,3] := nTamanho
								aDetalhe[nPosSeg,15,4] := nDecimal
							Case xConteudo=="RESERVADO"
								aDetalhe[nPosSeg,16,1] := "RESERVADO"
								aDetalhe[nPosSeg,16,2] := nPosIni
								aDetalhe[nPosSeg,16,3] := nTamanho
								aDetalhe[nPosSeg,16,4] := nDecimal
							Case xConteudo=="SEGMENTO"
								aSegmento[nPosSeg,3] := nPosIni
								aSegmento[nPosSeg,4] := nTamanho
							Case xConteudo=="AUTENTICACAO"
								aDetalhe[nPosSeg,17,1] := "AUTENTICACAO"
								aDetalhe[nPosSeg,17,2] := nPosIni
								aDetalhe[nPosSeg,17,3] := nTamanho
								aDetalhe[nPosSeg,17,4] := nDecimal
							Case xConteudo=="CGC"
								aDetalhe[nPosSeg,18,1] := "CGC"
								aDetalhe[nPosSeg,18,2] := nPosIni
								aDetalhe[nPosSeg,18,3] := nTamanho
								aDetalhe[nPosSeg,18,4] := nDecimal
							Case xConteudo=="CGCH"
								aDetalhe[nPosSeg,19,1] := "CGCH"
								aDetalhe[nPosSeg,19,2] := nPosIni
								aDetalhe[nPosSeg,19,3] := nTamanho
								aDetalhe[nPosSeg,19,4] := nDecimal
							Case xConteudo=="CODBAR"
								aDetalhe[nPosSeg,20,1] := "CODBAR"
								aDetalhe[nPosSeg,20,2] := nPosIni
								aDetalhe[nPosSeg,20,3] := nTamanho
								aDetalhe[nPosSeg,20,4] := nDecimal
							Case xConteudo=="SEGJ52"
								aSegmento[nPosSeg,5] := nPosIni
								aSegmento[nPosSeg,6] := nTamanho
							EndCase
						EndIf
					//Dados bancarios para a baixa
					ElseIf ( SubStr(cBuffer,3,1)=="H" )
						nPosIni  := Val(SubStr(cBuffer,20,03))
						nPosFim  := Val(SubStr(cBuffer,23,03))
						nDecimal := Val(SubStr(cBuffer,26,01))
						nTamanho := nPosFim - nPosIni +1
						xConteudo:= AllTrim(SubStr(cBuffer,27,255))
						lHeadL   := .T.
						Do Case
							Case xConteudo=="BANCO"
								aHeadL[1,1] := "BANCO"
								aHeadL[1,2] := nPosIni
								aHeadL[1,3] := nTamanho
								aHeadL[1,4] := nDecimal
								aHeadL[1,5] := .T.
							Case xConteudo=="AGENCIA"
								aHeadL[2,1] := "AGENCIA"
								aHeadL[2,2] := nPosIni
								aHeadL[2,3] := nTamanho
								aHeadL[2,4] := nDecimal
								aHeadL[2,5] := .T.
							Case xConteudo=="CONTA"
								aHeadL[3,1] := "CONTA"
								aHeadL[3,2] := nPosIni
								aHeadL[3,3] := nTamanho
								aHeadL[3,4] := nDecimal
								aHeadL[3,5] := .T.
						EndCase
					EndIf
				EndIf
			Else
				lContinua := .F.
			EndIf
		Next
	   //	EndDo
	   //	FClose(nHdlLay)
		__aLayCNAB	:=	{}
		Aadd(__aLayCNAB,cChave)
		Aadd(__aLayCNAB,aSegmento)
		Aadd(__aLayCNAB,aDetalhe)
		Aadd(__aLayCNAB,aHeadL)
		Aadd(__aLayCNAB,aBanco)				
	Else
		aSegmento	:= aClone(__aLayCNAB[2])
		aDetalhe	:= aClone(__aLayCNAB[3])
		aHeadL		:= aClone(__aLayCNAB[4])
		aBanco		:= aClone(__aLayCNAB[5])	
	EndIf

//EndIf

lContinua := .T.

While ( lContinua )
	aLinha		:= LerLinha(nHandle,nMaxLn)
	cBuffer 	:= aLinha[1]
	nLidosBco 	:= aLinha[2]
	lSegValido	:= .F.
	nLeitura++
	nLinRead++
	cSegmento	:= ""	
	If (!Empty(cBuffer))
		//Lendo no Header de Lote o Banco, Agencia e Conta para baixa
		If Substr(cBuffer,8,1) == "1" .And. lHeadL
			For nCntFor := 1 To Len(aHeadL)
				If aHeadL[nCntFor,5]
					nPosIni := aHeadL[nCntFor,2]
					nTamanho:= aHeadL[nCntFor,3]
					nDecimal:= aHeadL[nCntFor,4]
					Do Case
					Case aHeadL[nCntFor,1]=="BANCO"
						xBANCO	:= SubStr(cBuffer,nPosIni,nTamanho)
						aBanco[1] := xBANCO
					Case aHeadL[nCntFor,1]=="AGENCIA"
						xAGENCIA	:= SubStr(cBuffer,nPosIni,nTamanho)
						aBanco[2] := xAGENCIA
					Case aHeadL[nCntFor,1]=="CONTA"
						xCONTA	:= SubStr(cBuffer,nPosIni,nTamanho)		
						aBanco[3] := xCONTA
					EndCase
				EndIf	
			Next
			__aLayCNAB[5] := aClone( aBanco )
		Else
			//Recarrego os dados bancarios quando estiver processando o detalhe
			//Esses dados estao apenas no header e somente serao trocados quando 
			//lido um novo header
			If Empty(xBanco) .and. !Empty(aBanco[1])
				xBanco	:= aBanco[1]
				xAgencia := aBanco[2]
				xConta	:= aBanco[3]				
			Endif

			// Posição do SEGMENTO J52			
			nPosJ52 := Ascan(aSegmento,{|x| x[2] = "J52" })
			lReadJ  := Ascan(aReadSeg, {|x| x == "J" }) > 0
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Busca o segmento da linha atual no array(aSegmento)          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For nCntFor := 1 To Len(aSegmento)
				If Empty(cSegmento)
					cSegmento := If(SubStr(cBuffer,aSegmento[nCntFor,3],aSegmento[nCntFor,4]) == aSegmento[nCntFor,2], aSegmento[nCntFor,2],"")
				ElseIf cSegmento == "J" .And. lReadJ .And. nPosJ52 != 0 .And. nPosJ52 == nCntFor // Verifica se existe SEGMENTO J52 (Opicional)
					cSeg52 := Alltrim(SubStr(cBuffer,aSegmento[nCntFor,3],aSegmento[nCntFor,4])) + SubStr(cBuffer,aSegmento[nCntFor,5],aSegmento[nCntFor,6])
					cSegmento := If(cSeg52 == aSegmento[nPosJ52,2], aSegmento[nCntFor,2],cSegmento)
				EndIf
			Next
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Caso o segmento ja foi processado por uma linha do arquivo de    ³
			//³ retorno, saio da função com os dados carregados até o momento.    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(cSegmento) .And. aScan(aReadSeg, {|x| x == cSegmento}) > 0  
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Retorna a linha atual para ser relida na proxima interacao.  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nLinRead--
				FSeek(nHandle,-2*(nLidosBco),1)
				cBuffer := LerLinha(nHandle,nMaxLn)[1]
				lContinua := .F.
				Exit
			ElseIf !Empty(cSegmento)
				AADD(aReadSeg,cSegmento)
			EndIf			

			For nCntFor := 1 To Len(aSegmento)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³                      Teste de Quebra                         ³
				//³  1D(n)                                                       ³
				//³  ------------------------------                              ³
				//³  |(n)-------------------------  -> Linha Detalhe  =  Conj.   ³
				//³  | 1 |------------------------A - Identificador    | da      ³
				//³  | 2 |------------------------B - Identificador    | Linha   ³
				//³  | 3 |------------------------C - Identificador    | Detalhe ³
				//³  |   -------------------------                    =          ³
				//³  |                                                           ³
				//³  ------------------------------                              ³
				//³  2D(n)                                                       ³
				//³  ------------------------------                              ³
				//³  |(n)-------------------------  -> Linha Detalhe  =  Conj.   ³
				//³  | 1 |------------------------A - Identificador    | da      ³
				//³  | 2 |------------------------B - Identificador    | Linha   ³
				//³  | 3 |------------------------C - Identificador    | Detalhe ³
				//³  |   -------------------------                    =          ³
				//³  |                                                           ³
				//³  ------------------------------                              ³
				//³                                                              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ( nPosj52 ) > 0
					xConteudo  := Alltrim(SubStr(cBuffer,aSegmento[nCntFor,3],aSegmento[nCntFor,4]))
					xContOpt   := SubStr(cBuffer,aSegmento[nCntFor,5],aSegmento[nCntFor,6])   
	                If nPosj52 > 0  .And. Empty(xContOpt)
		                xContOpt:= SubStr(cBuffer,aSegmento[nPosj52,5],aSegmento[nPosj52,6])
		            EndIf    
	                
					If !Empty(xContOpt) .And. xContOpt == "52" .And. xConteudo=="J"
						xConteudo := Alltrim( xConteudo ) + xContOpt
					EndIf
				Else
					xConteudo  := SubStr(cBuffer,aSegmento[nCntFor,3],aSegmento[nCntFor,4])
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica a qual linha detalhe o segmento valido pertence.    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If If( nPosj52 > 0, ( xConteudo == aSegmento[nCntFor,2] ), ( xConteudo $ aSegmento[nCntFor,2] ) )
					cLinAtu := SubStr(aSegmento[nCntFor][1],1,1)
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se houve quebra de linha detalhe, ou se o houve re- ³
				//³ peticao do mesmo conjunto da linha detalhe. A repeticao ocor-³
				//³ re quando o identificador de linha repete-se.                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ( (cIdent == xConteudo .Or. cLinAtu<>cLinUlt ) .And. ;		     
					 !Empty(cIdent) .And. !Empty(cLinUlt) .And. nLeitura > 1 ) //.And.;
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Retorna a linha atual para ser relida na proxima interacao.  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nLinRead--
					FSeek(nHandle,-2*(nLidosBco),1)
					cBuffer := LerLinha(nHandle,nMaxLn)[1]
					lContinua := .F.
					Exit
				EndIf
				If ( lContinua )
					If If( nPosj52 > 0, xConteudo == aSegmento[nCntFor,2], xConteudo $ aSegmento[nCntFor,2] )
						lSegValido := .T.
						xBuffer    += cBuffer
						Aadd(aBuffer,cBuffer)
						If (Empty(cIdent))
							nLeitura := 1
							cIdent 	:= xConteudo
							cLinUlt := SubStr(aSegmento[nCntFor][1],1,1)
						EndIf
						For nCntFor2 := 1 To Len(aDetalhe[nCntFor])
							nPosIni := aDetalhe[nCntFor,nCntFor2,2]
							nTamanho:= aDetalhe[nCntFor,nCntFor2,3]
							nDecimal:= aDetalhe[nCntFor,nCntFor2,4]
							Do Case
							Case aDetalhe[nCntFor,nCntFor2,1]=="TITULO"
								xTITULO := SubStr(cBuffer,nPosIni,nTamanho)
							Case aDetalhe[nCntFor,nCntFor2,1]=="NOSSONUMERO"
								xNOSSONUM := SubStr(cBuffer,nPosIni,nTamanho)
							Case aDetalhe[nCntFor,nCntFor2,1]=="ESPECIE"
								xTIPO     := SubStr(cBuffer,nPosIni,nTamanho)
							Case aDetalhe[nCntFor,nCntFor2,1]=="OCORRENCIA"
								xOCORRENCI := SubStr(cBuffer,nPosIni,nTamanho)
							Case aDetalhe[nCntFor,nCntFor2,1]=="DATA"
								xDATA := SubStr(cBuffer,nPosIni,nTamanho)
							Case aDetalhe[nCntFor,nCntFor2,1]=="VALOR"
								xVALOR := SubStr(cBuffer,nPosIni,nTamanho)
								xVALOR := Val(xVALOR)/(Val("1"+Repl("0",nDecimal)))
							Case aDetalhe[nCntFor,nCntFor2,1]=="DESPESA"
								xDESPESA := SubStr(cBuffer,nPosIni,nTamanho)
								xDESPESA := Val(xDESPESA)/(Val("1"+Repl("0",nDecimal)))
							Case aDetalhe[nCntFor,nCntFor2,1]=="DESCONTO"
								xDESCONTO := SubStr(cBuffer,nPosIni,nTamanho)
								xDESCONTO := Val(xDESCONTO)/(Val("1"+Repl("0",nDecimal)))
							Case aDetalhe[nCntFor,nCntFor2,1]=="ABATIMENTO"
								xABATIMENT := SubStr(cBuffer,nPosIni,nTamanho)
								xABATIMENT := Val(xABATIMENT)/(Val("1"+Repl("0",nDecimal)))
							Case aDetalhe[nCntFor,nCntFor2,1]=="JUROS"
								xJUROS := SubStr(cBuffer,nPosIni,nTamanho)
								xJUROS := Val(xJUROS)/(Val("1"+Repl("0",nDecimal)))
							Case aDetalhe[nCntFor,nCntFor2,1]=="MULTA"
								xMULTA := SubStr(cBuffer,nPosIni,nTamanho)
								xMULTA := Val(xMULTA)/(Val("1"+Repl("0",nDecimal)))
							Case aDetalhe[nCntFor,nCntFor2,1]=="OUTROSCREDITOS"
								xValCC := SubStr(cBuffer,nPosIni,nTamanho)
								xValCC := Val(xValCC)/(Val("1"+Repl("0",nDecimal)))
							Case aDetalhe[nCntFor,nCntFor2,1]=="IOF"
								xValIof := SubStr(cBuffer,nPosIni,nTamanho)
								xValIof := Val(xValIof)/(Val("1"+Repl("0",nDecimal)))
							Case aDetalhe[nCntFor,nCntFor2,1]=="DATACREDITO"
								xDATACRED := SubStr(cBuffer,nPosIni,nTamanho)
							Case aDetalhe[nCntFor,nCntFor2,1]=="MOTIVO"
								xMOTIVO := SubStr(cBuffer,nPosIni,nTamanho)
							Case aDetalhe[nCntFor,nCntFor2,1]=="RESERVADO"
								xRESERVADO:= SubStr(cBuffer,nPosIni,nTamanho)
							Case aDetalhe[nCntFor,nCntFor2,1]=="AUTENTICACAO"
								xAUTENTICA := SubStr(cBuffer,nPosIni,nTamanho)
							Case aDetalhe[nCntFor,nCntFor2,1]=="CGC"
								xCGC:= SubStr(cBuffer,nPosIni,nTamanho)
							Case aDetalhe[nCntFor,nCntFor2,1]=="CGCH"
								xCGCH:= SubStr(cBuffer,nPosIni,nTamanho)
							Case aDetalhe[nCntFor,nCntFor2,1]=="CODBAR"
								xCODBAR:= SubStr(cBuffer,nPosIni,nTamanho)
							Case aDetalhe[nCntFor,nCntFor2,1]=="IDENT REG OPCIO"
								xIdent:= SubStr(cBuffer,nPosIni,nTamanho)
							EndCase
						Next
					EndIf
				EndIf
			Next nCntFor
			If ( !lSegValido .And. !Empty(cIdent) )
				lContinua := .F.
			EndIf
		Endif
	Else
		lContinua := .F.
	EndIf
EndDo
Return({	xTITULO,xTIPO,xOCORRENCI,xDATA,xVALOR,;
			xDESPESA,xDESCONTO,xABATIMENT,xJUROS,xMULTA,;
			xNOSSONUM,xVALIOF,xVALCC,xDATACRED,xMOTIVO,;
			xRESERVADO,xBuffer,xAUTENTICA,aBuffer,xCGC,;
			xBanco,xAgencia,xConta,xCGCH,xCODBAR})
			
			
			
			
			
			
			
			
			






Static Function HeaderA()  // Header do Arquivo

Local aRet := {}

aAdd(aRET, {"20H ","CODIGO DO BANCO","001","003","0",space(474)})
aAdd(aRET, {"20H ","LOTE DE SERVICO","004","007","0",space(474)})
aAdd(aRET, {"20H ","REG.HEADER ARQ.","008","008","0",space(474)})
aAdd(aRET, {"20H ","USO FEBRABAN   ","009","017","0",space(474)})
aAdd(aRET, {"20H ","TP.INSCR. EMPRE","018","018","0",space(474)})
aAdd(aRET, {"20H ","N. INCR.EMPRESA","019","032","0",space(474)})
aAdd(aRET, {"20H ","COD. CONV. BCO.","033","052","0",space(474)})
aAdd(aRET, {"20H ","AG. MANT. CONTA","053","057","0",space(474)})
aAdd(aRET, {"20H ","DIGITO VER. AG.","058","058","0",space(474)})
aAdd(aRET, {"20H ","NUM. C/CORRENTE","059","070","0",space(474)})
aAdd(aRET, {"20H ","DIG. VER. CONTA","071","071","0",space(474)})
aAdd(aRET, {"20H ","DIG. VER. AG/C.","072","072","0",space(474)})
aAdd(aRET, {"20H ","NOME EMPRESA   ","073","102","0",space(474)})
aAdd(aRET, {"20H ","NOME BANCO     ","103","132","0",space(474)})
aAdd(aRET, {"20H ","USO FEBRABAN   ","133","142","0",space(474)})
aAdd(aRET, {"20H ","COD. REM/RETOR.","143","143","0",space(474)})
aAdd(aRET, {"20H ","DT. GERAC. ARQ.","144","151","0",space(474)})
aAdd(aRET, {"20H ","HORA GER.ARQ.  ","152","157","0",space(474)})
aAdd(aRET, {"20H ","N.SEQUEN.ARQ.  ","158","163","0",space(474)})
aAdd(aRET, {"20H ","N.VERSAO L.OUT.","164","166","0",space(474)})
aAdd(aRET, {"20H ","DENSID. GRAVAC.","167","171","0",space(474)})
aAdd(aRET, {"20H ","P/ USO RES.BCO ","172","191","0",space(474)})
aAdd(aRET, {"20H ","P/USO RES.EMPRE","192","211","0",space(474)})
aAdd(aRET, {"20H ","USO FEBRABAN   ","212","240","0",space(474)})
aAdd(aRET, {"20H ","IDENT.COB.S/PAP","223","225","0",space(474)})
aAdd(aRET, {"20H ","USO EXCL.VANS  ","226","228","0",space(474)})
aAdd(aRET, {"20H ","TIPO SERVICO   ","229","230","0",space(474)})
aAdd(aRET, {"20H ","COD.OCORRENCIAS","231","240","0",space(474)})
                
Return aRet
                     

Static Function HeaderC()  // Header 
Local aRET := {}

aAdd(aRET, {"10H ","HEADER DE ARQUIVO             ", ".T.","","",space(466)})
aAdd(aRET, {"10T ","TRAILER DE ARQUIVO            ", ".T.","","",space(466)})
aAdd(aRET, {"11D ","DETALHE - CRED. CONTA/DOC     ", "A"  ,"","",space(466)})
aAdd(aRET, {"11H ","HEADER DE LOTE-CRED.CONTA/DOC ", ".T.","","",space(466)})
aAdd(aRET, {"11T ","TRAILER DE LOTE-CRED.CONTA/DOC", ".T.","","",space(466)})
aAdd(aRET, {"12D ","DETALHE - PGTO. TITULOS       ", "J"  ,"","",space(466)})
aAdd(aRET, {"13D ","DETALHE - O COD BARRAS        ", "O"  ,"","",space(466)})
//aAdd(aRET, {"12H ","HEADER DE LOTE-PGTO. TITULOS  ", ".T.","","",space(466)})
//aAdd(aRET, {"12T ","TRAILER DE LOTE-PGTO TITULOS  ", ".T.","","",space(466)})

Return aRET


Static Function HeaderL()  // Header do Lote

Local aRet := {}

aLayOutR := {}

aAdd(aRET, {"21H ","CODIGO DO BANCO","001","003","0",space(474)})
aAdd(aRET, {"21H ","LOTE DE SERVICO","004","007","0",space(474)})
aAdd(aRET, {"21H ","REG.HEADER ARQ.","008","008","0",space(474)})
aAdd(aRET, {"21H ","TIPO OPERACAO  ","009","009","0",space(474)})
aAdd(aRET, {"21H ","SERVICO        ","010","011","0",space(474)})
aAdd(aRET, {"21H ","FORM.LANCTO    ","012","013","0",space(474)})
aAdd(aRET, {"21H ","LAYOUT DO LOTE ","014","016","0",space(474)})
aAdd(aRET, {"21H ","USO FEBRABAN   ","017","017","0",space(474)})
aAdd(aRET, {"21H ","TIPO INSCR.    ","018","018","0",space(474)})
aAdd(aRET, {"21H ","NUMERO INCR.   ","019","032","0",space(474)})
aAdd(aRET, {"21H ","CONVENIO       ","033","052","0",space(474)})
aAdd(aRET, {"21H ","COD. AGENCIA   ","053","057","0",space(474)})
aAdd(aRET, {"21H ","DIG. VERIFIC   ","058","058","0",space(474)})
aAdd(aRET, {"21H ","NUM. C/CORR    ","059","070","0",space(474)})
aAdd(aRET, {"21H ","DIGITO VER.CONT","071","071","0",space(474)})
aAdd(aRET, {"21H ","DIG. VERIF.AG/C","072","072","0",space(474)})
aAdd(aRET, {"21H ","NOME DA EMPRESA","073","102","0",space(474)})
aAdd(aRET, {"21H ","MENSAGEM       ","103","142","0",space(474)})
aAdd(aRET, {"21H ","LOGRADOURO     ","143","172","0",space(474)})
aAdd(aRET, {"21H ","NUMERO         ","173","177","0",space(474)})
aAdd(aRET, {"21H ","COMPLEMENTO    ","178","192","0",space(474)})
aAdd(aRET, {"21H ","CIDADE         ","193","212","0",space(474)})
aAdd(aRET, {"21H ","CEP            ","213","217","0",space(474)})
aAdd(aRET, {"21H ","COMPL. CEP     ","218","220","0",space(474)})
aAdd(aRET, {"21H ","ESTADO         ","221","222","0",space(474)})
aAdd(aRET, {"21H ","USO FEBRABAN   ","223","230","0",space(474)})
aAdd(aRET, {"21H ","OCORRENCIAS    ","231","230","0",space(474)})

//aAdd(aLayOutR, {"BANCO"	, 1,  3} )                                                                                                                                                                                                                                                            
//aAdd(aLayOutR, {"AGENCIA"	,53, 57} )                                                                                                                                                                                                                                                            
//aAdd(aLayOutR, {"CONTA"	,59, 70} )                                                                                                                                                                                                                                                            

Return aRet

Static Function DetalheA()  // Detalhe A

Local aRet := {}

aAdd(aRET, {"21D ","SEGMENTO       ","014","014","0","SEGMENTO  "+space(464)})
aAdd(aRET, {"21D ","SEU NUMERO     ","074","083","0","TITULO    "+space(464)})
aAdd(aRET, {"21D ","ESPECIE        ","084","085","0","ESPECIE   "+space(464)})
aAdd(aRET, {"21D ","TIPO           ","086","093","0","RESERVADO "+space(464)})
aAdd(aRET, {"21D ","DATA REAL      ","155","162","0","DATA      "+space(464)})                                                                                                                                                                                                                                                     
aAdd(aRET, {"21D ","VALOR REAL     ","163","177","2","VALOR     "+space(464)})                                                                                                                                                                                                                                                     
aAdd(aRET, {"21D ","OCORRENCIAS    ","231","240","0","OCORRENCIA"+space(464)})

Return aRet


Static Function DetalheJ()  // Detalhe J
Local aRet := {}

aAdd(aRET, {"22D ","SEGMENTO       ","014","014","0","SEGMENTO  "+space(464)})
aAdd(aRET, {"22D ","SEU NUMERO     ","183","192","0","TITULO    "+space(464)})
aAdd(aRET, {"22D ","ESPECIE        ","193","194","0","ESPECIE   "+space(464)})
aAdd(aRET, {"22D ","TIPO           ","195","202","0","RESERVADO "+space(464)})
aAdd(aRET, {"22D ","DATA REAL      ","145","152","0","DATA      "+space(464)})
aAdd(aRET, {"22D ","VALOR REAL     ","153","167","2","VALOR     "+space(464)})
aAdd(aRET, {"22D ","OCORRENCIAS    ","231","240","0","OCORRENCIA"+space(464)})

Return aRet
                                         

Static Function DetalheO()  // Detalhe O
Local aRet := {}

aAdd(aRET, {"23D ","SEGMENTO       ","014","014","0","SEGMENTO  "+space(464)})
aAdd(aRET, {"23D ","DATA REAL      ","100","107","0","DATA      "+space(464)})
aAdd(aRET, {"23D ","VALOR REAL     ","108","122","2","VALOR     "+space(464)})
aAdd(aRET, {"23D ","SEU NUMERO     ","123","132","0","TITULO    "+space(464)})
aAdd(aRET, {"23D ","OCORRENCIAS    ","231","240","0","OCORRENCIA"+space(464)})

Return aRet


Static Function TrailerL()  // Trailer de Lote
Local aRet := {}

aAdd(aRET, {"21T ","CODIGO DO BANCO","001","003","0",space(474)})
aAdd(aRET, {"21T ","LOTE DE SERVICO","004","007","0",space(474)})
aAdd(aRET, {"21T ","REG.HEADER ARQ.","008","008","0",space(474)})
aAdd(aRET, {"21T ","USO FEBRABAN   ","009","017","0",space(474)})
aAdd(aRET, {"21T ","QTDE REGISTROS ","018","023","0",space(474)})
aAdd(aRET, {"21T ","VALOR DEB/CRED ","024","041","0",space(474)})
aAdd(aRET, {"21T ","QDTE MOEDA     ","042","059","0",space(474)})
aAdd(aRET, {"21T ","USO FEBRABAN   ","060","230","0",space(474)})
aAdd(aRET, {"21T ","OCORRENCIAS    ","231","240","0",space(474)})

Return aRet

Static Function TrailerA()  // Trailer do Arquivo

Local aRet := {}

aAdd(aRET, {"20T ","CODIGO DO BANCO","001","003","0",space(474)})
aAdd(aRET, {"20T ","LOTE DE SERVICO","004","007","0",space(474)})
aAdd(aRET, {"20T ","REGISTRO       ","008","008","0",space(474)})
aAdd(aRET, {"20T ","CNAB           ","009","017","0",space(474)})
aAdd(aRET, {"20T ","QTDE LOTES ARQ ","018","023","0",space(474)})
aAdd(aRET, {"20T ","QTDE REGISTROS ","024","029","0",space(474)})
aAdd(aRET, {"20T ","QTDE CONTAS    ","030","035","0",space(474)})
aAdd(aRET, {"20T ","CNAB           ","036","240","0",space(474)})

Return aRet


Static Function GetCNAB()
	Local nX   := 0 
	Local aRET := {} 
	Local aTMPC:= HeaderC()        
	Local aTMP := HeaderA()
	Local aTMP1:= HeaderL()
	Local aTMP2:= DetalheA()
	Local aTMP3:= DetalheJ()
	Local aTMP4:= TrailerL()
	Local aTMP5:= TrailerA()
	Local aTMP6:= DetalheO()
	
	For nX := 1 to Len(aTmpC)	
    	aAdd(aRET, aTmpC[nX][1]+aTmpC[nX][2]+aTmpC[nX][3]+aTmpC[nX][4]+aTmpC[nX][5]+aTmpC[nX][6])       
    Next
	For nX := 1 to Len(aTmp5)	
    	aAdd(aRET, aTmp5[nX][1]+aTmp5[nX][2]+aTmp5[nX][3]+aTmp5[nX][4]+aTmp5[nX][5]+aTmp5[nX][6])       
    Next
	For nX := 1 to Len(aTmp1)	
    	aAdd(aRET, aTmp1[nX][1]+aTmp1[nX][2]+aTmp1[nX][3]+aTmp1[nX][4]+aTmp1[nX][5]+aTmp1[nX][6])       
    Next
	For nX := 1 to Len(aTmp4)	
    	aAdd(aRET, aTmp4[nX][1]+aTmp4[nX][2]+aTmp4[nX][3]+aTmp4[nX][4]+aTmp4[nX][5]+aTmp4[nX][6])       
    Next
	For nX := 1 to Len(aTmp)	
    	aAdd(aRET, aTmp[nX][1]+aTmp[nX][2]+aTmp[nX][3]+aTmp[nX][4]+aTmp[nX][5]+aTmp[nX][6])       
    Next
	For nX := 1 to Len(aTmp3)	
    	aAdd(aRET, aTmp3[nX][1]+aTmp3[nX][2]+aTmp3[nX][3]+aTmp3[nX][4]+aTmp3[nX][5]+aTmp3[nX][6])       
    Next
	For nX := 1 to Len(aTmp6)	
    	aAdd(aRET, aTmp6[nX][1]+aTmp6[nX][2]+aTmp6[nX][3]+aTmp6[nX][4]+aTmp6[nX][5]+aTmp6[nX][6])       
    Next
	For nX := 1 to Len(aTmp2)	
    	aAdd(aRET, aTmp2[nX][1]+aTmp2[nX][2]+aTmp2[nX][3]+aTmp2[nX][4]+aTmp2[nX][5]+aTmp2[nX][6])       
    Next

	
Return aRet


**************************************
* Verifica se o arquivo é DDA
**************************************			
Static Function VerifDDA(pArqRet, pcData) 			
	Local lRET := .F.
	Local nTamFile, nTamLin, cBuffer, nBtLidos

	FT_FUse(pArqRet)
	FT_FGOTOP()    
	
    nLin := 1
    While (!FT_FEOF() ) .and. nLin < 4
	 cBuffer := FT_FREADLN()
     FT_FSKIP()
     nLin++
    EndDo
    
    pcData := Substr(cBuffer, 108, 8)
    lRET   := (SubStr(cBuffer,14,1) $ 'G/H')

	FT_FUSE()            

Return lRET
			
			
			
			
			
			
			
//------------------------------------------  CONCILIAÇÃO DDA -----------------------------------------			
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ EV260Ger ³ Autor ³ Valdemir / Eduardo    ³ Data ³ 28/11/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Conciliacao DDA - Debito Direto Autorizado                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ EV260Ger()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ EV260Ger                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EV260Ger()

Local lPanelFin := If (FindFunction("IsPanelFin"),IsPanelFin(),.F.)

Local cRecTRB
Local nSavRecno:= Recno()
Local nPos		:= 0
Local aTabela 	:= {}
Local cIndex	:= " "					
Local nSeq		:= 0						// controle sequencial de lancto do Banco
Local lSaida	:= .F.
Local nOpca		:= 0
Local aCores 	:= {}
Local nCont		:= 0
Local li
Local cVarQ := "  "
Local oTitulo
Local oBtn
Local oDlg
Local cArqRec1 := ""
Local cArqRec2 := ""
Local cArqRec3	:= ""
Local cArqRec4 := ""
Local cArqRec5 := ""
Local cArqRec6 := ""
Local cArqRec7 := ""
Local dDtIni	:= CTOD("01/01/1980","ddmmyy")
Local dDtFin	:= CTOD("01/01/1980","ddmmyy")
Local nTamCodBar	:= TAMSX3("FIG_CODBAR")[1]
Local nTamIdCnab	:= TAMSX3("E2_IDCNAB")[1]
Local lQuery	:= .F.
Local cQuery := ""
Local cAliasFIG := ""
Local cAliasSE2 := ""
Local cCampos := ""
Local nX := 0
Local cFilSE2 	:= ""
Local cFornece	:= ""
Local cLoja		:= ""
Local cNum		:= ""
Local cTipo		:= ""
Local cVencto	:= ""
Local cVencMin	:= ""
Local cVencMax	:= ""
Local cValor	:= ""
Local cValorMin:= ""
Local cValorMax:= ""
Local cTitSE2	:= ""
Local cSeqSe2  := ""
Local nValor	:= 0
Local nValorMin:= 0
Local nValorMax:= 0
Local nRecSe2	:= 0
Local nRecDDA	:= 0
Local nRecTrb  := 0
Local dVencMin	:= CTOD("//")
Local dVencMax	:= CTOD("//")
Local cChave	:= ""
Local cCPNEG	:=	MV_CPNEG

Local oOk	:= LoadBitmap( GetResources(), "ENABLE"		)	//Nivel 1
Local oN2	:= LoadBitmap( GetResources(), "BR_AZUL"		)	//Nivel 2
Local oN3	:= LoadBitmap( GetResources(), "BR_PRETO"		)	//Nivel 3
Local oN4	:= LoadBitmap( GetResources(), "BR_CINZA"		)	//Nivel 4
Local oN5	:= LoadBitmap( GetResources(), "BR_BRANCO"	)	//Nivel 5
Local oN6	:= LoadBitmap( GetResources(), "BR_AMARELO"	)	//Nivel 6
Local oN7	:= LoadBitmap( GetResources(), "BR_LARANJA"	)	//Nivel 7
Local oN8	:= LoadBitmap( GetResources(), "BR_PINK"		)	//Nivel 8
Local oNo	:= LoadBitmap( GetResources(), "DISABLE"		)	//Nivel 9
Local nScan := 0   
Local lOk := nil
Local aTab := {}
Local lDup := .F. 

Local nNivel:= 9 
Local lF260CHPESQ := Existblock("F260CHPESQ") //esse ponto de entrada é usado como auxilio ao P.E F430GRAFIL da rotina fina430
Local lChave := .F. //para verificar se a conc será usado a condicional de filial de filial de origem.
Local cFilOSE2 := ""

Aadd(aCores,oOk)
Aadd(aCores,oN2)
Aadd(aCores,oN3)
Aadd(aCores,oN4)
Aadd(aCores,oN5)
Aadd(aCores,oN6)
Aadd(aCores,oN7)
Aadd(aCores,oN8)
Aadd(aCores,oNo)

//Array que conterao os registros lockados com o usuario
Private aRLocksSE2 := {}
Private aRLocksFIG := {}

//Tratamento para adiantamento tipo NCC
If "|" $ cCPNEG
	cCPNEG	:=	StrTran(MV_CPNEG,"|","")
ElseIf "," $ cCPNEG
	cCPNEG	:=	StrTran(MV_CPNEG,",","")
Endif    
If Mod(Len(cCPNEG),3) > 0
	cCPNEG	+=	Replicate(" ",3-Mod(Len(cCPNEG),3))
Endif	

if !(Type('aCpoSel')=='A')
   aCpoSel := {}
endif 

if Len(aCpoSel) > 0
	aSort(aCpoSel,,, { |x, y| x < y })     // Vencimento
	dDtIni := aCpoSel[1]
	dDtFin := aCpoSel[Len(aCpoSel)]
else
	//Verifico se o parametro Vencto de/Ate nao esta vazio
	dDtIni	:= Max(dDtIni,Iif(Empty(mv_par09),dDtIni,mv_par09))
	dDtFin	:= Max(dDtFin,Iif(Empty(mv_par10),dDtFin,mv_par10))
Endif


// Acrescento/diminuo das variaveis para abrir periodo
dDtIni	:= dDtIni - mv_par14	
dDtFin	:= dDtFin + mv_par13

#IFDEF TOP
	If TcSrvType() == "AS/400"
		lQuery := .F.
	Else
		lQuery := .T.
	Endif
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de trabalho                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
F260CRIARQ(@cArqRec1,@cArqRec2,@cArqRec3,@cArqRec4,@cArqRec5,@cArqRec6,@cArqRec7)

//Filtra dados do FIG - Conciliacao DDA
If lQuery

	FIG->(dbSetOrder(2)) //Filial+Fornecedor+Loja+Vencto+Titulo	
    cChave		:= FIG->(IndexKey())
	cAliasFIG	:= GetNextAlias()
	aStru			:= FIG->(dbStruct())
	cCampos		:= ""
	cFilIn 		:= F260Filial()
	
	aEval(aStru,{|x| cCampos += ","+AllTrim(x[1])})
	cQuery := "SELECT "+SubStr(cCampos,2) + ", R_E_C_N_O_ RECNOFIG "
	cQuery += "FROM " + RetSqlName("FIG") + " FIG  WHERE "
	cQuery +=		"FIG_FILIAL IN "	+ FormatIn(cFilIn,"/") + " AND "
	cQuery += 		"FIG_FORNEC  >= '"+ mv_par04 + "' AND "
	cQuery += 		"FIG_FORNEC  <= '"+ mv_par05 + "' AND "
	cQuery += 		"FIG_LOJA >= '"	+ mv_par06 + "' AND "
	cQuery += 		"FIG_LOJA <= '"	+ mv_par07 + "' AND "
	cQuery +=		"FIG_VENCTO >= '"	+ DTOS(dDtIni) + "' AND "
	cQuery +=		"FIG_VENCTO <= '"	+ DTOS(dDtFin) + "' AND "
	cQuery +=		"FIG_DATA >= '"	+ DTOS(mv_par11) + "' AND "
	cQuery +=		"FIG_DATA <= '"	+ DTOS(mv_par12) + "' AND "
	cQuery += 		"FIG_VALOR > 0 AND "
	cQuery +=		"FIG_CONCIL = '2' AND "
	cQuery +=		"FIG_CODBAR <> '"	+ Space(nTamCodbar) + "' AND " 
	cQuery +=		"D_E_L_E_T_ = ' ' "
	cQuery +=	"ORDER BY " + SqlOrder(cChave) 
	
	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasFIG,.T.,.T.)

	For nX :=  1 To Len(aStru)
		If aStru[nX][2] <> "C" .And. FieldPos(aStru[nX][1]) > 0
			TcSetField(cAliasFIG,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
		EndIf
	Next nX

Else
	//CODEBASE	
	cAliasFIG := "NEWFIG"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra o SE5 por Banco/Ag./Cta                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Select(cAliasFIG) == 0
		ChkFile("FIG",.F.,cAliasFIG)
	Else
		DbSelectArea(cAliasFIG)
	EndIf
	DbSetOrder(1)
	cChave	:= IndexKey()
	cIndex	:= CriaTrab(nil,.f.)
	If mv_par01 == 1  //Considera filiais
		cQuery +=	"FIG_FILIAL >= '"	+ mv_par02 + "' .AND. "	
		cQuery +=	"FIG_FILIAL <= '"	+ mv_par03 + "' .AND. "	
	Else
		cQuery +=	"FIG_FILIAL == '"	+ xFilial("FIG") + "' .AND. "	
	Endif
	cQuery += 	"FIG_FORNEC  >= '"+ mv_par04 + "' .and. "
	cQuery += 	"FIG_FORNEC  <= '"+ mv_par05 + "' .and. "
	cQuery += 	"FIG_LOJA >= '"	+ mv_par06 + "' .and. "
	cQuery += 	"FIG_LOJA <= '"	+ mv_par07 + "' .and. "
	cQuery +=	"DTOS(FIG_VENCTO) >= '"	+ DTOS(dDtIni) + "' .and. "
	cQuery +=	"DTOS(FIG_VENCTO) <= '"	+ DTOS(dDtFin) + "' .and. "
	cQuery +=	"DTOS(FIG_DATA) >= '"	+ DTOS(mv_par11) + "' .and. "
	cQuery +=	"DTOS(FIG_DATA) <= '"	+ DTOS(mv_par12) + "' .and. "
	cQuery += 	"FIG_VALOR > 0 .and. "
	cQuery +=	"FIG_CONCIL = '2' .and. "
	cQuery +=	"FIG_CODBAR <> '"	+ Space(nTamCodbar) + "'" 

	IndRegua("NEWFIG",cIndex,cChave,,cQuery, "Selecionando Registros...") //
	DbSelectArea("NEWFIG")
	nIndexFIG :=RetIndex("FIG","NEWFIG")
	#IFNDEF TOP
		dbSetIndex(cIndex+OrdBagExt())
	#ENDIF
	dbSetorder(nIndexFig+1)
	dbGoTop()
EndIf
		
If (cAliasFIG)->(Bof()) .or. (cAliasFIG)->(Eof())
	Help(" ",1,"NORECFIG",,"Nenhum registro DDA encontrado"+CHR(10)+"Por favor, verifique parametrização",1,0) //###
	lSaida := .T.
Else		

	While !((cAliasFIG)->(Eof()))

		If !F260Verif(cAliasFIG)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava dados no arquivo de trabalho³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea("TRB")
			RecLock("TRB",.T.)
			cRecTRB := STRZERO(TRB->(Recno()))
		
			TRB->SEQMOV 	:= SUBSTR(cRecTRB,-5)
			TRB->SEQCON		:= ""	
			TRB->FIL_DDA	:= (cAliasFIG)->FIG_FILIAL
			TRB->FOR_DDA	:= (cAliasFIG)->FIG_FORNEC
			TRB->LOJ_DDA	:= (cAliasFIG)->FIG_LOJA
			TRB->TIT_DDA	:= (cAliasFIG)->FIG_TITULO+"000000"
			TRB->TIP_DDA	:= (cAliasFIG)->FIG_TIPO
			TRB->DTV_DDA	:= (cAliasFIG)->FIG_VENCTO
			TRB->VLR_DDA	:= Transform((cAliasFIG)->FIG_VALOR,"@E 999,999,999,999.99")
			TRB->REC_DDA	:= If(lQuery,(cAliasFIG)->RECNOFIG,(cAliasFIG)->(Recno()))
			TRB->OK     	:= 9		// NAO CONCILIADO
			TRB->CODBAR		:= (cAliasFIG)->FIG_CODBAR
			MsUnlock()
		Endif	
		(cAliasFIG)->(dbSkip())
	Enddo				
	
Endif


//Filtra dados do SE2 - Contas a Pagar
If !lSaida

	//Filtra dados do SE2 - Conciliacao DDA
	If lQuery
		cAliasSE2 := GetNextAlias()
		aStru  := SE2->(dbStruct())
		cCampos := ""
		cFilIn := F260Filial()

		cQuery := "SELECT "
		cQuery +=		"E2_FILIAL,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_FORNECE,E2_LOJA,E2_NOMFOR,E2_EMISSAO,"
		cQuery +=		"E2_VENCTO,E2_VENCREA,E2_VALOR,E2_EMIS1,E2_HIST,E2_SALDO,E2_ACRESC,E2_ORIGEM,E2_TXMOEDA,"
		cQuery +=		"E2_SDACRES,E2_DECRESC,E2_SDDECRE,E2_IDCNAB,E2_FILORIG,E2_CODBAR,E2_STATUS,E2_DTBORDE,"
		cQuery +=		"R_E_C_N_O_ RECNOSE2 "
		cQuery += "FROM " + RetSqlName("SE2") + " SE2  WHERE "
		cQuery +=		"E2_FILIAL IN "	+ FormatIn(cFilIn,"/") + " AND "
		cQuery += 		"E2_FORNECE  >= '"+ mv_par04 + "' AND "
		cQuery += 		"E2_FORNECE  <= '"+ mv_par05 + "' AND "
		cQuery += 		"E2_LOJA >= '"	+ mv_par06 + "' AND "
		cQuery += 		"E2_LOJA <= '"	+ mv_par07 + "' AND "
		//Considera Vencto do titulo
		If mv_par08 == 1
			cQuery +=	"E2_VENCTO >= '"	+ DTOS(dDtIni) + "' AND "
			cQuery +=	"E2_VENCTO <= '"	+ DTOS(dDtFin) + "' AND "

			cChave := "E2_FORNECE+E2_LOJA+DTOS(E2_VENCTO)+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO"
			
		//Considera Vencto do titulo
		Else
			cQuery +=	"E2_VENCREA >= '"	+ DTOS(dDtIni) + "' AND "
			cQuery +=	"E2_VENCREA <= '"	+ DTOS(dDtFin) + "' AND "

			cChave := "E2_FORNECE+E2_LOJA+DTOS(E2_VENCREA)+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO"

		Endif
		cQuery += 		"E2_SALDO > 0 AND "
		cQuery += 		"E2_TIPO NOT IN " + FORMATIN(cCPNEG+MVPAGANT,,3) + " AND "
		cQuery += 		"E2_TIPO NOT IN " + FORMATIN(MVABATIM,'|') + " AND "
		cQuery += 		"E2_TIPO NOT IN " + FORMATIN(MVTXA+"INA",,3) + " AND "
		cQuery += 		"E2_TIPO NOT IN " + FORMATIN(MVTAXA,,3) + " AND "						
		cQuery += 		"E2_TIPO NOT IN " + FORMATIN(MVPROVIS,,3) + " AND "						
		cQuery +=		"E2_CODBAR = '"	+ Space(nTamCodbar) + "' AND " 
		cQuery +=		"E2_IDCNAB = '"	+ Space(nTamIdCnab) + "' AND " 
		cQuery +=		"D_E_L_E_T_ = ' ' "
		cQuery +=	"ORDER BY " + SqlOrder(cChave) 
		
		cQuery := ChangeQuery(cQuery)

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE2,.T.,.T.)

		For nX :=  1 To Len(aStru)
			If aStru[nX][2] <> "C" .And. FieldPos(aStru[nX][1]) > 0
				TcSetField(cAliasSE2,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
			EndIf
		Next nX
	Else
		//CODEBASE	
		cAliasSE2 := "NEWSE2"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Filtra o SE5 por Banco/Ag./Cta                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Select(cAliasSE2) == 0
			ChkFile("SE2",.F.,cAliasSE2)
		Else
			DbSelectArea(cAliasSE2)
		EndIf
		
		cIndex	:= CriaTrab(nil,.f.)
	
		If mv_par01 == 1  //Considera filiais
			cQuery :=	"E2_FILIAL >= '"	+ mv_par02 + "' .AND. "	
			cQuery +=	"E2_FILIAL <= '"	+ mv_par03 + "' .AND. "	
		Else
			cQuery :=	"E2_FILIAL == '"	+ xFilial("SE2") + "' .AND. "	
		Endif
		cQuery += 	"E2_FORNECE >= '"+ mv_par04 + "' .and. "
		cQuery += 	"E2_FORNECE <= '"+ mv_par05 + "' .and. "
		cQuery += 	"E2_LOJA >= '"	+ mv_par06 + "' .and. "
		cQuery += 	"E2_LOJA <= '"	+ mv_par07 + "' .and. "
		If mv_par08 == 1
			cQuery +=	"DTOS(E2_VENCTO) >= '"	+ DTOS(dDtIni) + "' .and. "
			cQuery +=	"DTOS(E2_VENCTO) <= '"	+ DTOS(dDtFin) + "' .and. "
	
			cChave := "E2_FORNECE+E2_LOJA+DTOS(E2_VENCTO)+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO"
		Else
			cQuery +=	"DTOS(E2_VENCREA) >= '"	+ DTOS(dDtIni) + "' .and. "
			cQuery +=	"DTOS(E2_VENCREA) <= '"	+ DTOS(dDtFin) + "' .and. "

			cChave := "E2_FORNECE+E2_LOJA+DTOS(E2_VENCREA)+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO"
		Endif
		cQuery += 	"E2_SALDO > 0 .and. "
		cQuery +=	"E2_CODBAR = '"	+ Space(nTamCodbar) + "'.And." 
		cQuery += 	"!(E2_TIPO $ '" + MV_CPNEG +"/"+MVPAGANT+"/"+ MVABATIM+"/"+MVTXA+"/"+"INA"+"/"+MVTAXA+"/"+MVPROVIS+"')"

  
		IndRegua("NEWSE2",cIndex,cChave,,cQuery, "Selecionando Registros...") //
		DbSelectArea("NEWSE2")
		nIndexSE2 :=RetIndex("SE2","NEWSE2")
		#IFNDEF TOP
			dbSetIndex(cIndex+OrdBagExt())
		#ENDIF
		dbSetorder(nIndexSE2+1)
		dbGoTop()
	EndIf
	
   WHILE (cAliasSE2)->(!Eof())
		aAdd(aTab,{	(cAliasSE2)->E2_FILIAL,;
            (cAliasSE2)->E2_FORNECE,;
            (cAliasSE2)->E2_LOJA,;
            If(mv_par08 == 1,(cAliasSE2)->E2_VENCTO,(cAliasSE2)->E2_VENCREA ),;
            Transform((cAliasSE2)->E2_VALOR,"@E 999,999,999,999.99"),;
            If(lQuery,(cAliasSE2)->RECNOSE2,(cAliasSE2)->(Recno()))})
   		DbSkip()         
	EndDo            
	dbGoTop()		
	If (cAliasSE2)->(Bof()) .or. (cAliasSE2)->(Eof())
		Help(" ",1,"NORECSE2",,"Nenhum registro encontrado no arquivo de contas a pagar (SE2)"+CHR(10)+"Por favor, verifique parametrização",1,0)		//###
		lSaida := .T.
	Else	
		//ponto de entrada valida se a chave de comp terá a condição de filial de origem na conciliação.
		If lF260CHPESQ
			lChave := ExecBlock("F260CHPESQ",.F.,.F.)							
		EndIf
				
		dbSelectArea(cAliasSE2)
		While !((cAliasSE2)->(Eof()))
		
			// Grava dados do SE2 no arquivo de trabalho
			DbSelectArea("TRB")
			RecLock("TRB",.T.)
			cRecTRB := STRZERO(TRB->(Recno()))        
		
			TRB->SEQMOV 	:= SUBSTR(cRecTRB,-5)
			TRB->SEQCON		:= ""	
			TRB->FIL_SE2	:= (cAliasSE2)->E2_FILIAL
			TRB->FOR_SE2	:= (cAliasSE2)->E2_FORNECE
			TRB->LOJ_SE2	:= (cAliasSE2)->E2_LOJA
			TRB->TIT_SE2	:= (cAliasSE2)->(E2_PREFIXO+"-"+E2_NUM+"-"+E2_PARCELA)
			TRB->KEY_SE2	:= (cAliasSE2)->(E2_PREFIXO+E2_NUM+E2_PARCELA)
			TRB->TIP_SE2	:= (cAliasSE2)->E2_TIPO
			TRB->DTV_SE2	:= If(mv_par08 == 1,(cAliasSE2)->E2_VENCTO,(cAliasSE2)->E2_VENCREA ) 
			TRB->VLR_SE2	:= Transform((cAliasSE2)->E2_VALOR,"@E 999,999,999,999.99")
			TRB->REC_SE2	:= If(lQuery,(cAliasSE2)->RECNOSE2,(cAliasSE2)->(Recno()))
			TRB->OK     	:= 9		// N„O CONCILIADO
			TRB->FILOR_SE2:= (cAliasSE2)->E2_FILORIG
			MsUnlock()
	
	        cFilSE2 	:= TRB->FIL_SE2
	        cFornece	:= TRB->FOR_SE2
	        cLoja		:= TRB->LOJ_SE2
	        cNum		:= TRB->KEY_SE2
	        cTipo		:= TRB->TIP_SE2
	        cVencto		:= DTOS(TRB->DTV_SE2)
			dVencMin	:= TRB->DTV_SE2- mv_par14
			dVencMax	:= TRB->DTV_SE2+ mv_par13
			cVencMin	:= DTOS(dVencMin)
			cVencMax	:= DTOS(dVencMax)
            cValor		:= TRB->VLR_SE2
            
			nValorMin:= (cAliasSE2)->E2_VALOR - mv_par15
			nValorMax:= (cAliasSE2)->E2_VALOR + mv_par16
			cValorMin:= Transform(nValorMin,"@E 999,999,999,999.99")
			cValorMax:= Transform(nValorMax,"@E 999,999,999,999.99")
			cTitSE2	 := TRB->TIT_SE2			
            nRecSe2	 := TRB->REC_SE2
            cSeqSe2  := TRB->SEQMOV
            nRecTrb  := TRB->(Recno())
            cFilOSE2 := TRB->FILOR_SE2 

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Tento pre-reconciliacao dentro da 					  					  ³
			//³ Filial + Fornecedor + Loja + Data Vencto + Valor + Ttulo	     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea("TRB")
			DbSetOrder(1)	//FOR_DDA+LOJ_DDA+DTV_DDA+TIT_DDA"
			nRecno := Recno()

			//***************************************************
			// Incluido Data de vencimento  no seek para deixar *
			// a chave de pesquisa mais forte. Caso a mesma nao *
			// seja encontrada a chave sera Forncedeor e Loja   *
			//***************************************************

			IF ((nScan := aScan(aTab,{|x| x[1]==(cAliasSE2)->E2_FILIAL .AND. ;
					x[4]== If(mv_par08 == 1,(cAliasSE2)->E2_VENCTO,(cAliasSE2)->E2_VENCREA )  .and.; 
					x[5] == Transform((cAliasSE2)->E2_VALOR,"@E 999,999,999,999.99") .and. ;
					x[6] <> If(lQuery,(cAliasSE2)->RECNOSE2,(cAliasSE2)->(Recno())) }))) > 0
				lDup := .T.	
				(cAliasSE2)->(dbskip())
				Loop 

				
			ENDIF

						
			If DbSeek(cFornece + cLoja + cVencto ) .and. ;
				cFilSe2 == TRB->FIL_DDA .and. ;
				Empty(TRB->SEQCON) .and. ;
				TRB->VLR_DDA == cValor .and. ;
				F260Lock(.T.,aRLocksSE2,aRLocksFIG,nRecSe2,TRB->REC_DDA)

				If lChave
					If TRB->FIL_DDA != cFilOSE2 
						(cAliasSE2)->(dbSkip())
						Loop	
					EndIf
				EndIf
				
				nNivel := 1
				nRecno := Recno()

				DbGoTo(nRecTrb)
				dbDelete()
				dbGoto(nRecno)
				RecLock("TRB")	
				TRB->SEQCON 	:= SUBSTR(cRecTRB,-5)
				TRB->FIL_SE2	:= (cAliasSE2)->E2_FILIAL
				TRB->FOR_SE2	:= (cAliasSE2)->E2_FORNECE
				TRB->LOJ_SE2	:= (cAliasSE2)->E2_LOJA
				TRB->TIT_SE2	:= (cAliasSE2)->(E2_PREFIXO+"-"+E2_NUM+"-"+E2_PARCELA)
				TRB->KEY_SE2	:= (cAliasSE2)->(E2_PREFIXO+E2_NUM+E2_PARCELA)
				TRB->TIP_SE2	:= (cAliasSE2)->E2_TIPO
				TRB->DTV_SE2	:= If(mv_par08 == 1,(cAliasSE2)->E2_VENCTO,(cAliasSE2)->E2_VENCREA ) 
				TRB->VLR_SE2	:= Transform((cAliasSE2)->E2_VALOR,"@E 999,999,999,999.99")
				TRB->REC_SE2	:= If(lQuery,(cAliasSE2)->RECNOSE2,(cAliasSE2)->(Recno()))
				TRB->OK     	:= nNivel	// NIVEL DE CONCILIACAO
				MsUnlock()
			
			ElseIf DbSeek(cFornece + cLoja)
				nRecno := Recno()

				While !(TRB->(Eof())) .and. TRB->(FOR_DDA+LOJ_DDA) == cFornece+cLoja
				
					If lChave
						If TRB->FIL_DDA != cFilOSE2 
							TRB->(dbSkip())
							Loop	
						EndIf
					EndIf				

					nNivel:= 9 //Nao conciliado

					//------------------------------------------------
					//Chave exata
					//Filial - OK
					//Data Vencto - OK
					//Valor - OK
					If cFilSe2 == TRB->FIL_DDA	 .and. ;
						TRB->VLR_DDA == cValor .and. ;
						DTOS(TRB->DTV_DDA) == cVencto .and.;
						Empty(TRB->SEQCON)
						nNivel := 1
						nRecno := Recno()
						Exit
						
					//------------------------------------------------
					//Filial - OK
					//Data Vencto - OK
					//Valor - Intervalo
					ElseIf cFilSe2 == TRB->FIL_DDA .and. ;
							DTOS(TRB->DTV_DDA) == cVencto .and.  ;
							TRB->VLR_DDA >= cValorMin .and. ;
							TRB->VLR_DDA <= cValorMax .and.;
							Empty(TRB->SEQCON)
						nNivel := 2
						nRecno := Recno()
						Exit
						
					//------------------------------------------------
					//Filial - OK
					//Data Vencto - Intervalo
					//Valor - OK
					ElseIf cFilSe2 == TRB->FIL_DDA .and. ;
							DTOS(TRB->DTV_DDA) >= cVencMin .and.;
							DTOS(TRB->DTV_DDA) <= cVencMax .and.;
							TRB->VLR_DDA == cValor .and.;
							Empty(TRB->SEQCON)
						nNivel := 3
						nRecno := Recno()
						Exit
						
					//------------------------------------------------
					//Filial - OK
					//Data Vencto - Intervalo
					//Valor - Intervalo
					ElseIf cFilSe2 == TRB->FIL_DDA .and. ;
							DTOS(TRB->DTV_DDA) >= cVencMin .and.;
							DTOS(TRB->DTV_DDA) <= cVencMax .and.;
							TRB->VLR_DDA >= cValorMin .and.;
							TRB->VLR_DDA <= cValorMax  .and.;
							Empty(TRB->SEQCON)
						nNivel := 4
						nRecno := Recno()
						Exit

					//------------------------------------------------						
					//Filial - Diferente
					//Data Vencto - OK
					//Valor - OK
					ElseIf cFilSe2 != TRB->FIL_DDA	 .and. ;
							TRB->VLR_DDA == cValor .and. ;
							DTOS(TRB->DTV_DDA) == cVencto .and.;
							Empty(TRB->SEQCON)
						nNivel := 5
						nRecno := Recno()
						Exit

					//------------------------------------------------						
					//Filial - Diferente
					//Data Vencto - OK
					//Valor - Intervalo
					ElseIf cFilSe2 != TRB->FIL_DDA .and. ;
							DTOS(TRB->DTV_DDA) == cVencto .and.  ;
							TRB->VLR_DDA >= cValorMin .and. ;
							TRB->VLR_DDA <= cValorMax .and.;
							Empty(TRB->SEQCON)
						nNivel := 6
						nRecno := Recno()
						Exit

					//------------------------------------------------						
					//Filial - Diferente
					//Data Vencto - intevalo
					//Valor - OK
					ElseIf cFilSe2 != TRB->FIL_DDA .and. ;
							TRB->VLR_DDA == cValor  .and.  ;
							DTOS(TRB->DTV_DDA) >= cVencMin .and. ;
							DTOS(TRB->DTV_DDA) <= cVencMax .and.;
							Empty(TRB->SEQCON)
						nNivel := 7
						nRecno := Recno()
						Exit
						
					//------------------------------------------------
					//Filial - Diferente
					//Data Vencto - intervalo
					//Valor - Intervalo
					ElseIf cFilSe2 != TRB->FIL_DDA .and. ;
							DTOS(TRB->DTV_DDA) >= cVencMin .and.;
							DTOS(TRB->DTV_DDA) <= cVencMax .and.;
							TRB->VLR_DDA >= cValorMin .and.;
							TRB->VLR_DDA <= cValorMax .and.;
							Empty(TRB->SEQCON)
						nNivel := 8
						nRecno := Recno()
						Exit

					Else
						TRB->(dbSkip())
						Loop
					Endif

				Enddo				
				IIF(nNivel<9 .and. Type('lOk')=="U",lOk:=.T.,Nil)							
				//Caso houve algum tipo de possibilidade de conciliacao
				If nNivel < 9				

					//Caso tenho conseguido travar os registros do SE2 e FIG 
					If F260Lock(.T.,aRLocksSE2,aRLocksFIG,nRecSe2,TRB->REC_DDA)   .and. lOk
						DbGoTo(nRecTrb)
						dbDelete()
						dbGoto(nRecno)
						RecLock("TRB")	
						TRB->SEQCON 	:= SUBSTR(cRecTRB,-5)
						TRB->FIL_SE2	:= (cAliasSE2)->E2_FILIAL
						TRB->FOR_SE2	:= (cAliasSE2)->E2_FORNECE
						TRB->LOJ_SE2	:= (cAliasSE2)->E2_LOJA
						TRB->TIT_SE2	:= (cAliasSE2)->(E2_PREFIXO+"-"+E2_NUM+"-"+E2_PARCELA)
						TRB->KEY_SE2	:= (cAliasSE2)->(E2_PREFIXO+E2_NUM+E2_PARCELA)
						TRB->TIP_SE2	:= (cAliasSE2)->E2_TIPO
						TRB->DTV_SE2	:= If(mv_par08 == 1,(cAliasSE2)->E2_VENCTO,(cAliasSE2)->E2_VENCREA ) 
						TRB->VLR_SE2	:= Transform((cAliasSE2)->E2_VALOR,"@E 999,999,999,999.99")
						TRB->REC_SE2	:= If(lQuery,(cAliasSE2)->RECNOSE2,(cAliasSE2)->(Recno()))
						TRB->OK     	:= nNivel	// NIVEL DE CONCILIACAO
						MsUnlock()
					Endif
					lOk := .T.
				Endif

			Endif
			(cAliasSE2)->(dbSkip())

		Enddo
      
      If lDup 
      	Alert("Existe mais de uma chave possivel para a conciliação automática, por este motivo a conciliação de alguns títulos deverá ser feita de forma manual.")
      EndIf
      
		dbSelectArea("TRB")
		DbSetOrder(7)	//SEQMOV+FOR_DDA+LOJ_DDA+DTV_DDA+TIT_DDA"
		dbGoTop()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Faz o calculo automatico de dimensoes de objetos     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aSize := MSADVSIZE()
		
		DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL
		oDlg:lMaximized := .T.

		oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,30,30,.T.,.T. )
		
		DEFINE SBUTTON FROM 10,250 TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oPanel
		DEFINE SBUTTON FROM 10,280 TYPE 2 ACTION (nOpca := 0,oDlg:End()) ENABLE OF oPanel
		DEFINE SBUTTON oBtn  FROM 10,310	TYPE 15 ACTION (F260Pesq(oTitulo))		ENABLE OF oPanel
		DEFINE SBUTTON oBtn2 FROM 10,340 TYPE 11 ACTION (F260LEGTRB())		ENABLE PIXEL OF oPanel

		oBtn:cToolTip  := "Pesquisa"
		oBtn:cCaption  := "Pesquisa"
		oBtn2:cToolTip := "Legenda"
		oBtn2:cCaption := "Legenda"
		oPanel:Align := CONTROL_ALIGN_BOTTOM

	
		@ 01.0,.5 	LISTBOX oTitulo VAR cVarQ FIELDS ;
				 		HEADER "", 	"Seq.",;  // //
									"Filial DDA",;  //
							 		"Fornec.DDA",; //
									"Loja DDA",; //
									"Titulo DDA",; //
									"Tipo DDA",; //
									"Vencto.DDA",; //
									"Valor DDA",; //
									"Filial SE2",; //
									"Fornec.SE2",; //
									"Loja SE2",; //
									 "Titulo SE2",; //
									"Tipo SE2",; //
									"Vencto.SE2",; //
									"Valor SE2",; //
						 COLSIZES 12,GetTextWidth(0,"BBBB"),; 				//SEQ
					 	 				 GetTextWidth(0,"BBBB"),;				//Filial
										 GetTextWidth(0,"BBBBB"),;				//Fornecedor
										 GetTextWidth(0,"BBBB"),;				//Loja
										 GetTextWidth(0,"BBBBBBBB"),; 	  //Titulo
										 GetTextWidth(0,"BBBB"),;				//Tipo
										 GetTextWidth(0,"BBBBBB"),;			//Vencto
										 GetTextWidth(0,"BBBBBBBBB"),;		//Valor									 
					 	 				 GetTextWidth(0,"BBBB"),;				//Filial
										 GetTextWidth(0,"BBBBB"),;				//Fornecedor
										 GetTextWidth(0,"BBBB"),;				//Loja
										 GetTextWidth(0,"BBBBBBBBBBB"),;   //Titulo
										 GetTextWidth(0,"BBBB"),;				//Tipo
										 GetTextWidth(0,"BBBBBB"),;			//Vencto
										 GetTextWidth(0,"BBBBBBBBB");			//Valor
		SIZE 345,400 ON DBLCLICK	(F260Marca(oTitulo),oTitulo:Refresh()) NOSCROLL 

		oTitulo:bLine := { || {aCores[TRB->OK],;
										TRB->SEQMOV 	,;
										TRB->FIL_DDA	,;
										TRB->FOR_DDA	,;
										TRB->LOJ_DDA	,;
										TRB->TIT_DDA	,;
										TRB->TIP_DDA	,;
										TRB->DTV_DDA	,;
										PADR(TRB->VLR_DDA,18)	,;
										TRB->FIL_SE2	,;
										TRB->FOR_SE2	,;
										TRB->LOJ_SE2	,;
										TRB->TIT_SE2	,;
										TRB->TIP_SE2	,;
										TRB->DTV_SE2	,;
										PADR(TRB->VLR_SE2,18) }}

		oTitulo:Align := CONTROL_ALIGN_ALLCLIENT
	
		ACTIVATE MSDIALOG oDlg CENTERED

		Private _nArqAbr := 0
		
		If nOpca == 1

			BEGIN TRANSACTION

			dbSelectArea("TRB")
			dbGoTop()
			While !(TRB->(Eof()))
				nRecSE2 := TRB->REC_SE2
				nRecDDA := TRB->REC_DDA
								
				//Se houve cociliacao
				//Gravo os dados do codigo de barras no SE2
				//Gravo os dados do titulo SE2 na tabela DDA (FIG)
				If nRecSE2 > 0 .and. nRecDDA > 0
					
					dbSelectArea("SE2")
					dbGoto(nRecSE2)
					If RecLock("SE2",.F.)
						SE2->E2_CODBAR	:= TRB->CODBAR
						cTitSE2			:= SE2->E2_FILIAL+"|"+;
												SE2->E2_PREFIXO+"|"+;
												SE2->E2_NUM+"|"+;
												SE2->E2_PARCELA+"|"+;
												SE2->E2_TIPO+"|"+;
												SE2->E2_FORNECE+"|"+;
												SE2->E2_LOJA+"|"
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Ponto de Entrada para gravacao complementar SE2³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If ExistBlock("FA260GRSE2")
							ExecBlock("FA260GRSE2",.F.,.F.)
						Endif

					Endif
						
					dbSelectArea("FIG")
					dbGoto(nRecDDA)
					If RecLock("FIG",.F.)
						FIG->FIG_DDASE2	:= cTitSE2		//Chave do SE2 com o qual foi conciliado
						FIG->FIG_CONCIL	:= "1" 			//Conciliado					
						FIG->FIG_DTCONC	:= dDatabase	//Data da Conciliacao
						FIG->FIG_USCONC	:= cUsername	//Usuario responsavel pela conciliacao
                		_nArqAbr        := 1
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Ponto de Entrada para gravacao complementar FIG³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ						
						If ExistBlock("FA260GRFIG")
							ExecBlock("FA260GRFIG",.F.,.F.)
						Endif
					Endif
				EndIf	
				dbSelectArea("TRB")
				dbSkip()
				Loop
			Enddo

			END TRANSACTION
			// Chama Geração de Bordero e CNAB
			u_FA260BOR(@aCpoSel)
			RemSelSE2()
			u_AbrTela()
		EndIf
	Endif
Endif

//Destravar os registros do SE2 e FIG antes de sair
F260Lock(.F.,aRLocksSE2,aRLocksFIG,,,,.T.)

//Finalizar o arquivo de trabalho
dbSelectArea("TRB")
Set Filter To
dbCloseArea()
Ferase(cArqRec1+ GetDBExtension())
Ferase(cArqRec1+OrdBagExt())
Ferase(cArqRec2+OrdBagExt())
Ferase(cArqRec3+OrdBagExt())
Ferase(cArqRec4+OrdBagExt())
Ferase(cArqRec5+OrdBagExt())
Ferase(cArqRec6+OrdBagExt())
Ferase(cArqRec7+OrdBagExt())
IF SELECT("NEWFIG") != 0
   dbSelectArea( "NEWFIG" )
   dbCloseArea()
   If !Empty(cIndex)
	   FErase (cIndex+OrdBagExt())
   Endif
ENDIF	
IF SELECT("NEWSE2") != 0
   dbSelectArea( "NEWSE2" )
   dbCloseArea()
   If !Empty(cIndex)
	   FErase (cIndex+OrdBagExt())
   Endif
ENDIF	

dbSelectArea("FIG")
dbSetOrder(1)

Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³F260Filial³ Autor ³ Valdemir / Eduardo    ³ Data ³04.10.15  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Montagem da String de filiais a serem utilizadas no 		  ³±±
±±³          ³ processo de filtragem dados - TOP                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                            				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function F260Filial()
Local cFilIn	:= ""
Local nInc		:= 0
Local aSM0		:= aSM0 := AdmAbreSM0()

pergunte("FIN260",.F.)

//Considero filiais do intervalo e arquivos exclusivos
If mv_par01 == 1 .and. !Empty(xFilial("SE2"))
	//Arquivos Exclusivos
	For nInc := 1 To Len( aSM0 )
		If aSM0[nInc][2] >= mv_par02 .and. aSM0[nInc][2] <= mv_par03
			cFilIn += aSM0[nInc][2] + "/"
		EndIf
	Next
Else
	cFilIn := xFilial("SE2")
Endif	

Return cFilIn	
			
			
			
			/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³F260Lock  ³ Autor ³ Valdemir / Eduardo    ³ Data ³04.10.15  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao para controle de travamento e destravamento dos     ³±±
±±³          ³ registros utilizados por um determinado usuario            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1 = Rotina para travamento dos registros do SE2 e FIG  ³±±
±±³          ³ ExpA2 = Array p/ guardar registros SE2 em uso pelo usuario ³±±
±±³          ³ ExpA3 = Array p/ guardar registros FIG em uso pelo usuario ³±±
±±³          ³ ExpN4 = Numero do registro do SE2 que se quer travar       ³±±
±±³          ³ ExpN5 = Numero do registro do FIG que se quer travar       ³±±
±±³          ³ ExpL6 = Mostra Help em caso de nao travamento do registro  ³±±
±±³          ³ ExpL7 = Destravamento de todos os registros                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function F260Lock(lLock,aRLocksSE2,aRLocksFIG,nRecnoSE2,nRecnoFIG,lHelp,lTodos)

Local aArea	:= GetArea()
Local nPosRec
Local lSE2	:= .F.
Local	lFIG	:= .F.
Local lRet	:= .F.

DEFAULT lLock := .F.		//Travamento ou destravamento dos registros
DEFAULT lHelp := .F.		//Mostra help ou nao
DEFAULT lTodos:= .F.		//Libera todos os registros
DEFAULT aRLocksSE2:={}	//Array de registros do SE2 lockados com o usuario
DEFAULT aRLocksFIG:={}	//Array de registros do FIG lockados com o usuario

If lTodos
	//Destrava todos os registros - Final do processamento
	AEval(aRLocksSE2,{|x,y| SE2->(MsRUnlock(x))})  
	aRLocksSE2:={}
	
	AEval(aRLocksFIG,{|x,y| FIG->(MsRUnlock(x))})  
	aRLocksFIG:={}

Else
	//Controle de marcacao ou desmarcaao dos titulos
	If nRecnoSE2 <> Nil             
		SE2->(MsGoto(nRecnoSE2))
		lSE2	:= .T.
	Endif                         
	
	If nRecnoFIG <> Nil             
		FIG->(MsGoto(nRecnoFIG))
		lFIG	:= .T.
	Endif                         
	
	If lLock //Rotina chamada para travamento dos registros do SE2 e FIG

		//A conciliacao somente sera permitida quando os registros do SE2 e FIG puderem ser travados
		//Caso um deles esteja em uso por outro terminal, nao sera permitida a conciliacao	
		If lSE2 .and. lFIG
			If SE2->(MsRLock()) .and. FIG->(MsRLock())
				AAdd(aRLocksSE2, SE2->(Recno()))
				AAdd(aRLocksFIG, FIG->(Recno()))
				lRet	:=	.T.
			ElseIf lHelp                                       
				MsgAlert("Um dos registros reçacionados está sendo utilizado em outro terminal e não pode ser utilizado na Conciliação DDA")		//
			Endif	
		Endif	
	Else
		If lSE2 .and. lFIG
			//Destravo registro no SE2
			SE2->(MsRUnlock(SE2->(Recno())))
			If (nPosRec:=Ascan(aRlocksSE2,SE2->(Recno()))) > 0
				Adel(aRlocksSE2,nPosRec)
				aSize(aRlocksSE2,Len(aRlocksSE2)-1)
			Endif
			//Destravo registro no FIG
			FIG->(MsRUnlock(FIG->(Recno())))
			If (nPosRec:=Ascan(aRlocksFIG,FIG->(REcno()))) > 0
				Adel(aRlocksFIG,nPosRec)
				aSize(aRlocksFIG,Len(aRlocksFIG)-1)
			Endif
		Endif
	Endif
Endif
		
If aArea <> Nil
	RestArea(aArea)
Endif	

Return lRet



/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³F260Marca ³ Autor ³ Valdemir / Eduardo    ³ Data ³ 02/11/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Troca o flag para marcado ou nao,aceitando valor.		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto da ListBox da conciliacao DDA   			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ F260Marca 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function F260Marca(oTitulo)
Local oDlg1              
Local lRet		:= .T.
Local lIsDDa	:= .F.
Local nOpca1 	:= 0
Local nSequen 	:= 0
Local nRecTRB	:= 0
Local nRecSE2	:= 0
Local nRecDDA	:= 0
Local nRecOrig := 0
Local nValorMin:= 0
Local nValorMax:= 0
Local nReconc	:= TRB->OK
Local cFilTrb 	:= ""
Local cFornece	:= ""
Local cLoja		:= ""
Local cNum		:= ""
Local cTipo		:= ""
Local dVencto	:= ""
Local cValor	:= ""
Local cTitSE2	:= ""
Local cSeqMov  := ""
Local cVencMin	:= ""
Local cVencMax	:= ""
Local cValorMin:= ""
Local cValorMax:= ""
Local cRecTRB	:= ""
Local dVencMin	:= CTOD("//")
Local dVencMax	:= CTOD("//")

If nReconc == 9   // Se n„o reconciliado

	DEFINE MSDIALOG oDlg1 FROM  69,70 TO 160,331 TITLE "Conciliação DDA" PIXEL  //

	@ 0, 2 TO 22, 165 OF oDlg1 PIXEL
	@ 7, 98 MSGET nSequen Picture "99999" VALID (nSequen <= TRB->(RecCount())) .and. (nSequen > 0) SIZE 20, 10 OF oDlg1 PIXEL
	@ 8, 08 SAY  "Sequência a Conciliar"  SIZE 90, 7 OF oDlg1 PIXEL  //
	DEFINE SBUTTON FROM 29, 71 TYPE 1 ENABLE ACTION (nOpca1:=1,If((nSequen <= TRB->(RecCount())) .and. (nSequen > 0),oDLg1:End(),nOpca1:=0)) OF oDlg1
	DEFINE SBUTTON FROM 29, 99 TYPE 2 ENABLE ACTION (oDlg1:End()) OF oDlg1

	ACTIVATE MSDIALOG oDlg1 CENTERED

	IF	nOpca1 == 1

		// Obtenho os dados do registro a conciliar
		cFilTrb 	:= IIF(!Empty(TRB->FIL_DDA),TRB->FIL_DDA,TRB->FIL_SE2)
		cFornece	:= IIF(!Empty(TRB->FOR_DDA),TRB->FOR_DDA,TRB->FOR_SE2)
		cLoja		:= IIF(!Empty(TRB->LOJ_DDA),TRB->LOJ_DDA,TRB->LOJ_SE2)
		cNum		:= IIF(!Empty(TRB->TIT_DDA),TRB->TIT_DDA,TRB->KEY_SE2)
		cTipo		:= IIF(!Empty(TRB->TIP_DDA),TRB->TIP_DDA,TRB->TIP_SE2)
		dVencto	:= IIF(!Empty(TRB->DTV_DDA),TRB->DTV_DDA,TRB->DTV_SE2)
		cValor	:= IIF(!Empty(TRB->VLR_DDA),TRB->VLR_DDA,TRB->VLR_SE2)
		nRecno	:= IIF(!Empty(TRB->REC_DDA),TRB->REC_DDA,TRB->REC_SE2)
		cTitSE2	:= TRB->TIT_SE2						
		cSeqMov  := TRB->SEQMOV
		nRecTrb  := TRB->(Recno()) 
		nRecOrig := Val(TRB->SEQMOV)
		dVencMin	:= dVencto - mv_par14
		dVencMax	:= dVencto + mv_par13
		cVencMin	:= DTOS(dVencMin)
		cVencMax	:= DTOS(dVencMax)
		nValorMin:= DesTrans(cValor) - mv_par15		
		nValorMax:= DesTrans(cValor) + mv_par16
		cValorMin:= Transform(nValorMin,"@E 999,999,999,999.99")
		cValorMax:= Transform(nValorMax,"@E 999,999,999,999.99")

		//Verifico se o registro eh DDA ou SE2
		If !Empty(TRB->REC_DDA)
			lIsDDA := .T.
		Endif		

		//Posiciono no registro que desejo conciliar
		dbSelectArea("TRB")
		dbGoto(nSequen)

		//Obtenho os recnos originais de cada tabela
		//FIG = nRecDDA
		//SE2 = nRecSE2
		If lIsDDa
			nRecDDA	:= nRecno		
			nRecSE2	:= TRB->REC_SE2		
		Else
			nRecDDA	:= TRB->REC_DDA		
			nRecSE2	:= nRecno		
		Endif
		
		If TRB->OK < 9
			Help(" ",1,"JACONCIL",,"Tentativa de conciliar com movimento já conciliado",1,0) //
			dbGoto(nRecOrig)
			oTitulo:Refresh()
			lRet := .F.
		Endif

		//Verifica tentativa de conciliar DDA x DDA ou SE2 x SE2
		If lRet .and. ((lIsDDA .and. !Empty(TRB->TIT_DDA)) .or. (!lIsDDA .and. !Empty(TRB->TIT_SE2)))
			Help(" ",1,"NOCONCMT",,"Não é possivel conciliar registros DDA x DDA ou SE2 x SE2",1,0) //
			dbGoto(nRecOrig)
			oTitulo:Refresh()
			lRet := .F.
		Endif


		//Caso consiga reservar os registros nas tabelas originais (SE2 e FIG)
		If lRet .and. F260Lock(.T.,aRLocksSE2,aRLocksFIG,nRecSe2,nRecDDA,.T.)

			If lRet .and. ( IIf (lIsDDA , TRB->(FOR_SE2+LOJ_SE2) != cFornece+cLoja , TRB->(FOR_DDA+LOJ_DDA) != cFornece+cLoja))

				Help(" ",1,"NOCONCFL",,"Fornecedor e Loja dos movimentos não conferem",1,0) //
				F260Lock(.F.,aRLocksSE2,aRLocksFIG,nRecSE2,nRecDDA)
				dbGoto(nRecOrig)
				oTitulo:Refresh()
				lRet := .F.
			Endif
	
			If lRet .and. ( IIf (lIsDDA , ;
				(TRB->(VLR_SE2) < cValorMin .or. TRB->(VLR_SE2) > cValorMax) ,;
				(TRB->(VLR_DDA) < cValorMin .or. TRB->(VLR_DDA) > cValorMax) ))

				Help(" ",1,"NOCONCVL",,"Os valores dos movimentos não conferem ou não estão dentro da tolerância de valores parametrizada",1,0) //
				F260Lock(.F.,aRLocksSE2,aRLocksFIG,nRecSE2,nRecDDA)
				dbGoto(nRecOrig)
				oTitulo:Refresh()
				lRet := .F.
			Endif
	
			If  lRet .and. ( IIf (lIsDDA , ;
				( DTOS(TRB->(DTV_SE2)) < cVencMin  .or. DTOS(TRB->(DTV_SE2)) > cVencMax ) ,;
				( DTOS(TRB->(DTV_DDA)) < cVencMin  .or. DTOS(TRB->(DTV_DDA)) > cVencMax ) ) )

				Help(" ",1,"NOCONCDT",,"As datas dos movimentos não conferem ou não estão dentro da tolerância de datas parametrizada",1,0) //
				F260Lock(.F.,aRLocksSE2,aRLocksFIG,nRecSE2,nRecDDA)
				dbGoto(nRecOrig)
				oTitulo:Refresh()
				lRet := .F.
			Endif
	
			If lRet
				//Se partiu de um movimetno DDA
				If lIsDDA
	
					//Pego os dados do titulo SE2
					cFilTrb 	:= TRB->FIL_SE2
					cFornece	:= TRB->FOR_SE2
					cLoja		:= TRB->LOJ_SE2
					cNum		:= TRB->KEY_SE2
					cTipo		:= TRB->TIP_SE2
					dVencto	:= TRB->DTV_SE2
					cValor	:= TRB->VLR_SE2
					nRecTRB	:= TRB->REC_SE2
					cSeqMov	:= TRB->SEQMOV					
					cTitSE2	:= TRB->TIT_SE2			
	
					DbSelectArea("TRB")
					dbDelete()
	
					dbGoTo(nRecOrig)
					//Gravo os dados SE2 no registro a conciliar (digitado)
					RecLock("TRB")
					TRB->SEQCON 	:= cSeqMov
					TRB->FIL_SE2	:= cFilTrb
					TRB->FOR_SE2	:= cFornece
					TRB->LOJ_SE2	:= cLoja
					TRB->TIT_SE2	:= cTitSE2	//Com separador
					TRB->KEY_SE2	:= cNum		//Sem separador
					TRB->TIP_SE2	:= cTipo
					TRB->DTV_SE2	:= dVencto
					TRB->VLR_SE2	:= cValor
					TRB->REC_SE2	:= nRecSE2
					TRB->OK     	:= 1	// NIVEL DE CONCILIACAO - Conciliado pelo Usuário
					MsUnlock()
	
	         Else
	
					//Gravo os dados DDA no registro a conciliar (digitado)
					RecLock("TRB")
					TRB->SEQCON 	:= cSeqMov
					TRB->FIL_SE2	:= cFilTrb
					TRB->FOR_SE2	:= cFornece
					TRB->LOJ_SE2	:= cLoja
					TRB->KEY_SE2	:= cNum		//Sem separador
					TRB->TIT_SE2	:= cTitSE2	//Com separador
					TRB->TIP_SE2	:= cTipo
					TRB->DTV_SE2	:= dVencto
					TRB->VLR_SE2	:= cValor
					TRB->REC_SE2	:= nRecSE2
					TRB->OK     	:= 1	// NIVEL DE CONCILIACAO - Conciliado pelo Usuário
					MsUnlock()
	
					//Deleto o registro     			
					dbGoTo(nRecOrig)
					dbDelete()
					MsUnlock()
					
					//Atualizo a tela
					dbGoto(nSequen)
					oTitulo:Refresh()
				Endif	
			Endif
		Endif
	Endif
Else
	DEFINE MSDIALOG oDlg1 FROM  69,70 TO 165,331 TITLE  "Conciliação DDA" PIXEL //
	@  0, 2 TO 28, 128 OF oDlg1	PIXEL
	@  7.5,  9 SAY  "Esta movimentação já se encontra conciliada"  SIZE 115, 7 OF oDlg1 PIXEL  // //
	@ 14  ,  9 SAY  "Deseja cancelar a conciliação ?"  SIZE 100, 7 OF oDlg1 PIXEL  // //
	DEFINE SBUTTON FROM 32, 71 TYPE 1 ENABLE ACTION (nOpca1:=1,oDlg1:End()) OF oDlg1
	DEFINE SBUTTON FROM 32, 99 TYPE 2 ENABLE ACTION (oDlg1:End()) OF oDlg1

	ACTIVATE MSDIALOG oDlg1 CENTERED

	IF	nOpca1 == 1
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cancela reconcilia‡Æo                               			  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nRecOrig := VAL(TRB->SEQMOV)
		nSeqSE2	:= VAL(TRB->SEQCON)
		nRecSE2	:= TRB->REC_SE2
		nRecDDA	:= TRB->REC_DDA
		
		//Limpo os dados do registro de SE2 conciliado
		dbSelectArea("TRB")
		TRB->FIL_SE2 	:= Space(Len(TRB->FIL_SE2))
		TRB->FOR_SE2 	:= Space(Len(TRB->FOR_SE2))
		TRB->LOJ_SE2 	:= Space(Len(TRB->LOJ_SE2))
		TRB->TIT_SE2 	:= Space(Len(TRB->TIT_SE2))				
		TRB->TIP_SE2 	:= Space(Len(TRB->TIP_SE2))				
		TRB->DTV_SE2 	:= CTOD("//")
		TRB->VLR_SE2 	:= Space(Len(TRB->VLR_SE2))				
		TRB->KEY_SE2 	:= Space(Len(TRB->KEY_SE2))
		TRB->REC_SE2	:= 0
		TRB->SEQCON		:= Space(5)
		TRB->OK			:= 9

		//Recupera o Registro Deletado
		SET DELETED OFF
		dbGoTo(nSeqSE2)
		dbRecall()
		TRB->OK := 9
		SET DELETED ON
		dbGoto(nRecOrig)

		//Destrava registros nas tabelas originais (SE2 e FIG)
		F260Lock(.F.,aRLocksSE2,aRLocksFIG,nRecSE2,nRecDDA)		

	Endif
Endif
oTitulo:Refresh()

Return lRet


*******************************
* Remove seleção dos registros
*******************************
Static Function RemSelSE2()
	Local cQuery  := ""
	Local nResult := 0 
	
	cQuery := "UPDATE " + RETSQLNAME('SE2') + " SET E2_OK='' "
	cQuery += "WHERE D_E_L_E_T_ = '' AND E2_OK <> '' 		 "
		
	nResult := TcSqlExec(cQuery) 
	
	If nResult < 0
		cError := TCSQLError()
		apMsgInfo("Atualizando Tabela 'SE2' - Top Error: " + cError  )	
   	Endif

Return
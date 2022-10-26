-------------------------- versao atual (2.00) ----------------------------------
Declare
   nVlr1aParcela Numeric(15,2) :=0;
   nVlr2aParcela Numeric(15,2) :=0;
   nQtdMeses Integer :=0;
   nAnoMes Numeric (6,0) := 0;
Begin
  For i in (Select * from DFPVR_PLRMOTORISTA2021)
    Loop
       /*inicializa variáveis*/
       nQtdMeses :=0;
       nAnoMes :=0;
       nVlr1aParcela := 0;
       nVlr2aParcela := 0;

      nQtdMeses := i.QtdMeses;
      
      /*se admitido dentro do ano vigente, não considera mês da admissão*/
      If i.DtaAdmissao between '01-MAY-2020' AND '30-APR-2021' Then
         nQtdMeses := i.QtdMeses - 1;
      End If;
      
      /*subtrai os meses afastados*/
      nQtdMeses := nQtdMeses - i.QtdMesAfastado;
      
      /*se existir meses a pagar, calcula parcela*/
      If nQtdMeses > 0 Then
         /*calcula o valor da primeira parcela*/
         nVlr1aParcela := Round(((920 / 12) * nQtdMeses) / 2, 2);
      End If;

      Case i.QtdFaltaPrimSem
        When 0 Then nVlr1aParcela := nVlr1aParcela;
        When 1 Then nVlr1aParcela := nVlr1aParcela;        
        When 2 Then nVlr1aParcela := round(((nVlr1aParcela * 90) /100), 2);        
        When 3 Then nVlr1aParcela := round(((nVlr1aParcela * 80) /100), 2);
        When 4 Then nVlr1aParcela := round(((nVlr1aParcela * 70) /100), 2);
        When 5 Then nVlr1aParcela := round(((nVlr1aParcela * 60) /100), 2);
        When 6 Then nVlr1aParcela := round(((nVlr1aParcela * 50) /100), 2);                                
        Else nVlr1aParcela := 0;
      End Case;
     
      If nVlr1aParcela > 0 Then
         nAnoMes := 202109;
         /*Grava os Valores da primeira parcela*/
         Insert into DFP_FuncLancto 
                (SeqLancamento, NroEmpresa, DtaLancamento, NroDocumento, NroParcela, TotalParcela, CodFuncionario, Referencia, Valor, AnoMes,
                 NroLote, NroPlanta, CodEvento, DescontarAfastado, TipoRecibo, Proporcional, Observacao)
         Values
                (S_DFP_LANCAMENTO.NEXTVAL, i.NroEmpresa, '30-SEP-2021', 202109, 1, 2, i.CodFuncionario, 0, nVlr1aParcela, 202109,
                 0, i.NroPlanta, 994, 'S', 1, 'N', 'PLR Motoristas - Inclusão em Lote');
                     
         /*grava ocorrência primeira parcela*/
         DPKG_SEGURANCA.DGEP_Ocorrencia('FOLPAG', 'FOLPAG', 'FPLANCAGENDA', 'DFP_FUNCLANCTO', trim(TO_CHAR(i.NroEmpresa, '000')) || Trim(TO_CHAR(i.CodFuncionario, '0000000')), 1, 1, 'Inserido Lançamento Mês/Ano:' || TRIM(substr(nAnoMes, 5,2)) || '/' || TRIM(substr(nAnoMes, 1,4)) || ' - Evento: 994-PLR (Valor) - Valor: R$ ' || nVlr1aParcela, 'Inclusão em Lote - PLR Motoristas 2021', 'LDUTRA', 1);
 
         /*se o funcionário não contribui com o sindicato*/      
         If i.Descontaconfederativa = 'N' Then
            /*Parcela 1 - Cont.Confedera */
            Insert into DFP_FuncLancto 
                   (SeqLancamento, NroEmpresa, DtaLancamento, NroDocumento, NroParcela, TotalParcela, CodFuncionario, Referencia, Valor, AnoMes,
                    NroLote, NroPlanta, CodEvento, DescontarAfastado, TipoRecibo, Proporcional, Observacao)
            Values
                   (S_DFP_LANCAMENTO.NEXTVAL, i.NroEmpresa, '30-SEP-2021', 202109, 1, 2, i.CodFuncionario, 0, 50.00, 202109,
                    0, i.NroPlanta, 55, 'S', 1, 'N', 'PLR Motoristas - Contribuição Negocial - Inclusão em Lote');
            /*grava ocorrência cont.negocial*/
            DPKG_SEGURANCA.DGEP_Ocorrencia('FOLPAG', 'FOLPAG', 'FPLANCAGENDA', 'DFP_FUNCLANCTO', trim(TO_CHAR(i.NroEmpresa, '000')) || Trim(TO_CHAR(i.CodFuncionario, '0000000')), 1, 1, 'Inserido Lançamento Mês/Ano:' || TRIM(substr(nAnoMes, 5,2)) || '/' || TRIM(substr(nAnoMes, 1,4)) || ' - Evento: 55-Contribuição Negocial - Valor: R$ 50,00', 'Inclusão em Lote - PLR Motoristas 2021', 'LDUTRA', 1);
         End If;
      End If;


      /*se existir meses a pagar, calcula 2a parcela*/
      If nQtdMeses > 0 Then
         /*calcula o valor da primeira parcela*/
         nVlr2aParcela := Round(((920 / 12) * nQtdMeses) / 2, 2);
      End If;

      Case i.QtdFaltaPrimSem
        When 0 Then nVlr2aParcela := nVlr2aParcela;
        When 1 Then nVlr2aParcela := nVlr2aParcela;        
        When 2 Then nVlr2aParcela := round(((nVlr2aParcela * 90) /100), 2);        
        When 3 Then nVlr2aParcela := round(((nVlr2aParcela * 80) /100), 2);
        When 4 Then nVlr2aParcela := round(((nVlr2aParcela * 70) /100), 2);
        When 5 Then nVlr2aParcela := round(((nVlr2aParcela * 60) /100), 2);
        When 6 Then nVlr2aParcela := round(((nVlr2aParcela * 50) /100), 2);                                
        Else nVlr2aParcela := 0;
      End Case;
      

      /*Grava os Valores da segunda parcela*/
      If nVlr2aParcela > 0 Then
         nAnoMes := 202203;
         /*Parcela 2 PLR*/
         Insert into DFP_FuncLancto 
              (SeqLancamento, NroEmpresa, DtaLancamento, NroDocumento, NroParcela, TotalParcela, CodFuncionario, Referencia, Valor, AnoMes,
               NroLote, NroPlanta, CodEvento, DescontarAfastado, TipoRecibo, Proporcional, Observacao)
         Values
              (S_DFP_LANCAMENTO.NEXTVAL, i.NroEmpresa, '30-SEP-2021', 202109, 2, 2, i.CodFuncionario, 0, nVlr2aParcela, 202203,
               0, i.NroPlanta, 994, 'S', 1, 'N', 'PLR Motoristas - Inclusão em Lote');
                   
         /*grava ocorrência primeira parcela*/
         DPKG_SEGURANCA.DGEP_Ocorrencia('FOLPAG', 'FOLPAG', 'FPLANCAGENDA', 'DFP_FUNCLANCTO', trim(TO_CHAR(i.NroEmpresa, '000')) || Trim(TO_CHAR(i.CodFuncionario, '0000000')), 1, 1, 'Inserido Lançamento Mês/Ano:' || TRIM(substr(nAnoMes, 5,2)) || '/' || TRIM(substr(nAnoMes, 1,4)) || ' - Evento: 994-PLR (Valor) - Valor: R$ ' ||  nVlr2aParcela, 'Inclusão em Lote - PLR Motoristas 2021', 'LDUTRA', 1);

         /*se o funcionário não contribui com o sindicato*/      
         If i.Descontaconfederativa = 'N' Then
            /*Parcela 2 - Cont.Negocial */
            Insert into DFP_FuncLancto 
                (SeqLancamento, NroEmpresa, DtaLancamento, NroDocumento, NroParcela, TotalParcela, CodFuncionario, Referencia, Valor, AnoMes,
                 NroLote, NroPlanta, CodEvento, DescontarAfastado, TipoRecibo, Proporcional, Observacao)
            Values
                (S_DFP_LANCAMENTO.NEXTVAL, i.NroEmpresa, '30-SEP-2021', 202109, 2, 2, i.CodFuncionario, 0, 50.00, 202203,
                 0, i.NroPlanta, 55, 'S', 1, 'N', 'PLR Motoristas - Contribuição Negocial - Inclusão em Lote');
            /*grava ocorrência cont.negocial*/
            DPKG_SEGURANCA.DGEP_Ocorrencia('FOLPAG', 'FOLPAG', 'FPLANCAGENDA', 'DFP_FUNCLANCTO', trim(TO_CHAR(i.NroEmpresa, '000')) || Trim(TO_CHAR(i.CodFuncionario, '0000000')), 1, 1, 'Inserido Lançamento Mês/Ano:' || TRIM(substr(nAnoMes, 5,2)) || '/' || TRIM(substr(nAnoMes, 1,4)) || ' - Evento: 55-Contribuição Negocial - Valor: R$ 50,00', 'Inclusão em Lote - PLR Motoristas 2021', 'LDUTRA', 1);
         End If;
      End If;
   End Loop;
End;



---------------------------  versao 1.0 --------------------------------------
Declare
   nVlr1aParcela Numeric(15,2) :=0;
   nVlr2aParcela Numeric(15,2) :=0;
   nQtdMeses Integer :=0;
   nAnoMes Numeric (6,0) := 0;
Begin
  For i in (Select * from DFPVR_PLRMOTORISTA2021 where not codfuncionario in (601031, 601087, 601050))
    Loop
       /*inicializa variáveis*/
       nQtdMeses :=0;
       nAnoMes :=0;
       nVlr1aParcela := 0;
       nVlr2aParcela := 0;

      nQtdMeses := i.QtdMeses;
      
      /*se admitido dentro do ano vigente, não considera mês da admissão*/
      If i.DtaAdmissao between '01-MAY-2020' AND '30-APR-2021' Then
         nQtdMeses := i.QtdMeses - 1;
      End If;
      
      /*subtrai os meses afastados*/
      nQtdMeses := nQtdMeses - i.QtdMesAfastado;
      
      /*se existir meses a pagar, calcula parcela*/
      If nQtdMeses > 0 Then
         /*calcula o valor da primeira parcela*/
         nVlr1aParcela := Round(((920 / 12) * nQtdMeses) / 2, 2);
      End If;

      Case i.QtdFaltaPrimSem
        When 0 Then nVlr1aParcela := nVlr1aParcela;
        When 1 Then nVlr1aParcela := nVlr1aParcela;        
        When 2 Then nVlr1aParcela := round(((nVlr1aParcela * 90) /100), 2);        
        When 3 Then nVlr1aParcela := round(((nVlr1aParcela * 80) /100), 2);
        When 4 Then nVlr1aParcela := round(((nVlr1aParcela * 70) /100), 2);
        When 5 Then nVlr1aParcela := round(((nVlr1aParcela * 60) /100), 2);
        When 6 Then nVlr1aParcela := round(((nVlr1aParcela * 50) /100), 2);                                
        Else nVlr1aParcela := 0;
      End Case;
     
      If nVlr1aParcela > 0 Then
         /*Grava os Valores da primeira parcela em 4x*/
         nAnoMes := 202108;
         For X in 1..4 Loop
            nAnoMes := DPKG_FolhaPagto.DFPF_ADDAnoMes(nAnoMes, 1);
            /*Parcela 1 PLR*/
            Insert into DFP_FuncLancto 
                    (SeqLancamento, NroEmpresa, DtaLancamento, NroDocumento, NroParcela, TotalParcela, CodFuncionario, Referencia, Valor, AnoMes,
                     NroLote, NroPlanta, CodEvento, DescontarAfastado, TipoRecibo, Proporcional, Observacao)
            Values
                    (S_DFP_LANCAMENTO.NEXTVAL, i.NroEmpresa, '30-SEP-2021', 202109, X, 4, i.CodFuncionario, 0, round((nVlr1aParcela / 4), 2), nAnoMes,
                     0, i.NroPlanta, 994, 'S', 1, 'N', 'PLR Motoristas - Inclusão em Lote');
                     
            /*grava ocorrência primeira parcela*/
            DPKG_SEGURANCA.DGEP_Ocorrencia('FOLPAG', 'FOLPAG', 'FPLANCAGENDA', 'DFP_FUNCLANCTO', trim(TO_CHAR(i.NroEmpresa, '000')) || Trim(TO_CHAR(i.CodFuncionario, '0000000')), 1, 1, 'Inserido Lançamento Mês/Ano:' || TRIM(substr(nAnoMes, 5,2)) || '/' || TRIM(substr(nAnoMes, 1,4)) || ' - Evento: 994-PLR (Valor) - Valor: R$ ' ||  round((nVlr1aParcela / 4), 2), 'Inclusão em Lote - PLR Motoristas 2021', 'LDUTRA', 1);
 
            /*se for a primeira parcela*/
            If X = 1 Then
               /*se o funcionário não contribui com o sindicato*/      
               If i.Descontaconfederativa = 'N' Then
                  /*Parcela 1 - Cont.Confedera */
                  Insert into DFP_FuncLancto 
                         (SeqLancamento, NroEmpresa, DtaLancamento, NroDocumento, NroParcela, TotalParcela, CodFuncionario, Referencia, Valor, AnoMes,
                          NroLote, NroPlanta, CodEvento, DescontarAfastado, TipoRecibo, Proporcional, Observacao)
                  Values
                         (S_DFP_LANCAMENTO.NEXTVAL, i.NroEmpresa, '30-SEP-2021', 202109, 1, 2, i.CodFuncionario, 0, 50.00, nAnoMes,
                          0, i.NroPlanta, 55, 'S', 1, 'N', 'PLR Motoristas - Contribuição Negocial - Inclusão em Lote');
                  /*grava ocorrência cont.negocial*/
                  DPKG_SEGURANCA.DGEP_Ocorrencia('FOLPAG', 'FOLPAG', 'FPLANCAGENDA', 'DFP_FUNCLANCTO', trim(TO_CHAR(i.NroEmpresa, '000')) || Trim(TO_CHAR(i.CodFuncionario, '0000000')), 1, 1, 'Inserido Lançamento Mês/Ano:' || TRIM(substr(nAnoMes, 5,2)) || '/' || TRIM(substr(nAnoMes, 1,4)) || ' - Evento: 55-Contribuição Negocial - Valor: R$ 50,00', 'Inclusão em Lote - PLR Motoristas 2021', 'LDUTRA', 1);
               End If;
            End If;
          End Loop;
       End If;


      /*se existir meses a pagar, calcula 2a parcela*/
      If nQtdMeses > 0 Then
         /*calcula o valor da primeira parcela*/
         nVlr2aParcela := Round(((920 / 12) * nQtdMeses) / 2, 2);
      End If;

      Case i.QtdFaltaPrimSem
        When 0 Then nVlr2aParcela := nVlr2aParcela;
        When 1 Then nVlr2aParcela := nVlr2aParcela;        
        When 2 Then nVlr2aParcela := round(((nVlr2aParcela * 90) /100), 2);        
        When 3 Then nVlr2aParcela := round(((nVlr2aParcela * 80) /100), 2);
        When 4 Then nVlr2aParcela := round(((nVlr2aParcela * 70) /100), 2);
        When 5 Then nVlr2aParcela := round(((nVlr2aParcela * 60) /100), 2);
        When 6 Then nVlr2aParcela := round(((nVlr2aParcela * 50) /100), 2);                                
        Else nVlr2aParcela := 0;
      End Case;
      

      If nVlr2aParcela > 0 Then
         /*Grava os Valores da primeira parcela em 4x*/
         nAnoMes := 202112;

         For X in 1..4 Loop
            nAnoMes := DPKG_FolhaPagto.DFPF_ADDAnoMes(nAnoMes, 1);
            /*Parcela 2 PLR*/
            Insert into DFP_FuncLancto 
                 (SeqLancamento, NroEmpresa, DtaLancamento, NroDocumento, NroParcela, TotalParcela, CodFuncionario, Referencia, Valor, AnoMes,
                  NroLote, NroPlanta, CodEvento, DescontarAfastado, TipoRecibo, Proporcional, Observacao)
            Values
                 (S_DFP_LANCAMENTO.NEXTVAL, i.NroEmpresa, '30-SEP-2021', 202109, X, 4, i.CodFuncionario, 0, round((nVlr2aParcela / 4), 2), nAnoMes,
                  0, i.NroPlanta, 994, 'S', 1, 'N', 'PLR Motoristas - Inclusão em Lote');
                   
            /*grava ocorrência primeira parcela*/
            DPKG_SEGURANCA.DGEP_Ocorrencia('FOLPAG', 'FOLPAG', 'FPLANCAGENDA', 'DFP_FUNCLANCTO', trim(TO_CHAR(i.NroEmpresa, '000')) || Trim(TO_CHAR(i.CodFuncionario, '0000000')), 1, 1, 'Inserido Lançamento Mês/Ano:' || TRIM(substr(nAnoMes, 5,2)) || '/' || TRIM(substr(nAnoMes, 1,4)) || ' - Evento: 994-PLR (Valor) - Valor: R$ ' ||  round((nVlr2aParcela / 4), 2), 'Inclusão em Lote - PLR Motoristas 2021', 'LDUTRA', 1);

            If X = 1 Then
               /*se o funcionário não contribui com o sindicato*/      
               If i.Descontaconfederativa = 'N' Then
                  /*Parcela 2 - Cont.Confedera */
                  Insert into DFP_FuncLancto 
                      (SeqLancamento, NroEmpresa, DtaLancamento, NroDocumento, NroParcela, TotalParcela, CodFuncionario, Referencia, Valor, AnoMes,
                       NroLote, NroPlanta, CodEvento, DescontarAfastado, TipoRecibo, Proporcional, Observacao)
                  Values
                      (S_DFP_LANCAMENTO.NEXTVAL, i.NroEmpresa, '30-SEP-2021', 202109, 2, 2, i.CodFuncionario, 0, 50.00, nAnoMes,
                       0, i.NroPlanta, 55, 'S', 1, 'N', 'PLR Motoristas - Contribuição Negocial - Inclusão em Lote');
                  /*grava ocorrência cont.negocial*/
                  DPKG_SEGURANCA.DGEP_Ocorrencia('FOLPAG', 'FOLPAG', 'FPLANCAGENDA', 'DFP_FUNCLANCTO', trim(TO_CHAR(i.NroEmpresa, '000')) || Trim(TO_CHAR(i.CodFuncionario, '0000000')), 1, 1, 'Inserido Lançamento Mês/Ano:' || TRIM(substr(nAnoMes, 5,2)) || '/' || TRIM(substr(nAnoMes, 1,4)) || ' - Evento: 000-Contribuição Negocial - Valor: R$ 50,00', 'Inclusão em Lote - PLR Motoristas 2021', 'LDUTRA', 1);
               End If;
            End If;
         End Loop;
      End If;
   End Loop;
End;


/*----------------------------------------------------------------------------------------*/

Select
  E.NroEmpresa, E.NomeReduzido as Empresa
  , F.CodFuncionario, F.Nome, F.DtaAdmissao
  , Decode(nvl(FP.DESCCONFEDERATIVA, 0), 0, 'N', 'S') as DescontaConfederativa
  , VD.CodDepartamento, VD.DescrDepartamento as Departamento, VD.CodSetor, VD.DescrSetor as Setor
  , Fu.DescrReduzida as Funcao
  , S.CodSindicato, S.Nome as Sindicato
  , 
  nvl((Select 
       Sum(DPKG_FolhaPagto.DFPF_QtdFaltasMes(BC.NroEmpresa, BC.CodFuncionario, 'I', BC.AnoMes)) as Falta
   from
      DFP_BaseCompetencia BC
   where
      BC.NroEmpresa = F.NroEmpresa
      and BC.CodFuncionario = F.CodFuncionario
      and BC.TipoRecibo = 1
      and BC.Anomes between 202005 and 202010
      ), 0) as QtdFaltaPrimSem
  , 
  nvl((Select 
       Sum(DPKG_FolhaPagto.DFPF_QtdFaltasMes(BC.NroEmpresa, BC.CodFuncionario, 'I', BC.AnoMes)) as Falta
   from
      DFP_BaseCompetencia BC
   where
      BC.NroEmpresa = F.NroEmpresa
      and BC.CodFuncionario = F.CodFuncionario
      and BC.TipoRecibo = 1
      and BC.Anomes between 202011 and 202104
      ), 0) as QtdFaltaSegSem
  ,Case DPKG_FolhaPagto.DFPF_FuncStatus(F.NroEmpresa, trunc(sysdate), trunc(sysdate), F.CodFuncionario) 
      When 'A' Then 'Ativo'
      When 'P' Then 'Prospect'
      When 'F' Then 'Ferias'
      When 'L' Then 'Afastado'
      When 'D' Then 'Desligado'
      When 'T' Then 'Transferido'        
      When 'C' Then 'Cancelado'
   End as Status
   , round(Decode(Greatest(F.DtaAdmissao, '01-may-2020'), F.DtaAdmissao, Months_between('30-APR-2021', F.DtaAdmissao), Months_Between('30-APR-2021', '01-MAY-2020')), 0) as QtdMeses
from
   DFP_Funcionario F
   , DFP_FuncParametro FP
   , DFP_Sindicato S
   , DFPV_DeptoSetorSecao VD
   , DFP_Funcao Fu
   , GE_EMPRESA E
where
   F.CodSindicato in (2,20)
   and F.CodCadastro = 1
   and F.Situacao = 'A'
   and FP.NroEmpresa = F.NroEmpresa
   and FP.CodFuncionario = F.CodFuncionario
   and VD.NroPlantaDepto = F.NroPlantaDepto
   and VD.CodDepartamento = F.CodDepartamento
   and VD.CodSetor = F.CodSetor
   and VD.CodSecao = F.CodSecao   
   and Fu.NroPlanta = F.NroPlanta
   and Fu.CodFuncao = F.CodFuncao
   and S.NroPlanta =  F.NroPlanta
   and S.CodSindicato = F.CodSindicato
   and E.NroEmpresa = F.NroEmpresa
   
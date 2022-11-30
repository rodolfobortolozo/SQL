CREATE OR REPLACE TYPE ESTFV_ESTOQUESEMANAL
IS OBJECT (
                   SeqClassifAbate NUMBER(15) ,
                   SeqProduto NUMBER(15),
                   DescrProduto varchar2(300),
                   Quantidade NUMBER(15,3),
                   QtdEmbalagem NUMBER(15,3),
                   PesoLiquido NUMBER(15,3),
                   DescrEmbalagem VARCHAR(300), 
                   NroEmpresa NUMBER(3),
                   NomeReduzido VARCHAR2(15),
                   ProdutoUnidade NUMBER(15),
                   DtaValidade DATE,
                   DtaProducao DATE,
                   QtdDiasVencto NUMBER(15),
                   TipoCalculo NUMBER(1),
                   SeqFaixaClassifAbate NUMBER(15),
                   DescrFamiliaProduto VARCHAR2(300),
                   CodBarra VARCHAR(300),
                   VlrUnitario INTEGER,
                   VlrTotal INTEGER,
                   QtdReservadaBloqueada INTEGER,
                   QtdEmbalagemReservadaBloqueada INTEGER,
                   PesoReservadoBloqueado INTEGER,
                   GrupoProd NUMBER(15),
                   SubGrupoProd NUMBER(15),
                   DescrGrupoProduto VARCHAR2(300),
                   DescrSubGrupoProduto VARCHAR2(300),
                   FamiliaProd NUMBER(15),
                   CodContrato NUMBER(15),
                   CodigoSIF NUMBER(15),
                   CodSetor NUMBER(15),
                   SeqEmbalagem NUMBER(15),
                   Lote NUMBER(38),
                   DataEnt DATE
    );
------------
CREATE OR REPLACE TYPE ESTFVT_ESTOQUESEMANAL AS TABLE OF ESTFV_ESTOQUESEMANAL;
------------
CREATE OR REPLACE FUNCTION ESTF_ESTOQUESEMANAL

RETURN ESTFVT_ESTOQUESEMANAL PIPELINED

IS
BEGIN

       FOR I IN (SELECT * FROM ESTFV_DATASEXTAFEIRA /*where dia = '25-NOV-2022'*/)
         LOOP

          FOR RECORD_OUTPUT IN (
              Select *
              From (Select E.SeqClassifAbate,
                     E.SeqProduto,
                     E.DescrProduto as Descricao,
                     Sum(E.Quantidade) as Quantidade,
                     Sum(E.QtdEmbalagem) as QtdEmbalagem,
                     Sum(E.PesoLiquido) as PesoLiquido,
                     E.DescrEmbalagem as Unidade,
                     E.NroEmpresa,
                     E.NomeReduzido,
                     E.SeqProduto || E.SeqEmbalagem as ProdutoUnidade,
                     E.DtaValidade,
                     E.DtaProducao,
                     E.DiasValidade as QtdDiasVencto,
                     E.TipoCalculo,
                     E.SeqFaixaClassifAbate,
                     E.DescrFamiliaProduto,
                     E.CodBarraInterno As CodBarra,
                     0 as VlrUnitario,
                     0 as VlrTotal,
                     0 as QtdReservadaBloqueada,
                     0 as QtdEmbalagemReservadaBloqueada,
                     0 as PesoReservadoBloqueado,
                     E.GrupoProd,
                     E.SubGrupoProd,
                     E.DescrGrupoProduto,
                     E.DescrSubGrupoProduto,
                     E.FamiliaProd,
                     E.CodContrato,
                     E.CodigoSIF,
                     E.CodSetor,
                     E.SeqEmbalagem,
                     E.Lote,
                     E.DataEnt
                From DINV_ConsultaEstoque E, DIN_ProdutoEmbalagem P
               Where P.SeqEmbalagem = E.SeqEmbalagem
                 and not E.Status in (9, 6, 7, 17, 11, 13)
                 and E.NroEmpresa in (2, 3, 100, 75, 77)
                 and (not E.Quantidade = 0 or not E.QtdEmbalagem = 0 or
                     not E.PesoLiquido = 0)
                 and E.DataHoraEnt <= I.DIA
                 and (E.DataHoraSai is null or (E.DataHoraSai >= I.DIA and
                     E.SeqEstoqueOrigem is Null))
               Group By E.SeqClassifAbate,
                        E.DescrClassifAbate,
                        E.SeqProduto,
                        E.DescrProduto,
                        E.DescrProdutoIndustria,
                        E.DescrEmbalagem,
                        E.NroEmpresa,
                        E.NomeReduzido,
                        E.DtaValidade,
                        E.DtaProducao,
                        E.DiasValidade,
                        E.TipoCalculo,
                        E.SeqFaixaClassifAbate,
                        E.DescrFaixaClassifAbate,
                        E.CodContrato,
                        E.SeqEmbalagem,
                        E.CodBarraExterno,
                        E.CodBarraInterno,
                        E.GrupoProd,
                        E.DescrGrupoProduto,
                        E.SubGrupoProd,
                        E.DescrSubGrupoProduto,
                        E.FamiliaProd,
                        E.DescrFamiliaProduto,
                        E.CodigoSIF,
                        E.CodSetor,
                        E.DescrSetor,
                        E.Lote,
                        E.DataEnt)
                        Order By SeqProduto, SeqEmbalagem, DtaProducao
            )
            LOOP
                PIPE ROW (ESTFV_ESTOQUESEMANAL( RECORD_OUTPUT.SeqClassifAbate,
                                                 RECORD_OUTPUT.SeqProduto,
                                                 RECORD_OUTPUT.Descricao,
                                                 RECORD_OUTPUT.Quantidade,
                                                 RECORD_OUTPUT.QtdEmbalagem,
                                                 RECORD_OUTPUT.PesoLiquido,
                                                 RECORD_OUTPUT.Unidade,
                                                 RECORD_OUTPUT.NroEmpresa,
                                                 RECORD_OUTPUT.NomeReduzido,
                                                 RECORD_OUTPUT.ProdutoUnidade,
                                                 RECORD_OUTPUT.DtaValidade,
                                                 RECORD_OUTPUT.DtaProducao,
                                                 RECORD_OUTPUT.QtdDiasVencto,
                                                 RECORD_OUTPUT.TipoCalculo,
                                                 RECORD_OUTPUT.SeqFaixaClassifAbate,
                                                 RECORD_OUTPUT.DescrFamiliaProduto,
                                                 RECORD_OUTPUT.CodBarra,
                                                 RECORD_OUTPUT.VlrUnitario,
                                                 RECORD_OUTPUT.VlrTotal,
                                                 RECORD_OUTPUT.QtdReservadaBloqueada,
                                                 RECORD_OUTPUT.QtdEmbalagemReservadaBloqueada,
                                                 RECORD_OUTPUT.PesoReservadoBloqueado,
                                                 RECORD_OUTPUT.GrupoProd,
                                                 RECORD_OUTPUT.SubGrupoProd,
                                                 RECORD_OUTPUT.DescrGrupoProduto,
                                                 RECORD_OUTPUT.DescrSubGrupoProduto,
                                                 RECORD_OUTPUT.FamiliaProd,
                                                 RECORD_OUTPUT.CodContrato,
                                                 RECORD_OUTPUT.CodigoSIF,
                                                 RECORD_OUTPUT.CodSetor,
                                                 RECORD_OUTPUT.SeqEmbalagem,
                                                 RECORD_OUTPUT.Lote,
                                                 RECORD_OUTPUT.DataEnt)
                                                 );
            END LOOP;


         END LOOP;
END;
---------------------
select * from table(ESTF_ESTOQUESEMANAL)
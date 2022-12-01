--Conando criado para ler as tag dos xml salvo em banco de dados Oracle

SELECT extractValue(Value(TagBaseProduto),
                    '*/prod/CFOP',
                    'xmlns="http://www.portalfiscal.inf.br/nfe"') as CFOP,
       extractValue(Value(TagBaseConteudo),
                    '*/ide/nNF',
                    'xmlns="http://www.portalfiscal.inf.br/nfe"') as nNF,
       N.SeqNotaFiscal
  FROM DGE_ARQUIVOXML X,
       TABLE(XMLSequence(extract(XmlType(X.Conteudo),
                                 '/enviNFe',
                                 'xmlns="http://www.portalfiscal.inf.br/nfe"'))) TagBaseInicial,
       TABLE(XMLSequence(extract(VALUE(TagBaseInicial),
                                 '*/NFe/infNFe',
                                 'xmlns="http://www.portalfiscal.inf.br/nfe"'))) TagBaseConteudo,
       TABLE(XMLSequence(extract(VALUE(TagBaseConteudo),
                                 '*/det',
                                 'xmlns="http://www.portalfiscal.inf.br/nfe"'))) TagBaseProduto,
       DCE_Notafiscal N
 WHERE X.SeqArquivoXML = N.SeqArquivoXML
   AND N.DTACHEGADA>='01-JAN-2022'
   AND N.Statusnotafiscal <> 9
   AND N.StatusFinanceiro <> 9
   AND Exists (Select xI.SeqIntFinanceiro
          FROM DGE_IntFinanceiro xI
         WHERE xI.CodLink = N.SeqNotaFiscal
           AND xI.TabLink = 'CE'
           AND xI.Status <> 9)
   AND extractValue(Value(TagBaseConteudo),
                    '*/ide/nNF',
                    'xmlns="http://www.portalfiscal.inf.br/nfe"') = N.Nronotafiscal
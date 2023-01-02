BEGIN 
  FOR I IN(
            SELECT X.*, D.SEQDEPOSITARIO FROM (
            SELECT SUBSTR(T.OCORRENCIA, 0, INSTR(T.OCORRENCIA,'para',1,1)-2) CERTO, substr(T.DETALHE,INSTR(T.DETALHE,'para',1,1)+5,999) ERRADO,  T.CODLINK, DETALHE FROM  (
              SELECT REPLACE(DETALHE,'Depositário de ','') OCORRENCIA, CODLINK, DETALHE
              FROM DGE_OCORRENCIA
              WHERE MOTIVO = 'ALTERAÇÃO DE ESPÉCIE'
              AND DATA >='29-DEC-2022'
              AND DETALHE LIKE '%Depositário%' ) t
              ) X,  FI_DEPOSITARIO D
              WHERE D.DESCRICAO (+) = X.CERTO 
              --and CODLINK = '580000519699322'
           )
   LOOP
              UPDATE FI_TITULO y SET y.Seqdepositario = I.Seqdepositario where y.seqtitulo = i.codlink;
              
              INSERT INTO DGE_OCORRENCIA (TIPO,NIVEL,DATA,HORA,CODUSUARIO,DETALHE,MOTIVO,SISTEMA,MODULO,TABLINK,TERMINAL,
              USUARIOOS,CODAPLICACAO,SESSIONID,CODLINK)
            VALUES(7,1,TRUNC(SYSDATE),162600,'RODOLFO.BORTOLOZO','Depositário de '||I.ERRADO ||' para '|| I.CERTO,
            'CORREÇÃO/ALTERAÇÃO DE DEPOSITÁRIO','FINANCEIRO','OPERADORPLUS','FI_TITULO','DESKTOP-1U8AVLM','rodolfo.bortolozo','FIALTTITULO',NULL, I.CODLINK); 
              
   END LOOP;
END;

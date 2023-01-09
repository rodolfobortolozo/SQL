/*CRIA JOB DE ATUALIZAÇÃO MVIEW */
BEGIN
DBMS_REFRESH.MAKE(NAME=>'DCUVQM_VALOR_MERCADO', LIST=>'DCUVQM_VALOR_MERCADO', NEXT_DATE => SYSDATE, INTERVAL => 'NULL');
END;

/*ATUALIZA MVIEW*/
BEGIN
  DBMS_MVIEW.REFRESH('DCUVQM_VALOR_MERCADO');
END;

/*EXCLUI JOB MVIEW*/
BEGIN
DBMS_REFRESH.DESTROY ('DCUVQM_VALOR_MERCADO');
END;
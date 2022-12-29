CREATE OR REPLACE TRIGGER TBI_DGE_EMAIL_PedidoCompra
BEFORE INSERT ON DGE_EMAIL
FOR EACH ROW
  /************************************************/
  /*Author  : Rodolfo Bortolozo                   */
  /*Created : 25/05/2022                          */
  /*Purpose : Envio de Email Pedido de Compra     */
  /************************************************/
DECLARE
      Verifica INTEGER;
      NroEmpresa INTEGER;
      emailCC Varchar2(4000);
   BEGIN


   Verifica := INSTR(:NEW.CONTEUDO, '<EMPRESAPEDIDO>');

   IF Verifica > 0 THEN
      NroEmpresa := TO_NUMBER(
              REPLACE(REPLACE(SUBSTR(:NEW.CONTEUDO,
                      instr(:NEW.CONTEUDO,'<EMPRESAPEDIDO>')+15,
                      3 ),'</','')
               ,'<',''));

      IF NROEMPRESA = 77 THEN
        emailCC := '';
      ELSIF NROEMPRESA = 18 THEN
        emailCC := '';
      ELSIF NROEMPRESA IN (1,2) THEN
        emailCC := '';
      ELSIF NROEMPRESA = 4 THEN
        emailCC := '';
      ELSIF NROEMPRESA = 12 THEN
        emailCC := '';
      ELSIF NROEMPRESA IN (83, 980) THEN
        emailCC := '';
      ELSIF NROEMPRESA = 105 THEN
        emailCC := '';
      ELSIF NROEMPRESA = 104 THEN
        emailCC := '';
      ELSIF NROEMPRESA = 6 THEN
        emailCC := '';
      ELSIF NROEMPRESA = 72 THEN
        emailCC := '';
        
      ELSE
        emailCC := Null;
    END IF;
      
     IF :NEW.DESTINATARIOCC IS NULL THEN
       :NEW.DESTINATARIOCC := emailCC;
       ELSE
         IF emailCC is not null Then
          :NEW.DESTINATARIOCC := :NEW.DESTINATARIOCC|| '; '|| emailCC;
         END IF;
     END IF;

   END IF;

END;

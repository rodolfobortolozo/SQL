DECLARE
  p_url varchar2(4000); 
  p_username varchar2(4000); 
  p_password varchar2(4000); 
  p_wallet_path varchar2(4000); 
  p_wallet_password varchar2(4000); 

  l_http_request   UTL_HTTP.req;
  l_http_response  UTL_HTTP.resp;
  l_text           VARCHAR2(32767);
BEGIN
  -- HTTPS usa wallet
  p_wallet_path :='';
  p_wallet_password :='';
  
  p_url := 'http://viacep.com.br/ws/15600076/json/';
  
  IF p_wallet_path IS NOT NULL AND p_wallet_password IS NOT NULL THEN
    UTL_HTTP.set_wallet('file:' || p_wallet_path, p_wallet_password);
  END IF;
  
  -- Requisi��o HTTP
  l_http_request  := UTL_HTTP.begin_request(p_url, 'GET');

  -- Autentica��o
  IF p_username IS NOT NULL and p_password IS NOT NULL THEN
    UTL_HTTP.set_authentication(l_http_request, p_username, p_password);
  END IF;

  l_http_response := UTL_HTTP.get_response(l_http_request);

  -- Resposta
  BEGIN
    LOOP
      UTL_HTTP.read_text(l_http_response, l_text, 32766);
      DBMS_OUTPUT.put_line (l_text);
    END LOOP;
  EXCEPTION
    WHEN UTL_HTTP.end_of_body THEN
      UTL_HTTP.end_response(l_http_response);
  END;
EXCEPTION
  WHEN OTHERS THEN
    UTL_HTTP.end_response(l_http_response);
    RAISE;
END;

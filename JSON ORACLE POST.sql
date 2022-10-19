declare
req utl_http.req;
res utl_http.resp;
url varchar2(4000) := 'http://200.206.8.10:21115/api/rotas';
name varchar2(4000);
buffer varchar2(4000); 
content varchar2(4000);

begin

for i in (select * from iv_historico where acaogeradora = 16 and ( latitude is not null and longitude is not null) and dtarealizacao >='12-sep-2022')
loop
  
      content := '{"idUsr": "'||i.codusuario||'", "latitude": "'||replace(i.latitude,',','.')||'", "longitude": "'||replace(i.longitude,',','.')||'"}';
      
      req := utl_http.begin_request(url, 'POST',' HTTP/1.1');
      utl_http.set_header(req, 'user-agent', 'mozilla/4.0'); 
      utl_http.set_header(req, 'content-type', 'application/json'); 
      utl_http.set_header(req, 'Content-Length', length(content));

      utl_http.write_text(req, content);

      res := utl_http.get_response(req);
      
          begin
          loop
          utl_http.read_line(res, buffer);
          --dbms_output.put_line(buffer);

          end loop;
          utl_http.end_response(res);
          exception
          when utl_http.end_of_body then
          utl_http.end_response(res);
          end;
end loop;
end;

DECLARE
  l    VARCHAR2(1000);
  d    DATE := SYSDATE; 
  TYPE tab IS TABLE OF NUMBER(02) INDEX BY BINARY_INTEGER;
  i    NUMBER(02) := TO_CHAR(TRUNC(d,'MONTH'),'D');
  dia  tab;  
  c    NUMBER(02) := 1;
  POS  NUMBER     := 0;
  CURSOR C1 IS
    SELECT DIA, MES FROM
    (
      SELECT '03' DIA,'08' MES, 'Compromisso      '  DES
      FROM DUAL
    )
    WHERE MES IN (TO_CHAR(d,'MM'),'**');
BEGIN
  EXECUTE IMMEDIATE ('ALTER SESSION SET NLS_LANGUAGE=PORTUGUESE');
  DBMS_OUTPUT.PUT_LINE('.');
  DBMS_OUTPUT.PUT_LINE(REPLACE(REPLACE(to_char(d,'Day, DD . Month . YYYY, hh24:mi:ss'),' ',NULL),'.',' de '));
  DBMS_OUTPUT.PUT_LINE('.');
  DBMS_OUTPUT.PUT_LINE('Dom  Seg  Ter  Qua  Qui  Sex  Sab');
  DBMS_OUTPUT.PUT_LINE('---  ---  ---  ---  ---  ---  ---');
  EXECUTE IMMEDIATE ('ALTER SESSION SET NLS_LANGUAGE=ENGLISH');
  FOR ind IN TO_NUMBER(TO_CHAR(TRUNC(D,'MONTH'),'D'))..42
  LOOP
    IF c > TO_NUMBER(TO_CHAR(LAST_DAY(D),'DD')) THEN
      EXIT;
    END IF;
    dia(ind) := C;
    c        := c + 1;
  END LOOP;
  FOR ind IN 1..42
  LOOP
    IF dia.EXISTS(ind) THEN
      IF SUBSTR(TO_CHAR(dia(ind),'00'),2,2) = '01' THEN
        l := l || SUBSTR(TO_CHAR(dia(ind),'00'),2,2);
      ELSE
        l := l ||'  ' || TO_CHAR(dia(ind),'00');
      END IF;
    ELSE
      l :=  l ||'.....';
    END IF;
  END LOOP;
  l := REPLACE(l,TO_CHAR(d,'DD')||' ',TO_CHAR(d,'DD')||'<');
  l := REPLACE(l,'.',' ');
  IF SUBSTR(l,1,1) = ' ' THEN
    l := '.' || SUBSTR(L,2,999);
  END IF;
  FOR R1 IN C1
  LOOP
    l := REPLACE(l,r1.DIA||'  ',r1.DIA||'* ');
    l := REPLACE(l,r1.DIA||'< ',r1.DIA||'<*');
  END LOOP;
  FOR i IN 1..6
  LOOP
    DBMS_OUTPUT.PUT_LINE(SUBSTR(l,(i*35)-34,35));
  END LOOP;
END;

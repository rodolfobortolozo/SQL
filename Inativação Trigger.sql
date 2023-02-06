begin

  for i in (select *
              from all_objects
             where owner = 'RM'
               and object_type = 'TRIGGER'
               AND object_name like 'LOG%') 
  loop
  
    EXECUTE IMMEDIATE 'ALTER TRIGGER ' || i.Object_Name || ' DISABLE';
  
  end loop;

end;

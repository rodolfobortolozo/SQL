create or replace function DistanciaLatLng(Latitude1 number, Longitude1 number, 
                                           Latitude2 number, Longitude2 number)
return number is 
/*
       Function to Calculate Distance km KM with latitudes and longitudes.
       Rodolfo Bortolozo
*/
   
   Distancia number;
   Pi number;

begin

      
      Pi := 3.141618;
  
      Distancia :=  ACOS(SIN(pi*Latitude1/180.0)*SIN(pi*Latitude2/180.0)+COS(pi*Latitude1/180.0)*COS(pi*Latitude2/180.0)*
              COS(pi*Longitude1/180.0-pi*Longitude2/180.0))*6378.137;
              
                 
    return distancia;
   exception
      when others then return 0;
end DistanciaLatLng;
/

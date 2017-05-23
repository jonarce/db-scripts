## Show hotel distance from a given GPS location
## can be used with any other table as well to calculate distances
## or in where clauses to limit distances
use eanprod;

SELECT EANHotelID,Name,DISTANCE_BETWEEN_GPS(-34.017330, 22.809500, latitude, longitude) AS 'GPSdistance'
FROM activepropertylist

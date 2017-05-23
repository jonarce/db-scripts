/* 
SQLite query to obtain the count of hotels in each matching
parentregionlist table
*/
select parentregionlist.RegionID,RegionNameLong,RegionName,RegionType,SubClass, (
    SELECT COUNT(EANHotelID) 
    FROM regioneanhotelidmapping
    WHERE regioneanhotelidmapping.RegionID = parentregionlist.RegionID) AS 'HOTELS_IN_REGION_COUNT'
 from parentregionlist
 where RegionNameLong LIKE "%Granada%"
 
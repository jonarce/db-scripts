-- Get the best match from the records
use eangeo;
select AirportCode,AirportName,
IF(parentregionlist.ParentRegionType='Multi-City (Vicinity)',ParentRegionID,parentregionlist.RegionID) AS 'BestRegionIDs',
IF(parentregionlist.ParentRegionType='Multi-City (Vicinity)',ParentRegionNameLong,parentregionlist.RegionNameLong) AS 'BestRegionNames',
eanprod.HOTELS_IN_REGION_COUNT(IF(parentregionlist.ParentRegionType='Multi-City (Vicinity)',ParentRegionID,parentregionlist.RegionID)) AS 'HotelAmt',
eanprod.HOTELS_IN_REGION(      IF(parentregionlist.ParentRegionType='Multi-City (Vicinity)',ParentRegionID,parentregionlist.RegionID)) AS 'HotelIDs'
FROM geo_airportcoordinateslist, geo_citycoordinateslist
-- join the region parent table to know if is better to sell a City (and Vicinity) record
LEFT JOIN eanprod.parentregionlist
ON geo_citycoordinateslist.RegionID = parentregionlist.RegionID
WHERE
-- Airport that are inside those cities (the point is inside the polygon)
    ST_CONTAINS(geo_citycoordinateslist.geo_polygon,geo_airportcoordinateslist.geo_point)

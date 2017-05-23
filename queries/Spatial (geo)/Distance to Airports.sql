-- try the query using the Spatial Index for hotels
-- in order to find the nearest Airport with Service
USE eangeo;
SELECT 
    EANHotelID,Name,Address1,Address2,City,StateProvince,Country,PostalCode,
    IATACode,AirportType,ISORegion,Municipality,AirportName,
    `eanprod`.`DISTANCE_BETWEEN_GPS`(geo_activepropertybusinessmodel.Latitude, geo_activepropertybusinessmodel.Longitude, 
                                     geo_ourairports.Latitude, geo_ourairports.Longitude) AS 'Distance',
    (ST_DISTANCE(geo_activepropertybusinessmodel.geo_point, geo_ourairports.geo_point)) AS 'Calc'
    ,ST_ASTEXT(geo_ourairports.geo_point) AS 'Airport_Location'
FROM
    geo_activepropertybusinessmodel
    
JOIN geo_ourairports
ON ISOCountry = Country
WHERE
-- 4110 Atlantic City, 173179 Frisco TX
    EANHotelID = 173179 AND
    ST_DISTANCE(geo_activepropertybusinessmodel.geo_point, geo_ourairports.geo_point) < 1
ORDER BY ST_DISTANCE(geo_activepropertybusinessmodel.geo_point, geo_ourairports.geo_point)

-- http://stackoverflow.com/questions/5817395/how-can-i-loop-through-all-rows-of-a-table-mysql#16350693
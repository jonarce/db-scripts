-- try the query using the Spatial Index for hotels
-- in certain distance of a POI 
-- the Tour Eiffel (http://www.findlatitudeandlongitude.com/?loc=Tour+Eiffel)
-- Latitude:48.858844, Longitude:2.294351
USE eangeo;
SET @pt1 = ST_GeomFromText('POINT(48.858844 2.294351)');
SELECT 
    EANHotelID,Name,Address1,Address2,City,StateProvince,Country,PostalCode,
    ROUND(ST_DISTANCE_SPHERE(geo_point, @pt1)) AS 'Meters'
FROM
    geo_activepropertylist
WHERE
    City LIKE '%Paris%' AND Country = 'FR'
        AND ROUND(ST_DISTANCE_SPHERE(geo_point, @pt1)) < 8000

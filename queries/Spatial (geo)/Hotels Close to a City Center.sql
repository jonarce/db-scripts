-- try the query using the Spatial Index for hotels
-- in certain distance of a City Center 

USE eangeo;
SELECT geo_point INTO @pt 
FROM geo_regioncentercoordinateslist 
WHERE RegionName LIKE '%Genting Highlands%'
LIMIT 1;

-- now use that point to search for hotels
SELECT 
    EANHotelID,Name,Address1,Address2,City,StateProvince,Country,PostalCode,
	ROUND(SLC(geo_point,@pt)) AS 'Distance'

FROM
    geo_activepropertylist
WHERE
   ROUND(SLC(geo_point, @pt)) < 19
   ORDER BY 'Distance';
    
/* Use Spatial Data Functions to find all hotels
inside a polygon */
-- RegionID 1000 - Dallas, TX, US
-- RegionID: 2122 - Liverpool, England, UK

use eangeo;

SELECT 
    IATACode, AirportName,AirportType, ISORegion, ISOCountry,
    geo_citycoordinateslist.RegionID, geo_citycoordinateslist.RegionName,
    SLC(geo_regioncentercoordinateslist.geo_point, geo_ourairports.geo_point) AS 'KM_Distance'
FROM
    geo_citycoordinateslist,geo_ourairports
LEFT JOIN geo_regioncentercoordinateslist
    ON geo_citycoordinateslist.RegionID = geo_regioncentercoordinateslist.RegionID
WHERE
    ST_CONTAINS(geo_citycoordinateslist.geo_polygon,geo_ourairports.geo_point) 
	AND geo_citycoordinateslist.RegionID = 1000
;

/* Use Spatial Data Functions to find all hotels
inside a polygon */
-- RegionID 1000 - Dallas, TX, US
-- RegionID: 2122 - Liverpool, England, UK

use eangeo;

SELECT 
    EANHotelID, Name, City, StateProvince, Country, Coordinates
FROM
    geo_citycoordinateslist,
    geo_activepropertylist
WHERE
    ST_CONTAINS(geo_citycoordinateslist.geo_polygon,
            geo_activepropertylist.geo_point)
        AND geo_citycoordinateslist.RegionID = 1000;

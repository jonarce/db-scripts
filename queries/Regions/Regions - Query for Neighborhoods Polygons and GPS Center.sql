/*
-- Get All the Neigborhoods Center and its Polygons
*/USE eanprod;
SELECT regioncentercoordinateslist.RegionID,regioncentercoordinateslist.RegionName,Coordinates,
		CenterLatitude,CenterLongitude
FROM regioncentercoordinateslist
LEFT JOIN neighborhoodcoordinateslist
ON regioncentercoordinateslist.RegionID=neighborhoodcoordinateslist.RegionID
WHERE neighborhoodcoordinateslist.RegionID IS NOT NULL;




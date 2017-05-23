/*
-- Get All the Cities Center and its Polygons
*/
use eanprod;
SELECT regioncentercoordinateslist.RegionID,regioncentercoordinateslist.RegionName,Coordinates,
		CenterLatitude,CenterLongitude
FROM regioncentercoordinateslist
LEFT JOIN citycoordinateslist
ON regioncentercoordinateslist.RegionID=citycoordinateslist.RegionID
WHERE citycoordinateslist.RegionID IS NOT NULL


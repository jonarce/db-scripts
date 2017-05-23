#Query to get all Coordinates to be able to draw over a map
# a Multi-Vicinity type of region
use eanprod;
# get the "Cities"
SELECT parentregionlist.RegionID,parentregionlist.RegionName,RegionType,citycoordinateslist.Coordinates
FROM parentregionlist
JOIN citycoordinateslist ON parentregionlist.RegionID = citycoordinateslist.RegionID
WHERE ParentRegionID=178286
AND RegionType="City"
UNION ALL
# get the "Neigboorhoods"
SELECT parentregionlist.RegionID,parentregionlist.RegionName,RegionType,neighborhoodcoordinateslist.Coordinates
FROM parentregionlist
JOIN neighborhoodcoordinateslist ON parentregionlist.RegionID = neighborhoodcoordinateslist.RegionID
WHERE ParentRegionID=178286
AND RegionType="Neighborhood"
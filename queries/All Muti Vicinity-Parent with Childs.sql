use eanprod;
SELECT ParentRegionID,ParentRegionName,ParentRegionType,parentregionlist.RegionID,RegionNameLong,
       regioncentercoordinateslist.CenterLatitude,regioncentercoordinateslist.CenterLongitude,
       HOTELS_IN_REGION_COUNT(parentregionlist.RegionID) AS 'AmtHotels',
       HOTELS_IN_REGION(parentregionlist.RegionID) AS 'SortedHotelList'
FROM parentregionlist 
   LEFT JOIN regioncentercoordinateslist
   ON parentregionlist.RegionID = regioncentercoordinateslist.RegionID
WHERE ParentRegionID IN
   (SELECT RegionID FROM parentregionlist WHERE RegionType = "Multi-City (Vicinity)")
   ORDER BY ParentRegionName;

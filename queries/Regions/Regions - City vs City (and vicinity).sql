### Compare Regular Cities vs. Cities (and Vicinity)
use eanprod;
select ParentRegionID,ParentRegionNameLong,HOTELS_IN_REGION_COUNT(ParentRegionID) AS 'ParentHotels',
RegionID,RegionNameLong,HOTELS_IN_REGION_COUNT(RegionID) AS 'Hotels'
 FROM parentregionlist
 WHERE ParentRegionNameLong LIKE "%(and vicinity)%"
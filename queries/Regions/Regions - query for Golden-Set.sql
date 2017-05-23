### Create what we call the Regions Golden-Set
### our most important regions that contains the Multy-Vicinity Regions
use eanprod;
select RegionID,RegionName,RegionNameLong,RegionType,SubClass,
HOTELS_IN_REGION_COUNT(RegionID) AS 'AmtOfHotels',
HOTELS_IN_REGION(RegionID) AS  'ListOfEANIDs'
from ParentRegionList 
WHERE eanprod.parentregionlist.RegionType='Multi-City (Vicinity)' AND eanprod.parentregionlist.SubClass=''
ORDER BY RegionNameLong
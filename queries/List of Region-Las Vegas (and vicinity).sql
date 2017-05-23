### Las Vegas (and vicinity) with Hotel Names, Rating and Categories
use eanprod;
select parentregionlist.RegionID, RegionType, SubClass, RegionName, RegionNameLong,
	   HOTELS_IN_REGION_COUNT(parentregionlist.RegionID) AS 'AmtOfHotels',regioneanhotelidmapping.EANHotelID,Name,StarRating,PropertyCategoryDesc 
from parentregionlist
LEFT JOIN regioneanhotelidmapping
ON parentregionlist.RegionID=regioneanhotelidmapping.RegionID
LEFT JOIN activepropertybusinessmodel
ON regioneanhotelidmapping.EANHotelID=activepropertybusinessmodel.EANHotelID
LEFT JOIN propertytypelist
ON propertytypelist.PropertyCategory=activepropertybusinessmodel.PropertyCategory
where parentregionlist.RegionID=178276
/*
** Query to get the best recomended Region for an Hotel
** it used the RegionID field of the hotel table, but check if the
** ParentRegion is of 'Multi-City (Vicinity) type to use that one instead.
** Expanded to include the Default City for partners that need it.
*/
USE eanprod;
SELECT 
    EANHotelID,
    Name,
    City,
    StateProvince,
    PostalCode,
    Country,
    IF(parentregiontype = 'Multi-City (Vicinity)',
        ParentRegionID,
        parentregionlist.RegionID) AS 'Best_Region_ID',
    IF(parentregiontype = 'Multi-City (Vicinity)',
        ParentRegionNameLong,
        RegionNameLong) AS 'Best_Region_Name',
    IF(parentregiontype = 'Multi-City (Vicinity)',
        ParentRegionType,
        RegionType) AS 'Best_Region_Type',
    IF(parentregiontype = 'Multi-City (Vicinity)',
        HOTELS_IN_REGION_COUNT(ParentRegionID),
        HOTELS_IN_REGION_COUNT(parentregionlist.RegionID)) AS 'Best_Region_Count',
	-- the regular Region (city type)
	parentregionlist.RegionID, RegionNameLong, RegionType,
	HOTELS_IN_REGION_COUNT(parentregionlist.RegionID) AS 'Region_Count',
    IF(BusinessModelMask = 1, 'pre-pay',IF(BusinessModelMask = 2, 'post-pay','both')) 
    AS 'Payment_Model'
FROM
    activepropertybusinessmodel
        LEFT JOIN
    parentregionlist ON activepropertybusinessmodel.RegionID = parentregionlist.RegionID
ORDER BY Country , StateProvince , City
;

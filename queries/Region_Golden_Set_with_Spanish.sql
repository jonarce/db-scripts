use eanprod;
SELECT parentregionlist.RegionID, REGION_NAME_CLEAN(parentregionlist.RegionNameLong) AS 'Destination_en_us',
       REGION_NAME_CLEAN(regionlist_es_es.RegionNameLong) AS 'Destination_es_es',parentregionlist.RegionNameLong,
       RegionType, HOTELS_IN_REGION_COUNT(parentregionlist.RegionID) AS 'AmtOfHotels'
FROM parentregionlist

LEFT JOIN regionlist_es_es ON
parentregionlist.RegionID = regionlist_es_es.RegionID

####### Multi-City (Vicinity) - about 2700 records Priority # 01
WHERE (RegionType = "Multi-City (Vicinity)" AND SubClass="") OR
####### City records that do NOT have a Multi-City (Vicinity) - about 11000 records Priority # 02
	  (RegionType = "City" AND SubClass="" AND ParentRegionType <> "Multi-City (Vicinity)") OR
####### City records that do NOT have a Multi-City (Vicinity) - about 1400 records Priority # 03
	  (RegionType = "Neighborhood" AND SubClass="neighbor")
### you need to adjust this order depending on the language you need
ORDER BY REGION_NAME_CLEAN(RegionNameLong)
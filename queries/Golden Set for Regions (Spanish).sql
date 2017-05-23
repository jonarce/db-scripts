# Golden Set for Region
# could be used as a base of autocomplete
# this include the top 3 groups of data to use
use eanprod;
SELECT REGION_NAME_CLEAN(regionlist_es_es.RegionNameLong) AS 'SpanishName',parentregionlist.RegionNameLong, parentregionlist.RegionID, RegionType
FROM parentregionlist
####### Mixing it up with other languages
JOIN regionlist_es_es
	ON parentregionlist.RegionID = regionlist_es_es.RegionID

####### Multi-City (Vicinity) - about 2700 records Priority # 01
WHERE (RegionType = "Multi-City (Vicinity)" AND SubClass="") OR
####### City records that do NOT have a Multi-City (Vicinity) - about 11000 records Priority # 02
	  (RegionType = "City" AND SubClass="" AND ParentRegionType <> "Multi-City (Vicinity)") OR
####### City records that do NOT have a Multi-City (Vicinity) - about 1400 records Priority # 03
	  (RegionType = "Neighborhood" AND SubClass="neighbor")
### you need to adjust this order depending on the language you need

ORDER BY REGION_NAME_CLEAN(SpanishName)
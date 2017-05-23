-- Create an EANHotelID to ExpediaID mapping table
use eanmap;
SELECT EANHotelID,Name,EAN.GiataID,EXP.GiataID,EXP.ProviderID AS 'ExpediaID'
	FROM eanprod.activepropertybusinessmodel
-- get the GiataID from that EANHotelID
JOIN giataproviders AS EAN ON EANHotelID = ProviderID AND EAN.ProviderCode='expedia_ean'
-- get the ExpediaID linked to that GiataID
JOIN giataproviders AS EXP ON EAN.GiataID = EXP.GiataID AND EXP.ProviderCode='expedia_id'

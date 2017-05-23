/*
-- Hotels with Resort Fees
*/
use eanprod;
select propertymandatoryfeeslist.EANHotelID,Name,Address1,Address2,City,StateProvince,PostalCode,Country,BusinessModelMask,
    SUBSTRING(PropertyMandatoryFeesDescription,LOCATE('Resort fee:',PropertyMandatoryFeesDescription),
    (LOCATE('<',PropertyMandatoryFeesDescription,LOCATE('Resort fee:',PropertyMandatoryFeesDescription))-LOCATE('Resort fee:',PropertyMandatoryFeesDescription))) AS 'ResortFee'
FROM propertymandatoryfeeslist
JOIN activepropertybusinessmodel
ON propertymandatoryfeeslist.EANHotelID=activepropertybusinessmodel.EANHotelID 
WHERE PropertyMandatoryFeesDescription LIKE "%Resort Fee:%"

-- Resort fee: USD 10.00 per accomodation, per night<
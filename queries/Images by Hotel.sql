-- All Hotels with Image count
use eanprod;
select activepropertylist.EANHotelID,Name,CONCAT(Address1,',',Address2,',',City,',',StateProvince,',',PostalCode) AS 'Location',COUNT(hotelimagelist.EANHotelID) AS 'Image_Amt'
FROM activepropertylist
JOIN hotelimagelist ON activepropertylist.EANHotelID = hotelimagelist.EANHotelID
GROUP BY activepropertylist.EANHotelID
ORDER BY Country,StateProvince,City





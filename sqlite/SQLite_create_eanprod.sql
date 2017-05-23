/*******************************************************
** SQLlite_create_eanprod.sql                    v1.7 **
** Requires: SQLite 3.7.15+                           **
** SCRIPT TO GENERATE EAN DATABASE IN SQLITE3 ENGINE  **
** BE CAREFUL AS IT WILL ERASE THE EXISTING DATABASE  **
** YOU CAN USE SECTIONS OF IT TO RE-CREATE TABLES     **
********************************************************
**
** to create the database /or connect to an existing one
** just dcreate a directory to save all data and issue: 
** $sqlite3 eanprod.sqlite3
*/

/*******************************************************
**                                                    **
** TABLES CREATED FROM THE EAN RELATIONAL DOWNLOADED  **
** FILES.                                             **
**                                                    **
*******************************************************/
DROP TABLE IF EXISTS activepropertylist;
CREATE TABLE activepropertylist 
(
	EANHotelID integer NOT NULL,
	SequenceNumber integer DEFAULT NULL, 
	Name varchar (70) DEFAULT NULL,
	Address1 varchar (50) DEFAULT NULL,
	Address2 varchar (50) DEFAULT NULL,
	City varchar (50) DEFAULT NULL,
	StateProvince varchar (2) DEFAULT NULL,
	PostalCode varchar (15) DEFAULT NULL,
	Country varchar (2) DEFAULT NULL,
	Latitude decimal (8, 5) DEFAULT NULL,
	Longitude decimal (8, 5) DEFAULT NULL,
	AirportCode varchar (3) DEFAULT NULL,
	PropertyCategory integer DEFAULT NULL,
	PropertyCurrency varchar (3) DEFAULT NULL,
	StarRating decimal (2, 1) DEFAULT NULL,
	Confidence integer DEFAULT NULL,
	SupplierType varchar (3) DEFAULT NULL,
	Location varchar (80) DEFAULT NULL,
	ChainCodeID integer DEFAULT NULL,
	RegionID integer DEFAULT NULL,
	HighRate decimal (19,4) DEFAULT NULL,
	LowRate decimal (19,4) DEFAULT NULL,
 	CheckInTime varchar (10) DEFAULT NULL,
 	CheckOutTime varchar (10) DEFAULT NULL,
 	PRIMARY KEY (EANHotelID)
 );
CREATE INDEX activepropertylist_activeproperties_geoloc ON activepropertylist (Latitude, Longitude);
CREATE INDEX activepropertylist_activeproperties_regionid ON activepropertylist (RegionID);


DROP TABLE IF EXISTS activepropertybusinessmodel; 
CREATE TABLE activepropertybusinessmodel
(
	EANHotelID integer NOT NULL,
	SequenceNumber integer DEFAULT NULL,
	Name varchar (70) DEFAULT NULL,
	Address1 varchar (50) DEFAULT NULL,
	Address2 varchar (50) DEFAULT NULL,
	City varchar (50) DEFAULT NULL,
	StateProvince varchar (2) DEFAULT NULL,
	PostalCode varchar (15) DEFAULT NULL,
	Country varchar (2) DEFAULT NULL,
	Latitude decimal (8,5) DEFAULT NULL,
	Longitude decimal (8,5) DEFAULT NULL,
	AirportCode varchar (3) DEFAULT NULL,
	PropertyCategory int (11) DEFAULT NULL,
	PropertyCurrency varchar (3) DEFAULT NULL,
 	StarRating decimal (2,1) DEFAULT NULL,
 	Confidence integer DEFAULT NULL,
 	SupplierType varchar (3) DEFAULT NULL,
 	Location varchar (80) DEFAULT NULL,
 	ChainCodeID integer DEFAULT NULL,
 	RegionID integer DEFAULT NULL,
 	HighRate decimal (19,4) DEFAULT NULL,
	LowRate decimal (19,4) DEFAULT NULL,
	CheckInTime varchar (10) DEFAULT NULL,
	CheckOutTime varchar (10) DEFAULT NULL,
	BusinessModelMask integer (1) DEFAULT NULL,
	PRIMARY KEY (EANHotelID)
);


DROP TABLE IF EXISTS airportcoordinateslist;
CREATE TABLE airportcoordinateslist 
(
	AirportID integer NOT NULL,
	AirportCode varchar (3) NOT NULL,
 	AirportName varchar (70) DEFAULT NULL,
 	Latitude decimal (9,6) DEFAULT NULL,
	Longitude decimal (9,6) DEFAULT NULL,
 	MainCityID integer DEFAULT NULL,
 	CountryCode varchar (2) DEFAULT NULL,
 	PRIMARY KEY (AirportCode)
);
CREATE INDEX airportcoordinateslist_idx_airportcoordinatelist_airportname ON airportcoordinateslist (AirportName);
CREATE INDEX airportcoordinateslist_idx_airportcoordinatelist_maincityid ON airportcoordinateslist (MainCityID);
CREATE INDEX airportcoordinateslist_airportcoordinate_geoloc ON airportcoordinateslist (Latitude, Longitude);


DROP TABLE IF EXISTS aliasregionlist;
CREATE TABLE aliasregionlist 
(
	RegionID integer NOT NULL,
 	LanguageCode varchar (5) DEFAULT NULL,
 	AliasString varchar (255) DEFAULT NULL
);
CREATE INDEX aliasregionlist_idx_aliasregionid_regionid ON aliasregionlist (RegionID);


DROP TABLE IF EXISTS attributelist;
CREATE TABLE attributelist
(
	AttributeID integer NOT NULL,
 	LanguageCode varchar (5) DEFAULT NULL,
 	AttributeDesc varchar (255) DEFAULT NULL,
 	Type varchar (15) DEFAULT NULL,
 	SubType varchar (15) DEFAULT NULL,
 	PRIMARY KEY (AttributeID)
);


DROP TABLE IF EXISTS chainlist;
CREATE TABLE chainlist 
(
	ChainCodeID int (11) NOT NULL,
	ChainName varchar (30) DEFAULT NULL,
 	PRIMARY KEY (ChainCodeID)
);


DROP TABLE IF EXISTS countrylist;
CREATE TABLE countrylist 
(
	CountryID integer NOT NULL,
 	LanguageCode varchar (5) DEFAULT NULL,
 	CountryName varchar (250) DEFAULT NULL,
 	CountryCode varchar (2) NOT NULL,
 	Transliteration varchar (256) DEFAULT NULL,
 	ContinentID integer DEFAULT NULL,
 	PRIMARY KEY (CountryID)
 );
CREATE INDEX countrylist_idx_countrylist_countrycode ON countrylist (CountryCode);
CREATE INDEX countrylist_idx_countrylist_countryname ON countrylist (CountryName);


DROP TABLE IF EXISTS hotelimagelist;
CREATE TABLE hotelimagelist
(
	EANHotelID integer NOT NULL,
 	Caption varchar (70) DEFAULT NULL,
 	URL varchar (150) NOT NULL,
 	Width integer DEFAULT NULL,
 	Height integer DEFAULT NULL,
 	ByteSize integer DEFAULT NULL,
 	ThumbnailURL varchar (300) DEFAULT NULL,
 	DefaultImage tinyint (1) DEFAULT NULL,
 	PRIMARY KEY (URL)
);
CREATE INDEX hotelimagelist_idx_hotelimagelist_eanhotelid ON hotelimagelist (EANHotelID);


DROP TABLE IF EXISTS parentregionlist;
CREATE TABLE parentregionlist
(
	RegionID integer NOT NULL,
	RegionType varchar (50) DEFAULT NULL,
	RelativeSignificance varchar (3) DEFAULT NULL,
	SubClass varchar (50) DEFAULT NULL,
	RegionName varchar (255) DEFAULT NULL,
	RegionNameLong varchar (510) DEFAULT NULL,
	ParentRegionID int (11) DEFAULT NULL,
	ParentRegionType varchar (50) DEFAULT NULL,
	ParentRegionName varchar (255) DEFAULT NULL,
	ParentRegionNameLong varchar (510) DEFAULT NULL,
	PRIMARY KEY (RegionID)
);
CREATE INDEX parentregionlist_idx_regionnamelong ON parentregionlist (RegionNameLong);
CREATE INDEX parentregionlist_idx_parentid ON parentregionlist (ParentRegionID);


DROP TABLE IF EXISTS pointsofinterestcoordinateslist;
CREATE TABLE pointsofinterestcoordinateslist
(
	RegionID int (11) NOT NULL,
	RegionName varchar (255) DEFAULT NULL,
	RegionNameLong varchar (191) NOT NULL DEFAULT '',
	Latitude decimal (9,6) DEFAULT NULL,
	Longitude decimal (9,6) DEFAULT NULL,
 	SubClassification varchar (20) DEFAULT NULL,
 	PRIMARY KEY (RegionNameLong)
 );
CREATE INDEX pointsofinterestcoordinateslist_idx_pointsofinterestcoordinateslist_regionid ON pointsofinterestcoordinateslist (RegionID);
CREATE INDEX pointsofinterestcoordinateslist_idx_poi__geoloc ON pointsofinterestcoordinateslist (Latitude, Longitude);

 
DROP TABLE IF EXISTS propertyattributelink;
CREATE TABLE propertyattributelink
(
	EANHotelID int (11) NOT NULL,
	AttributeID int (11) NOT NULL,
	LanguageCode varchar (5) DEFAULT NULL,
	AppendTxt varchar (191) DEFAULT NULL,
	PRIMARY KEY(EANHotelID,AttributeID)
);
CREATE INDEX propertyattributelink_idx_propertyattributelink_reverse ON propertyattributelink (AttributeID, EANHotelID);


DROP TABLE IF EXISTS propertytypelist;
CREATE TABLE propertytypelist
(
	PropertyCategory int (11) NOT NULL,
 	LanguageCode varchar (5) DEFAULT NULL,
 	PropertyCategoryDesc varchar (256) DEFAULT NULL,
 	PRIMARY KEY (PropertyCategory)
);


DROP TABLE IF EXISTS regioncentercoordinateslist;
CREATE TABLE regioncentercoordinateslist
(
	RegionID int (11) NOT NULL,
 	RegionName varchar (255) DEFAULT NULL,
 	CenterLatitude decimal (9,6) DEFAULT NULL,
 	CenterLongitude decimal (9,6) DEFAULT NULL,
 	PRIMARY KEY (RegionID)
);

DROP TABLE IF EXISTS regioneanhotelidmapping;
CREATE TABLE regioneanhotelidmapping
(
	RegionID int (11) NOT NULL,
 	EANHotelID int (11) NOT NULL,
 	PRIMARY KEY (RegionID,
 	EANHotelID)
);
CREATE INDEX regioneanhotelidmapping_idx_hotelidmapping_reverse ON regioneanhotelidmapping (EANHotelID, RegionID);


DROP TABLE IF EXISTS areaattractionslist;
CREATE TABLE areaattractionslist
(	EANHotelID integer,
	LanguageCode text,
	AreaAttractions text
);


DROP TABLE IF EXISTS citycoordinateslist;
CREATE TABLE citycoordinateslist
(
	RegionID integer,
	RegionName text,
	Coordinates text
);


DROP TABLE IF EXISTS diningdescriptionlist;
CREATE TABLE diningdescriptionlist
(
	EANHotelID integer,
	LanguageCode text,
	PropertyDiningDescription text
);


DROP TABLE IF EXISTS neighborhoodcoordinateslist;
CREATE TABLE neighborhoodcoordinateslist
(
	RegionID integer,
	RegionName text,
	Coordinates text
);


DROP TABLE IF EXISTS policydescriptionlist;
CREATE TABLE policydescriptionlist
(
	EANHotelID integer,
	LanguageCode text,
	PolicyDescription text
);

DROP TABLE IF EXISTS propertydescriptionlist;
CREATE TABLE propertydescriptionlist
(
	EANHotelID integer,
	LanguageCode text,
	PropertyDescription text
);

DROP TABLE IF EXISTS recreationdescriptionlist;
CREATE TABLE recreationdescriptionlist
(
	EANHotelID integer,
	LanguageCode text,
	RecreationDescription text
);

DROP TABLE IF EXISTS roomtypelist;
CREATE TABLE roomtypelist
(
	EANHotelID integer,
	RoomTypeID integer,
	LanguageCode text,
	RoomTypeImage text,
	RoomTypeName text,
	RoomTypeDescription text
);


DROP TABLE IF EXISTS spadescriptionlist;
CREATE TABLE spadescriptionlist
(
	EANHotelID integer,
	LanguageCode text,
	SpaDescription text
);


DROP TABLE IF EXISTS whattoexpectlist;
CREATE TABLE whattoexpectlist
(
	EANHotelID integer,
	LanguageCode text,
	WhatToExpect text
);


DROP TABLE IF EXISTS propertylocationlist;
CREATE TABLE propertylocationlist
(
	EANHotelID integer,
	LanguageCode text,
	PropertyLocationDescription text
);


DROP TABLE IF EXISTS propertyamenitieslist;
CREATE TABLE propertyamenitieslist
(
	EANHotelID integer,
	LanguageCode text,
	PropertyAmenitiesDescription text
);


DROP TABLE IF EXISTS propertyroomslist;
CREATE TABLE propertyroomslist
(
	EANHotelID integer,
	LanguageCode text,
	PropertyRoomsDescription text
);


DROP TABLE IF EXISTS propertybusinessamenitieslist;
CREATE TABLE propertybusinessamenitieslist
(
	EANHotelID integer,
	LanguageCode text,
	PropertyBusinessAmenitiesDescription text
);


DROP TABLE IF EXISTS propertynationalratingslist;
CREATE TABLE propertynationalratingslist
(
	EANHotelID integer,
	LanguageCode text,
	PropertyNationalRatingsDescription text
);


DROP TABLE IF EXISTS propertyfeeslist;
CREATE TABLE propertyfeeslist
(
	EANHotelID integer,
	LanguageCode text,
	PropertyFeesDescription text
);


DROP TABLE IF EXISTS propertymandatoryfeeslist;
CREATE TABLE propertymandatoryfeeslist
(
	EANHotelID integer,
	LanguageCode text,
	PropertyMandatoryFeesDescription text
);


DROP TABLE IF EXISTS propertyrenovationslist;
CREATE TABLE propertyrenovationslist
(
	EANHotelID integer,
	LanguageCode text,
	PropertyRenovationsDescription text
);



/* SOME OF THE OTHER LANGUAGES TABLES */
DROP TABLE IF EXISTS activepropertybusinessmodel_es_es;
CREATE TABLE activepropertybusinessmodel_es_es
(
	EANHotelID integer NOT NULL,
	LanguageCode varchar (5) DEFAULT NULL,
	Name varchar (70) DEFAULT NULL,
	Location varchar (80) DEFAULT NULL,
	CheckInTime varchar (10) DEFAULT NULL,
	CheckOutTime varchar (10) DEFAULT NULL,
	BusinessModelMask INTEGER DEFAULT NULL,
	PRIMARY KEY (EANHotelID)
);


DROP TABLE IF EXISTS activepropertybusinessmodel_pt_br;
CREATE TABLE activepropertybusinessmodel_pt_br
(
	EANHotelID integer NOT NULL,
 	LanguageCode varchar (5) DEFAULT NULL,
 	Name varchar (70) DEFAULT NULL,
 	Location varchar (80) DEFAULT NULL,
 	CheckInTime varchar (10) DEFAULT NULL,
 	CheckOutTime varchar (10) DEFAULT NULL,
 	BusinessModelMask INTEGER DEFAULT NULL,
 	PRIMARY KEY (EANHotelID)
 );


DROP TABLE IF EXISTS activepropertylist_es_es;
CREATE TABLE activepropertylist_es_es
(
	EANHotelID integer NOT NULL,
	LanguageCode varchar (5) DEFAULT NULL,
	Name varchar (70) DEFAULT NULL,
	Location varchar (80) DEFAULT NULL,
	CheckInTime varchar (10) DEFAULT NULL,
	CheckOutTime varchar (10) DEFAULT NULL,
	PRIMARY KEY (EANHotelID)
);


DROP TABLE IF EXISTS activepropertylist_pt_br;
CREATE TABLE activepropertylist_pt_br
(
	EANHotelID integer NOT NULL,
 	LanguageCode varchar (5) DEFAULT NULL,
 	Name varchar (70) DEFAULT NULL,
 	Location varchar (80) DEFAULT NULL,
 	CheckInTime varchar (10) DEFAULT NULL,
 	CheckOutTime varchar (10) DEFAULT NULL,
 	PRIMARY KEY (EANHotelID)
 );

DROP TABLE IF EXISTS regionlist_es_es;
CREATE TABLE regionlist_es_es
(
	RegionID integer NOT NULL,
 	LanguageCode varchar (5) DEFAULT NULL,
 	RegionName varchar (255) DEFAULT NULL,
 	RegionNameLong varchar (510) DEFAULT NULL,
	PRIMARY KEY (RegionID)
);


DROP TABLE IF EXISTS regionlist_pt_br;
CREATE TABLE regionlist_pt_br
(
	RegionID integer NOT NULL,
 	LanguageCode varchar (5) DEFAULT NULL,
 	RegionName varchar (255) DEFAULT NULL,
 	RegionNameLong varchar (510) DEFAULT NULL,
 	PRIMARY KEY (RegionID)
 );

-- eof(SQLite_create_eanprod.sql)
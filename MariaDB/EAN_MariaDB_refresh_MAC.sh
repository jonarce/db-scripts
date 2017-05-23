#!/bin/bash
#########################################################################
## other than the default of the MariaDB Command Lines installation    ## 
## you will need to install:                                           ##   
## -> cURL                                                             ##
## -> unzip                                                            ##
## -> database client for MariaDB (MySQL client works)                                           ##
## you can select by searching for them in the Cygwin packages during  ##
## the install.                                                        ##
#########################################################################
# Modified for MAC
### Environment ###
STARTTIME=$(date +%s)
## for Linux: CHKSUM_CMD=md5sum
## cksum should be available in all Unix versions
## leave empty for faster processing
##CHKSUM_CMD=shasum
CHKSUM_CMD=
## for Linux: MYSQL_DIR=/usr/bin/
MYSQL_DIR=/usr/local/bin/
# for simplicity I added the MYSQL bin path to the Windows 
# path environment variable, for Windows set it to ""
#MYSQL_DIR=""
##MySQL user, password, host (Server)
#using a number will force it to use TCP/IP if no a pipe connection
MYSQL_HOST=localhost
MYSQL_USER=root
MYSQL_PASS=Passw@rd1
# after MySQL 5.6+ we depend on the mysql_config_editor to
# save the connections credentials (host, user, password)
# then we can use: --login-path={name of your connection}
# we use: /Users/jarce/.mylogin.cnf
MYSQL_LOGINPATH=local
MYSQL_DB=eanprod
MYSQL_PORT=3306
MYSQL_PROTOCOL=TCP
# home directory of the user (in our case "/home/eanuser")
HOME_DIR=/Users/jarce
## directory under HOME_DIR
FILES_DIR=eanfiles
## Amount of days to keep in the log
## that track changes to ActivePropertyList
LOG_DAYS=10
### Import files ###
#####################################
# the list should match the tables ##
# created by create_ean.sql script ##
#####################################
LANG=es_ES
FILES=(
ActivePropertyList
AirportCoordinatesList
AreaAttractionsList
AttributeList
ChainList
CityCoordinatesList
CountryList
DiningDescriptionList
HotelImageList
NeighborhoodCoordinatesList
ParentRegionList
PointsOfInterestCoordinatesList
PolicyDescriptionList
PropertyAttributeLink
PropertyDescriptionList
PropertyTypeList
RecreationDescriptionList
RegionCenterCoordinatesList
RegionEANHotelIDMapping
RoomTypeList
SpaDescriptionList
WhatToExpectList
#
# minorRev=25 added files
#
PropertyLocationList
PropertyAmenitiesList
PropertyRoomsList
PropertyBusinessAmenitiesList
PropertyNationalRatingsList
PropertyFeesList
PropertyMandatoryFeesList
PropertyRenovationsList
#
### Special File for Authorized Partners ONLY
ActivePropertyBusinessModel
## <BusinessModelMask> 	<Availability Offered>
## 1 	Expedia Collect only
## 2 	Hotel Collect only
## 3 	Both (ETP)
### Some spanish files
ActivePropertyList_es_ES
ActivePropertyBusinessModel_es_ES
RegionList_es_ES
### Some portuguese files
ActivePropertyList_pt_BR
ActivePropertyBusinessModel_pt_BR
RegionList_pt_BR
)

## home where the process will execute
#cd C:/data/EAN/DEV/database
## this will be CRONed so it needs the working directory absolute path
## change to your user home directory
cd ${HOME_DIR}

echo "Starting at working directory..."
pwd
## create subdirectory if required
if [ ! -d ${FILES_DIR} ]; then
   echo "creating download files directory..."
   mkdir ${FILES_DIR}
fi

## all clear, move into the working directory
cd ${FILES_DIR}

### Parameters that you may need:
### If you use LOW_PRIORITY, execution of the LOAD DATA statement is delayed until no other clients are reading from the table.
CMD_MYSQL="${MYSQL_DIR}mysql -u ${MYSQL_USER} -p${MYSQL_PASS} --local-infile=1 --default-character-set=utf8 --protocol=${MYSQL_PROTOCOL} --port=${MYSQL_PORT} --database=${MYSQL_DB}"

### Download Data ###
echo "Downloading files using cURL..."
for FILE in ${FILES[@]}
do
    ## capture the current file checksum
	if [ -e ${FILE}.txt ] && [ -n "${CHKSUM_CMD}" ] ; then
		echo "File exist $FILE.txt and using chksum command $CHKSUM_CMD... saving checksum for comparison..."
    	CHKSUM_PREV=`$CHKSUM_CMD $FILE.txt | cut -f1 -d' '`
    else
    	CHKSUM_PREV=0
	fi
    ## download the files via HTTP (no need for https), using time-stamping, -nd no host directories
    curl -O http://www.ian.com/affiliatecenter/include/V2/$FILE.zip
	## unzip the files, save the exit value to check for errors
	## BSD does not support same syntax, but there is no need in MAC OS as Linux (unzip -L `find -iname $FILE.zip`)
    echo "Working on $FILE.txt ..."
    unzip -L -o $FILE.zip
	ZIPOUT=$?
    ## rename files to CamelCase format
    mv `echo $FILE | tr \[A-Z\] \[a-z\]`.txt $FILE.txt
    ## special fix for DiningDescriptionLIst naming error
    if [ $FILE = "DiningDescriptionList" ] && [ -f "DiningDescriptionLIst.txt" ]; then
       mv -f DiningDescriptionLIst.txt diningdescriptionlist.txt
    fi
   	## some integrity tests to avoid processing 'bad' files
   	if [ -n "${CHKSUM_CMD}" ] ; then
   	   CHKSUM_NOW=`$CHKSUM_CMD $FILE.txt | cut -f1 -d' '`
   	else
   	   CHKSUM_NOW=1
   	fi
   	echo "calculating records ...."
    records=`wc -l < $FILE.txt | tr -d ' '`
    (( records-- ))
    echo "records found ($records)."
    ## check if we need to update or not based on file changed, file contains at least 1x record
    ## file is readeable, file NOT empty, file unzipped w/o errors
    if [ "$ZIPOUT" -eq 0 ] && [ "$CHKSUM_PREV" != "$CHKSUM_NOW" ] && [ "$records" -gt 0 ] && [ -s ${FILE}.txt ] && [ -r ${FILE}.txt ]; then
    	echo "Updating as integrity is ok & checksum change ($CHKSUM_PREV) to ($CHKSUM_NOW) on file ($FILE.txt)..."
		## table name are lowercase
   		tablename=`echo $FILE | tr "[[:upper:]]" "[[:lower:]]"`
        ## checking if working with activepropertylist to make a backup of it before changes
        if [ $tablename = "activepropertybusinessmodel" ]; then
			echo "Running a backup of ActivePropertyBusinessModel..."
			### Run stored procedures as required for extra functionality       ###
			### you can use this section for your own stuff                     ###
			CMDSP_MYSQL="${MYSQL_DIR}mysql -u ${MYSQL_USER} -p${MYSQL_PASS} --default-character-set=utf8 --protocol=${MYSQL_PROTOCOL} --port=${MYSQL_PORT} --database=eanprod"
			$CMDSP_MYSQL --execute="CALL eanprod.sp_log_createcopy();"
			echo "ActivePropertyBusinessModel backup done."
        fi
		### Update MySQL Data ###
   		echo "Uploading ($FILE.txt) to ($MYSQL_DB.$tablename) with REPLACE option..."
		## let's try with the REPLACE OPTION
   		time $CMD_MYSQL --execute="set foreign_key_checks=0; set sql_log_bin=0; set unique_checks=0; SET sql_mode = ''; LOAD DATA LOCAL INFILE '$FILE.txt' REPLACE INTO TABLE $tablename CHARACTER SET utf8 FIELDS TERMINATED BY '|' IGNORE 1 LINES;"
   		## we need to erase the records, NOT updated today
   		echo "erasing old records from ($tablename)..."
   		time $CMD_MYSQL --execute="DELETE FROM $tablename WHERE datediff(TimeStamp, now()) < 0;"
        ## checking if working with activepropertylist to fill the changed log table
        if [ $tablename = "activepropertybusinessmodel" ]; then
			echo "Creating log of changes for ActivePropertyBusinessModel..."
			### Run stored procedures as required for extra functionality       ###
			### you can use this section for your own stuff                     ###
			CMDSP_MYSQL="${MYSQL_DIR}mysql  -u ${MYSQL_USER} -p${MYSQL_PASS} --default-character-set=utf8 --protocol=${MYSQL_PROTOCOL} --port=${MYSQL_PORT} --database=eanprod"
			$CMDSP_MYSQL --execute="CALL eanprod.sp_log_addedrecords();"
			$CMDSP_MYSQL --execute="CALL eanprod.sp_log_erasedrecords();"
			$CMDSP_MYSQL --execute="CALL eanprod.sp_log_erase_common();"
			$CMDSP_MYSQL --execute="CALL eanprod.sp_log_erase_deleted();"
			$CMDSP_MYSQL --execute="CALL eanprod.sp_log_changedrecords();"
			### erase records before retention period
			$CMDSP_MYSQL --execute="DELETE FROM log_activeproperty_changes WHERE TimeStamp < DATE_SUB(NOW(), INTERVAL $LOG_DAYS DAY);"
			echo "Log for ActivePropertyBusinessModel done."
        fi
    fi
done
echo "Updates done."

## echo "Running Stored Procedures..."
### Run stored procedures as required for extra functionality       ###
### you can use this section for your own stuff                     ###

## CMD_MYSQL="${MYSQL_DIR}mysql --login-path=${MYSQL_LOGINPATH} --default-character-set=utf8 --protocol=${MYSQL_PROTOCOL} --port=${MYSQL_PORT} --database=eanextras"
## $CMD_MYSQL --execute="CALL eanextras.sp_fill_fasttextsearch();"
## added as a fixer alternative to Identify Chain Hotels by name
## $CMD_MYSQL --execute="CALL eanextras.sp_fill_chainlistlink();"
## echo "Stored Procedures done."


######
## process special files
######

### Update MySQL Data ###
### Parameters that you may need:
### If you use LOW_PRIORITY, execution of the LOAD DATA statement is delayed until no other clients are reading from the table.
CMD_MYSQL="${MYSQL_DIR}mysql -u ${MYSQL_USER} -p${MYSQL_PASS} --local-infile=1 --default-character-set=utf8 --protocol=${MYSQL_PROTOCOL} --port=${MYSQL_PORT} --database=${MYSQL_DB}"
echo "Uploading Data to MySQL..."
echo "Verify database against files..."
### Verify entries in tables against files ###
CMD_MYSQL="${MYSQL_DIR}mysqlshow -u ${MYSQL_USER} -p${MYSQL_PASS} --count ${MYSQL_DB} --protocol=${MYSQL_PROTOCOL} --port=${MYSQL_PORT}"
$CMD_MYSQL

### find the amount of records per datafile
### should match to the amount of database records
echo "+---------------------------------+----------+------------+"
echo "|             File                |       Records         |"
echo "+---------------------------------+----------+------------+"
for FILE in ${FILES[@]}
do
## Linux: records=`head --lines=-1 $FILE.txt | wc -l`
   records=`wc -l < $FILE.txt | tr -d ' '`
   (( records-- ))
   { printf "|" && printf "%33s" $FILE && printf "|" && printf "%23d" $records && printf "|\n"; }
done
echo "+---------------------------------+----------+------------+"
echo "Verify done."


echo "script (EAN_MariaDB_refresh.sh) done."
## display endtime for the script
ENDTIME=$(date +%s)
secs=$(( $ENDTIME - $STARTTIME ))
h=$(( secs / 3600 ))
m=$(( ( secs / 60 ) % 60 ))
s=$(( secs % 60 ))
printf "total script time: %02d:%02d:%02d\n" $h $m $s

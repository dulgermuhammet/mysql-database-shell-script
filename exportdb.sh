#!/bin/bash

#
#
#
#
# MySQL database shell script to get database working directory
#
#
#
#




# Set these variables

myUSER=""	               # Your Database User Name
myPASS=""                # Your Database Password
myHOST=""	               # Your Database Host Name
dbNAME=""                # Your Database Table Name
dbDIRNAME="backups"      # Database Bacup Directory Name
dbNUMBER="1"             # Databe backups number as you wish to store.


# Get date in dd-mm-yyyy format

now="$(date +"%d-%m-%Y_%s")"

#Backup Path

dbPATH=${PWD}"/"${dbDIRNAME}


# Backup Database Output Name

dest=${dbNAME}_${now}".db"


# Bin paths

mysqlDUMB="$(which mysqldump)"
gzip="$(which gzip)"



# Ask question to process last time

echo "                                                     "
echo -n "Are you sure to process Mr/Ms.${USERNAME^} (y/n)? "

read answer

if [ "$answer" != "${answer#[Yy]}" ] ;then

   # Check if directory exits
  
   if [  -d "$dbPATH" ]; then
     echo "${dbDIRNAME^^} directory has already been created. No need to create again !"
   
   else

   # If not create directory

   mkdir $dbPATH
     echo "${dbDIRNAME^^} directory has been created !"
   
   fi

   # Get selected table from database

   $mysqlDUMB -u $myUSER --password=$myPASS $dbNAME > $dest
   
   # Create zip files and delete and move .db files to sub folder

   tar -cf $dest.tar $dest
   $gzip -9 $dest.tar
   rm -rf $dest
   mv "$dest.tar.gz" $dbPATH 
   cd $dbPATH
   
   # Count backups and store newest backups according given number above and delete oldest ones.

   countFILE="$(ls -A | wc -l)"
   
   if [ "$countFILE" -gt "$dbNUMBER" ]; then
      
   ls -t | sed -e "1,${dbNUMBER}d" | xargs -d '\n' gio trash
         
   fi
   
   countFILE="$(ls -A | wc -l)"

  echo "                                                                                                "
  echo "================================================================================================"
  echo "Backup is completed! Backup name is $dest.tar.gz. Thank You !"                     
  echo "================================================================================================"
  
  echo "Total backups numbers is $countFILE"
  echo "============================"
  
else

  echo "                                                  "
  echo "=================================================="
  echo "Operation aborted.Be sure to back up. Thank you !"
  echo "=================================================="
  echo "                                                  "

fi





#!/bin/bash


SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
# set me
if [ $# -ne 1 ]
then
    echo "Usage : deploy_ToOrg.sh  DevelopperHubAlias"
    exit 1
fi

DEVHUBALIAS=$1
echo "Creating Meta Data api Package"
rm -rf mdapi_output_dir
mkdir mdapi_output_dir
sfdx force:source:convert -d mdapi_output_dir/ --packagename GuestAmbassadorApp
read -p "------------- Finished, type enter to continue " 

echo "Sending Metadata Api Package to the $DEVHUBALIAS Organisation"
sfdx force:mdapi:deploy -d mdapi_output_dir  -u $DEVHUBALIAS -w 3
read -p "------------- If not finished, wait before hitting enter by checking status in Deployment Status on SF" 

echo "Updating user permissions" 
for i in `ls force-app/main/default/permissionsets/`
do
    echo 'Treating Permission file : '$i
    permissionName=`echo $i | cut -d'.' -f1`
    echo permissionName=$permissionName
    sfdx force:user:permset:assign -n $permissionName -u $DEVHUBALIAS
done

read -p "------------- Finished, type enter to continue " 
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
# set me
if [ $# -ne 1 ]
then
    echo "Usage : deploy_sfdx.sh  OrgAlias"
    exit 1
fi

SCRATCHORGALIAS=$1

sfdx force:data:tree:export --query "select Id,Description__c, image__c , name, externalid__c from participant__c"  --prefix sfdx-demo-data --outputdir ./data --plan -u $SCRATCHORGALIAS
sfdx force:data:tree:export --query "SELECT IsActive,Description, ProductCode, Family, image__c, Name, productPage__c  FROM Product2" --prefix sfdx-demo-data --outputdir ./data --plan -u $SCRATCHORGALIAS
sfdx force:data:tree:export --query "select Name, active__c, externalid__c from GameActivity__c"  --prefix sfdx-demo-data --outputdir ./data --plan  -u $SCRATCHORGALIAS

sfdx force:data:tree:export --query "select Name, Mineral_Deposit__c, externalid__c from Mine__c" --prefix sfdx-demo-data --outputdir ./data --plan  -u $SCRATCHORGALIAS
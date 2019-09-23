global class LeadProcessor  implements Database.Batchable<sObject>, Database.Stateful {
    
    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT ID, Firstname, Lastname, LeadSource from LEAD'
        );
    }
    global void execute(Database.BatchableContext bc, List<Lead> scope){
        // process each batch of records

        List<Lead> leads = new List<Lead>();
        for (Lead ld : scope)
        {
            if (ld.LeadSource == 'Dreamforce')
            {
                ld.FirstName = 'Dreamforce ' + ld.FirstName;
                recordsProcessed = recordsProcessed + 1;
                leads.add(ld);
            }
        }
        update leads;
    }    

    global void finish(Database.BatchableContext bc){
        System.debug(recordsProcessed + ' records processed. Shazam!');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];

    }    
}
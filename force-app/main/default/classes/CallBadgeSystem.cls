public class CallBadgeSystem {

    @InvocableMethod(label='Invokes a call to the remote badge system' description='Creates a badge in the remote using a REST call')
    public static void invokeapexcallout(List<Guest__c> guests) 
    {
        for  (Guest__c guest : guests)
        {
            //Soql request
            Guest__c resultApex = [select id, name, firstname__c, lastname__c, company__c, host__r.firstname, host__r.lastname from guest__c where Id = :guest.id];
            FutureCallBadgeSystem.apexcallout(resultApex.id,
                                              resultApex.firstname__c,
                                              resultApex.lastname__c,
                                              resultApex.company__c, 
                                              resultApex.host__r.firstname, 
                                              resultApex.host__r.lastname);
        } 
        
    }
}
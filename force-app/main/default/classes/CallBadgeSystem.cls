public class CallBadgeSystem {

    @InvocableMethod(label='Invokes a call to the remote badge system' description='Creates a badge in the remote using a REST call')
    public static void invokeapexcallout(List<Guest__c> guests) 
    {
        //Soql request
        //List<Guest__c> guests = [select id, name, firstname__c, lastname__c, company__c, host__r.firstname, host__r.lastname from guest__c where Id = :guestId]
        for  (Guest__c guest : guests)
        {
            FutureCallBadgeSystem.apexcallout(guest.id,
                                              guest.firstname__c,
                                              guest.lastname__c,
                                              guest.company__c, 
                                              guest.host__r.FirstName, 
                                              guest.host__r.LastName);
        } 
        
    }
}
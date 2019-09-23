public class AccountProcessor {

    @future
    public static void countContacts (List<Id> accountIds)
    {
        System.debug('#### Accounts ID -> ' + accountIds);
        List<Account> accounts = [ select Id, Name from Account where Id in :accountIds ];
        for (Account acc : accounts)
        {
            System.debug('Account -> ' + acc.Name );
			// Gets the number of contacts associated:
			Id accId = acc.Id;
			integer nbContacts= database.countQuery('select count() from contact where accountId = :accId');
            System.debug('NbContacts -> ' + nbContacts );
            //acc.Number_of_Contacts__c = nbContacts;
           	update acc;
        }
    }
}

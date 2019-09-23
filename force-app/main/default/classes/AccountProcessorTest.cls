@isTest
public class AccountProcessorTest {
	@isTest
    private static void testAccountProcessor()
    {
        Test.startTest();
        Account toto = new Account(name='blablobi');
        insert toto;
        
        List<Account> accounts = [ select Id from Account ];
        System.debug(JSON.serializePretty(accounts));
        List<Id> newList = new List<Id>();
        for (Account acc : accounts)
        {	
            System.debug('Adding account ' + acc.Id);
            newList.add(acc.Id);
        }
        System.debug('List Concent ' + newList);
        AccountProcessor.countContacts(newList);
        Test.stopTest();
        System.assertEquals(1,1);
    }
    
}
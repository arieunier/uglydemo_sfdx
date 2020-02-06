@isTest
public class AddPrimaryContactTest {
    @testSetup 
    static void setup() {
        List<Account> accounts = new List<Account>();
        
        for (Integer i = 0; i < 50; i++)
        {
            accounts.add(new Account(name='Random Account Name ' + i  + 'NY', BillingState='NY'));
            accounts.add(new Account(name='Random Account Name ' + i + ' CA', BillingState='CA'));
        }

        insert accounts;
    }
    
    static testmethod void testQueueable() {
        String state = 'CA';
        // Create our Queueable instance
        AddPrimaryContact updater = new AddPrimaryContact(new Contact(Firstname = 'Foo', Lastname='Bar'), 'CA');
        // startTest/stopTest block to force async processes to run
        Test.startTest();        
        System.enqueueJob(updater);
        Test.stopTest();        
        // Validate the job ran. Check if record have correct parentId now

        System.assertEquals(50, [select count() from account where Account.billingstate= :state]);
    }
    
}

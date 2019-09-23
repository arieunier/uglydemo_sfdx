@isTest
private class LeadProcessorTest {
    @testSetup 
    static void setup() {
        List<Lead> leads = new List<Lead>();
        
        // insert 200 leads
        for (Integer i=0;i<200;i++) {
            leads.add(new Lead(FirstName='Firstname '+i, LastName='Lastname ' + i, LeadSource='Dreamforce', Company='WTF Company'));
        }
        insert leads;
        
    }
    static testmethod void test() {        
        Test.startTest();
        LeadProcessor uca = new LeadProcessor();
        Id batchId = Database.executeBatch(uca);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        System.assertEquals(200, [select count() from lead where LeadSource = 'Dreamforce']);
    }
    
}
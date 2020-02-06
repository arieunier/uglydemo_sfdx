
@isTest
private class DailyLeadProcessorTest 
{
    // Dummy CRON expression: midnight on March 15.
    // Because this is a test, job executes
    // immediately after Test.stopTest().
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    static testmethod void testScheduledJob() {
        // creates lead
        List<Lead> leadsList = new List<Lead>();
        for (Integer i = 0; i < 200; i++)
        {
            leadsList.add(new Lead(Firstname='Firstname ' + i , Lastname = 'Lastname ' + i , LeadSource =  '', Company = 'Company ' + i));
        }
        insert leadsList;
        Test.startTest();
        String jobId = System.schedule('ScheduledApexTest',
            CRON_EXP, 
            new DailyLeadProcessor());         
        Test.stopTest();

        System.assertEquals(200, [select count() from lead where LeadSource = 'Dreamforce']);
    }
}
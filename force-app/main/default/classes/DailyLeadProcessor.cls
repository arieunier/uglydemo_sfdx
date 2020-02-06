global class DailyLeadProcessor implements Schedulable{


    global void execute(SchedulableContext ctx)
    {
        List<Lead> leadsList = [select id, firstname, lastname from lead where leadsource = '' ];
        
        for (Lead ld : leadsList)
        {
            ld.LeadSource = 'Dreamforce';
        }
        update leadsList;

    }
}

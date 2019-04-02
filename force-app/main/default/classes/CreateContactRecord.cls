public class CreateContactRecord {

    @InvocableMethod(label='Creates a contact record from a Guest object' description='Creates a contact record from a Guest object')
    public static void createContactRecord(List<Guest__c> guests) 
    {

        for  (Guest__c guest : guests)
        {
            //Soql request
            Guest__c resultApex = [select id, 
                                   name, 
                                   firstname__c,  
                                   Phone_Number__c, 
                                   Email__c, 
                                   lastname__c, 
                                   company__c, 
                                   host__r.firstname, 
                                   host__r.lastname 
                                   from guest__c 
                                   where Id = :guest.id LIMIT 1];
        	
            // gets the account to attach the contact record to
        	// Checks first if an account exists with the given name
	        List<Account> checkAccounts = [SELECT id , name from Account where name=:resultApex.Company__c];
            System.debug(checkAccounts.size());    
            Account acc;
            if (checkAccounts.size() > 0)                 // takes one random ... 
            {
                System.debug('Reusing existing account');
                acc = checkAccounts[0];
            }
			else   // creates the account
            {
                System.debug('Creating an account');
				acc = new Account(name=resultApex.Company__c);
            	insert acc;
            }
        	//                                     
            // now creates the contact
            // checks if there is not a contact with the given email already
            List<Contact> checkContacts = [SELECT id, Name, Email from Contact where Email=:resultApex.Email__c];
			Contact contact ;
            
            System.debug(checkContacts.size());    
            if (checkContacts.size() > 0)                 // takes one random ... or at least the first one because of email unicity
            {

                System.debug('Reusing existing contact');
                contact = checkContacts[0];
                // updates the contact data
                acc.Name = resultApex.firstname__c+' '+resultApex.lastname__c;
                // updates the contact data to match its name and email
                contact.FirstName = resultApex.firstname__c;
				contact.Lastname = resultApex.lastname__c;
                contact.Email = resultApex.Email__c;
                contact.MobilePhone = resultApex.Phone_Number__c;
                contact.AccountId = acc.id;
                update contact;
            }
			else // creates the contact
            {
                System.debug('Creating a contact');
                contact =  new Contact(
                    FirstName=resultApex.firstname__c,
                    LastName=resultApex.Lastname__c,
                    MobilePhone=resultApex.Phone_Number__c,
                    Email=resultApex.Email__c,
                    AccountId=acc.id);            
            	insert contact;
            }
            // updates the guest object with the correct contact
            resultApex.contact__c= contact.id;
            resultApex.Account__c= acc.id;
            
            // gets the record type 
			// RecordType recordType =[select Id,Name from RecordType where Name='Complete_Data' LIMIT 1];
            resultApex.RecordTypeId=Schema.SObjectType.Guest__c.getRecordTypeInfosByName()
                  .get('Complete Data').getRecordTypeId(); 
                 
            update resultApex;
            
           	
        } 
        
    }
}
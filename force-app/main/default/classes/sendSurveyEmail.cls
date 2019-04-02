public class sendSurveyEmail {
    @InvocableMethod(label='Sends a survey to a guest' description='Sends a survey to a guest')
    public static void sendGuestSurvey(List<SurveyInvitation> invitations) 
    {

        for  (SurveyInvitation invitation : invitations)
        {
            //Soql request
            SurveyInvitation invitationContent = [Select SurveyId, EmailBrandingId, CreatedById, 
                                   InviteExpiryDateTime, InvitationLink, 
                                   Name, ParticipantId, ResponseStatus from SurveyInvitation
                                   where Id = :invitation.id LIMIT 1];
        	
            // gets the contact to send the email
			Contact emailContact = [SELECT id, Name, Email from Contact where id=:invitationContent.ParticipantId LIMIT 1 ];
            

            // First, reserve email capacity for the current Apex transaction to ensure
            // that we won't exceed our daily email limits when sending email after
            // the current transaction is committed.
            Messaging.reserveSingleEmailCapacity(2);
            
            // Processes and actions involved in the Apex transaction occur next,
            // which conclude with sending a single email.
            
            // Now create a new single email message object
            // that will send out a single email to the addresses in the To, CC & BCC list.
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            // Strings to hold the email addresses to which you are sending the email.
            String[] toAddresses = new String[] {emailContact.Email}; 
            String[] ccAddresses = new String[] {'arieunier@salesforce.com'};
              
            
            // Assign the addresses for the To and CC lists to the mail object.
            mail.setToAddresses(toAddresses);
            mail.setCcAddresses(ccAddresses);
            
            // Specify the address used when the recipients reply to the email. 
            mail.setReplyTo('arieunier@salesforce.com');
            
            // Specify the name used as the display name.
            mail.setSenderDisplayName('Salesforce Tower Survey');
            
            // Specify the subject line for your email address.
            mail.setSubject('A survey is available for you');
            
            // Specify the text content of the email.
            mail.setPlainTextBody('Thanks for visiting us today. Can you please take two minutes of your time and answer a survey ? Here is the address:  ' 
                                  + invitationContent.InvitationLink +' . ');
            
            mail.setHtmlBody('Thanks for visiting us today. Can you please take two minutes of your time and answer a survey ? Here is the address:  '
                             + invitationContent.InvitationLink  +' .'+
                 'Or <a href='+invitationContent.InvitationLink +'>click here.</a>');
            
            // Send the email you have created.
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
        } 
        
    }
}
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
        	System.debug('######### INVITATION NAME -> ' + invitationContent.Name);
                
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
            String mailSubject = 'SF Tower Communication';
			String mailPlainTextBody = 'Hello, Thanks for contacting us today. Can you please take a minute of your time and answer a survey ? Here is the address:  ' 
                                  + invitationContent.InvitationLink +' . ';
            String mailHTMLBody = mailPlainTextBody +
                 'Or <a href='+invitationContent.InvitationLink +'>click here.</a>';
            
            if (invitationContent.Name == 'SF Tower Guest Feedback')
            {
                mailSubject = 'SF Tower Welcome Guest Survey';
				mailPlainTextBody = 'Thanks for visiting us today. Can you please take two minutes of your time and answer a survey ? Here is the address:  ' 
                                  + invitationContent.InvitationLink +' . ' ;     
                mailHTMLBody = mailPlainTextBody +
                 'Or <a href='+invitationContent.InvitationLink +'>click here.</a>';
            }
            else if (invitationContent.Name == 'SF Close Case Feedback')
            {
                mailSubject = 'SF Tower Customer Support Survey';
				mailPlainTextBody = 'Thanks for contacting our support today. Can you please take two minutes of your time and answer a survey to help us improving our processes ? Here is the address:  ' 
                                  + invitationContent.InvitationLink +' . ' ;
                mailHTMLBody = mailPlainTextBody +
                 'Or <a href='+invitationContent.InvitationLink +'>click here.</a>';
            }
            mail.setSubject(mailSubject);
            mail.setPlainTextBody(mailPlainTextBody);
            mail.setHtmlBody(mailHTMLBody);

            
            // Send the email you have created.
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
        } 
        
    }
}
public class AddPrimaryContact implements Queueable
{
    private Contact contact;
    private String state;

    public AddPrimaryContact(Contact ctc, String st) 
    {
        this.contact = ctc;
        this.state = st;
    }

    public void execute(QueueableContext context)
    {
        List<Account> accountList = [ select Id, Name  from Account where BillingState= :state LIMIT 200];

        List<Contact> contactList = new List<Contact>();
        for (Account acc : accountList)
        {
            Contact newContact = contact.clone(False, True, False, False);
            newContact.AccountId = acc.Id;
            contactList.add(newContact);
        }
        insert contactList;


    }
}

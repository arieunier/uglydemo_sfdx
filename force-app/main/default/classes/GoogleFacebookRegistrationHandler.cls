global class GoogleFacebookRegistrationHandler implements Auth.RegistrationHandler
{
    private static final String ORG_SUFFIX = '.arieunier-cdo.com';
    private static final String DEFAULT_ACCOUNTNAME = 'Customers';
    private static final String EXTERNAL_USER_PROFILE = 'Customer Community User';
    private static final String INTERNAL_USER_PROFILE = 'Standard User'; 
    
    global boolean canCreateUser(Auth.UserData data) {
        System.debug('canCreateUser was called for ' + (data != null ? data.email : 'null'));
        Boolean retVal = (data != null 
                && data.email != null
                && data.lastName != null
                && data.firstName != null);
        
        System.debug('data.username='+data.username);
        System.debug('data.identifier='+data.identifier);
        System.debug('data.email='+data.email);
        System.debug('data.lastName='+data.lastName);
        System.debug('data.firstName='+data.firstName);
        
        return retVal;
    }

    global User createUser(Id portalId, Auth.UserData data)
    {
        System.debug('#### Debug incoming data');
        System.debug(data);
        
        if(!canCreateUser(data)) {
            //Returning null or throwing an exception fails the SSO flow
            return null;
        }
        
        // Is this a Community Context?
        if(data.attributeMap.containsKey('sfdc_networkid')) 
        {
            System.debug('#### COMMUNITY USER CONTEXT ');
            System.debug('Registering Community user: ' + data.email);
            Id contactId;
            // To keep things modular, we're creating the Contact in a separate method
            contactId = createContact(data);
            System.debug('Created contact: '+ contactId);
          
            // You'd likely use other logic to assign the Profile
            Profile p = [SELECT Id FROM profile WHERE name=:EXTERNAL_USER_PROFILE];
            System.debug('Found profile: '+ p);
    
            // Keeping it modular, we initialize the user in another method
            User u = createUser(data,p);
            
            u.contactId = contactId;
            return u;
        }
        else 
        {
            System.debug('#### INTERNAL USER CONTEXT ');
             //The user is authorized, so create their Salesforce user
            User u = new User();
            Profile p = [SELECT Id FROM profile WHERE name=:INTERNAL_USER_PROFILE];
            u = fillUserData(data, u);
            u.profileId = p.Id;
            return u;
        }
    }

    global void updateUser(Id userId, Id portalId, Auth.UserData data){
        User u = new User(id=userId);
		u = fillUserData(data, u);
        update(u);
    }
    
    /**
     * Create a Contact
     * 
     * @param data - Facebook provided context for the User
     **/
    private Id createContact(Auth.UserData data){
        Contact contact = new Contact();
        contact.LastName = data.lastName;
        contact.FirstName = data.firstName;
        contact.Email = data.email;
        
        // set Account Id
        if (data.attributemap.get('accountId') != null){
            contact.accountId = data.attributemap.get('accountId');
        } else {
            List<Account> accounts = [select Id from Account where Name =:DEFAULT_ACCOUNTNAME];
            System.debug('Found account: ' + accounts);
            
            contact.accountId = accounts[0].Id;            
        }
        insert contact;

        System.debug('Contact created for ' + data.email + ' id=' + contact.id);

        return contact.id; 
    }

	private User fillUserData(Auth.UserData data, User u)
    {
        String provider = '.Provider';
		if (data.provider != '')
        {
            provider = '.' + data.provider;
        }            

        if (data.username != null)
        {
            u.username = data.username + provider + ORG_SUFFIX;
        }
        else if (data.email != null)
        {
            u.username = data.email + provider+ ORG_SUFFIX;
        }
        else
        {
            u.username = data.identifier + provider + '@' + ORG_SUFFIX;
        }
        
        u.email = data.email;
        u.lastName = data.lastName;
        u.firstName = data.firstName;
        String alias = u.username;
        //Alias must be 8 characters or less
        if(alias.length() > 8) {
            alias = alias.substring(0, 8);
        }
        u.alias = alias;
        u.languagelocalekey = 'fr'; 
        u.localesidkey ='fr_FR_EURO';
        u.emailEncodingKey = 'UTF-8';
        u.timeZoneSidKey = 'America/Los_Angeles';
        return u;
    }

    /**
     * Create and initialize the User but don't save it yet
     * 
     * @param data - the provided User context from FaceBook
     * @param p - the Profile we are going to assign to this user
     * 
     * @return User that has been initialized but not Saved
     **/ 
    private User createUser(Auth.UserData data, Profile p) 
    {
        User u = new User();
        u = fillUserData(data, u);
        u.profileId = p.Id;
		return u;
    }       
}
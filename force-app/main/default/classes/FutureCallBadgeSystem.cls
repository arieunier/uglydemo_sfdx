public class FutureCallBadgeSystem {

    @future(Callout=true)
    public static void apexcallout(Id guest_id, String guest_firstname, String guest_lastname, String guest_company, String host_firstname, String host_lastname)
    {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String namedCredentials='callout:heroku';
        String requestURL='/badges';
        String params = '?guest_id=' + guest_Id + '&guest_firstname=' + guest_firstname + '&guest_lastname=' + guest_lastname + 
            '&guest_company='+guest_company+'&host_firstname='+host_firstname + '&host_lastname='+host_lastname;
        
        request.setEndpoint(namedCredentials + requestURL + params);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Set the body as a JSON object
        String bodyContent = '{"guest_id:"' + guest_id + '", guest_firstname:"' + guest_firstname + '"}';
        request.setBody(bodyContent);
        
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' +
                response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
    }
}
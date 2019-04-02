public class FutureCallBadgeSystem {

    @future(Callout=true)
    public static void apexcallout(Id guest_id, String guest_firstname, String guest_lastname, String guest_company, String host_firstname, String host_lastname, 
                                  String External_Picture_URL )
    {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String namedCredentials='callout:heroku';
        String requestURL='/badges?';

        String params = 'guest_id=' + EncodingUtil.urlEncode(guest_Id, 'UTF-8') 
            + '&guest_firstname=' + EncodingUtil.urlEncode(guest_firstname, 'UTF-8') 
            + '&guest_lastname=' +  EncodingUtil.urlEncode(guest_lastname, 'UTF-8')  
            + '&guest_company='+ EncodingUtil.urlEncode(guest_company, 'UTF-8')
            + '&host_firstname='+EncodingUtil.urlEncode(host_firstname, 'UTF-8') 
            + '&host_lastname='+EncodingUtil.urlEncode(host_lastname, 'UTF-8')
            + '&picture_url='+EncodingUtil.urlEncode(External_Picture_URL, 'UTF-8');
        System.debug(params);
        request.setEndpoint(namedCredentials + requestURL + params);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Set the body as a JSON object
        String bodyContent = '{"picture_url:"' + External_Picture_URL + '"}';
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
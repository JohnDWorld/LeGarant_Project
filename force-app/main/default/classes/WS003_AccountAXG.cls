/**
 * 
 * Web service class to REST request for Account
 * 
 * @author JohnDWorld
 */
@RestResource(urlMapping='/Accounts/*')
global with sharing class WS003_AccountAXG {
    //Method to create account from AXG
    @HttpPost
    global static ID createAccountFromAXG(String name) {
        List<Account> acsountsSF = [SELECT Id FROM Account WHERE Name=:name];
        if (acsountsSF.size() != 0) {
            return acsountsSF[0].Id;
        } else {
            Account thisAccount = new Account(
                Name = name
            );
            insert thisAccount;
            return thisAccount.Id;
        }
    }
    //Method to update account from AXG
    @HttpPatch
    global static Account updateAccountFromAXG() {
        RestRequest request = RestContext.request;
        String accountId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Account thisAccount = [SELECT Id FROM Account WHERE Id = :accountId];
        // Deserialize the JSON string into name-value pairs
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        // Iterate through each parameter field and value
        for(String fieldName : params.keySet()) {
            // Set the field and value on the Case sObject
            thisAccount.put(fieldName, params.get(fieldName));
        }
        update thisAccount;
        return thisAccount;
    }
}
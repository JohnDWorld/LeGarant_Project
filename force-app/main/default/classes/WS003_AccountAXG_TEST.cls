/**
 * 
 * Class test for WS001_ContactAXG ans his Methods
 * 
 * @author JohnDWorld
 */
@isTest
private class WS003_AccountAXG_TEST {
    //Test to create account who doesn't exist in SF from AXG
    @isTest static void testCreateAccountDoesntExist() {
        //Call the method to test
        Id thisAccountId = WS003_AccountAXG.createAccountFromAXG('Account Test');

        //Verify the test
        System.assert(thisAccountId != null);
        Account thisAccount = [SELECT Name FROM Account WHERE Id=:thisAccountId];
        System.assert(thisAccount != null);
        System.assertEquals('Account Test', thisAccount.Name);
    }
    //Test to try to create account who already exist in SF from AXG
    @isTest static void testCreateAccountAlreadyExist() {
        //Call the method to test
        Id thisAccountId1 = WS003_AccountAXG.createAccountFromAXG('Account Test');
        //Recall the method to test with same param
        Id thisAccountId2 = WS003_AccountAXG.createAccountFromAXG('Account Test');

        //Verify the test
        System.assert(thisAccountId1 != null);
        System.assert(thisAccountId2 != null);
        System.assert(thisAccountId1 == thisAccountId2);
        List<Account> thisAccounts = [SELECT Id FROM Account WHERE Name='Account Test'];
        System.assert(thisAccounts != null);
        System.assertEquals(1, thisAccounts.size());
    }
    //Test to update an account with info from AXG
    @isTest static void testUpdateAccount() {
        //Create a record of contact to test
        Id thisAccountId = createAccountContact();
        //Instantiate request
        RestRequest request = new RestRequest();
        request.requestURI = 'https://mindful-koala-iv2st7-dev-ed.my.salesforce.com/services/apexrest/Cases/'+thisAccountId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"Name": "Account Update"}');
        RestContext.request = request;
        //Update contact of existing contact
        Account accountUpdate = WS003_AccountAXG.updateAccountFromAXG();

        //Verify contact was update
        System.assert(accountUpdate != null);
        Account thisAccount = [SELECT Name FROM Account WHERE Id=:thisAccountId];
        System.assert(thisAccount != null);
        System.assertEquals('Account Update', thisAccount.Name);
    }
    //Helper method
    static Id createAccountContact() {
        Account account = new Account(
            Name = 'Account Test'
        );
        insert account;
        return account.Id;
    }
}

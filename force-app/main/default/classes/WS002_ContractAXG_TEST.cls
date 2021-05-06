/**
 * 
 * Class test for WS002_ContractAXG ans his Methods
 * 
 * @author JohnDWorld
 */
@isTest
private class WS002_ContractAXG_TEST {
    //Test to create contract with info from AXG
    @isTest static void testCreateContract() {
        //Create the data that we need
        String account = createAccountId();
        //Call the method to test
        Id thisContractId = WS002_ContractAXG.createContractFromAXG(account, 'Draft', 10);

        //Verify the test
        System.assert(thisContractId != null);
        Contract thisContract = [SELECT AccountId FROM Contract WHERE Id=:thisContractId];
        System.assert(thisContract != null);
        System.assertEquals(account, thisContract.AccountId);
    }
    //Test to update contract with info from AXG
    @isTest static void testUpdateContract() {
        //Create a record of contract to test and his account
        String account = createAccountId();
        Id thisContractId = createTestContract(account);
        //Instantiate request
        RestRequest request = new RestRequest();
        request.requestURI = 'https://mindful-koala-iv2st7-dev-ed.my.salesforce.com/services/apexrest/Cases/'+thisContractId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"status": "Activated"}');
        RestContext.request = request;
        //Update contact of existing contact
        WS002_ContractAXG.updateContractFromAXG();

        //Verify contact was update
        Contract thisContract = [SELECT Status FROM Contract WHERE Id=:thisContractId];
        System.assert(thisContract != null);
        System.assertEquals('Activated', thisContract.Status);
    }
    //Helper method
    static String createAccountId() {
        Account account = new Account(
            Name = 'Account Test'
        );
        insert account;
        return account.Id;
    }
    static Id createTestContract(String account) {
        Contract contract = new Contract(
            AccountId = account,
            Status = 'Draft',
            ContractTerm = 10
        );
        insert contract;
        return contract.Id;
    }
}
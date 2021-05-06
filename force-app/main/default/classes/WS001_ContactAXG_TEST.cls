/**
 * 
 * Class test for WS001_ContactAXG ans his Methods
 * 
 * @author JohnDWorld
 */
@isTest
private class WS001_ContactAXG_TEST {
    //Test to create contact who doesn't exist in SF from AXG
    @isTest static void testCreateContactDoesntExist() {
        //Call the method to test
        Id thisContactId = WS001_ContactAXG.createContactFromAXG('Test', 'Contact', 'exemple@exemple.com', '0102030405');

        //Verify the test
        System.assert(thisContactId != null);
        Contact thisContact = [SELECT Id, Email FROM Contact WHERE Id=:thisContactId];
        System.assert(thisContact != null);
        System.assertEquals('exemple@exemple.com', thisContact.Email);
    }
    //Test to try to create contact who already exist in SF from AXG
    @isTest static void testCreateContactAlreadyExist()  {
        //Call the method to test
        Id thisContactId1 = WS001_ContactAXG.createContactFromAXG('Test', 'Contact', 'exemple@exemple.com', '0102030405');
        //Recall the method to test with same param
        Id thisContactId2 = WS001_ContactAXG.createContactFromAXG('Test', 'Contact', 'exemple@exemple.com', '0102030405');

        //Verify the test
        System.assert(thisContactId1 != null);
        System.assert(thisContactId2 != null);
        System.assert(thisContactId1 == thisContactId2);
        List<Contact> thisContacts = [SELECT Id, Email FROM Contact WHERE Email='exemple@exemple.com'];
        System.assert(thisContacts != null);
        System.assertEquals(1, thisContacts.size());
    }
    //Test to update contact with info from AXG
    @isTest static void testUpdateContact() {
        //Create a record of contact to test
        Id thisContactId = createTestContact();
        //Instantiate request
        RestRequest request = new RestRequest();
        request.requestURI = 'https://mindful-koala-iv2st7-dev-ed.my.salesforce.com/services/apexrest/Cases/'+thisContactId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"lastName": "Update"}');
        RestContext.request = request;
        //Update contact of existing contact
        Contact contactUpdate = WS001_ContactAXG.updateContactFromAXG();

        //Verify contact was update
        System.assert(contactUpdate != null);
        Contact thisContact = [SELECT LastName FROM Contact WHERE Id=:thisContactId];
        System.assert(thisContact != null);
        System.assertEquals('Update', thisContact.LastName);
    }
    //Test to unactive contact after delete from AXG
    @isTest static void testDisableContact() {
        //Create a record of contact to test
        Id thisContactId = createTestContact();
        //Instantiate request
        RestRequest request = new RestRequest();
        request.requestURI = 'https://mindful-koala-iv2st7-dev-ed.my.salesforce.com/services/apexrest/Cases/'+thisContactId;
        request.httpMethod = 'GET';
        RestContext.request = request;
        //Disable contact
        WS001_ContactAXG.disableContactSF();

        //Verify the contact is disable and NOT delete
        Contact thisContact = [SELECT Active__c FROM Contact WHERE Id=:thisContactId];
        System.assert(thisContact != null);
        System.assertEquals(false, thisContact.Active__c);
    }
    //Helper method
    static Id createTestContact() {
        Contact contact = new Contact(
            LastName = 'Test',
            FirstName = 'Contact',
            Email = 'exemple@exemple.com',
            Phone = '0102030405'
        );
        insert contact;
        return contact.Id;
    }
}
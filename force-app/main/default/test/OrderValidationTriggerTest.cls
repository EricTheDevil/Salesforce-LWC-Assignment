@isTest
private class OrderValidationTriggerTest {
    static testMethod void testValidOrder() {
        Order_Item__c validOrder = new Order_Item__c(
            Name = 'Product1',
            Quantity__c = 5,
            Price__c = 10.0
        );
        // Insert the record
        Test.startTest();
        insert validOrder;
        Test.stopTest();
        System.assertEquals(1, [SELECT COUNT() FROM Order_Item__c WHERE Id = :validOrder.Id]);
    }
    
    static testMethod void testInvalidName() {
        Order_Item__c invalidOrder = new Order_Item__c(
            Name = 'Product#1',
            Quantity__c = 5,
            Price__c = 10.0
        );
        Test.startTest();
        try {
            insert invalidOrder;
        } catch (DmlException e) {
            String expectedError = 'Name cannot contain special characters.';
            System.assertEquals(expectedError, e.getDmlMessage(0));
        }
        Test.stopTest();
    }
    
    static testMethod void testBlankQuantity() {
        Order_Item__c invalidOrder = new Order_Item__c(
            Name = 'Product2',
            Quantity__c = null,
            Price__c = 10.0
        );
        Test.startTest();
        try {
            insert invalidOrder;
        } catch (DmlException e) {
            String expectedError = 'Quantity cannot be blank.';
            System.assertEquals(expectedError, e.getDmlMessage(0));
        }
        Test.stopTest();
    }
    
    static testMethod void testBlankPrice() {
        // Create an invalid Order_Item record with a blank Price field
        Order_Item__c invalidOrder = new Order_Item__c(
            Name = 'Product3',
            Quantity__c = 5,
            Price__c = null
        );
        // Insert the record and verify that the validation error is thrown
        Test.startTest();
        try {
            insert invalidOrder;
        } catch (DmlException e) {
            String expectedError = 'Price cannot be blank.';
            System.assertEquals(expectedError, e.getDmlMessage(0));
        }
        Test.stopTest();
    }
}

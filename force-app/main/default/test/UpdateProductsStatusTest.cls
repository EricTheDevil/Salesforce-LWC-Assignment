@isTest
private class UpdateProductsStatusTest {
    static testMethod void testUpdateProductStatus() {
        Product__c testProduct = new Product__c(
            Name = 'Test Product',
            Price__c = 10.0,
            Category__c = 'Boot',
            URL__c = ''
        );
        Test.startTest();
        insert testProduct;
        Test.stopTest();
        Product__c insertedProduct = [SELECT Id, Status__c FROM Product__c WHERE Id = :testProduct.Id];
        System.assertEquals('New', insertedProduct.Status__c);
    }
}

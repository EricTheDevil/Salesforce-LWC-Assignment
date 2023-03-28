public class DeleteOrderItemsBatch implements Database.Batchable<sObject> {

    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([SELECT Id FROM Order_Item__c]);
    }

    public void execute(Database.BatchableContext context, List<sObject> scope) {
        List<Order_Item__c> orderItemsToDelete = (List<Order_Item__c>) scope;
        delete orderItemsToDelete;

        List<OrderLineItem__c> orderChoicesToDelete = [SELECT Id FROM OrderLineItem__c];
        delete orderChoicesToDelete;
    }

    public void finish(Database.BatchableContext context) {
    }
}

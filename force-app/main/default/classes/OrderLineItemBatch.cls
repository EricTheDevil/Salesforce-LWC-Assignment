public class OrderLineItemBatch implements Database.Batchable<sObject> {
    private Order_Item__c newOrderItem;

    public OrderLineItemBatch(Order_Item__c newOrderItem) {
        this.newOrderItem = newOrderItem;
    }

    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([SELECT Id FROM Order_Item__c WHERE Id = :newOrderItem.Id]);
    }

    public void execute(Database.BatchableContext context, List<sObject> scope) {
        List<Order_Item__c> orderItems = (List<Order_Item__c>) scope;
        for (Order_Item__c orderItem : orderItems) {
            orderItem.Quantity__c = newOrderItem.Quantity__c;
            orderItem.Price__c = newOrderItem.Price__c;
        }
        update orderItems;
    }

    public void finish(Database.BatchableContext context) {
    }
}

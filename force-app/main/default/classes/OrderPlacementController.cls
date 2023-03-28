/**
 * Apex controller for the order placements.
 * Handles all the login for creating orders. 
 */
public with sharing class OrderPlacementController {

    /** Retrieves a list of all available products. */
    @AuraEnabled(cacheable=true)
    public static List<Product__c> getProducts() {
        return [SELECT Id, Name, Price__c, Category__c, URL__c FROM Product__c];
    }

     /**
     * Creates a new orderChoice and for each item it creates a new order item
     * There is some calculation happening to get the total cost.
     * @param orderItems The list of order items to include in the order.
     * @param orderChoices The list of choices associated with each order item.
     * @param orderName The name of the order to create.
     * @return A list of IDs for the orders created.
     */
    @AuraEnabled(cacheable=false)
    public static List<Id> createOrder(List<Order_Item__c> orderItems, List<OrderLineItem__c> orderChoices, String orderName) {
        Decimal totalCost = 0;
        Decimal currentCost = 0;

        if (orderItems.isEmpty() || orderChoices.isEmpty()) {
            throw new AuraHandledException('Input lists cannot be empty.');
        }

        Set<Id> productIds = new Set<Id>();
        for (OrderLineItem__c orderChoice : orderChoices) {
            productIds.add(orderChoice.Product__c);
        }

        Map<Id, Product__c> productMap = new Map<Id, Product__c>([SELECT Id, Name FROM Product__c WHERE Id IN :productIds]);
        List<OrderLineItem__c> orders = new List<OrderLineItem__c>();
        Order_Item__c newOrderItem = new Order_Item__c();


        newOrderItem.Name = orderName + String.valueOf((Integer) Math.floor(Math.random() * 1000));
        newOrderItem.Price__c = totalCost;

        insert newOrderItem;

        for (Integer i = 0; i < orderItems.size(); i++) {
            Order_Item__c item = orderItems[i];
            OrderLineItem__c order = new OrderLineItem__c();

            if (item.Quantity__c > 1) {
                currentCost = item.Quantity__c * orderChoices[i].Cost__c;
            } else {
                currentCost = orderChoices[i].Cost__c;
            }
            totalCost += currentCost;

            order.Order_Item__c = newOrderItem.Id;
            order.Product__c = orderChoices[i].Product__c;
            order.Cost__c = currentCost;
            order.Quantity__c = orderChoices[i].Quantity__c;
            
            Product__c productName = productMap.get(order.Product__c);
            order.Name = productName.Name;

            orders.add(order);
        }

        insert orders;

        newOrderItem.Quantity__c = orderItems.size();
        newOrderItem.Price__c = totalCost;
        OrderLineItemBatch batch = new OrderLineItemBatch(newOrderItem);
        Database.executeBatch(batch);

        List<Id> orderIds = new List<Id>();
        for (OrderLineItem__c order : orders) {
            orderIds.add(order.Id);
        }
        return orderIds;
    }

    @AuraEnabled(cacheable=true)
    public static List<Product__c> getFilteredProducts(String category) {
        String allCategory = 'All'; 
        if (category == allCategory) {
            return [SELECT Id, Name, Price__c, Category__c, URL__c FROM Product__c];
        } else {
            return [SELECT Id, Name, Price__c, Category__c, URL__c FROM Product__c WHERE Category__c = :category];
        }
    }
}

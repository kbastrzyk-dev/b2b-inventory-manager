public with sharing class OrderTriggerHandler {
    public static void handleAfterUpdate(List<Order> newOrders, Map<Id, Order> oldOrders) {
        Set<Id> activatedOrderIds = new Set<Id>();
        
        // 1. Isolate only the Orders that JUST changed their status to 'Activated'
        for (Order ord : newOrders) {
            Order oldOrd = oldOrders.get(ord.Id);
            if (ord.Status == 'Activated' && oldOrd.Status != 'Activated') {
                activatedOrderIds.add(ord.Id);
            }
        }
        
        // 2. If we found any newly activated orders, pass them to our future processing service
        if (!activatedOrderIds.isEmpty()) {
            System.debug('🚨 Found ' + activatedOrderIds.size() + ' newly activated orders. Ready to deduct inventory!');
            InventoryService.deductInventory(activatedOrderIds); 
        }
    }
}
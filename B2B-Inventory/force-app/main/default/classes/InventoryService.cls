public with sharing class InventoryService {
    
    public static void deductInventory(Set<Id> activatedOrderIds) {
        // String map to hold our ProductId + WarehouseId
        Map<String, Decimal> productWarehouseQuantities = new Map<String, Decimal>();

        // Query the OrderItems AND our new Warehouse__c field
        List<OrderItem> soldItems = [
            SELECT Product2Id, Quantity, Warehouse__c 
            FROM OrderItem 
            WHERE OrderId IN :activatedOrderIds AND Warehouse__c != null
        ];

        // Aggregate using the Composite Key!
        for (OrderItem item : soldItems) {
            String compositeKey = String.valueOf(item.Product2Id) + '-' + String.valueOf(item.Warehouse__c);
            
            if (productWarehouseQuantities.containsKey(compositeKey)) {
                Decimal currentQty = productWarehouseQuantities.get(compositeKey);
                productWarehouseQuantities.put(compositeKey, currentQty + item.Quantity);
            } else {
                productWarehouseQuantities.put(compositeKey, item.Quantity);
            }
        }

        if (productWarehouseQuantities.isEmpty()) return;

        // Query the inventory
        List<Inventory_Item__c> inventoryToUpdate = new List<Inventory_Item__c>();
        List<Inventory_Item__c> availableInventory = [
            SELECT Id, Product__c, Warehouse__c, Quantity_in_Meters__c, Restock_Threshold__c, Warehouse__r.Name 
            FROM Inventory_Item__c 
            WHERE Product__c IN :getExtractedIds(soldItems, 'Product2Id')
            AND Warehouse__c IN :getExtractedIds(soldItems, 'Warehouse__c')
        ];

        // Match exactly using the Composite Key
        for (Inventory_Item__c inv : availableInventory) {
            String invKey = String.valueOf(inv.Product__c) + '-' + String.valueOf(inv.Warehouse__c);
            Decimal amountSold = productWarehouseQuantities.get(invKey);
            
            if (amountSold != null && inv.Quantity_in_Meters__c >= amountSold) {
                inv.Quantity_in_Meters__c -= amountSold;
                inventoryToUpdate.add(inv);
            }
        }

        // Safe DML
        if (!inventoryToUpdate.isEmpty()) {
            update inventoryToUpdate;
        }
    }

    // Helper method to keep our SOQL queries clean and bulkified
    private static Set<Id> getExtractedIds(List<SObject> records, String fieldName) {
        Set<Id> ids = new Set<Id>();
        for (SObject record : records) {
            ids.add((Id)record.get(fieldName));
        }
        return ids;
    }
}
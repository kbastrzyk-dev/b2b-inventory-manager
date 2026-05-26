@isTest
public class TestDataFactory {
    
    // Utility to create a Warehouse
    public static Warehouse__c createWarehouse(String name, String region, Decimal capacity) {
        Warehouse__c w = new Warehouse__c(
            Name = name, 
            Region__c = region, 
            Total_Capacity_in_Meters__c = capacity
        );
        insert w;
        return w;
    }

    // Utility to create a Product
    public static Product2 createProduct(String name) {
        Product2 p = new Product2(Name = name, IsActive = true);
        insert p;
        return p;
    }

    // Utility to create an Inventory Item
    public static Inventory_Item__c createInventoryItem(Id warehouseId, Id productId, Decimal qty, Decimal threshold) {
        Inventory_Item__c inv = new Inventory_Item__c(
            Warehouse__c = warehouseId,
            Product__c = productId,
            Quantity_in_Meters__c = qty,
            Restock_Threshold__c = threshold
        );
        insert inv;
        return inv;
    }

    // Utility: Sets up an Account, Pricebook, Order, and OrderItems all at once!
    public static Order createOrderWithLineItems(Id productId, Id warehouseId, Decimal quantityOrdered) {
        // We need an Account for the Order
        Account acc = new Account(Name = 'Test B2B Partner');
        insert acc;

        // Salesforce requires OrderItems to have PricebookEntries. 
        // We use the standard test pricebook ID for this.
        Id pricebookId = Test.getStandardPricebookId();

        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = productId,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert pbe;

        // Create the Draft Order
        Order ord = new Order(
            AccountId = acc.Id,
            Status = 'Draft',
            EffectiveDate = Date.today(),
            Pricebook2Id = pricebookId
        );
        insert ord;

        // Create the OrderItem (linking the product, quantity, and specific warehouse)
        OrderItem item = new OrderItem(
            OrderId = ord.Id,
            PricebookEntryId = pbe.Id,
            Product2Id = productId,
            Quantity = quantityOrdered,
            UnitPrice = 100.00,
            Warehouse__c = warehouseId // Our custom composite key field!
        );
        insert item;

        return ord;
    }
}
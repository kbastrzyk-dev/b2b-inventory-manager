@isTest
private class OrderTriggerTest {
    
    @isTest
    static void testOrderActivationDeductsInventory() {
        // 1. ARRANGE (Set up our data using the Factory)
        Product2 prod = TestDataFactory.createProduct('Test Microfiber Roll');
        Warehouse__c warehouse = TestDataFactory.createWarehouse('Munich Hub', 'DACH', 10000);
        
        // Give the warehouse an initial inventory of 500 meters
        Inventory_Item__c inv = TestDataFactory.createInventoryItem(warehouse.Id, prod.Id, 500, 100);
        
        // Create an order for 200 meters of that product from that warehouse
        Order testOrder = TestDataFactory.createOrderWithLineItems(prod.Id, warehouse.Id, 200);
        
        // 2. ACT (Execute the logic we are testing)
        Test.startTest(); // Reset governor limits!
        
        testOrder.Status = 'Activated';
        update testOrder; // This fires Trigger -> Trigger Handler -> Inventory Service
        
        Test.stopTest();
        
        // 3. ASSERT (Prove to the system that it worked)
        // Query the database to see what happened to our inventory record
        Inventory_Item__c updatedInv = [
            SELECT Quantity_in_Meters__c 
            FROM Inventory_Item__c 
            WHERE Id = :inv.Id
        ];
        
        // We started with 500, ordered 200, so we should have exactly 300 left.
        System.assertEquals(300, updatedInv.Quantity_in_Meters__c, 'The inventory was not deducted correctly!');
    }
}
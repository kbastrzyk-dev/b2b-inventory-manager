// 1. Create and Insert the Product
Product2 prod = new Product2(
    Name = 'Industrial Microfiber Roll', 
    IsActive = true
);
insert prod;

// 2. Create and Insert the Warehouses
Warehouse__c berlin = new Warehouse__c(
    Name = 'Berlin Hub', 
    Region__c = 'DACH', 
    Total_Capacity_in_Meters__c = 50000
);
Warehouse__c london = new Warehouse__c(
    Name = 'London Hub', 
    Region__c = 'UK', 
    Total_Capacity_in_Meters__c = 30000
);
insert new List<Warehouse__c>{berlin, london};

// 3. Create and Insert the Inventory Items (The Junction Object)
Inventory_Item__c inv1 = new Inventory_Item__c(
    Warehouse__c = berlin.Id,       // Linking to Berlin
    Product__c = prod.Id,           // Linking to our Microfiber Roll
    Quantity_in_Meters__c = 1500,
    Restock_Threshold__c = 200
);

Inventory_Item__c inv2 = new Inventory_Item__c(
    Warehouse__c = london.Id,       // Linking to London
    Product__c = prod.Id,           // Linking to the same Microfiber Roll
    Quantity_in_Meters__c = 800,
    Restock_Threshold__c = 100
);
insert new List<Inventory_Item__c>{inv1, inv2};

System.debug('✅ All dummy data successfully created!');
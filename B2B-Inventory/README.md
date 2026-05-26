# B2B Material Order & Inventory Manager

## 📌 Project Overview
This is a custom backend Salesforce application designed to manage complex bulk material orders and automate inventory tracking across multiple European warehouses. It demonstrates enterprise-level Apex architecture, strict adherence to Governor Limits, and robust unit testing.

## 🏢 Business Scenario
A B2B manufacturer needs a system to deduct physical inventory automatically when a Sales Rep activates an Order. Because a single order might contain industrial materials shipped from different regional hubs (e.g., Berlin vs. London), the system requires a highly intelligent automation layer to deduct the exact quantities from the correct physical locations.

## ⚙️ Technical Architecture
* **Trigger Handler Pattern:** Implemented an `after update` trigger on the standard `Order` object, routing logic to a dedicated handler class to maintain Separation of Concerns.
* **Bulkification & Scalability:** The `InventoryService` class processes bulk records efficiently using Maps and Sets, ensuring only a single SOQL query and a single DML statement are executed, regardless of how many items are ordered.
* **Composite Keys:** Developed a complex Apex matching algorithm using Composite Keys (combining `Product2Id` + `Warehouse__c`) to accurately deduct line items shipped from different warehouses on the exact same order.
* **Enterprise Testing:** Created a reusable `TestDataFactory` to generate standard and custom object records. Achieved **100% Code Coverage** on the Trigger and Handler classes while safely resetting Governor Limits using `Test.startTest()`.

## 🗄️ Data Model
* **Standard Objects:** `Account`, `Product2`, `PricebookEntry`, `Order`, `OrderItem`
* **Custom Objects:** * `Warehouse__c` (Tracks physical locations and capacity)
  * `Inventory_Item__c` (Junction object linking Products to Warehouses to track specific stock levels and restock thresholds).

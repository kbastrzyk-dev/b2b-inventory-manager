trigger OrderTrigger on Order (after update) {
    // Route the transaction to our Handler class safely
    if (Trigger.isAfter && Trigger.isUpdate) {
        OrderTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
    }
}
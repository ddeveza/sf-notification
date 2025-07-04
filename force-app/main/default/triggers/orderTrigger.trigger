/**
 * @name orderTrigger
 * @description
**/
trigger orderTrigger on Order (
    after update
) {
        if(Trigger.isAfter && Trigger.isUpdate) {
            OrderHelper.AfterUpdate(Trigger.New, Trigger.Old);
        }
  
}
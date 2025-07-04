public class OrderHelper {

    /**
     * @name AfterUpdate
     * @description 
     * @param List<Order> newList
     * @param List<Order> oldList
     * @return void
    **/
    public static void AfterUpdate(List<Order> newList, List<Order> oldList){
        Set<Id> orderIds = new Set<Id>();
        for ( Integer i=0; i<newList.size(); i++ ){
            if ( newList[i].Status == Constants.ACTIVATED_ORDER_STATUS && oldList[i].Status != Constants.ACTIVATED_ORDER_STATUS ){
                orderIds.add(newList[i].Id);
            }
        }

        RollUpOrderItems(orderIds);
    }

    /**
     * @name RollUpOrderItems
     * @description Given a set of Activated Order ids, query the child Order Items and related Products to calculate Inventory levels
     * @param Set<Id> activatedOrderIds
     * @return void
    **/
    public static void RollUpOrderItems(Set<Id> activatedOrderIds){
        // Map of Product2 Id to Product2 record
        Map<Id, Product2> productMap = new Map<Id, Product2>();
        if (activatedOrderIds == null || activatedOrderIds.isEmpty()) {
            return;
        }
        // Query OrderItems for the activated orders
        List<OrderItem> orderItems = [
            SELECT Id, Product2Id, Quantity, Product2.Quantity_Ordered__c
            FROM OrderItem
            WHERE OrderId IN :activatedOrderIds
            AND Product2Id != null
        ];
        Set<Id> productIds = new Set<Id>();
        for (OrderItem oi : orderItems) {
            productIds.add(oi.Product2Id);
        }
        if (productIds.isEmpty()) {
            return;
        }
        // Query Product2 records
        for (Product2 p : [SELECT Id, Quantity_Ordered__c FROM Product2 WHERE Id IN :productIds]) {
            productMap.put(p.Id, p);
        }
        // Aggregate OrderItem quantities by Product2
        Map<Id, Decimal> productQtyMap = new Map<Id, Decimal>();
        for (AggregateResult ar : [
            SELECT Product2Id pId, SUM(Quantity) qty
            FROM OrderItem
            WHERE Product2Id IN :productIds
            GROUP BY Product2Id
        ]) {
            productQtyMap.put((Id)ar.get('pId'), (Decimal)ar.get('qty'));
        }
        // Update Product2 inventory levels
        List<Product2> productsToUpdate = new List<Product2>();
        for (Id pid : productMap.keySet()) {
            if (productQtyMap.containsKey(pid)) {
                productMap.get(pid).Quantity_Ordered__c = productQtyMap.get(pid);
                productsToUpdate.add(productMap.get(pid));
            }
        }
        if (!productsToUpdate.isEmpty()) {
            update productsToUpdate;
        }
    }

}
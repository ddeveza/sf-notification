@isTest (seeAllData=false)
private class Product2Tests {
@testSetup
public static void SetupTestData(){  
    
    CollaborationGroup ChatterGroup = new CollaborationGroup(
        Name = 'TEST'+ constants.INVENTORY_ANNOUNCEMENTS,  
        CollaborationType = 'Public',
        CanHaveGuests = false,
        IsArchived = false,
        IsAutoArchiveDisabled = true
        );
    insert ChatterGroup;
     
}
    
@isTest 
    static void Product2Extension_UnitTest(){
        PageReference pageRef = Page.Product2New;
        Test.setCurrentPage(pageRef);
        Product2 prod = new Product2(name='Test',isActive=true);        
        ApexPages.StandardController stdcontroller = new ApexPages.StandardController(prod);        
        Product2Extension ext = new Product2Extension(stdcontroller);        
           System.assertEquals(Constants.DEFAULT_ROWS, ext.productsToInsert.size());
        
        ext.addRows();
        System.assertEquals(Constants.DEFAULT_ROWS * 2, ext.productsToInsert.size());
        
        for (Integer i = 0; i < 5; i++) {
            Product2Extension.ProductWrapper wrapper = ext.productsToInsert[i];
            
            Product2 testProduct = new Product2();
            testProduct.Name = 'Test Product ' + i;
            testProduct.IsActive = true;
            testProduct.Initial_Inventory__c = 20;
            testProduct.Family = Constants.PRODUCT_FAMILY[0].getValue();
            wrapper.productRecord = testProduct;
            
            PricebookEntry testEntry = new PricebookEntry();
            testEntry.IsActive = true;
            testEntry.UnitPrice = 10;
            wrapper.pricebookEntryRecord = testEntry;
        }
        
        Test.startTest();
        ext.save();
        Test.stopTest();
        
        ext.GetFamilyOptions();
        ext.GetInventory();
        List<Product2> createdProducts = [
            SELECT
                Id
            FROM
                   Product2
        ];
        System.assertEquals(5, createdProducts.size());
    }
    
   @isTest
    static void Product2Trigger_UnitTest(){
        TestDataFactory.InsertTestData(5); 
          test.startTest();
        
   
        Order rec = [select id, Status from Order limit 1];
        Product2 prod = [SELECT 
        Family,Id,Name,Quantity_Ordered__c,Quantity_Remaining__c FROM Product2 
        limit 1];
         
       rec.status = constants.ACTIVATED_ORDER_STATUS;      
       Update rec;
       Product2 updatedprod = [SELECT 
       Family,Id,Name,Quantity_Ordered__c,Quantity_Remaining__c FROM Product2 limit 
       1];
        
       TestDataFactory.VerifyQuantityOrdered(prod,updatedprod,constants.DEFAULT_ROWS);
       Test.stopTest();
    
    }
}


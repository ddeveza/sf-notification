public class Constants {
    // Number of rows to display in Visualforce pages
    public static final Integer DEFAULT_ROWS = 5;
    
    // Select One picklist value from custom label
    public static final String SELECT_ONE = System.Label.Select_One;
    
    // Low inventory threshold from custom label
    public static final String INVENTORY_LEVEL_LOW = System.Label.Inventory_Level_Low;
    
    // Dynamic list of Product Family picklist values
    public static final List<Schema.PicklistEntry> PRODUCT_FAMILY = 
        Product2.Family.getDescribe().getPicklistValues();
    
    // Order status values
    public static final String DRAFT_ORDER_STATUS = 'Draft';
    public static final String ACTIVATED_ORDER_STATUS = 'Activated';
    
    // Chatter group name for inventory announcements
    public static final String INVENTORY_ANNOUNCEMENTS = 'Inventory Announcements';
    
    // Generic error message for Visualforce pages
    public static final String ERROR_MESSAGE = 
        'An error has occurred, please take a screenshot with the URL and send it to IT.';
    
    // Standard Pricebook Id
    public static final Id STANDARD_PRICEBOOK_ID = '01sd2000006KEucAAG';
}
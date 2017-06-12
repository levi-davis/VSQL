1 - Hubspot Contacts
47
SELECT
	c.CustomerID as 'Volusion ID'
	, COUNT(o.OrderID) as 'Order Count'
	, CONVERT(varchar, MIN(o.OrderDate), 101) as 'Order Date First'
	, CONVERT(varchar, MAX(o.OrderDate), 101) as 'Order Date Last'
	, c.AccessKey as 'Access Key'
	, ISNULL(c.SalesRep_CustomerID,o.SalesRep_CustomerID) as 'Account Rep'
	, c.CompanyName as 'Company Name'
	, c.FirstName as 'First Name'
	, c.LastName as 'Last Name'
	, c.BillingAddress1 as 'Street Address'
	, c.BillingAddress2 as 'Street Address 2'
	, c.City as 'City'
	, c.State as 'State/Region'
	, c.PostalCode as 'Postal Code'
	, c.Country as 'Country'
	, c.PhoneNumber as 'Phone Number'
	, c.EmailAddress as 'Email'
	, c.FaxNumber as 'Fax Number'
	, c.WebsiteAddress as 'Website URL'
	, CONVERT(varchar, c.LastModified, 101) as 'Volusion Last Modified Date'
	, c.Custom_Field_Industry as 'Industry'
FROM Customers AS c 
LEFT JOIN Orders AS o
	ON c.CustomerID = o.CustomerID
WHERE c.CustomerID >= 23
AND c.CustomerID <> 24
AND o.Orderstatus <> 'cancelled'
AND c.AccessKey <> 'A'
AND c.EmailAddress NOT LIKE '%@marketplace.amazon.com'
AND (c.Country <> '' OR c.Country IS NOT NULL)
AND o.OrderDate >= DATEADD(day, -30 , GETDATE())
GROUP BY 
	c.CustomerID
	, c.AccessKey
	, c.SalesRep_CustomerID
	, c.CompanyName
	, c.FirstName
	, c.LastName
	, c.BillingAddress1
	, c.BillingAddress2
	, c.City
	, c.State
	, c.PostalCode
	, c.Country
	, c.PhoneNumber
	, c.EmailAddress
	, c.FaxNumber
	, c.WebsiteAddress
	, c.FirstDateVisited
	, c.LastLogin
	, c.LastModified
	, c.Custom_Field_Industry
	, o.SalesRep_CustomerID
HAVING Count(o.OrderID) <> '0'
ORDER BY c.CustomerID ASC


2 - HubSpot Order Details
98
SELECT
	c.CustomerID AS 'Volusion ID'
	, c.EmailAddress as 'Email'
	, o.OrderID AS 'Order ID'
	, o.PaymentMethodID AS 'Payment Method ID'
	, o.Customer_IPAddress AS 'IP Address'
	, CONVERT(varchar, o.OrderDate, 101) AS 'Order Date'
	, o.OrderStatus AS 'Order Status'
	, CONVERT(varchar, MAX(od.ShipDate), 101) AS 'Shipment Date'
	, o.LastModBy AS 'Last Modification By'
	, o.SalesRep_CustomerID 'Order Created By'
	, o.PaymentAmount AS 'Payment Amount'
	, o.Total_Payment_Authorized AS 'Payment Authorized'
	, o.Total_Payment_Received AS 'Payment Received'
	, od.OrderDetailID AS 'Order Detail ID'
	, od.ProductCode AS 'Product Code'
	, od.ProductName AS 'Product Name'
	, od.TotalPrice AS 'Total Order Price of Line Item'
	, od.Quantity As 'Quantity Ordered'
FROM Orders AS o
LEFT JOIN OrderDetails AS od
	ON o.OrderID = od.OrderID
LEFT JOIN Customers AS c
	ON o.CustomerID = c.CustomerID
WHERE c.CustomerID >= 23
AND c.CustomerID <> 24
AND o.Orderstatus <> 'cancelled'
AND c.AccessKey <> 'A'
AND c.EmailAddress NOT LIKE '%@marketplace.amazon.com'
AND (c.Country <> '' OR c.Country IS NOT NULL)
AND o.OrderDate >= DATEADD(day, -90, GETDATE())
GROUP BY
	c.CustomerID
	, c.EmailAddress
	, o.OrderID
	, o.PaymentMethodID
	, o.Customer_IPAddress
	, o.OrderDate
	, o.OrderStatus
	, o.PaymentAmount
	, o.Total_Payment_Authorized
	, o.Total_Payment_Received
	, o.SalesRep_CustomerID
	, o.LastModBy
	, od.OrderDetailID 
	, od.ProductCode
	, od.ProductName
	, od.TotalPrice
	, od.Quantity
HAVING Count(o.OrderID) <> '0'
ORDER BY o.OrderID, od.TotalPrice ASC


3 - HubSpot Orders	
55
SELECT
	c.CustomerID AS 'Volusion ID'
	, c.EmailAddress as 'Email'
	, o.OrderID AS 'Order ID'
	, o.Customer_IPAddress AS 'IP Address'
	, o.OrderDate AS 'Order Date'
	, o.OrderStatus AS 'Order Status'
	, MAX(od.ShipDate) AS 'Shipment Date'
	, o.LastModBy AS 'Last Modification By'
	, o.SalesRep_CustomerID 'Order Created By'
	, o.PaymentAmount AS 'Payment Amount'
FROM Orders AS o
LEFT JOIN OrderDetails AS od
	ON o.OrderID = od.OrderID
LEFT JOIN Customers AS c
	ON o.CustomerID = c.CustomerID
WHERE c.CustomerID >= 23
AND c.CustomerID <> 24
AND o.Orderstatus <> 'cancelled'
AND c.AccessKey <> 'A'
AND (c.Country <> '' OR c.Country IS NOT NULL)
GROUP BY
	c.CustomerID
	,c.EmailAddress
	, o.OrderID
	, o.Customer_IPAddress
	, o.OrderDate
	, o.OrderStatus
	, o.PaymentAmount
	, o.SalesRep_CustomerID
	, o.LastModBy
ORDER BY c.CustomerID ASC


4 - Google Merchant Center	
13
SELECT p.productcode AS id,
       p.productname AS [stripHTML-title],
       Isnull(Isnull(p.google_product_type, pp.google_product_type), 'n/a') AS product_type,
       Isnull(Isnull(p.google_product_category, pp.google_product_category), 'n/a') AS google_product_category,
       CASE WHEN ISNULL(p.IsChildOfProductCode, '') = '' THEN
                                ISNULL(p.Google_Unique_Identifier_Exists, 1)
                               ELSE
                                    ISNULL(pp.Google_Unique_Identifier_Exists, 1)
                                END AS identifier_exists,
                                CASE WHEN ISNULL(p.IsChildOfProductCode, '') = '' THEN
                                ISNULL(p.Google_Adult_Product, 0)
                                ELSE
                                    ISNULL(pp.Google_Adult_Product, 0)
                                END AS adult,
       /* Previously: Isnull(p.saleprice, p.productprice) AS price, */
       p.productprice AS price,
       Isnull(p.productmanufacturer, 'n/a') AS brand,
       Isnull(p.productcondition, 'n/a') AS condition,
       CONVERT(VARCHAR(10), (Getdate() + 29), 120) AS expiration_date,
       p.productdescriptionshort AS[stripHTML-description],
       'Config_FullStoreURLConfig_ProductPhotosFolder/' + Isnull(p.productcode, pp.productcode) + '-2T.jpg' AS image_link,
       'Config_FullStoreURLProductDetails.asp?ProductCode=' + p.productcode + '&click=2' AS link,
       Isnull(p.google_age_group, pp.google_age_group) AS age_group,
       Isnull(p.google_availability, pp.google_availability) AS availability,
       Isnull(p.google_color, pp.google_color) AS color,
       Isnull(p.google_gender, pp.google_gender) AS gender,
       Isnull(p.google_material, pp.google_material) AS material,
       Isnull(p.google_pattern, pp.google_pattern) AS pattern,
       Isnull(p.google_size, pp.google_size) AS SIZE,
       Isnull(Isnull(Isnull(p.upc_code, pp.upc_code), Isnull(p.book_isbn, pp.book_isbn)), Isnull(p.ean, pp.ean)) AS gtin,
       Isnull(p.vendor_partno, pp.vendor_partno) AS mpn,
       p.ischildofproductcode AS item_group_id,
       p.warehousecustom AS custom_label_0
FROM vmerchant.products_joined p
LEFT OUTER JOIN vmerchant.products_joined pp ON p.ischildofproductcode = pp.productcode
WHERE Isnull(p.enablemultichildaddtocart, 'N') = 'N'
  AND Isnull(p.enableoptions_inventorycontrol, 'N') = 'N'
  AND (Isnull(p.hideproduct, 'N') <> 'Y'
       OR Isnull(p.ischildofproductcode, '') <> '')
  AND (Isnull(p.google_product_category, '') <> ''
       OR Isnull(pp.google_product_category, '') <> '')
  AND p.google_product_category IS NOT NULL
ORDER BY p.productcode


5 - Bing Product Catalog
38
SELECT p.productcode AS MPID,
       p.productname AS Title,
       Isnull(Isnull(p.google_product_category, pp.google_product_category), 'n/a') AS google_product_category,
       Isnull(Isnull(p.google_product_type, pp.google_product_type), 'n/a') AS MerchantCategory,
       Isnull(p.saleprice, p.productprice) AS price,
       Isnull(p.productmanufacturer, '') AS BrandorManufactuerer,
       'In stock' AS StockStatus,
       p.productweight AS ShippingWeight,
       Isnull(Isnull(p.google_product_category, pp.google_product_category), 'n/a') AS BingCategory,
       Isnull(p.productcondition, '') AS Condition,
       p.productdescriptionshort AS[stripHTML-description],
       'Config_FullStoreURLConfig_ProductPhotosFolder/' + p.productcode + '-2T.jpg' AS ImageURL,
       'Config_FullStoreURLProductDetails.asp?ProductCode=' + p.productcode + '&click=2' AS ProductURL,
       Isnull(p.google_availability, pp.google_availability) AS availability,
       Isnull(p.upc_code, '') AS UPC,
       Isnull(p.vendor_partno, pp.vendor_partno) AS MerchantSKU
FROM vmerchant.products_joined p
LEFT OUTER JOIN vmerchant.products_joined pp ON p.ischildofproductcode = pp.productcode
WHERE Isnull(p.enablemultichildaddtocart, 'N') = 'N'
  AND Isnull(p.enableoptions_inventorycontrol, 'N') = 'N'
  AND (Isnull(p.hideproduct, 'N') <> 'Y'
       OR Isnull(p.ischildofproductcode, '') <> '')
  AND (Isnull(p.google_product_category, '') <> ''
       OR Isnull(pp.google_product_category, '') <> '')
ORDER BY p.productcode


Accounting - Bank Transfer Finder (Specify Amount Range)	
139
SELECT
	o.OrderID
	, o.CustomerID
	, o.BillingCompanyName
	, o.BillingFirstName
	, o.BillingLastName
	, o.ShipCompanyName
	, o.ShipFirstName
	, o.ShipLastName
	, o.OrderStatus
	, o.PaymentAmount
	, o.Total_Payment_Authorized
	, o.Total_Payment_Received
FROM
	Orders AS o
WHERE 
        o.Total_Payment_Authorized > 1894.06
	AND o.Total_Payment_Authorized < 1994.06
GROUP BY
	o.OrderID
	, o.CustomerID
	, o.BillingCompanyName
	, o.BillingFirstName
	, o.BillingLastName
	, o.ShipCompanyName
	, o.ShipFirstName
	, o.ShipLastName
	, o.OrderStatus
	, o.PaymentAmount
	, o.Total_Payment_Authorized
	, o.Total_Payment_Received
ORDER BY o.OrderID ASC

Backup - Customers-All-Fields	
194
SELECT Customers.CustomerID, Customers.AccessKey, Customers.FirstName, Customers.LastName, Customers.CompanyName, Customers.BillingAddress1, Customers.BillingAddress2, Customers.City, Customers.State, Customers.PostalCode, Customers.Country, Customers.PhoneNumber, Customers.FaxNumber, Customers.EmailAddress, Customers.PaysStateTax, Customers.TaxID, Customers.EmailSubscriber, Customers.CatalogSubscriber, Customers.LastModified, Customers.PercentDiscount, Customers.WebsiteAddress, Customers.DiscountLevel, Customers.CustomerType, Customers.LastModBy, Customers.Customer_IsAnonymous, Customers.IsSuperAdmin, Customers.news1, Customers.news2, Customers.news3, Customers.news4, Customers.news5, Customers.news6, Customers.news7, Customers.news8, Customers.news9, Customers.news10, Customers.news11, Customers.news12, Customers.news13, Customers.news14, Customers.news15, Customers.news16, Customers.news17, Customers.news18, Customers.news19, Customers.news20, Customers.Allow_Access_To_Private_Sections, Customers.Customer_Notes, Customers.SalesRep_CustomerID, Customers.ID_Customers_Groups, Customers.Custom_Field_Custom4, Customers.Custom_Field_Custom5, Customers.Removed_From_Rewards, Customers.Custom_Field_Industry, Customers.Custom_Field_Verification FROM Customers


Backup - Products
193
SELECT Products_Joined.ProductCode, Products_Joined.Vendor_PartNo, Products_Joined.ProductName, Products_Joined.DisplayBeginDate, Products_Joined.DisplayEndDate, Products_Joined.HideProduct, Products_Joined.StockStatus, Products_Joined.LastModified, Products_Joined.Options_Cloned_From, Products_Joined.Photos_Cloned_From, Products_Joined.Share_StockStatus_With, Products_Joined.LastModBy, Products_Joined.IsChildOfProductCode, Products_Joined.IsChildOfProductCode_ProductID, Products_Joined.Options_Cloned_From_ProductID, Products_Joined.Photos_Cloned_From_ProductID, Products_Joined.Share_StockStatus_With_ProductID, Products_Joined.ProductPopularity, Products_Joined.HomePage_Section, Products_Joined.AutoDropShip, Products_Joined.DoNotAllowBackOrders, Products_Joined.WarehouseLocation, Products_Joined.WarehouseAisle, Products_Joined.WarehouseBin, Products_Joined.WarehouseCustom, Products_Joined.UPC_code, Products_Joined.ProductKeywords, Products_Joined.ProductNameShort, Products_Joined.ProductWeight, Products_Joined.FreeShippingItem, Products_Joined.MinQty, Products_Joined.MaxQty, Products_Joined.RecurringStartPrice, Products_Joined.RecurringStartDuration, Products_Joined.RecurringPrice, Products_Joined.RecurringHowOften, Products_Joined.RecurringDuration, Products_Joined.AllowPriceEdit, Products_Joined.ProductPrice, Products_Joined.ListPrice, Products_Joined.SalePrice, Products_Joined.TaxableProduct, Products_Joined.SelectedOptionIDs, Products_Joined.GiftWrapCost, Products_Joined.DownloadFile, Products_Joined.Availability, Products_Joined.METATAG_Title, Products_Joined.METATAG_Description, Products_Joined.DiscountedPrice_Level1, Products_Joined.DiscountedPrice_Level2, Products_Joined.DiscountedPrice_Level3, Products_Joined.DiscountedPrice_Level4, Products_Joined.DiscountedPrice_Level5, Products_Joined.Photo_SubText, Products_Joined.Photo_AltText, Products_Joined.DiscountedRecurringPrice_Level1, Products_Joined.DiscountedRecurringPrice_Level2, Products_Joined.DiscountedRecurringPrice_Level3, Products_Joined.DiscountedRecurringPrice_Level4, Products_Joined.DiscountedRecurringPrice_Level5, Products_Joined.Fixed_ShippingCost, Products_Joined.Fixed_ShippingCost_Outside_LocalRegion, Products_Joined.Uses_Product_KeyTypes, Products_Joined.Price_SubText, Products_Joined.Price_SubText_Short, Products_Joined.ListPrice_Name, Products_Joined.ProductPrice_Name, Products_Joined.SalePrice_Name, Products_Joined.Hide_YouSave, Products_Joined.Hide_FreeAccessories, Products_Joined.SetupCost, Products_Joined.SetupCost_Name, Products_Joined.DiscountedSetupCost_Level1, Products_Joined.DiscountedSetupCost_Level2, Products_Joined.DiscountedSetupCost_Level3, Products_Joined.DiscountedSetupCost_Level4, Products_Joined.DiscountedSetupCost_Level5, Products_Joined.SetupCost_Title, Products_Joined.StockReOrderQty, Products_Joined.warehouses, Products_Joined.Affiliate_Commissionable_Value, Products_Joined.AddtoCartBtn_Replacement_Text, Products_Joined.Book_ISBN, Products_Joined.ProductCondition, Products_Joined.EstShip_Ground, Products_Joined.EstShip_2ndDay, Products_Joined.EstShip_Overnight, Products_Joined.CustomField1, Products_Joined.CustomField2, Products_Joined.CustomField3, Products_Joined.CustomField4, Products_Joined.CustomField5, Products_Joined.ShoppingDotCom_Category, Products_Joined.Yahoo_Category, Products_Joined.Yahoo_Medium, Products_Joined.ProductManufacturer, Products_Joined.Hide_When_OutOfStock, Products_Joined.StockLowQtyAlarm, Products_Joined.AddToPO_Now, Products_Joined.LastPO_Qty, Products_Joined.LastPO_Date, Products_Joined.HowToGetSalePrice, Products_Joined.Inv_Verify_QtyOnHand, Products_Joined.Inv_LastVerified, Products_Joined.EnableMultiChildAddToCart, Products_Joined.Vendor_Price, Products_Joined.EnableOptions_InventoryControl, Products_Joined.PhotoURL_Small, Products_Joined.PhotoURL_Large, Products_Joined.Private_Section_Customers_Only, Products_Joined.Quickbooks_Item_Accnt, Products_Joined.Quickbooks_Item_AssetAccnt, Products_Joined.Quickbooks_Item_CogsAccnt, Products_Joined.VAT_Percentage, Products_Joined.Recurring_Pricing_Text, Products_Joined.Google_Product_Type, Products_Joined.Length, Products_Joined.Width, Products_Joined.Height, Products_Joined.Ships_By_Itself, Products_Joined.Package_Type, Products_Joined.Oversized, Products_Joined.Additional_Handling_Indicator, Products_Joined.Reward_Points_Given_For_Purchase, Products_Joined.ProductDescriptionShort, Products_Joined.ProductDescription, Products_Joined.ProductFeatures, Products_Joined.TechSpecs, Products_Joined.ExtInfo, Products_Joined.OrderFinished_Note, Products_Joined.METATAG_Keywords, Products_Joined.ProductDescription_AbovePricing, Products_Joined.CUSTOM_METATAGS_OVERRIDE, Products_Joined.NumProductsSharingStock, Products_Joined.EAN, Products_Joined.PhotoSeed, Products_Joined.Google_Product_Category, Products_Joined.Google_Size, Products_Joined.Google_Color, Products_Joined.Google_Gender, Products_Joined.Google_Age_Group, Products_Joined.Google_Availability, Products_Joined.Google_Pattern, Products_Joined.Google_Material, Products_Joined.EstDaysToShip, Products_Joined.Google_Unique_Identifier_Exists, Products_Joined.Google_Adult_Product, Products_Joined.Google_SizeType, Products_Joined.Google_SizeSystem, vMerchant.ufn_Get_Virtual_Columns(Products_Joined.ProductID, Products_Joined.ProductCode, 'CategoryIDs') AS CategoryIDs, vMerchant.ufn_Get_Virtual_Columns(Products_Joined.ProductID, Products_Joined.ProductCode, 'OptionIDs') AS OptionIDs, vMerchant.ufn_Get_Virtual_Columns(Products_Joined.ProductID, Products_Joined.ProductCode, 'Accessories') AS Accessories, vMerchant.ufn_Get_Virtual_Columns(Products_Joined.ProductID, Products_Joined.ProductCode, 'FreeAccessories') AS FreeAccessories, Products_Joined.ProductCode AS ProductURL, Products_Joined.ProductCode AS PhotoURL, (SELECT TOP 1 CategoryID FROM Categories_Products_Link WHERE ProductID = Products_Joined.ProductID ORDER BY ID) AS CategoryTree FROM Products_Joined WITH (NOLOCK) ORDER BY Products_Joined.ProductCode	


Database - Table Exporter (Specify Table)
109
SELECT *
FROM ProductViews


Database - Table Names and DB Structure	
56
select * from information_schema.tables


Edits - Add to Cart Replacement Text	
213
SELECT
	p.ProductCode
	, p.ProductName
	, p.AddtoCartBtn_Replacement_Text
FROM 
	Products_joined As p
WHERE 
	p.HideProduct IS NOT NULL
GROUP BY
	p.ProductCode
	, p.ProductName
	, p.AddtoCartBtn_Replacement_Text
ORDER BY 
	p.ProductCode ASC


Edits - Google Product Feed	
122
SELECT
              p.productcode
              , p.productname
              , p.google_product_type
              , pp.google_product_type
              , p.google_product_category
              , pp.google_product_category
              , p.saleprice
              , p.productprice
              , p.productmanufacturer
              , p.productweight
              , p.productcondition
              , p.productdescriptionshort
              , p.productcode
              , p.google_age_group
              , pp.google_age_group
              , p.google_availability
              , pp.google_availability
              , p.google_color
              , pp.google_color
              , p.google_gender
              , pp.google_gender
              , p.google_material
              , pp.google_material
              , p.google_pattern
              , pp.google_pattern
              , p.google_size
              , pp.google_size
              , p.upc_code
              , pp.upc_code
              , p.book_isbn
              , pp.book_isbn
              , p.ean
              , pp.ean
              , p.vendor_partno
              , pp.vendor_partno
              , p.ischildofproductcode
              , p.warehousecustom
       FROM vmerchant.products_joined p
       LEFT OUTER JOIN vmerchant.products_joined pp ON p.ischildofproductcode = pp.productcode
       WHERE Isnull(p.enablemultichildaddtocart, 'N') = 'N'
         AND Isnull(p.enableoptions_inventorycontrol, 'N') = 'N'
         AND (Isnull(p.hideproduct, 'N') <> 'Y'
              OR Isnull(p.ischildofproductcode, '') <> '')
         AND (Isnull(p.google_product_category, '') <> ''
              OR Isnull(pp.google_product_category, '') <> '')
       ORDER BY p.productcode


Edits - Google Merchant - Quick	
179
SELECT Products_Joined.ProductCode, Products_Joined.Vendor_PartNo, Products_Joined.ProductName, Products_Joined.StockStatus, Products_Joined.UPC_code, Products_Joined.ProductPrice, Products_Joined.RecurringPrice, Products_Joined.ProductManufacturer, Products_Joined.Google_Product_Type, Products_Joined.Google_Product_Category, Products_Joined.Google_Availability FROM Products_Joined WITH (NOLOCK) ORDER BY Products_Joined.ProductCode


Edits - Option Categories	
SELECT OptionCategories.ID, OptionCategories.HeadingGroup, OptionCategories.OptionCategoriesDesc, OptionCategories.IsRequired, OptionCategories.DisplayType, OptionCategories.ArrangeOptionCategoriesBy, OptionCategories.Hide_OptionCategoriesDesc, OptionCategories.Include_In_Search_Refinement, OptionCategories.AboutOptionCategories, OptionCategories.Use_Google_Size, OptionCategories.Use_Google_Color, OptionCategories.Use_Google_Material, OptionCategories.Use_Google_Pattern FROM OptionCategories


Edits - Options	
153
SELECT
	o.ID
	, o.OptionCatID
	, oc.OptionCategoriesDesc AS "OptionCategoriesDesc DELETE"
	, o.ReplacesOptionID
	, o.OptionsDesc
	, o.PriceDiff
	, o.ProductWeight
	, o.RecurringPriceDiff
	, o.JumpToProductCode
	, o.NoValue
	, o.ArrangeOptionsBy
	, o.IsProductCode
	, o.VendorPriceDiff
	, o.IsProductPrice
	, o.IsProductQuantity
	, o.IsProductCode_Qty
	, Options_ApplyTo.ProductCode AS ApplyToProductCodes
	, p.HideProduct AS "HideProduct DELETE"
FROM Options AS o
LEFT JOIN Options_ApplyTo 
	ON o.ID = Options_ApplyTo.OptionID
LEFT JOIN OptionCategories AS oc
	ON o.OptionCatID = oc.ID
LEFT JOIN Products_joined As p
	ON Options_ApplyTo.ProductCode = p.ProductCode
ORDER BY o.ID, Options_ApplyTo.ProductCode


Edits - Options Correction	
107
SELECT Options.ID, Options.OptionCatID, Options.ReplacesOptionID, Options.OptionsDesc, Options.PriceDiff, Options.ProductWeight, Options.RecurringPriceDiff, Options.JumpToProductCode, Options.NoValue, Options.ArrangeOptionsBy, Options.DefaultSelected, Options.Textbox_Size, Options.Textbox_Rows, Options.Validate_RegExpression, Options.Validate_ErrorMessage, Options.Validate_OptionID, Options.Validate_OptionCatID, Options.LastModified, Options.IsProductCode, Options.VendorPriceDiff, Options.Only_Available_With_OptionIDs, Options.Not_Available_With_OptionIDs, Options.IsProductPrice, Options.IsProductQuantity, Options.IsFixedShippingCost, Options.IsProductCode_Qty, Options.SetupCostDiff, Options.LastModBy, Options.OptionsDesc_SideNote, Options.Textbox_Max_Length, Options.FixedShippingCost, Options_ApplyTo.ProductCode AS ApplyToProductCodes FROM Options  LEFT JOIN Options_ApplyTo ON Options.ID = Options_ApplyTo.OptionID  ORDER BY Options.ID, Options_ApplyTo.ProductCode


Edits - Order ID Sales Rep Correction (Specify Rep Number)	
185
SELECT 
	o.OrderID
	, c.SalesRep_CustomerID
	, o.SalesRep_CustomerID
FROM Orders AS o
LEFT JOIN Customers AS c 
	ON c.CustomerID = o.CustomerID
WHERE c.CustomerID >= 23
	AND c.CustomerID <> 24
	AND c.CustomerID <> 26
	AND c.CustomerID <> 177
	AND c.AccessKey <> 'A'
	AND c.SalesRep_CustomerID = '26'
GROUP BY 
	o.OrderID
	, c.SalesRep_CustomerID
	, o.SalesRep_CustomerID
ORDER BY o.OrderID


Edits - Price Matching	
74
SELECT Products_Joined.ProductCode, Products_Joined.Vendor_PartNo, Products_Joined.ProductName, Products_Joined.UPC_code, Products_Joined.ProductPrice, Products_Joined.SalePrice, Products_Joined.ProductCode AS ProductURL FROM Products_Joined WITH (NOLOCK) ORDER BY Products_Joined.ProductCode


Edits - Product Availability	
210
SELECT
	p.ProductCode
	, p.ProductName
	, p.Availability
	, p.Google_Availability
	, p.HideProduct
FROM 
	Products_joined As p
GROUP BY
	p.ProductCode
	, p.ProductName
	, p.Availability
	, p.Google_Availability
	, p.HideProduct
ORDER BY 
	p.ProductCode ASC


Edits - Product Availability - HSI	
211
SELECT
	p.ProductCode
	, p.ProductName
	, p.Availability
	, p.Google_Availability
	, p.HideProduct
FROM 
	Products_joined As p
WHERE 
	(p.ProductCode LIKE 'CRS-VIDEO-CONFERENCING-%' 
	OR p.ProductCode LIKE 'CRS-GOOGLE-CHROMEBOX-SYSTEM' 
	OR p.ProductCode LIKE 'HUDDLECAM%'
	OR p.ProductCode LIKE 'PTZOptics%' 
	OR p.ProductCode LIKE 'HUDDLEPOD%'
	OR p.ProductCode LIKE 'PT12X%'
	OR p.ProductCode LIKE 'PT20X%'
	OR p.ProductCode LIKE 'PTVL%'
	OR p.ProductCode LIKE 'PT-BRDCST%'
	OR p.ProductCode LIKE 'HCA12%'
	OR p.ProductCode LIKE 'HCA20%'
	OR p.ProductCode LIKE 'HCM%'
	OR p.ProductCode LIKE 'HC%X%'
	OR p.ProductCode LIKE 'HC-JO%'
	OR p.ProductCode LIKE 'HP-AIR%'
	OR p.ProductCode LIKE 'PT-JO%'
	OR p.ProductCode LIKE 'PT-TEAM%'
	OR p.ProductCode LIKE 'HC-TEAM%'
	OR p.ProductCode LIKE 'PT-CM%')
GROUP BY
	p.ProductCode
	, p.ProductName
	, p.Availability
	, p.Google_Availability
	, p.HideProduct
ORDER BY 
	p.ProductName ASC


Edits - Product Availability - HSI - 2	
212
SELECT
	p.ProductCode
	, p.ProductName
	, p.Availability
	, ISNULL(p.Google_Availability,'') AS 'Google_Availability'
	, p.StockStatus
	, p.HideProduct
FROM 
	Products_joined As p
LEFT OUTER JOIN vmerchant.products_joined pp ON p.ischildofproductcode = pp.productcode
WHERE
	(p.ProductCode LIKE 'HUDDLECAM%' 
	AND p.HideProduct IS NULL
	AND pp.productid IS NULL
	AND p.Availability <> 'Discontinued')
	OR
	(p.ProductCode LIKE 'PTZOptics%' 
	AND p.HideProduct IS NULL
	AND pp.productid IS NULL
	AND p.Availability <> 'Discontinued')
	OR 
	(p.ProductCode LIKE 'HUDDLEPOD%' 
	AND p.HideProduct IS NULL
	AND pp.productid IS NULL
	AND p.Availability <> 'Discontinued')
	OR
	(p.ProductCode LIKE 'PT12X%' 
	AND p.HideProduct IS NULL
	AND pp.productid IS NULL
	AND p.Availability <> 'Discontinued')
	OR
	(p.ProductCode LIKE 'PT20X%' 
	AND p.HideProduct IS NULL
	AND pp.productid IS NULL
	AND p.Availability <> 'Discontinued')
	OR
	(p.ProductCode LIKE 'PTVL%' 
	AND p.HideProduct IS NULL
	AND pp.productid IS NULL
	AND p.Availability <> 'Discontinued')
	OR
	(p.ProductCode LIKE 'PT-BRDCST%' 
	AND p.HideProduct IS NULL
	AND pp.productid IS NULL
	AND p.Availability <> 'Discontinued')
	OR
	(p.ProductCode LIKE 'HCA12%' 
	AND p.HideProduct IS NULL
	AND pp.productid IS NULL
	AND p.Availability <> 'Discontinued')
	OR
	(p.ProductCode LIKE 'HCA20%' 
	AND p.HideProduct IS NULL
	AND pp.productid IS NULL
	AND p.Availability <> 'Discontinued')
	OR
	(p.ProductCode LIKE 'HCM%' 
	AND p.HideProduct IS NULL
	AND pp.productid IS NULL
	AND p.Availability <> 'Discontinued')
	OR
	(p.ProductCode LIKE 'HC%X%' 
	AND p.HideProduct IS NULL
	AND pp.productid IS NULL
	AND p.Availability <> 'Discontinued')
	OR
	(p.ProductCode LIKE 'HP-AIR%' 
	AND p.HideProduct IS NULL
	AND pp.productid IS NULL
	AND p.Availability <> 'Discontinued')
	OR
	(p.ProductCode LIKE 'PT-JO%' 
	AND p.HideProduct IS NULL
	AND pp.productid IS NULL
	AND p.Availability <> 'Discontinued')
	OR
	(p.ProductCode LIKE 'PT-TEAM%' 
	AND p.HideProduct IS NULL
	AND pp.productid IS NULL
	AND p.Availability <> 'Discontinued')
	OR
	(p.ProductCode LIKE 'HC-TEAM%' 
	AND p.HideProduct IS NULL
	AND pp.productid IS NULL
	AND p.Availability <> 'Discontinued')
	OR
	(p.ProductCode LIKE 'PT-CM%' 
	AND p.HideProduct IS NULL
	AND pp.productid IS NULL
	AND p.Availability <> 'Discontinued')
	OR
	(p.ProductCode LIKE 'CRS-VIDEO-CONFERENCING-%' 
	AND p.HideProduct IS NULL
	AND pp.productid IS NULL
	AND p.Availability <> 'Discontinued')
	OR
	(p.ProductCode LIKE 'CRS-GOOGLE-CHROMEBOX-SYSTEM'
	AND p.HideProduct IS NULL
	AND pp.productid IS NULL
	AND p.Availability <> 'Discontinued')
	OR
	(p.ProductCode LIKE 'HC-JO%'
	AND p.HideProduct IS NULL
	AND pp.productid IS NULL
	AND p.Availability <> 'Discontinued')
	OR
	(p.ProductCode LIKE '%-BSTK'
	AND p.Availability <> 'Discontinued'
	AND pp.productid IS NULL)
GROUP BY
	p.ProductCode
	, p.ProductName
	, p.Availability
	, p.Google_Availability
	, p.StockStatus
	, p.HideProduct
ORDER BY 
	p.ProductCode ASC


Edits - Product Metadata	
18
SELECT 
	p.ProductCode, 
	p.ProductName, 
	p.METATAG_Title, 
	p.ProductDescriptionShort, 
	p.METATAG_Description,
	vMerchant.ufn_Get_Virtual_Columns(p.ProductID, p.ProductCode, 'CategoryIDs') AS CategoryIDs,
	p.METATAG_Keywords 
FROM Products_Joined AS p
WHERE p.hideproduct IS NULL
ORDER BY p.ProductCode


Edits - Products Mass	
151
SELECT Products_Joined.ProductCode, Products_Joined.Vendor_PartNo, Products_Joined.ProductName, Products_Joined.HideProduct, Products_Joined.StockStatus, Products_Joined.UPC_code, Products_Joined.ProductKeywords, Products_Joined.ProductNameShort, Products_Joined.ProductWeight, Products_Joined.FreeShippingItem, Products_Joined.ProductPrice, Products_Joined.ListPrice, Products_Joined.SalePrice, Products_Joined.Availability, Products_Joined.METATAG_Title, Products_Joined.METATAG_Description, Products_Joined.DiscountedPrice_Level1, Products_Joined.DiscountedPrice_Level2, Products_Joined.DiscountedPrice_Level3, Products_Joined.DiscountedPrice_Level4, Products_Joined.DiscountedPrice_Level5, Products_Joined.Photo_SubText, Products_Joined.Photo_AltText, Products_Joined.Fixed_ShippingCost, Products_Joined.ProductCondition, Products_Joined.CustomField1, Products_Joined.CustomField2, Products_Joined.CustomField3, Products_Joined.CustomField4, Products_Joined.CustomField5, Products_Joined.ShoppingDotCom_Category, Products_Joined.Yahoo_Category, Products_Joined.ProductManufacturer, Products_Joined.Hide_When_OutOfStock, Products_Joined.Vendor_Price, Products_Joined.Google_Product_Type, Products_Joined.Length, Products_Joined.Width, Products_Joined.Height, Products_Joined.ProductDescriptionShort, Products_Joined.METATAG_Keywords, Products_Joined.ProductDescription_AbovePricing, Products_Joined.EAN, Products_Joined.Google_Product_Category, Products_Joined.Google_Availability, (SELECT TOP 1 CategoryID FROM Categories_Products_Link WHERE ProductID = Products_Joined.ProductID ORDER BY ID) AS CategoryTree FROM Products_Joined WITH (NOLOCK) ORDER BY Products_Joined.ProductCode


Edits - RMA Lost Value Correction	
206
SELECT
	o.SalesRep_CustomerID
	, o.OrderID
	, rma.RMA_Number
	, SUM(rmai.RMAI_LostValue) AS 'Lost Value'
FROM Orders AS o
LEFT JOIN RMAs AS rma
	ON o.OrderID = rma.RMA_OrderID
LEFT JOIN RMA_Items AS rmai
	ON rmai.RMA_Number = rma.RMA_Number
WHERE o.Orderstatus <> 'cancelled'
	AND o.OrderDate BETWEEN '1/1/2016 0:00' AND '12/31/2016 23:59'
	AND rma.RMA_Number <> ''
GROUP BY o.SalesRep_CustomerID
	, o.OrderID
	, rma.RMA_Number
ORDER BY o.SalesRep_CustomerID


Edits - Robot Check	
215
SELECT 
	c.CustomerID
	, Count(o.OrderID) AS 'Order Quanitity'
	, c.Country
FROM Customers AS c 
LEFT JOIN Orders AS o
	ON c.CustomerID = o.CustomerID
WHERE 
	c.Country = '' OR
	c.Country IS NULL
GROUP BY 
	c.CustomerID
	, c.EmailAddress
	, c.Country
ORDER BY c.CustomerID ASC


Edits - Sales Rep ID Correction	
136
SELECT
	c.CustomerID
	, c.FirstName
	, c.LastName
	, c.CompanyName
	, c.EmailAddress
	, c.SalesRep_CustomerID
	, o.OrderID
	, o.OrderDate
	, o.SalesRep_CustomerID
FROM Customers as c
LEFT JOIN Orders AS o
	ON c.CustomerID = o.CustomerID
WHERE o.CustomerID >= 23
AND o.CustomerID <> 24
GROUP BY
	c.CustomerID
	, c.FirstName
	, c.LastName
	, c.CompanyName
	, c.EmailAddress
	, c.SalesRep_CustomerID
	, o.OrderID
	, o.OrderDate
	, o.SalesRep_CustomerID
ORDER BY c.SalesRep_CustomerID, c.CustomerID, o.OrderID ASC


Edits - Sales Rep ID Correction 2	
183
SELECT
	c.CustomerID
	, c.FirstName
	, c.LastName
	, c.CompanyName
	, c.EmailAddress
	, c.SalesRep_CustomerID
FROM Customers as c
WHERE c.CustomerID >= 23
AND c.CustomerID <> 24
AND c.CustomerID <> 26
AND c.CustomerID <> 177
AND c.SalesRep_CustomerID is NULL
GROUP BY
	c.CustomerID
	, c.FirstName
	, c.LastName
	, c.CompanyName
	, c.EmailAddress
	, c.SalesRep_CustomerID
ORDER BY c.CustomerID ASC


HR - AR 4	
162
SELECT 
	o.PaymentMethodID, 
	o.OrderStatus, 
	o.SalesRep_CustomerID, 
	o.OrderID, 
	ISNULL(tn.ShipDate,o.OrderDate) AS 'Date', 
	o.BillingCompanyName, 
	o.PaymentAmount, 
	o.Total_Payment_Received,
	(o.PaymentAmount - o.Total_Payment_Received) AS 'Balance Due',
	DATEADD(day,30,o.ShipDate) AS 'Net30 Due Date',
	DATEDIFF(day, DATEADD(day,30,o.ShipDate), GETDATE()) AS 'Days Overdue'
FROM Orders AS o
WHERE (o.Orderstatus LIKE '%Shipped' or o.Orderstatus = 'Partially Returned' or o.Orderstatus = 'Ready to Ship' or o.Orderstatus = 'Pending Shipment' or o.Orderstatus = 'Awaiting Payment' or o.Orderstatus = 'Partially Shipped')
	AND (o.PaymentMethodID = '13' or o.PaymentMethodID = '2'or o.PaymentMethodID = '14'or o.PaymentMethodID = '29')
	AND o.PaymentAmount <> o.Total_Payment_Received
	AND o.ShipDate IS NOT NULL
	AND (o.PaymentAmount - o.Total_Payment_Received) > '0'
GROUP BY
	o.PaymentMethodID, 
	o.OrderStatus, 
	o.SalesRep_CustomerID, 
	o.OrderID, 
	o.ShipDate, 
	o.BillingCompanyName, 
	o.PaymentAmount, 
	o.Total_Payment_Received 
ORDER BY o.ShipDate


HR - AR 5	
188
SELECT 
	o.PaymentMethodID, 
	o.OrderStatus, 
	o.SalesRep_CustomerID, 
	o.OrderID, 
	o.ShipDate, 
	o.BillingCompanyName, 
	o.PaymentAmount, 
	o.Total_Payment_Received,
	(o.PaymentAmount - o.Total_Payment_Received) AS 'Balance Due',
	DATEADD(day,30,o.ShipDate) AS 'Net30 Due Date',
	DATEDIFF(day, DATEADD(day,30,o.ShipDate), GETDATE()) AS 'Days Overdue'
FROM Orders AS o
WHERE (o.Orderstatus LIKE '%Shipped' OR o.Orderstatus LIKE '%Backordered' OR o.Orderstatus = 'Partially Returned' OR o.Orderstatus = 'Awaiting Payment')
	AND o.PaymentAmount <> o.Total_Payment_Received
	AND o.ShipDate IS NOT NULL
	AND (o.PaymentAmount - o.Total_Payment_Received) > '0'
	AND o.PaymentMethodID <> '13'
GROUP BY
	o.PaymentMethodID, 
	o.OrderStatus, 
	o.SalesRep_CustomerID, 
	o.OrderID, 
	o.ShipDate, 
	o.BillingCompanyName, 
	o.PaymentAmount, 
	o.Total_Payment_Received 
ORDER BY o.ShipDate


HR - COMMISSIONS - ORDERS	
111
SELECT 
	o.OrderID,
	o.CustomerID,
	o.BillingCompanyName, 
	o.PaymentAmount, 
	o.PaymentMethodID, 
	o.OrderDate, 
	o.OrderStatus,
	o.Affiliate_Commissionable_Value, 
	o.Total_Payment_Received, 
	c.SalesRep_CustomerID, 
	o.Custom_Field_Costed, 
	o.Custom_Field_Commissioned, 
	o.Custom_Field_FIRSTORDER 
FROM Orders AS o
LEFT JOIN Customers AS c
	ON c.CustomerID = o.CustomerID
ORDER BY o.OrderID ASC


HR - COMMISSIONS-DETAILS	
120
SELECT 
	od.OrderDetailID, 
	od.OrderID, 
	od.ProductName, 
	od.Quantity, 
	od.ProductPrice, 
	od.TotalPrice, 
	od.Affiliate_Commissionable_Value, 
	od.Vendor_Price, 
	(od.TotalPrice - (od.Vendor_Price * od.Quantity)) AS Profit
FROM OrderDetails as od


HR - INVENTORY REPORT	
SELECT Products_Joined.ProductCode, Products_Joined.ProductName, Products_Joined.StockStatus, Products_Joined.Vendor_Price FROM Products_Joined WITH (NOLOCK) ORDER BY Products_Joined.ProductCode


HR - PA Sales Tax Report	
173
SELECT
	pl.pay_authdate AS 'Date'
	, o.OrderID
	, c.CompanyName AS 'Company'
	, o.ShipCity AS 'City'
	, o.ShipPostalCode AS 'Zip'
	, (c.FirstName + ' ' + c.LastName) AS 'Customer Name'
	, c.CustomerID
	, o.SalesRep_CustomerID AS 'Sales Rep'
	, (o.PaymentAmount - isnull(o.SalesTax1,0) - isnull(o.SalesTax2,0) - isnull(o.SalesTax3,0)) AS 'Subtotal'
	, (isnull(o.SalesTaxRate1,0) + isnull(o.SalesTaxRate2,0) + isnull(o.SalesTaxRate3,0)) AS 'Sales Tax Rate'
	, (isnull(o.SalesTax1,0) + isnull(o.SalesTax2,0) + isnull(o.SalesTax3,0)) AS 'Sales Tax'
	, (pm.paymentmethod + ' ' + isnull(o.pciaas_maskedcardref,' ')) AS 'Paid Via'
FROM Orders AS o
LEFT JOIN Customers AS c 
	ON c.CustomerID = o.CustomerID
LEFT JOIN Payment_Log AS pl 
	ON o.OrderID = pl.pay_orderid
LEFT JOIN PaymentMethods AS pm
	ON pl.pay_paymentmethodid = pm.paymentmethodid
WHERE pl.pay_paymentmethodid >= 5
	AND pl.pay_paymentmethodid <=8
	AND o.ShipState = 'PA'
	AND o.Orderstatus <> 'cancelled'
	AND o.Orderstatus NOT LIKE '%return%'
	AND pl.pay_authdate BETWEEN '1/1/2016 0:00' AND '12/31/2017 23:59'
	AND (pl.pay_result = 'DEBIT' OR pl.pay_result = 'CAPTURE')
	AND o.SalesTax1 <> '0'
	AND c.PaysStateTax is NULL
GROUP BY pl.pay_authdate, o.OrderID, c.CompanyName, o.ShipCity, o.ShipPostalCode, c.CustomerID, o.SalesRep_CustomerID, pl.pay_amount, (c.FirstName + ' ' + c.LastName), (o.PaymentAmount - isnull(o.SalesTax1,0) - isnull(o.SalesTax2,0) - isnull(o.SalesTax3,0)), (isnull(o.SalesTaxRate1,0) + isnull(o.SalesTaxRate2,0) + isnull(o.SalesTaxRate3,0)), (isnull(o.SalesTax1,0) + isnull(o.SalesTax2,0) + isnull(o.SalesTax3,0)), (pm.paymentmethod + ' ' + isnull(o.pciaas_maskedcardref,' '))
ORDER BY pl.pay_authdate ASC


HR - SALES BY ITEM	
104
SELECT OrderDetails.OrderDetailID, OrderDetails.OrderID, OrderDetails.ProductCode, OrderDetails.ProductName, OrderDetails.Quantity, OrderDetails.ProductPrice, OrderDetails.TotalPrice, OrderDetails.Shipped, OrderDetails.ShipDate, OrderDetails.Returned, OrderDetails.Returned_Date FROM OrderDetails


HR - SALES REPORT	
43
SELECT Orders.OrderID, Orders.BillingCompanyName, Orders.OrderDate, Orders.OrderStatus, Orders.Affiliate_Commissionable_Value, Orders.SalesRep_CustomerID FROM Orders


JM - CRS PO Customers	
208
SELECT
	c.CompanyName
	, (c.FirstName + ' ' + c.LastName) AS 'Customer Name'
	, c.CustomerID
	, o.SalesRep_CustomerID
	, o.OrderID
	, o.PaymentAmount
	, o.OrderDate
	, pl.pay_authdate
	, o.BillingCountry
	, DATEDIFF(day,o.OrderDate,pl.pay_authdate) AS 'Days Before Payment'
	, (DATEDIFF(day,o.OrderDate,pl.pay_authdate) - 30) AS 'Days over Net-30'
FROM Orders AS o
LEFT JOIN Customers AS c 
	ON c.CustomerID = o.CustomerID
LEFT JOIN Payment_Log AS pl 
	ON o.OrderID = pl.pay_orderid
WHERE o.PaymentMethodID = 13
	AND o.Orderstatus <> 'cancelled'
	AND o.OrderDate BETWEEN '1/1/2014 0:00' AND '12/31/2016 23:59'
	AND pl.Pay_Result = 'DEBIT'
GROUP BY 
	c.CompanyName
	, (c.FirstName + ' ' + c.LastName)
	, c.CustomerID
	, o.SalesRep_CustomerID
	, o.OrderID
	, o.PaymentAmount
	, o.BillingCountry
	, o.OrderDate
	, pl.pay_authdate
ORDER BY c.CompanyName ASC


JM - CRS PO Customers 2	
209
SELECT
	c.CompanyName
	, (c.FirstName + ' ' + c.LastName) AS 'Customer Name'
	, c.CustomerID
	, o.SalesRep_CustomerID
	, o.OrderID
	, o.PaymentAmount
	, MAX(ISNULL(tn.ShipDate,o.OrderDate)) AS 'Ship Date'
	, pl.pay_authdate
	, o.BillingCountry
	, DATEDIFF(day,MAX(ISNULL(tn.ShipDate,o.OrderDate)),pl.pay_authdate) AS 'Days Before Payment'
	, (DATEDIFF(day,MAX(ISNULL(tn.ShipDate,o.OrderDate)),pl.pay_authdate) - 32) AS 'Days over Net-30'
FROM Orders AS o
LEFT JOIN Customers AS c 
	ON c.CustomerID = o.CustomerID
LEFT JOIN Payment_Log AS pl 
	ON o.OrderID = pl.pay_orderid
LEFT JOIN TrackingNumbers AS tn 
	ON o.OrderID = tn.OrderID
WHERE o.PaymentMethodID = 13
	AND o.Orderstatus <> 'cancelled'
	AND o.OrderDate BETWEEN '1/1/2015 0:00' AND '12/31/2016 23:59'
	AND pl.Pay_Result = 'DEBIT'
	AND DATEDIFF(day,o.OrderDate,pl.pay_authdate) > 0
GROUP BY 
	c.CompanyName
	, (c.FirstName + ' ' + c.LastName)
	, c.CustomerID
	, o.SalesRep_CustomerID
	, o.OrderID
	, o.PaymentAmount
	, o.BillingCountry
	, pl.pay_authdate
ORDER BY c.CompanyName ASC


Unused - Dealer Renewal	
202
SELECT
	c.CustomerID
	, SUM(od.TotalPrice) AS 'Total Payment Received'
FROM OrderDetails AS od
LEFT JOIN Orders AS o
	ON o.OrderID = od.OrderID
LEFT JOIN Customers AS c 
	ON c.CustomerID = o.CustomerID
WHERE o.Orderstatus <> 'cancelled'
AND o.Orderstatus <> 'returned'
AND c.AccessKey <> 'A'
AND (od.ProductCode LIKE 'CRS-VIDEO-CONFERENCING-%' 
	OR od.ProductCode LIKE 'CRS-GOOGLE-CHROMEBOX-SYSTEM' 
	OR od.ProductCode LIKE 'HUDDLECAMHD%'
	OR od.ProductCode LIKE 'HUDDLECAMHD-%' 
	OR od.ProductCode LIKE 'PTZOptics%' 
	OR od.ProductCode LIKE 'HUDDLEPOD%'
	OR od.ProductCode LIKE 'PT12X%'
	OR od.ProductCode LIKE 'PT20X%'
	OR od.ProductCode LIKE 'PT-VL%'
	OR od.ProductCode LIKE 'PT-BRDCSTR%'
	OR od.ProductCode LIKE 'HCA12X'
	OR od.ProductCode LIKE 'HCA20X%'
	OR od.ProductCode LIKE 'HCM%'
	OR od.ProductCode LIKE 'HC%X%'
	OR od.ProductCode LIKE 'HC-JOY'
	OR od.ProductCode LIKE 'HP-AIR%')
AND (c.CustomerID = 50
	OR c.CustomerID = 158
	OR c.CustomerID = 142
	OR c.CustomerID = 278
	OR c.CustomerID = 671
	OR c.CustomerID = 378
	OR c.CustomerID = 39
	OR c.CustomerID = 1774
	OR c.CustomerID = 1703
	OR c.CustomerID = 644
	OR c.CustomerID = 481
	OR c.CustomerID = 466
	OR c.CustomerID = 620
	OR c.CustomerID = 503
	OR c.CustomerID = 229
	OR c.CustomerID = 675
	OR c.CustomerID = 1117
	OR c.CustomerID = 1980
	OR c.CustomerID = 751
	OR c.CustomerID = 791
	OR c.CustomerID = 861
	OR c.CustomerID = 973
	OR c.CustomerID = 969
	OR c.CustomerID = 1400
	OR c.CustomerID = 924
	OR c.CustomerID = 1134
	OR c.CustomerID = 1124
	OR c.CustomerID = 1130)
AND o.OrderDate BETWEEN '1/1/2015 0:00' AND '12/31/2015 23:59'
GROUP BY 
	c.CustomerID


JM - Dealer Totals	
205
SELECT
	c.CompanyName
	, SUM(od.TotalPrice) AS 'Total Payment Received'
FROM OrderDetails AS od
LEFT JOIN Orders AS o
	ON o.OrderID = od.OrderID
LEFT JOIN Customers AS c 
	ON c.CustomerID = o.CustomerID
WHERE o.Orderstatus <> 'cancelled'
AND o.Orderstatus <> 'returned'
AND c.CustomerID >= 23
AND c.CustomerID <> 24
AND c.CustomerID <> 26
AND c.CustomerID <> 177
AND c.AccessKey <> 'A'
AND (c.EmailAddress LIKE '%7distribution.com'
		OR c.EmailAddress LIKE '%abs-tech.com'
		OR c.EmailAddress LIKE '%academictechinc.com'
		OR c.EmailAddress LIKE '%adslv.com'
		OR c.EmailAddress LIKE '%admteknologi.com'
		OR c.EmailAddress LIKE '%advanced-inc.com'
		OR c.EmailAddress LIKE '%ats-av.com'
		OR c.EmailAddress LIKE '%affinitechinc.com'
		OR c.EmailAddress LIKE '%agrity.com.my'
		OR c.EmailAddress LIKE '%alltec.co.il'
		OR c.EmailAddress LIKE '%amazingtech.solutions'
		OR c.EmailAddress LIKE '%amelation.com'
		OR c.EmailAddress LIKE '%aselcom.cr'
		OR c.EmailAddress LIKE '%atpsystemsav.com'
		OR c.EmailAddress LIKE '%a-v-c.com'
		OR c.EmailAddress LIKE '%audiovideopr.com'
		OR c.EmailAddress LIKE '%mig-avc.com'
		OR c.EmailAddress LIKE '%avisystems.com'
		OR c.EmailAddress LIKE '%azure-ds.com'
		OR c.EmailAddress LIKE '%batipi.com'
		OR c.EmailAddress LIKE '%bluewatertech.com '
		OR c.EmailAddress LIKE '%belectriccorp.com'
		OR c.EmailAddress LIKE '%broadcast-tech.com'
		OR c.EmailAddress LIKE '%cve.com'
		OR c.EmailAddress LIKE '%camperio.net'
		OR c.EmailAddress LIKE '%caribtechsol.com'
		OR c.EmailAddress LIKE '%cartersav.com'
		OR c.EmailAddress LIKE '%casaplex.com'
		OR c.EmailAddress LIKE '%ccssouthwest.com '
		OR c.EmailAddress LIKE '%ccssoutheast.com'
		OR c.EmailAddress LIKE '%ce2.at'
		OR c.EmailAddress LIKE '%cerge.com'
		OR c.EmailAddress LIKE '%clarktechnologies.com'
		OR c.EmailAddress LIKE '%getclearav.co.uk'
		OR c.EmailAddress LIKE '%collaborationsolutions.com'
		OR c.EmailAddress LIKE '%colortone-av.com'
		OR c.EmailAddress LIKE '%commlinkav.com'
		OR c.EmailAddress LIKE '%commav.net'
		OR c.EmailAddress LIKE '%computerworldslu.com'
		OR c.EmailAddress LIKE '%conferencetech.com'
		OR c.EmailAddress LIKE '%cp-vision.at'
		OR c.EmailAddress LIKE '%crisptelecom.us'
		OR c.EmailAddress LIKE '%dg-av.com'
		OR c.EmailAddress LIKE '%digarts.com'
		OR c.EmailAddress LIKE '%adigitalhome.com'
		OR c.EmailAddress LIKE '%disk.cz'
		OR c.EmailAddress LIKE '%dreamtech.com.ua'
		OR c.EmailAddress LIKE '%easymeeting.net'
		OR c.EmailAddress LIKE '%elvia.cz'
		OR c.EmailAddress LIKE '%encompassmedia.net'
		OR c.EmailAddress LIKE '%ezpyramid.com'
		OR c.EmailAddress LIKE '%featherstonmedia.com'
		OR c.EmailAddress LIKE '%featpresav.com'
		OR c.EmailAddress LIKE '%ftx.ee'
		OR c.EmailAddress LIKE '%gnode.mx'
		OR c.EmailAddress LIKE '%networkparamedics.com'
		OR c.EmailAddress LIKE '%gofacing.com'
		OR c.EmailAddress LIKE '%hbcommunications.com'
		OR c.EmailAddress LIKE '%hefservices.com'
		OR c.EmailAddress LIKE '%hitechavs.com'
		OR c.EmailAddress LIKE '%highbitsav.com'
		OR c.EmailAddress LIKE '%iled.co.za'
		OR c.EmailAddress LIKE '%innotouch.net'
		OR c.EmailAddress LIKE '%integratedmultimediasolutions.com'
		OR c.EmailAddress LIKE '%intercadsys.com'
		OR c.EmailAddress LIKE '%intuitivecomminc.com'
		OR c.EmailAddress LIKE '%iqsystems.com.ec'
		OR c.EmailAddress LIKE '%verizon.net '
		OR c.EmailAddress LIKE '%it1.com'
		OR c.EmailAddress LIKE '%ivs-tec.com'
		OR c.EmailAddress LIKE '%jsav.com'
		OR c.EmailAddress LIKE '%jtjti.com'
		OR c.EmailAddress LIKE '%karshathoughts.com'
		OR c.EmailAddress LIKE '%kingsystemsllc.com'
		OR c.EmailAddress LIKE '%limasound.com'
		OR c.EmailAddress LIKE '%lookeasy.asia'
		OR c.EmailAddress LIKE '%ltt.com.pl'
		OR c.EmailAddress LIKE '%m3techgroup.com'
		OR c.EmailAddress LIKE '%madisontech.com.au'
		OR c.EmailAddress LIKE '%tbaytel.ne'
		OR c.EmailAddress LIKE '%gomediatech.com'
		OR c.EmailAddress LIKE '%medvisionusa.com'
		OR c.EmailAddress LIKE '%meineketv.com'
		OR c.EmailAddress LIKE '%midtownvideo.com'
		OR c.EmailAddress LIKE '%milestoneproductions.ie'
		OR c.EmailAddress LIKE '%momentumsound.com'
		OR c.EmailAddress LIKE '%msomcomm.com'
		OR c.EmailAddress LIKE '%multi-systems.com'
		OR c.EmailAddress LIKE '%mysherpa.com'
		OR c.EmailAddress LIKE '%natheatrix.com'
		OR c.EmailAddress LIKE '%northlandss.com'
		OR c.EmailAddress LIKE '%itshappeningrightnow.com'
		OR c.EmailAddress LIKE '%nyherji.is'
		OR c.EmailAddress LIKE '%officeplusuae.com'
		OR c.EmailAddress LIKE '%opennetworks.com'
		OR c.EmailAddress LIKE '%osmetro.com'
		OR c.EmailAddress LIKE '%opta.kiev.ua'
		OR c.EmailAddress LIKE '%performancecom.net'
		OR c.EmailAddress LIKE '%perftechman.com'
		OR c.EmailAddress LIKE '%perlmutterpurchasing.com'
		OR c.EmailAddress LIKE '%pixelpro.com.tr'
		OR c.EmailAddress LIKE '%chasethebracelet.com'
		OR c.EmailAddress LIKE '%praxis8.com'
		OR c.EmailAddress LIKE '%prosound.net'
		OR c.EmailAddress LIKE '%provector.dk'
		OR c.EmailAddress LIKE '%provav.com'
		OR c.EmailAddress LIKE '%rbccable.com'
		OR c.EmailAddress LIKE '%resolution-av.co.nz'
		OR c.EmailAddress LIKE '%slproductions.us'
		OR c.EmailAddress LIKE '%shi.com'
		OR c.EmailAddress LIKE '%sidewalktech.com'
		OR c.EmailAddress LIKE '%siscocorp.com'
		OR c.EmailAddress LIKE '%slickcybersystems.com'
		OR c.EmailAddress LIKE '%smartglobal.es'
		OR c.EmailAddress LIKE '%shisystems.com'
		OR c.EmailAddress LIKE '%streamportmedia.com'
		OR c.EmailAddress LIKE '%syncomation.com'
		OR c.EmailAddress LIKE '%sysquo.com'
		OR c.EmailAddress LIKE '%sys-dsn.com'
		OR c.EmailAddress LIKE '%tymc.co.kr'
		OR c.EmailAddress LIKE '%TCCOhio.com'
		OR c.EmailAddress LIKE '%tech-integ.com'
		OR c.EmailAddress LIKE '%tvg.mx'
		OR c.EmailAddress LIKE '%telesmart.co.nz'
		OR c.EmailAddress LIKE '%theavgroup.com'
		OR c.EmailAddress LIKE '%tirusvoice.com'
		OR c.EmailAddress LIKE '%triag.us'
		OR c.EmailAddress LIKE '%tsi-global.com '
		OR c.EmailAddress LIKE '%videolink.ca'
		OR c.EmailAddress LIKE '%visualgate.cz'
		OR c.EmailAddress LIKE '%vmivideo.com'
		OR c.EmailAddress LIKE '%voxelvision.com.tw'
		OR c.EmailAddress LIKE '%whitlock.com'
		OR c.EmailAddress LIKE '%wintech-inc.com'
		OR c.EmailAddress LIKE '%wisewaysupply.com'
		OR c.EmailAddress LIKE '%worldofsoundnc.com'
		OR c.EmailAddress LIKE '%csproducts.com'
		OR c.EmailAddress LIKE '%hdvparts.com'
		OR c.EmailAddress LIKE '%gaeltek.com'
		OR c.EmailAddress LIKE '%veytec.com'
		OR c.EmailAddress LIKE '%precisionmultimedia.com'
		OR c.EmailAddress LIKE '%mcwsolutions.net'
		OR c.EmailAddress LIKE '%uniguest.com'
		OR c.EmailAddress LIKE '%tnpbroadcast.co.uk'
		OR c.EmailAddress LIKE '%cyberfish.ch'
		OR c.EmailAddress LIKE '%sonopro.pt'
		OR c.EmailAddress LIKE '%vpintegral.com'
		OR c.EmailAddress LIKE '%tsicolumbus.com'
		OR c.EmailAddress LIKE '%jgcomm.net'
		OR c.EmailAddress LIKE '%88veterans.com'
		OR c.EmailAddress LIKE '%avworx.net'
		OR c.EmailAddress = 'manbina68@gmail.com'
		OR c.EmailAddress = 'digitalintegrationdesign@gmail.com'
		OR c.EmailAddress = 'garonsav@gmail.com'
		OR c.EmailAddress = 'geminiaudio@gmail.com'
		OR c.EmailAddress = 'dyerj205@gmail.com'
		OR c.EmailAddress = 'kw2sales@gmail.com'
		OR c.EmailAddress = 'lisakwood@hotmail.com'
		OR c.EmailAddress = 'jimrob1@hotmail.com')
		OR c.EmailAddress = 'audiochef@aol.com'
		OR c.EmailAddress LIKE '%avims.net'
		OR c.EmailAddress LIKE 'scharfindustries.com'
		OR c.EmailAddress LIKE 'streamlinesystemsltd.com'
		OR c.EmailAddress LIKE 'austinav.com'
		OR c.EmailAddress LIKE 'pro-media.at'
		OR c.EmailAddress LIKE 'threeriversvideo.com'
		OR c.EmailAddress LIKE 'bcpi.com'
		OR c.EmailAddress LIKE 'braca.nl'
		OR c.EmailAddress LIKE 'riole.com.br'
		OR c.EmailAddress LIKE 'acvideosolutions.com'
		OR c.EmailAddress LIKE 'adminmonitor.com'
		OR c.EmailAddress LIKE 'abi-com.com'
		OR c.EmailAddress LIKE 'bizco.com'
		OR c.EmailAddress LIKE 'clnik.com'
		OR c.EmailAddress LIKE 'uldwc.com'
		OR c.EmailAddress LIKE 'xciteav.com'
		OR c.EmailAddress LIKE 'blueorange.com.sg'
		OR c.EmailAddress LIKE 'cubsinc.com'
		OR c.EmailAddress = 'magnoliamusic@bellsouth.net'
		OR c.EmailAddress LIKE 'atea.dk'
		OR c.EmailAddress LIKE 'avsolutionsinc.net'
		OR c.EmailAddress LIKE 'bacomputersolutions.com'
		OR c.EmailAddress LIKE 'allied-audio.com'
		OR c.EmailAddress LIKE 'one-eye.nl'
		OR c.EmailAddress LIKE 'streamspot.com'
		OR c.EmailAddress LIKE 'avrduluth.com'
		OR c.EmailAddress LIKE 'idb.com.vn'
		OR c.EmailAddress LIKE 'telindus.lu'
		OR c.EmailAddress LIKE 'tcicomm.com'
		OR c.EmailAddress LIKE 'customcontrol.mx'
		OR c.EmailAddress LIKE 'dakotech.net'
		OR c.EmailAddress LIKE 'linesbroadcast.nl'
		OR c.EmailAddress LIKE 'avconusa.com'
		OR c.EmailAddress LIKE 'inavate-av.com'
		OR c.EmailAddress LIKE 'orizonAVS.com'
		OR c.EmailAddress LIKE 'koncerted.com'
		OR c.EmailAddress LIKE 'skelectronics.net'
		OR c.EmailAddress LIKE 'audioarte-bg.com'
		OR c.EmailAddress LIKE 'plugged-records.com'
		OR c.EmailAddress = 'rdciepiela@outlook.com')
	AND (od.ProductCode LIKE 'CRS-VIDEO-CONFERENCING-%' 
		OR od.ProductCode LIKE 'CRS-GOOGLE-CHROMEBOX-SYSTEM' 
		OR od.ProductCode LIKE 'HUDDLECAM%'
		OR od.ProductCode LIKE 'PTZOptics%' 
		OR od.ProductCode LIKE 'HUDDLEPOD%'
		OR od.ProductCode LIKE 'PT12X%'
		OR od.ProductCode LIKE 'PT20X%'
		OR od.ProductCode LIKE 'PTVL%'
		OR od.ProductCode LIKE 'PT-BRDCST%'
		OR od.ProductCode LIKE 'HCA12%'
		OR od.ProductCode LIKE 'HCA20%'
		OR od.ProductCode LIKE 'HCM%'
		OR od.ProductCode LIKE 'HC%X%'
		OR od.ProductCode LIKE 'HC-JO%'
		OR od.ProductCode LIKE 'HP-AIR%'
		OR od.ProductCode LIKE 'PT-JO%'
		OR od.ProductCode LIKE 'PT-TEAM%'
		OR od.ProductCode LIKE 'HC-TEAM%'
		OR od.ProductCode LIKE 'PT-CM%')
AND o.OrderDate BETWEEN '1/1/2016 0:00' AND '12/31/2016 23:59'
GROUP BY 
	c.CompanyName
ORDER BY c.CompanyName


JV - Not Hidden Products	
214
SELECT
	p.ProductCode
	, p.ProductName
FROM 
	Products_joined As p
WHERE 
	p.HideProduct IS NULL
GROUP BY
	p.ProductCode
	, p.ProductName
ORDER BY 
	p.ProductCode ASC


KP - Update Sales Rep ID	
198
SELECT
	c.EmailAddress
	, o.SalesRep_CustomerID
FROM Orders AS o 
LEFT JOIN Customers AS c
	ON o.CustomerID = c.CustomerID
WHERE o.SalesRep_CustomerID = 26
AND c.EmailAddress NOT LIKE '%@marketplace.amazon.com'
GROUP BY 
	c.EmailAddress
	, o.SalesRep_CustomerID
ORDER BY c.EmailAddress ASC


LD - CRS Product Quantity by Rep	
200
SELECT
	o.SalesRep_CustomerID
	, COUNT(o.OrderID) AS 'Order Count'
	, SUM(od.Quantity) AS 'Total Items'
FROM Orders AS o
LEFT JOIN Customers AS c 
	ON c.CustomerID = o.CustomerID
LEFT JOIN OrderDetails AS od
	ON o.OrderID = od.OrderID
WHERE c.CustomerID >= 23
AND c.CustomerID <> 24
AND o.Orderstatus <> 'cancelled'
AND o.Orderstatus <> 'returned'
AND od.RMAI_ID is null
AND c.AccessKey <> 'A'
AND c.EmailAddress NOT LIKE '%@marketplace.amazon.com'
AND o.OrderDate BETWEEN '1/1/2014 0:00' AND '12/31/2015 23:59'
AND (od.ProductCode LIKE 'CRS-VIDEO-CONFERENCING-%' 
	OR od.ProductCode LIKE 'CRS-GOOGLE-CHROMEBOX-SYSTEM' 
	OR od.ProductCode LIKE 'HUDDLECAMHD%'
	OR od.ProductCode LIKE 'HUDDLECAMHD-%' 
	OR od.ProductCode LIKE 'PTZOptics%' 
	OR od.ProductCode LIKE 'HUDDLEPOD%'
	OR od.ProductCode LIKE 'PT12X%'
	OR od.ProductCode LIKE 'PT20X%'
	OR od.ProductCode LIKE 'PT-VL%'
	OR od.ProductCode LIKE 'PT-BRDCSTR%'
	OR od.ProductCode LIKE 'HCA12X'
	OR od.ProductCode LIKE 'HCA20X%'
	OR od.ProductCode LIKE 'HCM%'
	OR od.ProductCode LIKE 'HC%X%'
	OR od.ProductCode LIKE 'HC-JOY'
	OR od.ProductCode LIKE 'HP-AIR%')
GROUP BY
	o.SalesRep_CustomerID
ORDER BY o.SalesRep_CustomerID


LD - Dealer Listing	
196
SELECT
	c.CompanyName
	, SUM(od.TotalPrice) AS 'Total Payment Received'
FROM OrderDetails AS od
LEFT JOIN Orders AS o
	ON o.OrderID = od.OrderID
LEFT JOIN Customers AS c 
	ON c.CustomerID = o.CustomerID
WHERE o.Orderstatus <> 'cancelled'
AND o.Orderstatus <> 'returned'
AND c.CustomerID >= 23
AND c.CustomerID <> 24
AND c.CustomerID <> 26
AND c.CustomerID <> 177
AND c.AccessKey <> 'A'
AND (c.EmailAddress = 'geminiaudio@gmail.com'
	OR c.EmailAddress = 'lisakwood@hotmail.com'
	OR c.EmailAddress LIKE '%@shi.com'
	OR c.EmailAddress LIKE '%@3a-techonline.com'
	OR c.EmailAddress LIKE '%@a-v-c.com'
	OR c.EmailAddress LIKE '%@admteknologi.com'
	OR c.EmailAddress LIKE '%@advanced-inc.com'
	OR c.EmailAddress LIKE '%@affinitechinc.com'
	OR c.EmailAddress LIKE '%@agrity.com.my'
	OR c.EmailAddress LIKE '%@alltec.co.il'
	OR c.EmailAddress LIKE '%@batipi.com'
	OR c.EmailAddress LIKE '%@broadcast-tech.com'
	OR c.EmailAddress LIKE '%@ccssouthwest.com '
	OR c.EmailAddress LIKE '%@commav.net'
	OR c.EmailAddress LIKE '%@conferencetech.com'
	OR c.EmailAddress LIKE '%@cp-vision.at'
	OR c.EmailAddress LIKE '%@dg-av.com'
	OR c.EmailAddress LIKE '%@ftx.ee'
	OR c.EmailAddress LIKE '%@getclearav.co.uk'
	OR c.EmailAddress LIKE '%@hefservices.com'
	OR c.EmailAddress LIKE '%@iled.co.za'
	OR c.EmailAddress LIKE '%@ivs-tec.com'
	OR c.EmailAddress LIKE '%@lookeasy.asia'
	OR c.EmailAddress LIKE '%@m3techgroup.com'
	OR c.EmailAddress LIKE '%@natheatrix.com'
	OR c.EmailAddress LIKE '%@networkparamedics.com'
	OR c.EmailAddress LIKE '%@nyherji.is'
	OR c.EmailAddress LIKE '%@opennetworks.com'
	OR c.EmailAddress LIKE '%@opta.kiev.ua'
	OR c.EmailAddress LIKE '%@osmetro.com'
	OR c.EmailAddress LIKE '%@pdlaser.com'
	OR c.EmailAddress LIKE '%@praxis8.com'
	OR c.EmailAddress LIKE '%@provav.com'
	OR c.EmailAddress LIKE '%@shisystems.com'
	OR c.EmailAddress LIKE '%@siscocorp.com'
	OR c.EmailAddress LIKE '%@tech-integ.com'
	OR c.EmailAddress LIKE '%@theavgroup.com'
	OR c.EmailAddress LIKE '%@tsi-global.com '
	OR c.EmailAddress LIKE '%@tymc.co.kr'
	OR c.EmailAddress LIKE '%@hbcommunications.com'
	)
AND (od.ProductCode LIKE 'CRS-VIDEO-CONFERENCING-%' 
	OR od.ProductCode LIKE 'CRS-GOOGLE-CHROMEBOX-SYSTEM' 
	OR od.ProductCode LIKE 'HUDDLECAMHD%'
	OR od.ProductCode LIKE 'HUDDLECAMHD-%' 
	OR od.ProductCode LIKE 'PTZOptics%' 
	OR od.ProductCode LIKE 'HUDDLEPOD%'
	OR od.ProductCode LIKE 'PT12X%'
	OR od.ProductCode LIKE 'PT20X%'
	OR od.ProductCode LIKE 'PT-VL%'
	OR od.ProductCode LIKE 'PT-BRDCSTR%'
	OR od.ProductCode LIKE 'HCA12X'
	OR od.ProductCode LIKE 'HCA20X%'
	OR od.ProductCode LIKE 'HCM%'
	OR od.ProductCode LIKE 'HC%X%'
	OR od.ProductCode LIKE 'HC-JOY'
	OR od.ProductCode LIKE 'HP-AIR%')
AND o.OrderDate BETWEEN '1/1/2016 0:00' AND '12/31/2016 23:59'
GROUP BY 
	c.CompanyName
ORDER BY c.CompanyName


LD - Product Quantity by Rep	
201
SELECT
	o.SalesRep_CustomerID
	, COUNT(o.OrderID) AS 'Order Count'
	, SUM(od.Quantity) AS 'Total Items'
FROM Orders AS o
LEFT JOIN Customers AS c 
	ON c.CustomerID = o.CustomerID
LEFT JOIN OrderDetails AS od
	ON o.OrderID = od.OrderID
WHERE c.CustomerID >= 23
AND c.CustomerID <> 24
AND o.Orderstatus <> 'cancelled'
AND o.Orderstatus <> 'returned'
AND od.RMAI_ID is null
AND c.AccessKey <> 'A'
AND c.EmailAddress NOT LIKE '%@marketplace.amazon.com'
AND o.OrderDate BETWEEN '1/1/2014 0:00' AND '12/31/2015 23:59'
GROUP BY
	o.SalesRep_CustomerID
ORDER BY o.SalesRep_CustomerID


LD - RMAs by Sales Rep	
199
SELECT
	o.SalesRep_CustomerID
	, COUNT(od.RMA_Number) AS 'RMA Count'
	, COUNT(od.RMAI_ID) AS 'RMA Line Items'
	, SUM(rma.RMAI_Quantity) 'RMA Total Quantities'
FROM Orders AS o
LEFT JOIN OrderDetails AS od
	ON o.OrderID = od.OrderID
LEFT JOIN RMA_Items AS rma
	ON od.RMAI_ID = rma.RMAI_ID
GROUP BY
	o.SalesRep_CustomerID


LD - Update Sales Rep ID	
197
SELECT
	c.EmailAddress
	, o.SalesRep_CustomerID
FROM Orders AS o 
LEFT JOIN Customers AS c
	ON o.CustomerID = c.CustomerID
WHERE o.SalesRep_CustomerID = 1
AND c.EmailAddress NOT LIKE '%@marketplace.amazon.com'
GROUP BY 
	c.EmailAddress
	, o.SalesRep_CustomerID
ORDER BY c.EmailAddress ASC


Other - Acctivate Test	
195
SELECT Customers.CustomerID, Customers.AccessKey, Customers.FirstName, Customers.LastName, Customers.CompanyName, Customers.BillingAddress1, Customers.BillingAddress2, Customers.City, Customers.State, Customers.PostalCode, Customers.Country, Customers.PhoneNumber, Customers.FaxNumber, Customers.EmailAddress, Customers.PaysStateTax, Customers.TaxID, Customers.EmailSubscriber, Customers.CatalogSubscriber, Customers.LastModified, Customers.PercentDiscount, Customers.WebsiteAddress, Customers.DiscountLevel, Customers.CustomerType, Customers.LastModBy, Customers.Customer_IsAnonymous, Customers.IsSuperAdmin, Customers.Customer_Notes, Customers.SalesRep_CustomerID, Customers.ID_Customers_Groups FROM Customers


Other - Amazon Orders Fulfilled by CRS (Specify Year)
144
SELECT
	o.OrderID
	, c.CustomerID as 'Volusion ID'
	, c.CompanyName as 'Company Name'
	, c.FirstName as 'First Name'
	, c.LastName as 'Last Name'
	, c.PhoneNumber as 'Phone Number'
	, c.EmailAddress as 'Email'
	, o.Total_Payment_Received as 'Payment Amount Received'
	, o.OrderDate as 'Order Date'
	, o.OrderID_Third_Party as 'Amazon Order ID'
FROM Customers AS c 
LEFT JOIN Orders AS o
	ON c.CustomerID = o.CustomerID
WHERE c.CustomerID >= 23
AND c.CustomerID <> 24
AND o.Orderstatus <> 'cancelled'
AND c.AccessKey <> 'A'
AND c.EmailAddress LIKE '%@marketplace.amazon.com'
AND o.OrderDate LIKE '%2014%'
GROUP BY 
	c.CustomerID
	, o.OrderID
	, c.CompanyName
	, c.FirstName
	, c.LastName
	, c.PhoneNumber
	, c.EmailAddress
	, o.Total_Payment_Received
	, o.OrderDate
	, o.OrderID_Third_Party
ORDER BY o.OrderID ASC


Other - Amazon Reference	
80
SELECT 
	Products_Joined.ProductName, 
	Products_Joined.ProductCode, 
	Products_Joined.Vendor_PartNo, 
	Products_Joined.HideProduct, 
	Products_Joined.StockStatus, 
	Products_Joined.UPC_code,
	Products_Joined.ProductPrice,
	Products_Joined.SalePrice, 
	Products_Joined.Vendor_Price 
FROM Products_Joined as Products_Joined
ORDER BY Products_Joined.ProductName


/*
PK - Pat's Customers	
73
usp_PagedItems 1, 50, '', '', '', 'SELECT o.LastModified, o.LastModBy, o.OrderStatus, o.OrderID, o.OrderDate, o.ShipDate, o.PaymentAmount, o.Total_Payment_Authorized, o.Total_Payment_Received, o.CustomerID, o.Locked, o.Printed, o.CreditCardAuthorizationDate, o.Shipped, o.PaymentDeclined, o.SalesTaxRate1, o.SalesTaxRate2, o.SalesTaxRate3, o.SalesTax1, o.SalesTax2, o.SalesTax3, o.Tax1_Title, o.Tax2_Title, o.Tax3_Title, o.TotalShippingCost, o.BatchNumber, o.Order_Entry_System, o.SalesRep_CustomerID, o.Customer_IPAddress,o.Custom_Field_Terms,o.Custom_Field_Custom2,o.Custom_Field_Custom3,o.Custom_Field_Custom4,o.Custom_Field_Custom5 , (SELECT Customers.EmailAddress FROM Customers WITH (NOLOCK) WHERE Customers.CustomerID = o.CustomerID) As EmailAddress ,o.ShipCompanyName, o.ShipFirstName, o.ShipLastName, o.ShipAddress1, o.ShipAddress2, o.ShipCity, o.ShipState, o.ShipPostalCode, o.ShipCountry, o.ShipPhoneNumber, o.ShipFaxNumber, o.ShipResidential, o.ShippingMethodID ,o.BillingCompanyName, o.BillingFirstName, o.BillingLastName, o.BillingAddress1, o.BillingAddress2, o.BillingCity, o.BillingState, o.BillingPostalCode, o.BillingCountry, o.BillingPhoneNumber, o.BillingFaxNumber , Fraud.Score , (SELECT PaymentMethod FROM PaymentMethods WITH (NOLOCK) WHERE PaymentMethods.PaymentMethodID = o.PaymentMethodID) As PaymentMethod, IsNull(OrderDetails.Quantity,0) as Quantity, IsNull(OrderDetails.QtyOnBackOrder,0) as QtyOnBackOrder, IsNull(OrderDetails.QtyOnHold,0) as QtyOnHold, IsNull(OrderDetails.QtyShipped,0) as QtyShipped, (SELECT TOP 1 Pay_AVS_Response FROM Payment_Log WITH (NOLOCK) WHERE Pay_OrderID = o.OrderID AND IsNull(Deleted,''N'') <> ''Y'' AND (Pay_Result = ''AUTHORIZE'' OR Pay_Result = ''DEBIT'')) AS Payment_Log_AVS_Response, (SELECT TOP 1 Pay_CVV2_Response FROM Payment_Log WITH (NOLOCK) WHERE Pay_OrderID = o.OrderID AND IsNull(Deleted,''N'') <> ''Y'' AND (Pay_Result = ''AUTHORIZE'' OR Pay_Result = ''DEBIT'')) AS Payment_Log_CVV2_Response FROM Orders o WITH (NOLOCK) LEFT OUTER JOIN vMerchant.Fraud WITH (NOLOCK) ON Fraud.OrderID = o.OrderID LEFT JOIN ( SELECT OrderID, Sum(Quantity) As Quantity, Sum(QtyOnBackOrder) As QtyOnBackOrder, Sum(QtyOnHold) As QtyOnHold, Sum(QtyShipped) As QtyShipped FROM OrderDetails WITH (NOLOCK) GROUP BY OrderID ) OrderDetails ON o.OrderID = OrderDetails.OrderID WHERE o.SalesRep_CustomerID = 11 ORDER BY o.OrderID DESC '
*/

QR - Quote Roller Products Update	
150
SELECT
	p.ProductName AS 'Catalog Name'
	, (p.ProductCode + ':' + CHAR(13) + CHAR(10) + p.ProductDescriptionShort) AS Description
	, ISNULL(p.WarehouseCustom, ISNULL(p.SalePrice, ISNULL(p.ProductPrice, 0))) AS Price
	, ISNULL(p.ProductManufacturer, 'Unknown') AS Category
	, ISNULL(p.Vendor_Price, 0) AS Cost
From Products_joined As p
ORDER BY p.ProductName ASC


Report - Search Term Count (Specify Date)	
138
SELECT
	st.SearchTerm
	, COUNT(st.SearchTerm) AS 'SearchTerm_Count'
FROM SearchTerms as st
WHERE
	st.ipaddress <> '173.161.232.*'
	AND st.lastmodified >= '3/27/2015 0:00'
GROUP BY st.SearchTerm


Reports - Click Tracking	
165
SELECT 
	referer
	, count(*) AS 'Number of Hits'
FROM ClickTrack
GROUP BY 
	referer
ORDER BY referer


Reports - Customer Valuation	
171
SELECT 
	c.SalesRep_CustomerID AS 'Sales Rep'
	, c.CompanyName
	, (c.FirstName + ' ' + c.LastName) AS 'Customer Name'
	, c.CustomerID
	, c.EmailAddress
	, SUM(o.Total_Payment_Authorized) AS 'Total Value of Orders'
	, Count(o.OrderID) AS 'Order Quanitity'
	, SUM(o.Total_Payment_Authorized) / Count(o.OrderID) AS 'Average Order Amount'
FROM Orders AS o
LEFT JOIN Customers AS c 
	ON c.CustomerID = o.CustomerID
WHERE c.CustomerID >= 23
	AND c.CustomerID <> 24
	AND c.CustomerID <> 26
	AND c.CustomerID <> 177
	AND o.Orderstatus <> 'cancelled'
	AND c.AccessKey <> 'A'
	AND o.OrderDate BETWEEN '1/1/2014 0:00' AND '6/11/2015 23:59'
	AND o.Orderstatus <> 'Returned'
	AND c.EmailAddress <> 'anonymous_user'
	AND c.SalesRep_CustomerID = '1'
GROUP BY c.CustomerID, c.SalesRep_CustomerID, c.EmailAddress, c.CompanyName, c.FirstName, c.LastName
ORDER BY SUM(o.Total_Payment_Authorized) DESC


Reports - European Sales (Specify Date Range)	
169
SELECT
	o.OrderDate
	, o.OrderID
	, o.CustomerID
	, o.BillingCompanyName
	, od.ProductCode
	, od.ProductName
	, od.Quantity
FROM Orders AS o
LEFT JOIN Customers AS c 
	ON c.CustomerID = o.CustomerID
LEFT JOIN OrderDetails AS od
	ON o.OrderID = od.OrderID
WHERE c.CustomerID >= 23
AND c.CustomerID <> 24
AND c.CustomerID <> 26
AND o.Orderstatus <> 'cancelled'
AND c.AccessKey <> 'A'
AND c.EmailAddress NOT LIKE '%@marketplace.amazon.com'
AND o.OrderDate BETWEEN '1/1/2015 0:00' AND '5/28/2015 23:59'
AND (od.ProductCode = 'CRS-VIDEO-CONFERENCING-1' 
	OR od.ProductCode = 'CRS-VIDEO-CONFERENCING-2' 
	OR od.ProductCode = 'CRS-VIDEO-CONFERENCING-3' 
	OR od.ProductCode = 'CRS-VIDEO-CONFERENCING-4' 
	OR od.ProductCode = 'CRS-GOOGLE-CHROMEBOX-SYSTEM' 
	OR od.ProductCode = 'CRS-LYNC-VIDEO-CONFERENCING-1' 
	OR od.ProductCode = 'CRS-LYNC-VIDEO-CONFERENCING-2' 
	OR od.ProductCode = 'CRS-LYNC-VIDEO-CONFERENCING-3' 
	OR od.ProductCode = 'CRS-LYNC-VIDEO-CONFERENCING-4'
	OR od.ProductCode = 'CRS-LYNC-VIDEO-CONFERENCING-5' 
	OR od.ProductCode = 'CRS-LYNC-VIDEO-CONFERENCING-6' 
	OR od.ProductCode = 'CRS-LYNC-VIDEO-CONFERENCING-7' 
	OR od.ProductCode = 'CRS-LYNC-VIDEO-CONFERENCING-8' 
	OR od.ProductCode = 'CRS-LYNC-VIDEO-CONFERENCING-9' 
	OR od.ProductCode = 'CRS-LYNC-VIDEO-CONFERENCING-10' 
	OR od.ProductCode = 'HUDDLECAMHD-3X' 
	OR od.ProductCode = 'HUDDLECAMHD-3X-WHITE' 
	OR od.ProductCode = 'HUDDLECAMHD-10X-720p' 
	OR od.ProductCode = 'HUDDLECAMHD-10X' 
	OR od.ProductCode = 'HUDDLECAMHD-10X-BLACK' 
	OR od.ProductCode = 'HUDDLECAMHD-10X-WHITE' 
	OR od.ProductCode = 'HUDDLECAMHD-3X-WIDE' 
	OR od.ProductCode = 'HUDDLECAMHD-12X' 
	OR od.ProductCode = 'HUDDLECAMHD-18X' 
	OR od.ProductCode = 'HUDDLECAMHD-20X' 
	OR od.ProductCode = 'HUDDLECAMHD-30X' 
	OR od.ProductCode = 'PTZOptics-12X-IP' 
	OR od.ProductCode = 'PTZOptics-20X-IP' 
	OR od.ProductCode = 'PTZOptics-12X-USB' 
	OR od.ProductCode = 'PTZOptics-20X-USB' 
	OR od.ProductCode = 'HUDDLECAMHD-Air 12x' 
	OR od.ProductCode = 'HUDDLECAMHD-Air 20x' 
	OR od.ProductCode = 'PTZOptics-12X-USB-WHITE' 
	OR od.ProductCode = 'PTZOptics-20X-USB-WHITE' 
	OR od.ProductCode = 'PTZOptics-12X-USB-W' 
	OR od.ProductCode = 'PTZOptics-12X-SDI-W' 
	OR od.ProductCode = 'PTZOptics-20X-USB-W' 
	OR od.ProductCode = 'PTZOptics-20X-SDI-W'
	OR od.ProductCode = 'HUDDLECAMHD-3X-WIDE-G2'
	OR od.ProductCode = 'HUDDLECAMHD-3X-G2'
	OR od.ProductCode = 'HUDDLECAMHD-20X-G2'
	OR od.ProductCode = 'HUDDLECAMHD-10X-G2'
	OR od.ProductCode = 'HUDDLEPOD-AIR')
AND (c.Country = 'Albania' 
	OR c.Country = 'Andorra' 
	OR c.Country = 'Armenia' 
	OR c.Country = 'Austria' 
	OR c.Country = 'Azerbaijan' 
	OR c.Country = 'Belarus' 
	OR c.Country = 'Belgium' 
	OR c.Country = 'Bosnia' 
	OR c.Country = 'Bulgaria' 
	OR c.Country = 'Croatia' 
	OR c.Country = 'Cyprus' 
	OR c.Country = 'Czech Republic' 
	OR c.Country = 'Denmark' 
	OR c.Country = 'Estonia' 
	OR c.Country = 'Finland' 
	OR c.Country = 'France' 
	OR c.Country = 'Georgia' 
	OR c.Country = 'Germany' 
	OR c.Country = 'Greece' 
	OR c.Country = 'Hungary' 
	OR c.Country = 'Iceland' 
	OR c.Country = 'Ireland' 
	OR c.Country = 'Italy' 
	OR c.Country = 'Kazakhstan' 
	OR c.Country = 'Kosovo' 
	OR c.Country = 'Latvia' 
	OR c.Country = 'Liechtenstein' 
	OR c.Country = 'Lithuania' 
	OR c.Country = 'Luxembourg' 
	OR c.Country = 'Macedonia' 
	OR c.Country = 'Malta'
	OR c.Country = 'Moldova' 
	OR c.Country = 'Monaco' 
	OR c.Country = 'Montenegro' 
	OR c.Country = 'Netherlands' 
	OR c.Country = 'Norway' 
	OR c.Country = 'Poland' 
	OR c.Country = 'Portugal' 
	OR c.Country = 'Romania'
	OR c.Country = 'Russia' 
	OR c.Country = 'San Marino' 
	OR c.Country = 'Scotland' 
	OR c.Country = 'Serbia' 
	OR c.Country = 'Slovakia' 
	OR c.Country = 'Slovenia' 
	OR c.Country = 'Spain' 
	OR c.Country = 'Sweden' 
	OR c.Country = 'Switzerland' 
	OR c.Country = 'Turkey' 
	OR c.Country = 'Ukraine'
	OR c.Country = 'United Kingdom' 
	OR c.Country = 'Vatican City State')
GROUP BY
	o.OrderDate
	, o.OrderID
	, o.CustomerID
	, o.BillingCompanyName
	, od.ProductCode
	, od.ProductName
	, od.Quantity
ORDER BY o.OrderDate


Unused - Multiple Products Order Quantities (Specify Date Range and Product Code)	
164
SELECT
	o.OrderDate
	, o.OrderID
	, o.BillingCompanyName
	, od.ProductCode
	, od.ProductName
	, od.Quantity
FROM Orders AS o
LEFT JOIN Customers AS c 
	ON c.CustomerID = o.CustomerID
LEFT JOIN OrderDetails AS od
	ON o.OrderID = od.OrderID
WHERE c.CustomerID >= 23
AND c.CustomerID <> 24
AND o.Orderstatus <> 'cancelled'
AND c.AccessKey <> 'A'
AND c.EmailAddress NOT LIKE '%@marketplace.amazon.com'
AND o.OrderDate BETWEEN '1/1/2015 0:00' AND '5/28/2015 23:59'
AND (od.ProductCode = 'CRS-VIDEO-CONFERENCING-1' OR od.ProductCode = 'CRS-VIDEO-CONFERENCING-2' OR od.ProductCode = 'CRS-VIDEO-CONFERENCING-3' OR od.ProductCode = 'CRS-VIDEO-CONFERENCING-4' OR od.ProductCode = 'CRS-GOOGLE-CHROMEBOX-SYSTEM' OR od.ProductCode = 'CRS-LYNC-VIDEO-CONFERENCING-1' OR od.ProductCode = 'CRS-LYNC-VIDEO-CONFERENCING-2' OR od.ProductCode = 'CRS-LYNC-VIDEO-CONFERENCING-3' OR od.ProductCode = 'CRS-LYNC-VIDEO-CONFERENCING-4')
GROUP BY
	o.OrderDate
	, o.OrderID
	, o.BillingCompanyName
	, od.ProductCode
	, od.ProductName
	, od.Quantity
ORDER BY o.OrderDate


Reports - Payment Totals by Day	
166
SELECT
	DATEADD(dd, 0, DATEDIFF(dd, 0, o.OrderDate)) AS 'Order Date'
	, SUM(o.PaymentAmount) AS 'Total Payments'
FROM Orders AS o
	WHERE o.Orderstatus <> 'cancelled'
	AND o.Orderstatus NOT LIKE '%Returned'
GROUP BY
	DATEADD(dd, 0, DATEDIFF(dd, 0, o.OrderDate))


Reports - Payment Totals by Sales Rep	
167
SELECT 
	o.SalesRep_CustomerID
	, SUM(o.PaymentAmount) AS 'Total Payments'
FROM Orders AS o
LEFT JOIN Customers AS c 
	ON c.CustomerID = o.CustomerID
WHERE c.CustomerID >= 23
	AND c.CustomerID <> 24
	AND c.CustomerID <> 26
	AND c.CustomerID <> 177
	AND o.Orderstatus <> 'cancelled'
	AND o.Orderstatus <> 'Returned'
	AND c.AccessKey <> 'A'
	AND o.OrderDate BETWEEN '1/1/2016 0:00' AND '12/31/2016 23:59'
GROUP BY 
	o.SalesRep_CustomerID
ORDER BY o.SalesRep_CustomerID



Reports - Product Quantity by Rep (Specify Product Code)	
163
SELECT
	o.SalesRep_CustomerID
	, c.EmailAddress
	, o.BillingCompanyName
	, c.FirstName
	, c.LastName
	, o.OrderDate
	, o.OrderID
	, od.Quantity
FROM Orders AS o
LEFT JOIN Customers AS c 
	ON c.CustomerID = o.CustomerID
LEFT JOIN OrderDetails AS od
	ON o.OrderID = od.OrderID
WHERE c.CustomerID >= 23
AND c.CustomerID <> 24
AND o.Orderstatus <> 'cancelled'
AND o.Orderstatus <> 'returned'
AND od.RMAI_ID is null
AND c.AccessKey <> 'A'
AND c.EmailAddress NOT LIKE '%@marketplace.amazon.com'
AND o.OrderDate BETWEEN '1/1/2014 0:00' AND '12/31/2015 23:59'
AND od.ProductCode LIKE 'CRS-VIDEO-CONFERENCING-%'
GROUP BY
	o.SalesRep_CustomerID
	, c.EmailAddress
	, o.BillingCompanyName
	, c.FirstName
	, c.LastName
	, o.OrderDate
	, o.OrderID
	, od.Quantity
ORDER BY o.OrderDate


Reports - Product View Totals	
115
SELECT
	pid.ProductID
	, pid.ProductCode
	, p.ProductName
	, SUM(pvs.HitCount) AS 'HitCount'
FROM Products_UniqueId_Map AS pid 
LEFT JOIN Products_Joined AS p
	ON pid.ProductCode = p.ProductCode
LEFT JOIN ProductViews_Stats_By_Day AS pvs
	ON pid.ProductID = pvs.ProductID
WHERE 
	(pvs.HitCount <> '' OR pvs.HitCount <> '0')
	AND pvs.statdate BETWEEN '1/1/2016 0:00' AND '12/31/2016 23:59'
GROUP BY 
	pid.ProductID
	, pid.ProductCode
	, p.ProductName
ORDER BY pid.ProductID ASC


Reports - Product Views by Day	
114
SELECT
	pid.ProductID
	, pid.ProductCode
	, p.ProductName
	, pvs.StatDate
	, pvs.HitCount
FROM Products_UniqueId_Map AS pid 
LEFT JOIN Products_Joined AS p
	ON pid.ProductCode = p.ProductCode
LEFT JOIN ProductViews_Stats_By_Day AS pvs
	ON pid.ProductID = pvs.ProductID
WHERE pvs.HitCount <> ''
GROUP BY 
	pid.ProductID
	, pid.ProductCode
	, p.ProductName
	, pvs.StatDate
	, pvs.HitCount
ORDER BY pid.ProductID, pvs.StatDate ASC


Reports - Returns (Specify Date Range)	
156
SELECT
	o.OrderID as 'Order ID'
	, o.OrderDate as 'Order Date'
	, o.OrderStatus as 'Order Status'
	, isnull(pl.pay_result,'') AS 'Transaction Type'
	, isnull(pl.pay_amount,'') AS 'TransactionAmount'
	, isnull(pl.pay_authdate,'') AS 'Transaction Date'
	, rma.RMA_Number AS 'RMA #'
FROM Orders as O 
LEFT JOIN Payment_Log as pl
	ON o.OrderID = pl.Pay_OrderId
LEFT JOIN RMAs as rma
	ON o.OrderID = rma.RMA_OrderID
LEFT JOIN Customers as c
	ON c.CustomerID = o.CustomerID
WHERE o.Orderstatus = 'Returned'
OR o.OrderStatus = 'Partially Returned'
AND o.OrderDate BETWEEN '1/1/2014 0:00' AND '12/31/2015 23:59'
AND c.EmailAddress NOT LIKE '%@marketplace.amazon.com'
AND pl.pay_result = 'CREDIT'
GROUP BY 
	o.OrderID
	, o.OrderDate
	, o.OrderStatus
	, pl.pay_result
	, pl.pay_amount
	, pl.pay_authdate
	, rma.RMA_Number
ORDER BY o.OrderID ASC


Reports - Returns and Exchanges	
99
SELECT
	o.OrderID
	, o.OrderStatus
	, o.SalesRep_CustomerID
	, od.OrderDetailID
	, od.ProductCode
	, od.ProductName
	, od.RMA_Number
	, od.RMAI_ID
	, rma.RMAI_RefundType
	, rma.RMAI_Quantity
	, rma.RMAI_QtyReceived_Sellable
	, rma.RMAI_QtyReceived_Damaged
	, rma.RMAI_LostValue 
	, rma.LastModBy
FROM Orders AS o
LEFT JOIN OrderDetails AS od
	ON o.OrderID = od.OrderID
LEFT JOIN RMA_Items AS rma
	ON od.RMAI_ID = rma.RMAI_ID
WHERE
	od.RMAI_ID <> ''
GROUP BY
	o.OrderID
	, o.OrderStatus
	, o.SalesRep_CustomerID
	, od.OrderDetailID
	, od.ProductCode
	, od.ProductName
	, od.RMA_Number
	, od.RMAI_ID
	, rma.RMAI_RefundType
	, rma.RMAI_Quantity
	, rma.RMAI_QtyReceived_Sellable
	, rma.RMAI_QtyReceived_Damaged
	, rma.RMAI_LostValue 
	, rma.LastModBy


Reports - Revenue	
189
SELECT
	o.OrderID
	, SUM(od.TotalPrice) AS 'Total Price'
	, (SUM(ISNULL(rmai.RMAI_LostValue,0)) / Count(od. OrderDetailID)) AS 'Lost Value'
	, (SUM(od.TotalPrice) - (SUM(ISNULL(rmai.RMAI_LostValue,0)) / Count(od.TotalPrice))) AS 'Product Based Revenue'
	, SUM(o.SalesTax1) AS 'Sales Tax'
	, (SUM(od.TotalPrice) - (SUM(ISNULL(rmai.RMAI_LostValue,0)) / Count(od.TotalPrice)) + SUM(o.TotalShippingCost) + SUM(o.SalesTax1)) AS 'Total Revenue'
	, (SUM(od.TotalPrice) - (SUM(ISNULL(rmai.RMAI_LostValue,0)) / Count(od.TotalPrice)) + SUM(o.TotalShippingCost)) AS 'Revenue minus Tax'
FROM Orders AS o
LEFT JOIN RMAs AS rma
	ON o.OrderID = rma.RMA_OrderID
LEFT JOIN RMA_Items AS rmai
	ON rma.RMA_Number = rmai.RMA_Number
LEFT JOIN OrderDetails AS od
	ON o.OrderID = od.OrderID
LEFT JOIN Customers AS c
	ON o.CustomerID = c.CustomerID
WHERE o.Orderstatus <> 'cancelled'
	AND o.OrderDate BETWEEN '1/1/2015 0:00' AND '12/31/2015 23:59'
	AND c.EmailAddress NOT LIKE '%@marketplace.amazon.com'
GROUP BY o.OrderID
ORDER BY o.OrderID


Reports - Specific Product Order Quantities (Specify Date Range and Product Code)	
158
SELECT
	o.OrderDate
	, o.OrderID
	, od.ProductCode
	, od.ProductName
	, od.Quantity
FROM Orders AS o
LEFT JOIN Customers AS c 
	ON c.CustomerID = o.CustomerID
LEFT JOIN OrderDetails AS od
	ON o.OrderID = od.OrderID
WHERE c.CustomerID >= 23
AND c.CustomerID <> 24
AND o.Orderstatus <> 'cancelled'
AND c.AccessKey <> 'A'
AND c.EmailAddress NOT LIKE '%@marketplace.amazon.com'
AND o.OrderDate BETWEEN '1/1/2015 0:00' AND '9/3/2015 23:59'
AND od.ProductCode = '960-000982'


Reports - Total Units Sold and Profit Margin (Specify Date Range)	
168
SELECT 
	od.ProductCode
	, SUM(od.Quantity) AS 'Total Units Sold'
	, SUM(od.TotalPrice) / SUM(od.Quantity) AS 'Average Price'
	, SUM(od.TotalPrice) AS 'Total Payment Received'
	, SUM(ISNULL(od.Vendor_Price, 0) * od.Quantity) AS 'Total Cost'
	, SUM(od.TotalPrice) - SUM(ISNULL(od.Vendor_Price, 0) * od.Quantity) AS 'Total Profit'
	, ((SUM(od.TotalPrice) - SUM(ISNULL(od.Vendor_Price, 0) * od.Quantity)) / SUM(od.TotalPrice)) AS 'Average Margin'
FROM OrderDetails AS od
LEFT JOIN Orders AS o
	ON o.OrderID = od.OrderID
LEFT JOIN Customers AS c 
	ON c.CustomerID = o.CustomerID
WHERE c.CustomerID >= 23
	AND c.CustomerID <> 24
	AND o.Orderstatus <> 'cancelled'
	AND c.AccessKey <> 'A'
	AND o.OrderDate BETWEEN '2/28/2015 0:00' AND '5/28/2015 23:59'
	AND o.Orderstatus NOT LIKE '%Returned'
	AND od.TotalPrice <> 0
GROUP BY 
	od.ProductCode
ORDER BY SUM(od.Quantity) DESC


Reports - Views by Product (Specify Product ID)	
216
SELECT
	pid.ProductID
	, pid.ProductCode
	, p.ProductName
	, SUM(pvs.hitcount) AS 'hitcount'
FROM Products_UniqueId_Map AS pid 
LEFT JOIN Products_Joined AS p
	ON pid.ProductCode = p.ProductCode
LEFT JOIN ProductViews_Stats_By_Day AS pvs
	ON pid.ProductID = pvs.ProductID
WHERE
	p.ProductName LIKE 'Minrray%'
	AND pvs.statdate BETWEEN '1/1/2014 0:00' AND '12/31/2016 23:59'
GROUP BY 
	pid.ProductID
	, pid.ProductCode
	, p.ProductName
ORDER BY 
	pid.ProductID
	, pid.ProductCode
	, p.ProductName
ASC


Reports - Weekly Product Sales (Specify Range)	
149
SELECT
	o.OrderDate
	, o.OrderID
	, o.SalesRep_CustomerID
	, od.ProductCode
	, od.ProductName
	, od.Quantity
	, od.ProductPrice
	, od.TotalPrice
	, ISNULL(rma.RMAI_Quantity,'0') AS 'Quantity Returned'
	, ISNULL((rma.RMAI_Quantity * od.ProductPrice),'0') AS 'Amount Lost'
FROM Orders AS o 
LEFT JOIN OrderDetails AS od
	ON o.OrderID = od.OrderID
LEFT JOIN RMA_Items AS rma
	ON od.RMAI_ID = rma.RMAI_ID
LEFT JOIN Customers AS c
	ON o.CustomerID = c.CustomerID
WHERE o.Orderstatus <> 'cancelled'
AND o.OrderDate BETWEEN '1/1/2016 0:00' AND '5/21/2016 23:59'
AND c.EmailAddress NOT LIKE '%@marketplace.amazon.com'
GROUP BY 
	o.OrderDate
	,o.OrderID
	, o.SalesRep_CustomerID
	, od.ProductCode
	, od.ProductName
	, od.Quantity
	, od.ProductPrice
	, od.TotalPrice
	, rma.RMAI_Quantity
ORDER BY o.OrderDate ASC


Revenue - 1 (Order)	
190
SELECT
	o.OrderID
	, SUM(od.TotalPrice) AS 'Total Price'
	, (SUM(o.SalesTax1) / Count(ISNULL(od.TotalPrice,1))) AS 'Sales Tax'
	, (SUM(o.TotalShippingCost)/Count(ISNULL(od.TotalPrice,1))) AS 'Customer Shipping Cost'
	, (SUM(od.TotalPrice) + (SUM(o.SalesTax1) / Count(ISNULL(od.TotalPrice,1))) + (SUM(o.TotalShippingCost) / Count(ISNULL(od.TotalPrice,1)))) AS 'Total Revenue'
FROM Orders AS o
LEFT JOIN OrderDetails AS od
	ON o.OrderID = od.OrderID
LEFT JOIN Customers AS c
	ON o.CustomerID = c.CustomerID
WHERE o.Orderstatus <> 'cancelled'
	AND o.OrderDate BETWEEN '12/28/2014 0:00' AND '12/26/2015 23:59'
	AND c.EmailAddress NOT LIKE '%@marketplace.amazon.com'
GROUP BY o.OrderID
ORDER BY o.OrderID


Revenue - 2 (Lost Value)	
191
SELECT
	o.OrderID
	, SUM(ISNULL(rmai.RMAI_LostValue,0)) AS 'Lost Value'
FROM Orders AS o
LEFT JOIN RMAs AS rma
	ON o.OrderID = rma.RMA_OrderID
LEFT JOIN RMA_Items AS rmai
	ON rma.RMA_Number = rmai.RMA_Number
LEFT JOIN Customers AS c
	ON o.CustomerID = c.CustomerID
WHERE o.Orderstatus <> 'cancelled'
	AND o.OrderDate BETWEEN '12/28/2014 0:00' AND '12/26/2015 23:59'
	AND c.EmailAddress NOT LIKE '%@marketplace.amazon.com'
GROUP BY o.OrderID
ORDER BY o.OrderID


Revenue - 3 (Shipping)	
192
SELECT
	o.OrderID
	, SUM(ISNULL(tn.Shipment_Cost,0)) AS 'Shipment Cost'
	, (o.TotalShippingCost - SUM(ISNULL(tn.Shipment_Cost,0)))  As 'Shipping Revenue'
FROM Orders AS o
	LEFT JOIN TrackingNumbers AS tn
		ON o.OrderID = tn.OrderID
	LEFT JOIN Customers AS c
		ON o.CustomerID = c.CustomerID
WHERE o.Orderstatus <> 'cancelled'
	AND o.OrderDate BETWEEN '12/28/2014 0:00' AND '12/26/2015 23:59'
	AND c.EmailAddress NOT LIKE '%@marketplace.amazon.com'
GROUP BY o.OrderID
	, o.TotalShippingCost
ORDER BY o.OrderID


SEO - Article Info and URL	
24
SELECT Articles.ID, Articles.PageName, Articles.ArticleTitle, Articles.METATAG_Title, Articles.METATAG_Description, Articles.METATAG_Keywords FROM Articles


SEO - Categories	
121
SELECT Categories.CategoryID, Categories.CategoryName, Categories.METATAG_Title, Categories.METATAG_Description, Categories.Link_Title_Tag, Categories.CategoryDescription, Categories.METATAG_Keywords, Categories.Hidden FROM Categories


SEO - Products	
84
SELECT Products_Joined.ProductCode, Products_Joined.HideProduct, Products_Joined.ProductName, Products_Joined.ProductNameShort, Products_Joined.METATAG_Title, Products_Joined.METATAG_Description, Products_Joined.Photo_AltText, Products_Joined.METATAG_Keywords FROM Products_Joined WITH (NOLOCK) ORDER BY Products_Joined.ProductCode


Support - Customers by Product (Specify Product)	
184
SELECT
	o.OrderDate
	, o.OrderID
	, o.CustomerID
	, c.FirstName
	, c.LastName
	, c.EmailAddress
	, o.BillingCompanyName
	, od.ProductCode
	, od.ProductName
	, od.Quantity
	, c.SalesRep_CustomerID
FROM Orders AS o
LEFT JOIN Customers AS c 
	ON c.CustomerID = o.CustomerID
LEFT JOIN OrderDetails AS od
	ON o.OrderID = od.OrderID
WHERE c.CustomerID >= 23
AND c.CustomerID <> 24
AND c.CustomerID <> 26
AND o.Orderstatus <> 'cancelled'
AND o.Orderstatus <> 'returned'
AND c.AccessKey <> 'A'
AND c.EmailAddress NOT LIKE '%@marketplace.amazon.com'
AND od.ProductCode Like '%pearl%' 
GROUP BY
	o.OrderDate
	, o.OrderID
	, o.CustomerID
	, c.FirstName
	, c.LastName
	, c.EmailAddress
	, o.BillingCompanyName
	, od.ProductCode
	, od.ProductName
	, od.Quantity
	, c.SalesRep_CustomerID
ORDER BY o.OrderDate


Unused - Commissioning Report	
108
SELECT
	c.SalesRep_CustomerID
	, c.CustomerID
	, o.OrderID
	, c.CompanyName
	, c.FirstName
	, c.LastName
	, o.OrderStatus
	, o.PaymentAmount
	, o.Total_Payment_Authorized
	,o.Total_Payment_Received
	, o.Custom_Field_FIRSTORDER
	, o.Custom_Field_Costed
	, o.Custom_Field_Commissioned
FROM Customers AS c 
LEFT JOIN Orders AS o
	ON c.CustomerID = o.CustomerID
WHERE c.CustomerID >= 23
AND c.CustomerID <> 24
AND o.Orderstatus <> 'cancelled'
AND c.AccessKey <> 'A'
AND o.OrderDate BETWEEN '1/1/2014 0:00' AND '12/31/2014 23:59'
GROUP BY 
	c.CustomerID
	, c.SalesRep_CustomerID
	, c.CompanyName
	, c.FirstName
	, c.LastName
	, o.OrderID
	, o.OrderStatus
	, o.PaymentAmount
	, o.Total_Payment_Authorized
	, o.Total_Payment_Received
	, o.Custom_Field_FIRSTORDER
	, o.Custom_Field_Costed
	, o.Custom_Field_Commissioned
ORDER BY c.SalesRep_CustomerID, c.CustomerID, o.OrderID ASC


Unused - Costed and Commissioned	
101
SELECT
	o.OrderID
	, o.Custom_Field_Costed
	, o.Custom_Field_Commissioned
FROM Orders AS o
GROUP BY
	o.OrderID
	, o.Custom_Field_Costed
	, o.Custom_Field_Commissioned
ORDER BY o.OrderID ASC


Unused - Customers with Zero Orders	
186
SELECT 
	c.CustomerID
	, COUNT(o.OrderID) AS 'Order Count'
FROM Customers AS c 
LEFT JOIN Orders AS o
	ON c.CustomerID = o.CustomerID
WHERE c.CustomerID >= 23
	AND c.CustomerID <> 24
	AND c.CustomerID <> 26
	AND c.CustomerID <> 177
	AND c.AccessKey <> 'A'
GROUP BY 
	c.CustomerID
HAVING COUNT(o.OrderID) = '0'
ORDER BY c.CustomerID


Unused - Dealer Listing	
178
SELECT
	c.CompanyName
	, c.DiscountLevel
	, c.SalesRep_CustomerID
	, SUM(od.TotalPrice) AS 'Total Payment Received'
FROM OrderDetails AS od
LEFT JOIN Orders AS o
	ON o.OrderID = od.OrderID
LEFT JOIN Customers AS c 
	ON c.CustomerID = o.CustomerID
WHERE o.Orderstatus <> 'cancelled'
AND o.Orderstatus <> 'returned'
AND c.CustomerID >= 23
AND c.CustomerID <> 24
AND c.CustomerID <> 26
AND c.CustomerID <> 177
AND c.AccessKey <> 'A'
AND (c.EmailAddress = 'garonsav@gmail.com'
	OR c.EmailAddress LIKE '%@shi.com'
	OR c.EmailAddress LIKE '%@sysquo.com'
	OR c.EmailAddress LIKE '%@casaplex.com'
	OR c.EmailAddress LIKE '%@ccssoutheast.com'
	OR c.EmailAddress LIKE '%@iqsystems.com.ec'
	OR c.EmailAddress LIKE '%@triag.us'
	OR c.EmailAddress LIKE '%@adigitalhome.com'
	OR c.EmailAddress LIKE '%@officeplusuae.com'
	OR c.EmailAddress LIKE '%@commlinkav.com'
	OR c.EmailAddress LIKE '%@aselcom.cr'
	OR c.EmailAddress = 'geminiaudio@gmail.com'
	OR c.EmailAddress LIKE '%@crisptelecom.us'
	OR c.EmailAddress LIKE '%@batipi.com'
	OR c.EmailAddress LIKE '%@provav.com'
	OR c.EmailAddress LIKE '%@smartglobal.es'
	OR c.EmailAddress LIKE '%@colortone-av.com'
	OR c.EmailAddress LIKE '%@hefservices.com'
	OR c.EmailAddress LIKE '%@siscocorp.com'
	OR c.EmailAddress LIKE '%@avisystems.com'
	OR c.EmailAddress LIKE '%@visualgate.cz'
	OR c.EmailAddress LIKE '%@whitlock.com'
	OR c.EmailAddress LIKE '%@iled.co.za'
	OR c.EmailAddress LIKE '%@m3techgroup.com'
	OR c.EmailAddress LIKE '%@leehartman.com'
	OR c.EmailAddress LIKE '%@msomcomm.com'
	OR c.EmailAddress LIKE '%@mcacom.com'
	OR c.EmailAddress LIKE '%@multi-systems.com'
	OR c.EmailAddress LIKE '%@caribtechsol.com'
	OR c.EmailAddress LIKE '%@cartersav.com'
	OR c.EmailAddress LIKE '%@atpsystemsav.com'
	OR c.EmailAddress LIKE '%@clarktechnologies.com'
	OR c.EmailAddress LIKE '%@performancecom.net'
	OR c.EmailAddress LIKE '%@perlmutterpurchasing.com'
	OR c.EmailAddress LIKE '%@belectriccorp.com'
	OR c.EmailAddress LIKE '%@amazingtech.solutions'
	OR c.EmailAddress LIKE '%@earthlink.net'
	OR c.EmailAddress LIKE '%@slproductions.us'
	OR c.EmailAddress LIKE '%@csproducts.com'
	OR c.EmailAddress LIKE '%@agrity.com.my'
	OR c.EmailAddress LIKE '%@networkparamedics.com'
	OR c.EmailAddress LIKE '%@natheatrix.com'
	OR c.EmailAddress LIKE '%@slickcybersystems.com'
	OR c.EmailAddress LIKE '%@it1.com'
	OR c.EmailAddress LIKE '%@ivs-tec.com'
	OR c.EmailAddress LIKE '%@elvia.cz'
	OR c.EmailAddress = 'jimrob1@hotmail.com'
	OR c.EmailAddress LIKE '%@chasethebracelet.com'
	OR c.EmailAddress LIKE '%@shisystems.com'
	OR c.EmailAddress LIKE '%@theavgroup.com'
	OR c.EmailAddress LIKE '%@hitechavs.com'
	OR c.EmailAddress LIKE '%@gofacing.com'
	OR c.EmailAddress LIKE '%@TCCOhio.com'
	OR c.EmailAddress = 'digitalintegrationdesign@gmail.com'
	OR c.EmailAddress LIKE '%@sys-dsn.com'
	OR c.EmailAddress LIKE '%@leehartman.com'
	OR c.EmailAddress LIKE '%@resolution-av.co.nz'
	OR c.EmailAddress LIKE '%@streamportmedia.com'
	OR c.EmailAddress LIKE '%@ftx.ee'
	OR c.EmailAddress LIKE '%@syncomation.com'
	OR c.EmailAddress LIKE '%@featherstonmedia.com'
	OR c.EmailAddress LIKE '%@tirusvoice.com'
	OR c.EmailAddress LIKE '%@medvisionusa.com'
	OR c.EmailAddress LIKE '%@tbaytel.ne'
	OR c.EmailAddress LIKE '%@ccssouthwest.com'
	OR c.EmailAddress LIKE '%@advanced-inc.com'
	OR c.EmailAddress LIKE '%@gomediatech.com'
	OR c.EmailAddress LIKE '%@cp-vision.at'
	OR c.EmailAddress LIKE '%@opennetworks.com'
	OR c.EmailAddress LIKE '%@getclearav.co.uk'
	OR c.EmailAddress LIKE '%@azure-ds.com'
	OR c.EmailAddress = 'manbina68@gmail.com'
	OR c.EmailAddress LIKE '%@videolink.ca'
	OR c.EmailAddress LIKE '%@worldofsoundnc.com'
	OR c.EmailAddress LIKE '%@perftechman.com'
	OR c.EmailAddress LIKE '%@ezpyramid.com'
	OR c.EmailAddress LIKE '%@amelation.com'
	OR c.EmailAddress LIKE '%@tsi-global.com'
	OR c.EmailAddress LIKE '%@affinitechinc.com'
	OR c.EmailAddress LIKE '%@commav.net'
	OR c.EmailAddress LIKE '%@tvg.mx'
	OR c.EmailAddress LIKE '%@sysquo.com'
	OR c.EmailAddress LIKE '%@hbcommunications.com'
	OR c.EmailAddress LIKE '%@bluewatertech.com'
	OR c.EmailAddress = 'irelandss@verizon.net'
	OR c.EmailAddress LIKE '%@madisontech.com.au'
	OR c.EmailAddress LIKE '%@audiovideopr.com'
	OR c.EmailAddress LIKE '%@intuitivecomminc.com'
	OR c.EmailAddress LIKE '%@highbitsav.com'
	OR c.EmailAddress LIKE '%@earthlink.net'
	OR c.EmailAddress LIKE '%@prosound.net'
	OR c.EmailAddress LIKE '%@intercadsys.com'
	OR c.EmailAddress LIKE '%@telesmart.co.nz'
	OR c.EmailAddress LIKE '%@wintech-inc.com'
	OR c.EmailAddress LIKE '%@mysherpa.com'
	OR c.EmailAddress LIKE '%@midtownvideo.com'
	OR c.EmailAddress LIKE '%@adslv.com'
	OR c.EmailAddress LIKE '%@camperio.net'
	OR c.EmailAddress LIKE '%@rbccable.com'
	OR c.EmailAddress LIKE '%@innotouch.net'
	OR c.EmailAddress LIKE '%@meineketv.com')
AND (od.ProductCode LIKE 'CRS-VIDEO-CONFERENCING-%' 
	OR od.ProductCode LIKE 'CRS-GOOGLE-CHROMEBOX-SYSTEM' 
	OR od.ProductCode LIKE 'HUDDLECAMHD%' 
	OR od.ProductCode LIKE 'PTZOptics%' 
	OR od.ProductCode LIKE 'HUDDLEPOD%'
	OR od.ProductCode LIKE 'CRS-LB%')
GROUP BY 
	c.CompanyName
	, c.DiscountLevel
	, c.SalesRep_CustomerID
ORDER BY c.CompanyName


Unused - Dealer Listing - Editing	
177
SELECT
	c.CustomerID
	, c.AccessKey
	, c.FirstName
	, c.LastName
	, c.CompanyName
	, c.Country
	, c.EmailAddress
	, c.DiscountLevel
	, c.ID_Customers_Groups
	, c.SalesRep_CustomerID
	, SUM(od.TotalPrice) AS 'Total Payment Received'
FROM OrderDetails AS od
LEFT JOIN Orders AS o
	ON o.OrderID = od.OrderID
LEFT JOIN Customers AS c 
	ON c.CustomerID = o.CustomerID
WHERE o.Orderstatus <> 'cancelled'
AND o.Orderstatus <> 'returned'
AND c.CustomerID >= 23
AND c.CustomerID <> 24
AND c.CustomerID <> 26
AND c.CustomerID <> 177
AND c.AccessKey <> 'A'
AND (c.EmailAddress = 'garonsav@gmail.com'
	OR c.EmailAddress LIKE '%@shi.com'
	OR c.EmailAddress LIKE '%@sysquo.com'
	OR c.EmailAddress LIKE '%@casaplex.com'
	OR c.EmailAddress LIKE '%@ccssoutheast.com'
	OR c.EmailAddress LIKE '%@iqsystems.com.ec'
	OR c.EmailAddress LIKE '%@triag.us'
	OR c.EmailAddress LIKE '%@adigitalhome.com'
	OR c.EmailAddress LIKE '%@officeplusuae.com'
	OR c.EmailAddress LIKE '%@commlinkav.com'
	OR c.EmailAddress LIKE '%@aselcom.cr'
	OR c.EmailAddress = 'geminiaudio@gmail.com'
	OR c.EmailAddress LIKE '%@crisptelecom.us'
	OR c.EmailAddress LIKE '%@batipi.com'
	OR c.EmailAddress LIKE '%@provav.com'
	OR c.EmailAddress LIKE '%@smartglobal.es'
	OR c.EmailAddress LIKE '%@colortone-av.com'
	OR c.EmailAddress LIKE '%@hefservices.com'
	OR c.EmailAddress LIKE '%@siscocorp.com'
	OR c.EmailAddress LIKE '%@avisystems.com'
	OR c.EmailAddress LIKE '%@visualgate.cz'
	OR c.EmailAddress LIKE '%@whitlock.com'
	OR c.EmailAddress LIKE '%@iled.co.za'
	OR c.EmailAddress LIKE '%@m3techgroup.com'
	OR c.EmailAddress LIKE '%@leehartman.com'
	OR c.EmailAddress LIKE '%@msomcomm.com'
	OR c.EmailAddress LIKE '%@mcacom.com'
	OR c.EmailAddress LIKE '%@multi-systems.com'
	OR c.EmailAddress LIKE '%@caribtechsol.com'
	OR c.EmailAddress LIKE '%@cartersav.com'
	OR c.EmailAddress LIKE '%@atpsystemsav.com'
	OR c.EmailAddress LIKE '%@clarktechnologies.com'
	OR c.EmailAddress LIKE '%@performancecom.net'
	OR c.EmailAddress LIKE '%@perlmutterpurchasing.com'
	OR c.EmailAddress LIKE '%@belectriccorp.com'
	OR c.EmailAddress LIKE '%@amazingtech.solutions'
	OR c.EmailAddress LIKE '%@earthlink.net'
	OR c.EmailAddress LIKE '%@slproductions.us'
	OR c.EmailAddress LIKE '%@csproducts.com'
	OR c.EmailAddress LIKE '%@agrity.com.my'
	OR c.EmailAddress LIKE '%@networkparamedics.com'
	OR c.EmailAddress LIKE '%@natheatrix.com'
	OR c.EmailAddress LIKE '%@slickcybersystems.com'
	OR c.EmailAddress LIKE '%@it1.com'
	OR c.EmailAddress LIKE '%@ivs-tec.com'
	OR c.EmailAddress LIKE '%@elvia.cz'
	OR c.EmailAddress = 'jimrob1@hotmail.com'
	OR c.EmailAddress LIKE '%@chasethebracelet.com'
	OR c.EmailAddress LIKE '%@shisystems.com'
	OR c.EmailAddress LIKE '%@theavgroup.com'
	OR c.EmailAddress LIKE '%@hitechavs.com'
	OR c.EmailAddress LIKE '%@gofacing.com'
	OR c.EmailAddress LIKE '%@TCCOhio.com'
	OR c.EmailAddress = 'digitalintegrationdesign@gmail.com'
	OR c.EmailAddress LIKE '%@sys-dsn.com'
	OR c.EmailAddress LIKE '%@leehartman.com'
	OR c.EmailAddress LIKE '%@resolution-av.co.nz'
	OR c.EmailAddress LIKE '%@streamportmedia.com'
	OR c.EmailAddress LIKE '%@ftx.ee'
	OR c.EmailAddress LIKE '%@syncomation.com'
	OR c.EmailAddress LIKE '%@featherstonmedia.com'
	OR c.EmailAddress LIKE '%@tirusvoice.com'
	OR c.EmailAddress LIKE '%@medvisionusa.com'
	OR c.EmailAddress LIKE '%@tbaytel.ne'
	OR c.EmailAddress LIKE '%@ccssouthwest.com'
	OR c.EmailAddress LIKE '%@advanced-inc.com'
	OR c.EmailAddress LIKE '%@gomediatech.com'
	OR c.EmailAddress LIKE '%@cp-vision.at'
	OR c.EmailAddress LIKE '%@opennetworks.com'
	OR c.EmailAddress LIKE '%@getclearav.co.uk'
	OR c.EmailAddress LIKE '%@azure-ds.com'
	OR c.EmailAddress = 'manbina68@gmail.com'
	OR c.EmailAddress LIKE '%@videolink.ca'
	OR c.EmailAddress LIKE '%@worldofsoundnc.com'
	OR c.EmailAddress LIKE '%@perftechman.com'
	OR c.EmailAddress LIKE '%@ezpyramid.com'
	OR c.EmailAddress LIKE '%@amelation.com'
	OR c.EmailAddress LIKE '%@tsi-global.com'
	OR c.EmailAddress LIKE '%@affinitechinc.com'
	OR c.EmailAddress LIKE '%@commav.net'
	OR c.EmailAddress LIKE '%@tvg.mx'
	OR c.EmailAddress LIKE '%@sysquo.com'
	OR c.EmailAddress LIKE '%@hbcommunications.com'
	OR c.EmailAddress LIKE '%@bluewatertech.com'
	OR c.EmailAddress = 'irelandss@verizon.net'
	OR c.EmailAddress LIKE '%@madisontech.com.au'
	OR c.EmailAddress LIKE '%@audiovideopr.com'
	OR c.EmailAddress LIKE '%@intuitivecomminc.com'
	OR c.EmailAddress LIKE '%@highbitsav.com'
	OR c.EmailAddress LIKE '%@earthlink.net'
	OR c.EmailAddress LIKE '%@prosound.net'
	OR c.EmailAddress LIKE '%@intercadsys.com'
	OR c.EmailAddress LIKE '%@telesmart.co.nz'
	OR c.EmailAddress LIKE '%@wintech-inc.com'
	OR c.EmailAddress LIKE '%@mysherpa.com'
	OR c.EmailAddress LIKE '%@midtownvideo.com'
	OR c.EmailAddress LIKE '%@adslv.com'
	OR c.EmailAddress LIKE '%@camperio.net'
	OR c.EmailAddress LIKE '%@rbccable.com'
	OR c.EmailAddress LIKE '%@innotouch.net'
	OR c.EmailAddress LIKE '%@meineketv.com')
AND (od.ProductCode LIKE 'CRS-VIDEO-CONFERENCING-%' 
	OR od.ProductCode LIKE 'CRS-GOOGLE-CHROMEBOX-SYSTEM' 
	OR od.ProductCode LIKE 'HUDDLECAMHD%' 
	OR od.ProductCode LIKE 'PTZOptics%' 
	OR od.ProductCode LIKE 'HUDDLEPOD%'
	OR od.ProductCode LIKE 'CRS-LB%')
GROUP BY 
	c.CustomerID
	, c.AccessKey
	, c.FirstName
	, c.LastName
	, c.CompanyName
	, c.Country
	, c.EmailAddress
	, c.DiscountLevel
	, c.ID_Customers_Groups
	, c.SalesRep_CustomerID
ORDER BY c.CompanyName


Unused - Google AdWords Prioritizing	
154
SELECT Products_Joined.ProductCode, Products_Joined.ProductName, Products_Joined.WarehouseCustom, Products_Joined.Google_Product_Category FROM Products_Joined WITH (NOLOCK) ORDER BY Products_Joined.ProductCode


Unused - Orders Export	
142
usp_PagedItems 1, 50, '', '', '', 'SELECT o.LastModified, o.LastModBy, o.OrderStatus, o.OrderID, o.OrderDate, o.ShipDate, o.PaymentAmount, o.Total_Payment_Authorized, o.Total_Payment_Received, o.CustomerID, o.Locked, o.Printed, o.CreditCardAuthorizationDate, o.Shipped, o.PaymentDeclined, o.SalesTaxRate1, o.SalesTaxRate2, o.SalesTaxRate3, o.SalesTax1, o.SalesTax2, o.SalesTax3, o.Tax1_Title, o.Tax2_Title, o.Tax3_Title, o.TotalShippingCost, o.BatchNumber, o.Order_Entry_System, o.SalesRep_CustomerID, o.Customer_IPAddress,o.Custom_Field_FIRSTORDER,o.Custom_Field_Terms,o.Custom_Field_Costed,o.Custom_Field_Commissioned,o.Custom_Field_Custom5 , (SELECT Customers.EmailAddress FROM Customers WITH (NOLOCK) WHERE Customers.CustomerID = o.CustomerID) As EmailAddress ,o.ShipCompanyName, o.ShipFirstName, o.ShipLastName, o.ShipAddress1, o.ShipAddress2, o.ShipCity, o.ShipState, o.ShipPostalCode, o.ShipCountry, o.ShipPhoneNumber, o.ShipFaxNumber, o.ShipResidential, o.ShippingMethodID ,o.BillingCompanyName, o.BillingFirstName, o.BillingLastName, o.BillingAddress1, o.BillingAddress2, o.BillingCity, o.BillingState, o.BillingPostalCode, o.BillingCountry, o.BillingPhoneNumber, o.BillingFaxNumber , Fraud.Score , (SELECT PaymentMethod FROM PaymentMethods WITH (NOLOCK) WHERE PaymentMethods.PaymentMethodID = o.PaymentMethodID) As PaymentMethod, IsNull(OrderDetails.Quantity,0) as Quantity, IsNull(OrderDetails.QtyOnBackOrder,0) as QtyOnBackOrder, IsNull(OrderDetails.QtyOnHold,0) as QtyOnHold, IsNull(OrderDetails.QtyShipped,0) as QtyShipped, (SELECT TOP 1 Pay_AVS_Response FROM Payment_Log WITH (NOLOCK) WHERE Pay_OrderID = o.OrderID AND IsNull(Deleted,''N'') <> ''Y'' AND (Pay_Result = ''AUTHORIZE'' OR Pay_Result = ''DEBIT'')) AS Payment_Log_AVS_Response, (SELECT TOP 1 Pay_CVV2_Response FROM Payment_Log WITH (NOLOCK) WHERE Pay_OrderID = o.OrderID AND IsNull(Deleted,''N'') <> ''Y'' AND (Pay_Result = ''AUTHORIZE'' OR Pay_Result = ''DEBIT'')) AS Payment_Log_CVV2_Response FROM Orders o WITH (NOLOCK) LEFT OUTER JOIN vMerchant.Fraud WITH (NOLOCK) ON Fraud.OrderID = o.OrderID LEFT JOIN ( SELECT OrderID, Sum(Quantity) As Quantity, Sum(QtyOnBackOrder) As QtyOnBackOrder, Sum(QtyOnHold) As QtyOnHold, Sum(QtyShipped) As QtyShipped FROM OrderDetails WITH (NOLOCK) GROUP BY OrderID ) OrderDetails ON o.OrderID = OrderDetails.OrderID WHERE 1=1 ORDER BY o.OrderID DESC '


Unused - Steph Rep ID Correction	
140
SELECT
	c.SalesRep_CustomerID
	, c.CustomerID
	, c.FirstName
	, c.LastName
	, c.CompanyName
	, c.EmailAddress
FROM Customers as c
WHERE c.CustomerID >= 23
AND c.CustomerID <> 24
AND c.SalesRep_CustomerID = 10
GROUP BY
	c.CustomerID
	, c.FirstName
	, c.LastName
	, c.CompanyName
	, c.EmailAddress
	, c.SalesRep_CustomerID
ORDER BY c.SalesRep_CustomerID, c.CustomerID ASC


Unused - Total Order Values	
116
SELECT
	od.ProductCode
	, p.ProductName
	, SUM(od.Quantity) AS 'Total Quantity'
	, SUM(od.TotalPrice) AS 'Total Price'
	, SUM(od.Vendor_Price*od.Quantity) AS 'Total Cost'
FROM OrderDetails AS od
LEFT JOIN Orders AS o
	ON o.OrderID = od.OrderID
LEFT JOIN Products_Joined AS p
	ON p.ProductCode = od.ProductCode
WHERE o.CustomerID >= 23
AND o.CustomerID <> 24
AND o.Orderstatus <> 'cancelled'
GROUP BY
	od.ProductCode
	, p.ProductName
ORDER BY p.ProductName ASC


Unused - Total Payment Received	
143
SELECT
	c.CustomerID as 'Volusion ID'
	, c.EmailAddress as 'Email'
	, COUNT(o.OrderID) as 'Order Count'
	, SUM(o.Total_Payment_Received) as 'Total Payment Received'
FROM Customers AS c 
LEFT JOIN Orders AS o
	ON c.CustomerID = o.CustomerID
WHERE c.CustomerID >= 23
AND c.CustomerID <> 24
AND o.Orderstatus <> 'cancelled'
AND c.AccessKey <> 'A'
GROUP BY 
	c.CustomerID
	, c.EmailAddress
ORDER BY c.CustomerID ASC


Unused - UPS WorldShip
118
SELECT
LEFT(CONVERT(VARCHAR(10), Sum(OrderDetails.ProductWeight*OrderDetails.Quantity)), 4) As TotalOrderWeight 
, Max(Orders.OrderID) As OrderID 
, Max(Orders.OrderDate) As OrderDate 
, Max(Orders.PaymentAmount) As PaymentAmount 
, LEFT(Max(Orders.ShipFirstName + ' ' + Orders.ShipLastName), 35) As ShipFullName 
, LEFT(Max(Customers.EmailAddress), 50) As EmailAddress 
, Max(Orders.ShipCompanyName) As ShipCompanyName 
, LEFT(Max(Orders.ShipAddress1), 35) As ShipAddress1 
, LEFT(Max(Orders.ShipAddress2), 35) As ShipAddress2 
, LEFT(Max(Orders.ShipCity), 30) As ShipCity 
, LEFT(Max(Orders.ShipState), 5) As ShipState 
, LEFT(Max(Orders.ShipPostalCode), 9) As ShipPostalCode 
, LEFT(Max(Orders.ShipCountry), 3) As ShipCountry 
, LEFT(Max(Orders.ShipPhoneNumber), 15) As ShipPhoneNumber 
, LEFT(Max(Orders.ShipFaxNumber), 15) As ShipFaxNumber 
, Max(Orders.CustomerID) As CustomerID --k
, Max(Orders.TotalShippingCost) As TotalShippingCost 
, ShippingMethodName = CASE Max(ShippingMethods.ServiceCode) 
WHEN '11' THEN 'Standard' 
WHEN '03' THEN 'Ground' 
WHEN '12' THEN '3-Day Select' 
WHEN '02' THEN '2nd Day Air' 
WHEN '59' THEN '2nd Day Air AM' 
WHEN '13' THEN 'Next Day Air Saver' 
WHEN '01' THEN 'Next Day Air' 
WHEN '14' THEN 'Next Day Air Early AM' 
WHEN '07' THEN 'Worldwide Express' 
WHEN '54' THEN 'Worldwide Express Plus' 
WHEN '08' THEN 'Worldwide Expedited' 
WHEN '65' THEN 'Express Saver' 
ELSE Max(ShippingMethods.ShippingMethodName) 
END 
, Max(ISNULL(Orders.ShipResidential, 'N')) As Residential 
, 'Prepaid' AS BillingOption 
, 'Package' AS PackageType 
, 'Y' AS ShipNotification 
, 'Email' AS NotificationType 

FROM OrderDetails 
INNER JOIN Orders 
	ON OrderDetails.OrderID = Orders.OrderID 
INNER JOIN Customers 
	ON Orders.CustomerID = Customers.CustomerID 
LEFT OUTER JOIN ShippingMethods 
	ON Orders.ShippingMethodID = ShippingMethods.ShippingMethodID 
WHERE OrderStatus = 'Ready to Ship' 
AND ShippingMethods.Gateway = 'UPS' 
GROUP BY Orders.OrderID;	


Unusued - Defective Siig Cables	
180
SELECT
	o.OrderDate
	, o.OrderID
	, o.BillingCompanyName
	, od.ProductCode
	, od.ProductName
	, od.Quantity
	, o.SalesRep_CustomerID
FROM Orders AS o
LEFT JOIN Customers AS c 
	ON c.CustomerID = o.CustomerID
LEFT JOIN OrderDetails AS od
	ON o.OrderID = od.OrderID
WHERE c.CustomerID >= 23
AND c.CustomerID <> 24
AND o.Orderstatus <> 'cancelled'
AND c.AccessKey <> 'A'
AND o.OrderDate BETWEEN '8/16/2015 0:00' AND '10/16/2015 23:59'
AND (od.ProductCode = 'GV2622' OR od.ProductCode = 'GV2623' OR od.ProductCode = 'GV2626' OR od.ProductCode = 'GV2627' OR od.ProductCode = 'GV2628')
GROUP BY
	o.OrderDate
	, o.OrderID
	, o.BillingCompanyName
	, od.ProductCode
	, od.ProductName
	, od.Quantity
	, o.SalesRep_CustomerID
ORDER BY o.OrderDate ASC


LD - Customer Remarketing Valuation
217
SELECT
	c.CustomerID
	, c.SalesRep_CustomerID
	, (c.FirstName + ' ' + c.LastName) AS 'Customer Name'
	, c.EmailAddress
	, c.CompanyName
	, COUNT(o.OrderID) AS 'Order Count'
	, SUM(o.PaymentAmount) AS 'Total Payment Amount'
	, COUNT(DISTINCT o.OrderDate) AS 'Order Count by Date'
	, SUM(o.PaymentAmount)/COUNT(o.OrderID) AS 'Average Payment Amount'
	, DATEDIFF(d,MIN(o.OrderDate),MAX(o.OrderDate)) AS 'Days as a Customer'
	, DATEDIFF(d,MIN(o.OrderDate),MAX(o.OrderDate))/COUNT(DISTINCT o.OrderDate) AS 'Average Days between Orders'
	, DATEDIFF(d,MAX(o.OrderDate),GETDATE()) AS 'Days since Last Order'
	, DATEDIFF(d,DATEDIFF(d,MIN(o.OrderDate),MAX(o.OrderDate))/COUNT(DISTINCT o.OrderDate),DATEDIFF(d,MAX(o.OrderDate),GETDATE())) AS 'Days Overdue based on Average'
FROM Customers AS c 
LEFT JOIN Orders AS o
	ON c.CustomerID = o.CustomerID
WHERE
	o.Orderstatus <> 'cancelled'
	AND c.AccessKey <> 'A'
	AND c.EmailAddress NOT LIKE '%@marketplace.amazon.com'
	AND (c.Country <> '' OR c.Country IS NOT NULL)
	AND c.CustomerID <> '459'
GROUP BY
	c.CustomerID
	, c.SalesRep_CustomerID
	, (c.FirstName + ' ' + c.LastName)
	, c.EmailAddress
	, c.CompanyName
HAVING 
	COUNT(o.OrderID) >= '3'
	AND SUM(o.PaymentAmount) >= '3000'
	AND DATEDIFF(d,MIN(o.OrderDate),MAX(o.OrderDate)) <> '0'
	AND DATEDIFF(d,MIN(o.OrderDate),GETDATE()) > '60' 
	AND DATEDIFF(d,DATEDIFF(d,MIN(o.OrderDate),MAX(o.OrderDate))/COUNT(DISTINCT o.OrderDate),DATEDIFF(d,MAX(o.OrderDate),GETDATE())) >= '0'
ORDER BY
	c.CustomerID
ASC


Reports - B-Stock Sales by Order
218
SELECT
	o.OrderDate
	, o.OrderID
	, c.CustomerID
	, c.SalesRep_CustomerID
	, o.BillingCompanyName
	, od.ProductCode
	, od.ProductName
	, od.Quantity
FROM Orders AS o
LEFT JOIN OrderDetails AS od
	ON o.OrderID = od.OrderID
LEFT JOIN Customers AS c 
	ON c.CustomerID = o.CustomerID
WHERE o.Orderstatus <> 'cancelled'
	AND c.AccessKey <> 'A'
	AND c.EmailAddress NOT LIKE '%@marketplace.amazon.com'
	AND (c.Country <> '' OR c.Country IS NOT NULL)
	AND c.CustomerID <> '459'
	AND o.OrderDate BETWEEN '1/1/2015 0:00' AND '12/31/2016 23:59'
	AND (od.ProductCode LIKE '%b-stock%' 
		OR od.ProductCode LIKE 'b-stock%' 
		OR od.ProductCode LIKE '%b-stock' 
		OR od.ProductCode LIKE '%bstock%' 
		OR od.ProductName LIKE '%b-stock%' 
		OR od.ProductName LIKE 'b-stock%' 
		OR od.ProductName LIKE '%b-stock' 
		OR od.ProductName LIKE '%bstock%')
GROUP BY
	o.OrderDate
	, o.OrderID
	, c.CustomerID
	, c.SalesRep_CustomerID
	, o.BillingCompanyName
	, od.ProductCode
	, od.ProductName
	, od.Quantity
ORDER BY o.OrderDate ASC


Reports - Multiple Products Order Quantities (Specify Date Range and Product Code)
219
SELECT
	od.ProductCode
	, o.OrderDate
	, o.OrderID
	, od.ProductName
	, od.Quantity
FROM Orders AS o
LEFT JOIN Customers AS c 
	ON c.CustomerID = o.CustomerID
LEFT JOIN OrderDetails AS od
	ON o.OrderID = od.OrderID
WHERE c.CustomerID >= 23
AND c.CustomerID <> 24
AND o.Orderstatus <> 'cancelled'
AND o.Orderstatus <> 'returned'
AND c.AccessKey <> 'A'
AND c.EmailAddress NOT LIKE '%@marketplace.amazon.com'
AND o.OrderDate BETWEEN '1/1/2016 0:00' AND '12/31/2016 23:59'
AND (od.ProductCode = 'TWP-1000' OR 
	 od.ProductCode = 'WIPG2000S' OR
	 od.ProductCode = 'AM-100')
ORDER BY od.ProductCode ASC


LD - PA Sales Tax Report
224
SELECT
	pl.pay_authdate AS 'Date'
	, o.OrderID
	, c.CompanyName AS 'Company'
	, o.ShipCity AS 'City'
	, o.ShipPostalCode AS 'Zip'
	, (c.FirstName + ' ' + c.LastName) AS 'Customer Name'
	, c.CustomerID
	, o.SalesRep_CustomerID AS 'Sales Rep'
	, Round((pl.pay_amount / (1 + (isnull(o.SalesTaxRate1,0) + isnull(o.SalesTaxRate2,0) + isnull(o.SalesTaxRate3,0)))),2) AS 'Subtotal'
	, (isnull(o.SalesTaxRate1,0) + isnull(o.SalesTaxRate2,0) + isnull(o.SalesTaxRate3,0)) AS 'Sales Tax Rate'
	, Round((pl.pay_amount / (1 + (isnull(o.SalesTaxRate1,0) + isnull(o.SalesTaxRate2,0) + isnull(o.SalesTaxRate3,0))) * (isnull(o.SalesTaxRate1,0) + isnull(o.SalesTaxRate2,0) + isnull(o.SalesTaxRate3,0))),2) AS 'Sales Tax'
FROM Orders AS o
LEFT JOIN Customers AS c 
	ON c.CustomerID = o.CustomerID
LEFT JOIN Payment_Log AS pl 
	ON o.OrderID = pl.pay_orderid
WHERE pl.pay_paymentmethodid >= 5
	AND pl.pay_paymentmethodid <=8
	AND o.ShipState = 'PA'
	AND o.Orderstatus <> 'cancelled'
	AND pl.pay_authdate BETWEEN '5/1/2016 0:00' AND '5/30/2016 23:59'
	AND (pl.pay_result = 'DEBIT' OR pl.pay_result = 'CAPTURE')
GROUP BY pl.pay_authdate, o.OrderID, c.CompanyName, o.ShipCity, o.ShipPostalCode, c.CustomerID, o.SalesRep_CustomerID, pl.pay_amount, (c.FirstName + ' ' + c.LastName), (isnull(o.SalesTaxRate1,0) + isnull(o.SalesTaxRate2,0) + isnull(o.SalesTaxRate3,0))
ORDER BY pl.pay_authdate ASC


QR - Quote Roller Products Update with Availability
225
SELECT
	ISNULL(p.ProductManufacturer, 'Unknown') As 'Category Name'
	, p.ProductName AS 'Catalog Name'
	, p.ProductCode + ':' + CHAR(13) + CHAR(10) + ISNULL(p.ProductDescriptionShort,p.ProductName) + ISNULL(CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + 'Estimated Availability' + SPACE(1) + '(' + CONVERT(VARCHAR(10),GETDATE(),110) + ')' + ':' + SPACE(1) + ISNULL(p.Availability,'Not applicable'),SPACE(1)) AS Description
	, ISNULL(p.WarehouseCustom, ISNULL(p.SalePrice, ISNULL(p.ProductPrice, 0))) AS Price
	, ISNULL(p.Vendor_Price, 0) AS Cost
FROM Products_joined As p
LEFT JOIN vmerchant.products_joined pp ON p.ischildofproductcode = pp.productcode
	WHERE p.Availability <> 'Discontinued' 
		AND pp.productid IS NULL
ORDER BY p.ProductName DESC

Edits - Product Description Short (Remove HTML)
226
SELECT
	p.ProductCode
	, p.ProductName
	, p.ProductDescriptionShort
FROM Products_joined As p
GROUP BY 	
	p.ProductCode
	, p.ProductName
	, p.ProductDescriptionShort
ORDER BY p.productcode


SEO - Robots.txt Disallow List
227
SELECT
	p.ProductName
	, ('Disallow:' + SPACE(1) + '/' + ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(p.ProductNameShort, SPACE(1) + char(45) + SPACE(1), char(45)), 'w' + char(47), 'with'), char(38), 'and'), char(39), 'inch'), char(34), 'ft'), char(58), char(45)), char(46), char(45)), char(47), char(45)), char(44), char(00)), char(40), char(00)), char(41), char(00)), SPACE(1), char(45)), 'product') + '-p/' + REPLACE(p.ProductCode, char(58), char(45) + 'colon' + char(45)) + '.htm') AS 'Robot.txt Disallow List'
FROM Products_joined As p
WHERE 
	p.HideProduct = 'Y'
GROUP BY 
	p.ProductName
	, ('Disallow:' + SPACE(1) + '/' + ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(p.ProductNameShort, SPACE(1) + char(45) + SPACE(1), char(45)), 'w' + char(47), 'with'), char(38), 'and'), char(39), 'inch'), char(34), 'ft'), char(58), char(45)), char(46), char(45)), char(47), char(45)), char(44), char(00)), char(40), char(00)), char(41), char(00)), SPACE(1), char(45)), 'product') + '-p/' + REPLACE(p.ProductCode, char(58), char(45) + 'colon' + char(45)) + '.htm')
ORDER BY p.ProductName


Edits - Free Shipping Products
228
SELECT
	p.ProductCode
	, p.ProductName
	, p.FreeShippingItem
	, p.Vendor_Price
	, p.productprice
FROM Products_joined As p
WHERE 
	p.HideProduct IS NULL
GROUP BY 	
	p.ProductCode
	, p.ProductName
	, p.FreeShippingItem
	, p.Vendor_Price
	, p.productprice
ORDER BY p.productcode


Reports - Revenue - Payment Log Main
229
SELECT
	o.OrderID
	, o.OrderDate
	, o.OrderStatus
	, isnull(pl.pay_result,'') AS 'Transaction Type'
	, isnull(pl.pay_amount,'') AS 'TransactionAmount'
	, isnull(pl.pay_authdate,'') AS 'Transaction Date'
FROM Orders as O 
LEFT JOIN Payment_Log as pl
	ON o.OrderID = pl.Pay_OrderId
LEFT JOIN Customers as c
	ON c.CustomerID = o.CustomerID
WHERE o.OrderDate BETWEEN '1/1/2016 0:00' AND '7/5/2016 23:59'
AND c.EmailAddress NOT LIKE '%@marketplace.amazon.com'
AND pl.pay_result <> 'DECLINED'
AND	pl.pay_result <> 'AUTHORIZE'
AND	pl.pay_result <> 'TIMEOUT'
AND	pl.pay_result <> 'FAILED'
GROUP BY 
	o.OrderID
	, o.OrderDate
	, o.OrderStatus
	, pl.pay_result
	, pl.pay_amount
	, pl.pay_authdate
ORDER BY o.OrderID ASC


Reports - Revenue - Payment Log - No Payment
230
SELECT
	o.OrderID
	, o.OrderDate
	, c.CompanyName
	, (c.FirstName + ' ' + c.LastName) AS 'Customer Name'
	, o.OrderStatus
	, o.PaymentAmount
	, o.SalesRep_CustomerID
	, isnull(pl.pay_result,'') AS 'Transaction Type'
	, isnull(pl.pay_amount,'') AS 'TransactionAmount'
	, isnull(pl.pay_authdate,'') AS 'Transaction Date'
FROM Orders as O 
LEFT JOIN Payment_Log as pl
	ON o.OrderID = pl.Pay_OrderId
LEFT JOIN Customers as c
	ON c.CustomerID = o.CustomerID
WHERE o.OrderDate BETWEEN '1/1/2016 0:00' AND '12/31/2017 23:59'
	AND c.EmailAddress NOT LIKE '%@marketplace.amazon.com'
	AND pl.pay_result IS NULL
	AND o.Orderstatus <> 'cancelled'
	AND o.Orderstatus <> 'Returned'
	AND o.ShipDate IS NOT NULL
GROUP BY 
	o.OrderID
	, o.OrderDate
	, c.CompanyName
	, (c.FirstName + ' ' + c.LastName) AS 'Customer Name'
	, o.OrderStatus
	, pl.pay_result
	, pl.pay_amount
	, pl.pay_authdate
	, o.PaymentAmount
	, o.SalesRep_CustomerID
ORDER BY o.OrderID ASC


Reports - Revenue - Payment Log - Voids
231
SELECT
	o.OrderID
	, o.OrderDate
	, o.OrderStatus
	, isnull(pl.pay_amount,'') AS 'Transaction Amount'
	, pl.pay_transid AS 'Transaction ID'
	, COUNT(pl.pay_transid) AS 'ID Count'
FROM Payment_Log as pl
LEFT JOIN Orders as O 
	ON o.OrderID = pl.Pay_OrderId
LEFT JOIN Customers as c
	ON c.CustomerID = o.CustomerID
WHERE o.OrderDate BETWEEN '1/1/2016 0:00' AND '7/5/2016 23:59'
AND c.EmailAddress NOT LIKE '%@marketplace.amazon.com'
AND (pl.pay_result = 'VOID'
	OR pl.pay_result = 'AUTHORIZE')
GROUP BY 
	o.OrderID
	, o.OrderDate
	, o.OrderStatus
	, pl.pay_amount
	, pl.pay_transid
HAVING (COUNT(pl.pay_transid) >= 2)
ORDER BY o.OrderID ASC


Reports - Revenue - Tax and Shipping
232
SELECT
	SUM(o.TotalShippingCost) AS 'Total Shipping'
	, (SUM(o.SalesTax1) + SUM(o.SalesTax2) + SUM(o.SalesTax3)) AS 'Total Tax'
FROM Orders as O
LEFT JOIN Customers as c
	ON c.CustomerID = o.CustomerID
WHERE o.OrderDate BETWEEN '1/1/2016 0:00' AND '7/5/2016 23:59'
AND c.EmailAddress NOT LIKE '%@marketplace.amazon.com'


233
Reports - Dealer Valuation and Remarketing
SELECT
	c.CompanyName
	, c.AccessKey
	, SUM(od.TotalPrice) AS 'Total Payment Amount'
	, COUNT(DISTINCT o.OrderDate) AS 'Order Count by Date'
	, SUM(o.PaymentAmount)/COUNT(o.OrderID) AS 'Average Payment Amount'
	, DATEDIFF(d,MIN(o.OrderDate),MAX(o.OrderDate)) AS 'Days as a Customer'
	, DATEDIFF(d,MIN(o.OrderDate),MAX(o.OrderDate))/COUNT(DISTINCT o.OrderDate) AS 'Average Days between Orders'
	, MAX(OrderDate) AS 'Last Order Date'
	, DATEDIFF(d,MAX(o.OrderDate),GETDATE()) AS 'Days since Last Order'
	, DATEDIFF(d,DATEDIFF(d,MIN(o.OrderDate),MAX(o.OrderDate))/COUNT(DISTINCT o.OrderDate),DATEDIFF(d,MAX(o.OrderDate),GETDATE())) AS 'Days Overdue based on Average'
FROM OrderDetails AS od
LEFT JOIN Orders AS o
	ON o.OrderID = od.OrderID
LEFT JOIN Customers AS c 
	ON c.CustomerID = o.CustomerID
WHERE o.Orderstatus <> 'cancelled'
AND o.Orderstatus <> 'returned'
AND c.CustomerID >= 23
AND c.CustomerID <> 24
AND c.CustomerID <> 26
AND c.CustomerID <> 177
AND c.AccessKey <> 'A'
AND (c.EmailAddress LIKE '%7distribution.com'
	OR c.EmailAddress LIKE '%abs-tech.com'
	OR c.EmailAddress LIKE '%academictechinc.com'
	OR c.EmailAddress LIKE '%adslv.com'
	OR c.EmailAddress LIKE '%admteknologi.com'
	OR c.EmailAddress LIKE '%advanced-inc.com'
	OR c.EmailAddress LIKE '%ats-av.com'
	OR c.EmailAddress LIKE '%affinitechinc.com'
	OR c.EmailAddress LIKE '%agrity.com.my'
	OR c.EmailAddress LIKE '%alltec.co.il'
	OR c.EmailAddress LIKE '%amazingtech.solutions'
	OR c.EmailAddress LIKE '%amelation.com'
	OR c.EmailAddress LIKE '%aselcom.cr'
	OR c.EmailAddress LIKE '%atpsystemsav.com'
	OR c.EmailAddress LIKE '%a-v-c.com'
	OR c.EmailAddress LIKE '%audiovideopr.com'
	OR c.EmailAddress LIKE '%mig-avc.com'
	OR c.EmailAddress LIKE '%avisystems.com'
	OR c.EmailAddress LIKE '%azure-ds.com'
	OR c.EmailAddress LIKE '%batipi.com'
	OR c.EmailAddress LIKE '%bluewatertech.com '
	OR c.EmailAddress LIKE '%belectriccorp.com'
	OR c.EmailAddress LIKE '%broadcast-tech.com'
	OR c.EmailAddress LIKE '%cve.com'
	OR c.EmailAddress LIKE '%camperio.net'
	OR c.EmailAddress LIKE '%caribtechsol.com'
	OR c.EmailAddress LIKE '%cartersav.com'
	OR c.EmailAddress LIKE '%casaplex.com'
	OR c.EmailAddress LIKE '%ccssouthwest.com '
	OR c.EmailAddress LIKE '%ccssoutheast.com'
	OR c.EmailAddress LIKE '%ce2.at'
	OR c.EmailAddress LIKE '%cerge.com'
	OR c.EmailAddress LIKE '%clarktechnologies.com'
	OR c.EmailAddress LIKE '%getclearav.co.uk'
	OR c.EmailAddress LIKE '%collaborationsolutions.com'
	OR c.EmailAddress LIKE '%colortone-av.com'
	OR c.EmailAddress LIKE '%commlinkav.com'
	OR c.EmailAddress LIKE '%commav.net'
	OR c.EmailAddress LIKE '%computerworldslu.com'
	OR c.EmailAddress LIKE '%conferencetech.com'
	OR c.EmailAddress LIKE '%cp-vision.at'
	OR c.EmailAddress LIKE '%crisptelecom.us'
	OR c.EmailAddress LIKE '%dg-av.com'
	OR c.EmailAddress LIKE '%digarts.com'
	OR c.EmailAddress LIKE '%adigitalhome.com'
	OR c.EmailAddress LIKE '%disk.cz'
	OR c.EmailAddress LIKE '%dreamtech.com.ua'
	OR c.EmailAddress LIKE '%easymeeting.net'
	OR c.EmailAddress LIKE '%elvia.cz'
	OR c.EmailAddress LIKE '%encompassmedia.net'
	OR c.EmailAddress LIKE '%ezpyramid.com'
	OR c.EmailAddress LIKE '%featherstonmedia.com'
	OR c.EmailAddress LIKE '%featpresav.com'
	OR c.EmailAddress LIKE '%ftx.ee'
	OR c.EmailAddress LIKE '%gnode.mx'
	OR c.EmailAddress LIKE '%networkparamedics.com'
	OR c.EmailAddress LIKE '%gofacing.com'
	OR c.EmailAddress LIKE '%hbcommunications.com'
	OR c.EmailAddress LIKE '%hefservices.com'
	OR c.EmailAddress LIKE '%hitechavs.com'
	OR c.EmailAddress LIKE '%highbitsav.com'
	OR c.EmailAddress LIKE '%iled.co.za'
	OR c.EmailAddress LIKE '%innotouch.net'
	OR c.EmailAddress LIKE '%integratedmultimediasolutions.com'
	OR c.EmailAddress LIKE '%intercadsys.com'
	OR c.EmailAddress LIKE '%intuitivecomminc.com'
	OR c.EmailAddress LIKE '%iqsystems.com.ec'
	OR c.EmailAddress LIKE '%verizon.net '
	OR c.EmailAddress LIKE '%it1.com'
	OR c.EmailAddress LIKE '%ivs-tec.com'
	OR c.EmailAddress LIKE '%jsav.com'
	OR c.EmailAddress LIKE '%jtjti.com'
	OR c.EmailAddress LIKE '%karshathoughts.com'
	OR c.EmailAddress LIKE '%kingsystemsllc.com'
	OR c.EmailAddress LIKE '%limasound.com'
	OR c.EmailAddress LIKE '%lookeasy.asia'
	OR c.EmailAddress LIKE '%ltt.com.pl'
	OR c.EmailAddress LIKE '%m3techgroup.com'
	OR c.EmailAddress LIKE '%madisontech.com.au'
	OR c.EmailAddress LIKE '%tbaytel.ne'
	OR c.EmailAddress LIKE '%gomediatech.com'
	OR c.EmailAddress LIKE '%medvisionusa.com'
	OR c.EmailAddress LIKE '%meineketv.com'
	OR c.EmailAddress LIKE '%midtownvideo.com'
	OR c.EmailAddress LIKE '%milestoneproductions.ie'
	OR c.EmailAddress LIKE '%momentumsound.com'
	OR c.EmailAddress LIKE '%msomcomm.com'
	OR c.EmailAddress LIKE '%multi-systems.com'
	OR c.EmailAddress LIKE '%mysherpa.com'
	OR c.EmailAddress LIKE '%natheatrix.com'
	OR c.EmailAddress LIKE '%northlandss.com'
	OR c.EmailAddress LIKE '%itshappeningrightnow.com'
	OR c.EmailAddress LIKE '%nyherji.is'
	OR c.EmailAddress LIKE '%officeplusuae.com'
	OR c.EmailAddress LIKE '%opennetworks.com'
	OR c.EmailAddress LIKE '%osmetro.com'
	OR c.EmailAddress LIKE '%opta.kiev.ua'
	OR c.EmailAddress LIKE '%performancecom.net'
	OR c.EmailAddress LIKE '%perftechman.com'
	OR c.EmailAddress LIKE '%perlmutterpurchasing.com'
	OR c.EmailAddress LIKE '%pixelpro.com.tr'
	OR c.EmailAddress LIKE '%chasethebracelet.com'
	OR c.EmailAddress LIKE '%praxis8.com'
	OR c.EmailAddress LIKE '%prosound.net'
	OR c.EmailAddress LIKE '%provector.dk'
	OR c.EmailAddress LIKE '%provav.com'
	OR c.EmailAddress LIKE '%rbccable.com'
	OR c.EmailAddress LIKE '%resolution-av.co.nz'
	OR c.EmailAddress LIKE '%slproductions.us'
	OR c.EmailAddress LIKE '%shi.com'
	OR c.EmailAddress LIKE '%sidewalktech.com'
	OR c.EmailAddress LIKE '%siscocorp.com'
	OR c.EmailAddress LIKE '%slickcybersystems.com'
	OR c.EmailAddress LIKE '%smartglobal.es'
	OR c.EmailAddress LIKE '%shisystems.com'
	OR c.EmailAddress LIKE '%streamportmedia.com'
	OR c.EmailAddress LIKE '%syncomation.com'
	OR c.EmailAddress LIKE '%sysquo.com'
	OR c.EmailAddress LIKE '%sys-dsn.com'
	OR c.EmailAddress LIKE '%tymc.co.kr'
	OR c.EmailAddress LIKE '%TCCOhio.com'
	OR c.EmailAddress LIKE '%tech-integ.com'
	OR c.EmailAddress LIKE '%tvg.mx'
	OR c.EmailAddress LIKE '%telesmart.co.nz'
	OR c.EmailAddress LIKE '%theavgroup.com'
	OR c.EmailAddress LIKE '%tirusvoice.com'
	OR c.EmailAddress LIKE '%triag.us'
	OR c.EmailAddress LIKE '%tsi-global.com '
	OR c.EmailAddress LIKE '%videolink.ca'
	OR c.EmailAddress LIKE '%visualgate.cz'
	OR c.EmailAddress LIKE '%vmivideo.com'
	OR c.EmailAddress LIKE '%voxelvision.com.tw'
	OR c.EmailAddress LIKE '%whitlock.com'
	OR c.EmailAddress LIKE '%wintech-inc.com'
	OR c.EmailAddress LIKE '%wisewaysupply.com'
	OR c.EmailAddress LIKE '%worldofsoundnc.com'
	OR c.EmailAddress LIKE '%csproducts.com'
	OR c.EmailAddress LIKE '%hdvparts.com'
	OR c.EmailAddress LIKE '%gaeltek.com'
	OR c.EmailAddress LIKE '%veytec.com'
	OR c.EmailAddress LIKE '%precisionmultimedia.com'
	OR c.EmailAddress LIKE '%mcwsolutions.net'
	OR c.EmailAddress LIKE '%uniguest.com'
	OR c.EmailAddress LIKE '%tnpbroadcast.co.uk'
	OR c.EmailAddress LIKE '%cyberfish.ch'
	OR c.EmailAddress LIKE '%sonopro.pt'
	OR c.EmailAddress LIKE '%vpintegral.com'
	OR c.EmailAddress LIKE '%tsicolumbus.com'
	OR c.EmailAddress LIKE '%jgcomm.net'
	OR c.EmailAddress LIKE '%88veterans.com'
	OR c.EmailAddress LIKE '%avworx.net'
	OR c.EmailAddress LIKE '%novasud.com'
	OR c.EmailAddress LIKE '%streamlinesystemsltd.com'
	OR c.EmailAddress LIKE '%avims.net'
	OR c.EmailAddress LIKE '%scharfindustries.com'
	OR c.EmailAddress LIKE '%pro-media.at'
	OR c.EmailAddress LIKE '%austinav.com'
	OR c.EmailAddress LIKE '%threeriversvideo.com'
	OR c.EmailAddress LIKE '%riole.com.br'
	OR c.EmailAddress LIKE '%braca.nl'
	OR c.EmailAddress LIKE '%bcpi.com'
	OR c.EmailAddress LIKE '%acvideosolutions.com'
	OR c.EmailAddress LIKE '%adminmonitor.com'
	OR c.EmailAddress LIKE '%bizco.com'
	OR c.EmailAddress LIKE '%uldwc.com'
	OR c.EmailAddress LIKE '%xciteav.com'
	OR c.EmailAddress LIKE '%clnik.com'
	OR c.EmailAddress LIKE '%blueorange.com.sg'
	OR c.EmailAddress LIKE '%cubsinc.com'
	OR c.EmailAddress LIKE '%abi-com.com'
	OR c.EmailAddress LIKE '%bacomputersolutions.com'
	OR c.EmailAddress LIKE '%one-eye.nl'
	OR c.EmailAddress LIKE '%atea.dk'
	OR c.EmailAddress LIKE '%avsolutionsinc.net'
	OR c.EmailAddress LIKE '%allied-audio.com'
	OR c.EmailAddress LIKE '%streamspot.com'
	OR c.EmailAddress LIKE '%avrduluth.com'
	OR c.EmailAddress LIKE '%idb.com.vn'
	OR c.EmailAddress LIKE '%tcicomm.com'
	OR c.EmailAddress LIKE '%dakotech.net'
	OR c.EmailAddress LIKE '%customcontrol.mx'
	OR c.EmailAddress LIKE '%linesbroadcast.nl'
	OR c.EmailAddress LIKE '%avconusa.com'
	OR c.EmailAddress LIKE '%inavate-av.com'
	OR c.EmailAddress LIKE '%HorizonAVS.com'
	OR c.EmailAddress LIKE '%koncerted.com'
	OR c.EmailAddress LIKE '%telindus.lu'
	OR c.EmailAddress LIKE '%skelectronics.net'
	OR c.EmailAddress LIKE '%techexport.com'
	OR c.EmailAddress LIKE '%audioarte-bg.com'
	OR c.EmailAddress LIKE '%plugged-records.com'
	OR c.EmailAddress = 'manbina68@gmail.com'
	OR c.EmailAddress = 'digitalintegrationdesign@gmail.com'
	OR c.EmailAddress = 'garonsav@gmail.com'
	OR c.EmailAddress = 'geminiaudio@gmail.com'
	OR c.EmailAddress = 'dyerj205@gmail.com'
	OR c.EmailAddress = 'kw2sales@gmail.com'
	OR c.EmailAddress = 'lisakwood@hotmail.com'
	OR c.EmailAddress = 'jimrob1@hotmail.com'
	OR c.EmailAddress = 'audiochef@aol.com'
	OR c.EmailAddress = 'magnoliamusic@bellsouth.net')
AND o.OrderDate BETWEEN '1/1/2014 0:00' AND '12/31/2016 23:59'
GROUP BY 
	c.CompanyName
	, c.AccessKey
ORDER BY c.CompanyName

234
LD - Dealer Editing
SELECT
	c.CompanyName
	, c.AccessKey
	, c.CustomerID
	, c.EmailAddress
FROM OrderDetails AS od
LEFT JOIN Orders AS o
	ON o.OrderID = od.OrderID
LEFT JOIN Customers AS c 
	ON c.CustomerID = o.CustomerID
WHERE o.Orderstatus <> 'cancelled'
AND o.Orderstatus <> 'returned'
AND c.CustomerID >= 23
AND c.CustomerID <> 24
AND c.CustomerID <> 26
AND c.CustomerID <> 177
AND c.AccessKey <> 'A'
AND (c.EmailAddress LIKE '%7distribution.com'
	OR c.EmailAddress LIKE '%abs-tech.com'
	OR c.EmailAddress LIKE '%academictechinc.com'
	OR c.EmailAddress LIKE '%adslv.com'
	OR c.EmailAddress LIKE '%admteknologi.com'
	OR c.EmailAddress LIKE '%advanced-inc.com'
	OR c.EmailAddress LIKE '%ats-av.com'
	OR c.EmailAddress LIKE '%affinitechinc.com'
	OR c.EmailAddress LIKE '%agrity.com.my'
	OR c.EmailAddress LIKE '%alltec.co.il'
	OR c.EmailAddress LIKE '%amazingtech.solutions'
	OR c.EmailAddress LIKE '%amelation.com'
	OR c.EmailAddress LIKE '%aselcom.cr'
	OR c.EmailAddress LIKE '%atpsystemsav.com'
	OR c.EmailAddress LIKE '%a-v-c.com'
	OR c.EmailAddress LIKE '%audiovideopr.com'
	OR c.EmailAddress LIKE '%mig-avc.com'
	OR c.EmailAddress LIKE '%avisystems.com'
	OR c.EmailAddress LIKE '%azure-ds.com'
	OR c.EmailAddress LIKE '%batipi.com'
	OR c.EmailAddress LIKE '%bluewatertech.com '
	OR c.EmailAddress LIKE '%belectriccorp.com'
	OR c.EmailAddress LIKE '%broadcast-tech.com'
	OR c.EmailAddress LIKE '%cve.com'
	OR c.EmailAddress LIKE '%camperio.net'
	OR c.EmailAddress LIKE '%caribtechsol.com'
	OR c.EmailAddress LIKE '%cartersav.com'
	OR c.EmailAddress LIKE '%casaplex.com'
	OR c.EmailAddress LIKE '%ccssouthwest.com '
	OR c.EmailAddress LIKE '%ccssoutheast.com'
	OR c.EmailAddress LIKE '%ce2.at'
	OR c.EmailAddress LIKE '%cerge.com'
	OR c.EmailAddress LIKE '%clarktechnologies.com'
	OR c.EmailAddress LIKE '%getclearav.co.uk'
	OR c.EmailAddress LIKE '%collaborationsolutions.com'
	OR c.EmailAddress LIKE '%colortone-av.com'
	OR c.EmailAddress LIKE '%commlinkav.com'
	OR c.EmailAddress LIKE '%commav.net'
	OR c.EmailAddress LIKE '%computerworldslu.com'
	OR c.EmailAddress LIKE '%conferencetech.com'
	OR c.EmailAddress LIKE '%cp-vision.at'
	OR c.EmailAddress LIKE '%crisptelecom.us'
	OR c.EmailAddress LIKE '%dg-av.com'
	OR c.EmailAddress LIKE '%digarts.com'
	OR c.EmailAddress LIKE '%adigitalhome.com'
	OR c.EmailAddress LIKE '%disk.cz'
	OR c.EmailAddress LIKE '%dreamtech.com.ua'
	OR c.EmailAddress LIKE '%easymeeting.net'
	OR c.EmailAddress LIKE '%elvia.cz'
	OR c.EmailAddress LIKE '%encompassmedia.net'
	OR c.EmailAddress LIKE '%ezpyramid.com'
	OR c.EmailAddress LIKE '%featherstonmedia.com'
	OR c.EmailAddress LIKE '%featpresav.com'
	OR c.EmailAddress LIKE '%ftx.ee'
	OR c.EmailAddress LIKE '%gnode.mx'
	OR c.EmailAddress LIKE '%networkparamedics.com'
	OR c.EmailAddress LIKE '%gofacing.com'
	OR c.EmailAddress LIKE '%hbcommunications.com'
	OR c.EmailAddress LIKE '%hefservices.com'
	OR c.EmailAddress LIKE '%hitechavs.com'
	OR c.EmailAddress LIKE '%highbitsav.com'
	OR c.EmailAddress LIKE '%iled.co.za'
	OR c.EmailAddress LIKE '%innotouch.net'
	OR c.EmailAddress LIKE '%integratedmultimediasolutions.com'
	OR c.EmailAddress LIKE '%intercadsys.com'
	OR c.EmailAddress LIKE '%intuitivecomminc.com'
	OR c.EmailAddress LIKE '%iqsystems.com.ec'
	OR c.EmailAddress LIKE '%verizon.net '
	OR c.EmailAddress LIKE '%it1.com'
	OR c.EmailAddress LIKE '%ivs-tec.com'
	OR c.EmailAddress LIKE '%jsav.com'
	OR c.EmailAddress LIKE '%jtjti.com'
	OR c.EmailAddress LIKE '%karshathoughts.com'
	OR c.EmailAddress LIKE '%kingsystemsllc.com'
	OR c.EmailAddress LIKE '%limasound.com'
	OR c.EmailAddress LIKE '%lookeasy.asia'
	OR c.EmailAddress LIKE '%ltt.com.pl'
	OR c.EmailAddress LIKE '%m3techgroup.com'
	OR c.EmailAddress LIKE '%madisontech.com.au'
	OR c.EmailAddress LIKE '%tbaytel.ne'
	OR c.EmailAddress LIKE '%gomediatech.com'
	OR c.EmailAddress LIKE '%medvisionusa.com'
	OR c.EmailAddress LIKE '%meineketv.com'
	OR c.EmailAddress LIKE '%midtownvideo.com'
	OR c.EmailAddress LIKE '%milestoneproductions.ie'
	OR c.EmailAddress LIKE '%momentumsound.com'
	OR c.EmailAddress LIKE '%msomcomm.com'
	OR c.EmailAddress LIKE '%multi-systems.com'
	OR c.EmailAddress LIKE '%mysherpa.com'
	OR c.EmailAddress LIKE '%natheatrix.com'
	OR c.EmailAddress LIKE '%northlandss.com'
	OR c.EmailAddress LIKE '%itshappeningrightnow.com'
	OR c.EmailAddress LIKE '%nyherji.is'
	OR c.EmailAddress LIKE '%officeplusuae.com'
	OR c.EmailAddress LIKE '%opennetworks.com'
	OR c.EmailAddress LIKE '%osmetro.com'
	OR c.EmailAddress LIKE '%opta.kiev.ua'
	OR c.EmailAddress LIKE '%performancecom.net'
	OR c.EmailAddress LIKE '%perftechman.com'
	OR c.EmailAddress LIKE '%perlmutterpurchasing.com'
	OR c.EmailAddress LIKE '%pixelpro.com.tr'
	OR c.EmailAddress LIKE '%chasethebracelet.com'
	OR c.EmailAddress LIKE '%praxis8.com'
	OR c.EmailAddress LIKE '%prosound.net'
	OR c.EmailAddress LIKE '%provector.dk'
	OR c.EmailAddress LIKE '%provav.com'
	OR c.EmailAddress LIKE '%rbccable.com'
	OR c.EmailAddress LIKE '%resolution-av.co.nz'
	OR c.EmailAddress LIKE '%slproductions.us'
	OR c.EmailAddress LIKE '%shi.com'
	OR c.EmailAddress LIKE '%sidewalktech.com'
	OR c.EmailAddress LIKE '%siscocorp.com'
	OR c.EmailAddress LIKE '%slickcybersystems.com'
	OR c.EmailAddress LIKE '%smartglobal.es'
	OR c.EmailAddress LIKE '%shisystems.com'
	OR c.EmailAddress LIKE '%streamportmedia.com'
	OR c.EmailAddress LIKE '%syncomation.com'
	OR c.EmailAddress LIKE '%sysquo.com'
	OR c.EmailAddress LIKE '%sys-dsn.com'
	OR c.EmailAddress LIKE '%tymc.co.kr'
	OR c.EmailAddress LIKE '%TCCOhio.com'
	OR c.EmailAddress LIKE '%tech-integ.com'
	OR c.EmailAddress LIKE '%tvg.mx'
	OR c.EmailAddress LIKE '%telesmart.co.nz'
	OR c.EmailAddress LIKE '%theavgroup.com'
	OR c.EmailAddress LIKE '%tirusvoice.com'
	OR c.EmailAddress LIKE '%triag.us'
	OR c.EmailAddress LIKE '%tsi-global.com '
	OR c.EmailAddress LIKE '%videolink.ca'
	OR c.EmailAddress LIKE '%visualgate.cz'
	OR c.EmailAddress LIKE '%vmivideo.com'
	OR c.EmailAddress LIKE '%voxelvision.com.tw'
	OR c.EmailAddress LIKE '%whitlock.com'
	OR c.EmailAddress LIKE '%wintech-inc.com'
	OR c.EmailAddress LIKE '%wisewaysupply.com'
	OR c.EmailAddress LIKE '%worldofsoundnc.com'
	OR c.EmailAddress LIKE '%csproducts.com'
	OR c.EmailAddress LIKE '%hdvparts.com'
	OR c.EmailAddress LIKE '%gaeltek.com'
	OR c.EmailAddress LIKE '%veytec.com'
	OR c.EmailAddress LIKE '%precisionmultimedia.com'
	OR c.EmailAddress LIKE '%mcwsolutions.net'
	OR c.EmailAddress LIKE '%uniguest.com'
	OR c.EmailAddress LIKE '%tnpbroadcast.co.uk'
	OR c.EmailAddress LIKE '%cyberfish.ch'
	OR c.EmailAddress LIKE '%sonopro.pt'
	OR c.EmailAddress LIKE '%vpintegral.com'
	OR c.EmailAddress LIKE '%tsicolumbus.com'
	OR c.EmailAddress LIKE '%jgcomm.net'
	OR c.EmailAddress LIKE '%88veterans.com'
	OR c.EmailAddress LIKE '%avworx.net'
	OR c.EmailAddress LIKE '%novasud.com'
	OR c.EmailAddress LIKE '%streamlinesystemsltd.com'
	OR c.EmailAddress LIKE '%avims.net'
	OR c.EmailAddress LIKE '%scharfindustries.com'
	OR c.EmailAddress LIKE '%pro-media.at'
	OR c.EmailAddress LIKE '%austinav.com'
	OR c.EmailAddress LIKE '%threeriversvideo.com'
	OR c.EmailAddress LIKE '%riole.com.br'
	OR c.EmailAddress LIKE '%braca.nl'
	OR c.EmailAddress LIKE '%bcpi.com'
	OR c.EmailAddress LIKE '%acvideosolutions.com'
	OR c.EmailAddress LIKE '%adminmonitor.com'
	OR c.EmailAddress LIKE '%bizco.com'
	OR c.EmailAddress LIKE '%uldwc.com'
	OR c.EmailAddress LIKE '%xciteav.com'
	OR c.EmailAddress LIKE '%clnik.com'
	OR c.EmailAddress LIKE '%blueorange.com.sg'
	OR c.EmailAddress LIKE '%cubsinc.com'
	OR c.EmailAddress LIKE '%abi-com.com'
	OR c.EmailAddress LIKE '%bacomputersolutions.com'
	OR c.EmailAddress LIKE '%one-eye.nl'
	OR c.EmailAddress LIKE '%atea.dk'
	OR c.EmailAddress LIKE '%avsolutionsinc.net'
	OR c.EmailAddress LIKE '%allied-audio.com'
	OR c.EmailAddress LIKE '%streamspot.com'
	OR c.EmailAddress LIKE '%avrduluth.com'
	OR c.EmailAddress LIKE '%idb.com.vn'
	OR c.EmailAddress LIKE '%tcicomm.com'
	OR c.EmailAddress LIKE '%dakotech.net'
	OR c.EmailAddress LIKE '%customcontrol.mx'
	OR c.EmailAddress LIKE '%linesbroadcast.nl'
	OR c.EmailAddress LIKE '%avconusa.com'
	OR c.EmailAddress LIKE '%inavate-av.com'
	OR c.EmailAddress LIKE '%HorizonAVS.com'
	OR c.EmailAddress LIKE '%koncerted.com'
	OR c.EmailAddress LIKE '%telindus.lu'
	OR c.EmailAddress LIKE '%skelectronics.net'
	OR c.EmailAddress LIKE '%techexport.com'
	OR c.EmailAddress LIKE '%audioarte-bg.com'
	OR c.EmailAddress LIKE '%plugged-records.com'
	OR c.EmailAddress = 'manbina68@gmail.com'
	OR c.EmailAddress = 'digitalintegrationdesign@gmail.com'
	OR c.EmailAddress = 'garonsav@gmail.com'
	OR c.EmailAddress = 'geminiaudio@gmail.com'
	OR c.EmailAddress = 'dyerj205@gmail.com'
	OR c.EmailAddress = 'kw2sales@gmail.com'
	OR c.EmailAddress = 'lisakwood@hotmail.com'
	OR c.EmailAddress = 'jimrob1@hotmail.com'
	OR c.EmailAddress = 'audiochef@aol.com'
	OR c.EmailAddress = 'magnoliamusic@bellsouth.net')
AND o.OrderDate BETWEEN '1/1/2014 0:00' AND '12/31/2016 23:59'
GROUP BY 
	c.CompanyName
	, c.AccessKey
	, c.CustomerID
	, c.EmailAddress
ORDER BY c.CompanyName


235
Reports - Dealer Order Details
SELECT
	c.CompanyName
	, od.ProductCode
	, od.ProductName
	, SUM(od.Quantity) AS 'Total Quantity'
FROM OrderDetails AS od
LEFT JOIN Orders AS o
	ON o.OrderID = od.OrderID
LEFT JOIN Customers AS c 
	ON c.CustomerID = o.CustomerID
WHERE o.Orderstatus <> 'cancelled'
AND o.Orderstatus <> 'returned'
AND c.CustomerID >= 23
AND c.CustomerID <> 24
AND c.CustomerID <> 26
AND c.CustomerID <> 177
AND c.AccessKey <> 'A'
AND (c.EmailAddress LIKE '%7distribution.com'
	OR c.EmailAddress LIKE '%abs-tech.com'
	OR c.EmailAddress LIKE '%academictechinc.com'
	OR c.EmailAddress LIKE '%adslv.com'
	OR c.EmailAddress LIKE '%admteknologi.com'
	OR c.EmailAddress LIKE '%advanced-inc.com'
	OR c.EmailAddress LIKE '%ats-av.com'
	OR c.EmailAddress LIKE '%affinitechinc.com'
	OR c.EmailAddress LIKE '%agrity.com.my'
	OR c.EmailAddress LIKE '%alltec.co.il'
	OR c.EmailAddress LIKE '%amazingtech.solutions'
	OR c.EmailAddress LIKE '%amelation.com'
	OR c.EmailAddress LIKE '%aselcom.cr'
	OR c.EmailAddress LIKE '%atpsystemsav.com'
	OR c.EmailAddress LIKE '%a-v-c.com'
	OR c.EmailAddress LIKE '%audiovideopr.com'
	OR c.EmailAddress LIKE '%mig-avc.com'
	OR c.EmailAddress LIKE '%avisystems.com'
	OR c.EmailAddress LIKE '%azure-ds.com'
	OR c.EmailAddress LIKE '%batipi.com'
	OR c.EmailAddress LIKE '%bluewatertech.com '
	OR c.EmailAddress LIKE '%belectriccorp.com'
	OR c.EmailAddress LIKE '%broadcast-tech.com'
	OR c.EmailAddress LIKE '%cve.com'
	OR c.EmailAddress LIKE '%camperio.net'
	OR c.EmailAddress LIKE '%caribtechsol.com'
	OR c.EmailAddress LIKE '%cartersav.com'
	OR c.EmailAddress LIKE '%casaplex.com'
	OR c.EmailAddress LIKE '%ccssouthwest.com '
	OR c.EmailAddress LIKE '%ccssoutheast.com'
	OR c.EmailAddress LIKE '%ce2.at'
	OR c.EmailAddress LIKE '%cerge.com'
	OR c.EmailAddress LIKE '%clarktechnologies.com'
	OR c.EmailAddress LIKE '%getclearav.co.uk'
	OR c.EmailAddress LIKE '%collaborationsolutions.com'
	OR c.EmailAddress LIKE '%colortone-av.com'
	OR c.EmailAddress LIKE '%commlinkav.com'
	OR c.EmailAddress LIKE '%commav.net'
	OR c.EmailAddress LIKE '%computerworldslu.com'
	OR c.EmailAddress LIKE '%conferencetech.com'
	OR c.EmailAddress LIKE '%cp-vision.at'
	OR c.EmailAddress LIKE '%crisptelecom.us'
	OR c.EmailAddress LIKE '%dg-av.com'
	OR c.EmailAddress LIKE '%digarts.com'
	OR c.EmailAddress LIKE '%adigitalhome.com'
	OR c.EmailAddress LIKE '%disk.cz'
	OR c.EmailAddress LIKE '%dreamtech.com.ua'
	OR c.EmailAddress LIKE '%easymeeting.net'
	OR c.EmailAddress LIKE '%elvia.cz'
	OR c.EmailAddress LIKE '%encompassmedia.net'
	OR c.EmailAddress LIKE '%ezpyramid.com'
	OR c.EmailAddress LIKE '%featherstonmedia.com'
	OR c.EmailAddress LIKE '%featpresav.com'
	OR c.EmailAddress LIKE '%ftx.ee'
	OR c.EmailAddress LIKE '%gnode.mx'
	OR c.EmailAddress LIKE '%networkparamedics.com'
	OR c.EmailAddress LIKE '%gofacing.com'
	OR c.EmailAddress LIKE '%hbcommunications.com'
	OR c.EmailAddress LIKE '%hefservices.com'
	OR c.EmailAddress LIKE '%hitechavs.com'
	OR c.EmailAddress LIKE '%highbitsav.com'
	OR c.EmailAddress LIKE '%iled.co.za'
	OR c.EmailAddress LIKE '%innotouch.net'
	OR c.EmailAddress LIKE '%integratedmultimediasolutions.com'
	OR c.EmailAddress LIKE '%intercadsys.com'
	OR c.EmailAddress LIKE '%intuitivecomminc.com'
	OR c.EmailAddress LIKE '%iqsystems.com.ec'
	OR c.EmailAddress LIKE '%verizon.net '
	OR c.EmailAddress LIKE '%it1.com'
	OR c.EmailAddress LIKE '%ivs-tec.com'
	OR c.EmailAddress LIKE '%jsav.com'
	OR c.EmailAddress LIKE '%jtjti.com'
	OR c.EmailAddress LIKE '%karshathoughts.com'
	OR c.EmailAddress LIKE '%kingsystemsllc.com'
	OR c.EmailAddress LIKE '%limasound.com'
	OR c.EmailAddress LIKE '%lookeasy.asia'
	OR c.EmailAddress LIKE '%ltt.com.pl'
	OR c.EmailAddress LIKE '%m3techgroup.com'
	OR c.EmailAddress LIKE '%madisontech.com.au'
	OR c.EmailAddress LIKE '%tbaytel.ne'
	OR c.EmailAddress LIKE '%gomediatech.com'
	OR c.EmailAddress LIKE '%medvisionusa.com'
	OR c.EmailAddress LIKE '%meineketv.com'
	OR c.EmailAddress LIKE '%midtownvideo.com'
	OR c.EmailAddress LIKE '%milestoneproductions.ie'
	OR c.EmailAddress LIKE '%momentumsound.com'
	OR c.EmailAddress LIKE '%msomcomm.com'
	OR c.EmailAddress LIKE '%multi-systems.com'
	OR c.EmailAddress LIKE '%mysherpa.com'
	OR c.EmailAddress LIKE '%natheatrix.com'
	OR c.EmailAddress LIKE '%northlandss.com'
	OR c.EmailAddress LIKE '%itshappeningrightnow.com'
	OR c.EmailAddress LIKE '%nyherji.is'
	OR c.EmailAddress LIKE '%officeplusuae.com'
	OR c.EmailAddress LIKE '%opennetworks.com'
	OR c.EmailAddress LIKE '%osmetro.com'
	OR c.EmailAddress LIKE '%opta.kiev.ua'
	OR c.EmailAddress LIKE '%performancecom.net'
	OR c.EmailAddress LIKE '%perftechman.com'
	OR c.EmailAddress LIKE '%perlmutterpurchasing.com'
	OR c.EmailAddress LIKE '%pixelpro.com.tr'
	OR c.EmailAddress LIKE '%chasethebracelet.com'
	OR c.EmailAddress LIKE '%praxis8.com'
	OR c.EmailAddress LIKE '%prosound.net'
	OR c.EmailAddress LIKE '%provector.dk'
	OR c.EmailAddress LIKE '%provav.com'
	OR c.EmailAddress LIKE '%rbccable.com'
	OR c.EmailAddress LIKE '%resolution-av.co.nz'
	OR c.EmailAddress LIKE '%slproductions.us'
	OR c.EmailAddress LIKE '%shi.com'
	OR c.EmailAddress LIKE '%sidewalktech.com'
	OR c.EmailAddress LIKE '%siscocorp.com'
	OR c.EmailAddress LIKE '%slickcybersystems.com'
	OR c.EmailAddress LIKE '%smartglobal.es'
	OR c.EmailAddress LIKE '%shisystems.com'
	OR c.EmailAddress LIKE '%streamportmedia.com'
	OR c.EmailAddress LIKE '%syncomation.com'
	OR c.EmailAddress LIKE '%sysquo.com'
	OR c.EmailAddress LIKE '%sys-dsn.com'
	OR c.EmailAddress LIKE '%tymc.co.kr'
	OR c.EmailAddress LIKE '%TCCOhio.com'
	OR c.EmailAddress LIKE '%tech-integ.com'
	OR c.EmailAddress LIKE '%tvg.mx'
	OR c.EmailAddress LIKE '%telesmart.co.nz'
	OR c.EmailAddress LIKE '%theavgroup.com'
	OR c.EmailAddress LIKE '%tirusvoice.com'
	OR c.EmailAddress LIKE '%triag.us'
	OR c.EmailAddress LIKE '%tsi-global.com '
	OR c.EmailAddress LIKE '%videolink.ca'
	OR c.EmailAddress LIKE '%visualgate.cz'
	OR c.EmailAddress LIKE '%vmivideo.com'
	OR c.EmailAddress LIKE '%voxelvision.com.tw'
	OR c.EmailAddress LIKE '%whitlock.com'
	OR c.EmailAddress LIKE '%wintech-inc.com'
	OR c.EmailAddress LIKE '%wisewaysupply.com'
	OR c.EmailAddress LIKE '%worldofsoundnc.com'
	OR c.EmailAddress LIKE '%csproducts.com'
	OR c.EmailAddress LIKE '%hdvparts.com'
	OR c.EmailAddress LIKE '%gaeltek.com'
	OR c.EmailAddress LIKE '%veytec.com'
	OR c.EmailAddress LIKE '%precisionmultimedia.com'
	OR c.EmailAddress LIKE '%mcwsolutions.net'
	OR c.EmailAddress LIKE '%uniguest.com'
	OR c.EmailAddress LIKE '%tnpbroadcast.co.uk'
	OR c.EmailAddress LIKE '%cyberfish.ch'
	OR c.EmailAddress LIKE '%sonopro.pt'
	OR c.EmailAddress LIKE '%vpintegral.com'
	OR c.EmailAddress LIKE '%tsicolumbus.com'
	OR c.EmailAddress LIKE '%jgcomm.net'
	OR c.EmailAddress LIKE '%88veterans.com'
	OR c.EmailAddress LIKE '%avworx.net'
	OR c.EmailAddress LIKE '%novasud.com'
	OR c.EmailAddress LIKE '%streamlinesystemsltd.com'
	OR c.EmailAddress LIKE '%avims.net'
	OR c.EmailAddress LIKE '%scharfindustries.com'
	OR c.EmailAddress LIKE '%pro-media.at'
	OR c.EmailAddress LIKE '%austinav.com'
	OR c.EmailAddress LIKE '%threeriversvideo.com'
	OR c.EmailAddress LIKE '%riole.com.br'
	OR c.EmailAddress LIKE '%braca.nl'
	OR c.EmailAddress LIKE '%bcpi.com'
	OR c.EmailAddress LIKE '%acvideosolutions.com'
	OR c.EmailAddress LIKE '%adminmonitor.com'
	OR c.EmailAddress LIKE '%bizco.com'
	OR c.EmailAddress LIKE '%uldwc.com'
	OR c.EmailAddress LIKE '%xciteav.com'
	OR c.EmailAddress LIKE '%clnik.com'
	OR c.EmailAddress LIKE '%blueorange.com.sg'
	OR c.EmailAddress LIKE '%cubsinc.com'
	OR c.EmailAddress LIKE '%abi-com.com'
	OR c.EmailAddress LIKE '%bacomputersolutions.com'
	OR c.EmailAddress LIKE '%one-eye.nl'
	OR c.EmailAddress LIKE '%atea.dk'
	OR c.EmailAddress LIKE '%avsolutionsinc.net'
	OR c.EmailAddress LIKE '%allied-audio.com'
	OR c.EmailAddress LIKE '%streamspot.com'
	OR c.EmailAddress LIKE '%avrduluth.com'
	OR c.EmailAddress LIKE '%idb.com.vn'
	OR c.EmailAddress LIKE '%tcicomm.com'
	OR c.EmailAddress LIKE '%dakotech.net'
	OR c.EmailAddress LIKE '%customcontrol.mx'
	OR c.EmailAddress LIKE '%linesbroadcast.nl'
	OR c.EmailAddress LIKE '%avconusa.com'
	OR c.EmailAddress LIKE '%inavate-av.com'
	OR c.EmailAddress LIKE '%HorizonAVS.com'
	OR c.EmailAddress LIKE '%koncerted.com'
	OR c.EmailAddress LIKE '%telindus.lu'
	OR c.EmailAddress LIKE '%skelectronics.net'
	OR c.EmailAddress LIKE '%techexport.com'
	OR c.EmailAddress LIKE '%audioarte-bg.com'
	OR c.EmailAddress LIKE '%plugged-records.com'
	OR c.EmailAddress = 'manbina68@gmail.com'
	OR c.EmailAddress = 'digitalintegrationdesign@gmail.com'
	OR c.EmailAddress = 'garonsav@gmail.com'
	OR c.EmailAddress = 'geminiaudio@gmail.com'
	OR c.EmailAddress = 'dyerj205@gmail.com'
	OR c.EmailAddress = 'kw2sales@gmail.com'
	OR c.EmailAddress = 'lisakwood@hotmail.com'
	OR c.EmailAddress = 'jimrob1@hotmail.com'
	OR c.EmailAddress = 'audiochef@aol.com'
	OR c.EmailAddress = 'magnoliamusic@bellsouth.net')
AND o.OrderDate BETWEEN '1/1/2014 0:00' AND '12/31/2016 23:59'
AND (od.ProductCode LIKE 'CRS-VIDEO-CONFERENCING-%' 
	OR od.ProductCode LIKE 'CRS-GOOGLE-CHROMEBOX-SYSTEM' 
	OR od.ProductCode LIKE 'HUDDLECAMHD%'
	OR od.ProductCode LIKE 'HUDDLECAMHD-%' 
	OR od.ProductCode LIKE 'PTZOptics%' 
	OR od.ProductCode LIKE 'HUDDLEPOD%'
	OR od.ProductCode LIKE 'PT12X%'
	OR od.ProductCode LIKE 'PT20X%'
	OR od.ProductCode LIKE 'PTVL%'
	OR od.ProductCode LIKE 'PT-BRDCSTR%'
	OR od.ProductCode LIKE 'HCA12X'
	OR od.ProductCode LIKE 'HCA20X%'
	OR od.ProductCode LIKE 'HCM%'
	OR od.ProductCode LIKE 'HC%X%'
	OR od.ProductCode LIKE 'HC-JOY'
	OR od.ProductCode LIKE 'HP-AIR%')
GROUP BY 
	c.CompanyName
	, od.ProductCode
	, od.ProductName
ORDER BY c.CompanyName


6 - Hubspot Bulk Update
236
SELECT
	c.CustomerID as 'Volusion ID'
	, COUNT(o.OrderID) as 'Order Count'
	, CONVERT(varchar, MIN(o.OrderDate), 101) as 'Order Date First'
	, CONVERT(varchar, MAX(o.OrderDate), 101) as 'Order Date Last'
	, c.AccessKey as 'Access Key'
	, c.SalesRep_CustomerID as 'Account Rep'
	, c.CompanyName as 'Company Name'
	, c.FirstName as 'First Name'
	, c.LastName as 'Last Name'
	, c.BillingAddress1 as 'Street Address'
	, c.BillingAddress2 as 'Street Address 2'
	, c.City as 'City'
	, c.State as 'State/Region'
	, c.PostalCode as 'Postal Code'
	, c.Country as 'Country'
	, c.PhoneNumber as 'Phone Number'
	, c.EmailAddress as 'Email'
	, c.FaxNumber as 'Fax Number'
	, c.WebsiteAddress as 'Website URL'
	, CONVERT(varchar, c.LastModified, 101) as 'Volusion Last Modified Date'
	, c.Custom_Field_Industry as 'Industry'
	, SUM(o.PaymentAmount) AS 'Total Payment Amount'
	, COUNT(DISTINCT o.OrderDate) AS 'Order Count by Date'
	, SUM(o.PaymentAmount)/COUNT(o.OrderID) AS 'Average Payment Amount'
	, DATEDIFF(d,MIN(o.OrderDate),MAX(o.OrderDate)) AS 'Days as a Customer'
	, DATEDIFF(d,MIN(o.OrderDate),MAX(o.OrderDate))/COUNT(DISTINCT o.OrderDate) AS 'Average Days between Orders'
	, MAX(OrderDate) AS 'Last Order Date'
	, DATEDIFF(d,MAX(o.OrderDate),GETDATE()) AS 'Days since Last Order'
	, DATEDIFF(d,DATEDIFF(d,MIN(o.OrderDate),MAX(o.OrderDate))/COUNT(DISTINCT o.OrderDate),DATEDIFF(d,MAX(o.OrderDate),GETDATE())) AS 'Days Overdue based on Average'
FROM Customers AS c 
LEFT JOIN Orders AS o
	ON c.CustomerID = o.CustomerID
WHERE c.CustomerID >= 23
AND c.CustomerID <> 24
AND o.Orderstatus <> 'cancelled'
AND c.AccessKey <> 'A'
AND c.EmailAddress NOT LIKE '%@marketplace.amazon.com'
AND (c.Country <> '' OR c.Country IS NOT NULL)
GROUP BY 
	c.CustomerID
	, c.AccessKey
	, c.SalesRep_CustomerID
	, c.CompanyName
	, c.FirstName
	, c.LastName
	, c.BillingAddress1
	, c.BillingAddress2
	, c.City
	, c.State
	, c.PostalCode
	, c.Country
	, c.PhoneNumber
	, c.EmailAddress
	, c.FaxNumber
	, c.WebsiteAddress
	, c.FirstDateVisited
	, c.LastLogin
	, c.LastModified
	, c.Custom_Field_Industry
HAVING Count(o.OrderID) <> '0'
ORDER BY c.CustomerID ASC


Reports - Weekly Product Sales - 2 (Specify Range)
237
SELECT
	od.ProductCode
	, od.ProductName
	, SUM(od.Quantity) AS 'Quantity'
	, SUM(od.TotalPrice) AS 'Total Income'
	, ISNULL(SUM(rma.RMAI_Quantity),0) AS 'Quantity Returned'
FROM Orders AS o 
LEFT JOIN OrderDetails AS od
	ON o.OrderID = od.OrderID
LEFT JOIN RMA_Items AS rma
	ON od.RMAI_ID = rma.RMAI_ID
LEFT JOIN Customers AS c
	ON o.CustomerID = c.CustomerID
WHERE o.Orderstatus <> 'cancelled'
AND o.OrderDate BETWEEN '1/1/2016 0:00' AND '5/21/2016 23:59'
AND c.EmailAddress NOT LIKE '%@marketplace.amazon.com'
GROUP BY 
	od.ProductCode
ORDER BY od.ProductCode ASC


Unused - Unyfy Sales
238
SELECT
	o.OrderDate
	, c.CustomerID
	, c.CompanyName
	, c.FirstName
	, c.LastName
	, c.EmailAddress
	, o.OrderID
	, od.ProductCode
	, od.ProductName
	, od.Quantity
	, od.TotalPrice
	, o.SalesRep_CustomerID
FROM Orders AS o
LEFT JOIN Customers AS c 
	ON c.CustomerID = o.CustomerID
LEFT JOIN OrderDetails AS od
	ON o.OrderID = od.OrderID
WHERE c.CustomerID >= 23
AND c.CustomerID <> 24
AND o.Orderstatus <> 'cancelled'
AND c.AccessKey <> 'A'
AND o.OrderDate BETWEEN '1/1/2015 0:00' AND '12/31/2016 23:59'
AND (od.ProductCode LIKE 'UC%' OR od.ProductCode LIKE '%Unyfy%'OR od.ProductCode LIKE '%UCT%')
GROUP BY
	o.OrderDate
	, c.CustomerID
	, c.CompanyName
	, c.FirstName
	, c.LastName
	, c.EmailAddress
	, o.OrderID
	, od.ProductCode
	, od.ProductName
	, od.Quantity
	, od.TotalPrice
	, o.SalesRep_CustomerID
ORDER BY o.OrderDate ASC


Edits - Sales Rep ID Correction (Nulls)
240
SELECT
	c.CustomerID
	, c.FirstName
	, c.LastName
	, c.CompanyName
	, c.EmailAddress
	, c.SalesRep_CustomerID
	, o.SalesRep_CustomerID
FROM Customers as c
LEFT JOIN Orders AS o
	ON c.CustomerID = o.CustomerID
WHERE o.CustomerID >= 23
AND o.CustomerID <> 24
AND c.AccessKey <> 'A'
AND c.EmailAddress NOT LIKE '%@marketplace.amazon.com'
AND c.SalesRep_CustomerID IS NULL
GROUP BY
	c.CustomerID
	, c.FirstName
	, c.LastName
	, c.CompanyName
	, c.EmailAddress
	, c.SalesRep_CustomerID
	, o.SalesRep_CustomerID
HAVING Count(o.OrderID) <> '0'
ORDER BY c.SalesRep_CustomerID, c.CustomerID ASC

JM - PA Sales Tax Report - 2
244
SELECT
	o.OrderID
	, o.OrderDate
	, o.Orderstatus
	, c.CustomerID
	, o.SalesRep_CustomerID
	, c.CompanyName
	, (c.FirstName + ' ' + c.LastName) AS 'Customer Name'
	, c.PaysStateTax
	, c.TaxID
	, o.ShipAddress1
	, o.ShipAddress2
	, o.ShipCity
	, o.ShipState
	, o.ShipPostalCode
	, (o.PaymentAmount - isnull(o.SalesTax1,0) - isnull(o.SalesTax2,0) - isnull(o.SalesTax3,0)) AS 'Subtotal'
	, (isnull(o.SalesTaxRate1,0) + isnull(o.SalesTaxRate2,0) + isnull(o.SalesTaxRate3,0)) AS 'Sales Tax Rate'
	, (isnull(o.SalesTax1,0) + isnull(o.SalesTax2,0) + isnull(o.SalesTax3,0)) AS 'Sales Tax'
FROM Orders AS o
LEFT JOIN Customers AS c 
	ON c.CustomerID = o.CustomerID
WHERE 
	o.ShipState = 'PA'
	AND o.Orderstatus <> 'cancelled'
	AND (isnull(o.SalesTax1,0) + isnull(o.SalesTax2,0) + isnull(o.SalesTax3,0)) = 0
	AND c.EmailAddress NOT LIKE '%@marketplace.amazon.com'
	AND (o.PaymentAmount - isnull(o.SalesTax1,0) - isnull(o.SalesTax2,0) - isnull(o.SalesTax3,0)) <> 0
	AND o.OrderDate BETWEEN '1/1/2013 0:00' AND '12/31/2015 23:59'
GROUP BY 
	o.OrderID
	, o.OrderDate
	, o.Orderstatus
	, c.CustomerID
	, o.SalesRep_CustomerID
	, c.CompanyName
	, (c.FirstName + ' ' + c.LastName)
	, c.PaysStateTax
	, c.TaxID
	, o.ShipAddress1
	, o.ShipAddress2
	, o.ShipCity
	, o.ShipState
	, o.ShipPostalCode
	, o.PaymentAmount
	, o.SalesTax1
	, o.SalesTax2
	, o.SalesTax3
	, o.SalesTaxRate1
	, o.SalesTaxRate2
	, o.SalesTaxRate3
ORDER BY o.OrderID ASC


JM - Acctivate - Products
246
SELECT
	p.Vendor_PartNo AS 'Product ID'
	, p.UPC_code AS 'UPC Code'
	, p.ProductCode AS 'Alt Product ID'
	, p.ProductDescriptionShort AS 'Description'
	, p.HideProduct AS 'Active'
	, '' AS 'Control Type'
	, '' AS 'Product Class'
	, '' AS 'Product Type'
	, '' AS 'Item Type'
	, '' As 'Unit'
	, p.ListPrice AS 'List Price'
	, p.Vendor_PartNo AS 'Vendor Product ID'
	, p.ProductManufacturer AS 'Vendor Name'
	, p.Vendor_Price AS 'Unit Cost'
	, '' AS 'Cost Method'
	, '' AS 'Qty On Hand'
FROM 
	Products_joined As p
GROUP BY
	p.Vendor_PartNo
	, p.UPC_code
	, p.ProductCode
	, p.ProductDescriptionShort
	, p.HideProduct
	, p.ListPrice
	, p.ProductManufacturer
	, p.Vendor_Price
ORDER BY p.ProductManufacturer ASC


JM - Acctivate - Customers
247
SELECT
	c.CustomerID AS 'Customer ID'
	, c.CompanyName AS 'CompanyName'
	, c.FirstName AS 'First Name'
	, c.LastName AS 'Last Name'
	, c.BillingAddress1 AS 'Address 1'
	, c.BillingAddress2 AS 'Address 2'
	, c.City AS 'City'
	, c.State AS 'State'
	, c.PostalCode AS 'Zip'
	, c.Country AS 'Country'
	, c.PhoneNumber AS 'Phone'
	, c.FaxNumber AS 'Fax'
	, c.EmailAddress AS 'Email'
	, c.PaysStateTax AS 'Tax Code ID'
	, c.TaxID AS 'Tax Exemption'
	, c.AccessKey AS 'Customer Type'
	, c.SalesRep_CustomerID AS 'Salesperson ID'
FROM 
	Customers AS c
GROUP BY
	c.CustomerID
	, c.CompanyName
	, c.FirstName
	, c.LastName
	, c.BillingAddress1
	, c.BillingAddress2
	, c.City
	, c.State
	, c.PostalCode
	, c.Country
	, c.PhoneNumber
	, c.FaxNumber
	, c.EmailAddress
	, c.PaysStateTax
	, c.TaxID
	, c.AccessKey
	, c.SalesRep_CustomerID
ORDER BY c.CustomerID ASC

248
Reports - Profitability Review
SELECT
	p.ProductCode
	, p.ProductName
	, p.Vendor_Price AS 'Cost'
	, p.ProductPrice AS 'Price'
	, p.ProductPrice - p.Vendor_Price AS 'Profit'
	, (p.ProductPrice - ISNULL(p.Vendor_Price,0)) / ISNULL(p.ProductPrice,1) AS 'Current Margin'
	, ROUND((p.Vendor_Price / 0.85),2) AS '15% Margin'
	, '' AS 'MAP'
	, '' AS 'Google Shopping'
	, '' AS 'Amazon'
FROM 
	Products_joined As p
WHERE 
	p.ProductPrice <> '0'
	AND p.ProductPrice IS NOT NULL
	AND p.Vendor_Price <> '0'
	AND p.Vendor_Price IS NOT NULL
	AND p.ProductPrice - p.Vendor_Price > 0
	AND p.ProductCode NOT LIKE 'Zoom-%'
	AND p.ProductCode NOT LIKE 'VTL-IPanel-%'
	AND p.ProductCode NOT LIKE 'Lync-1-%'
	AND p.ProductCode NOT LIKE 'CRS-LYNC-Video-Conferencing-%'
	AND p.ProductCode NOT LIKE 'CRS-KIT-CONF-%'
	AND p.ProductNAME NOT LIKE 'TurboMeeting%'
	AND p.ProductNAME NOT LIKE 'Konftel%'
	AND p.ProductNAME NOT LIKE 'telyHD%'
	AND p.ProductNAME NOT LIKE 'Marpac'
	AND p.ProductCode NOT LIKE '%B-Stock%'
	AND p.ProductCode NOT LIKE '%Demo%'
	AND p.ProductCode <> 'HP-AIR-BK-1'
	AND p.ProductCode <> 'AIV-1000-STK'
	AND p.ProductCode <> 'AIP-ID-1000'
	AND p.ProductCode <> 'AIP-ID-800'
	AND p.ProductCode <> 'R9805594'
	AND p.ProductCode <> 'R9805595'
	AND p.ProductCode <> 'TPMC-4SM'
	AND p.ProductCode <> 'AM-100'
	AND p.ProductCode NOT LIKE 'CRS%'
	AND p.ProductName NOT LIKE 'PTZOptics%'
	AND p.ProductName NOT LIKE 'HuddleCam%'
	AND p.ProductName NOT LIKE 'Gefen%'
	AND p.ProductName NOT LIKE 'Havavision%'
	AND p.ProductName NOT LIKE 'HuddlePod%'
	AND p.ProductCode <> 'NUC-i5-(DC53427HYE)'
	AND p.ProductCode <> '960-000982'
	AND p.ProductCode <> '920003070'
	AND p.ProductCode <> '7200-64680-001'
	AND p.ProductCode <> '2200-17900-001'
	AND p.ProductCode <> 'SLRM16AI'
	AND p.ProductName NOT LIKE '%Rocosoft%'
	AND p.ProductCode <> 'JU-CB0711-S1'
	AND p.ProductName NOT LIKE 'VDO360'
	AND p.ProductCode <> 'VMix-Go-Jr'
	AND p.ProductCode <> 'VMix-Thunder'
	AND p.ProductCode <> 'R9861005NA'
	AND p.ProductCode <> 'R9861008'
	AND p.ProductCode <> 'ERM-1001'
	AND p.ProductCode NOT LIKE 'kubi-%'
GROUP BY
	p.ProductCode
	, p.ProductName
	, p.Vendor_Price
	, p.ProductPrice
ORDER BY 
	p.ProductCode ASC

249
Reports - Dealer List Basic
SELECT
	c.CompanyName
	, c.FirstName + ' ' + c.LastName AS 'Customer Name'
	, c.EmailAddress
FROM Orders AS o
LEFT JOIN Customers AS c 
	ON c.CustomerID = o.CustomerID
WHERE o.Orderstatus <> 'cancelled'
AND o.Orderstatus <> 'returned'
AND c.CustomerID >= 23
AND c.CustomerID <> 24
AND c.CustomerID <> 26
AND c.CustomerID <> 177
AND c.AccessKey <> 'A'
AND (c.EmailAddress LIKE '%7distribution.com'
	OR c.EmailAddress LIKE '%abs-tech.com'
	OR c.EmailAddress LIKE '%academictechinc.com'
	OR c.EmailAddress LIKE '%adslv.com'
	OR c.EmailAddress LIKE '%admteknologi.com'
	OR c.EmailAddress LIKE '%advanced-inc.com'
	OR c.EmailAddress LIKE '%ats-av.com'
	OR c.EmailAddress LIKE '%affinitechinc.com'
	OR c.EmailAddress LIKE '%agrity.com.my'
	OR c.EmailAddress LIKE '%alltec.co.il'
	OR c.EmailAddress LIKE '%amazingtech.solutions'
	OR c.EmailAddress LIKE '%amelation.com'
	OR c.EmailAddress LIKE '%aselcom.cr'
	OR c.EmailAddress LIKE '%atpsystemsav.com'
	OR c.EmailAddress LIKE '%a-v-c.com'
	OR c.EmailAddress LIKE '%audiovideopr.com'
	OR c.EmailAddress LIKE '%mig-avc.com'
	OR c.EmailAddress LIKE '%avisystems.com'
	OR c.EmailAddress LIKE '%azure-ds.com'
	OR c.EmailAddress LIKE '%batipi.com'
	OR c.EmailAddress LIKE '%bluewatertech.com '
	OR c.EmailAddress LIKE '%belectriccorp.com'
	OR c.EmailAddress LIKE '%broadcast-tech.com'
	OR c.EmailAddress LIKE '%cve.com'
	OR c.EmailAddress LIKE '%camperio.net'
	OR c.EmailAddress LIKE '%caribtechsol.com'
	OR c.EmailAddress LIKE '%cartersav.com'
	OR c.EmailAddress LIKE '%casaplex.com'
	OR c.EmailAddress LIKE '%ccssouthwest.com '
	OR c.EmailAddress LIKE '%ccssoutheast.com'
	OR c.EmailAddress LIKE '%ce2.at'
	OR c.EmailAddress LIKE '%cerge.com'
	OR c.EmailAddress LIKE '%clarktechnologies.com'
	OR c.EmailAddress LIKE '%getclearav.co.uk'
	OR c.EmailAddress LIKE '%collaborationsolutions.com'
	OR c.EmailAddress LIKE '%colortone-av.com'
	OR c.EmailAddress LIKE '%commlinkav.com'
	OR c.EmailAddress LIKE '%commav.net'
	OR c.EmailAddress LIKE '%computerworldslu.com'
	OR c.EmailAddress LIKE '%conferencetech.com'
	OR c.EmailAddress LIKE '%cp-vision.at'
	OR c.EmailAddress LIKE '%crisptelecom.us'
	OR c.EmailAddress LIKE '%dg-av.com'
	OR c.EmailAddress LIKE '%digarts.com'
	OR c.EmailAddress LIKE '%adigitalhome.com'
	OR c.EmailAddress LIKE '%disk.cz'
	OR c.EmailAddress LIKE '%dreamtech.com.ua'
	OR c.EmailAddress LIKE '%easymeeting.net'
	OR c.EmailAddress LIKE '%elvia.cz'
	OR c.EmailAddress LIKE '%encompassmedia.net'
	OR c.EmailAddress LIKE '%ezpyramid.com'
	OR c.EmailAddress LIKE '%featherstonmedia.com'
	OR c.EmailAddress LIKE '%featpresav.com'
	OR c.EmailAddress LIKE '%ftx.ee'
	OR c.EmailAddress LIKE '%gnode.mx'
	OR c.EmailAddress LIKE '%networkparamedics.com'
	OR c.EmailAddress LIKE '%gofacing.com'
	OR c.EmailAddress LIKE '%hbcommunications.com'
	OR c.EmailAddress LIKE '%hefservices.com'
	OR c.EmailAddress LIKE '%hitechavs.com'
	OR c.EmailAddress LIKE '%highbitsav.com'
	OR c.EmailAddress LIKE '%iled.co.za'
	OR c.EmailAddress LIKE '%innotouch.net'
	OR c.EmailAddress LIKE '%integratedmultimediasolutions.com'
	OR c.EmailAddress LIKE '%intercadsys.com'
	OR c.EmailAddress LIKE '%intuitivecomminc.com'
	OR c.EmailAddress LIKE '%iqsystems.com.ec'
	OR c.EmailAddress LIKE '%verizon.net '
	OR c.EmailAddress LIKE '%it1.com'
	OR c.EmailAddress LIKE '%ivs-tec.com'
	OR c.EmailAddress LIKE '%jsav.com'
	OR c.EmailAddress LIKE '%jtjti.com'
	OR c.EmailAddress LIKE '%karshathoughts.com'
	OR c.EmailAddress LIKE '%kingsystemsllc.com'
	OR c.EmailAddress LIKE '%limasound.com'
	OR c.EmailAddress LIKE '%lookeasy.asia'
	OR c.EmailAddress LIKE '%ltt.com.pl'
	OR c.EmailAddress LIKE '%m3techgroup.com'
	OR c.EmailAddress LIKE '%madisontech.com.au'
	OR c.EmailAddress LIKE '%tbaytel.ne'
	OR c.EmailAddress LIKE '%gomediatech.com'
	OR c.EmailAddress LIKE '%medvisionusa.com'
	OR c.EmailAddress LIKE '%meineketv.com'
	OR c.EmailAddress LIKE '%midtownvideo.com'
	OR c.EmailAddress LIKE '%milestoneproductions.ie'
	OR c.EmailAddress LIKE '%momentumsound.com'
	OR c.EmailAddress LIKE '%msomcomm.com'
	OR c.EmailAddress LIKE '%multi-systems.com'
	OR c.EmailAddress LIKE '%mysherpa.com'
	OR c.EmailAddress LIKE '%natheatrix.com'
	OR c.EmailAddress LIKE '%northlandss.com'
	OR c.EmailAddress LIKE '%itshappeningrightnow.com'
	OR c.EmailAddress LIKE '%nyherji.is'
	OR c.EmailAddress LIKE '%officeplusuae.com'
	OR c.EmailAddress LIKE '%opennetworks.com'
	OR c.EmailAddress LIKE '%osmetro.com'
	OR c.EmailAddress LIKE '%opta.kiev.ua'
	OR c.EmailAddress LIKE '%performancecom.net'
	OR c.EmailAddress LIKE '%perftechman.com'
	OR c.EmailAddress LIKE '%perlmutterpurchasing.com'
	OR c.EmailAddress LIKE '%pixelpro.com.tr'
	OR c.EmailAddress LIKE '%chasethebracelet.com'
	OR c.EmailAddress LIKE '%praxis8.com'
	OR c.EmailAddress LIKE '%prosound.net'
	OR c.EmailAddress LIKE '%provector.dk'
	OR c.EmailAddress LIKE '%provav.com'
	OR c.EmailAddress LIKE '%rbccable.com'
	OR c.EmailAddress LIKE '%resolution-av.co.nz'
	OR c.EmailAddress LIKE '%slproductions.us'
	OR c.EmailAddress LIKE '%shi.com'
	OR c.EmailAddress LIKE '%sidewalktech.com'
	OR c.EmailAddress LIKE '%siscocorp.com'
	OR c.EmailAddress LIKE '%slickcybersystems.com'
	OR c.EmailAddress LIKE '%smartglobal.es'
	OR c.EmailAddress LIKE '%shisystems.com'
	OR c.EmailAddress LIKE '%streamportmedia.com'
	OR c.EmailAddress LIKE '%syncomation.com'
	OR c.EmailAddress LIKE '%sysquo.com'
	OR c.EmailAddress LIKE '%sys-dsn.com'
	OR c.EmailAddress LIKE '%tymc.co.kr'
	OR c.EmailAddress LIKE '%TCCOhio.com'
	OR c.EmailAddress LIKE '%tech-integ.com'
	OR c.EmailAddress LIKE '%tvg.mx'
	OR c.EmailAddress LIKE '%telesmart.co.nz'
	OR c.EmailAddress LIKE '%theavgroup.com'
	OR c.EmailAddress LIKE '%tirusvoice.com'
	OR c.EmailAddress LIKE '%triag.us'
	OR c.EmailAddress LIKE '%tsi-global.com '
	OR c.EmailAddress LIKE '%videolink.ca'
	OR c.EmailAddress LIKE '%visualgate.cz'
	OR c.EmailAddress LIKE '%vmivideo.com'
	OR c.EmailAddress LIKE '%voxelvision.com.tw'
	OR c.EmailAddress LIKE '%whitlock.com'
	OR c.EmailAddress LIKE '%wintech-inc.com'
	OR c.EmailAddress LIKE '%wisewaysupply.com'
	OR c.EmailAddress LIKE '%worldofsoundnc.com'
	OR c.EmailAddress LIKE '%csproducts.com'
	OR c.EmailAddress LIKE '%hdvparts.com'
	OR c.EmailAddress LIKE '%gaeltek.com'
	OR c.EmailAddress LIKE '%veytec.com'
	OR c.EmailAddress LIKE '%precisionmultimedia.com'
	OR c.EmailAddress LIKE '%mcwsolutions.net'
	OR c.EmailAddress LIKE '%uniguest.com'
	OR c.EmailAddress LIKE '%tnpbroadcast.co.uk'
	OR c.EmailAddress LIKE '%cyberfish.ch'
	OR c.EmailAddress LIKE '%sonopro.pt'
	OR c.EmailAddress LIKE '%vpintegral.com'
	OR c.EmailAddress LIKE '%tsicolumbus.com'
	OR c.EmailAddress LIKE '%jgcomm.net'
	OR c.EmailAddress LIKE '%88veterans.com'
	OR c.EmailAddress LIKE '%avworx.net'
	OR c.EmailAddress LIKE '%novasud.com'
	OR c.EmailAddress LIKE '%streamlinesystemsltd.com'
	OR c.EmailAddress LIKE '%avims.net'
	OR c.EmailAddress LIKE '%scharfindustries.com'
	OR c.EmailAddress LIKE '%pro-media.at'
	OR c.EmailAddress LIKE '%austinav.com'
	OR c.EmailAddress LIKE '%threeriversvideo.com'
	OR c.EmailAddress LIKE '%riole.com.br'
	OR c.EmailAddress LIKE '%braca.nl'
	OR c.EmailAddress LIKE '%bcpi.com'
	OR c.EmailAddress LIKE '%acvideosolutions.com'
	OR c.EmailAddress LIKE '%adminmonitor.com'
	OR c.EmailAddress LIKE '%bizco.com'
	OR c.EmailAddress LIKE '%uldwc.com'
	OR c.EmailAddress LIKE '%xciteav.com'
	OR c.EmailAddress LIKE '%clnik.com'
	OR c.EmailAddress LIKE '%blueorange.com.sg'
	OR c.EmailAddress LIKE '%cubsinc.com'
	OR c.EmailAddress LIKE '%abi-com.com'
	OR c.EmailAddress LIKE '%bacomputersolutions.com'
	OR c.EmailAddress LIKE '%one-eye.nl'
	OR c.EmailAddress LIKE '%atea.dk'
	OR c.EmailAddress LIKE '%avsolutionsinc.net'
	OR c.EmailAddress LIKE '%allied-audio.com'
	OR c.EmailAddress LIKE '%streamspot.com'
	OR c.EmailAddress LIKE '%avrduluth.com'
	OR c.EmailAddress LIKE '%idb.com.vn'
	OR c.EmailAddress LIKE '%tcicomm.com'
	OR c.EmailAddress LIKE '%dakotech.net'
	OR c.EmailAddress LIKE '%customcontrol.mx'
	OR c.EmailAddress LIKE '%linesbroadcast.nl'
	OR c.EmailAddress LIKE '%avconusa.com'
	OR c.EmailAddress LIKE '%inavate-av.com'
	OR c.EmailAddress LIKE '%HorizonAVS.com'
	OR c.EmailAddress LIKE '%koncerted.com'
	OR c.EmailAddress LIKE '%telindus.lu'
	OR c.EmailAddress LIKE '%skelectronics.net'
	OR c.EmailAddress LIKE '%techexport.com'
	OR c.EmailAddress LIKE '%audioarte-bg.com'
	OR c.EmailAddress LIKE '%plugged-records.com'
	OR c.EmailAddress = 'manbina68@gmail.com'
	OR c.EmailAddress = 'digitalintegrationdesign@gmail.com'
	OR c.EmailAddress = 'garonsav@gmail.com'
	OR c.EmailAddress = 'geminiaudio@gmail.com'
	OR c.EmailAddress = 'dyerj205@gmail.com'
	OR c.EmailAddress = 'kw2sales@gmail.com'
	OR c.EmailAddress = 'lisakwood@hotmail.com'
	OR c.EmailAddress = 'jimrob1@hotmail.com'
	OR c.EmailAddress = 'audiochef@aol.com'
	OR c.EmailAddress = 'magnoliamusic@bellsouth.net')
AND o.OrderDate BETWEEN '1/1/2014 0:00' AND '12/31/2016 23:59'
GROUP BY 
	c.CompanyName
	, c.FirstName
	, c.LastName
	, c.EmailAddress
ORDER BY c.CompanyName


Edits - Rep ID Change
252
SELECT
	c.EmailAddress
	, c.SalesRep_CustomerID AS 'Account Rep'
	, '' AS 'HubSpot Owner'
FROM Orders AS o 
LEFT JOIN Customers AS c
	ON o.CustomerID = c.CustomerID
WHERE (c.SalesRep_CustomerID = 11
	OR c.SalesRep_CustomerID = 177)
AND c.EmailAddress NOT LIKE '%@marketplace.amazon.com'
GROUP BY 
	c.EmailAddress
	, c.SalesRep_CustomerID
ORDER BY c.EmailAddress ASC


Reports - Product Sales Totals (Specify Dates)
253
SELECT
	p.ProductCode
	, p.ProductName
	, COUNT(ISNULL(od.OrderDetailID,0)) AS 'Order Count'
	, COUNT(DISTINCT ISNULL(o.CustomerID,0)) AS 'Customer Count'
	, SUM(ISNULL(od.Quantity,0)) AS 'Quantity Sold'
	, SUM(ISNULL(od.TotalPrice,0)) AS 'Revenue'
FROM
	Products_joined As p
LEFT JOIN OrderDetails AS od
	ON p.ProductCode = od.ProductCode
LEFT JOIN Orders AS o
	ON o.OrderID = od.OrderID
LEFT JOIN Customers AS c 
	ON c.CustomerID = o.CustomerID
WHERE c.CustomerID >= 23
AND c.CustomerID <> 24
AND o.Orderstatus <> 'cancelled'
AND o.Orderstatus <> 'returned'
AND od.RMAI_ID is null
AND c.AccessKey <> 'A'
AND c.EmailAddress NOT LIKE '%@marketplace.amazon.com'
AND o.OrderDate BETWEEN '10/6/2015 0:00' AND '10/6/2016 23:59'
GROUP BY
	p.ProductCode
	, p.ProductName
ORDER BY p.ProductName ASC


Reports - CRS Product Sales Totals (Specify Dates)
254
SELECT
	p.ProductCode
	, p.ProductName
	, p.ProductPrice
	, p.Vendor_Price
	, COUNT(ISNULL(od.OrderDetailID,0)) AS 'Order Count'
	, COUNT(DISTINCT ISNULL(o.CustomerID,0)) AS 'Customer Count'
	, SUM(ISNULL(od.Quantity,0)) AS 'Quantity Sold'
	, SUM(ISNULL(od.TotalPrice,0)) AS 'Revenue'
FROM
	Products_joined As p
LEFT JOIN OrderDetails AS od
	ON p.ProductCode = od.ProductCode
LEFT JOIN Orders AS o
	ON o.OrderID = od.OrderID
LEFT JOIN Customers AS c 
	ON c.CustomerID = o.CustomerID
WHERE c.CustomerID >= 23
AND c.CustomerID <> 24
AND o.Orderstatus <> 'cancelled'
AND o.Orderstatus <> 'returned'
AND od.RMAI_ID is null
AND c.AccessKey <> 'A'
AND c.EmailAddress NOT LIKE '%@marketplace.amazon.com'
AND o.OrderDate BETWEEN '10/6/2015 0:00' AND '10/6/2016 23:59'
AND (od.ProductCode LIKE 'CRS-VIDEO-CONFERENCING-%' 
	OR od.ProductCode LIKE 'CRS-GOOGLE-CHROMEBOX-SYSTEM' 
	OR od.ProductCode LIKE 'HUDDLECAMHD%'
	OR od.ProductCode LIKE 'HUDDLECAMHD-%' 
	OR od.ProductCode LIKE 'PTZOptics%' 
	OR od.ProductCode LIKE 'HUDDLEPOD%'
	OR od.ProductCode LIKE 'PT12X%'
	OR od.ProductCode LIKE 'PT20X%'
	OR od.ProductCode LIKE 'PT-VL%'
	OR od.ProductCode LIKE 'PT-BRDCSTR%'
	OR od.ProductCode LIKE 'HCA12X'
	OR od.ProductCode LIKE 'HCA20X%'
	OR od.ProductCode LIKE 'HCM%'
	OR od.ProductCode LIKE 'HC%X%'
	OR od.ProductCode LIKE 'HC-JOY'
	OR od.ProductCode LIKE 'HP-AIR%')
GROUP BY
	p.ProductCode
	, p.ProductName
	, p.ProductPrice
	, p.Vendor_Price
ORDER BY p.ProductName ASC

Acctivate - Product Code to Vendor Part No Translation

Select
	p.ProductCode 
	, p.Vendor_PartNo
FROM Products_Joined AS p
WHERE p.ProductCode <> p.Vendor_PartNo
GROUP BY
	p.ProductCode
	, p.Vendor_PartNo
ORDER BY p.ProductCode ASC


B-Stock List
266
Select
	p.ProductCode 
	, p.Vendor_PartNo
	, p.productdescriptionshort
	, 'Config_FullStoreURLProductDetails.asp?ProductCode=' + p.productcode + '&click=2' AS link
FROM Products_Joined AS p
WHERE p.ProductCode LIKE '%-bstk'
GROUP BY
	p.ProductCode 
	, p.Vendor_PartNo
	, p.productdescriptionshort
	, 'Config_FullStoreURLProductDetails.asp?ProductCode=' + p.productcode + '&click=2'
ORDER BY p.ProductCode


Unused - Shure MVi Project - 1
276
SELECT
	od.ProductCode
	, od.ProductName
	, SUM(od.Quantity) AS Quantity
	, SUM(od.TotalPrice) AS TotalPrice
FROM Orders AS o
LEFT JOIN Customers AS c 
	ON c.CustomerID = o.CustomerID
LEFT JOIN OrderDetails AS od
	ON o.OrderID = od.OrderID
WHERE c.CustomerID >= 23
AND c.CustomerID <> 24
AND o.Orderstatus <> 'cancelled'
AND c.AccessKey <> 'A'
AND o.OrderDate BETWEEN '1/1/2014 0:00' AND '12/31/2017 23:59'
AND (od.ProductCode = 'SAGOMIC' 
	OR od.ProductCode = 'SWXPD1HQ6'
	OR od.ProductCode = 'SWXPD1BLM5'
	OR od.ProductCode = 'MT201'
	OR od.ProductCode = 'MT454'
	OR od.ProductCode = 'MT454-DTI'
	OR od.ProductCode = 'MT454-DTI-PA'
	OR od.ProductCode = 'MT454-PA'
	OR od.ProductCode = 'MT454-PSTN'
	OR od.ProductCode = 'MT454-PSTN-PA'
	OR od.ProductCode = 'MT454-RVN'
	OR od.ProductCode = '999-8530-000'
	OR od.ProductCode = '999-8640-000'
	OR od.ProductCode = '999-8230-000'
	OR od.ProductCode = '999-8215-000'
	OR od.ProductCode = '999-8210-000'
	OR od.ProductCode = 'MMX-6-USB'
	OR od.ProductCode LIKE 'MT302%'
	OR od.ProductCode = 'MT201'
	OR od.ProductCode = 'MT201'
	OR od.ProductCode = 'MT201'
	OR od.ProductCode = 'MT201'
	OR od.ProductCode = 'MT201'
	OR od.ProductCode = 'MT201'
	OR od.ProductCode = 'MT201'
	OR od.ProductCode = 'MT201'
	OR od.ProductCode = 'MT201'
	OR od.ProductCode = 'MT201'
	OR od.ProductCode = 'MT201'
	OR od.ProductCode = 'MT201'
	OR od.ProductCode = 'MT201'
	OR od.ProductCode = 'MT201'
	OR od.ProductCode = 'MT201'
	OR od.ProductCode = 'MT201')
GROUP BY
	od.ProductCode
	, od.ProductName
ORDER BY od.ProductName ASC


Volusion to Magento
310
SELECT
	'admin' AS 'store'
	, 'Enabled' AS 'status'
	, 'base' AS 'websites'
	, 'default' AS 'attribute_set'
	, 'simple' AS 'type'
	, vMerchant.ufn_Get_Virtual_Columns(p.ProductID, p.ProductCode, 'CategoryIDs') AS 'category_ids'
	, p.ProductCode AS 'sku'
	, vMerchant.ufn_Get_Virtual_Columns(p.ProductID, p.ProductCode, 'OptionIDs') AS 'has_options'
	, p.ProductName AS 'name'
	, p.ProductName AS 'product_name'
	, p.METATAG_Title AS 'meta_title'
	, p.METATAG_Keywords AS 'meta_keyword'
	, p.METATAG_Description AS 'meta_description'
	, '' AS 'page_layout'
	, '' AS 'options_container'
	, '' AS 'country_of_manufacture'
	, '' AS 'msrp_enabled'
	, '' AS 'msrp_display_actual_price_type'
	, '' AS 'gift_message_available'
	, '' AS 'gift_wrapping_available'
	, p.ProductManufacturer AS 'manufacturer'
	, '' AS 'is_recurring'
	, p.HideProduct AS 'visibility'
	, p.TaxableProduct AS 'tax_class_id'
	, '' AS 'mw_storecredit'
	, '' AS 'uom_package'
	, p.ProductPrice AS 'price'
	, p.ProductWeight AS 'weight'
	, p.ProductDescription AS 'description'
	, p.ProductDescriptionShort AS 'short_description'
	, p.StockStatus AS 'qty'
	, '' AS 'min_qty'
	, '' AS 'use_config_min_qty'
	, '' AS 'is_qty_decimal'
	, p.DoNotAllowBackOrders AS 'backorders'
	, '' AS 'use_config_backorders'
	, p.MinQty AS 'min_sale_qty'
	, '' AS 'use_config_min_sale_qty'
	, p.MaxQty AS 'max_sale_qty'
	, '' AS 'use_config_max_sale_qty'
	, '' AS 'is_in_stock'
	, p.StockLowQtyAlarm AS 'use_config_notify_stock_qty'
	, '' AS 'stock_status_changed_auto'
	, '' AS 'use_config_qty_increments'
	, '' AS 'qty_increments'
	, '' AS 'use_config_enable_qty_inc'
	, '' AS 'enable_qty_increments'
	, '' AS 'is_decimal_divided'
	, '' AS 'stock_status_changed_automatically'
	, '' AS 'use_config_enable_qty_increments'
	, '' AS 'store_id'
	, 'simple' AS 'product_type_id'
FROM Products_joined As p
GROUP BY 	
	vMerchant.ufn_Get_Virtual_Columns(p.ProductID, p.ProductCode, 'CategoryIDs')
	, p.ProductCode
	, vMerchant.ufn_Get_Virtual_Columns(p.ProductID, p.ProductCode, 'OptionIDs')
	, p.ProductName
	, p.METATAG_Title
	, p.METATAG_Keywords
	, p.METATAG_Description
	, p.ProductManufacturer
	, p.HideProduct
	, p.TaxableProduct
	, p.ProductPrice
	, p.ProductWeight
	, p.ProductDescription
	, p.ProductDescriptionShort 
	, p.StockStatus
	, p.DoNotAllowBackOrders
	, p.MinQty
	, p.MaxQty
	, p.StockLowQtyAlarm
ORDER BY p.productname


Volusion to Magento - Supplement
320
SELECT 
	Products_Joined.ProductCode, 
	Products_Joined.Vendor_PartNo, 
	Products_Joined.WarehouseCustom, 
	Products_Joined.UPC_code, 
	Products_Joined.ListPrice, 
	Products_Joined.SalePrice, 
	Products_Joined.Availability, 
	Products_Joined.Fixed_ShippingCost, 
	Products_Joined.warehouses, 
	Products_Joined.AddtoCartBtn_Replacement_Text, 
	Products_Joined.ProductCondition, 
	Products_Joined.CustomField1, 
	Products_Joined.CustomField2, 
	Products_Joined.CustomField3, 
	Products_Joined.CustomField4, 
	Products_Joined.CustomField5, 
	Products_Joined.Vendor_Price, 
	Products_Joined.Google_Product_Category, 
	Products_Joined.Google_Availability,
	Products_Joined.TechSpecs
FROM Products_Joined WITH (NOLOCK) 
ORDER BY Products_Joined.ProductCode


Reports - CC Orders with No Capture in Last 30 Days
326
SELECT
	o.SalesRep_CustomerID
	, c.CustomerID
	, c.EmailAddress
	, (c.FirstName + ' ' + c.LastName) AS 'Customer Name'
	, o.OrderID
	, o.OrderDate
	, MIN(o.ShipDate) AS 'ShipDate'
	, o.OrderStatus
	, o.PaymentAmount
	, DATEADD(day,30,MIN(pl.pay_authdate)) AS 'Last Day to Capture'
	, '' AS 'Notes'
FROM Orders AS o
LEFT JOIN Customers AS c 
	ON c.CustomerID = o.CustomerID
LEFT JOIN Payment_Log AS pl 
	ON o.OrderID = pl.pay_orderid
LEFT JOIN PaymentMethods AS pm
	ON pl.pay_paymentmethodid = pm.paymentmethodid
WHERE pl.pay_paymentmethodid >= 5
	AND pl.pay_paymentmethodid <=8
	AND pl.pay_result = 'AUTHORIZE'
	AND o.Orderstatus <> 'cancelled'
	AND o.Orderstatus <> 'Returned'
	AND o.PaymentAmount <> o.Total_Payment_Received
	AND o.OrderNotes NOT LIKE '%non-capture%'
	AND o.Order_Comments NOT LIKE '%non-capture%'
GROUP BY
	o.OrderID
	, c.CustomerID
	, c.EmailAddress
	, (c.FirstName + ' ' + c.LastName)
	, o.SalesRep_CustomerID
	, o.OrderDate
	, o.OrderStatus
	, o.PaymentAmount
	, pl.pay_authdate
HAVING
	MIN(pl.pay_authdate) >= DATEADD(day,-30,GETDATE())
ORDER BY
	o.SalesRep_CustomerID, o.OrderDate
ASC;


Reports - CC Orders with No Capture in Between 31 and 90 Days
327
SELECT
	o.SalesRep_CustomerID
	, c.CustomerID
	, c.EmailAddress
	, (c.FirstName + ' ' + c.LastName) AS 'Customer Name'
	, o.OrderID
	, o.OrderDate
	, MIN(o.ShipDate) AS 'ShipDate'
	, o.OrderStatus
	, o.PaymentAmount
	, DATEADD(day,30,MIN(pl.pay_authdate)) AS 'Last Day to Capture'
	, '' AS 'Notes'
FROM Orders AS o
LEFT JOIN Customers AS c 
	ON c.CustomerID = o.CustomerID
LEFT JOIN Payment_Log AS pl 
	ON o.OrderID = pl.pay_orderid
LEFT JOIN PaymentMethods AS pm
	ON pl.pay_paymentmethodid = pm.paymentmethodid
WHERE pl.pay_paymentmethodid >= 5
	AND pl.pay_paymentmethodid <=8
	AND pl.pay_result = 'AUTHORIZE'
	AND o.Orderstatus <> 'cancelled'
	AND o.Orderstatus <> 'Returned'
	AND o.PaymentAmount <> o.Total_Payment_Received
	AND o.OrderNotes NOT LIKE '%non-capture%'
	AND o.Order_Comments NOT LIKE '%non-capture%'
GROUP BY
	o.OrderID
	, c.CustomerID
	, c.EmailAddress
	, (c.FirstName + ' ' + c.LastName)
	, o.SalesRep_CustomerID
	, o.OrderDate
	, o.OrderStatus
	, o.PaymentAmount
	, pl.pay_authdate
HAVING
	MIN(pl.pay_authdate) <= DATEADD(day,-31,GETDATE())
	AND MIN(pl.pay_authdate) >= DATEADD(day,-90,GETDATE())
ORDER BY
	o.SalesRep_CustomerID, o.OrderDate
ASC;


Edits - Products with null availability
328
SELECT
	p.ProductName
	, p.ProductCode
	, p.Availability
FROM Products_joined As p
LEFT JOIN vmerchant.products_joined pp ON p.ischildofproductcode = pp.productcode
	WHERE p.Availability IS NULL
GROUP BY
	p.ProductName
	, p.ProductCode
	, p.Availability
ORDER BY p.ProductName DESC
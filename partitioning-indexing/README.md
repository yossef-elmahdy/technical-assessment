# Partitioning and Indexing
After creation of the cleaned table and the data warehous tables, it is time to choose optimal strategies of partitioning and indexing these tables to optimize data retrieval performance.

## `online_retail_sales` 
### Partitioning Strategy 
- Partition type: Multilevel 
- Partitioned column(s): RANGE(`InvoiceDate`) >> LIST(`Country`) 
### Automated Partitioning 
- Automated: NO (#TO-DO)
- Strategy: -
### Indexing Strategy 
- Block Range Index (BRIN): 
    - `InvoiceDate`
- Non-Clustered Balanced Tree (BTREE): 
    - `InvoiceNo`
    - `InvoiceNo` and `Quantity`
    - `InvoiceNo` and `UnitPrice`
    - `InvoiceNo`, `Quantity` and `UnitPrice`
    - `StockCode`
    #### Before Partitioning/Indexing
    ![online_retail_sales_before](https://github.com/yossef-elmahdy/technical-assessment/blob/main/partitioning-indexing/online_retail_sales/Before.png)

    #### After Partitioning/Indexing
    ![online_retail_sales_after](https://github.com/yossef-elmahdy/technical-assessment/blob/main/partitioning-indexing/online_retail_sales/After.png)

## `DimDate` 
### Partitioning Strategy 
- Partition type: RANGE
- Partitioned column(s): `FullDate`
### Automated Partitioning 
- Automated: NO (#TO-DO)
- Strategy: -
### Indexing Strategy 
- Block Range Index (BRIN): 
    - `FullDate`
- Clustered Balanced Tree (BTREE):
    - `DateKey`
- Non-Clustered Balanced Tree (BTREE): 
    - `Month`
    - `Day` 
    - `Week` 
    #### Before Partitioning/Indexing
    ![DimDate_before](https://github.com/yossef-elmahdy/technical-assessment/blob/main/partitioning-indexing/DimDate/FullDate_Before.png)

    #### After Partitioning/Indexing
    ![DimDate_after](https://github.com/yossef-elmahdy/technical-assessment/blob/main/partitioning-indexing/DimDate/FullDate_Before.png)

## `DimCustomer` 
### Partitioning Strategy 
- Partition type: LIST 
- Partitioned column(s): `Country`
### Automated Partitioning 
- Automated: NO (#TO-DO)
- Strategy: -
### Indexing Strategy 
- Hash Index (HASH): 
    - `Country`
- Clustered Balanced Tree (BTREE):
    - `CustomerID`
    #### Before Partitioning/Indexing
    ![DimCustomer_before](https://github.com/yossef-elmahdy/technical-assessment/blob/main/partitioning-indexing/DimCustomer/CustomerID_Before.png)

    #### After Partitioning/Indexing
    ![DimCustomer_after](https://github.com/yossef-elmahdy/technical-assessment/blob/main/partitioning-indexing/DimCustomer/CustomerID_After.png)

## `DimProduct` 
### Partitioning Strategy 
- Partition type: LIST 
- Partitioned column(s): `StockCode`
### Automated Partitioning 
- Automated: YES 
- Strategy: When a new record is added, will automatically check the number of occurnce of this product's `StockCode` on `DimProduct` table and add a new partition if it exceeds 10. 
### Indexing Strategy 
- Clustered Balanced Tree (BTREE):
    - `UnitPrice`
- Non-Clustered Balanced Tree (BTREE): 
    - `StockCode` and `UnitPrice`
    #### Before Partitioning/Indexing
    ![DimProduct_before](https://github.com/yossef-elmahdy/technical-assessment/blob/main/partitioning-indexing/DimProduct/UnitPrice_Before.png)

    #### After Partitioning/Indexing
    ![DimProduct_after](https://github.com/yossef-elmahdy/technical-assessment/blob/main/partitioning-indexing/DimProduct/UnitPrice_After.png)

## `FactRetailSales` 
### Partitioning Strategy 
- Partition type: RANGE 
- Partitioned column(s): `InvoiceDate`
### Automated Partitioning 
- Automated: NO 
- Strategy: -
### Indexing Strategy 
- Clustered Balanced Tree (BTREE):
    - `UnitPrice`
- Non-Clustered Balanced Tree (BTREE): 
    - For better joins: 
        - `DateKey`
        - `ProductKey`
        - `CustomerKey`
    - For better filters: 
        - `Quantity`
        - `TotalLine`
        - `InvoiceDate` and `TotalLine`

    #### Before Partitioning/Indexing
    ![FactRetailSales_before]()

    #### After Partitioning/Indexing
    ![FactRetailSales_after]()

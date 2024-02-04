# Partitioning and Indexing
After creation of the cleaned table and the data warehous tables, it is time to choose optimal strategies of partitioning and indexing these tables to optimize data retrieval performance.

## `online_retail_sales` 
### Partitioning Strategy 
- Partition type: Multilevel 
- Partitioned column(s): RANGE(`InvoiceDate`) >> LIST(`Country`) 
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
### Indexing Strategy 
- Clustered Balanced Tree (BTREE):
    - `UnitPrice`
- Non-Clustered Balanced Tree (BTREE): 
    - `StockCode` and `UnitPrice`
    #### Before Partitioning/Indexing
    ![DimProduct_before](https://github.com/yossef-elmahdy/technical-assessment/blob/main/partitioning-indexing/DimProduct/UnitPrice_Before.png)

    #### After Partitioning/Indexing
    ![DimProduct_after](https://github.com/yossef-elmahdy/technical-assessment/blob/main/partitioning-indexing/DimProduct/UnitPrice_After.png)

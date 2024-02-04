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
    ![online_retail_sales_before]()

    #### After Partitioning/Indexing
    ![online_retail_sales_after]()

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
    ![DimDate_before]()

    #### After Partitioning/Indexing
    ![DimDate_after]()

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
    ![DimCustomer_before]()

    #### After Partitioning/Indexing
    ![DimCustomer_after]()

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
    ![DimProduct_before]()

    #### After Partitioning/Indexing
    ![DimProduct_after]()

# Quality and Versioning Mechanisms
At this point, we need to establish mechanisms to ensure the quality of data whenever new data is added periodically (daily, weekly, monthly, ...etc). 

Also, we need to make sure of keeping the history of the data and any changes that can happen to it, this can be achieved by ***logging*** for any creation, update, or deletion of data records. 

## Data Quality Management
We can use several methods or implementations to make sure that the quality of data is acceptable based on our defined criteria: 
1. **Implement Constraints and Checks:** As we did for our data, I've used constraints like (NOT NULL, UNIQUE, FOREIGN KEY) and other data validation checks (e.g., CHECK constraints, triggers) to enforce data quality rules at the database level. This ensures that incoming data meets predefined criteria.

2. **Regular Data Quality Checks:** Schedule regular data quality checks to monitor adherence to defined metrics and identify any anomalies or discrepancies.

3. **Data Profiling:** Use data profiling techniques to analyze your data and gain insights into its characteristics, such as value distributions, outliers, missing values, and data patterns.



## Data Versioning
It is important to keep the history of data, track any changes that happened to it, and keep the knowledge of who is responsible for these changes. This can be called ***logging***. 

We can use triggers to achieve this. 

1. **Create Versioning Tables:** Create tables to store the historical versions of your dataset. You may need separate tables for the main dataset and its historical versions.

2. **Trigger-based Approach:** Use triggers to automatically capture changes made to the main dataset table and insert them into the versioning tables.

3. **Timestamps and Metadata:** Include timestamps and metadata columns in the versioning tables to track when changes were made and by whom

### Log Table Creation 
```sql
CREATE TABLE "LOG_online_retail_cleaned" (
    version_id SERIAL PRIMARY KEY,
    "Id" BIGINT,
	"InvoiceNo" TEXT COLLATE pg_catalog."default",
    "StockCode" TEXT COLLATE pg_catalog."default",
    "Description" TEXT COLLATE pg_catalog."default",
    "Quantity" BIGINT,
    "InvoiceDate" TIMESTAMP WITHOUT TIME ZONE,
    "UnitPrice" DOUBLE PRECISION,
    "CustomerID" BIGINT,
    "Country" TEXT COLLATE pg_catalog."default",
    "CreatedAt" TIMESTAMP WITHOUT TIME ZONE,
    "UpdatedAt" TIMESTAMP WITHOUT TIME ZONE,
    "LOG_changeType" TEXT,  -- Indicates if it's an INSERT, UPDATE, or DELETE
    "LOG_userId" INT        -- ID of the user who made the change
);
```

### Evidence 
#### 1. INSERT 
![INSERT](https://github.com/yossef-elmahdy/technical-assessment/blob/main/quality-versioning-management/INSERT.png)
#### 2. UPDATE 
![UPDATE](https://github.com/yossef-elmahdy/technical-assessment/blob/main/quality-versioning-management/UPDATE.png)
#### 3. DELETE 
![DELETE](https://github.com/yossef-elmahdy/technical-assessment/blob/main/quality-versioning-management/DELETE%20.png)

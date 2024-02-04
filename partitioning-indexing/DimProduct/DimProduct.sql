-- Partitioning 
SELECT "DimProduct"."StockCode",
	COUNT(*)
FROM "DimProduct"
GROUP BY 1
ORDER BY 2 DESC

CREATE TABLE DimProduct (
    ProductKey BIGINT NOT NULL,
    StockCode TEXT COLLATE pg_catalog."default",
    Description TEXT COLLATE pg_catalog."default",
    UnitPrice DOUBLE PRECISION,
    ProductName TEXT COLLATE pg_catalog."default",
    CONSTRAINT DimProduct_pkey PRIMARY KEY (ProductKey, StockCode)
) PARTITION BY LIST (StockCode);


CREATE TABLE DimProduct_Manual PARTITION OF DimProduct
    FOR VALUES IN ('M');

CREATE TABLE DimProduct_Discount PARTITION OF DimProduct
    FOR VALUES IN ('D');

CREATE TABLE DimProduct_POST PARTITION OF DimProduct
    FOR VALUES IN ('POST');

CREATE TABLE DimProduct_DotCom PARTITION OF DimProduct
    FOR VALUES IN ('DOT');

CREATE TABLE DimProduct_CRUK PARTITION OF DimProduct
    FOR VALUES IN ('CRUK');

CREATE TABLE DimProduct_CRUK PARTITION OF DimProduct
    FOR VALUES IN ('CRUK');

CREATE TABLE DimProduct_21175 PARTITION OF DimProduct
    FOR VALUES IN ('21175');
	
CREATE TABLE DimProduct_21166 PARTITION OF DimProduct
    FOR VALUES IN ('21166');
	
CREATE TABLE DimProduct_82600 PARTITION OF DimProduct
    FOR VALUES IN ('82600');

-- Automating the process whenever a new StockCode is entered and it count exceeds 10  
CREATE OR REPLACE FUNCTION create_DimProduct_partition()
RETURNS TRIGGER AS
$$
DECLARE
    value_count INTEGER;
BEGIN
	EXECUTE format('SELECT COUNT("StockCode") FROM "DimProduct" WHERE "StockCode" = %L', NEW."StockCode"::TEXT) INTO value_count;
	
	RAISE NOTICE 'Value: %', value_count; 

    -- If the count exceeds the threshold, create a new partition and create new check 
    IF value_count > 10 THEN
        EXECUTE format('CREATE TABLE "DimProduct_%I" PARTITION OF "DimProduct" FOR VALUES IN (%L)', 
                       NEW."StockCode"::TEXT, NEW."StockCode"::TEXT);
					   
		EXECUTE format('ALTER TABLE "DimProduct_%I" ADD CONSTRAINT "%I_DimProduct_check" CHECK "StockCode" IN (%L) ', 
                       NEW."StockCode"::TEXT, NEW."StockCode"::TEXT, NEW."StockCode"::TEXT);
    END IF;

	RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER create_DimProduct_partition_trigger
BEFORE INSERT ON "DimProduct"
FOR EACH ROW
EXECUTE FUNCTION create_DimProduct_partition();

-- CREATE TABLE DimProduct (
--     ProductKey BIGINT NOT NULL,
--     StockCode TEXT COLLATE pg_catalog."default",
--     Description TEXT COLLATE pg_catalog."default",
--     UnitPrice DOUBLE PRECISION,
--     ProductName TEXT COLLATE pg_catalog."default",
--     CONSTRAINT DimProduct_pkey PRIMARY KEY (ProductKey)
-- ) PARTITION BY RANGE (UnitPrice);

-- CREATE TABLE DimProduct_low_price PARTITION OF DimProduct
--     FOR VALUES FROM (MINVALUE) TO (10);

-- CREATE TABLE DimProduct_medium_price PARTITION OF DimProduct
--     FOR VALUES FROM (10) TO (100);

-- CREATE TABLE DimProduct_high_price PARTITION OF DimProduct
--     FOR VALUES FROM (100) TO (MAXVALUE);

-- Indexing 
-- Before 
EXPLAIN ANALYZE
SELECT ROUND("UnitPrice"),
	COUNT(*)
FROM "DimProduct"
GROUP BY 1
ORDER BY 2 DESC


CREATE INDEX "CI_DimProduct_UnitPrice"
ON "DimProduct" USING BTREE ("UnitPrice");

ALTER TABLE "DimProduct"
CLUSTER ON "CI_DimProduct_UnitPrice";

CREATE INDEX "NCI_DimProduct_UnitPrice_StockCode"
ON "DimProduct" USING BTREE ("StockCode", "UnitPrice");

-- After 
EXPLAIN ANALYZE
SELECT ROUND("UnitPrice"),
	COUNT(*)
FROM "DimProduct"
GROUP BY 1
ORDER BY 2 DESC
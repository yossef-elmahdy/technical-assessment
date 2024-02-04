SELECT "Country",
	COUNT(*)
FROM "DimCustomer"
GROUP BY 1
ORDER BY 2 DESC

-- Partitioning 
CREATE TABLE IF NOT EXISTS public."DimCustomer"
(
    "CustomerKey" bigint NOT NULL,
    "CustomerID" bigint,
    "Country" text COLLATE pg_catalog."default",
    "CustomerName" text COLLATE pg_catalog."default",
    CONSTRAINT "DimCustomer_pkey" PRIMARY KEY ("CustomerKey", "Country")
)
PARTITION BY LIST("Country");

CREATE TABLE CUST_UK PARTITION OF "DimCustomer"
FOR
VALUES IN ('United Kingdom');



CREATE TABLE CUST_GER PARTITION OF "DimCustomer"
FOR
VALUES IN ('Germany');


CREATE TABLE CUST_FR PARTITION OF "DimCustomer"
FOR
VALUES IN ('France');


CREATE TABLE CUST_SP PARTITION OF "DimCustomer"
FOR
VALUES IN ('Spain');


CREATE TABLE CUST_BLG PARTITION OF "DimCustomer"
FOR
VALUES IN ('Belgium');


CREATE TABLE CUST_SWZ PARTITION OF "DimCustomer"
FOR
VALUES IN ('Switzerland');


CREATE TABLE CUST_PRG PARTITION OF "DimCustomer"
FOR
VALUES IN ('Portugal');


CREATE TABLE CUST_IT PARTITION OF "DimCustomer"
FOR
VALUES IN ('Italy');


CREATE TABLE CUST_FIN PARTITION OF "DimCustomer"
FOR
VALUES IN ('Finland');


CREATE TABLE CUST_OTHERS PARTITION OF "DimCustomer" DEFAULT;

-- We can do checks to be sure that each partition has its valud country 
ALTER TABLE CUST_UK ADD CONSTRAINT CUST_UK_Country_check
    CHECK Country IN ('United Kingdom'); 

ALTER TABLE CUST_GER ADD CONSTRAINT CUST_GER_Country_check
    CHECK Country IN ('Germany'); 


-- Indexing 
-- Before 
EXPLAIN ANALYZE
SELECT *
FROM "DimCustomer"
WHERE "CustomerID" BETWEEN 14000 AND 15000; 

CREATE INDEX "HI_DimCustomer_CustomerName" 
ON "DimCustomer" USING HASH 
("CustomerName");

-- OR
-- CREATE INDEX "CI_DimCustomer_CustomerName"
-- ON "DimCustomer" USING btree
-- ("CustomerName" ASC NULLS LAST);

ALTER TABLE"DimCustomer"
CLUSTER ON "CI_DimCustomer_CustomerName";

CREATE INDEX "CI_DimCustomer_CustomerID"
ON "DimCustomer" USING btree
("CustomerID" ASC NULLS LAST);

-- After 
EXPLAIN ANALYZE
SELECT *
FROM "DimCustomer"
WHERE "CustomerID" BETWEEN 14000 AND 15000; 



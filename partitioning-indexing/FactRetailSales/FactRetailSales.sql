-- Partitioning 

CREATE TABLE IF NOT EXISTS public."FactRetailSales"
(
    "SalesKey" bigint NOT NULL,
    "InvoiceNo" text COLLATE pg_catalog."default",
    "DateKey" bigint,
    "CustomerKey" bigint,
    "ProductKey" bigint,
    "InvoiceDate" date not null,
    "Quantity" bigint,
    "TotalLine" double precision,
    CONSTRAINT "FactRetailSales_pkey1" PRIMARY KEY ("SalesKey", "InvoiceDate"),
    CONSTRAINT factretailsales_dimcustomer_fk1 FOREIGN KEY ("CustomerKey")
        REFERENCES public."DimCustomer" ("CustomerKey") MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT factretailsales_dimdate_fk1 FOREIGN KEY ("DateKey")
        REFERENCES public."DimDate" ("DateKey") MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT factretailsales_dimproduct_fk1 FOREIGN KEY ("ProductKey")
        REFERENCES public."DimProduct" ("ProductKey") MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
) PARTITION BY RANGE ("InvoiceDate");



CREATE TABLE "FactRetailSales_2010" PARTITION OF "FactRetailSales"
    FOR VALUES FROM ('2010-01-01') TO ('2011-01-01');

CREATE TABLE "FactRetailSales_2011" PARTITION OF "FactRetailSales"
    FOR VALUES FROM ('2011-01-01') TO ('2012-01-01');

CREATE TABLE "FactRetailSales_2012" PARTITION OF "FactRetailSales"
    FOR VALUES FROM ('2012-01-01') TO ('2013-01-01');

CREATE TABLE "FactRetailSales_2013" PARTITION OF "FactRetailSales"
    FOR VALUES FROM ('2013-01-01') TO ('2014-01-01');

CREATE TABLE "FactRetailSales_2014" PARTITION OF "FactRetailSales"
    FOR VALUES FROM ('2014-01-01') TO ('2015-01-01');

CREATE TABLE "FactRetailSales_2015" PARTITION OF "FactRetailSales"
    FOR VALUES FROM ('2015-01-01') TO ('2016-01-01');

CREATE TABLE "FactRetailSales_2016" PARTITION OF "FactRetailSales"
    FOR VALUES FROM ('2016-01-01') TO ('2017-01-01');

CREATE TABLE "FactRetailSales_2017" PARTITION OF "FactRetailSales"
    FOR VALUES FROM ('2017-01-01') TO ('2018-01-01');

CREATE TABLE "FactRetailSales_2018" PARTITION OF "FactRetailSales"
    FOR VALUES FROM ('2018-01-01') TO ('2019-01-01');

CREATE TABLE "FactRetailSales_2019" PARTITION OF "FactRetailSales"
    FOR VALUES FROM ('2019-01-01') TO ('2020-01-01');

CREATE TABLE "FactRetailSales_2020" PARTITION OF "FactRetailSales"
    FOR VALUES FROM ('2020-01-01') TO ('2021-01-01');

CREATE TABLE "FactRetailSales_2021" PARTITION OF "FactRetailSales"
    FOR VALUES FROM ('2021-01-01') TO ('2022-01-01');

CREATE TABLE "FactRetailSales_2022" PARTITION OF "FactRetailSales"
    FOR VALUES FROM ('2022-01-01') TO ('2023-01-01');

CREATE TABLE "FactRetailSales_2023" PARTITION OF "FactRetailSales"
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE "FactRetailSales_2024" PARTITION OF "FactRetailSales"
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');


ALTER TABLE "FactRetailSales_2010" ADD CONSTRAINT FactRetailSales_2010_InvoiceDate_check
    CHECK ("InvoiceDate" >= '2010-01-01' AND "InvoiceDate" < '2011-01-01');

ALTER TABLE "FactRetailSales_2011" ADD CONSTRAINT FactRetailSales_2011_InvoiceDate_check
    CHECK ("InvoiceDate" >= '2011-01-01' AND "InvoiceDate" < '2012-01-01');

ALTER TABLE "FactRetailSales_2012" ADD CONSTRAINT FactRetailSales_2012_InvoiceDate_check
    CHECK ("InvoiceDate" >= '2012-01-01' AND "InvoiceDate" < '2013-01-01');

ALTER TABLE "FactRetailSales_2013" ADD CONSTRAINT FactRetailSales_2013_InvoiceDate_check
    CHECK ("InvoiceDate" >= '2013-01-01' AND "InvoiceDate" < '2014-01-01');

ALTER TABLE "FactRetailSales_2014" ADD CONSTRAINT FactRetailSales_2014_InvoiceDate_check
    CHECK ("InvoiceDate" >= '2014-01-01' AND "InvoiceDate" < '2015-01-01');

ALTER TABLE "FactRetailSales_2015" ADD CONSTRAINT FactRetailSales_2015_InvoiceDate_check
    CHECK ("InvoiceDate" >= '2015-01-01' AND "InvoiceDate" < '2016-01-01');

ALTER TABLE "FactRetailSales_2016" ADD CONSTRAINT FactRetailSales_2016_InvoiceDate_check
    CHECK ("InvoiceDate" >= '2016-01-01' AND "InvoiceDate" < '2017-01-01');

ALTER TABLE "FactRetailSales_2017" ADD CONSTRAINT FactRetailSales_2017_InvoiceDate_check
    CHECK ("InvoiceDate" >= '2017-01-01' AND "InvoiceDate" < '2018-01-01');

ALTER TABLE "FactRetailSales_2018" ADD CONSTRAINT FactRetailSales_2018_InvoiceDate_check
    CHECK ("InvoiceDate" >= '2018-01-01' AND "InvoiceDate" < '2019-01-01');

ALTER TABLE "FactRetailSales_2019" ADD CONSTRAINT FactRetailSales_2019_InvoiceDate_check
    CHECK ("InvoiceDate" >= '2019-01-01' AND "InvoiceDate" < '2020-01-01');

ALTER TABLE "FactRetailSales_2020" ADD CONSTRAINT FactRetailSales_2020_InvoiceDate_check
    CHECK ("InvoiceDate" >= '2020-01-01' AND "InvoiceDate" < '2021-01-01');

ALTER TABLE "FactRetailSales_2021" ADD CONSTRAINT FactRetailSales_2021_InvoiceDate_check
    CHECK ("InvoiceDate" >= '2021-01-01' AND "InvoiceDate" < '2022-01-01');

ALTER TABLE "FactRetailSales_2022" ADD CONSTRAINT FactRetailSales_2022_InvoiceDate_check
    CHECK ("InvoiceDate" >= '2022-01-01' AND "InvoiceDate" < '2023-01-01');

ALTER TABLE "FactRetailSales_2023" ADD CONSTRAINT FactRetailSales_2023_InvoiceDate_check
    CHECK ("InvoiceDate" >= '2023-01-01' AND "InvoiceDate" < '2024-01-01');

ALTER TABLE "FactRetailSales_2024" ADD CONSTRAINT FactRetailSales_2024_InvoiceDate_check
    CHECK ("InvoiceDate" >= '2024-01-01' AND "InvoiceDate" < '2025-01-01');

-- Indexing 
-- Before
EXPLAIN ANALYZE
SELECT "InvoiceNo",
	SUM("TotalLine") AS "Totals",
	SUM("Quantity") AS "TotalQuantity"
FROM "FactRetailSales"
GROUP BY "InvoiceNo"

CREATE INDEX "NCI_FactRetailSales_DateKey" 
ON "FactRetailSales" USING BTREE ("DateKey");

CREATE INDEX "NCI_FactRetailSales_ProductKey" 
ON "FactRetailSales" USING BTREE ("ProductKey");

CREATE INDEX "NCI_FactRetailSales_CustomerKey" 
ON "FactRetailSales" USING BTREE ("CustomerKey");


CREATE INDEX "NCI_FactRetailSales_Quantity" 
ON "FactRetailSales" USING BTREE ("Quantity");

CREATE INDEX "CI_FactRetailSales_TotalLine" 
ON "FactRetailSales" USING BTREE ("TotalLine");

ALTER TABLE "FactRetailSales"
CLUSTER ON "CI_FactRetailSales_TotalLine" 

CREATE INDEX "NCI_FactRetailSales_InvoiceDate_TotalLine" 
ON "FactRetailSales" USING BTREE ("InvoiceDate", "TotalLine");

-- After 
EXPLAIN ANALYZE
SELECT "InvoiceNo",
	SUM("TotalLine") AS "Totals",
	SUM("Quantity") AS "TotalQuantity"
FROM "FactRetailSales"
GROUP BY "InvoiceNo"

EXPLAIN ANALYZE
SELECT *
FROM "FactRetailSales"
JOIN "DimDate" ON "DimDate"."DateKey" = "FactRetailSales"."DateKey"
JOIN "DimCustomer" ON "DimCustomer"."CustomerKey" = "FactRetailSales"."CustomerKey"
JOIN "DimProduct" ON "DimProduct"."ProductKey" = "FactRetailSales"."ProductKey"


-- Partitioning 

CREATE TABLE IF NOT EXISTS public.online_retail_cleaned
(
    "Id" bigint NOT NULL,
    "InvoiceNo" text COLLATE pg_catalog."default",
    "StockCode" text COLLATE pg_catalog."default",
    "Description" text COLLATE pg_catalog."default",
    "Quantity" bigint,
    "InvoiceDate" timestamp without time zone,
    "UnitPrice" double precision,
    "CustomerID" bigint,
    "Country" text COLLATE pg_catalog."default",
    CONSTRAINT online_retail_cleaned_pkey PRIMARY KEY ("Id", "InvoiceDate", "Country")
) PARTITION BY RANGE("InvoiceDate");


CREATE TABLE "online_retail_cleaned_2010" PARTITION OF "online_retail_cleaned"
    FOR VALUES FROM ('2010-01-01') TO ('2011-01-01')
PARTITION BY LIST("Country");

CREATE TABLE CUST_UK PARTITION OF "online_retail_cleaned_2010"
FOR
VALUES IN ('United Kingdom');

CREATE TABLE CUST_GER PARTITION OF "online_retail_cleaned_2010"
FOR
VALUES IN ('Germany');


CREATE TABLE CUST_FR PARTITION OF "online_retail_cleaned_2010"
FOR
VALUES IN ('France');


CREATE TABLE CUST_SP PARTITION OF "online_retail_cleaned_2010"
FOR
VALUES IN ('Spain');


CREATE TABLE CUST_BLG PARTITION OF "online_retail_cleaned_2010"
FOR
VALUES IN ('Belgium');


CREATE TABLE CUST_SWZ PARTITION OF "online_retail_cleaned_2010"
FOR
VALUES IN ('Switzerland');


CREATE TABLE CUST_PRG PARTITION OF "online_retail_cleaned_2010"
FOR
VALUES IN ('Portugal');


CREATE TABLE CUST_IT PARTITION OF "online_retail_cleaned_2010"
FOR
VALUES IN ('Italy');


CREATE TABLE CUST_FIN PARTITION OF "online_retail_cleaned_2010"
FOR
VALUES IN ('Finland');


CREATE TABLE CUST_OTHERS PARTITION OF "online_retail_cleaned_2010" DEFAULT;


CREATE TABLE "online_retail_cleaned_2011" PARTITION OF "online_retail_cleaned"
    FOR VALUES FROM ('2011-01-01') TO ('2012-01-01')
PARTITION BY LIST("Country");
	
CREATE TABLE CUST_UK1 PARTITION OF "online_retail_cleaned_2011"
FOR
VALUES IN ('United Kingdom');

CREATE TABLE CUST_GER1 PARTITION OF "online_retail_cleaned_2011"
FOR
VALUES IN ('Germany');


CREATE TABLE CUST_FR1 PARTITION OF "online_retail_cleaned_2011"
FOR
VALUES IN ('France');


CREATE TABLE CUST_SP1 PARTITION OF "online_retail_cleaned_2011"
FOR
VALUES IN ('Spain');


CREATE TABLE CUST_BLG1 PARTITION OF "online_retail_cleaned_2011"
FOR
VALUES IN ('Belgium');


CREATE TABLE CUST_SWZ1 PARTITION OF "online_retail_cleaned_2011"
FOR
VALUES IN ('Switzerland');


CREATE TABLE CUST_PRG1 PARTITION OF "online_retail_cleaned_2011"
FOR
VALUES IN ('Portugal');


CREATE TABLE CUST_IT1 PARTITION OF "online_retail_cleaned_2011"
FOR
VALUES IN ('Italy');


CREATE TABLE CUST_FIN1 PARTITION OF "online_retail_cleaned_2011"
FOR
VALUES IN ('Finland');


CREATE TABLE CUST_OTHERS1 PARTITION OF "online_retail_cleaned_2011" DEFAULT;

CREATE TABLE "online_retail_cleaned_2012" PARTITION OF "online_retail_cleaned"
    FOR VALUES FROM ('2012-01-01') TO ('2013-01-01');

CREATE TABLE "online_retail_cleaned_2013" PARTITION OF "online_retail_cleaned"
    FOR VALUES FROM ('2013-01-01') TO ('2014-01-01');

CREATE TABLE "online_retail_cleaned_2014" PARTITION OF "online_retail_cleaned"
    FOR VALUES FROM ('2014-01-01') TO ('2015-01-01');

CREATE TABLE "online_retail_cleaned_2015" PARTITION OF "online_retail_cleaned"
    FOR VALUES FROM ('2015-01-01') TO ('2016-01-01');

CREATE TABLE "online_retail_cleaned_2016" PARTITION OF "online_retail_cleaned"
    FOR VALUES FROM ('2016-01-01') TO ('2017-01-01');

CREATE TABLE "online_retail_cleaned_2017" PARTITION OF "online_retail_cleaned"
    FOR VALUES FROM ('2017-01-01') TO ('2018-01-01');

CREATE TABLE "online_retail_cleaned_2018" PARTITION OF "online_retail_cleaned"
    FOR VALUES FROM ('2018-01-01') TO ('2019-01-01');

CREATE TABLE "online_retail_cleaned_2019" PARTITION OF "online_retail_cleaned"
    FOR VALUES FROM ('2019-01-01') TO ('2020-01-01');

CREATE TABLE "online_retail_cleaned_2020" PARTITION OF "online_retail_cleaned"
    FOR VALUES FROM ('2020-01-01') TO ('2021-01-01');

CREATE TABLE "online_retail_cleaned_2021" PARTITION OF "online_retail_cleaned"
    FOR VALUES FROM ('2021-01-01') TO ('2022-01-01');

CREATE TABLE "online_retail_cleaned_2022" PARTITION OF "online_retail_cleaned"
    FOR VALUES FROM ('2022-01-01') TO ('2023-01-01');

CREATE TABLE "online_retail_cleaned_2023" PARTITION OF "online_retail_cleaned"
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE "online_retail_cleaned_2024" PARTITION OF "online_retail_cleaned"
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');


ALTER TABLE "online_retail_cleaned_2010" ADD CONSTRAINT online_retail_cleaned_2010_InvoiceDate_check
    CHECK ("InvoiceDate" >= '2010-01-01' AND "InvoiceDate" < '2011-01-01');

ALTER TABLE "online_retail_cleaned_2011" ADD CONSTRAINT online_retail_cleaned_2011_InvoiceDate_check
    CHECK ("InvoiceDate" >= '2011-01-01' AND "InvoiceDate" < '2012-01-01');

ALTER TABLE "online_retail_cleaned_2012" ADD CONSTRAINT online_retail_cleaned_2012_InvoiceDate_check
    CHECK ("InvoiceDate" >= '2012-01-01' AND "InvoiceDate" < '2013-01-01');

ALTER TABLE "online_retail_cleaned_2013" ADD CONSTRAINT online_retail_cleaned_2013_InvoiceDate_check
    CHECK ("InvoiceDate" >= '2013-01-01' AND "InvoiceDate" < '2014-01-01');

ALTER TABLE "online_retail_cleaned_2014" ADD CONSTRAINT online_retail_cleaned_2014_InvoiceDate_check
    CHECK ("InvoiceDate" >= '2014-01-01' AND "InvoiceDate" < '2015-01-01');

ALTER TABLE "online_retail_cleaned_2015" ADD CONSTRAINT online_retail_cleaned_2015_InvoiceDate_check
    CHECK ("InvoiceDate" >= '2015-01-01' AND "InvoiceDate" < '2016-01-01');

ALTER TABLE "online_retail_cleaned_2016" ADD CONSTRAINT online_retail_cleaned_2016_InvoiceDate_check
    CHECK ("InvoiceDate" >= '2016-01-01' AND "InvoiceDate" < '2017-01-01');

ALTER TABLE "online_retail_cleaned_2017" ADD CONSTRAINT online_retail_cleaned_2017_InvoiceDate_check
    CHECK ("InvoiceDate" >= '2017-01-01' AND "InvoiceDate" < '2018-01-01');

ALTER TABLE "online_retail_cleaned_2018" ADD CONSTRAINT online_retail_cleaned_2018_InvoiceDate_check
    CHECK ("InvoiceDate" >= '2018-01-01' AND "InvoiceDate" < '2019-01-01');

ALTER TABLE "online_retail_cleaned_2019" ADD CONSTRAINT online_retail_cleaned_2019_InvoiceDate_check
    CHECK ("InvoiceDate" >= '2019-01-01' AND "InvoiceDate" < '2020-01-01');

ALTER TABLE "online_retail_cleaned_2020" ADD CONSTRAINT online_retail_cleaned_2020_InvoiceDate_check
    CHECK ("InvoiceDate" >= '2020-01-01' AND "InvoiceDate" < '2021-01-01');

ALTER TABLE "online_retail_cleaned_2021" ADD CONSTRAINT online_retail_cleaned_2021_InvoiceDate_check
    CHECK ("InvoiceDate" >= '2021-01-01' AND "InvoiceDate" < '2022-01-01');

ALTER TABLE "online_retail_cleaned_2022" ADD CONSTRAINT online_retail_cleaned_2022_InvoiceDate_check
    CHECK ("InvoiceDate" >= '2022-01-01' AND "InvoiceDate" < '2023-01-01');

ALTER TABLE "online_retail_cleaned_2023" ADD CONSTRAINT online_retail_cleaned_2023_InvoiceDate_check
    CHECK ("InvoiceDate" >= '2023-01-01' AND "InvoiceDate" < '2024-01-01');

ALTER TABLE "online_retail_cleaned_2024" ADD CONSTRAINT online_retail_cleaned_2024_InvoiceDate_check
    CHECK ("InvoiceDate" >= '2024-01-01' AND "InvoiceDate" < '2025-01-01');

-- Indexing 
CREATE INDEX "BRIN_online_retail_cleaned_InvoiceDate"
ON "online_retail_cleaned" USING BRIN ("InvoiceDate");

CREATE INDEX "NCI_online_retail_cleaned_InvoiceNo"
ON "online_retail_cleaned" USING BTREE ("InvoiceNo");

CREATE INDEX "NCI_online_retail_cleaned_InvoiceNo_Quantity"
ON "online_retail_cleaned" USING BTREE ("InvoiceNo", "Quantity");

CREATE INDEX "NCI_online_retail_cleaned_InvoiceNo_UnitPrice"
ON "online_retail_cleaned" USING BTREE ("InvoiceNo", "UnitPrice");

CREATE INDEX "NCI_online_retail_cleaned_InvoiceNo_Quantity_UnitPrice"
ON "online_retail_cleaned" USING BTREE ("InvoiceNo", "Quantity", "UnitPrice");

CREATE INDEX "NCI_online_retail_cleaned_StockCode"
ON "online_retail_cleaned" USING BTREE ("StockCode");


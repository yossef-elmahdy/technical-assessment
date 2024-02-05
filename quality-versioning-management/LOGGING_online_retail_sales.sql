-- Mock the DB users by keeping them on DB_Users table 

CREATE TABLE "DB_Users" (
	user_id SERIAL PRIMARY KEY, 
	user_name TEXT, 
	user_role TEXT
);

INSERT INTO "DB_Users" (user_name, user_role)
VALUES ('Youssef', 'DB Admin')
	, ('Nada', 'Developer');

-- 1. Create LOG table to keep changes 	
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


-- 2. Create trigger function

CREATE OR REPLACE FUNCTION capture_online_retail_cleaned_changes()
RETURNS TRIGGER AS
$$
BEGIN
    IF TG_OP = 'INSERT' THEN
		RAISE NOTICE 'INSERT id: %', NEW."Id"; 
		INSERT INTO "LOG_online_retail_cleaned" (
			"Id",
			"InvoiceNo",
			"StockCode",
			"Description",
			"Quantity",
			"InvoiceDate",
			"UnitPrice",
			"CustomerID",
			"Country",
			"CreatedAt",
			"UpdatedAt",
			"LOG_changeType",
			"LOG_userId")       
		VALUES (
			NEW."Id",
			NEW."InvoiceNo",
			NEW."StockCode",
			NEW."Description",
			NEW."Quantity",
			NEW."InvoiceDate",
			NEW."UnitPrice",
			NEW."CustomerID",
			NEW."Country",
			NEW."CreatedAt",
			NEW."UpdatedAt",
			'INSERT',
			1
		);
    ELSIF TG_OP = 'UPDATE' THEN
		RAISE NOTICE 'UPDATE id: %', NEW."Id";
        INSERT INTO "LOG_online_retail_cleaned" (
			"Id",
			"InvoiceNo",
			"StockCode",
			"Description",
			"Quantity",
			"InvoiceDate",
			"UnitPrice",
			"CustomerID",
			"Country",
			"CreatedAt",
			"UpdatedAt",
			"LOG_changeType",
			"LOG_userId")       
		VALUES (
			NEW."Id",
			NEW."InvoiceNo",
			NEW."StockCode",
			NEW."Description",
			NEW."Quantity",
			NEW."InvoiceDate",
			NEW."UnitPrice",
			NEW."CustomerID",
			NEW."Country",
			NEW."CreatedAt",
			NEW."UpdatedAt",
			'UPDATE',
			1
		);
    ELSIF TG_OP = 'DELETE' THEN
		RAISE NOTICE 'DELETE id: %', OLD."Id";
        INSERT INTO "LOG_online_retail_cleaned" (
			"Id",
			"InvoiceNo",
			"StockCode",
			"Description",
			"Quantity",
			"InvoiceDate",
			"UnitPrice",
			"CustomerID",
			"Country",
			"CreatedAt",
			"UpdatedAt",
			"LOG_changeType",
			"LOG_userId")       
		VALUES (
			OLD."Id",
			OLD."InvoiceNo",
			OLD."StockCode",
			OLD."Description",
			OLD."Quantity",
			OLD."InvoiceDate",
			OLD."UnitPrice",
			OLD."CustomerID",
			OLD."Country",
			OLD."CreatedAt",
			OLD."UpdatedAt",
			'DELETE',
			1
		);
    END IF;
    RETURN NULL;
END;
$$
LANGUAGE plpgsql;


-- 3. Create the trigger
CREATE TRIGGER LOG_online_retail_cleaned_trigger
AFTER INSERT OR UPDATE OR DELETE ON online_retail_cleaned
FOR EACH ROW
EXECUTE FUNCTION capture_online_retail_cleaned_changes(); 

-- 4. Testing 
-- INSERT 
INSERT INTO online_retail_cleaned ( "Id",
			"InvoiceNo",
			"StockCode",
			"Description",
			"Quantity",
			"InvoiceDate",
			"UnitPrice",
			"CustomerID",
			"Country",
			"CreatedAt",
			"UpdatedAt")
select 15000000 AS "Id", 
			"InvoiceNo",
			"StockCode",
			"Description",
			"Quantity",
			"InvoiceDate",
			"UnitPrice",
			"CustomerID",
			"Country",
			"CreatedAt",
			"UpdatedAt" 
from online_retail_cleaned
LIMIT 1

-- UPDATE 
UPDATE online_retail_cleaned
SET "StockCode" = '21111'
WHERE "Id" = 17

-- DELETE 
DELETE 
FROM online_retail_cleaned
WHERE "Id" = 15000000


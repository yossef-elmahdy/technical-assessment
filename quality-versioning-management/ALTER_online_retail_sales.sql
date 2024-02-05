-- Add timestamp columns to track the changes 
ALTER TABLE online_retail_cleaned 
ADD "CreatedAt" timestamp WITHOUT TIME ZONE DEFAULT NOW();

ALTER TABLE online_retail_cleaned 
ADD "UpdatedAt" timestamp WITHOUT TIME ZONE DEFAULT NOW();


-- Keep `UpdatedAt` column up-to-dated when any changes happen 
CREATE OR REPLACE FUNCTION online_retail_cleaned_change_updateAt_column()
RETURNS TRIGGER AS
$$
BEGIN
	NEW."UpdatedAt" = NOW();
	RETURN NEW; 
END;
$$
LANGUAGE plpgsql;


CREATE TRIGGER online_retail_cleaned_updateAt_trigger
BEFORE UPDATE ON online_retail_cleaned
FOR EACH ROW
EXECUTE FUNCTION online_retail_cleaned_change_updateAt_column(); 
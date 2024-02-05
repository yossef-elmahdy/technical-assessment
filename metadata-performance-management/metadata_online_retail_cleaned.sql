-- Dataset table
CREATE TABLE datasets (
    dataset_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    data_source TEXT,  
    storage_location TEXT,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Table table
CREATE TABLE dataset_tables (
    table_id SERIAL PRIMARY KEY,
    dataset_id INT REFERENCES datasets(dataset_id),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Column table
CREATE TABLE table_columns (
    column_id SERIAL PRIMARY KEY,
    table_id INT REFERENCES dataset_tables(table_id),
    name VARCHAR(255) NOT NULL,
    data_type VARCHAR(100),
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Relationship table
CREATE TABLE table_relationships (
    relationship_id SERIAL PRIMARY KEY,
    parent_table_id INT REFERENCES dataset_tables(table_id),
    child_table_id INT REFERENCES dataset_tables(table_id),
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

INSERT INTO datasets (name, description, data_source, storage_location) 
VALUES ('online_retail_cleaned', 'Cleaned version of the online retail dataset', 'Online retail system', 'Database');

-- Insert metadata for the table
INSERT INTO dataset_tables (dataset_id, name, description) VALUES (
    (SELECT dataset_id FROM datasets WHERE name = 'online_retail_cleaned'),
    'online_retail_cleaned',
    'Main table of the online retail dataset'
);

-- Insert metadata for the columns
INSERT INTO table_columns (table_id, name, data_type, description) VALUES 
    ((SELECT table_id FROM dataset_tables WHERE name = 'online_retail_cleaned'), 'Id', 'bigint', 'Unique identifier'),
    ((SELECT table_id FROM dataset_tables WHERE name = 'online_retail_cleaned'), 'InvoiceNo', 'text', 'Invoice number'),
    ((SELECT table_id FROM dataset_tables WHERE name = 'online_retail_cleaned'), 'StockCode', 'text', 'Stock code'),
    ((SELECT table_id FROM dataset_tables WHERE name = 'online_retail_cleaned'), 'Description', 'text', 'Description'),
    ((SELECT table_id FROM dataset_tables WHERE name = 'online_retail_cleaned'), 'Quantity', 'bigint', 'Quantity'),
    ((SELECT table_id FROM dataset_tables WHERE name = 'online_retail_cleaned'), 'InvoiceDate', 'timestamp without time zone', 'Date of the invoice'),
    ((SELECT table_id FROM dataset_tables WHERE name = 'online_retail_cleaned'), 'UnitPrice', 'double precision', 'Unit price'),
    ((SELECT table_id FROM dataset_tables WHERE name = 'online_retail_cleaned'), 'CustomerID', 'bigint', 'Customer ID'),
    ((SELECT table_id FROM dataset_tables WHERE name = 'online_retail_cleaned'), 'Country', 'text', 'Country'),
    ((SELECT table_id FROM dataset_tables WHERE name = 'online_retail_cleaned'), 'CreatedAt', 'timestamp without time zone', 'Creation timestamp'),
    ((SELECT table_id FROM dataset_tables WHERE name = 'online_retail_cleaned'), 'UpdatedAt', 'timestamp without time zone', 'Update timestamp');


INSERT INTO table_relationships (parent_table_id, child_table_id, description)
VALUES (
    (SELECT table_id FROM dataset_tables WHERE name = 'online_retail_cleaned'), -- Parent table
    (SELECT table_id FROM dataset_tables WHERE name = 'online_retail_cleaned'), -- Child table (same table)
    'Self-referencing relationship where some records are parent records and others are child records'
);

CREATE TABLE transformations (
    transformation_id SERIAL PRIMARY KEY,
    dataset_id INT REFERENCES datasets(dataset_id),
    description TEXT,
    applied_at TIMESTAMPTZ DEFAULT NOW() -- Timestamp of when the transformation was applied
);

-- Storage Location table
CREATE TABLE storage_locations (
    storage_location_id SERIAL PRIMARY KEY,
    dataset_id INT REFERENCES datasets(dataset_id),
    location_type VARCHAR(50),  -- Type of storage location (e.g., database, file system)
    location_details TEXT,     -- Details about the storage location (e.g., database name, schema name, file path)
    created_at TIMESTAMPTZ DEFAULT NOW()
);

INSERT INTO transformations (dataset_id, description)
VALUES (
    (SELECT dataset_id FROM datasets WHERE name = 'online_retail_cleaned'),
    'Data cleaning and preprocessing'
);

-- Insert storage location information
INSERT INTO storage_locations (dataset_id, location_type, location_details)
VALUES (
    (SELECT dataset_id FROM datasets WHERE name = 'online_retail_cleaned'),
    'Database',
    'Database: public, Table: online_retail_cleaned'
);
from sqlalchemy import create_engine, text
from time import time
import pandas as pd
import argparse
import utils


def build_dwh_DimDate(db_engine):
    sql = '''
    SELECT CAST(to_char(date_trunc('day', days)::date, 'YYYYMMDD') AS INT) AS "DateKey"
        , date_trunc('day', days):: date AS "FullDate"
        , EXTRACT(YEAR FROM days) AS "Year"
        , EXTRACT(MONTH FROM days) AS "Month"
        , EXTRACT(DAY FROM days) AS "Day"
        , EXTRACT(WEEK FROM days) AS "Week"
        , TO_CHAR(days, 'Month') AS "MonthName"
        , TO_CHAR(days, 'Day') AS "DayName"
    FROM generate_series
            ( '2010-01-01'::timestamp 
            , '2012-01-01'::timestamp
            , '1 day'::interval) days;
    '''
    date_df = pd.read_sql(sql, db_engine, index_col='DateKey')
    date_df['Year'] = date_df['Year'].astype(int)
    date_df['Month'] = date_df['Month'].astype(int)
    date_df['Day'] = date_df['Day'].astype(int)
    date_df['Week'] = date_df['Week'].astype(int)
    t_start = time()
    date_df.to_sql(name='DimDate', con=db_engine,
                   if_exists='replace', index=True, index_label='DateKey')
    print(f'Finished insertion in {time()-t_start:.3}s')
    query = 'ALTER TABLE "DimDate" ADD PRIMARY KEY ("DateKey");'
    with db_engine.connect() as db_conn:
        db_conn.execute(text(query))
        db_conn.commit()


def build_dwh_DimCustomer(db_engine, cleaned_df):
    customer_df = cleaned_df[['CustomerID', 'Country']
                             ].drop_duplicates(subset=['CustomerID']).copy()
    customer_df = customer_df.reset_index(drop=True)
    customer_df['CustomerKey'] = customer_df.index

    def set_customer_name(customer_key):
        return 'Customer ' + str(customer_key)
    customer_df['CustomerName'] = customer_df['CustomerKey'].apply(
        set_customer_name)
    customer_df = customer_df.set_index('CustomerKey')

    t_start = time()
    customer_df.to_sql(name='DimCustomer', con=db_engine,
                       if_exists='replace', index=True, index_label='CustomerKey')
    print(f'Finished insertion in {time()-t_start:.3}s')
    query = 'ALTER TABLE "DimCustomer" ADD PRIMARY KEY ("CustomerKey");'
    with db_engine.connect() as db_conn:
        db_conn.execute(text(query))
        db_conn.commit()


def build_dwh_DimProduct(db_engine, cleaned_df):
    product_df = cleaned_df[['StockCode', 'Description',
                             'UnitPrice']].drop_duplicates().copy()
    product_df = product_df.reset_index(drop=True)
    product_df['ProductKey'] = product_df.index

    def set_product_name(product_key):
        return 'Product ' + str(product_key)
    product_df['ProductName'] = product_df['ProductKey'].apply(
        set_product_name)
    product_df = product_df.set_index('ProductKey')

    t_start = time()
    product_df.to_sql(name='DimProduct', con=db_engine,
                      if_exists='replace', index=True, index_label='ProductKey')
    print(f'Finished insertion in {time()-t_start:.3}s')
    query = 'ALTER TABLE "DimProduct" ADD PRIMARY KEY ("ProductKey");'
    with db_engine.connect() as db_conn:
        db_conn.execute(text(query))
        db_conn.commit()


def build_dwh_FactRetailSales(db_engine):
    sql = '''
        SELECT "InvoiceNo"
            , "DateKey"
            , "CustomerKey"
            , "ProductKey"
            , "InvoiceDate"
            , "Quantity"
            , ROUND(CAST("Quantity" * ret."UnitPrice" AS numeric), 2) AS "TotalLine"
        FROM online_retail_cleaned AS ret
        JOIN "DimDate" AS DimDate
            ON DimDate."DateKey" = CAST(to_char(date_trunc('day', ret."InvoiceDate")::date, 'YYYYMMDD') AS INT)
        INNER JOIN "DimCustomer" AS DimCustomer 
            ON DimCustomer."CustomerID" = ret."CustomerID"
            AND DimCustomer."Country" = ret."Country"
        INNER JOIN "DimProduct" 
            ON "DimProduct"."StockCode" = ret."StockCode"
            AND "DimProduct"."Description" = ret."Description"
            AND "DimProduct"."UnitPrice" = ret."UnitPrice"
    '''
    retail_sales_df = pd.read_sql(sql, db_engine)
    retail_sales_df = retail_sales_df.reset_index(drop=True)
    retail_sales_df['SalesKey'] = retail_sales_df.index
    retail_sales_df = retail_sales_df.set_index('SalesKey')

    t_start = time()
    retail_sales_df.to_sql(name='FactRetailSales', con=db_engine,
                           if_exists='replace', index=True, index_label='SalesKey')
    print(f'Finished insertion in {time()-t_start:.3}s')
    query = 'ALTER TABLE "FactRetailSales" ADD PRIMARY KEY ("SalesKey");'
    with db_engine.connect() as db_conn:
        db_conn.execute(text(query))
        db_conn.commit()


def build_relationships(db_engine):
    queries = [
        '''
        ALTER TABLE "FactRetailSales"
        ADD CONSTRAINT FactRetailSales_DimDate_fk
        FOREIGN KEY ("DateKey")
        REFERENCES "DimDate"("DateKey")
        ON DELETE CASCADE
        ON UPDATE CASCADE
        ''',
        '''
        ALTER TABLE "FactRetailSales"
        ADD CONSTRAINT FactRetailSales_DimCustomer_fk
        FOREIGN KEY ("CustomerKey")
        REFERENCES "DimCustomer"("CustomerKey")
        ON DELETE CASCADE
        ON UPDATE CASCADE
        ''',
        '''
        ALTER TABLE "FactRetailSales"
        ADD CONSTRAINT FactRetailSales_DimProduct_fk
        FOREIGN KEY ("ProductKey")
        REFERENCES "DimProduct"("ProductKey")
        ON DELETE CASCADE
        ON UPDATE CASCADE
        '''
    ]

    for query in queries:
        with db_engine.connect() as db_conn:
            db_conn.execute(text(query))
            db_conn.commit()


def build_dwh(db_engine):
    sql = '''
    SELECT * 
    FROM online_retail_cleaned
    '''
    retail_cleaned_df = pd.read_sql(sql, db_engine, index_col='Id')

    # Drop the fact table (if exists) to drop foreign key constraints
    query = 'DROP TABLE IF EXISTS "FactRetailSales";'

    with db_engine.connect() as db_conn:
        db_conn.execute(text(query))
        db_conn.commit()

    # DimDate
    build_dwh_DimDate(db_engine)

    # DimCustomer
    build_dwh_DimCustomer(db_engine, retail_cleaned_df)

    # DimProduct
    build_dwh_DimProduct(db_engine, retail_cleaned_df)

    # FactRetailSales
    build_dwh_FactRetailSales(db_engine)

    # Build Relationships (foreign keys)
    build_relationships(db_engine)


def main(params):
    user = params.user
    password = params.password
    host = params.host
    port = params.port
    db = params.db

    db_engine = utils.database_connect(user, password, host, port, db)
    build_dwh(db_engine)
    print(f'>> Successfully completed building and populating DWH <<')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Building and populating the DWH')

    parser.add_argument('--user', required=True, help='user name for postgres')
    parser.add_argument('--password', required=True,
                        help='password for postgres')
    parser.add_argument('--host', required=True, help='host for postgres')
    parser.add_argument('--port', required=True, help='port for postgres')
    parser.add_argument('--db', required=True,
                        help='database name for postgres')

    args = parser.parse_args()

    main(args)

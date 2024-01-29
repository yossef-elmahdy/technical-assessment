import os
import pandas as pd
from time import time
from sqlalchemy import create_engine, text


def database_connect(user, password, host, port, db):
    engine = create_engine(
        f'postgresql://{user}:{password}@{host}:{port}/{db}')
    engine.connect()
    return engine


def extract_data(url, csv_file):
    csv_file = 'ext_' + csv_file
    ret = os.system(f"wget {url} -O {csv_file}")
    if ret != 0:
        print(
            f'Unable to get file {csv_file} , file not found or internet issue')
        os.system(f'rm {csv_file}')
    return ret


def old_extract_data(url):
    if url.endswith('.csv.gz'):
        csv_name = 'output.csv.gz'
    else:
        csv_name = 'output.csv'
    ret = os.system(f"wget {url} -O {csv_name}")
    return ret


def transform_data(csv_file):
    df = pd.read_csv(csv_file)

    # Drop null values
    df = df.dropna(subset=['CustomerID', 'InvoiceNo',
                   'StockCode', 'Description'], how='any')

    # Data Types validation
    dtypes = {
        'InvoiceNo': 'object',
        'StockCode': 'object',
        'Description': 'object',
        'Quantity': 'int64',
        'InvoiceDate': 'datetime64[ns]',
        'UnitPrice': 'float64',
        'CustomerID': 'int64',
        'Country': 'object'
    }

    try:
        df_cols = list(df.columns)
        for col in df_cols:
            col_dtype = dtypes.get(col, 'unknown')
            print(col + ' (' + col_dtype + ')', end='\t-> ')
            if col_dtype == str(df[col].dtype):
                print('ok')
            elif col_dtype == 'unknown':
                print('Unknown column, will be dropped')
                df = df.drop(columns=[col])
            else:
                if 'datetime' in col_dtype:
                    df[col] = pd.to_datetime(df[col])
                else:
                    df[col] = df[col].astype(col_dtype)
                print('ok')
    except Exception as e:
        print(e)

    # Imputing null values & handling outliers
    df.loc[df['Quantity'] < 0,
           'Quantity'] = df.loc[df['Quantity'] < 0, 'Quantity'] * -1
    median_of_means = round(df.groupby('InvoiceNo')[
                            'Quantity'].mean().median())
    df['Quantity'] = df['Quantity'].fillna(median_of_means)
    df.loc[df['Quantity'] > 100, 'Quantity'] = 100

    df.loc[df['UnitPrice'] < 0,
           'UnitPrice'] = df.loc[df['UnitPrice'] < 0, 'UnitPrice'] * -1
    median_of_means = round(df.groupby('UnitPrice')[
                            'UnitPrice'].mean().median())
    df['UnitPrice'] = df['UnitPrice'].fillna(median_of_means)
    df.loc[df['UnitPrice'] > 1000, 'UnitPrice'] = 1000

    nulls_cnt = df[['InvoiceNo', 'StockCode', 'CustomerID',
                    'Description', 'Quantity', 'UnitPrice']].isna().sum().sum()
    assert nulls_cnt == 0

    # Drop Duplicates
    df = df.drop_duplicates()
    assert df.duplicated().sum() == 0

    csv_file = 'cleaned(stg)_' + csv_file
    df.to_csv(csv_file, index=False)

    return df


def load_transactional(df, db_engine):
    print('Insert on transactional table: online_retail_cleaned', end=' => ')
    sql = '''
        SELECT max("Id") FROM "online_retail_cleaned";
    '''
    max_id_df = pd.read_sql(sql, db_engine)
    last_id = max_id_df['max'][0] + 1

    df['Id'] = range(last_id, last_id + df.shape[0])
    df = df.set_index('Id')

    t_start = time()
    df.to_sql(name='online_retail_cleaned', con=db_engine,
              if_exists='append', index=True, index_label='Id')
    print(f'Finished insertion in {time()-t_start:.3}s')
    return (df, last_id)


def load_dwh_DimDate(df, db_engine):
    print('Insert on DWH table: DimDate', end=' => ')
    sql = '''
        SELECT min("FullDate") AS "MinDate", max("FullDate") AS "MaxDate" FROM "DimDate";
    '''
    max_date_df = pd.read_sql(sql, db_engine)
    max_date = max_date_df['MaxDate'][0]

    max_invoice_date = df['InvoiceDate'].dt.date.max()

    date_df = None
    if max_invoice_date > max_date:
        sql = f'''
            SELECT CAST(to_char(date_trunc('day', days)::date, 'YYYYMMDD') AS INT) AS "DateKey"
            	, date_trunc('day', days):: date AS "FullDate"
            	, EXTRACT(YEAR FROM days) AS "Year"
            	, EXTRACT(MONTH FROM days) AS "Month"
            	, EXTRACT(DAY FROM days) AS "Day"
            	, EXTRACT(WEEK FROM days) AS "Week"
            	, TO_CHAR(days, 'Month') AS "MonthName"
            	, TO_CHAR(days, 'Day') AS "DayName"
            FROM generate_series
                    ( '{str(max_date)}'::timestamp + interval '1 day'
                    , '{str(max_invoice_date)}'::timestamp
                    , '1 day'::interval) days;
            '''
        date_df = pd.read_sql(sql, db_engine, index_col='DateKey')

        date_df['Year'] = date_df['Year'].astype(int)
        date_df['Month'] = date_df['Month'].astype(int)
        date_df['Day'] = date_df['Day'].astype(int)
        date_df['Week'] = date_df['Week'].astype(int)

        t_start = time()
        date_df.to_sql(name='DimDate', con=db_engine,
                       if_exists='append', index=True, index_label='DateKey')
        print(f'Finished insertion in {time()-t_start:.3}s')
    else:
        print('No new insertion')


def load_dwh_DimCustomer(df, db_engine):
    print('Insert on DWH table: DimCustomer', end=' => ')
    sql = '''
        SELECT Distinct "CustomerID"
        FROM "DimCustomer";
    '''
    customers_df = pd.read_sql(sql, db_engine)
    existing_customers = list(customers_df['CustomerID'])

    customer_df = df[['CustomerID', 'Country']].drop_duplicates(
        subset=['CustomerID']).copy()

    customer_df_insert = customer_df[~customer_df['CustomerID'].isin(
        existing_customers)]
    customer_df_update = customer_df[customer_df['CustomerID'].isin(
        existing_customers)]

    sql = '''
        SELECT max("CustomerKey") AS "MaxCustomerKey" 
        FROM "DimCustomer";
    '''
    max_customer_df = pd.read_sql(sql, db_engine)
    max_customer = max_customer_df['MaxCustomerKey'][0] + 1
    customer_df_insert['CustomerKey'] = range(
        max_customer, max_customer + customer_df_insert.shape[0])

    def set_customer_name(customer_key):
        return 'Customer ' + str(customer_key)
    customer_df_insert['CustomerName'] = customer_df_insert['CustomerKey'].apply(
        set_customer_name)
    customer_df_insert = customer_df_insert.set_index('CustomerKey')

    t_start = time()
    customer_df_insert.to_sql(name='DimCustomer', con=db_engine,
                              if_exists='append', index=True, index_label='CustomerKey')
    print(f'Finished insertion in {time()-t_start:.3}s')

    def update_customer_dwh(row):
        query = f'''
            UPDATE "DimCustomer"
            SET "Country" = '{row['Country']}'
            WHERE 
                "CustomerID" = '{row['CustomerID']}'
        '''
        with db_engine.connect() as db_conn:
            db_conn.execute(text(query))
            db_conn.commit()
    _ = customer_df_update.apply(update_customer_dwh, axis=1)


def load_dwh_DimProduct(df, db_engine):
    print('Insert on DWH table: DimProduct', end=' => ')
    sql = '''
        SELECT Distinct "StockCode"
        FROM "DimProduct";
    '''
    products_df = pd.read_sql(sql, db_engine)
    existing_products = list(products_df['StockCode'])

    product_df = df[['StockCode', 'Description',
                     'UnitPrice']].drop_duplicates().copy()

    product_df_insert = product_df[~product_df['StockCode'].isin(
        existing_products)]
    product_df_update = product_df[product_df['StockCode'].isin(
        existing_products)]

    sql = '''
        SELECT max("ProductKey") AS "MaxProductKey" 
        FROM "DimProduct";
    '''
    max_product_df = pd.read_sql(sql, db_engine)
    max_product = max_product_df['MaxProductKey'][0] + 1

    product_df_insert['ProductKey'] = range(
        max_product, max_product + product_df_insert.shape[0])

    def set_product_name(product_key):
        return 'Product ' + str(product_key)
    product_df_insert['ProductName'] = product_df_insert['ProductKey'].apply(
        set_product_name)
    product_df_insert = product_df_insert.set_index('ProductKey')

    t_start = time()
    product_df_insert.to_sql(name='DimProduct', con=db_engine,
                             if_exists='append', index=True, index_label='ProductKey')
    print(f'Finished insertion in {time()-t_start:.3}s')

    def update_product_dwh(row):
        query = f'''
                UPDATE "DimProduct"
                SET "UnitPrice" = {row['UnitPrice']}
                WHERE "StockCode" = '{row['StockCode']}'
                AND "Description" = '{row['Description'].replace("'", " ")}'
        '''
        with db_engine.connect() as db_conn:
            db_conn.execute(text(query))
            db_conn.commit()
    _ = product_df_update.apply(update_product_dwh, axis=1)


def load_dwh_FactRetailSales(df, last_trans_id, db_engine):
    sql = f'''
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
        WHERE ret."Id" >= {last_trans_id} 
    '''
    retail_sales_df = pd.read_sql(sql, db_engine)
    retail_sales_df

    sql = '''
        SELECT max("SalesKey") AS "MaxSalesKey" 
        FROM "FactRetailSales";
    '''
    max_sales_df = pd.read_sql(sql, db_engine)
    max_sales = max_sales_df['MaxSalesKey'][0] + 1
    max_sales

    retail_sales_df['SalesKey'] = range(
        max_sales, max_sales + retail_sales_df.shape[0])
    retail_sales_df = retail_sales_df.set_index('SalesKey')

    retail_sales_df

    t_start = time()
    retail_sales_df.to_sql(name='FactRetailSales', con=db_engine,
                           if_exists='append', index=True, index_label='SalesKey')
    print(f'Finished insertion in {time()-t_start:.3}s')


def load_data(df, db_engine):
    # OLTP
    df, last_trans_id = load_transactional(df, db_engine)

    # Date Dim
    load_dwh_DimDate(df, db_engine)

    # DimCustomer
    load_dwh_DimCustomer(df, db_engine)

    # DimProduct
    load_dwh_DimProduct(df, db_engine)

    # FactRetailSales
    load_dwh_FactRetailSales(df, last_trans_id, db_engine)

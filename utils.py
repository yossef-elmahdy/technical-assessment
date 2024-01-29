import pandas as pd
from sqlalchemy import create_engine


def database_connect(user, password, host, port, db):
    engine = create_engine(
        f'postgresql://{user}:{password}@{host}:{port}/{db}')
    engine.connect()
    return engine


def transform_data(csv_file=None, sql='', db_engine=None):
    if csv_file is not None:
        df = pd.read_csv(csv_file)
    else:
        df = pd.read_sql(sql, db_engine)

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

    if csv_file is not None:
        csv_file = 'cleaned(stg)_' + csv_file
        df.to_csv(csv_file, index=False)
    else:
        df.to_csv('cleaned(stg)_online_retails.csv', index=False)

    return df

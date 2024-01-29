from time import time
import pandas as pd
import argparse
import utils


def batch_load_data(engine, csv_file, table_name):
    df_iter = pd.read_csv(csv_file, iterator=True, chunksize=100000)
    df = next(df_iter)

    df.InvoiceDate = pd.to_datetime(df.InvoiceDate)
    df.head(n=0).to_sql(name=table_name, con=engine,
                        if_exists='replace', index=True, index_label='Id')
    df.to_sql(name=table_name, con=engine, if_exists='append',
              index=True, index_label='Id')

    elapsed_time = -1
    try:
        t_start = time()
        chuncks_cnt = 0

        while True:
            chuncks_cnt += 1
            chunck_start = time()

            df = next(df_iter)
            df.InvoiceDate = pd.to_datetime(df.InvoiceDate)
            df.to_sql(name=table_name, con=engine,
                      if_exists='append', index=True, index_label='Id')
            print(
                f'Inserted chunck {chuncks_cnt} in {time()-chunck_start:.3}s')
    except:
        elapsed_time = time() - t_start
        print(f'Finished ingestion into table: {table_name}')
        print(f'Number of chuncks: {chuncks_cnt}')
        print(f'Time taken: {elapsed_time:.3}s')

    return elapsed_time


def main(params):
    user = params.user
    password = params.password
    host = params.host
    port = params.port
    db = params.db
    table_name = params.table_name
    csv_file = params.csv_file

    db_engine = utils.database_connect(user, password, host, port, db)
    batch_load_data(db_engine, csv_file, table_name)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Ingest CSV data to Postgres')

    parser.add_argument('--user', required=True, help='user name for postgres')
    parser.add_argument('--password', required=True,
                        help='password for postgres')
    parser.add_argument('--host', required=True, help='host for postgres')
    parser.add_argument('--port', required=True, help='port for postgres')
    parser.add_argument('--db', required=True,
                        help='database name for postgres')
    parser.add_argument('--table_name', required=True,
                        help='name of the table where we will write the results to')
    parser.add_argument('--csv_file', required=True,
                        help='path of the csv file')

    args = parser.parse_args()

    main(args)

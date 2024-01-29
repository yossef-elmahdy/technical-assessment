from sqlalchemy import create_engine, text
from time import time
import pandas as pd
import argparse
import utils


def clean_validate_data(db_engine):
    sql = '''
        SELECT * 
        FROM online_retail
    '''
    df = utils.transform_data(sql=sql, db_engine=db_engine)

    t_start = time()
    df.to_sql(name='online_retail_cleaned', con=db_engine,
              if_exists='replace', index=True, index_label='Id')
    print(f'Finished insertion in {time()-t_start:.3}s')

    query = 'ALTER TABLE "online_retail_cleaned" ADD PRIMARY KEY ("Id");'
    with db_engine.connect() as db_conn:
        db_conn.execute(text(query))
        db_conn.commit()


def main(params):
    user = params.user
    password = params.password
    host = params.host
    port = params.port
    db = params.db

    db_engine = utils.database_connect(user, password, host, port, db)
    clean_validate_data(db_engine)
    print(f'>> Successfully completed cleaning data and inserting into online_retail_cleaned <<')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Cleaning and validating data into ')

    parser.add_argument('--user', required=True, help='user name for postgres')
    parser.add_argument('--password', required=True,
                        help='password for postgres')
    parser.add_argument('--host', required=True, help='host for postgres')
    parser.add_argument('--port', required=True, help='port for postgres')
    parser.add_argument('--db', required=True,
                        help='database name for postgres')

    args = parser.parse_args()

    main(args)

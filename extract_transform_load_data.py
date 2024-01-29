import argparse
import utils
import etl_utils


def run_etl(base_url, db_engine):
    cnt = 0
    file_not_found = 0
    while file_not_found == 0:
        url = ''
        csv_file = 'online_retail_' + str(cnt) + '.csv'
        url = base_url + csv_file
        print(f'Downloading file {csv_file} .. ')
        file_not_found = etl_utils.extract_data(url, csv_file)
        csv_file = 'ext_' + csv_file
        if file_not_found == 0:
            df = utils.transform_data(csv_file=csv_file)
            etl_utils.load_data(df, db_engine)
            cnt += 1
    return cnt


def main(params):
    user = params.user
    password = params.password
    host = params.host
    port = params.port
    db = params.db
    base_url = params.base_url

    db_engine = utils.database_connect(user, password, host, port, db)
    files_completed_cnt = run_etl(base_url, db_engine)
    print(f'>> Successfully completed {files_completed_cnt} csv files <<')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Extract, transform and load data to our Transactional and DWH')

    parser.add_argument('--user', required=True, help='user name for postgres')
    parser.add_argument('--password', required=True,
                        help='password for postgres')
    parser.add_argument('--host', required=True, help='host for postgres')
    parser.add_argument('--port', required=True, help='port for postgres')
    parser.add_argument('--db', required=True,
                        help='database name for postgres')
    parser.add_argument('--base_url', required=True,
                        help='The base url for the source of CSV files (must contain same format of main data)')

    args = parser.parse_args()

    main(args)

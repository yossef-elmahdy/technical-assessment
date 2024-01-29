#!/bin/bash

echo 'Parallel Executing ingest_base_data.py > clean_data.py > build_populate_dwh.py > extract_transform_load_data.py > '

exec python3 /app/ingest_base_data.py --user root --password root --host postgres-db --port 5432 --db RetailDB --table_name online_retail --csv_file online_retail.csv &
exec python3 /app/clean_data.py --user root --password root --host postgres-db --port 5432 --db RetailDB &
exec python3 /app/build_populate_dwh.py --user root --password root --host postgres-db --port 5432 --db RetailDB &
exec python3 /app/extract_transform_load_data.py --user root --password root --host postgres-db --port 5432 --db RetailDB --base_url https://github.com/yossef-elmahdy/technical-assessment/releases/download/online-retail-data/ &
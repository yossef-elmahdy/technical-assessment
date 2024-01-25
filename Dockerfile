FROM python:3.9

RUN pip install pandas sqlalchemy psycopg2

WORKDIR /app
COPY ingest_data.py ingest_data.py 
COPY ./jupyter-data/online_retail.csv online_retail.csv

ENTRYPOINT [ "python", "ingest_data.py" ]


# 1. docker build -t ingest-retail-data:v1 .
# 2. docker run -it --network=global-network ingest-retail-data:v1 --user root --password root --host postgres-db --port 5432 --db RetailDB --table_name online_retail --csv_file online_retail.csv 
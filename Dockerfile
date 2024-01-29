FROM python:3.9

RUN pip install pandas sqlalchemy psycopg2

WORKDIR /app 

COPY utils.py utils.py

COPY ingest_base_data.py ingest_base_data.py 
COPY ./jupyter-data/online_retail.csv online_retail.csv

COPY clean_data,py clean_data.py 

COPY build_populate_dwh,py build_populate_dwh.py 

COPY etl_utils.py etl_utils.py 
COPY extract_transform_load_data.py extract_transform_load_data.py

COPY run_project.sh  run_project.sh 
RUN chmod a+x run_project.sh 

ENTRYPOINT [ "./run_project.sh"]

# 1. docker build -t artefact-project:v01 .
# 2. (winpty) docker run -it --network=global-network artefact-project:v01

# Technical Assessment Solution 
My solution submission for the technical assessment task. 

## Project Pipeline 
![project-pipeline](https://github.com/yossef-elmahdy/technical-assessment/blob/main/images/project_flow.png)

## How to run 
I desgined the code to be dockerized on container to run all scripts on one container containing the data and the flow of the execution. 

### 1. Running docker-compose 
You need to run `docker-compose.yml` file first to build the environment that holds the data, it contains: 
1. Jupyter Notebook (port: 8888)
2. Postgres Database (port: 5432)
    - User: root 
    - Password: root 
    - DB: RetailDB
3. Pg-Admin4 (port: 8080)
    - Email: admin@admin.com
    - Password: root  

You can build the containers by typing the following on main project directory where `doscker-compose.yml` is located  
```yaml
docker-compose up -d 
```
> Note: [Docker](https://www.docker.com/) should be installed. 


### 2. Configure pg-admin4 to connect to RetailDB 
![configure_1](https://github.com/yossef-elmahdy/technical-assessment/blob/main/images/configure_1.png)
![configure_2](https://github.com/yossef-elmahdy/technical-assessment/blob/main/images/configure_2.png)
![configure_3](https://github.com/yossef-elmahdy/technical-assessment/blob/main/images/configure_3.png)

### 3. Running scripts container 
To be able to run the scripts, you need to build and and run the `Dockerfile`, you can execute the following commands on the directory that contains `Dockerfile`

1. Build the image: artefact-project:v01
    ```yaml
    docker build -t artefact-project:v01 .
    ```
2. Build and run the container 
    ```yaml
    docker run -it --network=global-network --name artefact_project_container artefact-project:v01
    ```

### 4. Schedule Run 
To run the scripts periodically, we need to establish schedule run to run the code, on our case I've built cron job to **run the code every day at 10:00 AM.** 
On your CMD run the following commands 
1. Open crontab 
    ```console
    crontab -e
    ```
2. Put the schdule on bottom of oppened file, close the file and save 
    ```console
    0 10 * * *  docker build -t artefact-project:v01 . && docker run -it --network=global-network --name artefact_project_container artefact-project:v01      
    ```
You can watch your schdules log by typing the following command 
```yaml 
greb CRON /var/log/sylog
```

## Data Warehouse Schema 
![dwh-schema](https://github.com/yossef-elmahdy/technical-assessment/blob/main/dwh-design/oneline-retail-dwh-v4.png)

## Project Investigation and dig-deep 
You can find my sandbox **Jupyter Notebooks** on `jupyter-data` directory that contains investigations and what I was thinking and executing before building final scripts 


## Project Structure 
├── Dockerfile \
├── README.md \
├── build_populate_dwh.py \
├── clean_data.py \
├── docker-compose.yml \
├── dwh-design \
├── etl-data \
├── etl_utils.py \
├── extract_transform_load_data.py \
├── ingest_base_data.py \
├── jupyter-data \
│   ├── data_cleaning_validation.ipynb \
│   ├── data_ingestion.ipynb \
│   ├── data_warehouse_build.ipynb \
│   ├── etl_process.ipynb \
│   ├── online_retail.csv \
├── run_project.sh \
└── utils.py 

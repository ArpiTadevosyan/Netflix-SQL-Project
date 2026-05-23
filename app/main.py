from extract import extract_data
from transform import transform_data
from load import load_data

CSV_FILE_PATH = "../data/netflix_titless.csv"
SQL_SERVER_NAME = "DESKTOP-17264RF\\SQLEXPRESS"

def run_pipeline():
    print("STARTING ETL PIPELINE...")
    

    raw_data = extract_data(CSV_FILE_PATH)
    if raw_data is None: return
    

    cleaned_data = transform_data(raw_data)
    
    load_data(cleaned_data, SQL_SERVER_NAME)
    
    print("ETL PIPELINE FINISHED.")

if __name__ == "__main__":
    run_pipeline()

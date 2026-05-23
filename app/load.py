import pandas as pd
from sqlalchemy import create_engine
from urllib.parse import quote_plus

def load_data(df, server_name):
    print("Executing: LOAD PHASE")
    
    conn_param = quote_plus(
        f"DRIVER={{ODBC Driver 17 for SQL Server}};"
        f"SERVER={server_name};"
        f"DATABASE=NetflixDB;"
        f"Trusted_Connection=yes;"
    )
    
    try:
       
        engine = create_engine(f"mssql+pyodbc:///?odbc_connect={conn_param}")
        
        df.to_sql('netflix_raw', con=engine, if_exists='replace', index=False)
        
        print("netflix_raw table loaded successfully to SQL Server!")
        return engine
        
    except Exception as e:
        print(f"Error during loading data: {e}")
        return None

import pandas as pd

def transform_data(df):
    print("Executing: TRANSFORM PHASE")
    
    df['director'] = df['director'].fillna('Unknown')
    df['country'] = df['country'].fillna('Unknown')
    df['cast'] = df['cast'].fillna('No Cast')
    df['rating'] = df['rating'].fillna('Not Rated')
    df['duration'] = df['duration'].fillna('Unknown')
    
   
    df['date_added'] = pd.to_datetime(df['date_added'].str.strip(), errors='coerce')
    
    df = df.drop_duplicates(subset=['show_id'])
    
    print("Data cleaning and transformation completed successfully.")
    return df

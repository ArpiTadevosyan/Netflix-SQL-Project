import pandas as pd

def extract_data(file_path):
    print("Executing: EXTRACT PHASE")
    try:
        df = pd.read_csv(file_path)
        print(f"Successfully extracted {len(df)} rows from CSV.")
        return df
    except Exception as e:
        print(f"Error during extraction: {e}")
        return None

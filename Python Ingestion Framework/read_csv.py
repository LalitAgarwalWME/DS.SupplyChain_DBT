import pandas as pd
 
def read_csv(source_object):
 
    file_path = f"Data\\{source_object}.csv"
 
    df = pd.read_csv(file_path)
 
    print(f"Source Rows Processed : {len(df)}")
 
    return df
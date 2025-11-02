import pandas as pd
from sqlalchemy import create_engine

connection_string = 'postgresql://postgres:gelo120601@localhost/painting'
db = create_engine(connection_string)
conn = db.connect()

files = ['artist','canvas_size','image_link','museum','museum_hours',
         'product_size','subject','work']

for file in files:
    df = pd.read_csv(f'C:/Users/ryana/Documents/Github/famous_paintings/dataset/{file}.csv')
    df.to_sql(file, con=conn, if_exists='replace', index=False)

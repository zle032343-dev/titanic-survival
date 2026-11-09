import pandas as pd

train = pd.read_csv("/data/train.csv")
print(f"Training data: {train.shape[0]} rows, {train.shape[1]} columns")
print("Columns:", ", ".join(train.columns))
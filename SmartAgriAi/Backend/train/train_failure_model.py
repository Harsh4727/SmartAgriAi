import pandas as pd
from sklearn.ensemble import RandomForestClassifier
import pickle

df = pd.read_csv("failure_data.csv")

X = df[['temperature','rainfall','ndvi']]
y = df['failure']

model = RandomForestClassifier()
model.fit(X, y)

pickle.dump(model, open("../ml/failure_model.pkl", "wb"))

print("Failure model saved")

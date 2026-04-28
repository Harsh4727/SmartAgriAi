import pandas as pd
from sklearn.ensemble import RandomForestClassifier
import pickle

df = pd.read_csv("crop_recommendation.csv")

X = df[['temperature','humidity','ph','rainfall']]
y = df['label']

model = RandomForestClassifier()
model.fit(X, y)

pickle.dump(model, open("../ml/crop_model.pkl", "wb"))

print("MODEL SAVED SUCCESSFULLY")
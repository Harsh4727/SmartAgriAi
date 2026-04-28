from fastapi.middleware.cors import CORSMiddleware
#Save Result to Database
from db import Base, engine, SessionLocal
from models import Prediction

#Signup API
from models import Farmer
from db import SessionLocal
from fastapi import Form

Base.metadata.create_all(bind=engine)

from fastapi import FastAPI
import requests
import pickle
import random
import numpy as np

failure_model = pickle.load(open("ml/failure_model.pkl","rb"))

# def get_ndvi(lat: float, lon: float):
#     return round(random.uniform(0.2, 0.8), 2)
#from services.ndvi_real import get_real_ndvi

from services.ndvi_api import get_ndvi

import ee
# Initialize Earth Engine
ee.Initialize(project='smartagriai-ndvi')


import sqlite3

conn = sqlite3.connect("smartagri.db", check_same_thread=False)
cursor = conn.cursor()

# cursor.execute("""
# INSERT INTO farmers (name, phone, village, district)
# VALUES ('Harsh','9825147128','Khambhat','Anand')
# """)

conn.commit()

print("Farmer inserted successfully")

cursor.execute("""
CREATE TABLE IF NOT EXISTS prediction_history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    farmer_id INTEGER,
    module TEXT,
    input_data TEXT,
    result TEXT,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
""")
conn.commit()

cursor.execute("""
CREATE TABLE IF NOT EXISTS farmers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    phone TEXT,
    village TEXT,
    district TEXT
)
""")
conn.commit()

def get_ndvi(lat, lon):

    point = ee.Geometry.Point([lon, lat])

    image = (
        ee.ImageCollection("COPERNICUS/S2_SR_HARMONIZED")
        .filterBounds(point)
        .sort("CLOUDY_PIXEL_PERCENTAGE")
        .first()
    )

    ndvi = image.normalizedDifference(['B8', 'B4'])

    value = ndvi.reduceRegion(
        reducer=ee.Reducer.mean(),
        geometry=point,
        scale=10
    ).getInfo()

    return value["nd"]


#Save Result to Database
def save_prediction(data):
    db = SessionLocal()
    record = Prediction(**data)
    db.add(record)
    db.commit()
    db.close()


crop_model = pickle.load(open("ml/crop_model.pkl","rb"))

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

API_KEY = "e010615efab1f789840c0bbbca2a7e4c"

# @app.get("/weather")
# def get_weather(city: str):
#     url = f"https://api.openweathermap.org/data/2.5/weather?q={city}&appid={API_KEY}&units=metric"
#     data = requests.get(url).json()

#     return {
#         "city": city,
#         "temperature": data["main"]["temp"],
#         "humidity": data["main"]["humidity"]
#     }

# @app.get("/recommend")
# def recommend_crop(temp: float, humidity: float, ph: float, rainfall: float):

#     features = [[temp, humidity, ph, rainfall]]
#     crop = crop_model.predict(features)[0]

#     return {
#         "recommended_crop": crop
#     }

@app.get("/ndvi")
def get_ndvi(lat: float, lon: float):

    point = ee.Geometry.Point([lon, lat])

    collection = (
        ee.ImageCollection("COPERNICUS/S2_SR_HARMONIZED")
        .filterBounds(point)
        .filterDate("2024-01-01", "2024-12-31")
        .sort("CLOUDY_PIXEL_PERCENTAGE")
        .first()
    )

    ndvi = collection.normalizedDifference(["B8", "B4"]).rename("NDVI")

    value = ndvi.reduceRegion(
        reducer=ee.Reducer.mean(),
        geometry=point,
        scale=10
    ).getInfo()

    ndvi_value = value.get("NDVI", 0)

    health = "Healthy"

    if ndvi_value < 0.2:
        health = "Poor"
    elif ndvi_value < 0.5:
        health = "Moderate"

    return {
        "ndvi": ndvi_value,
        "health": health
    }

# @app.get("/ndvi")
# def ndvi_api(lat: float, lon: float):

#     ndvi_value = get_ndvi(lat, lon)

#     if ndvi_value is None:
#         status = "No Data"

#     elif ndvi_value > 0.6:
#         status = "Healthy Crop"

#     elif ndvi_value > 0.3:
#         status = "Moderate Crop"

#     else:
#         status = "Poor Crop"

#     return {
#         "ndvi": ndvi_value,
#         "health": status
#     }

from fastapi import Query

@app.get("/smart-recommend")
def smart_recommend(
    city: str = Query(...),
    soil_ph: float = Query(...),
    rainfall: float = Query(...)
):

    print("City:", city)
    print("Soil PH:", soil_ph)
    print("Rainfall:", rainfall)

    # Dummy logic (your ML model can be used here)

    if soil_ph > 7:
        crop = "Rice"
    else:
        crop = "Wheat"

    cursor.execute("""
    INSERT INTO prediction_history (farmer_id, module, input_data, result)
    VALUES (?, ?, ?, ?)
    """, (
        1,
        "Crop Recommendation",
        f"city={city}, soil_ph={soil_ph}, rainfall={rainfall}",
        crop
    ))

    conn.commit()

    return {
        "recommended_crop": crop
    }

    # return {
    #     "city": city,
    #     "temperature": temp,
    #     "humidity": humidity,
    #     "recommended_crop": crop
    # }

#Crop Rotation Rules
rotation_rules = {
    "rice": "pulses",
    "wheat": "lentils",
    "cotton": "chickpea",
    "sugarcane": "groundnut",
    "maize": "soybean",
    "millet": "pulses"
}

#Function for Suggesting Next Crop
@app.get("/next-crop")
def next_crop(current_crop: str):

    rotation = {
        "rice": ("wheat", "Wheat improves nitrogen balance after rice"),
        "wheat": ("maize", "Maize helps reduce wheat pests"),
        "maize": ("cotton", "Cotton benefits from maize soil nutrients"),
        "cotton": ("groundnut", "Groundnut restores soil nitrogen"),
    }

    crop = current_crop.lower()

    if crop in rotation:
        next_crop, reason = rotation[crop]
    else:
        next_crop = "pulses"
        reason = "Pulses improve soil fertility"

    return {
        "current_crop": current_crop,
        "next_crop": next_crop,
        "reason": reason
    }

#API For Failure Prediction
# @app.get("/failure-risk")
# def failure_risk(city: str, lat: float, lon: float):

#     # Weather
#     url = f"https://api.openweathermap.org/data/2.5/weather?q={city}&appid={API_KEY}&units=metric"
#     data = requests.get(url).json()

#     temp = data["main"]["temp"]
#     rainfall = data.get("rain", {}).get("1h", 10)

#     # REAL NDVI
#     ndvi = get_real_ndvi(lat, lon)

#     pred = failure_model.predict([[temp, rainfall, ndvi]])[0]
#     risk = "HIGH" if pred == 1 else "LOW"

#     return {
#         "temperature": temp,
#         "rainfall": rainfall,
#         "ndvi": ndvi,
#         "risk": risk
#     }

@app.get("/failure-risk")
def failure_risk(city: str, lat: float, lon: float):

    # Weather
    url = f"https://api.openweathermap.org/data/2.5/weather?q={city}&appid={API_KEY}&units=metric"
    data = requests.get(url).json()
    print(data)
    temp = data.get("main", {}).get("temp", 0)
    #temp = data["main"]["temp"]
    #rainfall = data.get("rain", {}).get("1h", 10)
    rainfall = data.get("rain", {}).get("1h", 0)

    # NDVI (safe)
    ndvi = get_ndvi(lat, lon)

    if ndvi is None:
        # fallback NDVI
        ndvi = 0.4   # “average” vegetation health

    pred = failure_model.predict([[temp, rainfall, ndvi]])[0]
    risk = "HIGH" if pred == 1 else "LOW"

    result = {
        "temperature": temp,
        "rainfall": rainfall,
        "ndvi": ndvi,
        "risk": risk
    }

    save_prediction({
        "city": city,
        "crop": "N/A",
        "risk": risk,
        "ndvi": ndvi,
        "temperature": temp,
        "rainfall": rainfall
    })

    return result

    # return {
    #     "temperature": temp,
    #     "rainfall": rainfall,
    #     "ndvi": ndvi,
    #     "risk": risk
    # }

#Signup API
@app.post("/signup")
def signup(
    name: str = Form(...),
    phone: str = Form(...),
    village: str = Form(...),
    district: str = Form(...),
    password: str = Form(...)
):

    db = SessionLocal()

    existing = db.query(Farmer).filter(Farmer.phone == phone).first()

    if existing:
        return {"message": "Phone already registered"}

    farmer = Farmer(
        name=name,
        phone=phone,
        village=village,
        district=district,
        password=password
    )

    db.add(farmer)
    db.commit()

    return {"message": "Signup successful"}
# @app.post("/signup")
# def signup(name: str, phone: str, village: str, district: str, password: str):

#     db = SessionLocal()

#     existing = db.query(Farmer).filter(Farmer.phone == phone).first()

#     if existing:
#         return {"message": "Phone already registered"}

#     farmer = Farmer(
#         name=name,
#         phone=phone,
#         village=village,
#         district=district,
#         password=password
#     )

#     db.add(farmer)
#     db.commit()

#     return {"message": "Signup successful"}

#Login API
@app.post("/login")
def login(
    phone: str = Form(...),
    password: str = Form(...)
):

    db = SessionLocal()

    farmer = db.query(Farmer).filter(
        Farmer.phone == phone,
        Farmer.password == password
    ).first()

    if farmer:
        return {
            "message": "Login successful",
            "name": farmer.name,
            "farmer_id": farmer.id
        }

    return {"message": "Invalid phone or password"}
# @app.post("/login")
# def login(phone: str, password: str):

#     db = SessionLocal()

#     farmer = db.query(Farmer).filter(
#         Farmer.phone == phone,
#         Farmer.password == password
#     ).first()

#     if farmer:
#         return {
#             "message": "Login successful",
#             "name": farmer.name,
#             "farmer_id": farmer.id
#         }

#     return {"message": "Invalid phone or password"}

@app.get("/prediction-history")
def get_history():

    cursor.execute("""
    SELECT module, input_data, result, date
    FROM prediction_history
    ORDER BY date DESC
    """)

    rows = cursor.fetchall()

    history = []

    for r in rows:
        history.append({
            "module": r[0],
            "input": r[1],
            "result": r[2],
            "date": r[3]
        })

    return {"history": history}

@app.get("/farmer/{farmer_id}")
def get_farmer_profile(farmer_id: int):

    cursor.execute("""
    SELECT name, phone, village, district
    FROM farmers
    WHERE id=?
    """,(farmer_id,))

    row = cursor.fetchone()

    print("DATABASE ROW:", row)

    if row:
        return {
            "name": row[0],
            "phone": row[1],
            "village": row[2],
            "district": row[3]
        }

    return {"error":"Farmer not found"}

@app.get("/compensation")
def get_compensation(lat: float, lon: float):

    # Example logic (replace with your dataset lookup)
    if lat and lon:
        return {
            "scheme": "PM Fasal Bima Yojana",
            "amount": 5000
        }

    return {
        "scheme": "No scheme found",
        "amount": 0
    }
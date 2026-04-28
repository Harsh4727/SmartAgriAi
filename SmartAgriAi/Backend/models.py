from sqlalchemy import Column, Integer, String, Float, DateTime
from datetime import datetime
from db import Base

class Prediction(Base):
    __tablename__ = "predictions"

    id = Column(Integer, primary_key=True, index=True)
    city = Column(String)
    crop = Column(String)
    risk = Column(String)
    ndvi = Column(Float)
    temperature = Column(Float)
    rainfall = Column(Float)
    created_at = Column(DateTime, default=datetime.utcnow)

class Farmer(Base):
    __tablename__ = "farmers"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String)
    phone = Column(String, unique=True)
    village = Column(String)
    district = Column(String)
    password = Column(String)
from db import SessionLocal
from models import Prediction

db = SessionLocal()

rows = db.query(Prediction).all()

for r in rows:
    print(r.id, r.city, r.crop, r.risk, r.temperature, r.ndvi, r.created_at)

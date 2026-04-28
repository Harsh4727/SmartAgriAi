import requests

def get_ndvi(lat, lon):
    try:
        url = (
            f"https://vegetation-api.open-meteo.com/v1/ndvi?"
            f"latitude={lat}&longitude={lon}&past_days=30"
        )

        res = requests.get(url, timeout=10).json()

        values = res.get("ndvi", {}).get("values", [])

        if not values:
            return None

        return round(values[-1], 3)

    except Exception as e:
        # if API fails, return None so backend doesn't crash
        print("NDVI API error:", e)
        return None

#This File is Not in Use

import ee

# Initialize Earth Engine
ee.Initialize()

def get_real_ndvi(lat, lon):

    point = ee.Geometry.Point(lon, lat)

    # Load Sentinel-2 image collection
    collection = (
        ee.ImageCollection("COPERNICUS/S2")
        .filterBounds(point)
        .filterDate("2024-01-01", "2024-12-31")
        .filter(ee.Filter.lt("CLOUDY_PIXEL_PERCENTAGE", 20))
        .median()
    )

    ndvi_image = collection.normalizedDifference(["B8", "B4"]).rename("NDVI")

    ndvi_value = ndvi_image.reduceRegion(
        reducer=ee.Reducer.mean(),
        geometry=point,
        scale=10
    ).get("NDVI")

    ndvi = ndvi_value.getInfo()

    return round(ndvi, 3) if ndvi else None

# import json
# import firebase_admin
# from firebase_admin import credentials
# from firebase_admin import firestore

# # 🔑 Step 1: Initialize Firebase
# cred = credentials.Certificate(r'd:\Project\RoadEyeAI\zonedatabase-d0432-firebase-adminsdk-fbsvc-3f55e1789f.json')
# firebase_admin.initialize_app(cred)

# db = firestore.client()

# # 🗂 Step 2: Load HMV restricted zones GeoJSON
# with open(r'd:\Project\RoadEyeAI\data\zonedatabase.geojson', 'r', encoding='utf-8') as f:
#     geo_data = json.load(f)

# # 🛣 Step 3: Upload each feature to Firestore
# collection_name = 'ZoneData'  # You can rename this

# for feature in geo_data.get('features', []):
#     zone_id = feature.get('id') or feature.get('properties', {}).get('osm_id')
    
#     if not zone_id:
#         continue
    
#     # Create a document with feature data
#     doc_ref = db.collection(collection_name).document(str(zone_id))
    
#     data_to_upload = {
#         'type': feature.get('geometry', {}).get('type'),
#         'coordinates': feature.get('geometry', {}).get('coordinates'),
#         'properties': feature.get('properties', {})
#     }
    
#     doc_ref.set(data_to_upload)

# print(f"✅ Uploaded {len(geo_data.get('features', []))} HMV restricted zones to Firestore.")


# import json
# import firebase_admin
# from firebase_admin import credentials, firestore
# import re

# # ----------------------------
# # 1️⃣ Load Firebase credentials
# # ----------------------------
# cred = credentials.Certificate(r'd:\Project\RoadEyeAI\zonedatabase-d0432-firebase-adminsdk-fbsvc-3f55e1789f.json')
# firebase_admin.initialize_app(cred)

# # ----------------------------
# # 2️⃣ Initialize Firestore
# # ----------------------------
# db = firestore.client()
# collection_name = "DataZone"  # change this to your Firestore collection name

# # ----------------------------
# # 3️⃣ Load zone data (GeoJSON / Overpass JSON)
# # ----------------------------
# with open(r'd:\Project\RoadEyeAI\data\zonedatabase.geojson', 'r', encoding='utf-8') as f:
#     geo_data = json.load(f)

# # ----------------------------
# # 4️⃣ Upload each zone to Firestore
# # ----------------------------
# uploaded = 0
# skipped = 0

# for feature in geo_data.get("features", []):
#     zone_id = feature.get("id") or feature.get("properties", {}).get("osm_id")
#     zone_name = feature.get("properties", {}).get("name", "Unnamed Zone")

#     if not zone_id:
#         skipped += 1
#         print("⚠️ Skipping a zone with no valid ID.")
#         continue

#     # 🔧 Clean up zone_id for Firestore (remove invalid chars)
#     zone_id = re.sub(r"[^A-Za-z0-9_-]", "_", str(zone_id))

#     # Create Firestore document reference
#     doc_ref = db.collection(collection_name).document(zone_id)

#     try:
#         doc_ref.set({
#             "id": zone_id,
#             "name": zone_name,
#             "type": feature.get("type", "Unknown"),
#             "geometry": feature.get("geometry", {}),
#             "properties": feature.get("properties", {}),
#         })
#         uploaded += 1
#         print(f"✅ Uploaded zone: {zone_name} ({zone_id})")

#     except Exception as e:
#         skipped += 1
#         print(f"❌ Failed to upload {zone_id}: {e}")

# # ----------------------------
# # 5️⃣ Summary
# # ----------------------------
# print("\n---- Upload Summary ----")
# print(f"✅ Uploaded: {uploaded}")
# print(f"⚠️ Skipped: {skipped}")
# print("-------------------------")


# import json
# import firebase_admin
# from firebase_admin import credentials, firestore
# import re

# cred = credentials.Certificate(r'd:\Project\RoadEyeAI\zonedatabase-d0432-firebase-adminsdk-fbsvc-3f55e1789f.json')
# firebase_admin.initialize_app(cred)

# db = firestore.client()
# collection_name = "ZoneData"

# with open(r'd:\Project\RoadEyeAI\data\zonedatabase.geojson', 'r', encoding='utf-8') as f:
#     geo_data = json.load(f)

# uploaded = 0
# skipped = 0

# for feature in geo_data.get("features", []):
#     zone_id = feature.get("id") or feature.get("properties", {}).get("osm_id")
#     zone_name = feature.get("properties", {}).get("name", "Unnamed Zone")

#     if not zone_id:
#         skipped += 1
#         continue

#     zone_id = re.sub(r"[^A-Za-z0-9_-]", "_", str(zone_id))

#     doc_ref = db.collection(collection_name).document(zone_id)

#     # 🔧 Convert geometry to JSON text
#     geometry_json = json.dumps(feature.get("geometry", {}), ensure_ascii=False)

#     try:
#         doc_ref.set({
#             "id": zone_id,
#             "name": zone_name,
#             "geometry_json": geometry_json,  # ✅ store as string
#             "properties": feature.get("properties", {}),
#         })
#         uploaded += 1
#         print(f"✅ Uploaded zone: {zone_name} ({zone_id})")

#     except Exception as e:
#         skipped += 1
#         print(f"❌ Failed to upload {zone_id}: {e}")

# print("\n---- Upload Summary ----")
# print(f"✅ Uploaded: {uploaded}")
# print(f"⚠️ Skipped: {skipped}")
# print("-------------------------")

import json
import firebase_admin
from firebase_admin import credentials, firestore
import re
from shapely.geometry import shape, Point
from geopy.distance import geodesic

# 🔑 Initialize Firebase
cred = credentials.Certificate(r"d:\Project\RoadEyeAI\zonedatabase-d0432-firebase-adminsdk-fbsvc-3f55e1789f.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

collection_name = "ZoneData"

# 📂 Load GeoJSON
with open(r"d:\Project\RoadEyeAI\zonedatabase.geojson", "r", encoding="utf-8") as f:
    geo_data = json.load(f)

uploaded = 0
skipped = 0

def flatten_coords(coords):
    """Flatten coordinates to a simple list of [lon, lat] pairs."""
    flat = []
    def _flatten(c):
        if isinstance(c[0], (float, int)):
            flat.append(c)
        else:
            for i in c:
                _flatten(i)
    _flatten(coords)
    return flat

def get_center(flat_coords):
    """Calculate approximate center point."""
    if not flat_coords:
        return None
    lons = [c[0] for c in flat_coords]
    lats = [c[1] for c in flat_coords]
    return [sum(lons) / len(lons), sum(lats) / len(lats)]

for feature in geo_data.get("features", []):
    zone_id = feature.get("id") or feature.get("properties", {}).get("osm_id")
    if not zone_id:
        skipped += 1
        continue

    zone_id = re.sub(r"[^A-Za-z0-9_-]", "_", str(zone_id))
    props = feature.get("properties", {})
    geom = feature.get("geometry", {})

    geom_type = geom.get("type", "Unknown")
    coords = geom.get("coordinates", [])

    # 🗺️ Flatten and find center
    flat_coords = flatten_coords(coords)
    center = get_center(flat_coords)

    # ------------------------
    # CALCULATE RADIUS
    radius = None
    try:
        geo_shape = shape(geom)
        centroid = geo_shape.centroid
        center_coords = (centroid.y, centroid.x)  # (lat, lon)

        max_distance = 0
        if geo_shape.geom_type in ["Polygon", "MultiPolygon"]:
            # polygon: calculate distance from centroid to farthest vertex
            coords_list = list(geo_shape.exterior.coords)
            for c in coords_list:
                dist = geodesic(center_coords, (c[1], c[0])).meters
                if dist > max_distance:
                    max_distance = dist
        elif geo_shape.geom_type == "LineString":
            # line: half-length as radius
            coords_list = list(geo_shape.coords)
            total_length = 0
            for i in range(len(coords_list)-1):
                total_length += geodesic((coords_list[i][1], coords_list[i][0]),
                                         (coords_list[i+1][1], coords_list[i+1][0])).meters
            max_distance = total_length / 2

        radius = round(max_distance, 2)
    except Exception as e:
        print(f"⚠️ Could not calculate radius for {zone_id}: {e}")

    # ------------------------

    doc_data = {
        "active_hours": "08:00–11:00, 17:00–21:00",
        "inactive_hours": "21:00–08:00",
        "id": zone_id,
        "city": "Pune",
        "geometry_type": geom_type,
        "center": {"lon": center[0], "lat": center[1]} if center else None,
        "radius_meters": radius,
        "coordinates_count": len(flat_coords),
        "properties": props,
    }

    try:
        db.collection(collection_name).document(zone_id).set(doc_data)
        uploaded += 1
        print(f"✅ Uploaded: {zone_id}")
    except Exception as e:
        skipped += 1
        print(f"❌ Failed {zone_id}: {e}")

# docs = db.collection("HMV_Restricted_Zones").stream()
# for doc in docs:
#     doc.reference.delete()
#     print(f"🗑️ Deleted document: {doc.id}")

# print("✅ All documents deleted from ZoneData")

print("\n---- Upload Summary ----")
print(f"✅ Uploaded: {uploaded}")
print(f"⚠️ Skipped: {skipped}")
print("-------------------------")

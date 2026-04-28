import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smartagriai_app/services/api_service.dart';
//import '../services/location_service.dart';
import 'package:geolocator/geolocator.dart';


class FailurePrediction extends StatefulWidget {
  @override
  _FailurePredictionState createState() => _FailurePredictionState();
}

class _FailurePredictionState extends State<FailurePrediction> {

  bool isLoading = false;

  TextEditingController cityController = TextEditingController();

  String temperature = "";
  String rainfall = "";
  String ndvi = "";
  String risk = "";

  Future<Position> getLocation() async {

    LocationPermission permission;

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permission permanently denied");
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );
  }

  checkFailureRisk() async {

  setState(() {
    isLoading = true;
  });

  try {

    // Get phone location
    Position position = await getLocation();

    double lat = position.latitude;
    double lon = position.longitude;

    print("Latitude: $lat");
    print("Longitude: $lon");

    // Call backend API
    var url = Uri.parse("${ApiService.baseUrl}/failure-risk?city=${cityController.text}&lat=$lat&lon=$lon");

    var response = await http.get(
      url,
      headers: {
        "ngrok-skip-browser-warning": "true"
      },
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    var result = jsonDecode(response.body);

    setState(() {
      temperature = result["temperature"].toString();
      rainfall = result["rainfall"].toString();
      ndvi = result["ndvi"].toString();
      risk = result["risk"].toString();
      isLoading = false;
    });

  } catch (e) {

    setState(() {
      isLoading = false;
    });

    print(e);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Unable to get prediction")),
    );

  }

}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Crop Failure Prediction"),
        backgroundColor: Colors.red,
      ),

      body: Padding(
        padding: EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              controller: cityController,
              decoration: InputDecoration(labelText: "City"),
            ),

            SizedBox(height: 20),

            isLoading
            ? CircularProgressIndicator(
              color: Colors.green,
            )
            : ElevatedButton(
                onPressed: checkFailureRisk,
                child: Text("Detect Location & Check Risk"),
              ),

            SizedBox(height: 30),

            Text("Temperature: $temperature °C",
                style: TextStyle(fontSize: 18)),

            Text("Rainfall: $rainfall mm",
                style: TextStyle(fontSize: 18)),

            Text("NDVI: $ndvi",
                style: TextStyle(fontSize: 18)),

            SizedBox(height: 10),

            Text(
              "Risk Level: $risk",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: risk == "HIGH" ? Colors.red : Colors.green,
              ),
            )

          ],
        ),
      ),
    );
  }
}
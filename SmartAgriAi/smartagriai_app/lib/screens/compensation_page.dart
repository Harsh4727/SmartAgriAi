import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:smartagriai_app/services/api_service.dart';

class CompensationPage extends StatefulWidget {
  @override
  _CompensationPageState createState() => _CompensationPageState();
}

class _CompensationPageState extends State<CompensationPage> {

  bool isLoading = false;

  TextEditingController cityController = TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController lonController = TextEditingController();

  String risk = "";
  String compensation = "";
  String cityName = "";
  String schemeName = "";
  String compensationAmount = "";

  Future<Map<String, double>> getLocation() async {

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception("Location services disabled");
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return {
      "lat": position.latitude,
      "lon": position.longitude
    };
  }

  Future getCompensation() async {

  var location = await getLocation();

  double lat = location["lat"]!;
  double lon = location["lon"]!;

  List<Placemark> placemarks =
    await placemarkFromCoordinates(lat, lon);

  String city = placemarks[0].locality ?? "Unknown";

  var url = Uri.parse(
  "${ApiService.baseUrl}/compensation?lat=$lat&lon=$lon"
  );

  var response = await http.get(
    url,
    headers: {
      "ngrok-skip-browser-warning": "true"
    },
  );

  print("STATUS: ${response.statusCode}");
  print("BODY: ${response.body}");

  //var result = jsonDecode(response.body);

  var data = jsonDecode(response.body);

  print("Compensation API Result: $data");

  setState(() {
    cityName = city;
    schemeName = data["scheme"].toString();
    compensationAmount = data["amount"].toString();
    isLoading = false;
  });

  // setState(() {
  //   compensation = data["compensation"];
  //   cityName = city;
  // });
}

  // Future checkCompensation() async {

  //   String city = cityController.text;
  //   String lat = latController.text;
  //   String lon = lonController.text;

  //   var url = Uri.parse(
  //       "http://127.0.0.1:8000/failure-risk?city=$city&lat=$lat&lon=$lon"
  //   );

  //   var response = await http.get(url);

  //   if(response.statusCode != 200){
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Server Error"))
  //     );
  //     return;
  //   }

  //   var data = jsonDecode(response.body);

  //   setState(() {

  //     risk = data["risk"];

  //     if(risk == "HIGH"){

  //       compensation =
  //       "⚠ High risk detected.\n\n"
  //       "Eligible for Government Crop Insurance.\n\n"
  //       "Suggested Scheme:\n"
  //       "Pradhan Mantri Fasal Bima Yojana (PMFBY)\n\n"
  //       "Visit nearest agriculture office.";

  //     }
  //     else{

  //       compensation =
  //       "Crop condition is safe.\n\nNo compensation required.";

  //     }

  //   });
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("Government Compensation"),
        backgroundColor: Colors.blue,
      ),

      body: Padding(
        padding: EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              controller: cityController,
              decoration: InputDecoration(labelText: "City"),
            ),

            // TextField(
            //   controller: latController,
            //   decoration: InputDecoration(labelText: "Latitude"),
            // ),

            // TextField(
            //   controller: lonController,
            //   decoration: InputDecoration  (labelText: "Longitude"),
            // ),

            SizedBox(height:20),

            isLoading
            ? CircularProgressIndicator(
              color: Colors.green,
            )
            : ElevatedButton(
                onPressed: getCompensation,
                child: Text("Check Compensation"),
              ),

            SizedBox(height:30),

            Text(
              "Scheme: $schemeName",
              style: TextStyle(fontSize: 18),
            ),

            Text(
              "Compensation Amount: ₹$compensationAmount",
              style: TextStyle(fontSize: 18),
            ),

            Text(
              compensation,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            )

          ],
        ),
      ),

    );
  }
}
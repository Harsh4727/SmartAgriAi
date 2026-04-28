import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smartagriai_app/services/api_service.dart';
import 'package:geolocator/geolocator.dart';
// import '../services/location_service.dart';


class NDVIPage extends StatefulWidget {
  @override
  _NDVIPageState createState() => _NDVIPageState();
}

class _NDVIPageState extends State<NDVIPage> {

  bool isLoading = false;

  TextEditingController cityController = TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController lonController = TextEditingController();

  double ndvi = 0.0;
  String healthStatus = "";

  String ndviValue = "";
  String cropHealth = "";

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
        desiredAccuracy: LocationAccuracy.high);
  }
  
  // Future getNDVI() async {

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

  //     ndvi = double.parse(data["ndvi"].toString());

  //     if(ndvi >= 0.6){
  //       healthStatus = "Healthy Crop 🌱";
  //     }
  //     else if(ndvi >= 0.3){
  //       healthStatus = "Moderate Crop Health ⚠";
  //     }
  //     else{
  //       healthStatus = "Poor Crop Health ❌";
  //     }

  //   });
  // }

  checkNDVI() async {

    setState(() {
      isLoading = true;
    });

    try {

      Position position = await getLocation();
      // Position position = await LocationService.getLocation();


      double lat = position.latitude;
      double lon = position.longitude;

      var url = Uri.parse(
          "${ApiService.baseUrl}/ndvi?lat=$lat&lon=$lon");

      var response = await http.get(
        url,
        headers: {
          "ngrok-skip-browser-warning": "true"
        },
      );

      print(response.body);

      var result = jsonDecode(response.body);

      setState(() {
        ndviValue = result["ndvi"].toString();
        cropHealth = result["health"];
        isLoading = false;
      });

    } catch (e) {

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unable to fetch NDVI")),
      );

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("NDVI Crop Health"),
        backgroundColor: Colors.teal,
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
            //   decoration: InputDecoration(labelText: "Longitude"),
            // ),

            SizedBox(height:20),

            isLoading
            ? CircularProgressIndicator(
              color: Colors.green,
            )
            : ElevatedButton(
                onPressed: checkNDVI,
                child: Text("Check Crop Health"),
              ),

            SizedBox(height:30),

            Text(
              "NDVI Value: $ndvi",
              style: TextStyle(fontSize: 20),
            ),

            SizedBox(height:10),

            Text(
              "Crop Health: $cropHealth",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: cropHealth == "Healthy"
                    ? Colors.green
                    : Colors.orange,
              ),
            ),

            Text(
              healthStatus,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold
              ),
            )

          ],
        ),
      ),

    );
  }
}
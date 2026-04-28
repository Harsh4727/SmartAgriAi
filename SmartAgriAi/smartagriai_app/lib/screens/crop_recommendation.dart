import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smartagriai_app/services/api_service.dart';

class CropRecommendation extends StatefulWidget {
  @override
  _CropRecommendationState createState() => _CropRecommendationState();
}

class _CropRecommendationState extends State<CropRecommendation> {

  TextEditingController cityController = TextEditingController();
  // TextEditingController phController = TextEditingController();
  TextEditingController rainfallController = TextEditingController();
  TextEditingController soilController = TextEditingController();

  String result = "";
  String recommendedCrop = "";

  bool isLoading = false;

  predictCrop() async {

    print("City: ${cityController.text}");
    print("Soil PH: ${soilController.text}");
    print("Rainfall: ${rainfallController.text}");

    if (cityController.text.isEmpty ||
        soilController.text.isEmpty ||
        rainfallController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      var url = Uri.parse(
        "${ApiService.baseUrl}/smart-recommend"
        "?city=${cityController.text}"
        "&soil_ph=${soilController.text}"
        "&rainfall=${rainfallController.text}"
      );

      var response = await http.get(
        url,
        headers: {
          "ngrok-skip-browser-warning": "true"
        },
      );

      print(response.body);

      var result = jsonDecode(response.body);

      setState(() {
        recommendedCrop = result["recommended_crop"].toString();
        isLoading = false;
      });

    } catch (e) {

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Server connection error")),
      );

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Crop Recommendation"),
        backgroundColor: Colors.green,
      ),

      body: Padding(
        padding: EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              controller: cityController,
              decoration: InputDecoration(labelText: "City"),
            ),
            
            

            TextField(
              controller: soilController,
              decoration: InputDecoration(labelText: "Soil pH"),
              keyboardType: TextInputType.number,
            ),

            TextField(
              controller: rainfallController,
              decoration: InputDecoration(labelText: "Rainfall"),
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 20),

            isLoading
            ? CircularProgressIndicator(
              color: Colors.green,
            )
            : ElevatedButton(
                onPressed: predictCrop,
                child: Text("Predict Crop"),
              ),

            SizedBox(height: 30),

            Text(
              "Recommended Crop:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),
            
            Text(
              recommendedCrop,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            )

            // Text(
            //   result,
            //   style: TextStyle(fontSize: 22, color: Colors.green),
            // )

          ],
        ),
      ),
    );
  }
}
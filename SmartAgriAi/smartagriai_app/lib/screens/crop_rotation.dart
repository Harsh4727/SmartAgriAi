import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smartagriai_app/services/api_service.dart';

class CropRotation extends StatefulWidget {
  @override
  _CropRotationState createState() => _CropRotationState();
}

class _CropRotationState extends State<CropRotation> {

  bool isLoading = false;

  TextEditingController cropController = TextEditingController();

  String currentCrop = "";
  String nextCrop = "";
  String reason = "";

  fetchNextCrop() async {

    if (cropController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter current crop")),
      );
      return;
    }

    try {

      var url = Uri.parse(
        "${ApiService.baseUrl}/next-crop?current_crop=${cropController.text}"
      );

      var response = await http.get(url);

      // PRINT FULL RESPONSE
      print("API Response Body: ${response.body}");

      var result = jsonDecode(response.body);

      // PRINT DECODED DATA
      print("Decoded Result: $result");

      // PRINT NEXT CROP VALUE
      print("Next Crop: ${result["next_crop"]}");

      setState(() {
        currentCrop = cropController.text;
        nextCrop = result["next_crop"].toString();
        reason = result["reason"].toString();
      });

    } catch (e) {

      print("Error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Server connection error")),
      );

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Crop Rotation"),
        backgroundColor: Colors.orange,
      ),

      body: Padding(
        padding: EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              controller: cropController,
              decoration: InputDecoration(
                labelText: "Current Crop",
                hintText: "Example: rice / wheat / cotton"
              ),
            ),

            SizedBox(height: 20),

            isLoading
            ? CircularProgressIndicator(
              color: Colors.green,
            )
            : ElevatedButton(
                onPressed: fetchNextCrop,
                child: Text("Suggest Next Crop"),
              ),

            SizedBox(height: 30),

            Text(
              "Current Crop: $currentCrop",
              style: TextStyle(fontSize: 18),
            ),

            SizedBox(height: 10),

            Text(
              "Recommended Next Crop: $nextCrop",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Reason:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            Text(reason)

          ],
        ),
      ),
    );
  }
}
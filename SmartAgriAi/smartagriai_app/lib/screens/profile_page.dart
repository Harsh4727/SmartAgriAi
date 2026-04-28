import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smartagriai_app/services/api_service.dart';
import 'edit_profile.dart';

class ProfilePage extends StatefulWidget {

  final int farmerId;

  ProfilePage({required this.farmerId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String name = "";
  String phone = "";
  String village = "";
  String district = "";

  fetchProfile() async {

    try {

      var url = Uri.parse("${ApiService.baseUrl}/farmer/1");

      print("API URL: $url");

      var response = await http.get(
        url,
        headers: {"ngrok-skip-browser-warning": "true"}
      );

      print("STATUS CODE: ${response.statusCode}");
      print("RAW RESPONSE: ${response.body}");

      var data = jsonDecode(response.body);

      print("DECODED DATA: $data");

      setState(() {

        name = data["name"].toString();
        phone = data["phone"].toString();
        village = data["village"].toString();
        district = data["district"].toString();

      });

    } catch (e) {

      print("ERROR OCCURRED: $e");

    }

  }

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("Farmer Profile"),
        backgroundColor: Colors.brown,
      ),

      body: Padding(
        padding: EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text("Name: $name", style: TextStyle(fontSize: 18)),
            SizedBox(height:10),

            Text("Phone: $phone", style: TextStyle(fontSize: 18)),
            SizedBox(height:10),

            Text("Village: $village", style: TextStyle(fontSize: 18)),
            SizedBox(height:10),

            Text("District: $district", style: TextStyle(fontSize: 18)),
            
            SizedBox(height:20),

            ElevatedButton(

              onPressed: (){

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfile(
                      name: name,
                      phone: phone,
                      village: village,
                      district: district,
                    ),
                  ),
                );

              },

              child: Text("Edit Profile"),

            )
          ],
        ),
      ),

    );
  }
}
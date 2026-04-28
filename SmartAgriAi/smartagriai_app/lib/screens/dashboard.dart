import 'package:flutter/material.dart';

import 'crop_recommendation.dart';
import 'failure_prediction.dart';
import 'crop_rotation.dart';
import 'ndvi_page.dart';
import 'compensation_page.dart';
import 'history_page.dart';
import 'profile_page.dart';
import 'login_screen.dart';

class Dashboard extends StatelessWidget {

  final int farmerId;
  final String farmerName;

  Dashboard({required this.farmerId, required this.farmerName});

  Widget dashboardCard(
      BuildContext context,
      String title,
      IconData icon,
      Color color,
      Widget page
      ) {

    return Card(

      elevation: 6,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),

      child: InkWell(

        borderRadius: BorderRadius.circular(18),

        onTap: () {

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );

        },

        child: Padding(

          padding: EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Icon(
                icon,
                size: 40,
                color: color,
              ),

              SizedBox(height:10),

              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  void logout(BuildContext context){

    showDialog(
      context: context,
      builder: (context){

        return AlertDialog(

          title: Text("Logout"),

          content: Text("Are you sure you want to logout?"),

          actions: [

            TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),

            TextButton(
              onPressed: (){

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false,
                );

              },
              child: Text("Logout"),
            )

          ],

        );

      },
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: Text("SmartAgriAI"),

        backgroundColor: Colors.green,

        actions: [

          IconButton(
            icon: Icon(Icons.logout),
            onPressed: (){
              logout(context);
            },
          )

        ],

      ),

      body: Padding(

        padding: EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(
              "Welcome $farmerName 🌾",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height:20),

            Expanded(

              child: GridView.count(

                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,

                children: [

                  dashboardCard(
                      context,
                      "Crop Recommendation",
                      Icons.agriculture,
                      Colors.green,
                      CropRecommendation()
                  ),

                  dashboardCard(
                      context,
                      "Crop Failure Risk",
                      Icons.warning,
                      Colors.red,
                      FailurePrediction()
                  ),

                  dashboardCard(
                      context,
                      "Crop Rotation",
                      Icons.autorenew,
                      Colors.orange,
                      CropRotation()
                  ),

                  dashboardCard(
                      context,
                      "NDVI Crop Health",
                      Icons.eco,
                      Colors.teal,
                      NDVIPage()
                  ),

                  dashboardCard(
                      context,
                      "Compensation Info",
                      Icons.attach_money,
                      Colors.blue,
                      CompensationPage()
                  ),

                  dashboardCard(
                      context,
                      "History",
                      Icons.history,
                      Colors.purple,
                      HistoryPage()
                  ),

                  dashboardCard(
                      context,
                      "Farmer Profile",
                      Icons.person,
                      Colors.brown,
                      ProfilePage(farmerId: farmerId)
                  ),

                ],

              ),

            )

          ],

        ),

      ),

    );

  }

}
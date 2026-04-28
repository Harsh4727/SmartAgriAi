import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController village = TextEditingController();
  TextEditingController district = TextEditingController();
  TextEditingController password = TextEditingController();

  signupUser() async {

    var res = await ApiService.signup(
        name.text,
        phone.text,
        village.text,
        district.text,
        password.text);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(res["message"])));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.green.shade50,

      appBar: AppBar(
        title: Text("Create Farmer Account"),
        backgroundColor: Colors.green,
      ),

      body: SingleChildScrollView(

        child: Padding(

          padding: EdgeInsets.all(24),

          child: Column(
            children: [

              Icon(
                Icons.person_add,
                size: 80,
                color: Colors.green,
              ),

              SizedBox(height:20),

              TextField(
                controller: name,
                decoration: InputDecoration(
                  labelText: "Farmer Name",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              SizedBox(height:20),

              TextField(
                controller: phone,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              SizedBox(height:20),

              TextField(
                controller: village,
                decoration: InputDecoration(
                  labelText: "Village",
                  prefixIcon: Icon(Icons.location_city),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              SizedBox(height:20),

              TextField(
                controller: district,
                decoration: InputDecoration(
                  labelText: "District",
                  prefixIcon: Icon(Icons.map),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              SizedBox(height:20),

              TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              SizedBox(height:30),

              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  onPressed: signupUser,

                  child: Text(
                    "Create Account",
                    style: TextStyle(fontSize:18),
                  ),

                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
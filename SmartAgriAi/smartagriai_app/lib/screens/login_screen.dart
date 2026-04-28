import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'signup_screen.dart';
import 'dashboard.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();

  loginUser() async {
    var res = await ApiService.login(phone.text, password.text);
    print("API RESPONSE: $res");  // debug
    if (res["message"] == "Login successful"){
      Navigator.pushReplacement(
          context,
        MaterialPageRoute(
          builder: (context) => Dashboard(
            farmerId: res["farmer_id"],
            farmerName: res["name"],
          ),
        ),
      );
    }
    else{

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res["message"] ?? "Login failed")),
      );

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.green.shade50,

      body: Center(

        child: SingleChildScrollView(

          child: Padding(
            padding: EdgeInsets.all(24),

            child: Column(
              children: [

                Icon(
                  Icons.agriculture,
                  size: 80,
                  color: Colors.green,
                ),

                SizedBox(height:10),

                Text(
                  "SmartAgriAI",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),

                SizedBox(height:30),

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

                SizedBox(height:25),

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

                    onPressed: loginUser,

                    child: Text(
                      "Login",
                      style: TextStyle(fontSize:18),
                    ),

                  ),
                ),

                SizedBox(height:15),

                TextButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignupScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Create New Account",
                    style: TextStyle(fontSize:16),
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
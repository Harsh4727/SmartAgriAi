import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {

  final String name;
  final String phone;
  final String village;
  final String district;

  EditProfile({
    required this.name,
    required this.phone,
    required this.village,
    required this.district,
  });

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  late TextEditingController name;
  late TextEditingController phone;
  late TextEditingController village;
  late TextEditingController district;
  late TextEditingController farmSize;
  late TextEditingController soilType;

  @override
  void initState() {
    super.initState();

    name = TextEditingController(text: widget.name);
    phone = TextEditingController(text: widget.phone);
    village = TextEditingController(text: widget.village);
    district = TextEditingController(text: widget.district);

    farmSize = TextEditingController();
    soilType = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("Edit Profile"),
        backgroundColor: Colors.green,
      ),

      body: SingleChildScrollView(

        child: Padding(
          padding: EdgeInsets.all(20),

          child: Column(
            children: [

              TextField(
                controller: name,
                decoration: InputDecoration(
                  labelText: "Farmer Name",
                  prefixIcon: Icon(Icons.person),
                ),
              ),

              SizedBox(height:20),

              TextField(
                controller: phone,
                decoration: InputDecoration(
                  labelText: "Phone",
                  prefixIcon: Icon(Icons.phone),
                ),
              ),

              SizedBox(height:20),

              TextField(
                controller: village,
                decoration: InputDecoration(
                  labelText: "Village",
                  prefixIcon: Icon(Icons.location_city),
                ),
              ),

              SizedBox(height:20),

              TextField(
                controller: district,
                decoration: InputDecoration(
                  labelText: "District",
                  prefixIcon: Icon(Icons.map),
                ),
              ),

              SizedBox(height:20),

              TextField(
                controller: farmSize,
                decoration: InputDecoration(
                  labelText: "Farm Size (acres)",
                  prefixIcon: Icon(Icons.agriculture),
                ),
              ),

              SizedBox(height:20),

              TextField(
                controller: soilType,
                decoration: InputDecoration(
                  labelText: "Soil Type",
                  prefixIcon: Icon(Icons.eco),
                ),
              ),

              SizedBox(height:30),

              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),

                  onPressed: () {

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Profile Updated")),
                    );

                  },

                  child: Text(
                    "Save Changes",
                    style: TextStyle(fontSize:18),
                  ),

                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
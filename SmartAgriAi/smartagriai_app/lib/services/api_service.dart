import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static String baseUrl = "https://pilose-nonperceptively-damion.ngrok-free.dev";
  //static String baseUrl = "http://172.20.10.5:8000";  // When use on Phone
  //static String baseUrl = "http://127.0.0.1:8000";  // When use on Browser / localhost

  static Future login(String phone, String password) async {

    //var url = Uri.parse("$baseUrl/login");
    var url = Uri.parse("$baseUrl/login");

    var response = await http.post(url, body: {
      "phone": phone,
      "password": password
    });

    return jsonDecode(response.body);
  }

  // static Future predictCrop(String city, String soilPh, String rainfall) async {

  //   var url = Uri.parse("$baseUrl/smart-recommend");

  //   var response = await http.post(
  //     url,
  //     headers: {
  //       "Content-Type": "application/json",
  //       "ngrok-skip-browser-warning": "true"
  //     },
  //     body: jsonEncode({
  //       "city": city,
  //       "soil_ph": double.parse(soilPh),
  //       "rainfall": double.parse(rainfall)
  //     }),
  //   );

  //   return jsonDecode(response.body);
  // }

  static Future signup(
      String name,
      String phone,
      String village,
      String district,
      String password) async {

    var url = Uri.parse("$baseUrl/signup");

    var response = await http.post(url, body: {
      "name": name,
      "phone": phone,
      "village": village,
      "district": district,
      "password": password
    });

    return jsonDecode(response.body);
  }
}
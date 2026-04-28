import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  List history = [];

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  fetchHistory() async {

    var url = Uri.parse("${ApiService.baseUrl}/prediction-history");

    var response = await http.get(
      url,
      headers: {"ngrok-skip-browser-warning":"true"}
    );

    var data = jsonDecode(response.body);

    setState(() {
      history = data["history"];
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("History")),

      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context,index){

          var item = history[index];

          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(item["module"]),
              subtitle: Text(item["input"]),
              trailing: Text(item["result"]),
            ),
          );

        },
      ),
    );
  }
}
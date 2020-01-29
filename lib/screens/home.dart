import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NewsSource extends StatefulWidget {
  @override
  _NewsSourceState createState() => _NewsSourceState();
}

class _NewsSourceState extends State<NewsSource> {
  
  Map data;
  List userData;

  Future getSource() async {
    http.Response response = await http.get("https://newsapi.org/v2/sources?apiKey="+DotEnv().env['NEWS_API_KEY']);
    data = json.decode(response.body);
    setState(() {
      userData = data['sources'];
    });
    debugPrint(userData.toString());
  }

  @override
  void initState() {
    super.initState();
    getSource();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: userData == null ? 0 : userData.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: Row(children: <Widget>[
              Text(userData[index]['name'])
            ],),
          );
        },
      ),
    );
  }
}


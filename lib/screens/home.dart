import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_app/screens/news_list.dart';

class NewsSource extends StatefulWidget {
  @override
  _NewsSourceState createState() => _NewsSourceState();
}

class _NewsSourceState extends State<NewsSource> {
  Map data;
  List sourceData;

  Future getSource() async {
    http.Response response = await http.get(
        "https://newsapi.org/v2/sources?apiKey=" +
            DotEnv().env['NEWS_API_KEY']);
    data = json.decode(response.body);
    setState(() {
      sourceData = data['sources'];
    });
    debugPrint(sourceData.toString());
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
        itemCount: sourceData == null ? 0 : sourceData.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsList(source: sourceData[index]['id'])
                ),
              );
            },
            child: Card(
              child: Row(
                children: <Widget>[Text(sourceData[index]['name'])],
              ),
            ),
          );
        },
      ),
    );
  }
}

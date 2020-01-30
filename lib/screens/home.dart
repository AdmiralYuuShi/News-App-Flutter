import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_app/screens/news_list.dart';
import 'package:flag/flag.dart';

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
                  builder: (context) => NewsList(source: sourceData[index]['id'], name: sourceData[index]['name'])
                ),
              );
            },
            child: Card(
              child: ListTile(
                leading: Text(sourceData[index]['name'].toString()[0], style: TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),),
                title: Text(sourceData[index]['name']),
                trailing: Flags.getMiniFlag(sourceData[index]['country'].toString().toUpperCase() == 'ZH' ? 'CN' : sourceData[index]['country'].toString().toUpperCase(), null, 30),
              ),
            ),
          );
        },
      ),
    );
  }
}

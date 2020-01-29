import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsList extends StatefulWidget {
  final String source;

  NewsList({Key key, @required this.source}) : super(key: key);

  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  Map data;
  List newsData;

  Future getSource() async {
    http.Response response = await http.get(
        "https://newsapi.org/v2/everything?sources="+widget.source+"&apiKey="+DotEnv().env['NEWS_API_KEY']);
    data = json.decode(response.body);
    setState(() {
      newsData = data['articles'];
    });
    debugPrint(newsData.toString());
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
        title: Text(widget.source),
      ),
      body: ListView.builder(
        itemCount: newsData == null ? 0 : newsData.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsWeb(news: newsData[index]['url'])
                ),
              );
            },
            child: Card(
              child: Row(
                children: <Widget>[Text(newsData[index]['title'])],
              ),
            ),
          );
        },
      ),
    );
  }
}

class NewsWeb extends StatelessWidget {
  final String news;

  NewsWeb({Key key, @required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(news),
      ),
      body: 
      WebView(
        initialUrl: news,
      ),
    );
  }
}
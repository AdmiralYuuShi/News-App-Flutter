import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
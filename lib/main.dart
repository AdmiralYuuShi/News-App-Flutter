import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';

Future main() async {
  await DotEnv().load('.env');
  //...runapp
  runApp(NewsApp());
}

class NewsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'News App',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Colors.red,
    ),
    home: NewsSource(),
  );
}
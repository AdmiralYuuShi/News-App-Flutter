import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_app/screens/news_web.dart';
import 'package:intl/intl.dart';


class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({ this.milliseconds });

  run(VoidCallback action) {
    if (_timer != null) {
      _timer.cancel();
    }

    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class NewsList extends StatefulWidget {
  final String source;
  final String name;

  NewsList({Key key, @required this.source, this.name}) : super(key: key);

  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  Map data;
  List newsData;
  bool isLoading = false;
  var formater = DateFormat.yMEd().add_jms();
  final _debouncer = Debouncer(milliseconds: 500);

  TextEditingController searchController = new TextEditingController();


  Future getSource(search) async {
    setState(() {
      isLoading = true;
    });
    http.Response response = await http.get(
        "https://newsapi.org/v2/everything?sources=" +
            widget.source +
            "&q="+search+"&apiKey=" +
            DotEnv().env['NEWS_API_KEY']);
    data = json.decode(response.body);
    setState(() {
      newsData = data['articles'];
      isLoading = false;
    });
    debugPrint(newsData.toString());
  }

  @override
  void initState() {
    super.initState();
    getSource('');
  }

  void searchResults(String search) {
    print(search);
    _debouncer.run(() => getSource(search));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
        ),
        body: Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        onChanged: (value) {
                          searchResults(value);
                        },
                        controller: searchController,
                        decoration: InputDecoration(
                            labelText: "Search",
                            hintText: "Search Articles",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)))),
                      ),
                    ),
                    isLoading ? LinearProgressIndicator(backgroundColor: Colors.white, valueColor: AlwaysStoppedAnimation<Color>(Colors.red,),) :
                    newsData.length == 0 ? Text('Article not found . . .') :
                    Expanded(
                      child: ListView.builder(
                        itemCount: newsData == null ? 0 : newsData.length,
                        itemBuilder: (BuildContext context, int index) {
                          return 
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NewsWeb(
                                          news: newsData[index]['url'])),
                                );
                              },
                              child: Padding(
                                padding:
                                    EdgeInsets.fromLTRB(5.0, 3.0, 5.0, 0.0),
                                child: Card(
                                    child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 180,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              newsData[index]['urlToImage'] == null ? 'https://pasca.hamzanwadi.ac.id/asset/foto_berita/no-image.jpg' : newsData[index]['urlToImage']),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.all(6.0),
                                        child: Column(
                                          children: <Widget>[
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                formater.format(DateTime.parse(
                                                    newsData[index]
                                                        ['publishedAt'])),
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                newsData[index]['title'],
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                newsData[index]['description'],
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ))
                                  ],
                                )),
                              ));
                        },
                      ),
                    )
                  ],
                ),
              ));
  }
}

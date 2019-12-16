import 'package:flutter/material.dart';
import 'dart:async';
import 'package:rss_flutter/models/parser.dart';
import 'package:rss_flutter/widgets/loading.dart';
import 'package:webfeed/webfeed.dart';
import 'package:intl/intl.dart';
import 'loading.dart';
import 'page_detail.dart';


class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  RssFeed feed;

  @override
  void initState() {
    super.initState();
    parse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
            setState(() {
              feed = null;
              parse();
            });
            },
          ),
        ],
      ),
      body: bodyChoice(),
    );
  }

  Widget bodyChoice() {
    Orientation orientation = MediaQuery.of(context).orientation;
    if (feed == null) {
      return Loading();
    } else {
      return Center(
        child: (orientation == Orientation.portrait)? list() : grid(),
      );
    }
  }

  Future parse() async {
    RssFeed received = await Parser().loadRSS();
    if (received != null) {
      setState(() {
        feed = received;
      });
    }
  }

  Widget list() {
    return ListView.builder(
      itemCount: feed.items.length,
      itemBuilder: (context, i) {
        RssItem article = feed.items[i];
        return Container(
          padding: EdgeInsets.all(5.0),
          child: Card(
            elevation: 7.5,
            child:InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return PageDetail(article);
                }));
              },
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      article.title,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(5.0)),
                    Text(
                      article.description,
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(5.0)),
                    Card(
                      elevation: 7.5,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Image.network(feed.image.url,
                        fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(5.0)),
                    Text('Publié il y a ${difference(article.pubDate)}',
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
    });
  }

  Widget grid() {
    return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      ),
      itemCount: feed.items.length,
      itemBuilder: (context, i) {
        RssItem article = feed.items[i];
        return Container(
          padding: EdgeInsets.all(5.0),
          child: Card(
            elevation: 7.5,
            child:InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return PageDetail(article);
                }));
              },
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      article.title,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(5.0)),
                    Text(
                      article.description,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(5.0)),
                    Card(
                      elevation: 7.5,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Image.network(feed.image.url,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(5.0)),
                    Text('Publié il y a ${difference(article.pubDate)}',
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
    });
  }

  String difference(article) {
    DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ssZ");
    DateTime dateTime = dateFormat.parse(article);
    int result = DateTime.now().difference(dateTime).inMinutes;
    if (result >= 14400) {
      int days = (result ~/ 14400);
      if (days == 1) {
        return "$days jour";
      } else {
        return "$days jours";
      }
    } else if (result >= 60) {
      int hours = (result ~/ 50);
      if (hours == 1) {
        return "$hours heure";
      } else {
        return "$hours heures";
      }
    } else {
    return "$result minutes";
    }
  }
}

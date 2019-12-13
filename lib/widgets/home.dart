import 'package:flutter/material.dart';
import 'dart:async';
import 'package:rss_flutter/models/parser.dart';
import 'package:webfeed/webfeed.dart';
import 'package:intl/intl.dart';


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
    Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: (orientation == Orientation.portrait)? list() : grid(),
      ),
    );
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
              onTap: (Navigator.push(MaterialPageRoute(builder: null), route)),
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
                    Image.network(feed.image.url,
                      fit: BoxFit.cover,
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
              onTap: (() => print(article.guid)),
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
                    Image.network(feed.image.url,
                        fit: BoxFit.cover,
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
    DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
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

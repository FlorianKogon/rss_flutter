import 'package:flutter/material.dart';
import 'dart:async';
import 'package:rss_flutter/models/parser.dart';
import 'package:webfeed/webfeed.dart';

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
          height: 300.0,
          child: Card(
            child: Column(
              children: <Widget>[
                Text(
                  article.title,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  article.description,
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget grid() {
    return GridView.builder(gridDelegate: null, itemBuilder: null);
  }
}
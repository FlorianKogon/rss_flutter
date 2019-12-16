import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';
import 'textflo.dart';

class PageDetail extends StatelessWidget {

  PageDetail(this.item);

  RssItem item;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Détail de l'article"
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextFlo(item.title, fontSize: 30.0,),
            Card(
              elevation: 7.5,
              child: Container(
                width: MediaQuery.of(context).size.width / 1.5,
              ),
            ),
            TextFlo(item.description),
          ],
        ),
      ),
    );
  }
}
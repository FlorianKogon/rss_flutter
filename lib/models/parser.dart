import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart';
import 'dart:async';

class Parser {
  final url = "http://www.jeuxvideo.com/rss/rss.xml";

  Future loadRSS() async {
    final answer = await get(url);
    if (answer.statusCode == 200) {
      final feed = RssFeed.parse(answer.body);
      return feed;
    } else {
      print('error : ${answer.statusCode}');
    }
  }
}
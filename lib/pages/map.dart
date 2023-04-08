import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maps'),
      ),
      body: WebView(
        initialUrl: 'https://www.google.com/maps',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

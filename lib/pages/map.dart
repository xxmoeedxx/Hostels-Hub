import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class MapPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maps'),
        backgroundColor: const Color.fromARGB(255, 2, 24, 61),
      ),
      body: const WebView(
        initialUrl: 'https://www.google.com/maps',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}

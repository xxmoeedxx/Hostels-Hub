import 'package:authui/pages/hostel_list.dart';
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
        toolbarHeight: 80,
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        )),
        title: const Text('Maps'),
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HostelListPage()));
          },
        ),
        backgroundColor: Color.fromARGB(255, 7, 6, 68),
      ),
      body: const WebView(
        initialUrl: 'https://www.google.com/maps/search/Hostels',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
// import 'dart:io';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:url_launcher/url_launcher.dart';

// class MapPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Isolate Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: InAppWebViewExampleScreen(),
//     );
//   }
// }

// class InAppWebViewExampleScreen extends StatefulWidget {
//   @override
//   _InAppWebViewExampleScreenState createState() =>
//       new _InAppWebViewExampleScreenState();
// }

// class _InAppWebViewExampleScreenState extends State<InAppWebViewExampleScreen> {
//   InAppWebViewController webView;
//   ContextMenu contextMenu;
//   String url = "";
//   double progress = 0;
//   CookieManager _cookieManager = CookieManager.instance();

//   void requestPermission() async {
//     Map<Permission, PermissionStatus> statuses =
//         await [Permission.location].request();
//   }

//   @override
//   void initState() {
//     super.initState();

//     requestPermission();

//     contextMenu = ContextMenu(
//         menuItems: [
//           ContextMenuItem(
//               androidId: 1,
//               iosId: "1",
//               title: "Special",
//               action: () async {
//                 print("Menu item Special clicked!");
//                 print(await webView.getSelectedText());
//                 await webView.clearFocus();
//               })
//         ],
//         options: ContextMenuOptions(hideDefaultSystemContextMenuItems: true),
//         onCreateContextMenu: (hitTestResult) async {
//           print("onCreateContextMenu");
//           print(hitTestResult.extra);
//           print(await webView.getSelectedText());
//         },
//         onHideContextMenu: () {
//           print("onHideContextMenu");
//         },
//         onContextMenuActionItemClicked: (contextMenuItemClicked) async {
//           var id = (Platform.isAndroid)
//               ? contextMenuItemClicked.androidId
//               : contextMenuItemClicked.iosId;
//           print("onContextMenuActionItemClicked: " +
//               id.toString() +
//               " " +
//               contextMenuItemClicked.title);
//         });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title: Text("InAppWebView")),
//         //drawer: myDrawer(context: context),
//         body: SafeArea(
//             child: Column(children: <Widget>[
//           Container(
//             padding: EdgeInsets.all(20.0),
//             child: Text(
//                 "CURRENT URL\n${(url.length > 50) ? url.substring(0, 50) + "..." : url}"),
//           ),
//           Container(
//               padding: EdgeInsets.all(10.0),
//               child: progress < 1.0
//                   ? LinearProgressIndicator(value: progress)
//                   : Container()),
//           Expanded(
//             child: Container(
//               margin: const EdgeInsets.all(10.0),
//               decoration:
//                   BoxDecoration(border: Border.all(color: Colors.blueAccent)),
//               child: InAppWebView(
//                 // contextMenu: contextMenu,
//                 initialUrl: "https://www.google.co.in/maps/",
//                 // initialFile: "assets/index.html",
//                 initialHeaders: {},
//                 initialOptions: InAppWebViewGroupOptions(
//                     crossPlatform: InAppWebViewOptions(
//                       debuggingEnabled: true,
//                       useShouldOverrideUrlLoading: true,
//                     ),
//                     android: AndroidInAppWebViewOptions(
//                         //useHybridComposition: true
//                         )),
//                 androidOnGeolocationPermissionsShowPrompt:
//                     (InAppWebViewController controller, String origin) async {
//                   bool result = await showDialog<bool>(
//                     context: context,
//                     barrierDismissible: false, // user must tap button!
//                     builder: (BuildContext context) {
//                       return AlertDialog(
//                         title: Text('Allow access location $origin'),
//                         content: SingleChildScrollView(
//                           child: ListBody(
//                             children: <Widget>[
//                               Text('Allow access location $origin'),
//                             ],
//                           ),
//                         ),
//                         actions: <Widget>[
//                           TextButton(
//                             child: Text('Allow'),
//                             onPressed: () {
//                               Navigator.of(context).pop(true);
//                             },
//                           ),
//                           TextButton(
//                             child: Text('Denied'),
//                             onPressed: () {
//                               Navigator.of(context).pop(false);
//                             },
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                   if (result) {
//                     return Future.value(GeolocationPermissionShowPromptResponse(
//                         origin: origin, allow: true, retain: true));
//                   } else {
//                     return Future.value(GeolocationPermissionShowPromptResponse(
//                         origin: origin, allow: false, retain: false));
//                   }
//                 },
//                 onWebViewCreated: (InAppWebViewController controller) {
//                   webView = controller;
//                   print("onWebViewCreated");
//                 },
//                 onLoadStart: (InAppWebViewController controller, String url) {
//                   print("onLoadStart $url");
//                   setState(() {
//                     this.url = url;
//                   });
//                 },
//                 shouldOverrideUrlLoading:
//                     (controller, shouldOverrideUrlLoadingRequest) async {
//                   var url = shouldOverrideUrlLoadingRequest.url;
//                   var uri = Uri.parse(url);

//                   if (![
//                     "http",
//                     "https",
//                     "file",
//                     "chrome",
//                     "data",
//                     "javascript",
//                     "about"
//                   ].contains(uri.scheme)) {
//                     if (await canLaunch(url)) {
//                       // Launch the App
//                       await launch(
//                         url,
//                       );
//                       // and cancel the request
//                       return ShouldOverrideUrlLoadingAction.CANCEL;
//                     }
//                   }

//                   return ShouldOverrideUrlLoadingAction.ALLOW;
//                 },
//                 onLoadStop:
//                     (InAppWebViewController controller, String url) async {
//                   print("onLoadStop $url");
//                   setState(() {
//                     this.url = url;
//                   });
//                 },
//                 onProgressChanged:
//                     (InAppWebViewController controller, int progress) {
//                   setState(() {
//                     this.progress = progress / 100;
//                   });
//                 },
//                 onUpdateVisitedHistory: (InAppWebViewController controller,
//                     String url, bool androidIsReload) {
//                   print("onUpdateVisitedHistory $url");
//                   setState(() {
//                     this.url = url;
//                   });
//                 },
//                 onConsoleMessage: (controller, consoleMessage) {
//                   print(consoleMessage);
//                 },
//               ),
//             ),
//           ),
//           ButtonBar(
//             alignment: MainAxisAlignment.center,
//             children: <Widget>[
//               RaisedButton(
//                 child: Icon(Icons.arrow_back),
//                 onPressed: () {
//                   if (webView != null) {
//                     webView.goBack();
//                   }
//                 },
//               ),
//               RaisedButton(
//                 child: Icon(Icons.arrow_forward),
//                 onPressed: () {
//                   if (webView != null) {
//                     webView.goForward();
//                   }
//                 },
//               ),
//               RaisedButton(
//                 child: Icon(Icons.refresh),
//                 onPressed: () {
//                   if (webView != null) {
//                     webView.reload();
//                   }
//                 },
//               ),
//             ],
//           ),
//         ])));
//   }
// }

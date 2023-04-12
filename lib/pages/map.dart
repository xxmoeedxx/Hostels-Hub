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
        initialUrl: 'https://www.google.com/maps/search/Hostels',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';

// // ignore: use_key_in_widget_constructors
// class MapPage extends StatefulWidget {
//   @override
//   // ignore: library_private_types_in_public_api
//   _MapPageState createState() => _MapPageState();
// }

// class _MapPageState extends State<MapPage> {
//   late String _initialUrl;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation().then((initialUrl) {
//       setState(() {
//         _initialUrl = initialUrl;
//       });
//     }).catchError((error) {
//       setState(() {
//         _initialUrl = 'https://www.google.com/maps/search/Hostels';
//       });
//       _showLocationErrorDialog();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_initialUrl == null) {
//       // Return a loading indicator while _initialUrl is null.
//       return Center(child: CircularProgressIndicator());
//     } else {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Maps'),
//           backgroundColor: const Color.fromARGB(255, 2, 24, 61),
//         ),
//         body: WebView(
//           initialUrl: _initialUrl,
//           javascriptMode: JavascriptMode.unrestricted,
//         ),
//       );
//     }
//   }

//   Future<String> _getCurrentLocation() async {
//     bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!isLocationServiceEnabled) {
//       throw Exception('Location service is disabled');
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.deniedForever) {
//       throw Exception(
//           'Location permission is permanently denied, we cannot request permissions.');
//     }

//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission != LocationPermission.whileInUse &&
//           permission != LocationPermission.always) {
//         throw Exception('Location permission is denied');
//       }
//     }

//     final position = await Geolocator.getCurrentPosition();
//     final lat = position.latitude;
//     final lon = position.longitude;
//     return 'https://www.google.com/maps/search/Hostels/@$lat,$lon,15z';
//   }

//   void _showLocationErrorDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Location Error'),
//           content: Text(
//               'Unable to get your current location. Please enable location services and try again.'),
//           actions: <Widget>[
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//}

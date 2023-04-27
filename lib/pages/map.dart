import 'package:db_project/pages/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? mapController;
  CameraPosition? initialCameraPosition;
  late BitmapDescriptor pinLocationIcon;
  Position? currentPosition;
  bool _isMapReady = false;

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  // Get user's current location
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Check location permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    } else if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    // Get user's current location
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation().then((position) {
      setState(() {
        currentPosition = position;
        _isMapReady = true;
      });
    });
    // Set the icon for the user's current location
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(devicePixelRatio: 2.5),
            'assets/images/location_icon.png')
        .then((icon) {
      setState(() {
        pinLocationIcon = icon;
      });
    });

    // Load the initial camera position
    initialCameraPosition = const CameraPosition(
      target: LatLng(37.7749, -122.4194),
      zoom: 14.0,
    );
  }

  // Update the current position when the user's location changes
  void updateCurrentPosition(Position position) {
    setState(() {
      currentPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: const Color.fromARGB(255, 7, 6, 68),
        shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        )),
        title: const Text('Map Page'),
      ),
      body: Visibility(
        visible: _isMapReady,
        child: GoogleMap(
          initialCameraPosition: initialCameraPosition!,
          mapType: MapType.normal,
          zoomControlsEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          circles: <Circle>{
            const Circle(
              circleId: CircleId('current_location'),
              center: LatLng(37.7749, -122.4194),
              radius: 10,
              fillColor: Color.fromARGB(255, 7, 6, 68),
              strokeColor: Color.fromARGB(255, 7, 6, 68),
              strokeWidth: 1,
            )
          },
        ),
      ),
      bottomNavigationBar: const AnimatedBottomBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 7, 6, 68),
        onPressed: () async {
          // Get user's current location
          final Position position = await getCurrentLocation();

          // Update the current position
          updateCurrentPosition(position);

          // Animate camera to user's current location
          mapController!.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 14.0,
            ),
          ));
        },
        child: const Icon(
          Icons.my_location,
        ),
      ),
    );
  }
}

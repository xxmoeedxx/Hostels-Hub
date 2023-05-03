import 'package:db_project/components/my_button.dart';
import 'package:db_project/pages/Questions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:db_project/services/database_service.dart';
import 'package:db_project/pages/bottom_bar.dart';
import 'package:provider/provider.dart';
import '../components/ImageCarousels.dart';
import '../services/user_provider.dart';
//import 'package:hostel_app/hostel.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'hostellites.dart';

class MyHostelsPage extends StatefulWidget {
  @override
  _MyHostelsPageState createState() => _MyHostelsPageState();
}

class _MyHostelsPageState extends State<MyHostelsPage> {
  Hostel? _selectedHostel;
  late Stream<List<Hostel>> _hostelStream;
  late List<Hostel> _hostels;
  late bool _isLoading;
  String _selectedCity = "Lahore";
  final List<String> _cities = ['Lahore', 'Islamabad'];
  String _selectedGender = "Male";
  final List<String> _genders = ['Male', 'Female'];
  final List<String> images = [];
  late bool _showAllEnabled = true;
  // Filter options
  late bool _isAirConditionedFilterEnabled;
  late bool _isFoodMessAvailableFilterEnabled;
  late bool _isWifiAvailableFilterEnabled;
  late int _roomRentFilter;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _db = DatabaseService();
  late Function()? onTap;
  Future<void> getUserData() async {
    User? user = _auth.currentUser;
    UserProvider userProvider =
        // ignore: use_build_context_synchronously
        Provider.of<UserProvider>(context, listen: false);
    Future<Users?> userFuture = _db.getUserInfo(user!.uid);
    Users? _user = await userFuture;
    userProvider.setCurrentUser(_user!);
  }

  List<Hostel> _getMyHostels() {
    return _hostels.where((hostel) {
      return _auth.currentUser?.email == hostel.ownerEmail;
    }).toList();
  }

  Future<void> _showHostelDetails(Hostel hostel) async {
    setState(() {
      _selectedHostel = hostel;
      onTap = () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HostelBookingListPage(
              hostelId: hostel.hostelId,
            ),
          ),
        );
      };
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).padding.top + 15.0),
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            body: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: MediaQuery.of(context).size.width,
              height: _selectedHostel != null
                  ? MediaQuery.of(context).size.height
                  : 0.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ImageCarousel(images: hostel.images),
                      Text(
                        hostel.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailsSection(
                        title: 'Description:',
                        content: hostel.description,
                      ),
                      const SizedBox(height: 16),
                      _buildDetailsSection(
                        title: 'Address:',
                        content: '${hostel.address}, ${hostel.location}',
                      ),
                      const SizedBox(height: 16),
                      _buildDetailsSection(
                        title: 'Gender:',
                        content: hostel.gender,
                      ),
                      const SizedBox(height: 16),
                      _buildDetailsSection(
                        title: 'Room Rent:',
                        content: 'Rs. ${hostel.roomRent}/month',
                      ),
                      const SizedBox(height: 16),
                      _buildDetailsSection(
                        title: 'Available Rooms:',
                        content:
                            '${hostel.availableRooms}/${hostel.totalRooms}',
                      ),
                      const SizedBox(height: 16),
                      _buildDetailsSection(
                        title: 'Wifi Available:',
                        content: '${hostel.isWifiAvailable}',
                      ),
                      const SizedBox(height: 16),
                      _buildDetailsSection(
                        title: 'Air Conditioned:',
                        content: '${hostel.isAirConditioned}',
                      ),
                      const SizedBox(height: 16),
                      _buildDetailsSection(
                        title: 'Food Mess Available:',
                        content: '${hostel.isFoodMessAvailable}',
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: onTap,
                        child: AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 7, 6, 68),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text(
                                "View Bookings",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      )
                      // MyButton(onTap: () {
                      //   Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => HostelBookingListPage(
                      //         hostelId: hostel.hostelId,
                      //       ),
                      //     ),
                      //   );
                      // }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailsSection({
    required String title,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    // Initialize filter options
    _isAirConditionedFilterEnabled = false;
    _isFoodMessAvailableFilterEnabled = false;
    _isWifiAvailableFilterEnabled = false;
    _roomRentFilter = 0;
    getUserData();
    // Fetch all hostels from database
    _isLoading = true;
    _hostelStream = DatabaseService().getHostels();
    _hostelStream.listen((hostels) {
      setState(() {
        _hostels = hostels;
        _isLoading = false;
      });
    });
  }

  // Filter hostels based on selected options
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
        title: const Text(
          'My Hostels',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Stack(
        children: [
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      const Padding(
                        padding: EdgeInsets.all(6.0),
                      ),
                      // Hostel list
                      Expanded(
                        child: ListView.builder(
                          itemCount: _getMyHostels().length,
                          itemBuilder: (context, index) {
                            Hostel hostel = _getMyHostels()[index];
                            return InkWell(
                              onTap: () {
                                _showHostelDetails(hostel);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 5.0),
                                child: ListTile(
                                  title: Text(
                                    hostel.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  subtitle: Text(
                                    hostel.location,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  trailing: PopupMenuButton(
                                    itemBuilder: (BuildContext context) => [
                                      const PopupMenuItem(
                                        child: Text('Edit Hostel Details'),
                                        value: 'edit',
                                      ),
                                      const PopupMenuItem(
                                        child: Text('Delete Hostel'),
                                        value: 'delete',
                                      ),
                                    ],
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                HostelDetailsForm(
                                              hostelName: hostel.name,
                                              roomRent: hostel.roomRent,
                                              totalRooms: hostel.totalRooms,
                                              availableRooms:
                                                  hostel.availableRooms,
                                              address: hostel.address,
                                              description: hostel.description,
                                              selectedLocation: hostel.location,
                                              selectedGender: hostel.gender,
                                              isAirConditioned:
                                                  hostel.isAirConditioned,
                                              isFoodMessAvailable:
                                                  hostel.isFoodMessAvailable,
                                              isWifiAvailable:
                                                  hostel.isWifiAvailable,
                                              images: hostel.images,
                                              hostelId: hostel.hostelId,
                                              initial: 1,
                                            ),
                                          ),
                                        );
                                      } else if (value == 'delete') {
                                        _db.deleteHostel(hostel.hostelId);
                                        _hostelStream =
                                            DatabaseService().getHostels();
                                        _hostelStream.listen((hostels) {
                                          setState(() {
                                            _hostels = hostels;
                                            _isLoading = false;
                                          });
                                        });
                                      }
                                    },
                                    icon: const Icon(Icons.more_vert),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Filter options
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                      ),
                    ],
                  ),
                )
        ],
      ),
      bottomNavigationBar: const AnimatedBottomBar(),
    );
  }
}

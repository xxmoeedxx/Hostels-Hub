import 'package:authui/pages/Questions.dart';
import 'package:flutter/material.dart';
import 'package:authui/services/database_service.dart';
import 'package:authui/pages/map.dart';
import 'package:authui/pages/bottom_bar.dart';
import 'package:authui/pages/sidebar.dart';
//import 'package:hostel_app/hostel.dart';

class HostelListPage extends StatefulWidget {
  @override
  _HostelListPageState createState() => _HostelListPageState();
}

class _HostelListPageState extends State<HostelListPage> {
  Hostel? _selectedHostel;
  late Stream<List<Hostel>> _hostelStream;
  late List<Hostel> _hostels;
  late bool _isLoading;
  String _selectedCity = "Lahore";
  final List<String> _cities = ['Lahore', 'Islamabad'];
  late bool _showAllEnabled = true;
  // Filter options
  late bool _isAirConditionedFilterEnabled;
  late bool _isFoodMessAvailableFilterEnabled;
  late int _roomRentFilter;
  void _showHostelDetails(Hostel hostel) {
    setState(() {
      _selectedHostel = hostel;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(hostel.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Address:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '${hostel.address}, ${hostel.location}',
                style: TextStyle(
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Room Rent:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Rs. ${hostel.roomRent}/month',
                style: TextStyle(
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Available Rooms:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '${hostel.availableRooms}',
                style: TextStyle(
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Air Conditioned:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '${hostel.isAirConditioned}',
                style: TextStyle(
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Food Mess Available:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '${hostel.isFoodMessAvailable}',
                style: TextStyle(
                  color: Colors.grey[700],
                ),
              ),
              // Add more attributes as needed
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedHostel = null;
                });
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _onSidebarItemTapped(int index) {
    // Handle sidebar item tap here
    print('Tapped item $index');
  }

  @override
  void initState() {
    super.initState();

    // Initialize filter options
    _isAirConditionedFilterEnabled = false;
    _isFoodMessAvailableFilterEnabled = false;
    _roomRentFilter = 0;

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
  List<Hostel> _getFilteredHostels() {
    return _hostels.where((hostel) {
      bool isAirConditionedFilterMatch =
          !_isAirConditionedFilterEnabled || hostel.isAirConditioned;
      bool isFoodMessAvailableFilterMatch =
          !_isFoodMessAvailableFilterEnabled || hostel.isFoodMessAvailable;
      bool roomRentFilterMatch =
          _roomRentFilter == 0 || hostel.roomRent <= _roomRentFilter;
      bool isSelectedCity = (_selectedCity == hostel.location);
      return isAirConditionedFilterMatch &&
              isFoodMessAvailableFilterMatch &&
              roomRentFilterMatch &&
              isSelectedCity ||
          _showAllEnabled;
    }).toList();
  }

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
        title: const Text(
          'Hostels',
          style: TextStyle(fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MapPage()));
          },
        ),
        actions: <Widget>[
          Expanded(
              flex: -2,
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => (HostelDetailsForm())));
                },
                alignment: Alignment.centerRight,
              )),
          Expanded(
            flex: -2,
            child: IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Filters'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DropdownButtonFormField<String>(
                              // your city filter widget code here
                              decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(16, 8, 16, 8),
                                labelText: 'City',
                                border: OutlineInputBorder(),
                              ),
                              value: _selectedCity,
                              onChanged: (value) {
                                setState(() {
                                  _selectedCity = value!;
                                });
                              },
                              items: _cities
                                  .map((e) => DropdownMenuItem<String>(
                                        value: e,
                                        child: Text(e),
                                      ))
                                  .toList(),
                            ),
                            CheckboxListTile(
                              title: Text('Air conditioned'),
                              value: _isAirConditionedFilterEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _isAirConditionedFilterEnabled =
                                      value ?? false;
                                });
                              },
                            ),
                            CheckboxListTile(
                              title: Text('Food mess available'),
                              value: _isFoodMessAvailableFilterEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _isFoodMessAvailableFilterEnabled =
                                      value ?? false;
                                });
                              },
                            ),
                            CheckboxListTile(
                              title: Text('Show All'),
                              value: _showAllEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _showAllEnabled = value ?? false;
                                });
                              },
                            ),
                            SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 2.0,
                                activeTrackColor: Color.fromARGB(255, 7, 6, 68),
                                inactiveTrackColor: Colors.black,
                                thumbColor: Color.fromARGB(255, 7, 6, 68),
                                overlayColor: Color.fromARGB(255, 7, 6, 68)
                                    .withOpacity(0.2),
                                overlayShape: RoundSliderOverlayShape(
                                    overlayRadius: 12.0),
                                thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 16.0),
                              ),
                              child: Slider(
                                value: _roomRentFilter.toDouble(),
                                min: 0,
                                max: 50000,
                                divisions: 100,
                                label: 'Max room rent: $_roomRentFilter',
                                onChanged: (value) {
                                  setState(() {
                                    _roomRentFilter = value.toInt();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Close'),
                          ),
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.filter_list),
              //alignment: Alignment.centerRight,
            ),
          ),
        ],
        backgroundColor: Color.fromARGB(255, 7, 6, 68),
      ),
      body: Stack(children: [
        _isLoading
            ? Center(
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
                    // Hostel list
                    Expanded(
                      child: ListView.builder(
                        itemCount: _getFilteredHostels().length,
                        itemBuilder: (context, index) {
                          Hostel hostel = _getFilteredHostels()[index];
                          return ListTile(
                            title: Text(hostel.name,
                                style: TextStyle(color: Colors.black)),
                            subtitle: Text(hostel.location),
                            trailing: Text('Rs. ${hostel.roomRent}/month'),
                            onTap: () => _showHostelDetails(hostel),
                          );
                        },
                      ),
                    ),
                    // Filter options
                  ],
                ),
              )
      ]),
      // floatingActionButton: AnimatedSidebar(
      //   icons: [
      //     Icons.home,
      //     Icons.search,
      //     Icons.favorite,
      //     Icons.settings,
      //   ],
      //   labels: [
      //     'Home',
      //     'Search',
      //     'Favorites',
      //     'Settings',
      //   ],
      //   onTap: _onSidebarItemTapped,
      // ),
      bottomNavigationBar: const AnimatedBottomBar(
        icons: [
          Icons.home,
          Icons.search,
          Icons.notifications,
          Icons.person,
        ],
        labels: [
          'Home',
          'Search',
          'Notifications',
          'Profile',
        ],
      ),
    );
  }
}

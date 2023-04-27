import 'package:db_project/pages/Questions.dart';
import 'package:flutter/material.dart';
import 'package:db_project/services/database_service.dart';
import 'package:db_project/pages/map.dart';
import 'package:db_project/pages/bottom_bar.dart';
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

    final double dialogHeight = 400.0;
    final double screenHeight = MediaQuery.of(context).size.height - 40;

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
              height: _selectedHostel != null
                  ? MediaQuery.of(context).size.height
                  : 0.0,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('assets/images/pic3.png'),
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
                        title: 'Air Conditioned:',
                        content: '${hostel.isAirConditioned}',
                      ),
                      const SizedBox(height: 16),
                      _buildDetailsSection(
                        title: 'Food Mess Available:',
                        content: '${hostel.isFoodMessAvailable}',
                      ),
                      const SizedBox(height: 16),
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
        backgroundColor: const Color.fromARGB(255, 7, 6, 68),
        shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        )),
        title: const Text(
          'Hostels',
          style: TextStyle(fontSize: 20),
        ),
        actions: <Widget>[
          Expanded(
              flex: -2,
              child: IconButton(
                icon: const Icon(Icons.add),
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
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter setStateD) {
                        return AlertDialog(
                          title: const Text('Filters'),
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
                                title: const Text('Air conditioned'),
                                value: _isAirConditionedFilterEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    setStateD(() {});
                                    _isAirConditionedFilterEnabled =
                                        value ?? false;
                                  });
                                },
                              ),
                              CheckboxListTile(
                                title: const Text('Food mess available'),
                                value: _isFoodMessAvailableFilterEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    setStateD(() {});
                                    _isFoodMessAvailableFilterEnabled =
                                        value ?? false;
                                  });
                                },
                              ),
                              CheckboxListTile(
                                title: const Text('Show All'),
                                value: _showAllEnabled,
                                onChanged: (value) {
                                  setState(() {
                                    setStateD(() {});
                                    _showAllEnabled = value ?? false;
                                  });
                                },
                              ),
                              SliderTheme(
                                data: SliderThemeData(
                                  trackHeight: 2.0,
                                  activeTrackColor:
                                      const Color.fromARGB(255, 7, 6, 68),
                                  inactiveTrackColor: Colors.black,
                                  thumbColor:
                                      const Color.fromARGB(255, 7, 6, 68),
                                  overlayColor:
                                      const Color.fromARGB(255, 7, 6, 68)
                                          .withOpacity(0.2),
                                  overlayShape: const RoundSliderOverlayShape(
                                      overlayRadius: 12.0),
                                  thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 16.0),
                                ),
                                child: Slider(
                                  value: _roomRentFilter.toDouble(),
                                  min: 0,
                                  max: 25,
                                  divisions: 100,
                                  label: 'Max room rent: $_roomRentFilter',
                                  onChanged: (value) {
                                    setState(() {
                                      setStateD(() {});
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
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      });
                    });
              },
              icon: const Icon(Icons.filter_list),
              //alignment: Alignment.centerRight,
            ),
          ),
        ],
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
                          itemCount: _getFilteredHostels().length,
                          itemBuilder: (context, index) {
                            Hostel hostel = _getFilteredHostels()[index];
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
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text(
                                        "From",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                      Text(
                                        "Rs. ${hostel.roomRent}/month",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
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
      bottomNavigationBar: const AnimatedBottomBar(),
    );
  }
}

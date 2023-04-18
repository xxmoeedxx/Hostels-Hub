// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:authui/pages/hostel_list.dart';

class HostelDetailsForm extends StatefulWidget {
  @override
  _HostelDetailsFormState createState() => _HostelDetailsFormState();
}

class _HostelDetailsFormState extends State<HostelDetailsForm> {
  final _formKey = GlobalKey<FormState>();

  final CollectionReference hostelCollection =
      FirebaseFirestore.instance.collection('hostels');
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        await hostelCollection.add({
          'name': _hostelNameController.text,
          'location': _selectedLocation,
          'address': _addressController.text,
          'isAirConditioned': _isAirConditioned,
          'roomRent': int.parse(_roomRentController.text),
          'totalRooms': int.parse(_totalRoomsController.text),
          'availableRooms': int.parse(_availableRoomsController.text),
          'isFoodMessAvailable': _isFoodMessAvailable,
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Hostel details submitted'),
        ));
        _formKey.currentState!.reset();
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error submitting hostel details'),
        ));
      }
    }
  }

  // Text Editing Controllers
  final TextEditingController _hostelNameController = TextEditingController();
  final TextEditingController _roomRentController = TextEditingController();
  final TextEditingController _totalRoomsController = TextEditingController();
  final TextEditingController _availableRoomsController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // DropdownButton variables
  final List<String> _locations = ['Lahore', 'Islamabad']; // Option 2
  String _selectedLocation = 'Lahore'; // Option 2

  // Switch variable
  bool _isAirConditioned = false;
  bool _isFoodMessAvailable = false;

  @override
  void dispose() {
    _hostelNameController.dispose();
    _roomRentController.dispose();
    _totalRoomsController.dispose();
    _availableRoomsController.dispose();
    _addressController.dispose();
    super.dispose();
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
        title: const Text('Hostel Details'),
        backgroundColor: Color.fromARGB(255, 7, 6, 68),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Basic Information',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _hostelNameController,
                  decoration: const InputDecoration(
                    labelText: 'Hostel Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter hostel name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Location',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                const SizedBox(height: 12.0),
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    labelText: 'Select Location',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedLocation,
                  onChanged: (value) {
                    setState(() {
                      _selectedLocation = value.toString();
                    });
                  },
                  items: _locations.map((location) {
                    return DropdownMenuItem(
                      value: location,
                      child: Text(location),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter hostel address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Additional Information',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Air Conditioned Rooms'),
                    Switch(
                      value: _isAirConditioned,
                      onChanged: (value) {
                        setState(() {
                          _isAirConditioned = value;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Food Mess Available'),
                    Switch(
                      value: _isFoodMessAvailable,
                      onChanged: (value) {
                        setState(() {
                          _isFoodMessAvailable = value;
                        });
                      },
                    ),
                  ],
                ),
                TextFormField(
                  controller: _roomRentController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Room Rent (per month)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter room rent';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _totalRoomsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Total Number of Rooms',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter total number of rooms';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _availableRoomsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Number of Available Rooms',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter number of available rooms';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 2, 24, 61)),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // do something
                      _submit();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HostelListPage()));
                    }
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                        backgroundColor: Color.fromARGB(255, 7, 6, 68),
                        fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

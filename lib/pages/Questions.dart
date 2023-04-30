// ignore: file_names
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:db_project/pages/hostel_list.dart';
import 'package:image_picker/image_picker.dart';

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
          'description': _descriptionController.text,
          'isAirConditioned': _isAirConditioned,
          'roomRent': int.parse(_roomRentController.text),
          'totalRooms': int.parse(_totalRoomsController.text),
          'availableRooms': int.parse(_availableRoomsController.text),
          'isFoodMessAvailable': _isFoodMessAvailable,
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Hostel details submitted'),
        ));
        _formKey.currentState!.reset();
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
  final TextEditingController _descriptionController = TextEditingController();

  // DropdownButton variables
  final List<String> _locations = ['Lahore', 'Islamabad']; // Option 2
  String _selectedLocation = 'Lahore'; // Option 2

  // Switch variable
  bool _isAirConditioned = false;
  bool _isFoodMessAvailable = false;
  List<File> _images = [];

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  void dispose() {
    _hostelNameController.dispose();
    _roomRentController.dispose();
    _totalRoomsController.dispose();
    _availableRoomsController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        )),
        title: const Text('Hostel Details'),
        backgroundColor: const Color.fromARGB(255, 7, 6, 68),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Insert Image'),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: _images.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Stack(
                        children: [
                          Image.file(_images[index], fit: BoxFit.cover),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.clear, color: Colors.red),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
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
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter hostel description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Location',
                  style: Theme.of(context).textTheme.titleMedium,
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
                    const Text('Air Conditioned Rooms'),
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
                    const Text('Food Mess Available'),
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

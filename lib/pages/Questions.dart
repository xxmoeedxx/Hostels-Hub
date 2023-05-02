// ignore: file_names
import 'dart:io';
import 'dart:typed_data';
import 'package:db_project/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:db_project/pages/hostel_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final User? user = _auth.currentUser;
final String? userEmail = user?.email;
final String ownerEmail = userEmail!;
// Text Editing Controllers
// DropdownButton variables
final List<String> _locations = ['Lahore', 'Islamabad'];
final List<String> _genders = ['Male', 'Female']; // Option 2
int _initial = 0;

Future<List<File>> loadImages(List<String> imageUrls) async {
  List<File> imageFiles = [];

  for (int i = 0; i < imageUrls.length; i++) {
    String imageUrl = imageUrls[i];
    var response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      Uint8List bytes = response.bodyBytes;
      String fileName = imageUrl.split('/').last;
      String tempPath = (await getTemporaryDirectory()).path;
      File file = File('$tempPath/$fileName');
      await file.writeAsBytes(bytes);

      imageFiles.add(file);
    }
  }

  return imageFiles;
}

void deleteImages(List<File> images) {
  for (File file in images) {
    file.delete();
  }
}

class HostelDetailsForm extends StatefulWidget {
  final String hostelName;
  final int roomRent;
  final int totalRooms;
  final int availableRooms;
  final String address;
  final String description;
  final String selectedLocation;
  final String selectedGender;
  final String hostelId;
  final bool isAirConditioned;
  final bool isFoodMessAvailable;
  final bool isWifiAvailable;
  final List<String> images;
  final int initial;
  HostelDetailsForm({
    this.hostelName = '',
    this.hostelId = '',
    this.roomRent = 0,
    this.totalRooms = 0,
    this.availableRooms = 0,
    this.address = '',
    this.description = '',
    this.selectedLocation = 'Lahore',
    this.selectedGender = 'Male',
    this.isAirConditioned = false,
    this.isFoodMessAvailable = false,
    this.isWifiAvailable = false,
    this.images = const [],
    this.initial = 0,
  });

  @override
  _HostelDetailsFormState createState() => _HostelDetailsFormState();
}

class _HostelDetailsFormState extends State<HostelDetailsForm> {
  final TextEditingController _hostelNameController = TextEditingController();
  final TextEditingController _roomRentController = TextEditingController();
  final TextEditingController _totalRoomsController = TextEditingController();
  final TextEditingController _availableRoomsController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedLocation = 'Lahore';
  String _selectedGender = 'Male';
  bool _isAirConditioned = false;
  bool _isFoodMessAvailable = false;
  bool _isWifiAvailable = false;
  List<File> _images = [];

  Future<List<File>> returnImg() async {
    List<File> img = await loadImages(widget.images);
    return img;
  }

  Future<void> _init() async {
    List<File> images = await loadImages(widget.images);
    setState(() {
      _images = images;
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
    _hostelNameController.text = widget.hostelName;
    _roomRentController.text = widget.roomRent.toString();
    _totalRoomsController.text = widget.totalRooms.toString();
    _availableRoomsController.text = widget.availableRooms.toString();
    _addressController.text = widget.address;
    _descriptionController.text = widget.description;
    _selectedLocation = widget.selectedLocation;
    _selectedGender = widget.selectedGender;
    _isAirConditioned = widget.isAirConditioned;
    _isWifiAvailable = widget.isWifiAvailable;
    _isFoodMessAvailable = widget.isFoodMessAvailable;
    _initial = widget.initial;
  }

  final _formKey = GlobalKey<FormState>();
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final CollectionReference hostelCollection =
      FirebaseFirestore.instance.collection('hostels');
  final DatabaseService _db = DatabaseService();
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (_initial == 0) {
          _db.createHostel(
              name: _hostelNameController.text,
              description: _descriptionController.text,
              location: _selectedLocation,
              address: _addressController.text,
              roomRent: int.parse(_roomRentController.text),
              totalRooms: int.parse(_totalRoomsController.text),
              availableRooms: int.parse(_availableRoomsController.text),
              isAirConditioned: _isAirConditioned,
              isFoodMessAvailable: _isFoodMessAvailable,
              isWifiAvailable: _isWifiAvailable,
              gender: _selectedGender,
              images: await getImageUrls(_images),
              ownerEmail: userEmail!);
        } else {
          _db.updateHostel(
              hostelId: widget.hostelId,
              name: _hostelNameController.text,
              description: _descriptionController.text,
              location: _selectedLocation,
              address: _addressController.text,
              roomRent: int.parse(_roomRentController.text),
              totalRooms: int.parse(_totalRoomsController.text),
              availableRooms: int.parse(_availableRoomsController.text),
              isAirConditioned: _isAirConditioned,
              isFoodMessAvailable: _isFoodMessAvailable,
              isWifiAvailable: _isWifiAvailable,
              gender: _selectedGender,
              images: await getImageUrls(_images),
              ownerEmail: userEmail!);
        }
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

  Future<String> uploadImageToFirebase(File imageFile) async {
    String fileName = Path.basename(imageFile.path);
    firebase_storage.Reference firebaseStorageRef =
        firebase_storage.FirebaseStorage.instance.ref().child(fileName);
    firebase_storage.UploadTask uploadTask =
        firebaseStorageRef.putFile(imageFile);
    firebase_storage.TaskSnapshot taskSnapshot =
        await uploadTask.whenComplete(() => null);
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<List<String>> getImageUrls(List<File> imageFiles) async {
    List<String> imageUrls = [];
    for (File imageFile in imageFiles) {
      String imageUrl = await uploadImageToFirebase(imageFile);
      imageUrls.add(imageUrl);
    }
    return imageUrls;
  }

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
    if (_initial != 0) {
      deleteImages(_images);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<File>>(
      future: loadImages(widget.images),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //_images = snapshot.data!;
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
                      const SizedBox(height: 20),
                      const Text(
                        'Basic Information',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
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
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Wifi Available'),
                          Switch(
                            value: _isWifiAvailable,
                            onChanged: (value) {
                              setState(() {
                                _isWifiAvailable = value;
                              });
                            },
                          ),
                        ],
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
                      const SizedBox(height: 12.0),
                      DropdownButtonFormField(
                        decoration: const InputDecoration(
                          labelText: 'Select Required Gender',
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedGender,
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value.toString();
                          });
                        },
                        items: _genders.map((gender) {
                          return DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select location';
                          }
                          return null;
                        },
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
                            backgroundColor:
                                const Color.fromARGB(255, 2, 24, 61)),
                        onPressed: _images.length < 6 ? _pickImage : null,
                        child: const Text('Insert Image'),
                      ),
                      Visibility(
                        visible: _images.length == 6,
                        child: const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            'You have reached the limit of images',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
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
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.clear,
                                          color: Colors.red),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 2, 24, 61)),
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
          // Your widget tree here
        } else if (snapshot.hasError) {
          return Text("Error loading images");
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

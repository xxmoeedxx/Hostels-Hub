import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create a new hostel document in the database
  Future<void> createHostel(
      {required String name,
      required String location,
      required String address,
      required int roomRent,
      required int totalRooms,
      required int availableRooms,
      required bool isAirConditioned,
      required bool isFoodMessAvailable}) async {
    await _db.collection('hostels').add({
      'name': name,
      'location': location,
      'address': address,
      'roomRent': roomRent,
      'totalRooms': totalRooms,
      'availableRooms': availableRooms,
      'isAirConditioned': isAirConditioned,
      'isFoodMessAvailable': isFoodMessAvailable,
    });
  }

  // Fetch all hostels from the database
  Stream<List<Hostel>> getHostels() {
    return _db.collection('hostels').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Hostel.fromFirestore(doc)).toList();
    });
  }
}

class Hostel {
  final String name;
  final String description;
  final String location;
  final String address;
  final int roomRent;
  final int totalRooms;
  final int availableRooms;
  final bool isAirConditioned;
  final bool isFoodMessAvailable;

  Hostel(
      {required this.name,
      required this.description,
      required this.location,
      required this.address,
      required this.roomRent,
      required this.totalRooms,
      required this.availableRooms,
      required this.isAirConditioned,
      required this.isFoodMessAvailable});

  factory Hostel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Hostel(
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      location: data['location'] ?? '',
      address: data['address'] ?? '',
      roomRent: data['roomRent'] ?? 0,
      totalRooms: data['totalRooms'] ?? 0,
      availableRooms: data['availableRooms'] ?? 0,
      isAirConditioned: data['isAirConditioned'] ?? false,
      isFoodMessAvailable: data['isFoodMessAvailable'] ?? false,
    );
  }
}

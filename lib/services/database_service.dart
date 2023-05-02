import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create a new hostel document in the database
  Future<void> createHostel({
    required String name,
    required String description,
    required String location,
    required String address,
    required int roomRent,
    required int totalRooms,
    required int availableRooms,
    required bool isAirConditioned,
    required bool isFoodMessAvailable,
    required bool isWifiAvailable,
    required String gender,
    required List<String> images,
    required String ownerEmail,
  }) async {
    final String hostelId = Uuid().v4();
    await _db.collection('hostels').doc(hostelId).set({
      'name': name,
      'description': description,
      'location': location,
      'address': address,
      'roomRent': roomRent,
      'totalRooms': totalRooms,
      'availableRooms': availableRooms,
      'isAirConditioned': isAirConditioned,
      'isFoodMessAvailable': isFoodMessAvailable,
      'isWifiAvailable': isWifiAvailable,
      'gender': gender,
      'images': images,
      'ownerEmail': ownerEmail,
    });
  }

  Future<void> updateHostel({
    required String hostelId,
    required String name,
    required String description,
    required String location,
    required String address,
    required int roomRent,
    required int totalRooms,
    required int availableRooms,
    required bool isAirConditioned,
    required bool isFoodMessAvailable,
    required bool isWifiAvailable,
    required String gender,
    required List<String> images,
    required String ownerEmail,
  }) async {
    await _db.collection('hostels').doc(hostelId).update({
      'name': name,
      'description': description,
      'location': location,
      'address': address,
      'roomRent': roomRent,
      'totalRooms': totalRooms,
      'availableRooms': availableRooms,
      'isAirConditioned': isAirConditioned,
      'isFoodMessAvailable': isFoodMessAvailable,
      'isWifiAvailable': isWifiAvailable,
      'gender': gender,
      'images': images,
      'ownerEmail': ownerEmail,
    });
  }

  Future<void> deleteHostel(String hostelId) async {
    await _db.collection('hostels').doc(hostelId).delete();
  }

  // Fetch all hostels from the database
  Stream<List<Hostel>> getHostels() {
    return _db.collection('hostels').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Hostel.fromFirestore(doc)).toList();
    });
  }

  // Create a new user document in the database
  Future<void> createUser({
    required String name,
    required String uid,
    required String contact,
    required String profilePicture,
  }) async {
    await _db.collection('users').doc(uid).set({
      'name': name,
      'contact': contact,
      'profilePicture': profilePicture,
    });
  }

  // Fetch all users from the database
  Stream<List<Users>> getUsers() {
    return _db.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Users.fromFirestore(doc)).toList();
    });
  }

  Future<DocumentSnapshot?> getUser(String uid) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final userDoc = await userRef.get();
    if (userDoc.exists) {
      return userDoc;
    } else {
      return null;
    }
  }

  Future<void> updateUser({
    required String uid,
    String name = '',
    String contact = '',
    String profilePicture = '',
  }) async {
    try {
      await _db.collection('users').doc(uid).update({
        'name': name,
        'contact': contact,
        'profilePicture': profilePicture,
      });
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  Future<Users?> getUserInfo(String uid) async {
    Users temp = Users(name: '-', uid: uid, contact: '-', profilePicture: '');
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
      return Users.fromFirestore(doc);
    } catch (e) {
      //print('Error fetching user info: $e');
      return temp;
    }
  }

  Future<Booking?> getBookingInfo(String userId, String hostelId) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('userId', isEqualTo: userId)
          .where('hostelId', isEqualTo: hostelId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return Booking.fromFirestore(querySnapshot.docs.first);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting booking info: $e');
      return null;
    }
  }

  // Create a new review document in the database
  Future<void> createReview({
    required String hostelId,
    required String userId,
    required String review,
    required int rating,
  }) async {
    await _db.collection('reviews').add({
      'hostelId': hostelId,
      'userId': userId,
      'review': review,
      'rating': rating,
    });
  }

  // Fetch all reviews from the database
  Stream<List<Review>> getReviews() {
    return _db.collection('reviews').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Review.fromFirestore(doc)).toList();
    });
  }

  Future<void> createBooking({
    required String hostelId,
    required String userId,
    required Timestamp timestamp,
  }) async {
    await _db
        .collection('Booking')
        .add({'hostelId': hostelId, 'userId': userId, 'timestamp': timestamp});
  }
}

class Users {
  final String name;
  final String uid;
  final String contact;
  final String profilePicture;

  Users({
    required this.name,
    required this.uid,
    required this.contact,
    required this.profilePicture,
  });

  factory Users.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    print('Fetched data: $data');
    return Users(
      name: data['name'] ?? '',
      uid: doc.id,
      contact: data['contact'] ?? '',
      profilePicture: data['profilePicture'] ?? '',
    );
  }
}

class Review {
  final String hostelId;
  final String userId;
  final String userName;
  final String reviewText;
  final int rating;
  final Timestamp timestamp;

  Review({
    required this.hostelId,
    required this.userId,
    required this.userName,
    required this.reviewText,
    required this.rating,
    required this.timestamp,
  });

  factory Review.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Review(
      hostelId: data['hostelId'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      reviewText: data['reviewText'] ?? '',
      rating: data['rating'] ?? 0,
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
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
  final bool isWifiAvailable;
  final String gender;
  final List<String> images;
  final String ownerEmail;
  final String hostelId;
  Hostel({
    required this.name,
    required this.description,
    required this.location,
    required this.address,
    required this.roomRent,
    required this.totalRooms,
    required this.availableRooms,
    required this.isAirConditioned,
    required this.isFoodMessAvailable,
    required this.isWifiAvailable,
    required this.gender,
    required this.images,
    required this.ownerEmail,
    required this.hostelId,
  });

  factory Hostel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
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
      isWifiAvailable: data['isWifiAvailable'] ?? false,
      gender: data['gender'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      ownerEmail: data['ownerEmail'] ?? '',
      hostelId: doc.id,
    );
  }
}

class Booking {
  final String userId;
  final String hostelId;
  final Timestamp timestamp;
  Booking({
    required this.userId,
    required this.hostelId,
    required this.timestamp,
  });
  factory Booking.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Booking(
      hostelId: data['hostelId'] ?? '',
      userId: data['userId'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:db_project/services/database_service.dart';

class UserProvider with ChangeNotifier {
  Users? _currentUser;

  Users? get currentUser => _currentUser;

  void setCurrentUser(Users user) {
    _currentUser = user;
    notifyListeners();
  }
}

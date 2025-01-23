import 'package:ezuite_login_app/configs/database_helper.dart';
import 'package:ezuite_login_app/models/user_model.dart';
import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  Future<void> loadUserFromDB() async {
    _currentUser = await DatabaseHelper.instance.getUser();
    notifyListeners();
  }

  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }

  // Update UserProvider to include setUser method
  // In user_provider.dart
  void setUser(UserModel? user) {
    _currentUser = user;
    notifyListeners();
  }
}

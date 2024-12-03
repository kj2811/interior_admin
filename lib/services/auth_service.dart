import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:interior_admin/model/user.dart';

class AuthService {
  Future<User?> validateUser(String email, String password) async {
    // Load the JSON file
    var rootBundle2 = rootBundle;
    final List<dynamic> data = json.decode(
        await newMethod(rootBundle2).loadString('assets/json/user.json'));

    // Check each user in the JSON
    for (var user in data) {
      User currentUser = User.fromJson(user);
      if (currentUser.email == email && currentUser.password == password) {
        return currentUser;
      }
    }
    return null; // Return null if no match found
  }

  AssetBundle newMethod(AssetBundle rootBundle2) => rootBundle2;
}

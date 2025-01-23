import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../configs/database_helper.dart';
import '../models/user_model.dart';

class AuthService {
  static  String loginUrl = dotenv.env['LOGIN_URL']!;

  Future<UserModel?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        body: jsonEncode({
          "API_Body": [
            {
              "Unique_Id": username,
              "Pw": password
            }
          ],
          "Api_Action": "GetUserData",
          "Company_Code": username
        }),
        headers: {
          'Content-Type': 'application/json'
        }
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['Status_Code'] == 200) {
          final userData = jsonResponse['Response_Body'][0];
          final user = UserModel.fromJson(userData);
          
          // Save user to SQLite
          await DatabaseHelper.instance.insertUser(user);
          return user;
        }
      }
      return null;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }
}

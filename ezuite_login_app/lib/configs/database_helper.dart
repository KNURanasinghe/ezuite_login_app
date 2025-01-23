import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/user_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  final logger = Logger();

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('user_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users (
      userCode TEXT PRIMARY KEY,
      userDisplayName TEXT,
      email TEXT,
      userEmployeeCode TEXT,
      companyCode TEXT,
      userLocations TEXT,
      userPermissions TEXT
    )
  ''');
  }

  Future<void> insertUser(UserModel user) async {
    final db = await database;

    try {
      final Map<String, dynamic> userMap = {
        'userCode': user.userCode,
        'userDisplayName': user.userDisplayName,
        'email': user.email,
        'userEmployeeCode': user.userEmployeeCode,
        'companyCode': user.companyCode,
        'userLocations':
            user.userLocations != null ? jsonEncode(user.userLocations) : null,
        'userPermissions': user.userPermissions != null
            ? jsonEncode(user.userPermissions)
            : null,
      };

      await db.insert(
        'users',
        userMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      logger.e('Error inserting user: $e');
    }
  }

  Future<UserModel?> getUser() async {
    final db = await database;

    try {
      final maps = await db.query('users');

      if (maps.isNotEmpty) {
        final userMap = Map<String, dynamic>.from(maps.first);

        // Decode JSON strings back to lists
        if (userMap['userLocations'] != null) {
          userMap['User_Locations'] = jsonDecode(userMap['userLocations']);
        }

        if (userMap['userPermissions'] != null) {
          userMap['User_Permissions'] = jsonDecode(userMap['userPermissions']);
        }

        final user = UserModel.fromJson(userMap);

        return user;
      }

      return null;
    } catch (e) {
      logger.e('Error retrieving user: $e');
      return null;
    }
  }
}

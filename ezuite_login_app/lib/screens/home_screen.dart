import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../configs/database_helper.dart';
import '../providers/user_provider.dart';
import '../screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadUserData();
    Provider.of<UserProvider>(context, listen: false).loadUserFromDB();
  }

  final logger = Logger();
  Future<void> _loadUserData() async {
    try {
      // Explicitly load user from database
      final user = await DatabaseHelper.instance.getUser();

      if (user != null) {
        Provider.of<UserProvider>(context, listen: false).setUser(user);
      } else {
        logger.e('No user found in database');
      }
    } catch (e) {
      logger.e('Error loading user:', error: ' $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<UserProvider>(context, listen: false).clearUser();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
          )
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.currentUser;
          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('User Profile',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                _buildUserInfoTile('User Code', user.userCode),
                _buildUserInfoTile('Display Name', user.userDisplayName),
                _buildUserInfoTile('Email', user.email),
                _buildUserInfoTile('Employee Code', user.userEmployeeCode),
                _buildUserInfoTile('Company Code', user.companyCode),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserInfoTile(String label, String value) {
    return ListTile(
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
    );
  }
}

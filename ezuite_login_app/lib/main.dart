import 'package:ezuite_login_app/providers/user_provider.dart';
import 'package:ezuite_login_app/screens/home_screen.dart';
import 'package:ezuite_login_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EZuite Login App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Consumer<UserProvider>(builder: (context, userProvider, child) {
        return userProvider.currentUser != null
            ? const HomeScreen()
            : const LoginScreen();
      }),
    );
  }
}

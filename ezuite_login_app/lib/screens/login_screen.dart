import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/text_form_feild_component.dart';
import '../providers/user_provider.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final result = await _authService.login(
          _usernameController.text, _passwordController.text);

      setState(() => _isLoading = false);

      if (result != null) {
        Provider.of<UserProvider>(context, listen: false).loadUserFromDB();

        // Navigate to home screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        // Navigate to home screen or dashboard
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Login Successful!')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Login Failed')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: Container(
              height: 400,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 3),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Log In",
                      style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal),
                    ),
                    const SizedBox(height: 32),
                    TextFromFeildComponent(
                      usernameController: _usernameController,
                      name: "Username",
                      validator: 'Enter Username',
                      obsecure: false,
                    ),
                    const SizedBox(height: 16),
                    TextFromFeildComponent(
                      usernameController: _passwordController,
                      name: "Password",
                      validator: 'Enter Password',
                      obsecure: true,
                    ),
                    const SizedBox(height: 24),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _login,
                            style: const ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.blue)),
                            child: const Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class TextFromFeildComponent extends StatefulWidget {
  final String name;
  final String validator;
  final bool obsecure;
  const TextFromFeildComponent(
      {super.key,
      required TextEditingController usernameController,
      required this.name,
      required this.validator,
      required this.obsecure})
      : _usernameController = usernameController;

  final TextEditingController _usernameController;

  @override
  State<TextFromFeildComponent> createState() => _TextFromFeildComponentState();
}

class _TextFromFeildComponentState extends State<TextFromFeildComponent> {
  late bool _isObscure;
  @override
  void initState() {
    super.initState();
    _isObscure = widget.obsecure; // Initialize the obscure state
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget._usernameController,
      decoration: InputDecoration(
        labelText: widget.name,
        border: const OutlineInputBorder(),
        suffixIcon: widget.obsecure
            ? IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure; // Toggle obscure state
                  });
                },
              )
            : null,
      ),
      obscureText: _isObscure,
      validator: (value) => value!.isEmpty ? widget.validator : null,
    );
  }
}

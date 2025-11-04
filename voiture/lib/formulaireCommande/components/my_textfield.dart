import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  final ValueChanged<bool> onIsFilledChanged;
  final TextInputType? keyboardType;
  const MyTextField({
    super.key,
    this.keyboardType,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.onIsFilledChanged,

  });

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool isFilled = false;
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        keyboardType : widget.keyboardType,
        controller: widget.controller,
        obscureText: widget.obscureText,
        onChanged: (text) {
          setState(() {
            // Mettez à jour la valeur isFilled lorsque le texte change
            isFilled = text.isNotEmpty;
          });
          widget.onIsFilledChanged(isFilled);
        },
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
      ),
    );
  }
}

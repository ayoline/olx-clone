// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputCustomizado extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final bool obscure;
  final bool autofocus;
  final TextInputType type;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final FormFieldValidator<String>? onSaved;

  InputCustomizado({
    required this.hint,
    this.inputFormatters,
    this.validator,
    this.obscure = false,
    this.autofocus = false,
    this.controller,
    this.type = TextInputType.text,
    this.maxLines = 1,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      autofocus: autofocus,
      keyboardType: type,
      inputFormatters: inputFormatters,
      validator: validator,
      maxLines: maxLines,
      onSaved: onSaved,
      style: const TextStyle(
        fontSize: 20,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}

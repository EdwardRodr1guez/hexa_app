import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexa_app/backend/players_service.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.playersService,
    required this.hintText,
    this.onChanged,
    this.inputFormatters,
    required this.maxLength,
    this.validator,
    this.showObscure,
  });
  final bool? showObscure;
  final Function(String)? onChanged;
  final TextEditingController controller;
  final PlayersService playersService;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLength;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: showObscure == true ? false : true,
      controller: controller,
      inputFormatters: inputFormatters,
      maxLength: maxLength,
      decoration: InputDecoration(hintText: hintText),
      validator: validator,
      onChanged: onChanged,
    );
  }
}

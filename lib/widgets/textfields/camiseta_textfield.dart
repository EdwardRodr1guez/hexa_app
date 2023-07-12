import 'package:flutter/material.dart';

class CamisetaTextField extends StatelessWidget {
  const CamisetaTextField({
    super.key,
    required this.camisetaTextfield,
  });

  final TextEditingController camisetaTextfield;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: camisetaTextfield,
      keyboardType: TextInputType.number,
      maxLength: 2,
      decoration: const InputDecoration(hintText: "Camiseta"),
    );
  }
}

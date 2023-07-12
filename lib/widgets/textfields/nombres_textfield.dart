import 'package:flutter/material.dart';

class NombresTextField extends StatelessWidget {
  const NombresTextField({
    super.key,
    required this.nombresTextfield,
  });

  final TextEditingController nombresTextfield;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: nombresTextfield,
      maxLength: 100,
      decoration: const InputDecoration(hintText: "Nombres"),
      validator: (value) {
        if (value!.isEmpty) {
          return "Campo obligatorio";
        }

        return null;
      },
    );
  }
}

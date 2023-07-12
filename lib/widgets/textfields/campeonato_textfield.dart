import 'package:flutter/material.dart';

class CampeonatosTextField extends StatelessWidget {
  const CampeonatosTextField({
    super.key,
    required this.campeonatosTextfield,
  });

  final TextEditingController campeonatosTextfield;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: campeonatosTextfield,
      validator: (value) {
        if (value!.isEmpty) {
          return "Campo obligatorio";
        }

        return null;
      },
      maxLength: 3,
      decoration: const InputDecoration(hintText: "Campeonatos"),
    );
  }
}

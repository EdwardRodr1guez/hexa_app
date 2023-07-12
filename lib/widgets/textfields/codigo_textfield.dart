import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexa_app/backend/players_service.dart';
import 'package:hexa_app/utils/formaters/uppercase_textformatter.dart';

class CodigoTextField extends StatelessWidget {
  const CodigoTextField({
    super.key,
    required this.codigoTextfield,
    required this.playersService,
  });

  final TextEditingController codigoTextfield;
  final PlayersService playersService;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: codigoTextfield,
      inputFormatters: [
        UpperCaseTextFormatter(),
        FilteringTextInputFormatter.deny(RegExp(r"\s")),
        FilteringTextInputFormatter.deny(RegExp(r'[^a-zA-Z0-9]'))
      ],
      maxLength: 10,
      decoration: const InputDecoration(hintText: "Código"),
      validator: (value) {
        if (value!.isEmpty) {
          return "Campo obligatorio";
        }
        for (var element in playersService.playersModel!) {
          if (element.codigo!.toLowerCase() == value.toLowerCase()) {
            return "El código debe ser único";
          }
        }
        return null;
      },
    );
  }
}

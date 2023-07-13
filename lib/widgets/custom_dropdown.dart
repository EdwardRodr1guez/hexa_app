import 'package:flutter/material.dart';
import 'package:hexa_app/models/teams_model.dart';

class CustomDropdownButton extends StatefulWidget {
  final bool? individual;
  final String? hintText;
  final String? value;
  final void Function(String?)? onchanged;
  final List<TeamsModel>? teams;
  const CustomDropdownButton({
    super.key,
    required this.teams,
    this.onchanged,
    this.value,
    this.hintText,
    this.individual,
  });

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  /*String dropdownValue = "Selecciona equipo";*/
  String? dropdownValue;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isDense: true,
      hint: Text("Equipo: ${widget.hintText}" ?? "Selecciona equipo"),
      //dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      validator: (value) {
        if ((value == null)) {
          return "Campo obligatorio";
        }
        if (value == widget.hintText) {
          return "El nuevo valor no puede ser idéntico al actual";
        }

        return null;
      },
      onChanged: widget.onchanged,
      /*(String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },*/
      items: widget.teams!
          .map((value) => value.nombre!)
          .toList()
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

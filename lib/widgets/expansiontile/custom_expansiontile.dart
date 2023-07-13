import 'package:flutter/material.dart';
import 'package:hexa_app/models/players_model.dart';
import 'package:hexa_app/widgets/forms/custom_form.dart';

class CustomExpansionTile extends StatefulWidget {
  final PlayersModel player;
  const CustomExpansionTile({super.key, required this.player});

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  ExpansionTileController expansionController = ExpansionTileController();

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        controller: expansionController,
        childrenPadding: const EdgeInsets.symmetric(horizontal: 25),
        trailing: const Icon(Icons.edit),
        leading: const Icon(Icons.person),
        title: Text(widget.player.nombres!),
        children: [
          CustomForm(
            expansionController: expansionController,
            player: widget.player,
          )
        ]);
  }
}

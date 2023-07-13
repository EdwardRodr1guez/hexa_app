import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexa_app/backend/players_service.dart';
import 'package:hexa_app/backend/teams_service.dart';
import 'package:hexa_app/utils/formaters/uppercase_textformatter.dart';
import 'package:hexa_app/utils/validators/custom_validator.dart';
import 'package:hexa_app/widgets/custom_dropdown.dart';
import 'package:hexa_app/widgets/expansiontile/custom_expansiontile.dart';

import 'package:hexa_app/widgets/textfields/custom_textfield.dart';

import 'package:provider/provider.dart';

class PlayersScreen extends StatefulWidget {
  const PlayersScreen({
    super.key,
  });

  @override
  State<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  @override
  void initState() {
    super.initState();
    Future.wait([
      Provider.of<PlayersService>(context, listen: false).getPlayers(),
      Provider.of<TeamsService>(context, listen: false).getTeams()
    ]);
  }

  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  //Agregar registro nuevo
  TextEditingController nuevoCodigoTextfield = TextEditingController();
  TextEditingController nuevoNombresTextfield = TextEditingController();
  TextEditingController nuevoCamisetaTextfield = TextEditingController();
  TextEditingController nuevoCampeonatosTextfield = TextEditingController();
  int nuevoIdEquipo = -1;
  String nuevoCodigoEquipo = "";
  String nuevoNombreEquipo = "";
  String? nuevoDropdownValue;
  String nuevoRegistryStatus = "Agregar";
  bool nuevoIsSubmittingNewRegister = false;

  bool isSubmittingNewRegister = false;

  @override
  void dispose() {
    nuevoCodigoTextfield.dispose();
    nuevoNombresTextfield.dispose();
    nuevoCamisetaTextfield.dispose();
    nuevoCampeonatosTextfield.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playersService = Provider.of<PlayersService>(context);
    final teamsService = Provider.of<TeamsService>(context);

    return playersService.playersModel!.isEmpty
        ? const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                strokeWidth: 2,
              ),
              SizedBox(
                height: 15,
              ),
              Text("Loading"),
            ],
          )
        : RefreshIndicator(
            onRefresh: () async {
              await playersService.getPlayers();
            },
            child: Stack(children: [
              Container(
                margin: const EdgeInsets.only(
                  bottom: 80,
                ),
                child: ListView.builder(
                  itemCount: playersService.playersModel!.length,
                  itemBuilder: (context, index) {
                    final player = playersService.playersModel![index];

                    return CustomExpansionTile(player: player);
                  },
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: FloatingActionButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(builder: (context, setState) {
                          return WillPopScope(
                            onWillPop: () async {
                              nuevoRegistryStatus = "Agregar";
                              return true;
                            },
                            child: AlertDialog(
                              scrollable: true,
                              title: const Text("Agregar nuevo jugador "),
                              content: Form(
                                key: _form,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Column(
                                    children: [
                                      CustomTextField(
                                        controller: nuevoCodigoTextfield,
                                        playersService: playersService,
                                        hintText: "Código",
                                        maxLength: 10,
                                        inputFormatters: [
                                          UpperCaseTextFormatter(),
                                          FilteringTextInputFormatter.deny(
                                              RegExp(r"\s")),
                                          FilteringTextInputFormatter.deny(
                                              RegExp(r'[^a-zA-Z0-9]'))
                                        ],
                                        validator: (value) {
                                          return CustomValidator
                                              .codigoValidator(
                                                  value: value!,
                                                  playersService:
                                                      playersService);
                                        },
                                      ),
                                      CustomTextField(
                                        controller: nuevoNombresTextfield,
                                        playersService: playersService,
                                        hintText: "Nombres",
                                        maxLength: 100,
                                        validator: (value) {
                                          return CustomValidator
                                              .nombresValidator(value: value!);
                                        },
                                      ),

                                      /*NombresTextField(
                                          nombresTextfield:
                                              nuevoNombresTextfield),*/
                                      CustomTextField(
                                        controller: nuevoCamisetaTextfield,
                                        playersService: playersService,
                                        hintText: 'Camiseta:',
                                        maxLength: 2,
                                      ),
                                      CustomDropdownButton(
                                          value: nuevoDropdownValue,
                                          onchanged: (String? value) {
                                            setState(() {
                                              nuevoDropdownValue = value;
                                              int idxSelected = teamsService
                                                  .teamsModel!
                                                  .indexWhere((element) =>
                                                      element.nombre == value);
                                              nuevoIdEquipo = teamsService
                                                  .teamsModel![idxSelected]
                                                  .idEquipo!;
                                              nuevoCodigoEquipo = teamsService
                                                  .teamsModel![idxSelected]
                                                  .codigo
                                                  .toString();
                                              nuevoNombreEquipo = teamsService
                                                  .teamsModel![idxSelected]
                                                  .nombre
                                                  .toString();
                                            });
                                          },
                                          teams: teamsService.teamsModel!),
                                      CustomTextField(
                                        controller: nuevoCampeonatosTextfield,
                                        playersService: playersService,
                                        hintText: 'Campeonatos:',
                                        maxLength: 3,
                                        validator: (value) {
                                          return CustomValidator
                                              .campeonatosValidator(
                                                  value: value!);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              actionsPadding: const EdgeInsets.only(bottom: 5),
                              actionsAlignment: MainAxisAlignment.spaceBetween,
                              actions: [
                                if (!nuevoIsSubmittingNewRegister)
                                  TextButton(
                                      onPressed: () {
                                        nuevoRegistryStatus = "Agregar";
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Cancelar")),
                                TextButton(
                                    onPressed: () async {
                                      bool isValidated =
                                          _form.currentState!.validate();

                                      if (isValidated) {
                                        setState(() {
                                          nuevoIsSubmittingNewRegister = true;
                                        });
                                        Map data = {
                                          "idJugador": (playersService
                                                      .playersModel!.length +
                                                  1)
                                              .toInt(),
                                          "codigo": nuevoCodigoTextfield.text
                                              .toString(),
                                          "nombres": nuevoNombresTextfield.text
                                              .toString(),
                                          "camiseta": nuevoCamisetaTextfield
                                              .text
                                              .toString(),
                                          "campeonatos":
                                              nuevoCampeonatosTextfield.text
                                                  .toString(),
                                          "idEquipo": nuevoIdEquipo.toInt(),
                                          "codigoEquipo":
                                              nuevoCodigoEquipo.toString(),
                                          "nombreEquipo":
                                              nuevoNombreEquipo.toString()
                                        };

                                        final response = await playersService
                                            .postPlayer(data);
                                        setState(() {
                                          nuevoIsSubmittingNewRegister = false;
                                        });
                                        if (response) {
                                          nuevoRegistryStatus = "Exitoso";

                                          await playersService.getPlayers();
                                          await Future.delayed(const Duration(
                                                  milliseconds: 1000))
                                              .then((value) {
                                            nuevoRegistryStatus = "Agregar";
                                            setState(() {});
                                          });
                                        } else {
                                          nuevoRegistryStatus = "Error";
                                          await Future.delayed(const Duration(
                                                  milliseconds: 1000))
                                              .then((value) {
                                            nuevoRegistryStatus = "Agregar";
                                            setState(() {});
                                          });
                                        }
                                      }
                                    },
                                    child: nuevoIsSubmittingNewRegister
                                        ? const Center(
                                            child: CircularProgressIndicator())
                                        : Text(nuevoRegistryStatus))
                              ],
                            ),
                          );
                        });
                      },
                    );
                  },
                  child: const Icon(Icons.add),
                ),
              ),
            ]),
          );
  }
}

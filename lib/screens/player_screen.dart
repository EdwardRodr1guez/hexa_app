import 'package:flutter/material.dart';
import 'package:hexa_app/backend/players_service.dart';
import 'package:hexa_app/backend/teams_service.dart';
import 'package:hexa_app/widgets/custom_dropdown.dart';
import 'package:hexa_app/widgets/textfields/camiseta_textfield.dart';
import 'package:hexa_app/widgets/textfields/campeonato_textfield.dart';
import 'package:hexa_app/widgets/textfields/codigo_textfield.dart';
import 'package:hexa_app/widgets/textfields/nombres_textfield.dart';
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
  TextEditingController codigoTextfield = TextEditingController();
  TextEditingController nombresTextfield = TextEditingController();
  TextEditingController camisetaTextfield = TextEditingController();
  TextEditingController campeonatosTextfield = TextEditingController();

  int idEquipo = -1;
  String codigoEquipo = "";
  String nombreEquipo = "";
  String? dropdownValue;
  String registryStatus = "Agregar";

  bool isSubmittingNewRegister = false;

  @override
  void dispose() {
    codigoTextfield.dispose();
    nombresTextfield.dispose();
    camisetaTextfield.dispose();
    campeonatosTextfield.dispose();
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
        : Stack(children: [
            Container(
              margin: const EdgeInsets.only(bottom: 80),
              child: ListView.builder(
                itemCount: playersService.playersModel!.length,
                itemBuilder: (context, index) {
                  final player = playersService.playersModel![index];
                  final List playerInfo = [
                    'Código: ${player.codigo}',
                    'Nombres: ${player.nombres}',
                    'Camiseta: ${player.camiseta}',
                    'Equipo: ${player.nombreEquipo}',
                    'Campeonatos: ${player.campeonatos}'
                  ];
                  return ExpansionTile(
                      trailing: const Icon(Icons.edit),
                      leading: const Icon(Icons.person),
                      title: Text("${player.nombres}"),
                      children: List.generate(5, (idx) {
                        return TextField(
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 20),
                              hintText: playerInfo[idx]),
                        );
                      }));
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
                            registryStatus = "Agregar";
                            return true;
                          },
                          child: AlertDialog(
                            content: Form(
                              key: _form,
                              child: Column(
                                children: [
                                  CodigoTextField(
                                      codigoTextfield: codigoTextfield,
                                      playersService: playersService),
                                  NombresTextField(
                                      nombresTextfield: nombresTextfield),
                                  CamisetaTextField(
                                      camisetaTextfield: camisetaTextfield),
                                  CustomDropdownButton(
                                      value: dropdownValue,
                                      onchanged: (String? value) {
                                        setState(() {
                                          dropdownValue = value;
                                          int idxSelected = teamsService
                                              .teamsModel!
                                              .indexWhere((element) =>
                                                  element.nombre == value);
                                          idEquipo = teamsService
                                              .teamsModel![idxSelected]
                                              .idEquipo!;
                                          codigoEquipo = teamsService
                                              .teamsModel![idxSelected].codigo
                                              .toString();
                                          nombreEquipo = teamsService
                                              .teamsModel![idxSelected].nombre
                                              .toString();
                                        });
                                      },
                                      teams: teamsService.teamsModel!),
                                  CampeonatosTextField(
                                      campeonatosTextfield:
                                          campeonatosTextfield),
                                ],
                              ),
                            ),
                            actionsPadding: const EdgeInsets.only(bottom: 5),
                            actionsAlignment: MainAxisAlignment.spaceBetween,
                            actions: [
                              if (!isSubmittingNewRegister)
                                TextButton(
                                    onPressed: () {
                                      registryStatus = "Agregar";
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Cancelar")),
                              TextButton(
                                  onPressed: () async {
                                    bool isValidated =
                                        _form.currentState!.validate();

                                    if (isValidated) {
                                      setState(() {
                                        isSubmittingNewRegister = true;
                                      });
                                      Map data = {
                                        "idJugador": (playersService
                                                    .playersModel!.length +
                                                1)
                                            .toInt(),
                                        "codigo":
                                            codigoTextfield.text.toString(),
                                        "nombres":
                                            nombresTextfield.text.toString(),
                                        "camiseta":
                                            camisetaTextfield.text.toString(),
                                        "campeonatos": campeonatosTextfield.text
                                            .toString(),
                                        "idEquipo": idEquipo.toInt(),
                                        "codigoEquipo": codigoEquipo.toString(),
                                        "nombreEquipo": nombreEquipo.toString()
                                      };

                                      final response =
                                          await playersService.postPlayer(data);
                                      setState(() {
                                        isSubmittingNewRegister = false;
                                      });
                                      if (response) {
                                        registryStatus = "Exitoso";
                                        //await Provider.of<PlayersService>(context,listen: false).getPlayers();
                                        await playersService.getPlayers();
                                        await Future.delayed(const Duration(
                                                milliseconds: 1000))
                                            .then((value) {
                                          registryStatus = "Agregar";
                                          setState(() {});
                                        });
                                      } else {
                                        registryStatus = "Error";
                                        await Future.delayed(const Duration(
                                                milliseconds: 1000))
                                            .then((value) {
                                          registryStatus = "Agregar";
                                          setState(() {});
                                        });
                                      }
                                      /*registryStatus = "Agregar";
                                      await Future.delayed(
                                          const Duration(milliseconds: 1000));*/
                                    }
                                  },
                                  child: isSubmittingNewRegister
                                      ? const Center(
                                          child: CircularProgressIndicator())
                                      : Text(registryStatus))
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
          ]);
  }
}

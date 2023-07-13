import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexa_app/backend/players_service.dart';
import 'package:hexa_app/backend/teams_service.dart';
import 'package:hexa_app/models/players_model.dart';
import 'package:hexa_app/utils/formaters/uppercase_textformatter.dart';
import 'package:hexa_app/utils/validators/custom_validator.dart';
import 'package:hexa_app/widgets/custom_dropdown.dart';
import 'package:hexa_app/widgets/textfields/custom_textfield.dart';
import 'package:provider/provider.dart';

class CustomForm extends StatefulWidget {
  final ExpansionTileController expansionController;
  final PlayersModel player;
  const CustomForm(
      {super.key, required this.player, required this.expansionController});

  @override
  State<CustomForm> createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  //Editar registro
  TextEditingController codigoTextfield = TextEditingController();
  TextEditingController nombresTextfield = TextEditingController();
  TextEditingController camisetaTextfield = TextEditingController();
  TextEditingController campeonatosTextfield = TextEditingController();
  int idEquipo = -1;
  String codigoEquipo = "";
  String? nombreEquipo;
  String? dropdownValue;
  String registryStatus = "actualizar";

  String? codigo;
  String? nombres;
  String? camiseta;
  String? campeonato;

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
    bool hasEditedAllField() {
      if ((codigoTextfield.text
              .isNotEmpty /*&
              (widget.player.codigo != codigoTextfield.text)*/
          ) &
          (nombresTextfield.text
              .isNotEmpty /*  &
              (widget.player.nombres != nombresTextfield.text)*/
          ) &
          (camisetaTextfield.text
              .isNotEmpty /*&
              (widget.player.camiseta != camisetaTextfield.text)*/
          ) &
          (campeonatosTextfield.text
              .isNotEmpty /* &
              (widget.player.campeonatos != campeonatosTextfield.text)*/
          ) &
          ((dropdownValue != widget.player.nombreEquipo)) &
          (dropdownValue != null)) {
        return true;
      } else {
        return false;
      }
    }

    return Form(
      key: _form,
      child: Column(
        children: [
          CustomTextField(
            controller: codigoTextfield,
            playersService: playersService,
            hintText: 'Código: ${widget.player.codigo}',
            maxLength: 10,
            inputFormatters: [
              UpperCaseTextFormatter(),
              FilteringTextInputFormatter.deny(RegExp(r"\s")),
              FilteringTextInputFormatter.deny(RegExp(r'[^a-zA-Z0-9]'))
            ],
            onChanged: (value) => setState(() {
              codigo = value;
            }),
            validator: (value) {
              return CustomValidator.codigoValidator(
                  value: value,
                  playersService: playersService,
                  individual: true);
            },
          ),
          CustomTextField(
            controller: nombresTextfield,
            playersService: playersService,
            hintText: 'Nombres: ${widget.player.nombres}',
            maxLength: 100,
            onChanged: (value) => setState(() {
              nombres = value;
            }),
            validator: (value) {
              return CustomValidator.nombresValidator(
                  value: value, individual: true);
            },
          ),
          CustomTextField(
            controller: camisetaTextfield,
            playersService: playersService,
            hintText: 'Camiseta: ${widget.player.camiseta}',
            maxLength: 2,
            onChanged: (value) => setState(() {
              camiseta = value;
            }),
          ),
          CustomDropdownButton(
              individual: true,
              hintText: widget.player.nombreEquipo,
              value: dropdownValue,
              onchanged: (String? value) {
                setState(() {
                  dropdownValue = value;
                  int idxSelected = teamsService.teamsModel!
                      .indexWhere((element) => element.nombre == value);
                  idEquipo = teamsService.teamsModel![idxSelected].idEquipo!;
                  codigoEquipo =
                      teamsService.teamsModel![idxSelected].codigo.toString();
                  nombreEquipo =
                      teamsService.teamsModel![idxSelected].nombre.toString();
                });
              },
              teams: teamsService.teamsModel!),
          CustomTextField(
            showObscure: (!widget.player.nombreEquipo!.trim().startsWith("a")) |
                (!widget.player.nombreEquipo!.trim().startsWith("b")),
            controller: campeonatosTextfield,
            playersService: playersService,
            hintText: widget.player.nombreEquipo!
                        .toLowerCase()
                        .startsWith("a") |
                    widget.player.nombreEquipo!.toLowerCase().startsWith("b")
                ? 'Campeonatos:   ${widget.player.campeonatos}'
                : 'Campeonatos: ···',
            maxLength: 3,
            onChanged: (value) => setState(() {
              campeonato = value;
            }),
            validator: (value) {
              return CustomValidator.campeonatosValidator(
                  value: value, individual: true);
            },
          ),
          const SizedBox(
            height: 10,
          ),
          //if (hasEditedSomeField())
          Opacity(
            opacity: hasEditedAllField() ? 1 : 0.4,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: FilledButton(
                  onPressed: () async {
                    Map updatePlayer = {"idJugador": widget.player.idJugador};
                    bool isValidate = _form.currentState!.validate();
                    log("El estatus del validador es $isValidate");
                    if (isValidate) {
                      isSubmittingNewRegister = true;
                      setState(() {});
                      if (codigoTextfield.text.isNotEmpty) {
                        updatePlayer["codigo"] = codigoTextfield.text;
                      }
                      if (nombresTextfield.text.isNotEmpty) {
                        updatePlayer["nombres"] = nombresTextfield.text;
                      }
                      if (camisetaTextfield.text.isNotEmpty) {
                        updatePlayer["camiseta"] = camisetaTextfield.text;
                      }
                      if (campeonatosTextfield.text.isNotEmpty) {
                        updatePlayer["campeonatos"] = campeonatosTextfield.text;
                      }
                      if ((dropdownValue != widget.player.nombreEquipo) &
                          (dropdownValue != null)) {
                        int idxSelected = teamsService.teamsModel!.indexWhere(
                            (element) => element.nombre == dropdownValue);

                        updatePlayer["idEquipo"] =
                            teamsService.teamsModel![idxSelected].idEquipo!;
                        updatePlayer["codigoEquipo"] = teamsService
                            .teamsModel![idxSelected].codigo
                            .toString();
                        updatePlayer["nombreEquipo"] = teamsService
                            .teamsModel![idxSelected].nombre
                            .toString();
                      }

                      log(updatePlayer.toString());
                      final response =
                          await playersService.updatePlayer(updatePlayer);
                      log(response.toString());
                      await playersService.getPlayers();
                      isSubmittingNewRegister = false;
                      setState(() {});

                      if (response) {
                        registryStatus = "Exitoso";

                        await playersService.getPlayers();
                        await Future.delayed(const Duration(milliseconds: 1000))
                            .then((value) {
                          registryStatus = "Actualizar";
                          setState(() {});
                          widget.expansionController.collapse();
                        });
                      } else {
                        registryStatus = "Error";
                        await Future.delayed(const Duration(milliseconds: 1000))
                            .then((value) {
                          registryStatus = "Actualizar";
                          setState(() {});
                        });
                      }
                    }
                  },
                  child: isSubmittingNewRegister
                      ? const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Text(registryStatus)),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}

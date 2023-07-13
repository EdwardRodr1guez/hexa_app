import 'package:hexa_app/backend/players_service.dart';

class CustomValidator {
  static String? codigoValidator(
      {String? value,
      required PlayersService playersService,
      bool? individual}) {
    if ((value!.isEmpty)) {
      return "Campo obligatorio";
    }
    for (var element in playersService.playersModel!) {
      if (element.codigo!.toLowerCase() == value.toLowerCase()) {
        return "El código debe ser único";
      }
    }

    return null;
  }

  static String? nombresValidator({String? value, bool? individual}) {
    if ((value!.trim().isEmpty)) {
      return "Campo obligatorio";
    }

    return null;
  }

  static String? camisetaValidator({String? value, String? current}) {
    return null;
  }

  static String? campeonatosValidator({String? value, bool? individual}) {
    if ((value!.trim().isEmpty)) {
      return "Campo obligatorio";
    }

    return null;
  }
}

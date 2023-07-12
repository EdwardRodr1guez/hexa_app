// To parse this JSON data, do
//
//     final playersModel = playersModelFromMap(jsonString);

class PlayersModel {
  int? idJugador;
  String? codigo;
  String? nombres;
  String? camiseta;
  String? campeonatos;
  int? idEquipo;
  String? codigoEquipo;
  String? nombreEquipo;

  PlayersModel({
    this.idJugador,
    this.codigo,
    this.nombres,
    this.camiseta,
    this.campeonatos,
    this.idEquipo,
    this.codigoEquipo,
    this.nombreEquipo,
  });

  factory PlayersModel.fromMap(Map<String, dynamic> json) => PlayersModel(
        idJugador: json["idJugador"],
        codigo: json["codigo"],
        nombres: json["nombres"],
        camiseta: json["camiseta"],
        campeonatos: json["campeonatos"],
        idEquipo: json["idEquipo"],
        codigoEquipo: json["codigoEquipo"],
        nombreEquipo: json["nombreEquipo"],
      );
}

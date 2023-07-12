// To parse this JSON data, do
//
//     final teamsModel = teamsModelFromMap(jsonString);

import 'dart:convert';

List<TeamsModel> teamsModelFromMap(String str) =>
    List<TeamsModel>.from(json.decode(str).map((x) => TeamsModel.fromMap(x)));

String teamsModelToMap(List<TeamsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class TeamsModel {
  int? idEquipo;
  String? codigo;
  String? nombre;

  TeamsModel({
    this.idEquipo,
    this.codigo,
    this.nombre,
  });

  factory TeamsModel.fromMap(Map<String, dynamic> json) => TeamsModel(
        idEquipo: json["idEquipo"],
        codigo: json["codigo"],
        nombre: json["nombre"],
      );

  Map<String, dynamic> toMap() => {
        "idEquipo": idEquipo,
        "codigo": codigo,
        "nombre": nombre,
      };
}

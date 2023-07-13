import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hexa_app/models/players_model.dart';

class PlayersService extends ChangeNotifier {
  List<PlayersModel>? playersModel = [];

  final dio = Dio(BaseOptions(baseUrl: "http://143.244.154.127:34765/api"));
  Future<List<PlayersModel>?> getPlayers() async {
    final response = await dio.get("/jugadores");

    playersModel = response.data
        .map<PlayersModel>((player) => PlayersModel.fromMap(player))
        .toList();

    notifyListeners();
    return playersModel;
  }

  Future<bool> postPlayer(Map data) async {
    try {
      await dio.post("/jugadores", data: data);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> updatePlayer(Map data) async {
    try {
      await dio.put("/jugadores", data: data);
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}

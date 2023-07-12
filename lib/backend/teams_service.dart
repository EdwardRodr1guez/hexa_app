import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hexa_app/models/teams_model.dart';

class TeamsService extends ChangeNotifier {
  List<TeamsModel>? teamsModel = [];

  final dio = Dio(BaseOptions(baseUrl: "http://143.244.154.127:34765/api"));

  Future<List<TeamsModel>?> getTeams() async {
    final response = await dio.get("/equipos");

    teamsModel = response.data
        .map<TeamsModel>((team) => TeamsModel.fromMap(team))
        .toList();

    teamsModel!.sort((a, b) => a.nombre!.compareTo(b.nombre!));
    for (var element in teamsModel!) {
      log(element.nombre!);
    }
    notifyListeners();
    return teamsModel;
  }
}

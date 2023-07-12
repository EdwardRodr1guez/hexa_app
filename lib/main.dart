import 'package:flutter/material.dart';
import 'package:hexa_app/backend/players_service.dart';
import 'package:hexa_app/backend/teams_service.dart';
import 'package:hexa_app/config/app_theme.dart';
import 'package:hexa_app/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlayersService()),
        ChangeNotifierProvider(create: (_) => TeamsService()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Hexa App',
          theme: AppTheme().getTheme(),
          home: const HomeScreen()),
    );
  }
}

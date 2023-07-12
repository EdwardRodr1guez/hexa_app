import 'package:flutter/material.dart';
import 'package:hexa_app/screens/exercises_screen.dart';
import 'package:hexa_app/screens/player_screen.dart';
import 'package:hexa_app/widgets/custom_bottomnav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController = PageController();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentIndex == 0 ? "Players List" : "Exercises"),
        centerTitle: true,
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: (value) {
          currentIndex = value;
          setState(() {});
        },
        children: const [PlayersScreen(), Exercises()],
      ),
      bottomNavigationBar: CustomBottomNav(
          pageController: pageController, currentIndex: currentIndex),
    );
  }
}

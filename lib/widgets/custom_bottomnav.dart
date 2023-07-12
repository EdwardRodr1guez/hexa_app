import 'package:flutter/material.dart';

class CustomBottomNav extends StatefulWidget {
  final PageController pageController;
  final int currentIndex;
  const CustomBottomNav({
    super.key,
    required this.pageController,
    required this.currentIndex,
  });

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: (value) {
          widget.pageController.jumpToPage(value);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.people_sharp,
              color: widget.currentIndex == 0 ? color.primary : Colors.black26,
            ),
            label: "Jugadores",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.text_snippet_outlined,
                color:
                    widget.currentIndex == 1 ? color.primary : Colors.black26),
            label: "Ejercicios",
          ),
        ]);
  }
}

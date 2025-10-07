import 'package:flutter/material.dart';
import '../screens/home.dart';
import '../screens/profile.dart';
import '../screens/favorite.dart';
import '../main.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});
  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _currentIndex = 0;
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomePage(),
      const FavoritePage(),
      ProfilePage(onHomeTap: () => _onTabTapped(0)),
    ];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: pages[_currentIndex],
      floatingActionButton: FloatingActionButton(
        child: Icon(isDark ? Icons.wb_sunny : Icons.nightlight_round),
        onPressed: () {
          // Toggle theme in the app state
          final appState = CountryApp.of(context);
          appState?.toggleTheme();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}


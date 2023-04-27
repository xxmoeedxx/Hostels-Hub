import 'package:db_project/pages/hostel_list.dart';
import 'package:db_project/pages/map2.dart';
import 'package:db_project/pages/profile_page.dart';
import 'package:flutter/material.dart';

class AnimatedBottomBar extends StatefulWidget {
  const AnimatedBottomBar({Key? key}) : super(key: key);

  @override
  _AnimatedBottomBarState createState() => _AnimatedBottomBarState();
}

class _AnimatedBottomBarState extends State<AnimatedBottomBar> {
  static int _currentIndex = 0;
  final List<IconData> _icons = [
    Icons.home,
    Icons.map,
    Icons.notifications,
    Icons.person,
  ];
  final List<String> _labels = [
    'Hostel List',
    'Map',
    'Notifications',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color.fromARGB(255, 7, 6, 68),
          selectedItemColor: const Color.fromARGB(255, 179, 217, 248),
          unselectedItemColor: const Color.fromARGB(209, 255, 255, 255),
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              if (index == 0) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HostelListPage()));
              } else if (index == 1) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const MapPage()));
              } else if (index == 3) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()));
              }
            });
          },
          items: List.generate(
            _icons.length,
            (index) => BottomNavigationBarItem(
              icon: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _currentIndex == index ? 30 : 20,
                child: Icon(
                  _icons[index],
                ),
              ),
              label: _labels[index],
            ),
          ),
        ),
      ),
    );
  }
}

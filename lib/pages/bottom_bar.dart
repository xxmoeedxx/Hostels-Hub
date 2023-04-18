import 'package:flutter/material.dart';

class AnimatedBottomBar extends StatefulWidget {
  final List<IconData> icons;
  final List<String> labels;

  const AnimatedBottomBar({
    Key? key,
    required this.icons,
    required this.labels,
  }) : super(key: key);

  @override
  _AnimatedBottomBarState createState() => _AnimatedBottomBarState();
}

class _AnimatedBottomBarState extends State<AnimatedBottomBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color.fromARGB(255, 7, 6, 68),
          selectedItemColor: Color.fromARGB(255, 179, 217, 248),
          unselectedItemColor: Color.fromARGB(209, 255, 255, 255),
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: List.generate(
            widget.icons.length,
            (index) => BottomNavigationBarItem(
              icon: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: _currentIndex == index ? 30 : 20,
                child: Icon(
                  widget.icons[index],
                ),
              ),
              label: widget.labels[index],
            ),
          ),
        ),
      ),
    );
    const SizedBox(height: 55);
  }
}

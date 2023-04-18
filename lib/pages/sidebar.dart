import 'package:flutter/material.dart';

class AnimatedSidebar extends StatefulWidget {
  final List<IconData> icons;
  final List<String> labels;
  final Function(int) onTap;

  const AnimatedSidebar({
    Key? key,
    required this.icons,
    required this.labels,
    required this.onTap,
  }) : super(key: key);

  @override
  _AnimatedSidebarState createState() => _AnimatedSidebarState();
}

class _AnimatedSidebarState extends State<AnimatedSidebar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: FadeTransition(
              opacity: _animation,
              child: Container(
                height: widget.icons.length * 60.0,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    widget.icons.length,
                    (index) => InkWell(
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                        widget.onTap(_selectedIndex);
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: _selectedIndex == index ? 60 : 50,
                        height: _selectedIndex == index ? 60 : 50,
                        decoration: BoxDecoration(
                          color: _selectedIndex == index
                              ? Colors.blue
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                          widget.icons[index],
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: InkWell(
              onTap: () {
                if (_animationController.status == AnimationStatus.completed) {
                  _animationController.reverse();
                } else {
                  _animationController.forward();
                }
              },
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

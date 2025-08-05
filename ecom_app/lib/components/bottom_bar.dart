import 'package:flutter/material.dart';

class CustomBottomBar extends StatefulWidget {
  final int currentIndex;
  
  const CustomBottomBar({
    super.key,
    required this.currentIndex,
  });

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  
  void _onItemTapped(int index) {
    // Only navigate if not already on the selected page
    if (index == widget.currentIndex) return;
    
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: _onItemTapped,
      selectedItemColor: Colors.deepPurple, // Active color
      unselectedItemColor: Colors.grey, // Inactive color
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
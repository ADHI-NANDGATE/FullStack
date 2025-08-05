import 'package:ecom_app/util/deletedialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}


Future<void> showLogoutDialog(BuildContext context) async {
    showDialog(
    context: context,
    builder: (context) {
      return DialogBox(
        onSave: () {
          logout(context);
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
        );
    }
  ); 
}

Future<void> logout(context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('auth_token');
  Navigator.pushNamed(context, '/login');
}


class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('E-Commerce App'),
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
            Navigator.pushNamed(context, '/cart');
          },
        ),
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            Navigator.pushNamed(context, '/profile');
          },
        ),
        IconButton(
          icon: const Icon(Icons.logout_rounded),
          onPressed: () => showLogoutDialog(context),
        ),
      ],
    );
  }
}
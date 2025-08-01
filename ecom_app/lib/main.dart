import 'package:ecom_app/landing_page.dart';
import 'package:ecom_app/login_page.dart';
import 'package:ecom_app/register_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-commerce App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LandingPage(),
      routes: {
        '/landing': (context) => const LandingPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}

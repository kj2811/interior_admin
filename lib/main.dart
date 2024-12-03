import 'package:flutter/material.dart';
import 'package:interior_admin/screens/login.dart';
import 'package:interior_admin/screens/manager_screen.dart';
import 'package:interior_admin/screens/employee_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Interior Admin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/manager': (context) => const ManagerScreen(),
        '/employee': (context) => const EmployeeScreen(),
      },
      home: const LoginPage(),
    );
  }
}

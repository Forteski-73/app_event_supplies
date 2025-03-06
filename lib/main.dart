import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pag/login.dart'; // Importe a página de login

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login com Google',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(), // Chama a LoginPage aqui
    );
  }
}
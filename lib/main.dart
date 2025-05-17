import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pag/login.dart';
import 'cls/routes.dart';  // import das rotas

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
      title: 'Login com Google e Facebook',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(),
      routes: appRoutes,  // mapa importado
      onGenerateRoute: onGenerateRoute,  // rotas dinâmicas com argumentos
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'menu.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // O usuário cancelou a autenticação
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print("Erro no login com Google: $e");
      return null;
    }
  }

  Future<User?> _signInWithFacebook() async {
    try {
      
      debugPrint("Login com Facebook.............");
      final LoginResult result = await FacebookAuth.instance.login();
      debugPrint("Login com Facebook...............: ${result.status}");
      if (result.status == LoginStatus.success) {
        final accessToken = result.accessToken;
        if (accessToken != null) {
          final OAuthCredential credential = FacebookAuthProvider.credential(accessToken.tokenString); // Acesso ao token diretamente
          final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
          print("Login com Facebook.....: ${userCredential.user}");
          return userCredential.user;
        }
      }
    } catch (e) {
      print("Erro no login com Facebook: $e");
      return null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Aplicativo de Gestão de Materiais para Eventos")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final user = await _signInWithGoogle();
                if (user != null) {
                  if (user != null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Menu()),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 15, 130, 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Image.asset('assets/google_icon.png', width: 30, height: 30),
                  Icon(Icons.search, color: Colors.white), // Ícone do Google
                  SizedBox(width: 10),
                  Text('Login com Google', style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final user = await _signInWithGoogle();
                if (user != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Menu()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 15, 130, 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.facebook, color: const Color.fromARGB(255, 90, 88, 88)), // Ícone do Facebook
                  SizedBox(width: 10),
                  Text('Login com Facebook', style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Função para realizar o login com Google
  Future<User?> signInWithGoogle() async {
    try {
      print("Iniciando o login com Google...");

      // Iniciar o processo de login com Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // O usuário cancelou o login, retornando null
        print("O usuário cancelou o login");
        return null;
      }

      print("Usuário autenticado no Google: ${googleUser.displayName}");

      // Obter o objeto de autenticação do Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Verificar se os tokens de autenticação foram recebidos corretamente
      print("AccessToken: ${googleAuth.accessToken}");
      print("IDToken: ${googleAuth.idToken}");

      // Criar as credenciais do Firebase com o token de autenticação do Google
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Realizar o login com as credenciais no Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Verificar se o usuário foi autenticado corretamente no Firebase
      print("Usuário logado no Firebase: ${userCredential.user?.displayName}");

      // Retornar o usuário autenticado
      return userCredential.user;
    } catch (e) {
      print("Erro ao fazer login com Google: $e");
      return null;
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Mantengo **método** para que coincida con tu app.dart (con paréntesis).
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  /// Login con Google para `google_sign_in: ^7.1.1`
  Future<User?> signInWithGoogle() async {
    final signIn = GoogleSignIn.instance;

    // Si en Android te lo pide, descomenta y pon tu clientId web:
    // await signIn.initialize(serverClientId: 'TU_CLIENT_ID_WEB');

    // Flujo interactivo v7 (reemplaza al antiguo signIn())
    final account = await signIn.authenticate(); // cancelado

    // En v7, el idToken se obtiene así:
    final googleAuth = account.authentication; // trae idToken

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken, // Para Firebase Auth basta el idToken
      // accessToken: (no es necesario para autenticar con Firebase)
    );

    final userCred = await _auth.signInWithCredential(credential);
    return userCred.user;
  }

  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    await _auth.signOut();
  }
}

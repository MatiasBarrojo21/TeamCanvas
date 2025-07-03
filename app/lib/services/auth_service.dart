import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get getCurrentUser =>
      _auth.currentUser; // Añade esto dentro de la clase AuthService

  // Flujo de Login
  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('Login error: ${e.code}');
      throw _authErrorMapper(e.code);
    }
  }

  // Flujo de Registro
  Future<User?> register(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('Register error: ${e.code}');
      throw _authErrorMapper(e.code);
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Escucha cambios de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Mapeador de errores
  String _authErrorMapper(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Correo electrónico inválido';
      case 'user-disabled':
        return 'Usuario deshabilitado';
      case 'user-not-found':
        return 'Usuario no encontrado';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'email-already-in-use':
        return 'El correo ya está en uso';
      case 'operation-not-allowed':
        return 'Operación no permitida';
      case 'weak-password':
        return 'Contraseña demasiado débil';
      default:
        return 'Error desconocido';
    }
  }
}

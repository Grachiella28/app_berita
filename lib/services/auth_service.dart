import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up method
  Future<String?> signUp({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      return 'Please fill all fields.';
    }

    if (password != confirmPassword) {
      return 'Passwords do not match.';
    }

    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return _handleFirebaseError(e);
    } catch (e) {
      return 'An error occurred. Please try again.';
    }
  }

  // 🔐 Sign in method
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      return 'Please enter email and password.';
    }

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return _handleFirebaseError(e);
    } catch (e) {
      return 'Login failed. Please try again.';
    }
  }

  Future<void> sendPasswordReset(String email) async {
  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
}

  // 🔐 Common Firebase error handler
  String _handleFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'User not found.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'Email is already registered.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      default:
        return 'Authentication error: ${e.message}';
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get current user as UserModel
  UserModel? get currentUser {
    final firebaseUser = _auth.currentUser;
    return firebaseUser != null
        ? UserModel.fromFirebaseUser(firebaseUser)
        : null;
  }

  // Stream of auth changes as UserModel
  Stream<UserModel?> get userStream {
    return _auth.authStateChanges().map((User? firebaseUser) {
      if (firebaseUser == null) return null;
      return UserModel.fromFirebaseUser(firebaseUser);
    });
  }

  // Sign in with Google
  Future<UserModel?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with the credential
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) {
        throw FirebaseAuthException(
          code: 'ERROR_USER_NOT_CREATED',
          message: 'Failed to create user account',
        );
      }

      return UserModel.fromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    } on Exception catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    } catch (e) {
      throw Exception('Error signing out: $e');
    }
  }

  Exception _handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'ERROR_ABORTED_BY_USER':
        return Exception('Sign in aborted by user');
      case 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
        return Exception('Account exists with different credentials');
      case 'ERROR_INVALID_CREDENTIAL':
        return Exception('Invalid credentials');
      case 'ERROR_OPERATION_NOT_ALLOWED':
        return Exception('Operation not allowed');
      case 'ERROR_USER_DISABLED':
        return Exception('User has been disabled');
      case 'ERROR_INVALID_VERIFICATION_CODE':
        return Exception('Invalid verification code');
      case 'ERROR_USER_NOT_CREATED':
        return Exception('Failed to create user account');
      case 'network-request-failed':
        return Exception('No internet connection. Please check your network');
      case 'too-many-requests':
        return Exception('Too many attempts. Please try again later');
      default:
        return Exception('An error occurred: ${e.message}');
    }
  }
}

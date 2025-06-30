import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class UserModel {
  final String? uid;
  final String? email;
  final String? displayName;
  final String? photoURL;

  UserModel({this.uid, this.email, this.displayName, this.photoURL});

  factory UserModel.fromFirebaseUser(firebase_auth.User? user) {
    if (user == null) return UserModel();

    return UserModel(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoURL: user.photoURL,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
    };
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, displayName: $displayName, photoURL: $photoURL)';
  }
}

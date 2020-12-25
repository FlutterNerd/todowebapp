import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todowebapp/helper_functions/shared_preferences.dart';
import 'package:todowebapp/services/database.dart';
import 'package:todowebapp/views/home.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get current user
  Future<User> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<User> signInWithGoogle(BuildContext context) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = new GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    UserCredential result =
        await _firebaseAuth.signInWithCredential(credential);
    User userDetails = result.user;

    if (result == null) {
    } else {
      SharedPreferencesHelper().saveUserLoggedIn(true);
      SharedPreferencesHelper().saveUserId(userDetails.uid);

      Map<String, dynamic> userInfoMap = {
        "userEmail": userDetails.email,
        "displayName": userDetails.displayName,
        "userName": userDetails.email.replaceAll("@gmail.com", "")
      };

      print(userInfoMap.toString());

      DatabaseMethods()
          .uploadUserInfo(userDetails.uid, userInfoMap)
          .then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      });
    }

    return userDetails;
  }

  Future signOut() async {
    try {
      return _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}

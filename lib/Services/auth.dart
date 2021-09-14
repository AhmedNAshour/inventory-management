import 'package:firebase_auth/firebase_auth.dart';
import 'package:inventory/Services/database.dart';
import 'package:inventory/Models/user.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> getCurrentUID() async{
    final FirebaseUser user = await _auth.currentUser();
    final String uid = user.uid.toString();
    return uid;
  }
  Future<String> getCurrentEmail() async{
    final FirebaseUser user = await _auth.currentUser();
    final String email = user.email;
    return email;
  }

  // create user obj based on firebase user
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
    //.map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }


  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password, String number,String name) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      await DatabaseService(uid: user.uid).updateUserData(name,number);

      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }


  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:java_shop/models/signed_in_user.dart';
import 'package:java_shop/services/database.dart';

class AuthService{
  ///steps:
  //create a final instance of your firebase Authentication.

  final FirebaseAuth _auth = FirebaseAuth.instance;
  //late User user;
  //crate a user object based on firebase user

  SignedInUser? _userFromFirebaseUser(User? user){
    /// very important to have this function like this.
    return user !=null ? SignedInUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<SignedInUser?> get user{
    return _auth.authStateChanges()
        //longest way to do it
        // .map((User? user) => _userFromFirebaseUser(user!));
    //simplest way to do it
    .map(_userFromFirebaseUser);
  }

  //sign in anonymously
Future  signInAnon() async{
  try{
    UserCredential result = await _auth.signInAnonymously();
    User user = result.user!;
    return _userFromFirebaseUser(user);
  }catch(e){
    debugPrint(e.toString());
    return null;
  }
}
  //sign in with email and password

  Future signInWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);

    }catch(e){
      debugPrint(e.toString());
      return null;
    }
  }

  //register with email and password

  Future registerWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      //cretae a new document for user with UID
      await DatabaseService(uid: user!.uid).updateUserData('0', 'new crew member', 100);
      return _userFromFirebaseUser(user);

    }catch(e){
      debugPrint(e.toString());
      return null;
    }
  }
  //sign out

Future signOut()async{
    try{
      return await _auth.signOut();
    }catch(e){
      debugPrint(e.toString());
      return null;
    }
  }
}
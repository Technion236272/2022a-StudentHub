import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }
enum Error { Email_Already_in_Use, NO_ERROR, Other_Error }

class AuthRepository with ChangeNotifier {
  FirebaseAuth _auth;
  User? _user;
  Status _status = Status.Uninitialized;

  AuthRepository.instance() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onAuthStateChanged);
    _user = _auth.currentUser;
    _onAuthStateChanged(_user);
  }

  Status get status => _status;

  User? get user => _user;

  bool get isAuthenticated => status == Status.Authenticated;

  Future<Error?> signUp(String email, String password, String name,
      String phone_number, String faculty, String Gender) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();

      final new_user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      User? user = new_user.user;
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'Full Name': name,
        'Phone Number': phone_number,
        'Faculty': faculty,
        'Gender': Gender
      });
      user.updateDisplayName(name);
      await user.reload();
      user = await _auth.currentUser;

      await new_user.user!.sendEmailVerification();
      return Error.NO_ERROR;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _status = Status.Unauthenticated;
        notifyListeners();
        return Error.Email_Already_in_Use;
      }
    } catch (e) {
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();
      return Error.Other_Error;
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      final user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (user.user!.emailVerified)
        return true;
      else {
        _status = Status.Unauthenticated;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  String? getName() {
    return _user?.displayName;
  }

  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _user = null;
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;

    }
    notifyListeners();
  }
}

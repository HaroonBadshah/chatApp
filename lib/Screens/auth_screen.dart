import 'package:chat_app/Widgets/auth/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoding = false;

  void _submitAuthForm(String email, String username, String password,
      bool isLogin, BuildContext ctx) async {
    // ignore: unused_local_variable
    FirebaseUser firebaseUser;

    try {
      setState(() {
        _isLoding = true;
      });
      if (isLogin) {
        firebaseUser = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        firebaseUser = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await Firestore.instance
            .collection('users')
            .document(firebaseUser.uid)
            .setData({
          'username': username,
          'email': email,
        });
      }
    } on PlatformException catch (err) {
      var message = 'An error occured, please check credintials!';

      if (err.message != null) {
        message = err.message;
      }
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).errorColor,
      ));

      setState(() {
        _isLoding = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoding = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isLoding),
    );
  }
}

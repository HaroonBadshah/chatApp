import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMassages extends StatefulWidget {
  @override
  _NewMassagesState createState() => _NewMassagesState();
}

class _NewMassagesState extends State<NewMassages> {
  final _controller = new TextEditingController();
  var _enterdMassage = '';

  void _sendMassage() async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser();
    Firestore.instance.collection('chat').add({
      'text': _enterdMassage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Senda a massage...'),
              onChanged: (value) {
                setState(() {
                  _enterdMassage = value;
                });
              },
            ),
          ),
          IconButton(
              color: Theme.of(context).primaryColor,
              icon: Icon(Icons.send),
              onPressed: _enterdMassage.trim().isEmpty ? null : _sendMassage),
        ],
      ),
    );
  }
}

// File: signout_page.dart
import 'package:flutter/material.dart';

class SignOutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Out')),
      body: Center(child: Text('You have been signed out')),
    );
  }
}

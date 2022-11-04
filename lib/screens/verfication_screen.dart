import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/screens/home_screen.dart';

class AccountConfirmation extends StatefulWidget {
  static String routeName = 'AccountConfirmationScreen';

  const AccountConfirmation({Key? key}) : super(key: key);

  @override
  State<AccountConfirmation> createState() => _AccountConfirmationState();
}

class _AccountConfirmationState extends State<AccountConfirmation> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false) {
        timer.cancel();
        // Navigator.pop(context, true);
        Navigator.pushNamed(context, HomeScreen.routeName);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(
            height: 10,
          ),
          Text('Verifying your email'),
        ],
      )),
    );
  }
}

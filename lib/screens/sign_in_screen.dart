// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/provider/sign_in_provider.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/screens/home_screen.dart';
import 'package:quiz_app/screens/verfication_screen.dart';
import 'package:quiz_app/widgets/button.dart';

class SignInScreen extends StatefulWidget {
  static String routeName = 'SignInScreen';

  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  GoogleSignInAccount? _currentUser;
  String _contactText = '';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  @override
  void initState() {
    super.initState();
    _googleSignIn.signOut();

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
        if (account != null) {
          Provider.of<SigninProvider>(context, listen: false)
              .setProfile(account.photoUrl!, account.displayName!);
        }
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        print(account);
      });
      if (_currentUser != null) {
        print('current user is not equal to null');
        print(account);
        if (account != null) {
          Provider.of<SigninProvider>(context, listen: false)
              .setProfile(account.photoUrl!, account.displayName!);
        }
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      }
    });
    _googleSignIn.signInSilently();
  }

  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    print('signing in');
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: const [
          Colors.yellow,
          Colors.orange,
          Colors.deepOrange
        ])),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage(
                        'assets/logo.png',
                      ),
                    )),
                  ),
                  Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage(
                        'assets/quiz.png',
                      ),
                    )),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  isDense: true,
                  hintText: 'Email',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  isDense: true,
                  hintText: 'Password',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                  onPressed: () =>
                      Provider.of<SigninProvider>(context, listen: false)
                          .handleSignInWithEmailandPassword(
                              context, _emailController, _passwordController),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    minimumSize:
                        Size(MediaQuery.of(context).size.width * 0.8, 50),
                  ),
                  child: Text(
                    'SIGN UP',
                    style: TextStyle(color: Colors.white),
                  )),
              SizedBox(height: 60),
              TextButton(
                  onPressed: _handleSignIn,
                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 221, 75, 57),
                    minimumSize:
                        Size(MediaQuery.of(context).size.width * 0.8, 50),
                  ),
                  child: Text(
                    'SIGN IN WITH GOOGLE',
                    style: TextStyle(color: Colors.white),
                  )),
              SizedBox(height: 10),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                    minimumSize:
                        Size(MediaQuery.of(context).size.width * 0.8, 50),
                    side: BorderSide(color: Colors.white, width: 2)),
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Enter Mobile Number'),
                    content: TextField(
                      controller: _phoneController,
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () =>
                            Provider.of<SigninProvider>(context, listen: false)
                                .handlePhoneSignIn(context,
                                    _phoneController.text, _codeController),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ),
                child: const Text(
                  'SIGN IN USING PHONE NUMBER',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

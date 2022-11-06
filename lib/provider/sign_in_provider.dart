import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/screens/home_screen.dart';
import 'package:quiz_app/screens/verfication_screen.dart';

class SigninProvider with ChangeNotifier {
  late String _profilePic;
  late String _resultName;

  setProfile(String profilePic, String profileName) {
    _profilePic = profilePic;
    _resultName = profileName;
  }

  String? get profileName => _resultName;

  ProfileClass getProfile() {
    return ProfileClass(profileName: _resultName, profilePic: _profilePic);
  }

  final CollectionReference collection =
      FirebaseFirestore.instance.collection('user-score');
  Future<DocumentReference> addScore(dynamic score) {
    return collection.add(score);
  }

  Future<List> getData() async {
    print(_resultName);
    QuerySnapshot querySnapshot =
        await collection.where("useId", isEqualTo: _resultName).get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    return allData;
  }

  handlePhoneSignIn(BuildContext context, String phoneNumber,
      TextEditingController codeController) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        _auth.signInWithCredential(credential).then((UserCredential result) {
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        }).catchError((e) {
          print(e);
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      codeSent: (String verificationId, int? forceResendingToken) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
                  title: Text("Enter OTP"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: codeController,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text("Done"),
                      onPressed: () {
                        FirebaseAuth auth = FirebaseAuth.instance;

                        String _smsCode = codeController.text.trim();

                        AuthCredential _credential =
                            PhoneAuthProvider.credential(
                                verificationId: verificationId,
                                smsCode: _smsCode);
                        auth
                            .signInWithCredential(_credential)
                            .then((UserCredential result) {
                          Navigator.pushReplacementNamed(
                              context, HomeScreen.routeName);
                          _resultName = phoneNumber;
                        }).catchError((e) {
                          print(e);
                        });
                      },
                    )
                  ],
                ));
      },
      verificationFailed: (FirebaseAuthException error) {
        print(error.message);
      },
    );
  }

  handleSignInWithEmailandPassword(
      BuildContext context,
      TextEditingController emailController,
      TextEditingController passwordController) async {
    try {
      final UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      Navigator.pushNamed(context, AccountConfirmation.routeName);
      _resultName = emailController.text;

      credential.user?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
}

class ProfileClass {
  final String profilePic;
  final String profileName;
  ProfileClass({
    required this.profilePic,
    required this.profileName,
  });
}

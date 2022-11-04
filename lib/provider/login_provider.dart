import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  late String _profilePic;
  late String _profileName;

  setProfile(String profilePic, String profileName) {
    _profilePic = profilePic;
    _profileName = profileName;
  }

  String? get profileName => _profileName;

  ProfileClass getProfile() {
    return ProfileClass(profileName: _profileName, profilePic: _profilePic);
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

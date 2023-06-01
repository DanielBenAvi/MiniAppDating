import 'dart:async';

import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:social_hive_client/model/boundaries/object_boundary.dart';
import 'package:social_hive_client/model/boundaries/user_boundary.dart';
import 'package:social_hive_client/model/singleton_user.dart';
import 'package:social_hive_client/rest_api/command_api.dart';
import 'package:social_hive_client/rest_api/object_api.dart';
import 'package:social_hive_client/rest_api/user_api.dart';
import 'package:social_hive_client/screens/login/screen_dating_profile_register.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({Key? key}) : super(key: key);

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  final _textFieldEmailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    "Dating",
                    style: TextStyle(
                      color: Colors.pink,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _textFieldEmailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    style: const TextStyle(color: Colors.black),
                    validator: ValidationBuilder().email().maxLength(50).build(),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _login(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: _screenRegister,
                    style: TextButton.styleFrom(foregroundColor: Colors.pink),
                    child: const Text('Register'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    UserBoundary userBoundary =
    await UserApi().getUser(_textFieldEmailController.text);

    SingletonUser singletonUser = SingletonUser.instance;
    singletonUser.email = userBoundary.userId.email;
    singletonUser.username = userBoundary.username;
    singletonUser.avatar = userBoundary.avatar;
    singletonUser.role = userBoundary.role;
    await ObjectApi().getDemoObject();

    ObjectBoundary? userDetails = await CommandApi().getMyUserDetailsByEmail(singletonUser.email!);

    if (userDetails == null) {
      await showPopupMessage(context, "Error login, missing user details");
      _screenRegisterUserDetails();
      return;
    }
    List<ObjectBoundary>? privateDatingProfile =
    await ObjectApi().getChildren(userDetails?.objectId.internalObjectId as String);
    if (privateDatingProfile == null) {
      await showPopupMessage(context, "Error login, missing dating profile");
      return;
    } else if (privateDatingProfile.isEmpty) {
      await showPopupMessage(context, "Error login, missing dating profile");
      _datingProfileScreenState(userDetails);
      return;
    } else if (privateDatingProfile.length == 1) {
      _screenHomeDatingScreenState(userDetails, privateDatingProfile[0]);
    }
  }

  void _screenRegister() {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/screen_user_register');
  }

  void _screenRegisterUserDetails() {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/screen_user_details_register');
  }

  void _screenHomeDatingScreenState(
      ObjectBoundary? userDetails, ObjectBoundary? privateDatingProfile) {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/home_dating');
  }

  void _datingProfileScreenState(ObjectBoundary? userDetails) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DatingProfileScreen(userDetails: userDetails),
      ),
    );
  }

  Future<void> showPopupMessage(BuildContext context, String message) async {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.redAccent,
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    await Future.delayed(const Duration(seconds: 3));
  }

}

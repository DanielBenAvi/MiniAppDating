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
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.pink,
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.pink),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      home: Scaffold(
        body: Container(
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
                      _login();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.pink,
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
        ),
      ),
    );
  }

  Future<void> _login() async {
    UserBoundary userBoundary =
    await UserApi().getUser(_textFieldEmailController.text);

    SingletonUser singletonUser = SingletonUser.instance;
    singletonUser.email = userBoundary.userId.email;
    singletonUser.username = userBoundary.username;
    singletonUser.avatar = userBoundary.avatar;
    singletonUser.role = userBoundary.role;

    ObjectBoundary? userDetails = await CommandApi().getMyUserDetailsByEmail();

    if(userDetails == null){
      _showErrorDialog(context, 'login Failed. missing user details.');
      _screenRegisterUserDetails();
    }
    List<ObjectBoundary>? privateDatingProfile = await ObjectApi().getChildren(userDetails?.objectId as String);
    if(privateDatingProfile == null){
      _showErrorDialog(context, 'login Failed. Please try again.');
    }
    else if(privateDatingProfile.isEmpty){
      _showErrorDialog(context, 'login Failed. missing dating profile.');
      _datingProfileScreenState(userDetails);
    }
    else if(privateDatingProfile.length == 1){
      _screenHomeDatingScreenState();
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

  void _screenHomeDatingScreenState() {
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

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}

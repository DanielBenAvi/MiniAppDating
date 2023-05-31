import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:social_hive_client/model/boundaries/object_boundary.dart';
import 'package:social_hive_client/model/boundaries/user_boundary.dart';
import 'package:social_hive_client/model/singleton_user.dart';
import 'package:social_hive_client/rest_api/command_api.dart';
import 'package:social_hive_client/rest_api/object_api.dart';
import 'package:social_hive_client/rest_api/user_api.dart';

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
            borderSide: BorderSide(color: Colors.pink),
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
                  style: TextStyle(color: Colors.black),
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
                    primary: Colors.pink,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Login'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: _screenRegister,
                  style: TextButton.styleFrom(primary: Colors.pink),
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

    ObjectBoundary? object = await CommandApi().getMyUserDetailsByEmail();

    if(object == null){
      debugPrint("error no userDetails");
      return;
    }
    List<ObjectBoundary>? objects = await ObjectApi().getChildren(object.objectId.internalObjectId);
    if(objects == null){
      debugPrint("error getting child");
    }
    else if(objects.isEmpty){

    }
    else if(objects.length == 1){
      _screenHomeDatingScreenState();
    }


  }

  void _screenRegister() {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/register');
  }

  void _screenHomeDatingScreenState() {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/home_dating');
  }
}

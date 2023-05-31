import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:social_hive_client/constants/roles.dart';
import 'package:social_hive_client/model/singleton_user.dart';
import 'package:social_hive_client/rest_api/user_api.dart';

import '../../constants/preferences.dart';
import '../../model/item_object.dart';
import '../../model/UserDetails.dart';
import '../../widgets/multi_select_dialog.dart';
import 'dating_profile_register.dart';

class ScreenRegister extends StatefulWidget {
  const ScreenRegister({Key? key}) : super(key: key);

  @override
  State<ScreenRegister> createState() => _ScreenRegisterState();
}

class _ScreenRegisterState extends State<ScreenRegister> {
  final _textFieldControllerEmail = TextEditingController();
  final _textFieldControllerUsername = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String _avatarPath =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSw4dcOs0ebrWK3g4phCh7cfF-aOM3rhxnsCQ&usqp=CAU';

  List<ItemObject> _selectedPreferences = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.pink,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.pink, width: 2),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(_avatarPath),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _textFieldControllerEmail,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.pink),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    style: const TextStyle(color: Colors.black),
                    validator: ValidationBuilder().email().maxLength(50).build(),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _textFieldControllerUsername,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    style: const TextStyle(color: Colors.black),
                    validator: ValidationBuilder().minLength(3).maxLength(20).build(),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _imagePicker(context);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.pink,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Choose Avatar'),
                  ),
                  const SizedBox(height: 20),
                  MultiSelect(
                    "Preferences",
                    "Preferences",
                    Preferences().getPreferences(),
                    onMultiSelectConfirm: (List<ItemObject> results) {
                      _selectedPreferences = results;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _continue();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.pink,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Continue'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _continue() {
    SingletonUser singletonUser = _setSingletonUser();
    UserDetails userDetails = _setUserDetailsUser() ;
    // _createUser(singletonUser);
    // _createUserDetails();
    _screenDatingProfile(singletonUser, userDetails);
  }

  void _screenDatingProfile(singletonUser, userDetails) {
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DatingProfileScreen(
          user: singletonUser,
          userDetails: userDetails
        ),
      ),
    );
  }


  Future<void> _imagePicker(BuildContext context) async {
    final result = await Navigator.pushNamed(context, '/image_picker');
    setState(() {
      _avatarPath = (result as String?)!;
    });
    if (!mounted) return;
  }

  SingletonUser _setSingletonUser() {
    SingletonUser singletonUser = SingletonUser.instance;
    singletonUser.email = _textFieldControllerEmail.text;
    singletonUser.username = _textFieldControllerUsername.text;
    singletonUser.role = roles[2];
    singletonUser.avatar = _avatarPath;

    return singletonUser;
  }

  UserDetails _setUserDetailsUser()  {
    List<String> preferences = [];
    for (var element in _selectedPreferences) {
      preferences.add(element.name);
    }

    UserDetails userDetails = UserDetails(preferences: preferences);

    return userDetails;
  }

}

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:social_hive_client/screens/login/screen_dating_profile_register.dart';
import '../../constants/preferences.dart';
import '../../model/UserDetails.dart';
import '../../model/boundaries/object_boundary.dart';
import '../../model/item_object.dart';
import '../../rest_api/user_api.dart';
import '../../widgets/multi_select_dialog.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({Key? key}) : super(key: key);

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final TextEditingController _textFieldControllerName = TextEditingController();
  final TextEditingController _textFieldControllerPhoneNumber = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<ItemObject> _selectedPreferences = [];


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.pink,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(8.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(8.0),
          ),
          labelStyle: const TextStyle(color: Colors.pinkAccent),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'Register extra user details',
              style: TextStyle(color: Colors.white),
            ),
          ),
          backgroundColor: Colors.pink,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: _textFieldControllerName,
                  decoration: const InputDecoration(labelText: 'Name',),
                  style: const TextStyle(color: Colors.black),
                  validator: ValidationBuilder().required().minLength(3).maxLength(30).build(),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _textFieldControllerPhoneNumber,
                  decoration: const InputDecoration(labelText: 'Phone Number',),
                  style: const TextStyle(color: Colors.black),
                  validator: ValidationBuilder().phone().maxLength(50).build(),
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
                    foregroundColor: Colors.white, backgroundColor: Colors.pink,
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
    );
  }

  Future<void> _continue() async {
    ObjectBoundary? userDetails = await _createUserDetails();
    if(userDetails == null){
      _showErrorDialog(context, 'Registration Failed. Please try again.');
      return;
    }
    _datingProfileScreenState(userDetails);
  }

  Future _createUserDetails() async {

    List<String> preferences = [];
    for (var element in _selectedPreferences) {
      preferences.add(element.name);
    }
    UserDetails userDetails = UserDetails();
    userDetails.preferences = preferences;
    userDetails.name = _textFieldControllerName.text;
    userDetails.phoneNum = _textFieldControllerPhoneNumber.text;

    ObjectBoundary? object = await UserApi().postUserDetails(
      userDetails.name as String,
      userDetails.phoneNum as String,
      userDetails.preferences, 10, 11,
    );

    return object;
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

  void _datingProfileScreenState(ObjectBoundary? userDetails) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DatingProfileScreen(userDetails: userDetails),
      ),
    );
  }


}


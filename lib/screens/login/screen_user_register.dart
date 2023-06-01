import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:social_hive_client/constants/roles.dart';
import 'package:social_hive_client/model/singleton_user.dart';
import 'package:social_hive_client/rest_api/user_api.dart';
import '../../model/boundaries/user_boundary.dart';



class ScreenRegister extends StatefulWidget {

  const ScreenRegister({
    Key? key,
  }) : super(key: key);

  @override
  State<ScreenRegister> createState() => _ScreenRegisterState();
}

class _ScreenRegisterState extends State<ScreenRegister> {
  final _textFieldControllerEmail = TextEditingController();
  final _textFieldControllerUsername = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String _avatarPath =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSw4dcOs0ebrWK3g4phCh7cfF-aOM3rhxnsCQ&usqp=CAU';
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  String? downloadURL;

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
          title: const Center( // Center the "Register" title
            child: Text(
              'Register',
              style: TextStyle(color: Colors.white),
            ),
          ),
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
                    const SizedBox(height: 16.0),
                    OutlinedButton(
                        onPressed: _filePicker, child: const Text('Add Image')),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _textFieldControllerEmail,
                      decoration: const InputDecoration(labelText: 'Email',),
                      style: const TextStyle(color: Colors.black),
                      validator: ValidationBuilder().email().maxLength(50).build(),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _textFieldControllerUsername,
                      decoration: const InputDecoration(labelText: 'User name',),
                      style: const TextStyle(color: Colors.black),
                      validator: ValidationBuilder().required().maxLength(50).build(),
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
        ),
      ),
    );
  }



  void _continue() async {
    SingletonUser singletonUser = _setSingletonUser();
    UserBoundary? userBoundary = await _createUser(singletonUser);

    if (userBoundary == null) {
      _showErrorDialog(context, 'Registration Failed. Please try again.');
      return;
    }


    _userDetailsScreenState();
  }


  // void _screenDatingProfile(singletonUser, userDetails) {
  //   Navigator.popUntil(context, (route) => route.isFirst);
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => DatingProfileScreen(
  //           user: singletonUser,
  //           userDetails: userDetails
  //       ),
  //     ),
  //   );
  // }




  SingletonUser _setSingletonUser() {
    SingletonUser singletonUser = SingletonUser.instance;
    singletonUser.email = _textFieldControllerEmail.text;
    singletonUser.username = _textFieldControllerUsername.text;
    singletonUser.role = roles[2];
    singletonUser.avatar = _avatarPath;

    return singletonUser;
  }

  Future <UserBoundary?>_createUser(SingletonUser singletonUser) async {
    Map<String, dynamic> user = {
      'email': singletonUser.email,
      'username': singletonUser.username,
      'role': singletonUser.role,
      'avatar': singletonUser.avatar,
    };

    return await UserApi().postUser(user);
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

  void _userDetailsScreenState() {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/screen_user_details_register');
  }

  Future _filePicker() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
    Uint8List? uploadFile = result.files.single.bytes;
    final path = 'files/${pickedFile!.name}';

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putData(uploadFile!);
    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    setState(() {
      downloadURL = urlDownload;
      _avatarPath = urlDownload; // Update the avatar path with the new image URL
    });
    debugPrint('Download-Link: $urlDownload');
  }

}



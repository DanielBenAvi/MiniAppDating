import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:social_hive_client/model/PrivateDatingProfile.dart';
import 'package:social_hive_client/model/singleton_user.dart';
import 'dart:io';
import '../../constants/Gender.dart';
import '../../model/PublicDatingProfile.dart';
import '../../model/boundaries/object_boundary.dart';
import '../../rest_api/object_api.dart';

class DatingProfileScreen extends StatefulWidget {
  final ObjectBoundary? userDetails;


  const DatingProfileScreen({
    Key? key,
    required this.userDetails,
  }) : super(key: key);

  @override
  _DatingProfileScreenState createState() => _DatingProfileScreenState();
}

class _DatingProfileScreenState extends State<DatingProfileScreen> {

  final TextEditingController _bioController = TextEditingController();
  Gender? _selectedGender;
  String? _stringSelectedGender;
  final List<Gender> _selectedSexualPreference = [];
  final List<String> _stringSelectedSexualPrefrences = [];
  DateTime? _selectedDateOfBirth;
  RangeValues _ageRangeValues = const RangeValues(18, 40);
  final _formKey = GlobalKey<FormState>();



  int calculateAge(DateTime dateOfBirth) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - dateOfBirth.year;

    if (currentDate.month < dateOfBirth.month ||
        (currentDate.month == dateOfBirth.month && currentDate.day < dateOfBirth.day)) {
      age--;
    }

    return age;
  }


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
          title: const Text('Register Dating Profile'),
          backgroundColor: Colors.pink,
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _bioController,
                  decoration: const InputDecoration(labelText: 'Bio'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your bio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Date of Birth:',
                  style: TextStyle(fontSize: 16.0, color: Colors.pinkAccent),
                ),
                const SizedBox(height: 8.0),
                InkWell(
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    ).then((selectedDate) {
                      if (selectedDate != null) {
                        int age = calculateAge(selectedDate);
                        if (age >= 18) {
                          setState(() {
                            _selectedDateOfBirth = selectedDate;
                          });
                        } else {
                          // Show an error message or handle the case when the selected date is not valid.
                          // For example, you can display a SnackBar with an error message:
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('You must be at least 18 years old.'),
                            ),
                          );
                        }
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      _selectedDateOfBirth != null
                          ? '${_selectedDateOfBirth!.day}/${_selectedDateOfBirth!.month}/${_selectedDateOfBirth!.year}'
                          : 'Select Date of Birth',
                    ),
                  ),
                ),

                const SizedBox(height: 16.0),
                Text(
                  'Age Range: ${_ageRangeValues.start.toInt()} - ${_ageRangeValues.end.toInt()}',
                  style: const TextStyle(fontSize: 16.0, color: Colors.pinkAccent),
                ),
                const SizedBox(height: 8.0),
                RangeSlider(
                  values: _ageRangeValues,
                  min: 18,
                  max: 100,
                  divisions: 82,
                  labels: RangeLabels(
                    _ageRangeValues.start.toInt().toString(),
                    _ageRangeValues.end.toInt().toString(),
                  ),
                  onChanged: (values) {
                    setState(() {
                      _ageRangeValues = values;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Gender:',
                  style: TextStyle(fontSize: 16.0, color: Colors.pinkAccent),
                ),
                const SizedBox(height: 8.0),
                DropdownButtonFormField<Gender>(
                  value: _selectedGender,
                  onChanged: (Gender? newValue) {
                    setState(() {
                      _selectedGender = newValue;
                      _stringSelectedGender = _selectedGender?.toString().split('.').last.toUpperCase() ?? '';
                    });
                  },
                  items: Gender.values.map<DropdownMenuItem<Gender>>((Gender value) {
                    return DropdownMenuItem<Gender>(
                      value: value,
                      child: Text(
                        value.toString().split('.').last,
                      ),
                    );
                  }).toList(),
                  decoration: const InputDecoration(labelText: 'Gender'),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select your gender';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Sexual Preference:',
                  style: TextStyle(fontSize: 16.0, color: Colors.pinkAccent),
                ),
                const SizedBox(height: 8.0),
                Wrap(
                  children: Gender.values.map((gender) {
                    return Container(
                      margin: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        backgroundColor: _selectedSexualPreference.contains(gender)
                            ? Colors.pink
                            : Colors.transparent,
                        label: Text(
                          gender.toString().split('.').last,
                          style: TextStyle(
                            color: _selectedSexualPreference.contains(gender)
                                ? Colors.white
                                : Colors.pink,
                          ),
                        ),
                        selected: _selectedSexualPreference.contains(gender),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              _selectedSexualPreference.add(gender);
                              _stringSelectedSexualPrefrences.add(gender.toString().split('.').last.toUpperCase());
                            } else {
                              _selectedSexualPreference.remove(gender);
                              _stringSelectedSexualPrefrences.remove(gender.toString().split('.').last);
                            }
                          });
                        },
                        selectedColor: Colors.pink[100],
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _registerDatingProfile,
                  child: const Text('Register'),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _registerDatingProfile() async {
    if (_formKey.currentState!.validate()) {
      List<String> picture =[SingletonUser.instance.avatar!];
      PublicDatingProfile publicDP = PublicDatingProfile(
        nickName: widget.userDetails?.objectDetails['name'],
        gender: _stringSelectedGender,
        age: calculateAge(_selectedDateOfBirth!),
        bio: _bioController.text,
        pictures: picture,
      );

      PrivateDatingProfile privateDP = PrivateDatingProfile(
        dateOfBirthday: _selectedDateOfBirth,
        distanceRange: 100,
        publicProfile: publicDP,
        maxAge: _ageRangeValues.end.toInt(),
        minAge: _ageRangeValues.start.toInt(),
        phoneNumber: widget.userDetails?.objectDetails['phoneNum'],
        genderPreferences: _stringSelectedSexualPrefrences,
      );
      ObjectBoundary? privateDatingProfile = await _createPrivateDatingProfile(privateDP);
      if (privateDatingProfile == null) {
        _showErrorDialog(context, 'Registration Failed. Please try again.');
        return;
      }

      String? internalObjectId = widget.userDetails?.objectId?.internalObjectId;
      ObjectApi().addChild(internalObjectId!, privateDatingProfile.objectId) ;

      _screenLogin();
    }
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






  Future _createPrivateDatingProfile(PrivateDatingProfile privateDP) async {
    Map<String, dynamic> mapPrivateDatingProfile = privateDP.privateDatingProfileToMap();
    ObjectBoundary? object = await ObjectApi().
    postPrivateDatingProfile(mapPrivateDatingProfile,10 ,10);

    return object;
  }

  void _screenLogin() {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/login');
  }

}



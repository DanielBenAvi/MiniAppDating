import 'package:flutter/material.dart';
import 'package:social_hive_client/model/PrivateDatingProfile.dart';
import 'package:social_hive_client/model/UserDetails.dart';
import 'package:social_hive_client/model/singleton_user.dart';
import 'dart:io';
import '../../constants/Gender.dart';
import '../../model/PublicDatingProfile.dart';
import '../../model/boundaries/object_boundary.dart';
import '../../rest_api/user_api.dart';

class DatingProfileScreen extends StatefulWidget {
  final SingletonUser user;
  final UserDetails userDetails;


  const DatingProfileScreen({
    Key? key,
    required this.user,
    required this.userDetails,
  }) : super(key: key);

  @override
  _DatingProfileScreenState createState() => _DatingProfileScreenState();
}

class _DatingProfileScreenState extends State<DatingProfileScreen> {

  final TextEditingController _bioController = TextEditingController();
  Gender? _selectedGender;
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final List<Gender> _selectedSexualPreference = [];
  DateTime? _selectedDateOfBirth;
  File? _selectedImage;
  RangeValues _ageRangeValues = const RangeValues(18, 40);
  RangeValues _distanceRangeValues = const RangeValues(0, 100);
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
          backgroundColor: Colors.pink[200],
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
                        setState(() {
                          _selectedDateOfBirth = selectedDate;
                        });
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
                    });
                  },
                  items: Gender.values.map<DropdownMenuItem<Gender>>((Gender value) {
                    return DropdownMenuItem<Gender>(
                      value: value,
                      child: Text(
                        value.toString().substring(value.toString().indexOf('.') + 1),
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
                            } else {
                              _selectedSexualPreference.remove(gender);
                            }
                          });
                        },
                        selectedColor: Colors.pink[100],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Distance Preference: ${_distanceRangeValues.end.toInt()} km',
                  style: const TextStyle(fontSize: 16.0, color: Colors.pinkAccent),
                ),
                const SizedBox(height: 8.0),
                Slider(
                  value: _distanceRangeValues.end,
                  min: 0,
                  max: 100,
                  divisions: 100,
                  label: _distanceRangeValues.end.toInt().toString(),
                  onChanged: (value) {
                    setState(() {
                      _distanceRangeValues = RangeValues(value, value);
                    });
                  },
                ),
                TextFormField(
                  controller: _latitudeController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Latitude'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter latitude';
                    }
                    final double? latitude = double.tryParse(value);
                    if (latitude == null || latitude < -180 || latitude > 180) {
                      return 'Please enter a valid latitude between -180 and 180';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _longitudeController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Longitude'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter longitude';
                    }
                    final double? longitude = double.tryParse(value);
                    if (longitude == null || longitude < -180 || longitude > 180) {
                      return 'Please enter a valid longitude between -180 and 180';
                    }
                    return null;
                  },
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

  void _registerDatingProfile() {
    if (_formKey.currentState!.validate()) {
      PublicDatingProfile publicDP = PublicDatingProfile(nickName: widget.userDetails.name, gender: _selectedGender,
          age: calculateAge(_selectedDateOfBirth!), bio: _bioController.text);

      PrivateDatingProfile privateDP = PrivateDatingProfile(dateOfBirthday:_selectedDateOfBirth,
          distanceRange: _distanceRangeValues.end.toInt(), publicProfile: publicDP,
          maxAge: _ageRangeValues.end.toInt(), minAge: _ageRangeValues.start.toInt(), phoneNumber: widget.userDetails.phoneNum,
          genderPreferences: _selectedSexualPreference);

      print(_createUser(widget.user));
      //todo: fix this so it will get object boundary and not list
      print(_createUserDetails());
      print(privateDP.toString());

    }
  }

  Future _createUser(SingletonUser singletonUser) async {
    print(singletonUser.toString());

    Map<String, dynamic> user = {
      'email': singletonUser.email,
      'username': singletonUser.username,
      'role': singletonUser.role,
      'avatar': singletonUser.avatar,
    };

    await UserApi().postUser(user);
  }

  Future _createUserDetails() async {

    ObjectBoundary? object = await UserApi().postUserDetails(
        widget.userDetails.name as String,
        widget.userDetails.phoneNum as String,
        widget.userDetails.preferences,
        double.parse(_latitudeController.text)
        , double.parse(_longitudeController.text)
    );

    return object;
  }
}

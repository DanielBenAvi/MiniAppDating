import 'package:flutter/material.dart';
import 'dart:io';
import '../../constants/Gender.dart';

class DatingProfileScreen extends StatefulWidget {
  const DatingProfileScreen({Key? key}) : super(key: key);

  @override
  _DatingProfileScreenState createState() => _DatingProfileScreenState();
}

class _DatingProfileScreenState extends State<DatingProfileScreen> {
  TextEditingController _bioController = TextEditingController();
  TextEditingController _distancePreferenceController = TextEditingController();

  Gender? _selectedGender;
  List<Gender> _selectedSexualPreference = [];
  DateTime? _selectedDateOfBirth;
  File? _selectedImage;

  RangeValues _ageRangeValues = const RangeValues(18, 40);
  RangeValues _distanceRangeValues = const RangeValues(0, 100);

  final _formKey = GlobalKey<FormState>();

  void _registerDatingProfile() {
    if (_formKey.currentState!.validate()) {
      final String bio = _bioController.text;
      final double distancePreference = _distanceRangeValues.end;
      final List<Gender> sexualPreferences = _selectedSexualPreference;

      print('Bio: $bio');
      print('Distance Preference: $distancePreference');
      print('Age Range: ${_ageRangeValues.start.toInt()} - ${_ageRangeValues.end.toInt()}');
      print('Gender Preferences: $sexualPreferences');
      print('Profile Picture: ${_selectedImage?.path}');
    }
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
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(8.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(8.0),
          ),
          labelStyle: TextStyle(color: Colors.pinkAccent),
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
                Text(
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
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
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
                  style: TextStyle(fontSize: 16.0, color: Colors.pinkAccent),
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
                Text(
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
                Text(
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
                  style: TextStyle(fontSize: 16.0, color: Colors.pinkAccent),
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
}

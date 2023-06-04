import 'package:flutter/material.dart';
import '../model/boundaries/object_boundary.dart';

class ScreenProfileScreen extends StatefulWidget {
  final ObjectBoundary? userDetails;
  final ObjectBoundary? privateDatingProfile;

  const ScreenProfileScreen({
    Key? key,
    this.userDetails,
    this.privateDatingProfile,
  }) : super(key: key);

  @override
  _ScreenProfileScreenState createState() => _ScreenProfileScreenState();
}

class _ScreenProfileScreenState extends State<ScreenProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? publicProfile =
    widget.privateDatingProfile?.objectDetails['publicProfile'];
    final String? nickname = publicProfile?['nickName'];
    final String? bio = publicProfile?['bio'];
    final int? age = publicProfile?['age'];
    final String? gender = publicProfile?['gender'];
    final String? phoneNumber =
    widget.privateDatingProfile?.objectDetails['phoneNumber'];
    final String? profilePicture = publicProfile?['pictures']?.first ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 100,
                backgroundImage: NetworkImage(profilePicture ?? ''),
              ),
              SizedBox(height: 16),
              Text(
                'Name: $nickname',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Age: $age',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Gender: $gender',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Bio: $bio',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Phone Number: $phoneNumber',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

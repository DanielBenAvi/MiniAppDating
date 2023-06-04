
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_hive_client/screens/home_dating.dart';

import '../model/boundaries/object_boundary.dart';
import '../model/singleton_user.dart';
import '../rest_api/command_api.dart';
import '../rest_api/object_api.dart';
import 'check_matches.dart';

class ScreenLikes extends StatefulWidget {
  final ObjectBoundary? userDetails;

  const ScreenLikes({
    Key? key,
    this.userDetails,
  }) : super(key: key);


  @override
  _ScreenLikes createState() => _ScreenLikes();
}


class _ScreenLikes extends State<ScreenLikes> {
  List<ObjectBoundary?> likedProfiles = [];
  List<String?> matchesIds= [];
  int pageNum = 0;
  ObjectBoundary? privateDatingProfile;

  @override
  void initState() {
    super.initState();
    fetchLikes();
  }

  Future<void> fetchLikes() async {

    List<ObjectBoundary>? objects =
    await ObjectApi().getChildren(widget.userDetails?.objectId.internalObjectId as String);
    if(objects == null) {
      await showPopupMessage(context, "Error", false);
      _loginScreen(context);
    }
    privateDatingProfile = objects?[0];

    List<ObjectBoundary?>? likes = await CommandApi().getLikes(
      SingletonUser.instance.email,
      widget.userDetails,
      privateDatingProfile,
      pageNum,
    );
    if (likes == null) {
      await showPopupMessage(context, "Error getting liked dating porifles", false);
      _loginScreen(context);
    } else if (likes.isEmpty) {
      await showPopupMessage(context, "No liked profile", false);
    }
    setState(() {
      likedProfiles = likes ?? [];
    });
  }

  Future<void> fetchMoreLikes() async {
    pageNum++;
    List <ObjectBoundary?>? newLikes = await CommandApi().getLikes(
      SingletonUser.instance.email,
      widget.userDetails,
      privateDatingProfile,
      pageNum,
    );
    if (newLikes == null) {
      await showPopupMessage(context, "Error Matches", false);
      pageNum--;
    } else {
      setState(() {
        likedProfiles.addAll(newLikes);
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Profiles'),
        centerTitle: true,
        backgroundColor: Colors.pink,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: likedProfiles.length,
                itemBuilder: (context, index) {
                  ObjectBoundary? likedProfile = likedProfiles[index];
                  Map<String, dynamic>? publicProfile = likedProfile?.objectDetails['publicProfile'];
                  String? profilePicture = publicProfile?['pictures']?.first ?? '';
                  String? nickname = publicProfile?['nickName'];
                  String? bio = publicProfile?['bio'];
                  int? age = publicProfile?['age'];
                  String? gender = publicProfile?['gender'];
                  String? phoneNumber = likedProfile?.objectDetails['phoneNumber'];

                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 48,
                            backgroundImage: NetworkImage(profilePicture ?? ''),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildProfileAttributeLabel('Name'),
                                Text(
                                  nickname ?? '',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildProfileAttributeLabel('Age & Gender'),
                                Text(
                                  '$age years old, $gender'.toLowerCase(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                _buildProfileAttributeLabel('Bio'),
                                Text(
                                  bio ?? '',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                _buildProfileAttributeLabel('Phone Number'),
                                Text(
                                  phoneNumber ?? '',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchMoreLikes,
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildProfileAttributeLabel(String label) {
    return Text(
      '$label:',
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    );
  }

  void _loginScreen(BuildContext context) {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/login');
  }

  Future<void> showPopupMessage(BuildContext context, String message, bool green) async {
    if(green){
      final snackBar = SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.greenAccent,
        duration: const Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    else{
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
    }

    await Future.delayed(const Duration(seconds: 3));
  }
}

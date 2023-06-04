import 'package:flutter/material.dart';
import 'package:social_hive_client/rest_api/object_api.dart';

import '../model/boundaries/object_boundary.dart';
import '../model/singleton_user.dart';
import '../rest_api/command_api.dart';

class CheckMatchesScreen extends StatefulWidget {
  final ObjectBoundary? userDetails;

  const CheckMatchesScreen({
    Key? key,
    this.userDetails,
  }) : super(key: key);


  @override
  _CheckMatchesScreen createState() => _CheckMatchesScreen();
}


class _CheckMatchesScreen extends State<CheckMatchesScreen> {
  List<ObjectBoundary?> matchesProfiles = [];
  List<String?> matchesIds= [];
  int pageNum = 0;
  ObjectBoundary? privateDatingProfile;

  @override
  void initState() {
    super.initState();
    fetchMatches();
  }

  Future<void> fetchMatches() async {
    List<ObjectBoundary>? objects =
    await ObjectApi().getChildren(widget.userDetails?.objectId.internalObjectId as String);
    if(objects == null) {
      await showPopupMessage(context, "Error", false);
      _loginScreen(context);
    }
    privateDatingProfile = objects?[0];

    MatchResult? matches = await CommandApi().getMatches(
      SingletonUser.instance.email,
      privateDatingProfile,
      pageNum,
    );
    if (matches == null) {
      await showPopupMessage(context, "Error gettingMatches", false);
      _loginScreen(context);
    } else if (matches.matchesProfile.isEmpty) {
      await showPopupMessage(context, "No Matches", false);
    }
    setState(() {
      matchesProfiles = matches?.matchesProfile ?? [];
      matchesIds= matches?.matches ?? [];
    });
  }

  Future<void> fetchMoreMatches() async {
    pageNum++;
    MatchResult? newMatches= await CommandApi().getMatches(
      SingletonUser.instance.email,
      privateDatingProfile,
      pageNum,
    );
    if (newMatches == null) {
      await showPopupMessage(context, "Error Matches", false);
      pageNum--;
    } else {
      setState(() {
        matchesProfiles.addAll(newMatches.matchesProfile);
        matchesIds.addAll(newMatches.matches);
        debugPrint('matchesIds.toString()');
        debugPrint(matchesIds.toString());
      });
    }
  }

  Future<void> unMatch(ObjectBoundary? targetDatingProfile, String? matchId) async {
    Map<String, dynamic>? publicProfile = targetDatingProfile?.objectDetails['publicProfile'];
    String? nickname = publicProfile?['nickName'];

    bool? responseStatus = await CommandApi().unMatch(targetDatingProfile, matchId,
        SingletonUser.instance.email);
    if(responseStatus == null){
      await showPopupMessage(context, "Error unMatching", false);
    }
    else if(responseStatus == false){
      await showPopupMessage(context, "Failed unMatch", false);
    }
    else if(responseStatus == true){
      await showPopupMessage(context, "Dating profile $nickname unmatched", true);
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matches'),
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
                itemCount: matchesProfiles.length,
                itemBuilder: (context, index) {
                  ObjectBoundary? matchesProfile = matchesProfiles[index];
                  String? matchId = matchesIds[index];
                  Map<String, dynamic>? publicProfile = matchesProfile?.objectDetails['publicProfile'];
                  String? profilePicture = publicProfile?['pictures']?.first ?? '';
                  String? nickname = publicProfile?['nickName'];
                  String? bio = publicProfile?['bio'];
                  int? age = publicProfile?['age'];
                  String? gender = publicProfile?['gender'];
                  String? phoneNumber = matchesProfile?.objectDetails['phoneNumber'];

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
                          IconButton(
                            icon: const Icon(Icons.heart_broken),
                            onPressed: () {
                              unMatch(matchesProfile, matchId); // Pass the selected profile and matchId
                            },
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
        onPressed: fetchMoreMatches,
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

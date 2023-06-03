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
  List<ObjectBoundary?> potentialDates = [];
  int pageNum = 0;
  ObjectBoundary? privateDatingProfile;

  @override
  void initState() {
    super.initState();
    fetchMatches();
  }

  Future<void> fetchMatches() async {
    debugPrint("here");
    debugPrint(widget.userDetails?.objectId.internalObjectId);
    debugPrint(widget.userDetails.toString());
    List<ObjectBoundary>? objects =
    await ObjectApi().getChildren(widget.userDetails?.objectId.internalObjectId as String);
    if(objects == null) {
      await showPopupMessage(context, "Error", false);
      _loginScreen(context);
    }
    privateDatingProfile = objects?[0];

    List<ObjectBoundary?>? matches = await CommandApi().getMatches(
      SingletonUser.instance.email,
      privateDatingProfile,
      pageNum,
    );
    if (matches == null) {
      await showPopupMessage(context, "Error gettingMatches", false);
      _loginScreen(context);
    } else if (matches.isEmpty) {
      await showPopupMessage(context, "No Matches", false);
    }
    setState(() {
      potentialDates = matches ?? [];
    });
  }

  Future<void> fetchMoreMatches() async {
    pageNum++;
    List<ObjectBoundary?>? newMatches= await CommandApi().getMatches(
      SingletonUser.instance.email,
      privateDatingProfile,
      pageNum,
    );
    if (newMatches == null) {
      await showPopupMessage(context, "Error Matches", false);
      pageNum--;
    } else {
      setState(() {
        potentialDates.addAll(newMatches);
      });
    }
  }

  Future<void> unMatch(ObjectBoundary? targetDatingProfile) async {
    Map<String, dynamic>? publicProfile = targetDatingProfile?.objectDetails['publicProfile'];
    String? nickname = publicProfile?['nickName'];

    bool? responseStatus = await CommandApi().likeDatingProfile(privateDatingProfile, targetDatingProfile,
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

  void navigateToMatchesScreen(BuildContext context) {
    Navigator.pushNamed(context, '/check_matches');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckMatchesScreen(userDetails: widget.userDetails),
      ),
    );
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                SingletonUser.instance.username ?? '',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                SingletonUser.instance.email ?? '',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                  SingletonUser.instance.avatar ?? 'https://picsum.photos/200',
                ),
                backgroundColor: Colors.transparent,
                radius: 60,
              ),
              decoration: const BoxDecoration(
                color: Colors.pink,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(
                'Edit Profile',
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/edit_profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text(
                'Matches',
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {
                navigateToMatchesScreen(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                'Logout',
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {
                _loginScreen(context);
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: potentialDates.length,
                itemBuilder: (context, index) {
                  ObjectBoundary? potentialDate = potentialDates[index];
                  Map<String, dynamic>? publicProfile =
                  potentialDate?.objectDetails['publicProfile'];
                  String? profilePicture =
                      publicProfile?['pictures']?.first ?? '';
                  String? nickname = publicProfile?['nickName'];
                  String? bio = publicProfile?['bio'];
                  int? age = publicProfile?['age'];
                  String? gender = publicProfile?['gender'];

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
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.heart_broken),
                            onPressed: () {
                              unMatch(potentialDate); // Pass the selected profile
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

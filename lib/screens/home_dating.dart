import 'package:flutter/material.dart';
import 'package:social_hive_client/model/singleton_user.dart';
import '../model/boundaries/object_boundary.dart';
import '../rest_api/command_api.dart';
import 'check_matches.dart';

class HomeDatingScreen extends StatefulWidget {
  final ObjectBoundary? userDetails;
  final ObjectBoundary? privateDatingProfile;

  const HomeDatingScreen({
    Key? key,
    this.userDetails,
    this.privateDatingProfile,
  }) : super(key: key);

  @override
  _HomeDatingScreenState createState() => _HomeDatingScreenState();
}

class _HomeDatingScreenState extends State<HomeDatingScreen> {
  List<ObjectBoundary?> potentialDates = [];
  int pageNum = 0;
  late List<String> likes;

  @override
  void initState() {
    super.initState();
    fetchPotentialDates();
    likes = widget.privateDatingProfile!.objectDetails['likes'].
    toString().replaceAll('[', '').replaceAll(']', '').split(',').map((e) => e.trim()).toList();
  }

  Future<void> fetchPotentialDates() async {
    List<ObjectBoundary?>? dates = await CommandApi().getPotentialDates(
      SingletonUser.instance.email,
      widget.userDetails,
      widget.privateDatingProfile,
      pageNum,
    );
    if (dates == null) {
      await showPopupMessage(context, "Error getting potential dates", false);
      _loginScreen(context);
    } else if (dates.isEmpty) {
      await showPopupMessage(context, "No potential dates", false);
    }
    setState(() {
      potentialDates = dates ?? [];
    });
  }

  Future<void> fetchMorePotentialDates() async {
    pageNum++;
    List<ObjectBoundary?>? newDates = await CommandApi().getPotentialDates(
      SingletonUser.instance.email,
      widget.userDetails,
      widget.privateDatingProfile,
      pageNum,
    );
    if (newDates == null) {
      await showPopupMessage(context, "Error getting potential dates", false);
      pageNum--;
    } else {
      setState(() {
        potentialDates.addAll(newDates);
      });
    }
  }

  Future<void> likeProfile(ObjectBoundary? targetDatingProfile) async {
    Map<String, dynamic>? publicProfile = targetDatingProfile?.objectDetails['publicProfile'];
    String? nickname = publicProfile?['nickName'];

    bool? responseStatus = await CommandApi().likeDatingProfile(widget.privateDatingProfile, targetDatingProfile,
        SingletonUser.instance.email);
    if(responseStatus == null){
      await showPopupMessage(context, "Error liking dating profile", false);
    }
    else if(responseStatus == false){
      await showPopupMessage(context, "Failed to like dating profile", false);
    }
    else if(responseStatus == true){
      await showPopupMessage(context, "Dating profile $nickname engaged", true);
    }

  }

  void navigateToMatchesScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckMatchesScreen(userDetails: widget.userDetails,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Potential Dates'),
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
                            icon: likes.contains('${potentialDate!.objectId.superapp}_${potentialDate.objectId.internalObjectId}')?
                            const Icon(Icons.favorite):const Icon(Icons.favorite_border),
                            onPressed: () {
                              likeProfile(potentialDate); // Pass
                              setState(() {
                                String id = '${potentialDate!.objectId.superapp}_${potentialDate.objectId.internalObjectId}';
                                if(!likes.contains(id)){
                                  likes.add(id);
                                }

                              });
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
        onPressed: fetchMorePotentialDates,
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

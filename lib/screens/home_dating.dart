import 'package:flutter/material.dart';
import 'package:social_hive_client/model/singleton_user.dart';
import '../model/boundaries/object_boundary.dart';
import '../rest_api/command_api.dart';

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

  @override
  void initState() {
    super.initState();
    fetchPotentialDates();
  }

  Future<void> fetchPotentialDates() async {
    int pageNum = 0;
    List<ObjectBoundary?>? dates = await CommandApi().getPotentialDates(
      SingletonUser.instance.email,
      widget.userDetails,
      widget.privateDatingProfile,
      pageNum,
    );
    if (dates == null) {
      await showPopupMessage(context, "Error getting potential dates");
      _loginScreen(context);
    } else if (dates.isEmpty) {
      await showPopupMessage(context, "No potential dates");
    }
    setState(() {
      potentialDates = dates ?? [];
    });
  }

  void likeProfile(int index) {
    // Perform the like action for the profile at the given index
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Dating'),
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
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                SingletonUser.instance.email ?? '',
                style: TextStyle(
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Center(
                child: Text(
                  'Potential Dates',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: potentialDates.length,
                itemBuilder: (context, index) {
                  ObjectBoundary? potentialDate = potentialDates[index];
                  Map<String, dynamic>? publicProfile =
                  potentialDate?.objectDetails?['publicProfile'];
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
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildProfileAttributeLabel('Age & Gender'),
                                Text(
                                  '$age years old, $gender',
                                  style: TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                _buildProfileAttributeLabel('Bio'),
                                Text(
                                  bio ?? '',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.favorite_border),
                            onPressed: () {
                              likeProfile(index);
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
    );
  }

  Widget _buildProfileAttributeLabel(String label) {
    return Text(
      '$label:',
      style: TextStyle(
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

  Future<void> showPopupMessage(BuildContext context, String message) async {
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

    await Future.delayed(const Duration(seconds: 3));
  }
}

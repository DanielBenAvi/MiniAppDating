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
    List<ObjectBoundary?>? potentialDates = await CommandApi().getPotentialDates(SingletonUser.instance.email,
        widget.userDetails, widget.privateDatingProfile);
    if(potentialDates == null){
      await showPopupMessage(context, "Error getting potential dates");
      _loginScreen(context);
    }
    else if(potentialDates.isEmpty){
      await showPopupMessage(context, "no potential dates");
    }
    potentialDates?.forEach((object) {
      debugPrint(object.toString());
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Dating Screen'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        backgroundColor: Colors.pink,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(SingletonUser.instance.username ?? ''),
              accountEmail: Text(SingletonUser.instance.email ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    SingletonUser.instance.avatar ?? 'https://picsum.photos/200'),
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.black,
                radius: 30,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.pink,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Edit Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/edit_profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                _loginScreen(context);
              },
            ),
          ],
        ),
      ),
      body: const SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [],
        ),
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

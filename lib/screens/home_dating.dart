import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:social_hive_client/model/boundaries/user_boundary.dart';
import 'package:social_hive_client/model/singleton_user.dart';
import 'package:social_hive_client/rest_api/user_api.dart';

import '../model/boundaries/object_boundary.dart';

class HomeDatingScreen extends StatefulWidget {
  final ObjectBoundary? userDetails;
  final ObjectBoundary? privateDatingProfile;

  const HomeDatingScreen({
    Key? key,
    this.userDetails, this.privateDatingProfile,
  }) : super(key: key);

  @override
  _HomeDatingScreenState createState() => _HomeDatingScreenState();
}

class _HomeDatingScreenState extends State<HomeDatingScreen> {
  SingletonUser? singletonUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    singletonUser = ModalRoute.of(context)!.settings.arguments as SingletonUser?;
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
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(singletonUser?.username ?? ''),
              accountEmail: Text(singletonUser?.email ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(singletonUser?.avatar ?? 'https://picsum.photos/200'),
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32.0),
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(singletonUser?.avatar ?? 'https://picsum.photos/200'),
                    backgroundColor: Colors.transparent,
                    radius: 60.0,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    singletonUser?.username ?? '',
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    singletonUser?.details ?? 'i like long walks on the beach',
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),

    );
  }

  void _loginScreen(BuildContext context) {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/login');
  }
}

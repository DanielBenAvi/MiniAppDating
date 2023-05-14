import 'package:flutter/material.dart';
import 'package:social_hive_client/screens/choose_location_screen.dart';
import 'package:social_hive_client/screens/home_dating.dart';
import 'package:social_hive_client/screens/login/login.dart';
import 'package:social_hive_client/screens/login/page_user_details.dart';
import 'package:social_hive_client/screens/login/register.dart';
import 'package:social_hive_client/screens/profile.dart';
import 'package:social_hive_client/widgets/image_picker.dart';
import 'package:social_hive_client/screens/edit_profile.dart';
import 'package:social_hive_client/screens/check_likes.dart';
import 'package:social_hive_client/screens/add_likes.dart';
import 'package:social_hive_client/screens/check_matches.dart';



void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false, // Add this li
  initialRoute: '/login',
  routes: {
    '/login': (context) => const Login(),
    '/register': (context) => const Register(),
    '/user_details': (context) => const UserDetailsScreen(),
    '/profile': (context) => const ProfileScreen(),
    '/image_picker': (context) => const ImagePickerScreen(),
    '/home_dating': (context) => const HomeDatingScreen(),
    '/choose_location': (context) => const ChooseLocationScreen(),
    '/edit_profile': (context) => const ChangeProfileScreen(),
    '/check_likes': (context) => const CheckLikesScreen(),
    '/add_likes': (context) => const AddLikesScreen(),
    '/check_matches': (context) => const CheckMatchesScreen(),

  },
));




import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:social_hive_client/screens/choose_location_screen.dart';
import 'package:social_hive_client/screens/home_dating.dart';
import 'package:social_hive_client/screens/login/screen_dating_profile_register.dart';
import 'package:social_hive_client/screens/login/login.dart';
import 'package:social_hive_client/screens/login/screen_user_register.dart';
import 'package:social_hive_client/screens/login/screen_user_details_register.dart';
import 'package:social_hive_client/screens/profile.dart';
import 'package:social_hive_client/widgets/image_picker.dart';
import 'package:social_hive_client/screens/edit_profile.dart';
import 'package:social_hive_client/screens/check_likes.dart';
import 'package:social_hive_client/screens/add_likes.dart';
import 'package:social_hive_client/screens/check_matches.dart';
import 'firebase_options.dart';




void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(

    debugShowCheckedModeBanner: false,
    initialRoute: '/login',
    routes: {
      '/login': (context) => const ScreenLogin(),
      '/screen_user_register': (context) => const ScreenRegister(),
      '/screen_user_details_register': (context) => const UserDetailsScreen(),
      '/profile': (context) => const ProfileScreen(),
      '/screen_dating_profile_register': (context) =>
      const DatingProfileScreen(userDetails: null,),
      '/image_picker': (context) => const ImagePickerScreen(),
      '/home_dating': (context) => const HomeDatingScreen(),
      '/choose_location': (context) => const ChooseLocationScreen(),
      '/edit_profile': (context) => const ChangeProfileScreen(),
      '/check_likes': (context) => const CheckLikesScreen(),
      '/add_likes': (context) => const AddLikesScreen(),
      '/check_matches': (context) => const CheckMatchesScreen(),

    },
  ));
}
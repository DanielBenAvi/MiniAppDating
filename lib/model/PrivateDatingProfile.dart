import '../constants/Gender.dart';

class PrivateDatingProfile {
  PublicDatingProfile? publicProfile;
  DateTime? dateOfBirthday;
  String? phoneNumber;
  int distanceRange;
  int maxAge;
  int minAge;
  List<Gender> genderPreferences;
  List<String> matches;
  List<String> likes;

  PrivateDatingProfile({
    this.publicProfile,
    this.dateOfBirthday,
    this.phoneNumber,
    required this.distanceRange,
    required this.maxAge,
    required this.minAge,
    List<Gender>? genderPreferences,
    List<String>? matches,
    List<String>? likes,
  })  : genderPreferences = genderPreferences ?? [],
        matches = matches ?? [],
        likes = likes ?? [];

  @override
  String toString() {
    return 'PrivateDatingProfile{'
        'publicProfile=$publicProfile, '
        'dateOfBirthday=$dateOfBirthday, '
        'phoneNumber=$phoneNumber, '
        'distanceRange=$distanceRange, '
        'maxAge=$maxAge, '
        'minAge=$minAge, '
        'genderPreferences=$genderPreferences, '
        'matches=$matches, '
        'likes=$likes'
        '}';
  }
}

class PublicDatingProfile {
  // Add properties of the PublicDatingProfile.dart class here
}



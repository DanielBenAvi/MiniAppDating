import '../constants/Gender.dart';
import 'PublicDatingProfile.dart';

class PrivateDatingProfile {
  PublicDatingProfile? publicProfile;
  DateTime? dateOfBirthday;
  String? phoneNumber;
  int distanceRange;
  int maxAge;
  int minAge;
  //String address;
  List<String> genderPreferences;
  List<String> matches;
  List<String> likes;

  PrivateDatingProfile({
    required this.publicProfile,
    required this.dateOfBirthday,
    required this.phoneNumber,
    required this.distanceRange,
    required this.maxAge,
    required this.minAge,
    required List<String>? genderPreferences,
    List<String>? matches,
    List<String>? likes,
  })  : genderPreferences = genderPreferences ?? [] ,
        matches = matches ?? [],
        likes = likes ?? [];

  PublicDatingProfile? getPublicProfile() {
    return publicProfile;
  }

  void setPublicProfile(PublicDatingProfile? publicProfile) {
    this.publicProfile = publicProfile;
  }

  DateTime? getDateOfBirthday() {
    return dateOfBirthday;
  }

  void setDateOfBirthday(DateTime? dateOfBirthday) {
    this.dateOfBirthday = dateOfBirthday;
  }

  String? getPhoneNumber() {
    return phoneNumber;
  }

  void setPhoneNumber(String? phoneNumber) {
    this.phoneNumber = phoneNumber;
  }

  int getDistanceRange() {
    return distanceRange;
  }

  void setDistanceRange(int distanceRange) {
    this.distanceRange = distanceRange;
  }

  int getMaxAge() {
    return maxAge;
  }

  void setMaxAge(int maxAge) {
    this.maxAge = maxAge;
  }

  int getMinAge() {
    return minAge;
  }

  void setMinAge(int minAge) {
    this.minAge = minAge;
  }

  List<String> getGenderPreferences() {
    return genderPreferences;
  }

  void setGenderPreferences(List<String> genderPreferences) {
    this.genderPreferences = genderPreferences;
  }

  List<String> getMatches() {
    return matches;
  }

  void setMatches(List<String> matches) {
    this.matches = matches;
  }

  List<String> getLikes() {
    return likes;
  }

  void setLikes(List<String> likes) {
    this.likes = likes;
  }

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

  Map<String, dynamic> privateDatingProfileToMap() {
    final objectDetails = <String, dynamic>{
      'publicProfile': publicProfile?.publicDatingProfileToMap(),
      'dateOfBirthday': dateOfBirthday?.toIso8601String(),
      'phoneNumber': phoneNumber,
      'distanceRange': distanceRange,
      'maxAge': maxAge,
      'minAge': minAge,
      'genderPreferences': genderPreferences.map((gender) => gender.toString()).toList(),
      'matches': matches,
      'likes': likes,
    };

    return objectDetails;
  }
}

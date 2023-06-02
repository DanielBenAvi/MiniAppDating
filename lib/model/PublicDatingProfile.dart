import '../constants/Gender.dart';

class PublicDatingProfile {
  String? nickName;
  String? gender;
  int? age;
  String? bio;
  List<String> pictures;

  PublicDatingProfile({
    required this.nickName,
    required this.gender,
    required this.age,
    required this.bio,
    List<String>? pictures,
  }) : pictures = pictures ?? [];

  @override
  String toString() {
    return 'PublicDatingProfile{'
        'nickName=$nickName, '
        'gender=$gender, '
        'age=$age, '
        'bio=$bio, '
        'pictures=$pictures'
        '}';
  }

  Map<String, dynamic> publicDatingProfileToMap() {
    return {
      'nickName': nickName,
      'gender': gender.toString(),
      'age': age,
      'bio': bio,
      'pictures': pictures,
    };
  }
}

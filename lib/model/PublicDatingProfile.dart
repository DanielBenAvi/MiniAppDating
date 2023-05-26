import '../constants/Gender.dart';

class PublicDatingProfile {
  String? nickName;
  Gender? gender;
  int? age;
  String? bio;
  List<Gender> sexOrientation;
  List<String> pictures;

  PublicDatingProfile({
    this.nickName,
    this.gender,
    this.age,
    this.bio,
    List<Gender>? sexOrientation,
    List<String>? pictures,
  })  : sexOrientation = sexOrientation ?? [],
        pictures = pictures ?? [];

  @override
  String toString() {
    return 'PublicDatingProfile{'
        'nickName=$nickName, '
        'gender=$gender, '
        'age=$age, '
        'bio=$bio, '
        'sexOrientation=$sexOrientation, '
        'pictures=$pictures'
        '}';
  }
}

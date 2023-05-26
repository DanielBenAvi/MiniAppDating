class UserDetails {
  String? name;
  String? phoneNum;
  List<String> preferences;

  UserDetails({
    this.name,
    this.phoneNum,
    this.preferences = const [],
  });
}

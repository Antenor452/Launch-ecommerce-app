class User {
  final String? email;
  final String? username;
  final String? uid;
  final String? imgUrl;

  User(
      {required this.uid,
      required this.email,
      required this.username,
      this.imgUrl});
}

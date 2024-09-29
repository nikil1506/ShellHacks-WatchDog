enum UserType { guest, dispatcher, security }

class UserModel {
  final String? id;
  final String? token;
  final UserType type;

  UserModel({
    this.id,
    this.token,
    this.type = UserType.guest,
  });
}

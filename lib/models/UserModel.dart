import 'dart:convert';

class UserModel {
  int id;
  String firstname;
  String lastname;
  String email;
  String password;
  String role;

  UserModel(
      {this.id,
      this.firstname,
      this.lastname,
      this.email,
      this.password,
      this.role});

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      firstname: map['firstname'],
      lastname: map['lastname'],
      email: map['email'],
      password: map['password'],
      role: map['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firstname": firstname,
      "lastname": lastname,
      "email": email,
      "password": password,
      "role": role
    };
  }

  @override
  String toString() {
    return 'User{id: $id, firstname: $firstname, lastname: $lastname, email: $email, password: $password, role: $role}';
  }

  List<UserModel> userFromJson(String jsonData) {
    final data = json.decode(jsonData);
    return List<UserModel>.from(data.map((item) => UserModel.fromJson(item)));
  }

  String userToJson(UserModel data) {
    final jsonData = data.toJson();
    return json.encode(jsonData);
  }
}

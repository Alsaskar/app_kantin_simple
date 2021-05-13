import 'package:app_kantin/models/UserModel.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';

class UserService {
  final String baseUrl = "http://192.168.43.196:3000/user";
  Client client = Client();
  UserModel user = UserModel();

  Future<bool> registerUser(UserModel data) async {
    final response = await client.post(
      "$baseUrl/register",
      headers: {"content-type": "application/json"},
      body: user.userToJson(data),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  loginUser(String email, String password) async {
    final response = await client.post(
      "$baseUrl/login",
      body: {
        "email": email,
        "password": password,
      },
    );

    var value = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return value;
    } else if (response.statusCode == 401) {
      return value;
    }

    return null;
  }
}

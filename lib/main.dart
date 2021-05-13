import 'package:flutter/material.dart';
import 'package:app_kantin/views/Login.dart';
import 'package:app_kantin/views/Dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var email = sharedPreferences.getString("email");
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: email == null ? Login() : Dashboard(),
  ));
}

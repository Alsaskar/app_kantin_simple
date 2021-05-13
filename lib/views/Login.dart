import 'package:app_kantin/service/UserService.dart';
import 'package:flutter/material.dart';
import 'package:app_kantin/views/Register.dart';
import 'package:app_kantin/views/Dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  final String messageAlert, statusMessage;

  Login({this.statusMessage, this.messageAlert, Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPass = TextEditingController();

  bool _isLoading = false;
  bool _isFieldEmailValid;
  bool _isFieldPassValid;

  // pesan error jika gagal login
  String messageError;
  bool statusError = false;

  @override
  void initState() {
    super.initState();
  }

  void _setSharedPreferences(String email, int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('email', email);
    sharedPreferences.setString('id_user', id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(top: 150),
        child: _isLoading
            ? Stack(
                children: <Widget>[
                  Opacity(
                    opacity: 0.3,
                    child: ModalBarrier(
                      dismissible: false,
                      color: Colors.grey,
                    ),
                  ),
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/kantin.jpg",
                      height: 200,
                    ),
                    Text(
                      "Login Aplikasi Kantin",
                      style: TextStyle(fontSize: 25),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, left: 40, right: 40),
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),

                    // feedback ke user
                    widget.statusMessage == 'true'
                        ? Container(
                            padding: EdgeInsets.all(5),
                            width: 280.0,
                            color: Colors.blue,
                            child: Text(
                              widget.messageAlert,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : Container(),

                    statusError
                        ? Container(
                            padding: EdgeInsets.all(5),
                            width: 280.0,
                            color: Colors.red,
                            child: Text(
                              messageError,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : Container(),

                    Padding(
                      padding: EdgeInsets.only(top: 10, left: 40, right: 40),
                      child: _buildTextFieldEmail(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, left: 40, right: 40),
                      child: _buildTextFieldPass(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: ButtonTheme(
                        minWidth: 280.0,
                        height: 50.0,
                        child: RaisedButton(
                          color: Colors.blue,
                          onPressed: () {
                            setState(() => _isLoading = true);

                            String email = _controllerEmail.text.toString();
                            String password = _controllerPass.text.toString();

                            UserService service = UserService();

                            service.loginUser(email, password).then((data) {
                              setState(() {
                                _isLoading = false;
                              });

                              if (data['loggedIn']) {
                                // jika berhasil login
                                _setSharedPreferences(
                                    data['users']['email'],
                                    data['users']
                                        ['id']); // set shared preferences
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Dashboard(),
                                  ),
                                );
                              } else {
                                // jika gagal login
                                setState(() {
                                  messageError = data['error'];
                                  statusError = true;
                                });

                                _controllerPass.clear();
                              }
                            });
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Register(),
                            ),
                          );
                        },
                        child: Text("Belum Daftar ? Silahkan daftar"),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildTextFieldEmail() {
    return TextField(
      controller: _controllerEmail,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        labelText: "Email",
        errorText: _isFieldEmailValid == null || _isFieldEmailValid
            ? null
            : "Email tidak boleh kosong",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldPassValid) {
          setState(() => _isFieldPassValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldPass() {
    return TextField(
      controller: _controllerPass,
      obscureText: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Password",
        errorText: _isFieldPassValid == null || _isFieldPassValid
            ? null
            : "Password tidak boleh kosong",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldPassValid) {
          setState(() => _isFieldPassValid = isFieldValid);
        }
      },
    );
  }

  Future<void> _showMyDialog(String title, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            InkWell(
              child: Text('Oke'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

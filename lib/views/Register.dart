import 'package:app_kantin/models/UserModel.dart';
import 'package:app_kantin/service/UserService.dart';
import 'package:flutter/material.dart';
import 'package:app_kantin/views/Login.dart';

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _controllerFirstname = TextEditingController();
  TextEditingController _controllerLastname = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPass = TextEditingController();
  TextEditingController _controllerConfirmPass = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(top: 50),
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
                      "Daftar Sekarang",
                      style: TextStyle(fontSize: 25),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, left: 40, right: 40),
                      child: Divider(
                        color: Colors.black,
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(top: 10, left: 40, right: 40),
                            child: TextFormField(
                              controller: _controllerFirstname,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)),
                                ),
                                labelText: "Nama Depan",
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Nama Depan tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(top: 10, left: 40, right: 40),
                            child: TextFormField(
                              controller: _controllerLastname,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)),
                                ),
                                labelText: "Nama Belakang",
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Nama Belakang tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(top: 10, left: 40, right: 40),
                            child: TextFormField(
                              controller: _controllerEmail,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)),
                                ),
                                labelText: "Email",
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(top: 10, left: 40, right: 40),
                            child: TextFormField(
                              controller: _controllerPass,
                              obscureText: true,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)),
                                ),
                                labelText: "Password",
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Passwod tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(top: 10, left: 40, right: 40),
                            child: TextFormField(
                              controller: _controllerConfirmPass,
                              obscureText: true,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)),
                                ),
                                labelText: "Konfirmasi Password",
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Konfirmasi Password tidak boleh kosong';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: ButtonTheme(
                              minWidth: 280.0,
                              height: 50.0,
                              child: RaisedButton(
                                color: Colors.blue,
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    setState(() => _isLoading = true);

                                    if (_controllerConfirmPass.text !=
                                        _controllerPass.text) {
                                      setState(() => _isLoading = false);
                                      _showMyDialog('Maaf',
                                          'Konfirmasi password tidak cocok dengan password');
                                    } else {
                                      String firstname =
                                          _controllerFirstname.text.toString();
                                      String lastname =
                                          _controllerLastname.text.toString();
                                      String email =
                                          _controllerEmail.text.toString();
                                      String password = _controllerConfirmPass
                                          .text
                                          .toString();
                                      String role = 'pembeli';

                                      UserModel user = UserModel(
                                        firstname: firstname,
                                        lastname: lastname,
                                        email: email,
                                        password: password,
                                        role: role,
                                      );

                                      UserService()
                                          .registerUser(user)
                                          .then((isSuccess) {
                                        setState(() => _isLoading = false);
                                        if (isSuccess) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Login(
                                                messageAlert:
                                                    'Anda telah berhasil mendaftar. Silahkan login',
                                                statusMessage: 'true',
                                              ),
                                            ),
                                          );
                                        } else {
                                          _showMyDialog(
                                              'Maaf', 'Gagal mendaftar');
                                        }
                                      });
                                    }
                                  }
                                },
                                child: Text(
                                  "Register",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: FlatButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Login(),
                                  ),
                                );
                              },
                              child: Text("Sudah punya akun ? Login"),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
      ),
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

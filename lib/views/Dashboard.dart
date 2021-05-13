import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_kantin/views/Login.dart';
import 'package:app_kantin/service/KantinService.dart';
import 'package:app_kantin/views/Order.dart';

String dataKantin;

class Dashboard extends StatefulWidget {
  final String email;
  final int id;

  Dashboard({this.email, this.id, Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  SharedPreferences sharedPreferences;
  List<dynamic> canteens;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  _checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    // jika user belum login
    if (sharedPreferences.getString("email") == "") {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => Login(),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }

  _logout() async {
    sharedPreferences.clear();
    sharedPreferences.commit();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => Login()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Kantin"),
        actions: [
          FlatButton(
            onPressed: () {
              _logout(); // logout
            },
            child: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Container(
        child: FutureBuilder<List>(
          future: KantinService().getAll(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                scrollDirection: Axis.vertical, // vertical
                itemCount: snapshot.data.length,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 2,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: Column(children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            snapshot.data[index]['nama'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            snapshot.data[index]['alamat'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ]),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Order(
                            namaKantin: snapshot.data[index]['nama'],
                            idKantin: snapshot.data[index]['id'],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("Error");
            }

            return Container(
              child: Text("Loading..."),
            );
          },
        ),
      ),
    );
  }
}

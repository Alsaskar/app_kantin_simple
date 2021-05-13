import 'package:flutter/material.dart';
import 'package:app_kantin/service/MenuService.dart';

class Order extends StatefulWidget {
  final String namaKantin;
  final int idKantin;
  Order({Key key, this.namaKantin, this.idKantin}) : super(key: key);

  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.namaKantin),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "Daftar Menu",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5, bottom: 10),
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "Silahkan untuk memilih menu yang terdapat pada " +
                    widget.namaKantin,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
          Flexible(
            child: FutureBuilder<List>(
              future: MenuService().getMenu(widget.idKantin),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data.length > 0
                      ? ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            var images =
                                "http://192.168.43.196/app_kantin/assets/images/menu/" +
                                    snapshot.data[index]['foto'];
                            var noImage =
                                "http://192.168.43.196/app_kantin/assets/images/no_image.jpg";

                            return Container(
                              margin: EdgeInsets.only(
                                  left: 5.0, right: 5.0, bottom: 5),
                              child: Ink(
                                color: Colors.blue,
                                child: ListTile(
                                  onTap: () {
                                    print("berhasil di klik");
                                  },
                                  title: Text(
                                    snapshot.data[index]['nama_menu'],
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Harga : " +
                                        snapshot.data[index]['harga']
                                            .toString() +
                                        ", tersisa : " +
                                        snapshot.data[index]['stock']
                                            .toString(),
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                  leading: snapshot.data[index]['foto'] == ''
                                      ? Image.network(noImage)
                                      : Image.network(images),
                                  hoverColor: Colors.blue,
                                ),
                              ),
                            );
                          },
                        )
                      : Column(
                          // jika data kosong
                          children: [
                            Image.asset(
                              "assets/images/sorry.png",
                              height: 200,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                "Maaf kantin ini belum ada menu",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                        );
                }

                return CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }
}

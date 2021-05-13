import 'package:http/http.dart' show Client;
import 'dart:convert';

class MenuService {
  final String baseUrl = "http://192.168.43.196:3000/menu";
  Client client = Client();

  Future<List> getMenu(int id) async {
    final response = await client.get("$baseUrl/$id");
    Map<String, dynamic> map = json.decode(response.body);
    List<dynamic> data = map['data'];
    return data;
  }
}

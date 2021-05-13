import 'package:http/http.dart' show Client;
import 'dart:convert';

class KantinService {
  final String baseUrl = "http://192.168.43.196:3000/kantin";
  Client client = Client();

  Future<List> getAll() async {
    final response = await client.get("$baseUrl/get-all");
    Map<String, dynamic> map = json.decode(response.body);
    List<dynamic> data = map['data'];
    return data;
  }
}

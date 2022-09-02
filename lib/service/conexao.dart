import 'dart:convert';

import 'package:http/http.dart' as http;

class Conexao {
  Future api() async {
    http.Response response;
    String link = "https://jsonplaceholder.typicode.com/users";

    response = await http.get(Uri.parse(link));

    // print("${response.statusCode}");
    // print("++++++++++++++++++++++++++++corpo++++++++++++++++++++++++++++");
    // print("${response.body.runtimeType}");

    return jsonDecode(response.body);
  }
}

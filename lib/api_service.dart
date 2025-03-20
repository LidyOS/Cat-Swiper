import 'dart:convert';
import 'package:http/http.dart' as http;
import 'cat_model.dart';

class ApiService {
  static const _baseUrl = 'https://api.thecatapi.com/v1';
  static const _apiKey =
      'live_PWrJ6DO9LxqJi3b7TMVX91bR2IzYxgwlYcjM6Tmc66vATk2k3LVRXIKaStmgNClb';

  Future<Cat> fetchCat() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/images/search?has_breeds=true'),
      headers: {'x-api-key': _apiKey},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)[0];
      return Cat.fromJson(data);
    } else {
      throw Exception('Failed to load cat');
    }
  }
}

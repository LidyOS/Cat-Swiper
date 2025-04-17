import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:homework_1/domain/entities/cat.dart';

class CatApiService {
  static const _baseUrl = 'https://api.thecatapi.com/v1';
  static final _apiKey = dotenv.env['API_TOKEN'];

  Future<Cat> fetchCat() async {
    if (_apiKey == null) {
      throw Exception('API token is not defined in .env file');
    }
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/images/search?has_breeds=true'),
        headers: {'x-api-key': _apiKey!},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)[0];
        return Cat.fromJson(data);
      } else {
        throw Exception('Failed to load cat: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}

import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:homework_1/domain/entities/cat.dart';
import 'package:homework_1/data/datasources/database_helper.dart';

class CatApiService {
  static const _baseUrl = 'https://api.thecatapi.com/v1';
  static const _defaultApiKey =
      'live_28eBZMsCParu7dWJ88d9gjgcGvJEMIPGgqVFYCOQa7Xw0WEaFMqwhHz5SInIGfGk';
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final Connectivity _connectivity = Connectivity();

  Future<Cat> fetchCat() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      final bool isConnected = connectivityResult != ConnectivityResult.none;

      if (!isConnected) {
        debugPrint('No internet connection, using offline data');
        return _getOfflineCat();
      }

      final apiKey = dotenv.env['API_TOKEN'] ?? _defaultApiKey;

      final Map<String, String> headers = {'x-api-key': apiKey};

      try {
        final response = await http
            .get(
              Uri.parse('$_baseUrl/images/search?has_breeds=true&limit=1'),
              headers: headers,
            )
            .timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final List<dynamic> responseData = jsonDecode(response.body);
          if (responseData.isEmpty) {
            return _getOfflineCat();
          }

          final data = responseData[0];
          if (data['breeds'] == null || (data['breeds'] as List).isEmpty) {
            return _getOfflineCat();
          }

          return Cat.fromJson(data);
        } else {
          debugPrint('API error: ${response.statusCode} - ${response.body}');
          return _getOfflineCat();
        }
      } catch (e) {
        debugPrint('Network error, using offline data: $e');
        return _getOfflineCat();
      }
    } catch (e) {
      debugPrint('Error in fetchCat: $e');
      return _getOfflineCat();
    }
  }

  Future<Cat> _getOfflineCat() async {
    final likedCats = await _databaseHelper.getLikedCats();
    if (likedCats.isNotEmpty) {
      final random = Random();
      final index = random.nextInt(likedCats.length);
      return likedCats[index];
    }

    final random = Random();
    final index = random.nextInt(_offlineCats.length);
    return _offlineCats[index];
  }

  Future<bool> isConnected() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  static final List<Cat> _offlineCats = [
    Cat(
      id: 'offline-1',
      imageUrl: 'https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg',
      breed: const Breed(
        name: 'Abyssinian',
        description:
            'The Abyssinian is easy to care for, and a joy to have in your home. They are affectionate cats and love both people and other animals.',
        temperament: 'Active, Energetic, Independent, Intelligent, Gentle',
        origin: 'Egypt',
      ),
    ),
    Cat(
      id: 'offline-2',
      imageUrl: 'https://cdn2.thecatapi.com/images/ozEvzdVM-.jpg',
      breed: const Breed(
        name: 'American Bobtail',
        description:
            'American Bobtails are loving and incredibly intelligent cats possessing a distinctive wild appearance. They are extremely interactive cats that bond with their human family with great devotion.',
        temperament: 'Intelligent, Interactive, Lively, Playful, Sensitive',
        origin: 'United States',
      ),
    ),
    Cat(
      id: 'offline-3',
      imageUrl: 'https://cdn2.thecatapi.com/images/hBXicehMA.jpg',
      breed: const Breed(
        name: 'Siamese',
        description:
            'The Siamese is one of the oldest breeds of domestic cats. Affectionate and intelligent, they are known for their loyalty and ability to communicate with their owners.',
        temperament: 'Active, Agile, Clever, Sociable, Loving, Energetic',
        origin: 'Thailand',
      ),
    ),
  ];
}

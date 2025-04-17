import 'package:homework_1/data/datasources/cat_api_service.dart';
import 'package:homework_1/domain/entities/cat.dart';
import 'package:homework_1/domain/repositories/cat_repository.dart';

class CatRepositoryImpl implements CatRepository {
  final CatApiService apiService;

  CatRepositoryImpl({required this.apiService});

  @override
  Future<Cat> fetchCat() async {
    try {
      return await apiService.fetchCat();
    } catch (e) {
      throw Exception('Failed to fetch cat: $e');
    }
  }
}

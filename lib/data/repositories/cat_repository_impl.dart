import 'package:homework_1/data/datasources/cat_api_service.dart';
import 'package:homework_1/data/datasources/database_helper.dart';
import 'package:homework_1/domain/entities/cat.dart';
import 'package:homework_1/domain/repositories/cat_repository.dart';

class CatRepositoryImpl implements CatRepository {
  final CatApiService apiService;
  final DatabaseHelper databaseHelper;

  CatRepositoryImpl({required this.apiService, required this.databaseHelper});

  @override
  Future<Cat> fetchCat() async {
    try {
      return await apiService.fetchCat();
    } catch (e) {
      throw Exception('Failed to fetch cat: $e');
    }
  }

  @override
  Future<void> likeCat(Cat cat) async {
    await databaseHelper.insertCat(cat);
  }

  @override
  Future<void> unlikeCat(String id) async {
    await databaseHelper.deleteCat(id);
  }

  @override
  Future<List<Cat>> getLikedCats() async {
    return await databaseHelper.getLikedCats();
  }

  @override
  Future<bool> isCatLiked(String id) async {
    return await databaseHelper.isCatLiked(id);
  }

  @override
  Future<bool> isConnected() async {
    return await apiService.isConnected();
  }
}

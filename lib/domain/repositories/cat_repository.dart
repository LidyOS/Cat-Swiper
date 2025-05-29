import 'package:homework_1/domain/entities/cat.dart';

abstract class CatRepository {
  Future<Cat> fetchCat();
  Future<void> likeCat(Cat cat);
  Future<void> unlikeCat(String id);
  Future<List<Cat>> getLikedCats();
  Future<bool> isCatLiked(String id);
  Future<bool> isConnected();
}

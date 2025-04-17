import 'package:homework_1/domain/entities/cat.dart';

abstract class CatRepository {
  Future<Cat> fetchCat();
}

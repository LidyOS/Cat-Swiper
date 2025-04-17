import 'package:homework_1/domain/entities/cat.dart';
import 'package:homework_1/domain/repositories/cat_repository.dart';

class FetchCatUseCase {
  final CatRepository repository;

  FetchCatUseCase({required this.repository});

  Future<Cat> execute() async {
    return await repository.fetchCat();
  }
}

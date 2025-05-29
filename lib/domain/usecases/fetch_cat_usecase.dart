import 'package:homework_1/domain/entities/cat.dart';
import 'package:homework_1/domain/repositories/cat_repository.dart';

class FetchCatUseCase {
  final CatRepository repository;

  FetchCatUseCase({required this.repository});

  Future<Cat> execute() async {
    return await repository.fetchCat();
  }
}

class LikeCatUseCase {
  final CatRepository repository;

  LikeCatUseCase({required this.repository});

  Future<void> execute(Cat cat) async {
    await repository.likeCat(cat);
  }
}

class UnlikeCatUseCase {
  final CatRepository repository;

  UnlikeCatUseCase({required this.repository});

  Future<void> execute(String id) async {
    await repository.unlikeCat(id);
  }
}

class GetLikedCatsUseCase {
  final CatRepository repository;

  GetLikedCatsUseCase({required this.repository});

  Future<List<Cat>> execute() async {
    return await repository.getLikedCats();
  }
}

class IsCatLikedUseCase {
  final CatRepository repository;

  IsCatLikedUseCase({required this.repository});

  Future<bool> execute(String id) async {
    return await repository.isCatLiked(id);
  }
}

class CheckConnectivityUseCase {
  final CatRepository repository;

  CheckConnectivityUseCase({required this.repository});

  Future<bool> execute() async {
    return await repository.isConnected();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:homework_1/domain/entities/cat.dart';
import 'package:homework_1/domain/usecases/fetch_cat_usecase.dart';

part 'cat_state.dart';

class CatCubit extends Cubit<CatState> {
  final FetchCatUseCase fetchCatUseCase;
  final LikeCatUseCase likeCatUseCase;
  final UnlikeCatUseCase unlikeCatUseCase;
  final GetLikedCatsUseCase getLikedCatsUseCase;
  final IsCatLikedUseCase isCatLikedUseCase;
  final CheckConnectivityUseCase checkConnectivityUseCase;

  List<Cat> _likedCats = [];
  String? _breedFilter;
  bool _isConnected = true;

  CatCubit({
    required this.fetchCatUseCase,
    required this.likeCatUseCase,
    required this.unlikeCatUseCase,
    required this.getLikedCatsUseCase,
    required this.isCatLikedUseCase,
    required this.checkConnectivityUseCase,
  }) : super(CatInitial()) {
    _loadLikedCats();
    _checkConnectivity();
  }

  Future<void> _loadLikedCats() async {
    _likedCats = await getLikedCatsUseCase.execute();
    if (state is CatLoaded) {
      final currentCat = (state as CatLoaded).cat;
      emit(CatLoaded(cat: currentCat, isConnected: _isConnected));
    }
  }

  Future<void> _checkConnectivity() async {
    _isConnected = await checkConnectivityUseCase.execute();
    if (state is CatLoaded) {
      final currentCat = (state as CatLoaded).cat;
      emit(CatLoaded(cat: currentCat, isConnected: _isConnected));
    }
  }

  Future<void> fetchCat() async {
    emit(CatLoading());
    try {
      await _checkConnectivity();
      final cat = await fetchCatUseCase.execute();
      final isLiked = await isCatLikedUseCase.execute(cat.id);
      emit(CatLoaded(cat: cat, isLiked: isLiked, isConnected: _isConnected));
    } catch (e) {
      debugPrint('Error in CatCubit.fetchCat: $e');
      emit(CatError(message: 'Не удалось загрузить котика. Попробуйте снова.'));
    }
  }

  Future<void> likeCat(Cat cat) async {
    try {
      await likeCatUseCase.execute(cat);
      await _loadLikedCats();
      emit(
        CatLiked(
          cat: cat,
          likedCats: getFilteredLikedCats(),
          isConnected: _isConnected,
        ),
      );
    } catch (e) {
      debugPrint('Error in CatCubit.likeCat: $e');
    }
  }

  Future<void> unlikeCat(Cat cat) async {
    try {
      await unlikeCatUseCase.execute(cat.id);
      await _loadLikedCats();
      emit(
        CatUnliked(
          likedCats: getFilteredLikedCats(),
          isConnected: _isConnected,
        ),
      );
    } catch (e) {
      debugPrint('Error in CatCubit.unlikeCat: $e');
    }
  }

  List<Cat> getFilteredLikedCats() {
    if (_breedFilter == null || _breedFilter!.isEmpty) {
      return List.from(_likedCats);
    }
    return _likedCats
        .where(
          (cat) => cat.breed.name.toLowerCase().contains(
            _breedFilter!.toLowerCase(),
          ),
        )
        .toList();
  }

  void setBreedFilter(String? breed) {
    _breedFilter = breed;
    emit(
      CatFiltered(likedCats: getFilteredLikedCats(), isConnected: _isConnected),
    );
  }

  List<String> getBreeds() {
    return _likedCats.map((cat) => cat.breed.name).toSet().toList();
  }

  bool get isConnected => _isConnected;

  Future<void> checkConnectivity() async {
    final wasConnected = _isConnected;
    await _checkConnectivity();
    if (wasConnected != _isConnected) {
      if (state is CatLoaded) {
        final currentCat = (state as CatLoaded).cat;
        emit(CatLoaded(cat: currentCat, isConnected: _isConnected));
      }
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:homework_1/domain/entities/cat.dart';
import 'package:homework_1/domain/usecases/fetch_cat_usecase.dart';

part 'cat_state.dart';

class CatCubit extends Cubit<CatState> {
  final FetchCatUseCase fetchCatUseCase;
  final List<Cat> _likedCats = [];
  String? _breedFilter;

  CatCubit({required this.fetchCatUseCase}) : super(CatInitial());

  Future<void> fetchCat() async {
    emit(CatLoading());
    try {
      final cat = await fetchCatUseCase.execute();
      emit(CatLoaded(cat: cat));
    } catch (e) {
      emit(CatError(message: e.toString()));
    }
  }

  void likeCat(Cat cat) {
    _likedCats.add(cat);
    emit(CatLiked(cat: cat, likedCats: getFilteredLikedCats()));
  }

  void unlikeCat(Cat cat) {
    _likedCats.removeWhere((c) => c.id == cat.id);
    emit(CatUnliked(likedCats: getFilteredLikedCats()));
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
    emit(CatFiltered(likedCats: getFilteredLikedCats()));
  }

  List<String> getBreeds() {
    return _likedCats.map((cat) => cat.breed.name).toSet().toList();
  }
}

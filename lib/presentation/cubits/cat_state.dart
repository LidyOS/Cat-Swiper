part of 'cat_cubit.dart';

abstract class CatState extends Equatable {
  const CatState();

  @override
  List<Object?> get props => [];
}

class CatInitial extends CatState {}

class CatLoading extends CatState {}

class CatLoaded extends CatState {
  final Cat cat;

  const CatLoaded({required this.cat});

  @override
  List<Object?> get props => [cat];
}

class CatError extends CatState {
  final String message;

  const CatError({required this.message});

  @override
  List<Object?> get props => [message];
}

class CatLiked extends CatState {
  final Cat cat;
  final List<Cat> likedCats;

  const CatLiked({required this.cat, required this.likedCats});

  @override
  List<Object?> get props => [cat, likedCats];
}

class CatUnliked extends CatState {
  final List<Cat> likedCats;

  const CatUnliked({required this.likedCats});

  @override
  List<Object?> get props => [likedCats];
}

class CatFiltered extends CatState {
  final List<Cat> likedCats;

  const CatFiltered({required this.likedCats});

  @override
  List<Object?> get props => [likedCats];
}

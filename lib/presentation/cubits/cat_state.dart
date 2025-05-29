part of 'cat_cubit.dart';

abstract class CatState extends Equatable {
  final bool isConnected;

  const CatState({this.isConnected = true});

  @override
  List<Object?> get props => [isConnected];
}

class CatInitial extends CatState {}

class CatLoading extends CatState {
  const CatLoading({super.isConnected});
}

class CatLoaded extends CatState {
  final Cat cat;
  final bool isLiked;

  const CatLoaded({
    required this.cat,
    this.isLiked = false,
    required super.isConnected,
  });

  @override
  List<Object?> get props => [cat, isLiked, isConnected];
}

class CatError extends CatState {
  final String message;

  const CatError({required this.message, super.isConnected});

  @override
  List<Object?> get props => [message, isConnected];
}

class CatLiked extends CatState {
  final Cat cat;
  final List<Cat> likedCats;

  const CatLiked({
    required this.cat,
    required this.likedCats,
    required super.isConnected,
  });

  @override
  List<Object?> get props => [cat, likedCats, isConnected];
}

class CatUnliked extends CatState {
  final List<Cat> likedCats;

  const CatUnliked({required this.likedCats, required super.isConnected});

  @override
  List<Object?> get props => [likedCats, isConnected];
}

class CatFiltered extends CatState {
  final List<Cat> likedCats;

  const CatFiltered({required this.likedCats, required super.isConnected});

  @override
  List<Object?> get props => [likedCats, isConnected];
}

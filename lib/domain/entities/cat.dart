import 'package:equatable/equatable.dart';

class Cat extends Equatable {
  final String id;
  final String imageUrl;
  final Breed breed;
  final DateTime likedAt;

  Cat({
    required this.id,
    required this.imageUrl,
    required this.breed,
    DateTime? likedAt,
  }) : likedAt = likedAt ?? DateTime.now();

  factory Cat.fromJson(Map<String, dynamic> json) {
    return Cat(
      id: json['id'],
      imageUrl: json['url'],
      breed: Breed.fromJson(json['breeds'][0]),
    );
  }

  Cat copyWith({
    String? id,
    String? imageUrl,
    Breed? breed,
    DateTime? likedAt,
  }) {
    return Cat(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      breed: breed ?? this.breed,
      likedAt: likedAt ?? this.likedAt,
    );
  }

  @override
  List<Object?> get props => [id, imageUrl, breed, likedAt];
}

class Breed extends Equatable {
  final String name;
  final String description;
  final String temperament;
  final String origin;

  const Breed({
    required this.name,
    required this.description,
    required this.temperament,
    required this.origin,
  });

  factory Breed.fromJson(Map<String, dynamic> json) {
    return Breed(
      name: json['name'],
      description: json['description'],
      temperament: json['temperament'],
      origin: json['origin'],
    );
  }

  @override
  List<Object?> get props => [name, description, temperament, origin];
}

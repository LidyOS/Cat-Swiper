class Cat {
  final String imageUrl;
  final Breed breed;

  Cat({required this.imageUrl, required this.breed});

  factory Cat.fromJson(Map<String, dynamic> json) {
    return Cat(imageUrl: json['url'], breed: Breed.fromJson(json['breeds'][0]));
  }
}

class Breed {
  final String name;
  final String description;
  final String temperament;
  final String origin;

  Breed({
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
}

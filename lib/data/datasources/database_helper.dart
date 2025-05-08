import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cat_swiper/domain/entities/cat.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'cat_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE liked_cats(
        id TEXT PRIMARY KEY,
        imageUrl TEXT NOT NULL,
        breedName TEXT NOT NULL,
        breedDescription TEXT NOT NULL,
        breedTemperament TEXT NOT NULL,
        breedOrigin TEXT NOT NULL,
        likedAt TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertCat(Cat cat) async {
    final db = await database;
    return await db.insert('liked_cats', {
      'id': cat.id,
      'imageUrl': cat.imageUrl,
      'breedName': cat.breed.name,
      'breedDescription': cat.breed.description,
      'breedTemperament': cat.breed.temperament,
      'breedOrigin': cat.breed.origin,
      'likedAt': cat.likedAt.toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteCat(String id) async {
    final db = await database;
    return await db.delete('liked_cats', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Cat>> getLikedCats() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('liked_cats');

    return List.generate(maps.length, (i) {
      return Cat(
        id: maps[i]['id'],
        imageUrl: maps[i]['imageUrl'],
        breed: Breed(
          name: maps[i]['breedName'],
          description: maps[i]['breedDescription'],
          temperament: maps[i]['breedTemperament'],
          origin: maps[i]['breedOrigin'],
        ),
        likedAt: DateTime.parse(maps[i]['likedAt']),
      );
    });
  }

  Future<bool> isCatLiked(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'liked_cats',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }
}

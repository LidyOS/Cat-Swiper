import 'package:flutter/material.dart';
import 'api_service.dart';
import 'cat_model.dart';
import 'detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cat Swiper',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CatsHome(),
    );
  }
}

class CatsHome extends StatefulWidget {
  const CatsHome({super.key});

  @override
  State<CatsHome> createState() => _CatsHomeState();
}

class _CatsHomeState extends State<CatsHome> {
  int _likesCount = 0;
  late Future<Cat> _catFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _catFuture = _apiService.fetchCat();
  }

  void _nextCat({bool isLiked = false}) {
    setState(() {
      if (isLiked) _likesCount++;
      _catFuture = _apiService.fetchCat();
    });
  }

  void _handleSwipe(DragEndDetails details) {
    if (details.primaryVelocity == null) return;
    if (details.primaryVelocity! < 0) {
      _nextCat();
    } else if (details.primaryVelocity! > 0) {
      _nextCat(isLiked: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cat Swiper'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(Icons.favorite, color: Colors.red),
                Text('$_likesCount'),
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder<Cat>(
        future: _catFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No cats found'));
          }

          final cat = snapshot.data!;
          return GestureDetector(
            onPanEnd: _handleSwipe,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(cat: cat),
                            ),
                          ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CachedNetworkImage(
                          imageUrl: cat.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    cat.breed.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ActionButton(
                      icon: Icons.close,
                      color: Colors.red,
                      onPressed: () => _nextCat(),
                    ),
                    ActionButton(
                      icon: Icons.favorite,
                      color: Colors.green,
                      onPressed: () => _nextCat(isLiked: true),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const ActionButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 48,
      onPressed: onPressed,
      icon: Icon(icon, color: color),
    );
  }
}

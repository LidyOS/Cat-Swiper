import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homework_1/domain/entities/cat.dart';
import 'package:homework_1/presentation/cubits/cat_cubit.dart';

class DetailScreen extends StatelessWidget {
  final Cat cat;

  const DetailScreen({super.key, required this.cat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(cat.breed.name)),
      body: BlocBuilder<CatCubit, CatState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!state.isConnected)
                  Container(
                    width: double.infinity,
                    color: Colors.orange.shade100,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wifi_off, color: Colors.orange),
                        SizedBox(width: 8),
                        Text(
                          'Offline Mode',
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                Hero(
                  tag: 'cat_image_${cat.id}',
                  child: CachedNetworkImage(
                    imageUrl: cat.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                    errorWidget:
                        (context, url, error) => const Icon(Icons.error),
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoRow('Origin', cat.breed.origin),
                _buildInfoRow('Temperament', cat.breed.temperament),
                const SizedBox(height: 8),
                Text(cat.breed.description),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () async {
                    final cubit = context.read<CatCubit>();
                    final isCatLiked = await cubit.isCatLikedUseCase.execute(
                      cat.id,
                    );
                    if (isCatLiked) {
                      cubit.unlikeCat(cat);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cat removed from favorites'),
                          ),
                        );
                      }
                    } else {
                      cubit.likeCat(cat);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cat added to favorites'),
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.favorite),
                  label: const Text('Toggle Favorite'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade100,
                    foregroundColor: Colors.pink.shade700,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

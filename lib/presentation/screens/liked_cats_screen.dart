import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homework_1/presentation/cubits/cat_cubit.dart';
import 'package:homework_1/presentation/screens/detail_screen.dart';
import 'package:homework_1/presentation/widgets/cat_list_item.dart';

class LikedCatsScreen extends StatelessWidget {
  const LikedCatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Cats'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            if (context.read<CatCubit>().state is! CatLoaded) {
              context.read<CatCubit>().fetchCat();
            }
          },
        ),
      ),
      body: BlocBuilder<CatCubit, CatState>(
        builder: (context, state) {
          final catCubit = context.read<CatCubit>();
          final likedCats = catCubit.getFilteredLikedCats();
          final breeds = catCubit.getBreeds();

          if (!state.isConnected) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Offline Mode - Your liked cats are still available',
                ),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 2),
              ),
            );
          }

          if (likedCats.isEmpty) {
            return const Center(child: Text('No liked cats yet'));
          }

          return Column(
            children: [
              if (!state.isConnected)
                Container(
                  width: double.infinity,
                  color: Colors.orange.shade100,
                  padding: const EdgeInsets.symmetric(vertical: 8),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Filter by breed',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem<String>(
                      value: '',
                      child: Text('All breeds'),
                    ),
                    ...breeds.map(
                      (breed) => DropdownMenuItem<String>(
                        value: breed,
                        child: Text(breed),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    catCubit.setBreedFilter(value == '' ? null : value);
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: likedCats.length,
                  itemBuilder: (context, index) {
                    final cat = likedCats[index];
                    return CatListItem(
                      cat: cat,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(cat: cat),
                          ),
                        );
                      },
                      onDelete: () {
                        catCubit.unlikeCat(cat);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

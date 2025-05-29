import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homework_1/presentation/cubits/cat_cubit.dart';
import 'package:homework_1/presentation/screens/detail_screen.dart';
import 'package:homework_1/presentation/screens/liked_cats_screen.dart';
import 'package:homework_1/presentation/widgets/action_button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      ConnectivityResult result,
    ) {
      if (mounted) {
        context.read<CatCubit>().checkConnectivity();
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  void _handleSwipe(BuildContext context, DragEndDetails details) {
    if (details.primaryVelocity == null) return;
    if (details.primaryVelocity! < 0) {
      context.read<CatCubit>().fetchCat();
    } else if (details.primaryVelocity! > 0) {
      final state = context.read<CatCubit>().state;
      if (state is CatLoaded) {
        context.read<CatCubit>().likeCat(state.cat);
        context.read<CatCubit>().fetchCat();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cat Swiper'),
        actions: [
          BlocBuilder<CatCubit, CatState>(
            builder: (context, state) {
              final likedCats = context.read<CatCubit>().getFilteredLikedCats();
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LikedCatsScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  label: Text('Liked (${likedCats.length})'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    backgroundColor: Colors.white,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<CatCubit, CatState>(
        listenWhen: (previous, current) {
          return previous.isConnected != current.isConnected ||
              current is CatError;
        },
        listener: (context, state) {
          if (state is CatError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                duration: const Duration(seconds: 3),
                action: SnackBarAction(
                  label: 'Повторить',
                  onPressed: () {
                    context.read<CatCubit>().fetchCat();
                  },
                ),
              ),
            );
            context.read<CatCubit>().fetchCat();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.isConnected
                      ? 'Подключение к интернету восстановлено'
                      : 'Нет подключения к интернету. Работаем в оффлайн режиме',
                ),
                backgroundColor:
                    state.isConnected ? Colors.green : Colors.orange,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CatLoading || state is CatInitial) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Loading cat...',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            );
          } else if (state is CatError) {
            return const Center(child: Text('Error loading cat'));
          } else if (state is CatLoaded ||
              state is CatLiked ||
              state is CatUnliked ||
              state is CatFiltered) {
            final cat =
                state is CatLoaded
                    ? state.cat
                    : state is CatLiked
                    ? state.cat
                    : context.read<CatCubit>().state is CatLoaded
                    ? (context.read<CatCubit>().state as CatLoaded).cat
                    : null;

            if (cat == null) {
              context.read<CatCubit>().fetchCat();
              return const Center(child: CircularProgressIndicator());
            }

            return GestureDetector(
              onPanEnd: (details) => _handleSwipe(context, details),
              child: Column(
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
                            placeholder:
                                (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                            errorWidget:
                                (context, url, error) =>
                                    const Icon(Icons.error),
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
                        onPressed: () => context.read<CatCubit>().fetchCat(),
                      ),
                      ActionButton(
                        icon: Icons.favorite,
                        color:
                            state is CatLoaded && state.isLiked
                                ? Colors.red
                                : Colors.green,
                        onPressed: () {
                          context.read<CatCubit>().likeCat(cat);
                          context.read<CatCubit>().fetchCat();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          }

          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }
}

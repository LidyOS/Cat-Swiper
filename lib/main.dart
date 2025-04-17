import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homework_1/di/injection_container.dart';
import 'package:homework_1/presentation/cubits/cat_cubit.dart';
import 'package:homework_1/presentation/screens/home_screen.dart';

void main() async {
  initDependencies();
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CatCubit>()..fetchCat(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cat Swiper',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: const HomeScreen(),
      ),
    );
  }
}

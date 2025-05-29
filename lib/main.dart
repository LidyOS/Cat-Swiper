import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homework_1/di/injection_container.dart';
import 'package:homework_1/presentation/cubits/cat_cubit.dart';
import 'package:homework_1/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: "assets/.env");
  } catch (e) {
    dotenv.testLoad(
      fileInput:
          "API_TOKEN=live_28eBZMsCParu7dWJ88d9gjgcGvJEMIPGgqVFYCOQa7Xw0WEaFMqwhHz5SInIGfGk",
    );
  }

  initDependencies();

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
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
        ),
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}

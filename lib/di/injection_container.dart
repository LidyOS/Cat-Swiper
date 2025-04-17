import 'package:get_it/get_it.dart';
import 'package:homework_1/data/datasources/cat_api_service.dart';
import 'package:homework_1/data/repositories/cat_repository_impl.dart';
import 'package:homework_1/domain/repositories/cat_repository.dart';
import 'package:homework_1/domain/usecases/fetch_cat_usecase.dart';
import 'package:homework_1/presentation/cubits/cat_cubit.dart';

final GetIt sl = GetIt.instance;

void initDependencies() {
  // Data sources
  sl.registerLazySingleton<CatApiService>(() => CatApiService());

  // Repositories
  sl.registerLazySingleton<CatRepository>(
    () => CatRepositoryImpl(apiService: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => FetchCatUseCase(repository: sl()));

  // Cubits
  sl.registerFactory(() => CatCubit(fetchCatUseCase: sl()));
}

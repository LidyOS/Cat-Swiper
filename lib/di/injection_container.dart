import 'package:get_it/get_it.dart';
import 'package:homework_1/data/datasources/cat_api_service.dart';
import 'package:homework_1/data/repositories/cat_repository_impl.dart';
import 'package:homework_1/domain/repositories/cat_repository.dart';
import 'package:homework_1/domain/usecases/fetch_cat_usecase.dart';
import 'package:homework_1/presentation/cubits/cat_cubit.dart';

final GetIt sl = GetIt.instance;

void initDependencies() {
  sl.registerLazySingleton<CatApiService>(() => CatApiService());

  sl.registerLazySingleton<CatRepository>(
    () => CatRepositoryImpl(apiService: sl()),
  );

  sl.registerLazySingleton(() => FetchCatUseCase(repository: sl()));

  sl.registerFactory(() => CatCubit(fetchCatUseCase: sl()));
}

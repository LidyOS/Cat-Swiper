import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:cat_swiper/domain/entities/cat.dart';
import 'package:cat_swiper/domain/usecases/fetch_cat_usecase.dart';
import 'package:cat_swiper/presentation/cubits/cat_cubit.dart';

import 'cat_cubit_test.mocks.dart';

@GenerateMocks([
  FetchCatUseCase,
  LikeCatUseCase,
  UnlikeCatUseCase,
  GetLikedCatsUseCase,
  IsCatLikedUseCase,
  CheckConnectivityUseCase,
])
void main() {
  late CatCubit catCubit;
  late MockFetchCatUseCase mockFetchCatUseCase;
  late MockLikeCatUseCase mockLikeCatUseCase;
  late MockUnlikeCatUseCase mockUnlikeCatUseCase;
  late MockGetLikedCatsUseCase mockGetLikedCatsUseCase;
  late MockIsCatLikedUseCase mockIsCatLikedUseCase;
  late MockCheckConnectivityUseCase mockCheckConnectivityUseCase;

  setUp(() {
    mockFetchCatUseCase = MockFetchCatUseCase();
    mockLikeCatUseCase = MockLikeCatUseCase();
    mockUnlikeCatUseCase = MockUnlikeCatUseCase();
    mockGetLikedCatsUseCase = MockGetLikedCatsUseCase();
    mockIsCatLikedUseCase = MockIsCatLikedUseCase();
    mockCheckConnectivityUseCase = MockCheckConnectivityUseCase();

    when(mockGetLikedCatsUseCase.execute()).thenAnswer((_) async => []);
    when(mockCheckConnectivityUseCase.execute()).thenAnswer((_) async => true);

    catCubit = CatCubit(
      fetchCatUseCase: mockFetchCatUseCase,
      likeCatUseCase: mockLikeCatUseCase,
      unlikeCatUseCase: mockUnlikeCatUseCase,
      getLikedCatsUseCase: mockGetLikedCatsUseCase,
      isCatLikedUseCase: mockIsCatLikedUseCase,
      checkConnectivityUseCase: mockCheckConnectivityUseCase,
    );
  });

  final testCat = Cat(
    id: 'test-id',
    imageUrl: 'https://example.com/cat.jpg',
    breed: const Breed(
      name: 'Test Breed',
      description: 'Test Description',
      temperament: 'Test Temperament',
      origin: 'Test Origin',
    ),
  );

  group('CatCubit', () {
    test('initial state should be CatInitial', () {
      expect(catCubit.state, isA<CatInitial>());
    });

    test(
      'fetchCat should emit CatLoading and then CatLoaded when successful',
      () async {
        when(mockFetchCatUseCase.execute()).thenAnswer((_) async => testCat);
        when(mockIsCatLikedUseCase.execute(any)).thenAnswer((_) async => false);

        final expectedStates = [isA<CatLoading>(), isA<CatLoaded>()];

        expectLater(catCubit.stream, emitsInOrder(expectedStates));

        await catCubit.fetchCat();
      },
    );

    test('likeCat should call likeCatUseCase and emit CatLiked', () async {
      when(mockLikeCatUseCase.execute(testCat)).thenAnswer((_) async => {});
      when(
        mockGetLikedCatsUseCase.execute(),
      ).thenAnswer((_) async => [testCat]);

      final expectedStates = [isA<CatLiked>()];

      expectLater(catCubit.stream, emitsInOrder(expectedStates));

      await catCubit.likeCat(testCat);

      verify(mockLikeCatUseCase.execute(testCat)).called(1);
      verify(mockGetLikedCatsUseCase.execute()).called(1);
    });

    test(
      'unlikeCat should call unlikeCatUseCase and emit CatUnliked',
      () async {
        when(
          mockUnlikeCatUseCase.execute(testCat.id),
        ).thenAnswer((_) async => {});
        when(mockGetLikedCatsUseCase.execute()).thenAnswer((_) async => []);

        final expectedStates = [isA<CatUnliked>()];

        expectLater(catCubit.stream, emitsInOrder(expectedStates));

        await catCubit.unlikeCat(testCat);

        verify(mockUnlikeCatUseCase.execute(testCat.id)).called(1);
        verify(mockGetLikedCatsUseCase.execute()).called(1);
      },
    );
  });
}

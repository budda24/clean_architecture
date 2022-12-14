import 'package:clean_archtecture/core/error/exception.dart';
import 'package:clean_archtecture/core/error/failures.dart';
import 'package:clean_archtecture/core/platform/network_info.dart';
import 'package:clean_archtecture/feature/number_trivia/data/datasource/number_trivia_local_data_source.dart';
import 'package:clean_archtecture/feature/number_trivia/data/datasource/number_trivia_remote_data_source.dart';
import 'package:clean_archtecture/feature/number_trivia/data/models/number_trivia_model.dart';

import 'package:clean_archtecture/feature/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_archtecture/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNumberTriviaRemoteDatasoure extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockNumberTriviaLocalDatasource extends Mock
    implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NumberTriviaRepositoryImpl repository;
  late NumberTriviaRemoteDataSource mockRemoteDataSource;
  late NumberTriviaLocalDataSource mockLocalDataSource;
  late NetworkInfo networkInfo;

  setUp(() {
    mockRemoteDataSource = MockNumberTriviaRemoteDatasoure();
    mockLocalDataSource = MockNumberTriviaLocalDatasource();
    networkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
        localDataSource: mockLocalDataSource,
        remoteDataSource: mockRemoteDataSource,
        networkInfo: networkInfo);
  });
  const tnumber = 1;
  final NumberTriviaModel tNumberTriviaModel =
      NumberTriviaModel(number: tnumber, text: 'test');
  final NumberTrivia numberTrivia = tNumberTriviaModel;
  group('getconcreteNumberTrivia', () {
    test('should check if device is online', () async {
      //arrange
      when((() => networkInfo.isConnected)).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getConcreteNumberTrivia(tnumber))
          .thenAnswer((_) async => tNumberTriviaModel);

      //act
      await repository.getConcreteNumberTrivia(tnumber);
      //assert
      verify(() => networkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(() => networkInfo.isConnected).thenAnswer((_) async => true);
      });
      test(
          'should get concrete number trivia frome remote when device is online',
          () async {
        //arrange

        when(() => mockRemoteDataSource.getConcreteNumberTrivia(tnumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final response = await repository.getConcreteNumberTrivia(tnumber);
        //assert
        expect(response, right(tNumberTriviaModel));
        verify(() => networkInfo.isConnected);
      });
      test('should cache data after retriving it from remote server', () async {
        //arrange

        when(() => mockRemoteDataSource.getConcreteNumberTrivia(tnumber))
            .thenAnswer((_) async => tNumberTriviaModel);

        //act
        await repository.getConcreteNumberTrivia(tnumber);
        //assert
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tnumber));
        verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });
      test(
          'should trwow server faliure when getting remote number trivia trwow exeption',
          () async {
        //arrange

        when(() => mockRemoteDataSource.getConcreteNumberTrivia(tnumber))
            .thenThrow(ServerException());

        //act
        final result = await repository.getConcreteNumberTrivia(tnumber);

        //assert
        verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tnumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(left(ServerFaliure())));
      });
    });
    group('device is offline', () {
      setUp(() {
        when((() => networkInfo.isConnected)).thenAnswer((_) async => false);
      });
      test(
          'should get concrete number trivia from local when device is offline',
          () async {
        //arrange
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final response = await repository.getConcreteNumberTrivia(tnumber);
        //assert
        expect(response, right(tNumberTriviaModel));
        verify(() => mockLocalDataSource.getLastNumberTrivia());
      });
      test('should trow CacheFaliure when there is no previous triva saved',
          () async {
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        //act
        final response = await repository.getConcreteNumberTrivia(tnumber);
        //assert
        expect(response, right(CacheFaliure()));
        verify(() => mockLocalDataSource.getLastNumberTrivia());
      });
    });
  });
}

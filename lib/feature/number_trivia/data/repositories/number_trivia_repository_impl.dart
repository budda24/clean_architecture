// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:clean_archtecture/core/error/exception.dart';
import 'package:dartz/dartz.dart';

import 'package:clean_archtecture/core/platform/network_info.dart';
import 'package:clean_archtecture/feature/number_trivia/data/datasource/number_trivia_local_data_source.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/repositories/number_trivia_repository.dart';
import '../datasource/number_trivia_remote_data_source.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaLocalDataSource localDataSource;
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  NumberTriviaRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    if (await networkInfo.isConnected) {
      try {
        var remoteNumberTrivia =
            await remoteDataSource.getConcreteNumberTrivia(number);
        await localDataSource.cacheNumberTrivia(remoteNumberTrivia);
        return right(remoteNumberTrivia);
      } on ServerException {
        return left(ServerFaliure());
      }
    } else {
      return right(await localDataSource.getLastNumberTrivia());
    }
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() {
    // TODO: implement getRandomNumberTrivia
    return Future.value(right(NumberTrivia(text: '', number: 1)));
  }
}

import 'package:flutter_tdd/src/core/error/exceptions.dart';
import 'package:flutter_tdd/src/core/network/network_info.dart';
import 'package:flutter_tdd/src/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_tdd/src/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_tdd/src/domain/entities/number_trivia.dart';
import 'package:flutter_tdd/src/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_tdd/src/domain/repositories/number_trivia_repository.dart';
import 'package:meta/meta.dart';

// typedef Future<NumberTrivia> _ConcreteOrRandomChoose();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia(
      () => remoteDataSource.getConcreteNumberTrivia(number),
    );
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(
      () => remoteDataSource.getRandomNumberTrivia(),
    );
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      Future<NumberTrivia> Function() getConcreteOrRandom) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}

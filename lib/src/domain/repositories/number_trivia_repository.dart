import 'package:dartz/dartz.dart';
import 'package:flutter_tdd/src/core/error/failures.dart';
import 'package:flutter_tdd/src/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}

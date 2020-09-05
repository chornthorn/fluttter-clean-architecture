import 'package:dartz/dartz.dart';
import 'package:flutter_tdd/src/core/error/failures.dart';
import 'package:flutter_tdd/src/core/usecases/usecase.dart';
import 'package:flutter_tdd/src/domain/entities/number_trivia.dart';
import 'package:flutter_tdd/src/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);
  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }
}



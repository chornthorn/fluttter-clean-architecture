import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tdd/src/core/error/failures.dart';
import 'package:flutter_tdd/src/core/usecases/usecase.dart';
import 'package:flutter_tdd/src/domain/entities/number_trivia.dart';
import 'package:flutter_tdd/src/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;
  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  Params({@required this.number}) : super([number]);
}

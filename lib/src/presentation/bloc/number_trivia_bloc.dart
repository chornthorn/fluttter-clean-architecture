import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tdd/src/core/error/failures.dart';
import 'package:flutter_tdd/src/core/usecases/usecase.dart';
import 'package:flutter_tdd/src/core/utils/input_convert.dart';
import 'package:flutter_tdd/src/domain/entities/number_trivia.dart';
import 'package:flutter_tdd/src/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_tdd/src/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConvert inputConvert;
  NumberTriviaBloc({
    @required GetConcreteNumberTrivia concreteNumberTrivia,
    @required GetRandomNumberTrivia randomNumberTrivia,
    @required this.inputConvert,
  })  : assert(concreteNumberTrivia != null),
        assert(randomNumberTrivia != null),
        assert(inputConvert != null),
        getConcreteNumberTrivia = concreteNumberTrivia,
        getRandomNumberTrivia = randomNumberTrivia;

  @override
  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither =
          inputConvert.stringToUnsignedInteger(event.numberString);

      yield* inputEither.fold(
        (l) async* {
          yield Error('invalid number');
        },
        (r) async* {
          yield Loading();
          final failureOrTrivia = await getConcreteNumberTrivia(
            Params(number: r),
          );
          yield* _eitherLoadedOrErrorState(failureOrTrivia);
        },
      );
    } else if (event is GetTriviaForRandomNumber) {
      yield Loading();
      final failureOrTrivia = await getRandomNumberTrivia(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrTrivia);
    }
  }

  Stream<NumberTriviaState> _eitherLoadedOrErrorState(
      Either<Failure, NumberTrivia> failureOrTrivia) async* {
    yield failureOrTrivia.fold(
      (l) => Error(_mapFailureToMessage(l)),
      (r) => Loaded(numberTrivia: r),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'server failure';
        break;
      case CacheFailure:
        return 'cache failure';
        break;
      default:
        return 'Unexpected error';
    }
  }
}

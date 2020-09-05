part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {}

class Empty extends NumberTriviaState {}

class Loading extends NumberTriviaState {}

class Loaded extends NumberTriviaState {
  final NumberTrivia numberTrivia;

  Loaded({@required this.numberTrivia});
}

class Error extends NumberTriviaState {
  final String message;

  Error(this.message);
}

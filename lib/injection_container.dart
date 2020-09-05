import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_tdd/src/core/network/network_info.dart';
import 'package:flutter_tdd/src/core/utils/input_convert.dart';
import 'package:flutter_tdd/src/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_tdd/src/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_tdd/src/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_tdd/src/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_tdd/src/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_tdd/src/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_tdd/src/presentation/bloc/number_trivia_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;
Future<void> init() async {
  //! feature - Number Trivia
  // bloc
  sl.registerFactory(
    () => NumberTriviaBloc(
      concreteNumberTrivia: sl(),
      randomNumberTrivia: sl(),
      inputConvert: sl(),
    ),
  );
  // use case
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  // repository
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // data
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(
      client: sl(),
    ),
  );
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );

  //! Core
  sl.registerLazySingleton(() => InputConvert());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  //! external
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}

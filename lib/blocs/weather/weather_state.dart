import 'package:equatable/equatable.dart';
import '../../models/weather_model.dart';

abstract class WeatherState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoadInProgress extends WeatherState {}

class WeatherLoadSuccess extends WeatherState {
  final Weather weather;

  WeatherLoadSuccess({required this.weather});

  @override
  List<Object?> get props => [weather];
}

class WeatherLoadFailure extends WeatherState {
  final String message;

  WeatherLoadFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

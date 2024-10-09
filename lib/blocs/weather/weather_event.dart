import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class WeatherRequested extends WeatherEvent {
  final String city;

  WeatherRequested({required this.city});

  @override
  List<Object> get props => [city];
}

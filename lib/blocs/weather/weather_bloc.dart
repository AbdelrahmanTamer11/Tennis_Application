import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/weather_model.dart';
import 'weather_event.dart';
import 'weather_state.dart';
import '../../services/weather_api_client.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherApiClient weatherApiClient;

  WeatherBloc({required this.weatherApiClient}) : super(WeatherInitial()) {
    on<WeatherRequested>((event, emit) async {
      emit(WeatherLoadInProgress());
      try {
        final Weather weather = await weatherApiClient.fetchWeather(event.city);
        emit(WeatherLoadSuccess(weather: weather));
      } catch (e) {
        emit(WeatherLoadFailure(message: e.toString()));
      }
    });
  }
}

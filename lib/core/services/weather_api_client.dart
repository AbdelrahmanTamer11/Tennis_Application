import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherApiClient {
  final http.Client httpClient;
  final apiKey = '4a083f1bef0b53aa5ba680a7b0ecfc16';

  WeatherApiClient({required this.httpClient});

  Future<Weather> fetchWeather(String city) async {
    final url = 'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric';
    final response = await httpClient.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Error fetching weather data with status: ${response.statusCode}');
    }

    return Weather.fromJson(jsonDecode(response.body));
  }
}

import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_api_client.dart';

class WeatherController extends ChangeNotifier {
  final WeatherApiClient apiClient;
  Weather? currentWeather;
  String errorMessage = '';
  bool isLoading = false;

  WeatherController({required this.apiClient});

  // Function to fetch weather data
  Future<void> fetchWeather(String city) async {
    isLoading = true;
    notifyListeners();  // Notify before the operation to show loading indicator
    try {
      currentWeather = await apiClient.fetchWeather(city);
      errorMessage = '';
    } catch (error) {
      errorMessage = error.toString();
      currentWeather = null;  // Reset the weather data on error
    } finally {
      isLoading = false;
      notifyListeners();  // Notify after the operation to update the UI
    }
  }
}

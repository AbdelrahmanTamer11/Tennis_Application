class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final List<Forecast> forecast;
  List<int> features;  // Feature flags for conditions

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.forecast,
    required this.features,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    List<int> features = [0, 0, 0, 0, 0]; // Initialize features for rainy, sunny, hot, mild, high humidity
    double temp = json['list'][0]['main']['temp'].toDouble();
    String desc = json['list'][0]['weather'][0]['description'].toLowerCase();

    if (desc.contains('rain')) features[0] = 1;
    if (desc.contains('clear')) features[1] = 1;
    if (temp > 30) features[2] = 1; // Consider hot weather as temperatures above 30°C
    if (temp >= 15 && temp <= 25) features[3] = 1; // Mild temperature range
    if (json['list'][0]['main']['humidity'] > 80) features[4] = 1; // High humidity condition

    List<Forecast> parsedForecasts = [];
    Set<DateTime> dates = Set();  // To track unique dates

    for (var data in json['list']) {
      Forecast forecast = Forecast.fromJson(data);
      DateTime date = DateTime(forecast.date.year, forecast.date.month, forecast.date.day);
      // Ensure each date is only added once and limit the forecasts to the next five days
      if (dates.length < 6 && !dates.contains(date)) {
        dates.add(date);
        parsedForecasts.add(forecast);
      }
    }

    return Weather(
      cityName: json['city']['name'],
      temperature: temp,
      description: desc,
      humidity: json['list'][0]['main']['humidity'],
      windSpeed: json['list'][0]['wind']['speed'].toDouble(),
      forecast: parsedForecasts,
      features: features,
    );
  }
}

class Forecast {
  final DateTime date;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;

  Forecast({
    required this.date,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      date: DateTime.parse(json['dt_txt']),
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
    );
  }
}

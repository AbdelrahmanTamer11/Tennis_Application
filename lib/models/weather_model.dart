class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final List<Forecast> forecast;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.forecast,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['city']['name'],
      temperature: json['list'][0]['main']['temp'].toDouble(),
      description: json['list'][0]['weather'][0]['description'],
      humidity: json['list'][0]['main']['humidity'],
      windSpeed: json['list'][0]['wind']['speed'].toDouble(),
      forecast: (json['list'] as List).map((data) => Forecast.fromJson(data)).toList(),
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

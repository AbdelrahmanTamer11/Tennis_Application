class Weather {
  final String cityName;
  final double temperature;
  final List<Forecast> forecast;

  Weather({required this.cityName, required this.temperature, required this.forecast});

  factory Weather.fromJson(Map<String, dynamic> json) {
    List<Forecast> forecasts = (json['list'] as List)
      .map((data) => Forecast.fromJson(data))
      .toList();
    return Weather(
      cityName: json['city']['name'],
      temperature: json['list'][0]['main']['temp'].toDouble(),
      forecast: forecasts,
    );
  }
}

class Forecast {
  final DateTime date;
  final double temperature;

  Forecast({required this.date, required this.temperature});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      date: DateTime.parse(json['dt_txt']),
      temperature: json['main']['temp'].toDouble(),
    );
  }
}

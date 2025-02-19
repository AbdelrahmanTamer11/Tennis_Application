import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/blocs/weather/weather_bloc.dart';
import '../../../core/blocs/weather/weather_event.dart';
import '../../../core/blocs/weather/weather_state.dart';
import '../../../core/models/weather_model.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityTextController = TextEditingController();
  String predictionMessage = '';

  void _fetchWeather() {
    context.read<WeatherBloc>().add(WeatherRequested(city: _cityTextController.text));
  }

  Future<void> _predictWeather(Weather weather) async {
    try {
      final url = Uri.parse('http://10.0.2.2:5001/predict'); 
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'features': weather.features}),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        final prediction = result['prediction'][0];
        setState(() {
          predictionMessage = prediction == 0 ? "You can play Today." : "You can't play Today.";
        });
      } else {
        setState(() {
          predictionMessage = 'Failed to fetch prediction.';
        });
      }
    } catch (e) {
      setState(() {
        predictionMessage = 'Error occurred while fetching prediction.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Information'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchWeather,
          ),
        ],
        backgroundColor: Colors.teal,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.webp'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 1.8, sigmaY: 1.8),
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextField(
                  controller: _cityTextController,
                  decoration: InputDecoration(
                    labelText: 'Enter City Name',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white24,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search, color: Colors.white),
                      onPressed: _fetchWeather,
                    ),
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  onSubmitted: (value) => _fetchWeather(),
                ),
                SizedBox(height: 20),
                BlocBuilder<WeatherBloc, WeatherState>(
                  builder: (context, state) {
                    if (state is WeatherLoadInProgress) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is WeatherLoadSuccess) {
                      return Column(
                        children: [
                          _buildWeatherInfo(state.weather),
                          ElevatedButton(
                            onPressed: () => _predictWeather(state.weather),
                            child: Text('AI Prediction'),
                          ),
                          Text(predictionMessage, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
                        ],
                      );
                    } else if (state is WeatherLoadFailure) {
                      return Text(
                        'Error: ${state.message}',
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      );
                    }
                    return Text(
                      'Enter a city to get the weather',
                      style: TextStyle(color: Colors.white, fontSize:  18),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherInfo(Weather weather) {
    return Card(
      color: Colors.white70,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.location_city, color: Colors.teal),
              title: Text(weather.cityName, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Current Temperature: ${weather.temperature.toStringAsFixed(1)}°C', style: TextStyle(color: Colors.black)),
            ),
            Text('Description: ${weather.description}'),
            Text('Humidity: ${weather.humidity}%'),
            Text('Wind Speed: ${weather.windSpeed} km/h'),
            Divider(),
            SizedBox(height: 20),
            Text(
              '5-Day Forecast:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(), // Disables scrolling within the ListView
              shrinkWrap: true, // Allows ListView to size itself according to its children
              itemCount: weather.forecast.length,
              itemBuilder: (context, index) {
                final forecast = weather.forecast[index];
                return ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text(
                    '${forecast.date.month}/${forecast.date.day}: ${forecast.temperature.toStringAsFixed(1)}°C',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${forecast.description}, Humidity: ${forecast.humidity}%, Wind: ${forecast.windSpeed} km/h'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

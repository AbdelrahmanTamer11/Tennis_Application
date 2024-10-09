import 'package:flutter/material.dart';
import 'dart:ui' as ui; // Import this for ImageFilter
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/weather/weather_bloc.dart';
import '../../blocs/weather/weather_event.dart';
import '../../blocs/weather/weather_state.dart';
import '../../models/weather_model.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _cityTextController = TextEditingController();

  void _fetchWeather() {
    // Dispatching WeatherRequested event to fetch weather
    context.read<WeatherBloc>().add(WeatherRequested(city: _cityTextController.text));
  }

  @override
  void initState() {
    super.initState();
    // Example to fetch weather on screen load if needed
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Screen'),
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
                color: Colors.black12.withOpacity(0.5),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _cityTextController,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Enter City Name',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 7.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search, color: Colors.white),
                      onPressed: _fetchWeather,
                    ),
                  ),
                  onSubmitted: (value) => _fetchWeather(),
                ),
                SizedBox(height: 20),
                BlocBuilder<WeatherBloc, WeatherState>(
                  builder: (context, state) {
                    if (state is WeatherLoadInProgress) {
                      return CircularProgressIndicator();
                    } else if (state is WeatherLoadSuccess) {
                      return _buildWeatherInfo(state.weather);
                    } else if (state is WeatherLoadFailure) {
                      return Text(
                        'Error: ${state.message}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      );
                    }
                    return Container(); // Default empty container for initial state
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
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.location_city),
              title: Text(weather.cityName),
              subtitle: Text('Current Temperature'),
            ),
            Divider(),
            Text(
              '${weather.temperature.toStringAsFixed(1)} °C',
              style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
            ),
            Divider(),
            Text(
              '5-Day Forecast:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: weather.forecast.length,
              itemBuilder: (context, index) {
                final forecast = weather.forecast[index];
                return ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text('${forecast.date}'),
                  trailing: Text('${forecast.temperature.toStringAsFixed(1)} °C'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

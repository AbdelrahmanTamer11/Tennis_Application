import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../services/weather_api_client.dart';
import '../blocs/weather/weather_bloc.dart';
import '../../features/weather/presentation/weather_screen.dart';

Widget signUpButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Create an instance of WeatherApiClient
        final WeatherApiClient apiClient = WeatherApiClient(httpClient: http.Client());
        // Navigate to WeatherScreen with WeatherBloc
        Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                  create: (context) => WeatherBloc(weatherApiClient: apiClient),
                                  child: WeatherScreen(),
                              ),
                            ));
      },
      child: Text(
        'Sign Up',
        style: TextStyle(
          color: Colors.black, // Set your desired color here
          fontSize: 16,  // Optional: Change font size as needed
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.teal[400],
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';  // Include this for ImageFilter
import 'dart:ui';  // Include this for ImageFilter
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tennis_application/core/blocs/weather/weather_bloc.dart';
import 'package:tennis_application/core/services/weather_api_client.dart';
import 'package:tennis_application/features/signup/presentation/siginup_screen.dart';
import 'package:tennis_application/features/weather/presentation/weather_screen.dart';

import '../../../core/widgets/reusable_text_for_signin.dart';
import '../../../core/widgets/signin_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _userTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.webp"),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1.8, sigmaY: 1.8),
              child: Container(
                color: Colors.black.withOpacity(0),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 50.0,
                          backgroundImage: AssetImage('assets/logo_copy.png'),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          'ACE APP',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        reusableTextField("Enter Username", Icons.person_outline, false, _userTextController),
                        SizedBox(height: 20.0),
                        reusableTextField("Enter Password", Icons.lock_outline, true, _passwordTextController),
                        SizedBox(height: 20.0),
                        SignInSignUpButton(context, true, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (_) => WeatherBloc(weatherApiClient: WeatherApiClient(httpClient: http.Client())),
                                child: WeatherScreen(),
                              ),
                            ),
                          );
                        }),
                        SizedBox(height: 10.0),
                        signUpOption(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(color: Colors.grey),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tennis_application/features/signin/presentation/signin_screen.dart';
import 'dart:ui';


import '../../../core/widgets/reusable_text_for_signup.dart';
import '../../../core/widgets/signup_button.dart';  // Include this for ImageFilter


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _userTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _confirmPasswordTextController = TextEditingController();

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
                        Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        reusableTextField("Enter UserName", Icons.person, false, _userTextController),
                        SizedBox(height: 20.0),
                        reusableTextField("Enter Email", Icons.email, false, _emailTextController),
                        SizedBox(height: 20.0),
                        reusableTextField("Enter Password", Icons.lock_outline, true, _passwordTextController),
                        SizedBox(height: 20.0),
                        reusableTextField("Confirm Password", Icons.lock_outline, true, _confirmPasswordTextController),
                        SizedBox(height: 20.0),
                        signUpButton(context),
                        SizedBox(height: 10.0),
                        switchToSignIn(),
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
  Widget switchToSignIn() {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen()));
      },
      child: Text(
        'Already have an account? Sign In',
        style: TextStyle(
          color: Colors.teal,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

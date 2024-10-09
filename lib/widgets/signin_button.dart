import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget SignInSignUpButton(BuildContext context, bool isLogin, Function onTap) {
    return ElevatedButton(
      onPressed: () => onTap(),
      child: Text(
        isLogin ? 'Log In' : 'Sign Up',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
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
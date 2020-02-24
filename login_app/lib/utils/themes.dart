import 'package:flutter/material.dart';

import 'package:login_app/constants.dart';

final ThemeData lightTheme = ThemeData(
  backgroundColor: lightBackgroundColor,
  scaffoldBackgroundColor: lightBackgroundColor,
  typography: Typography(
    englishLike: Typography.englishLike2018,
    dense: Typography.dense2018,
    tall: Typography.tall2018,
  ),
  textTheme: TextTheme(
    display1: TextStyle(
      fontFamily: 'FredokaOne',
      color: Color(0xff011f4b),
      fontSize: 32.0,
    ),
    headline: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 24.0,
      color: Colors.black.withOpacity(0.65),
    ),
    title: TextStyle(
      fontFamily: 'RobotoMedium',
      fontSize: 20.0,
      color: Colors.black.withOpacity(0.65),
    ),
    subhead: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 16.0,
      color: Colors.black.withOpacity(0.65),
    ),
    body2: TextStyle(
      fontFamily: 'RobotoMedium',
      fontSize: 14.0,
      color: Colors.black.withOpacity(0.65),
    ),
    body1: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 14.0,
      color: Colors.black.withOpacity(0.65),
    ),
    display2: TextStyle(
      fontSize: 16.0,
      fontFamily: 'Math',
      fontWeight: FontWeight.w700,
      color: Colors.black.withOpacity(0.65),
    ),
    display3: TextStyle(
      fontSize: 18.0,
      fontFamily: 'Math',
      fontWeight: FontWeight.w700,
      color: Colors.black.withOpacity(0.65),
    ),
  ),
);

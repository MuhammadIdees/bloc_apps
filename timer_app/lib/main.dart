import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer_app/data/ticker.dart';
import 'package:timer_app/bloc/bloc.dart';
import 'package:timer_app/ui/timer_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timer App',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(109, 234, 255, 1),
        accentColor: Color.fromRGBO(72, 74, 126, 1),
      ),
      home: BlocProvider(
        create: (context) => TimerBloc(ticker: Ticker()),
        child: TimerScreen(),
      ),
    );
  }
}
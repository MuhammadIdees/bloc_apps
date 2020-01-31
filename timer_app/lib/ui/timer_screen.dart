import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:timer_app/bloc/bloc.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[


          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 100.0),
                child: BlocBuilder<TimerBloc, TimerState>(
                  builder: (context, state){
                    final String minutesStr = ((state.duration / 60) % 60).floor().toString().padLeft(2, '0');
                    final String secondsStr = (state.duration % 60).floor().toString().padLeft(2, '0');

                    return Text(
                      '$minutesStr:$secondsStr',
                      style: timerTextStyle,
                    );
                  },
                ),
              ),

              BlocBuilder<TimerBloc, TimerState>(
                condition: (previousState, state) => state.runtimeType != previousState.runtimeType,
                builder: (context, state) => Actions(),
              ),

              Flexible(child: Background()),

            ],
          ),
        ],
      ),
    );
  }
}

class Actions extends StatelessWidget {
  const Actions({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _mapStateToActionButtons(
        timerBloc: BlocProvider.of<TimerBloc>(context),
      ),
    );
  }

  List<Widget> _mapStateToActionButtons({TimerBloc timerBloc}){
    final TimerState currentState = timerBloc.state;

    if (currentState is Ready) {
      return [
        FloatingActionButton(
          child: Icon(Icons.play_arrow),
          onPressed: () => timerBloc.add(Start(duration: currentState.duration)),
        ),
      ];
    }

    if (currentState is Running){
      return [
        FloatingActionButton(
          child: Icon(Icons.pause),
          onPressed: () => timerBloc.add(Pause())
        ),
        FloatingActionButton(
          child: Icon(Icons.replay),
          onPressed: () => timerBloc.add(Reset())
        ),
      ];
    }

    if (currentState is Paused) {
      return [
        FloatingActionButton(
          child: Icon(Icons.play_arrow),
          onPressed: () => timerBloc.add(Resume()),
        ),
        FloatingActionButton(
          child: Icon(Icons.replay),
          onPressed: () => timerBloc.add(Reset()),
        ),
      ];
    }
 
    if (currentState is Finished) {
      return [
        FloatingActionButton(
          child: Icon(Icons.replay),
          onPressed: () => timerBloc.add(Reset()),
        ),
      ];
    }

    return [];
  }
}

const TextStyle timerTextStyle = TextStyle(
  fontSize: 60.0,
  fontWeight: FontWeight.w500,
);

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WaveWidget(
      config: CustomConfig(
        gradients: [
          [
            Color.fromRGBO(72, 74, 126, 1),
            Color.fromRGBO(125, 170, 206, 1),
            Color.fromRGBO(184, 189, 245, 0.7)
          ],
          [
            Color.fromRGBO(72, 74, 126, 1),
            Color.fromRGBO(125, 170, 206, 1),
            Color.fromRGBO(172, 182, 219, 0.7)
          ],
          [
            Color.fromRGBO(72, 73, 126, 1),
            Color.fromRGBO(125, 170, 206, 1),
            Color.fromRGBO(190, 238, 246, 0.7)
          ],
        ],
        durations: [19440, 10800, 6000],
        heightPercentages: [0.03, 0.01, 0.02],
        gradientBegin: Alignment.bottomCenter,
        gradientEnd: Alignment.topCenter,
      ),
      size: Size(double.infinity, 150.0),
      waveAmplitude: 25,
    );
  }
}
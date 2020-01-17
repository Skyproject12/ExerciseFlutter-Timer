import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer/Bloc/TimeBloc.dart';
import 'package:timer/Bloc/TimeEvent.dart';
import 'package:timer/Bloc/TimerState.dart';
import 'package:timer/Ticker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => TimerBloc(ticker: Ticker()),
        child: Timer(),
      ),
    );
  }
}

class Timer extends StatelessWidget {
  static const TextStyle timeTextStyle =
      TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter Timer")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // menampilkan result
          Padding(
            padding: EdgeInsets.symmetric(vertical: 100.0),
            child: Center(
              child: BlocBuilder<TimerBloc, TimerState>(
                builder: (context, state) {
                  // format of the time to minutest second
                  final String minutesStr = ((state.duration / 60) % 60)
                      .floor()
                      .toString()
                      .padLeft(2, '0');
                  final String secondStr =
                      (state.duration % 60).floor().toString().padLeft(2, '0');
                  return Text(
                    // set text format and the result of timer
                    '$minutesStr:$secondStr',
                    style: Timer.timeTextStyle,
                  );
                },
              ),
            ),
          ),

          // menampilkan button
          BlocBuilder<TimerBloc, TimerState>(
            condition: (previousState, state) =>
                state.runtimeType != previousState.runtimeType,
            builder: (contexxt, state) => Action(),
          )
        ],
      ),
    );
  }
}

class Action extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: mapStateToActionButtons(
        timerBloc: BlocProvider.of<TimerBloc>(context),
      ),
    );
  }

  List<Widget> mapStateToActionButtons({
    TimerBloc timerBloc,
  }) {
    // dafination TimerState from timerBloc
    final TimerState currentState = timerBloc.state;
    if (currentState is Ready) {
      return [
        // tampilkan floatingactionbutton
        FloatingActionButton(
          child: Icon(Icons.play_arrow),
          onPressed: () =>
              timerBloc.add(Start(duration: currentState.duration)),
        )
      ];
    }
    // state sekarang running
    if (currentState is Running) {
      return [
        FloatingActionButton(
          child: Icon(Icons.pause),
          onPressed: () => timerBloc.add(Pause()),
        ),
        // ketika button replay di klik
        FloatingActionButton(
          child: Icon(Icons.replay),
          // set timerBloc reset
          onPressed: () => timerBloc.add(Reset()),
        )
      ];
    } 
    if(currentState is Paused){ 
      return [ 
        FloatingActionButton( 
          child: Icon(Icons.play_arrow), 
          onPressed: () => timerBloc.add(Resume()),
        ), 
        FloatingActionButton( 
          child: Icon(Icons.replay), 
          onPressed: () => timerBloc.add(Reset()),
        )
      ];
    }
    // ketika button finish
    if (currentState is Finished) {
      return [
        FloatingActionButton(
          child: Icon(Icons.replay),
          // set timerBloc reset
          onPressed: () => timerBloc.add(Reset()),
        )
      ];
    }
    // selain itu maka jalankan kosong
    return [];
  }
}

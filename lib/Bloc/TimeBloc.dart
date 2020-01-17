import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer/Bloc/TimeEvent.dart';
import 'package:timer/Ticker.dart';
import 'TimerState.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  // initial of ticker
  final Ticker tiker;
  final int duration = 60;
  StreamSubscription<int> tikerSubscription;
  TimerBloc({@required Ticker ticker})
      : assert(ticker != null),
        tiker = ticker;

  @override
  // initial awal
  // TODO: implement initialState
  get initialState => Ready(duration);

  @override
  Stream<TimerState> mapEventToState(TimerEvent event) async* {
    // TODO: implement mapEventToState
    // start the state
    if (event is Start) {
      yield* mapStartToState(event);
    } 
    else if(event is Pause){ 
      yield* mapPauseToState(event);
    } 
    else if(event is Resume){ 
      yield* mapResumeToState(event);
    } 
    else if(event is Reset){  
      // call the fungsion reset  
      yield* mapResetToState(event);
    }
    // jika tick sudah siap dijalankan
    else if (event is Tick) {
      yield* mapTickToState(event);
    }
  }

// memberhentika suatu tikerSubcription
  @override
  Future<void> close() {
    tikerSubscription?.cancel();
    return super.close();
  }

  Stream<TimerState> mapStartToState(Start start) async* {
    yield Running(start.duration);
    tikerSubscription = tiker
        .tick(ticks: start.duration)
        .listen((duration) => add(Tick(duration: duration)));
  }

// make parameter from TimeEvent
  Stream<TimerState> mapTickToState(Tick tick) async* {
    // mengecek ketika durasi lebih dari 0 maka jalankan running selian itu jalankan finish
    yield tick.duration > 0 ? Running(tick.duration) : Finished();
  } 
  Stream<TimerState> mapPauseToState(Pause pause) async* { 
    // ketika state running 
    if(state is Running){ 
      tikerSubscription?.pause(); 
      // menampilkan fungsi dari TimerState  
      yield Paused(state.duration);
    }
  }

// 
  Stream<TimerState> mapResumeToState(Resume  pause) async* {  
    // if(state sama dengan status pause)
    if(state is Paused){ 
      tikerSubscription?.resume(); 
      yield Running(state.duration);
    }
  }

  Stream<TimerState> mapResetToState(Reset reset) async*{ 
    // memberhentikan subscription 
    tikerSubscription?.cancel(); 
    // set duration ready to running 
    yield Ready(duration);
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
abstract class TimerState extends Equatable{ 
  final int duration; 
  const TimerState(this.duration); 
  @override 
  List<Object> get props => [duration];
}  
// menampilkan durasi ketika ready
class Ready extends TimerState{
  Ready(int duration) : super(duration); 
  @override 
  String toString() => 'Ready {duration: $duration}';
}
// menampilkan fungsi ketika status pause  
class Paused extends TimerState{
  Paused(int duration) : super(duration);  
  @override 
  String toString() => 'Paused {duration: $duration}';
} 
// ketika fungsi masih melakukan running
class Running extends TimerState{
  Running(int duration) : super(duration); 
  @override 
  String toString() => 'Running {duration : $duration}';
}  
// ketika fungsi finish
class Finished extends TimerState { 
  // reset the timer 
  Finished() : super(0);  
}

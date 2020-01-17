import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class TimerEvent extends Equatable{ 
  const TimerEvent(); 
  @override 
  List<Object> get props => [];
}  
// inform time to start the timer
class Start extends TimerEvent{ 
  final int duration; 
  const Start({@required this.duration}); 
  @override 
  String toString() => "String {duration : $duration}";
} 
class Pause extends TimerEvent{ 

} 
class Resume extends TimerEvent { 

} 
class Reset extends TimerEvent { 

} 
// infomation bahwa tick sudah dapat di jalankan 
class Tick extends TimerEvent{ 
  final int  duration; 
  const Tick({ 
    @required this.duration
  }); 
  @override 
  List<Object> get props => [duration]; 

  @override 
  String toString() => "Tick {duration: $duration}";
}
import 'package:flutter_bloc/flutter_bloc.dart';

/// We need to specify the events that are going to take place
/// when the app is used. In out counter app their are only two
/// events so we'll use an enum
/// 
/// increment: for incrementing count
/// decrement: for decrementing count

enum CounterEvent { increment, decrement }

/// The bloc will react on those events and update the state occordingly
/// 
/// Here we can get away with using int else we would neet to create a seperate class

class CounterBloc extends Bloc<CounterEvent, int> {

  // Sets the initial state 
  @override
  int get initialState => 0;

  // Changes the state as the change events occur
  @override
  Stream<int> mapEventToState(CounterEvent event) async* {
    switch (event) {
      case CounterEvent.increment:
        yield state + 1;
        break;
      case CounterEvent.decrement:
        yield state - 1;
        break;
    }
  }
  
}
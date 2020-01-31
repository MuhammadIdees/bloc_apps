import 'package:counter_app/counter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final CounterBloc counterBloc = BlocProvider.of<CounterBloc>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Counter App')),
      body: BlocBuilder<CounterBloc, int>(
        builder: (context, count){
          return Center(
            child: Text(
              "$count",
              style: TextStyle(fontSize: 32.0),
            ),
          );
        },
      ),

      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(4.0),
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: (){
                counterBloc.add(CounterEvent.increment);
              }
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.0),
            child: FloatingActionButton(
              child: Icon(Icons.remove),
              onPressed: (){
                counterBloc.add(CounterEvent.decrement);
              }
            ),
          ),
        ],
      ),
    );
  }
}
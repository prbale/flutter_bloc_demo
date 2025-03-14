import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_demo/bloc/internet_bloc.dart';
import 'package:my_demo/bloc/internet_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(child:
            BlocBuilder<InternetBloc, InternetState>(builder: (context, state) {
          if (state is InternetGainedState) {
            return Text('Internet is connected');
          } else if (state is InternetLostState) {
            return Text('Internet is Lost');
          } else {
            return Text('Loading...');
          }
        })),
      ),
    );
  }
}

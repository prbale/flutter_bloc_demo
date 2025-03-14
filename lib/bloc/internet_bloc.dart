import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_demo/bloc/internet_event.dart';
import 'package:my_demo/bloc/internet_state.dart';
import 'package:connectivity/connectivity.dart';

// Step 1: Define the InternetBloc class
// This class extends Bloc, where the first type parameter represents events (InternetEvent)
// and the second type represents states (InternetState). It's responsible for managing
// the connectivity-related state changes.
class InternetBloc extends Bloc<InternetEvent, InternetState> {
  // Step 2: Declare the Connectivity instance to monitor network status
  final Connectivity _connectivity = Connectivity();

  // Step 3: Declare a StreamSubscription to listen to connectivity changes
  StreamSubscription? connectivitySubscription;

  // Constructor: Initializes the Bloc with an initial state (InternetInitialState) and
  // listens to InternetGainedEvent and InternetLostEvent events to update the state.
  InternetBloc() : super(InternetInitialState()) {
    // Step 4: Handling InternetGainedEvent
    // When the event InternetGainedEvent is added, we emit a new state
    // InternetGainedState, indicating that the device has gained internet access.
    on<InternetGainedEvent>((event, emit) {
      emit(InternetGainedState());
    });

    // Step 5: Handling InternetLostEvent
    // When the event InternetLostEvent is added, we emit a new state InternetLostState,
    // indicating that the device has lost internet access.
    on<InternetLostEvent>((event, emit) {
      emit(InternetLostState());
    });

    // Step 6: Monitor connectivity changes
    // Here, we subscribe to the onConnectivityChanged stream provided by
    // the Connectivity plugin, which gives us real-time updates on the device's
    // internet connection (e.g., mobile data, Wi-Fi, or no connection).
    connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        add(InternetGainedEvent());
      } else {
        add(InternetLostEvent());
      }
    });
  }

  // Step 7: Clean up the subscription when the Bloc is closed
  // It's essential to cancel the StreamSubscription in the close() method
  // to prevent memory leaks, as the subscription will no longer be needed
  // once the Bloc is disposed of.
  @override
  Future<void> close() {
    connectivitySubscription?.cancel();
    return super.close();
  }
}

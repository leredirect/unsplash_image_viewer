import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meta/meta.dart';

part 'connection_event.dart';

part 'connection_state.dart';

class ConnectivityBloc extends Bloc<ConnectionEvent, ConnectivityState> {
  ConnectivityBloc() : super(ConnectionInitial()) {
    on<NoConnectionEvent>(_onNoConnection);
    on<HasConnectionEvent>(_onHasConnection);
    on<CheckConnectionEvent>(_onCheckConnection);
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        print("NOOOOOOO");
        add(NoConnectionEvent());
      } else {
        print("true");
        add(HasConnectionEvent());
      }
    });
  }

  void _onNoConnection(
      NoConnectionEvent event, Emitter<ConnectivityState> emit) {
    emit(NoConnectionState());
  }

  void _onHasConnection(
      HasConnectionEvent event, Emitter<ConnectivityState> emit) {
    emit(HasConnectionState());
  }

  Future<void> _onCheckConnection(
      CheckConnectionEvent event, Emitter<ConnectivityState> emit) async  {

    ConnectivityResult result = await Connectivity().checkConnectivity();

    if (result == ConnectivityResult.none) {
      print("NOOOOOOO");
      add(NoConnectionEvent());
    } else {
      print("true");
      add(HasConnectionEvent());
    }
  }
}

part of 'connection_bloc.dart';

@immutable
abstract class ConnectivityState {}

class ConnectionInitial extends ConnectivityState {}

class HasConnectionState extends ConnectivityState {}

class NoConnectionState extends ConnectivityState {}

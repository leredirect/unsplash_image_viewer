part of 'connection_bloc.dart';

@immutable
abstract class ConnectionEvent {}
class CheckConnectionEvent extends ConnectionEvent{}
class NoConnectionEvent extends ConnectionEvent{}
class HasConnectionEvent extends ConnectionEvent{}

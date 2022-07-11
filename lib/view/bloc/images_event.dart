part of 'images_bloc.dart';

@immutable
abstract class ImagesEvent {}

class ImagesGetInitialPageEvent extends ImagesEvent {}
class ImagesGetNextPageEvent extends ImagesEvent {}
class ImagesUpdateEvent extends ImagesEvent {}

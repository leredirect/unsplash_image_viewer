part of 'images_bloc.dart';

@immutable
abstract class ImagesState {}

class ImagesInitial extends ImagesState {}

class ImagesHasDataState extends ImagesState{

  final List<PhotoData> photoData;

  ImagesHasDataState({
    required this.photoData,
  });
}

class ImagesLoadingState extends ImagesState {}
class ImagesErrorState extends ImagesState {}
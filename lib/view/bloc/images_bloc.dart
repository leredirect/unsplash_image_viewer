import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:instant_image_viewer/core/repository/unsplash_repository.dart';
import 'package:meta/meta.dart';

import '../../core/model/photo_data.dart';

part 'images_event.dart';

part 'images_state.dart';

class ImagesBloc extends Bloc<ImagesEvent, ImagesState> {
  ImagesBloc() : super(ImagesInitial()) {
    on<ImagesGetInitialPageEvent>(_onGetInitialPage);
    on<ImagesGetNextPageEvent>(_onGetNextPage);
    on<ImagesUpdateEvent>(_onUpdatePage);
  }

  int page = 1;

  Future<void> _onGetInitialPage(
      ImagesGetInitialPageEvent event, Emitter<ImagesState> emit) async {
    emit(ImagesLoadingState());
    try {
      List<PhotoData> data = await UnsplashRepository().get(page: page);
      emit(ImagesHasDataState(photoData: data));
      page++;
    } on Exception catch (e) {
      print("ERROR");
      emit(ImagesErrorState());
    }

  }

  Future<void> _onGetNextPage(
      ImagesGetNextPageEvent event, Emitter<ImagesState> emit) async {
    List<PhotoData> data = await UnsplashRepository().get(page: page);
    emit(ImagesHasDataState(photoData: data));
    page++;
  }

  Future<void> _onUpdatePage(
      ImagesUpdateEvent event, Emitter<ImagesState> emit) async {
    emit(ImagesLoadingState());
    page = 1;
    await Future.delayed(Duration(seconds: 1));
    UnsplashRepository().clearCache();
    List<PhotoData> data = await UnsplashRepository().get(page: page);
    emit(ImagesHasDataState(photoData: data));
    page++;
  }
}

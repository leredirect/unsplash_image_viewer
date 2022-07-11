import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/photo_data.dart';

class UnsplashRepository {
  static final UnsplashRepository _unsplashRepository =
      UnsplashRepository._internal();

  factory UnsplashRepository() {
    return _unsplashRepository;
  }

  UnsplashRepository._internal();


  List<PhotoData> _requestedData = [];

  void clearCache(){
    _requestedData.clear();
  }

  Future<List<PhotoData>> get({required int page}) async {
    try {
      var response = await http
          .get(Uri.parse("https://api.unsplash.com/photos?page=$page&per_page=30"), headers: {
        'Authorization': 'Client-ID ITDqfqwGi54v8AjVSxrKOx3ueyLqzQmCmmIgBn2mx1A',
      });


      List<dynamic> data = jsonDecode(response.body);

      List<PhotoData> photoData = [];

      for (var element in data) {
        photoData.add(PhotoData.fromJson(element));
      }

      _requestedData.addAll(photoData);

      return _requestedData;
    } on Exception catch (e) {
      print("cant reach api");
      throw Exception();
    }
  }
}

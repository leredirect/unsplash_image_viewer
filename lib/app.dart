import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instant_image_viewer/connection_bloc/connection_bloc.dart';
import 'package:instant_image_viewer/view/bloc/images_bloc.dart';
import 'package:instant_image_viewer/view/home_page.dart';
import 'package:instant_image_viewer/view/picture_view_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Instant Image Viewer",
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ImagesBloc()..add(ImagesGetInitialPageEvent()),
          ),
          BlocProvider(
            create: (context) => ConnectivityBloc()..add(CheckConnectionEvent()),
          ),
        ],
        child: SafeArea(child: const HomePage()),
      ),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case "/pictureView":
            return MaterialPageRoute(builder: (context) {
              return PictureViewPage(
                url: (settings.arguments as Map<String, dynamic>)["url"],
                hash: (settings.arguments as Map<String, dynamic>)["hash"],
                userImageUrl: (settings.arguments
                    as Map<String, dynamic>)["userImageUrl"],
                username:
                    (settings.arguments as Map<String, dynamic>)["username"],
                dominantColor: (settings.arguments
                    as Map<String, dynamic>)["dominantColor"],
              );
            });
        }
      },
      theme: ThemeData(primaryColor: Colors.black),
    );
  }
}

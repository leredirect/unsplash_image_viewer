import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

class PictureViewPage extends StatefulWidget {
  final String url;
  final String hash;
  final String username;
  final String userImageUrl;
  final Brightness dominantColor;

  const PictureViewPage(
      {Key? key,
      required this.url,
      required this.hash,
      required this.username,
      required this.userImageUrl,
      required this.dominantColor})
      : super(key: key);

  @override
  State<PictureViewPage> createState() => _PictureViewPageState();
}

class _PictureViewPageState extends State<PictureViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          InteractiveViewer(
            child: BlurHash(
              image: widget.url,
              hash: widget.hash,
              imageFit: BoxFit.cover,
            ),
          ),
          Positioned(
              child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 15,
              color: widget.dominantColor == Brightness.light
                  ? Colors.white.withOpacity(0.5)
                  : Colors.black.withOpacity(0.5),
              child: Row(
                children: [
                  ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: widget.userImageUrl,
                      placeholder: (context, str) => CircularProgressIndicator(
                          color: widget.dominantColor == Brightness.light
                              ? Colors.black
                              : Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    widget.username,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.5,
                        color: widget.dominantColor == Brightness.light
                            ? Colors.black
                            : Colors.white),
                  )
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:palette_generator/palette_generator.dart';

class ImageTileWidget extends StatefulWidget {
  final String hash;
  final String url;
  final double extent;
  final String username;
  final String userImageUrl;

  const ImageTileWidget(
      {Key? key,
      required this.url,
      required this.hash,
      required this.extent,
      required this.username,
      required this.userImageUrl})
      : super(key: key);

  @override
  State<ImageTileWidget> createState() => _ImageTileWidgetState();
}

class _ImageTileWidgetState extends State<ImageTileWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () async {
        final PaletteGenerator paletteGenerator =
            await PaletteGenerator.fromImageProvider(NetworkImage(widget.url));

        Brightness brightness = ThemeData.estimateBrightnessForColor(
            paletteGenerator.dominantColor!.color);

        Navigator.of(context).pushNamed("/pictureView", arguments: {
          "url": widget.url,
          "hash": widget.hash,
          "username": widget.username,
          "userImageUrl": widget.userImageUrl,
          "dominantColor": brightness
        });
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        height: widget.extent,
        child: BlurHash(
          image: widget.url,
          hash: widget.hash,
          imageFit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

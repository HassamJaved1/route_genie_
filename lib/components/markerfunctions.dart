import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  var codec = await instantiateImageCodec(
    data.buffer.asUint8List(),
    targetWidth: width,
  );
  FrameInfo frameInfo = await codec.getNextFrame();
  return (await frameInfo.image.toByteData(format: ImageByteFormat.png))!
      .buffer
      .asUint8List();
}

Future<BitmapDescriptor> loadCustomMarker(String imagePath) async {
  final Uint8List markerIconData = await getBytesFromAsset(
    imagePath,
    80, // Adjust the image size as needed
  );

  return BitmapDescriptor.fromBytes(markerIconData);
}

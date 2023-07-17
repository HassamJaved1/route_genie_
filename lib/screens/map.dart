import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();

  LatLng? currentLocation;
  late BitmapDescriptor locationIcon;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    loadCustomMarker('assets/images/breakdown.png').then((descriptor) {
      setState(() {
        locationIcon = descriptor;
      });
    });
    _getCurrentLocation();
  }

  //Function to find current location of user

  Future<void> _getCurrentLocation() async {
    bool? serviceEnabled;
    LocationPermission? permission;
    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    // Request permission to access location
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
      markers.add(
        Marker(
            markerId: const MarkerId("Current Location"),
            position: LatLng(
              currentLocation?.latitude ?? 0.0,
              currentLocation?.longitude ?? 0.0,
            ),
            infoWindow: const InfoWindow(
              title: "CURRENT LOCATION",
            ),
            icon: locationIcon),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return currentLocation == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(currentLocation?.latitude ?? 0,
                  currentLocation?.longitude ?? 0),
              zoom: 16,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: markers,
          );
  }
}

// THESE ARE THE TWO FUNCTIONS NECESSARY TO ADD CUSTOM MARKERS
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
    90, // Adjust the image size as needed
  );

  return BitmapDescriptor.fromBytes(markerIconData);
}

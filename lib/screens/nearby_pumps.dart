import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice_ex/places.dart';

class NearbyPumps extends StatefulWidget {
  const NearbyPumps({super.key});

  @override
  State<NearbyPumps> createState() => _NearbyPumps();
}

class _NearbyPumps extends State<NearbyPumps> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? _currentPosition;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _getNearbyMechanics();
  }

  void _getNearbyMechanics() async {
    bool serviceEnabled;
    LocationPermission permission;

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

    // Get the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    _currentPosition = LatLng(position.latitude, position.longitude);
    // Find nearby mechanics using Google Places API
    final places =
        GoogleMapsPlaces(apiKey: 'AIzaSyASziBp-JpfM8YegAESwlSaLk26y0U4J4I');
    final response = await places.searchNearbyWithRadius(
        Location(lat: position.latitude, lng: position.longitude), 10000,
        type: 'pumps');
// Add marker for users current location
    _markers.add(
      Marker(
        markerId: const MarkerId("Current Location"),
        position: LatLng(
          _currentPosition?.latitude ?? 0.0,
          _currentPosition?.longitude ?? 0.0,
        ),
        infoWindow: const InfoWindow(
          title: "You are here",
        ),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
    // Add markers for each nearby mechanic
    for (var result in response.results) {
      _markers.add(Marker(
        markerId: MarkerId(result.placeId),
        position: LatLng(result.geometry?.location.lat ?? 0.0,
            result.geometry?.location.lng ?? 0.0),
        infoWindow: InfoWindow(title: result.name, snippet: result.vicinity),
      ));
    }
    // Dispose the places object
    places.dispose();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPosition == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(_currentPosition?.latitude ?? 0,
                    _currentPosition?.longitude ?? 0),
                zoom: 16,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: _markers,
            ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart' as mode;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as p;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:google_maps_webservice_ex/places.dart';

import '../components/markerfunctions.dart';
import '../util/constants.dart';

class NearbyMechanics extends StatefulWidget {
  const NearbyMechanics({Key? key}) : super(key: key);

  @override
  _NearbyMechanicsState createState() => _NearbyMechanicsState();
}

class _NearbyMechanicsState extends State<NearbyMechanics> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? _currentPosition;
  final Set<Marker> _markers = {};
  List<PlacesSearchResult> _mechanics = [];
  late BitmapDescriptor locationIcon;
  late BitmapDescriptor mechanicsIcon;

  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  final Set<p.Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _getNearbyMechanics();
    loadCustomMarker('assets/images/breakdown.png').then((descriptor) {
      setState(() {
        locationIcon = descriptor;
      });
    });
    loadCustomMarker('assets/images/mechanic.png').then((descriptor) {
      setState(() {
        mechanicsIcon = descriptor;
      });
    });
  }

  void _getNearbyMechanics() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    _currentPosition = LatLng(position.latitude, position.longitude);

    final places =
        GoogleMapsPlaces(apiKey: 'AIzaSyASziBp-JpfM8YegAESwlSaLk26y0U4J4I');
    final response = await places.searchNearbyWithRadius(
        Location(lat: position.latitude, lng: position.longitude), 10000,
        type: 'car_repair');

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
        icon: locationIcon,
      ),
    );

    for (var result in response.results) {
      LatLng mechanicLocation = LatLng(
        result.geometry?.location.lat ?? 0.0,
        result.geometry?.location.lng ?? 0.0,
      );

      _markers.add(
        Marker(
          icon: mechanicsIcon,
          markerId: MarkerId(result.placeId),
          position: mechanicLocation,
          infoWindow: InfoWindow(
            title: result.name,
            snippet: result.vicinity ?? '',
          ),
        ),
      );

      PolylineResult? polylineResult =
          await polylinePoints.getRouteBetweenCoordinates(
        'AIzaSyASziBp-JpfM8YegAESwlSaLk26y0U4J4I',
        PointLatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        PointLatLng(mechanicLocation.latitude, mechanicLocation.longitude),
        travelMode: mode.TravelMode.driving,
      );

      if (polylineResult.status == 'OK' && polylineResult.points.isNotEmpty) {
        polylineCoordinates.clear();
        for (var point in polylineResult.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }

        p.Polyline polyline = p.Polyline(
          polylineId: PolylineId(result.placeId),
          points: polylineCoordinates,
          color: Colors.blue,
          width: 5,
        );

        _polylines.add(polyline);
      }

      setState(() {
        _mechanics = response.results;
      });
    }

    places.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: _currentPosition == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: kSecondaryColor,
                  pinned: false,
                  expandedHeight: 500,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          _currentPosition?.latitude ?? 0,
                          _currentPosition?.longitude ?? 0,
                        ),
                        zoom: 16,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      markers: _markers,
                      polylines: _polylines,
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      PlacesSearchResult? result = _mechanics[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        delay: const Duration(milliseconds: 100),
                        child: SlideAnimation(
                          duration: const Duration(milliseconds: 2500),
                          curve: Curves.fastLinearToSlowEaseIn,
                          child: FadeInAnimation(
                            curve: Curves.fastLinearToSlowEaseIn,
                            duration: const Duration(milliseconds: 2500),
                            child: Container(
                              margin: EdgeInsets.only(bottom: w / 20),
                              height: w / 4,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 40,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.location_on),
                                title: Text(result.name),
                                trailing: Text(
                                  result.rating?.toStringAsFixed(1) ?? "-",
                                ),
                                onTap: () {
                                  // Navigate to mechanic details page
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: _mechanics.length,
                  ),
                ),
              ],
            ),
    );
  }
}

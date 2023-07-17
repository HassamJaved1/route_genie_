import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../components/markerfunctions.dart';

class MechanicsMapScreen extends StatefulWidget {
  const MechanicsMapScreen({Key? key}) : super(key: key);

  @override
  State<MechanicsMapScreen> createState() => _MechanicsMapScreenState();
}

class _MechanicsMapScreenState extends State<MechanicsMapScreen> {
  late GoogleMapController mapController;
  List<Marker> markers = [];
  late BitmapDescriptor mechanicsIcon;
  late CustomInfoWindowController customInfoWindowController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  LatLng? position;

  void _fetchMechanicsData() {
    FirebaseFirestore.instance.collection('users').get().then(
      (QuerySnapshot snapshot) {
        setState(() {
          markers = snapshot.docs
              .where((doc) => doc['isMechanic'] == true)
              .map((DocumentSnapshot doc) {
            final mechanic = doc.data() as Map<String, dynamic>;
            position = LatLng(
              mechanic['businessAddressLatitude'] ?? 0.0,
              mechanic['businessAddressLongitude'] ?? 0.0,
            );

            return Marker(
              icon: mechanicsIcon,
              markerId: MarkerId(doc.id),
              position:
                  LatLng(position?.latitude ?? 0, position?.longitude ?? 0),
              onTap: () {
                customInfoWindowController.addInfoWindow!(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Name: ${mechanic['firstName'] ?? 'N/A'}'),
                      Text('Business: ${mechanic['businessName'] ?? 'N/A'}'),
                      Text('Email: ${mechanic['email'] ?? 'N/A'}'),
                      // Add more properties as desired
                    ],
                  ),
                  LatLng(position?.latitude ?? 0, position?.longitude ?? 0),
                );
              },
            );
          }).toList();
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    loadCustomMarker('assets/images/rgenie.png').then((descriptor) {
      setState(() {
        mechanicsIcon = descriptor;
      });
    });
    customInfoWindowController = CustomInfoWindowController();
    _fetchMechanicsData();
  }

  @override
  void dispose() {
    customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return position == null
        ? const Center(
            child: SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Mechanics Map'),
            ),
            body: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target:
                    LatLng(position?.latitude ?? 0, position?.longitude ?? 0),
                zoom: 12,
              ),
              markers: markers.toSet(),
              onTap: (LatLng latLng) {
                customInfoWindowController.hideInfoWindow!();
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                customInfoWindowController.hideInfoWindow!();
              },
              child: const Icon(Icons.close),
            ),
          );
  }
}

import 'package:floating_bottom_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_genie_/components/appbar.dart';
import 'package:route_genie_/screens/login_screen.dart';

import 'package:route_genie_/screens/nearby_hotels.dart';
import 'package:route_genie_/screens/nearby_mechanics.dart';
import 'package:route_genie_/screens/nearby_pumps.dart';
import 'package:url_launcher/url_launcher.dart';
import '../util/constants.dart';
import 'map.dart';

class HomeScreen extends StatefulWidget {
  final String firstName, lastName, email, phoneNumber, profilePicture;

  const HomeScreen(
      {super.key,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.phoneNumber,
      required this.profilePicture});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  LatLng? _currentLocation;

  bool? centerModelOpen;
  List<Widget> screensList = [
    const MapPage(),
    const NearbyMechanics(),
    const NearbyHotels(),
    const NearbyPumps()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: customAppBar(),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              children: [
                SizedBox(
                  height: 250,
                  child: DrawerHeader(
                    decoration: const BoxDecoration(
                      color: kSecondaryColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundImage: NetworkImage(widget.profilePicture),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${widget.firstName} ${widget.lastName}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.email,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.phoneNumber,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    // Handle navigation to settings
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout_outlined),
                  title: const Text('Logout'),
                  onTap: () {
                    // Handle navigation to settings

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                ),
              ],
            ),
          ),
          body: screensList[currentIndex],
          bottomNavigationBar: AnimatedBottomNavigationBar(
            bottomBarItems: [
              BottomBarItemsModel(
                icon: const Icon(
                  Icons.home,
                  size: 30,
                ),
                iconSelected: const Icon(
                  Icons.home,
                  color: kSecondaryColor,
                  size: 30,
                ),
                title: 'Home',
                dotColor: kSecondaryColor,
                onTap: () {
                  setState(() {
                    centerModelOpen = false;
                  });
                },
              ),
              BottomBarItemsModel(
                  icon: const Icon(
                    Icons.zoom_out_outlined,
                    size: 30,
                  ),
                  iconSelected: const Icon(Icons.zoom_out_outlined,
                      color: kSecondaryColor, size: 30),
                  title: 'Search',
                  dotColor: kSecondaryColor,
                  onTap: () {
                    setState(() {
                      centerModelOpen = false;
                    });
                  }),
              BottomBarItemsModel(
                icon: const Icon(
                  Icons.person,
                  size: 30,
                ),
                iconSelected:
                    const Icon(Icons.person, color: kSecondaryColor, size: 30),
                title: 'Profile',
                dotColor: kSecondaryColor,
                onTap: () {
                  setState(() {
                    centerModelOpen = false;
                  });
                },
              ),
              //this is the center button present in our bottom nav bar
              BottomBarItemsModel(
                icon: const Icon(
                  Icons.sos,
                ),
                iconSelected: const Icon(Icons.sos, color: kSecondaryColor),
                title: 'Help',
                dotColor: kSecondaryColor,
                onTap: () async {
                  setState(() async {
                    Position position = await Geolocator.getCurrentPosition(
                        desiredAccuracy: LocationAccuracy.high);
                    _currentLocation =
                        LatLng(position.latitude, position.longitude);

                    if (_currentLocation != null) {
                      String latitude = _currentLocation!.latitude.toString();
                      String longitude = _currentLocation!.longitude.toString();
                      String message =
                          'Help! I am in an emergency. My current location is: '
                          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

                      String url =
                          'whatsapp://send?text=${Uri.encodeComponent(message)}';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url));
                      } else {
                        // ignore: avoid_print
                        print('Could not launch WhatsApp.');
                      }
                    } else {
                      // ignore: avoid_print
                      print('Location not available.');
                    }

                    centerModelOpen = false;
                  });
                },
              ),
            ],
            bottomBarCenterModel: BottomBarCenterModel(
              centerBackgroundColor: kButton,
              centerIcon: const FloatingCenterButton(
                child: Icon(
                  Icons.car_crash_rounded,
                  color: AppColors.white,
                  size: 32,
                ),
              ),
              centerIconChild: [
                FloatingCenterButtonChild(
                  child: Column(
                    children: const [
                      Icon(
                        Icons.build,
                        color: AppColors.white,
                      ),
                      Text(
                        "Nearby Mechanics",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 6.5),
                      ),
                    ],
                  ),
                  onTap: () {
                    //Apply logic of showNearbyMechanics
                    setState(() {
                      currentIndex = 1;
                    });
                  },
                ),
                FloatingCenterButtonChild(
                  child: Column(
                    children: const [
                      Icon(
                        Icons.local_hotel_rounded,
                        color: AppColors.white,
                      ),
                      Text(
                        "Nearby Hotels",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 6.5),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      currentIndex = 2;
                    });
                  },
                ),
                FloatingCenterButtonChild(
                  child: Column(
                    children: const [
                      Icon(
                        Icons.local_gas_station_rounded,
                        color: AppColors.white,
                      ),
                      Text(
                        "Nearby Pumps",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 6.5),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      currentIndex = 3;
                    });
                  },
                ),
              ],
            ),
          )),
    );
  }
}

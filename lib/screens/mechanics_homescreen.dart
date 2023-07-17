// ignore_for_file: avoid_print

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:route_genie_/components/appbar.dart';
import 'package:route_genie_/screens/login_screen.dart';
import 'package:route_genie_/screens/mechanic_map.dart';
import 'package:route_genie_/util/constants.dart';

import '../components/covercard.dart';
import '../components/promocard.dart';

class MechanicsHomepage extends StatefulWidget {
  final String businessName,
      firstName,
      email,
      phoneNumber,
      lastName,
      profilePicture;
  final double latitude, longitude;

  const MechanicsHomepage(
      {super.key,
      required this.profilePicture,
      required this.lastName,
      required this.firstName,
      required this.latitude,
      required this.longitude,
      required this.businessName,
      required this.email,
      required this.phoneNumber});

  @override
  State<MechanicsHomepage> createState() => _MechanicsHomepageState();
}

class _MechanicsHomepageState extends State<MechanicsHomepage> {
  late String word;
  late VoidCallback function;

  @override
  Widget build(BuildContext context) {
    final List<String> imageUrls = [
      'assets/images/mechanicsmap.png',
      'assets/images/i.jpg',
      'assets/images/final.png'
    ];
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
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
                          "${widget.firstName}${widget.lastName}",
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
                        const SizedBox(height: 5),
                        Text(
                          widget.businessName,
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
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () {
                    // Handle navigation to home
                  },
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
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(30))),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Welcome To Your Store ',
                          style: TextStyle(color: Colors.black87, fontSize: 25),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          widget.firstName,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(244, 243, 243, 1),
                              borderRadius: BorderRadius.circular(15)),
                          child: const TextField(
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.black87,
                                ),
                                hintText: "Search you're looking for",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 15)),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.businessName,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          height: 200,
                          child: CarouselSlider.builder(
                            itemCount: imageUrls.length,
                            itemBuilder: (BuildContext context, int index,
                                int realIndex) {
                              if (index == 0) {
                                word = 'Access Your Store 🔧';
                                function = () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return const MechanicsMapScreen();
                                  }));
                                };
                              } else if (index == 1) {
                                word = 'My Basic Services 👨‍🔧';
                                function = () {};
                              } else {
                                word = 'Think Later';

                                function = () {
                                  setState(() {});
                                };
                              }
                              return Row(children: [
                                PromoCard(
                                  text: word,
                                  onTap: function,
                                  image: imageUrls[index],
                                )
                                // PromoCard(
                                //     imageUrls[index], word, function, context),
                              ]);
                            },
                            options: CarouselOptions(
                              height: 300,
                              enableInfiniteScroll: true,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        coverCard('assets/images/final.png'),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

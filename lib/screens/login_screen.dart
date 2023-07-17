// ignore_for_file: avoid_pri, avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:route_genie_/components/button.dart';
import 'package:route_genie_/components/fade_transition.dart';
import 'package:route_genie_/screens/home_screen.dart';
import 'package:route_genie_/screens/mechanics_homescreen.dart';

import '../components/input.dart';
import '../util/constants.dart';

void main(List<String> args) {
  runApp(const LoginScreen());
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Screen(),
    );
  }
}

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  TextEditingController loginEmail = TextEditingController();
  TextEditingController loginPassword = TextEditingController();
  bool isLoadingEnabled = false;
  Map<String, dynamic>? userData;

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      // Check if the user exists in the Firestore database
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.size == 1) {
        // User exists, now check if the password matches
        String userId = querySnapshot.docs[0].id;
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        userData = userSnapshot.data() as Map<String, dynamic>;
        if (userData!.containsKey('password')) {
          String storedPassword = userData!['password'];
          // Rest of your code...
          if (storedPassword == password) {
            // Password matches, perform login
            if (querySnapshot.docs.isNotEmpty) {
              String firstName = querySnapshot.docs.first.get('firstName');
              String lastName = querySnapshot.docs.first.get('lastName');
              String email = querySnapshot.docs.first.get('email');
              String phoneNumber = querySnapshot.docs.first.get('phoneNumber');
              bool isMechanic = querySnapshot.docs.first.get('isMechanic');
              String profilePicture =
                  querySnapshot.docs.first.get('profilePicture');

              if (isMechanic == true) {
                String businessName =
                    querySnapshot.docs.first.get('businessName');
                double businessLatitude =
                    querySnapshot.docs.first.get('businessAddressLatitude');
                double businessLongitude =
                    querySnapshot.docs.first.get('businessAddressLongitude');

                Navigator.push(
                    context,
                    FadeRoute1(MechanicsHomepage(
                      firstName: firstName,
                      businessName: businessName,
                      email: email,
                      phoneNumber: phoneNumber,
                      lastName: lastName,
                      latitude: businessLatitude,
                      longitude: businessLongitude,
                      profilePicture: profilePicture,
                    )));
              } else {
                Navigator.push(
                    context,
                    FadeRoute1(HomeScreen(
                      firstName: firstName,
                      email: email,
                      lastName: lastName,
                      phoneNumber: phoneNumber,
                      profilePicture: profilePicture,
                    )));
              }
            }
          } else {
            // Password does not match
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: const Text('Wrong Password. Please Try Again.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        } else {
          // Users password is incorrect
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Wait a minute! 🤚'),
                content: const Text('Please check your password '),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Wait a minute! 🤚'),
              content: const Text('Please create your account first. '),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Handle login errors
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Login Error. $e '),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        //First Image
        SvgPicture.asset(
          'assets/images/login.svg',
          width: screenSize.width,
          fit: BoxFit.fill,
        ),
        Positioned(
          top: 30,
          left: 15,
          child: SvgPicture.asset(
            'assets/images/Plants.svg',
            width: screenSize.width * 0.9,
          ),
        ),
        Positioned(
          left: 50,
          top: 120,
          child: SvgPicture.asset(
            'assets/images/standing-23.svg',
            width: screenSize.width * 0.3,
          ),
        ),
        Positioned(
          top: 120,
          left: 130,
          child: Center(
            child: SvgPicture.asset(
              'assets/images/standing-14.svg',
              width: 0.2 * screenSize.width,
            ),
          ),
        ),
        Positioned(
          right: 100,
          top: 160,
          child: SvgPicture.asset(
            'assets/images/sitting-4.svg',
            width: 0.3 * screenSize.width,
          ),
        ),

        Positioned(
          top: screenSize.height * 0.45,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Welcome',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 55,
                  fontFamily: 'Etna Sans Serif',
                ),
              ),
              SizedBox(
                width: 100,
              ),
              Text(
                'Back!',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 50,
                  fontFamily: 'Etna Sans Serif',
                ),
              ),
            ],
          ),
        ),

        Positioned(
          bottom: 10,
          left: 25,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Input(
                  icon: const Icon(Icons.email_rounded),
                  text: 'Email',
                  hide: false,
                  lengthLimiter: false,
                  controller: loginEmail,
                ),
                const SizedBox(
                  height: 8,
                ),
                Input(
                  icon: const Icon(Icons.lock_rounded),
                  text: 'Password',
                  hide: true,
                  lengthLimiter: true,
                  controller: loginPassword,
                ),
                const SizedBox(
                  height: 15,
                ),
                Button(
                  color: kButton,
                  text: 'Login In',
                  onPress: () async {
                    setState(() {
                      isLoadingEnabled = true;
                    });
                    loginWithEmailAndPassword(
                        loginEmail.text, loginPassword.text);
                    Future.delayed(const Duration(seconds: 6), () {
                      setState(() {
                        isLoadingEnabled = false;
                      });
                    });
                  },
                  isLoading: isLoadingEnabled,
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Forgotten Password?",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontFamily: 'Etna Sans Serif',
                      decoration: TextDecoration.underline),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "OR Create a new one",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontFamily: 'Etna Sans Serif',
                      decoration: TextDecoration.underline),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

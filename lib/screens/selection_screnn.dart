import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:route_genie_/screens/signup_screen.dart';

import '../components/button.dart';
import '../util/constants.dart';
import 'login_screen.dart';

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
            body: Container(
                height: screenSize.height,
                width: screenSize.width,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [kPrimaryColor, kSecondaryColor])),
                child: Stack(children: [
                  Positioned(
                    right: 5,
                    left: 5,
                    top: 150,
                    //This is container 1 for greetings
                    child: SizedBox(
                      width: screenSize.width,
                      child: AnimatedTextKit(
                        pause: const Duration(milliseconds: 100),
                        animatedTexts: [
                          ScaleAnimatedText('!خوش آمدید',
                              textAlign: TextAlign.end,
                              duration: const Duration(seconds: 6),
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenSize.width * 0.2,
                                  fontFamily:
                                      'AA Sameer Armaa unicode AA Sameer Armaa unicode',
                                  shadows: const [
                                    Shadow(
                                        color: Colors.black,
                                        offset: Offset(1, 1))
                                  ])),
                          ScaleAnimatedText('Welcome!',
                              textAlign: TextAlign.center,
                              duration: const Duration(seconds: 6),
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenSize.width * 0.2,
                                  fontFamily:
                                      'AA Sameer Armaa unicode AA Sameer Armaa unicode',
                                  shadows: const [
                                    Shadow(
                                        color: Colors.black,
                                        offset: Offset(1, 1))
                                  ])),
                        ],
                        repeatForever: true,
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),

//Container 1 ends here

//Container 2 starts here

                  Positioned(
                    right: 5,
                    top: 250,
                    left: 5,
                    child: SizedBox(
                      width: screenSize.width,
                      child: AnimatedTextKit(
                          repeatForever: true,
                          pause: const Duration(milliseconds: 100),
                          animatedTexts: [
                            ScaleAnimatedText('آپ کا سفر',
                                textAlign: TextAlign.end,
                                duration: const Duration(seconds: 6),
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenSize.width * 0.2,
                                    fontFamily:
                                        'AA Sameer Armaa unicode AA Sameer Armaa unicode',
                                    shadows: const [
                                      Shadow(
                                          color: Colors.black,
                                          offset: Offset(1, 1))
                                    ])),
                            ScaleAnimatedText('Your   Journey',
                                textAlign: TextAlign.center,
                                duration: const Duration(seconds: 6),
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenSize.width * 0.13,
                                    fontFamily:
                                        'AA Sameer Armaa unicode AA Sameer Armaa unicode',
                                    shadows: const [
                                      Shadow(
                                          color: Colors.black,
                                          offset: Offset(1, 1))
                                    ])),
                          ]),
                    ),
                  ),

                  const SizedBox(height: 100),

                  //Container 2 ends here

                  //Container 3 starts from here
                  Positioned(
                    right: 5,
                    top: 320,
                    left: 5,
                    child: SizedBox(
                      width: screenSize.width,
                      child: AnimatedTextKit(
                          repeatForever: true,
                          pause: const Duration(milliseconds: 100),
                          animatedTexts: [
                            ScaleAnimatedText('ہم بنائیں محفوظ',
                                textAlign: TextAlign.end,
                                duration: const Duration(seconds: 6),
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenSize.width * 0.2,
                                    fontFamily:
                                        'AA Sameer Armaa unicode AA Sameer Armaa unicode',
                                    shadows: const [
                                      Shadow(
                                          color: Colors.black,
                                          offset: Offset(1, 1))
                                    ])),
                            ScaleAnimatedText('Made   Safe',
                                textAlign: TextAlign.center,
                                duration: const Duration(seconds: 6),
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenSize.width * 0.11,
                                    fontFamily:
                                        'AA Sameer Armaa unicode AA Sameer Armaa unicode',
                                    shadows: const [
                                      Shadow(
                                          color: Colors.black,
                                          offset: Offset(1, 1))
                                    ])),
                          ]),
                    ),
                  ),

                  Positioned(
                    bottom: 120,
                    left: 110,
                    child: Column(
                      verticalDirection: VerticalDirection.down,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Button(
                            color: kButton,
                            text: 'Sign In',
                            onPress: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()));
                            },
                            isLoading: false,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Button(
                            color: kButton,
                            text: 'Sign Up',
                            onPress: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpScreen()));
                            },
                            isLoading: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]))));
  }
}

// ignore_for_file: use_build_context_synchronously, duplicate_ignore, unused_local_variable, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:route_genie_/screens/home_screen.dart';
import 'package:route_genie_/screens/mechanics_homescreen.dart';
import 'package:route_genie_/util/constants.dart';
import 'dart:io';

import '../components/button.dart';
import '../components/input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Screen(),
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic>? userData;

  Future<void> registerUser() async {
    // ignore: duplicate_ignore

    // Simulate an asynchronous operation
    Future.delayed(const Duration(seconds: 6), () {
      setState(() {
        isLoadingEnabled = false;
      });
    });

    try {
      // Create user with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // Get the user ID
      String userId = userCredential.user!.uid;

      // Create a map of user data
      Map<String, dynamic> userData = {
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'phoneNumber': phoneNumberController.text,
        'email': emailController.text,
        'isMechanic': isMechanic,
        'password': passwordController.text,
        'confirmPassword': confirmPasswordController.text
      };
      if (isprofilepictureUploaded) {
        String profilePic =
            await uploadImage(profilePhoto, 'profile_picture_$userId.jpg', '2');
        userData['profilePicture'] = profilePic;
      }

      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(userId);
      if (isMechanic) {
        userData['businessName'] = businessNameController.text;
        userData['businessAddressLatitude'] = position!.latitude;
        userData['businessAddressLongitude'] = position!.longitude;
        // Upload images to Firebase Storage
        if (isfrontidUploaded) {
          String frontid =
              await uploadImage(idFront, 'front_id_$userId.jpg', '1');
          userData['idFront'] = frontid;
        }

        if (isfrontpolicerecordUploaded) {
          String frontpolice = await uploadImage(
              policerecordFront, 'front_policerecord_$userId.jpg', '3');
          userData['policeFront'] = frontpolice;
        }

        if (isbackpolicerecordUploaded) {
          String backpolice = await uploadImage(
              policerecordBack, 'back_policerecord_$userId.jpg', '4');
          userData['policeBack'] = backpolice;
        }
      }

      // Set the user data in Firestore
      await userDocRef.set(userData);

      // Clear form fields
      firstNameController.clear();
      lastNameController.clear();
      phoneNumberController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();

      // Display success message or navigate to the next screen
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('User registered successfully!'),
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
    } catch (e) {
      // Display error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Registration failed. Error: $e'),
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

  Future<String> uploadImage(
      File imageFile, String imageName, String id) async {
    String? downloadUrl;
    try {
      // Upload the image file to Firebase Storage
      Reference storageReference =
          FirebaseStorage.instance.ref().child('images/$imageName');
      UploadTask uploadTask = storageReference.putFile(imageFile);
      await uploadTask.whenComplete(() {});

      // Get the download URL of the uploaded image
      downloadUrl = await storageReference.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      if (downloadUrl == null) {
        return 'The value is null';
      }
      return downloadUrl;
    }
  }

  Future<void> getLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Location services are disabled.'),
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
        return;
      }

      // Request location permission
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Location permission denied.'),
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
        return;
      }

      // Get the current position
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Location stored successfully!'),
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
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future uploadfrontidImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        isfrontidUploaded = true;
        idFront = File(image.path);
      });
    }
  }

  Future uploadprofilePicture() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        isprofilepictureUploaded = true;
        profilePhoto = File(image.path);
      });
    }
  }

  Future uploadfrontpolicerecordImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        isfrontpolicerecordUploaded = true;
        policerecordFront = File(image.path);
      });
    }
  }

  Future uploadbackpolicerecordImage() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        isbackpolicerecordUploaded = true;
        policerecordBack = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Stack(
            children: [
              SvgPicture.asset(
                'assets/images/login.svg',
                width: screenSize.width,
                fit: BoxFit.fill,
              ),

              //This is Child 2 of Stack
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Center(
                    child: Text(
                      'Sign Up Here',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 28,
                        fontFamily: 'Etna Sans Serif',
                      ),
                    ),
                  ),
                  Input(
                    text: "First Name",
                    icon: const Icon(Icons.person),
                    hide: false,
                    lengthLimiter: false,
                    controller: firstNameController,
                  ),
                  Input(
                    text: "Last Name",
                    icon: const Icon(Icons.person),
                    hide: false,
                    lengthLimiter: false,
                    controller: lastNameController,
                  ),
                  Input(
                    text: "Phone Number",
                    icon: const Icon(Icons.phone),
                    hide: false,
                    lengthLimiter: true,
                    controller: phoneNumberController,
                  ),
                  Input(
                    text: "Email Address",
                    icon: const Icon(Icons.email_rounded),
                    hide: false,
                    lengthLimiter: false,
                    controller: emailController,
                  ),
                  Input(
                    text: "Password",
                    icon: const Icon(Icons.lock),
                    hide: true,
                    lengthLimiter: true,
                    controller: passwordController,
                  ),
                  Container(
                    width: 290,
                    height: 50,
                    margin: const EdgeInsets.all(7),
                    child: TextFormField(
                      obscureText: true,
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        prefixIcon: const Icon(Icons.lock),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(color: Color(0xffE4E7EB)),
                        ),
                        filled: true,
                        fillColor: const Color(0xffF8F9FA),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Color(0xffE4E7EB),
                            )),
                        errorBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(color: Colors.red)),
                        focusedErrorBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(color: Colors.red)),
                        errorStyle: const TextStyle(color: Colors.red),
                        errorMaxLines: 1,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the required value';
                        } else if (confirmPasswordController.text !=
                            passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (isprofilepictureUploaded == false)
                    const Text(
                      'Upload Profile Picture',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 17,
                        fontFamily: 'Etna Sans Serif',
                      ),
                    )
                  else
                    Image.file(
                      profilePhoto,
                      height: 50,
                      width: 50,
                    ),
                  Button(
                    color: kButton,
                    text: "Upload",
                    onPress: uploadprofilePicture,
                    isLoading: false,
                  ),
                  //Ends Here
                  Container(
                    width: 250,
                    height: 50,
                    color: Colors.orange,
                    child: CheckboxListTile(
                        value: isMechanic,
                        checkboxShape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(1)),
                        title: const Text("Are you a mechanic?"),
                        secondary: SizedBox(
                            width: 50,
                            child: Image.asset('assets/images/Saly-1.png')),
                        controlAffinity: ListTileControlAffinity.platform,
                        enableFeedback: true,
                        onChanged: (value) {
                          setState(() {
                            isMechanic = value!;
                          });
                        }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (isMechanic)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Input(
                          text: "Enter Business Name",
                          icon: const Icon(Icons.business_center_sharp),
                          hide: false,
                          lengthLimiter: false,
                          controller: businessNameController,
                        ),

//ADD BUSINESS ADDRESS HERE PLEASE

                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              getLocation();
                            });
                          },
                          child: const Text('Get Business Address Location'),
                        ),

                        const SizedBox(
                          height: 5,
                        ),
                        position == null
                            ? const Text(
                                'Location is not set',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 167, 0, 0),
                                  fontSize: 17,
                                  fontFamily: 'Etna Sans Serif',
                                ),
                              )
                            : const Text(
                                'Location Uploaded',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 5, 224, 31),
                                  fontSize: 17,
                                  fontFamily: 'Etna Sans Serif',
                                ),
                              ),
                        const SizedBox(
                          height: 20,
                        ),
                        //Using this to upload front ID image
                        if (isfrontidUploaded == false)
                          const Text(
                            'Upload ID card image',
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 17,
                              fontFamily: 'Etna Sans Serif',
                            ),
                          )
                        else
                          Image.file(
                            idFront,
                            height: 50,
                            width: 50,
                          ),
                        Button(
                          color: kButton,
                          text: "Upload",
                          onPress: uploadfrontidImage,
                          isLoading: false,
                        ),
                        //Ends here

                        //Using this to upload back ID image

                        //Using this to upload front police record image
                        if (isfrontpolicerecordUploaded == false)
                          const Text(
                            'Upload front police record picture',
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 17,
                              fontFamily: 'Etna Sans Serif',
                            ),
                          )
                        else
                          Image.file(
                            policerecordFront,
                            height: 50,
                            width: 50,
                          ),
                        Button(
                          color: kButton,
                          text: "Upload",
                          onPress: uploadfrontpolicerecordImage,
                          isLoading: false,
                        ),
                        //Ends Here
                        //Using this to upload backside of police record image
                        if (isbackpolicerecordUploaded == false)
                          const Text(
                            'Upload back police record',
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 17,
                              fontFamily: 'Etna Sans Serif',
                            ),
                          )
                        else
                          Image.file(
                            policerecordBack,
                            height: 50,
                            width: 50,
                          ),
                        Button(
                          color: kButton,
                          text: "Upload",
                          onPress: uploadbackpolicerecordImage,
                          isLoading: false,
                        ),
                        //Ends Here

                        Column(
                          children: [
                            Button(
                              color: kPrimaryColor,
                              text: "Start Your Journey",
                              onPress: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    isLoadingEnabled = true;
                                  });

                                  await registerUser();
                                  try {
                                    QuerySnapshot query =
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .where('email', isEqualTo: email)
                                            .get();

                                    if (query.size == 1) {
                                      //User exists. Now get the required data

                                      String id = query.docs[0].id;

                                      DocumentSnapshot document =
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(id)
                                              .get();
                                      userData = document.data()
                                          as Map<String, dynamic>;
                                    }
                                  } catch (e) {
                                    print('Error Logging in');
                                  }
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MechanicsHomepage(
                                                businessName:
                                                    userData?['businessName'] ??
                                                        "",
                                                email: userData?['email'] ?? "",
                                                phoneNumber:
                                                    userData?['phoneNumber'] ??
                                                        "",
                                                firstName:
                                                    userData?['firstName'] ??
                                                        '',
                                                lastName:
                                                    userData?['lastName'] ?? '',
                                                latitude: userData?[
                                                        'businessAddressLatitude'] ??
                                                    0,
                                                longitude: userData?[
                                                        'businessAddressLongitude'] ??
                                                    0,
                                                profilePicture: userData?[
                                                        'profilePicture'] ??
                                                    '',
                                              )));
                                  setState(() {
                                    isLoadingEnabled = false;
                                  });
                                }
                              },
                              isLoading: isLoadingEnabled,
                            ),
                            Image.asset(
                              'assets/images/Rectangle 47 (2).png',
                              width: screenSize.width * 0.7,
                            ),
                          ],
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        Button(
                          color: kButton,
                          text: 'Start Your Journey',
                          onPress: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoadingEnabled = true;
                              });

                              await registerUser();
//Checking whether user exists or not
                              try {
                                QuerySnapshot query = await FirebaseFirestore
                                    .instance
                                    .collection('users')
                                    .where('email', isEqualTo: email)
                                    .get();

                                if (query.size == 1) {
                                  //User exists. Now get the required data

                                  String id = query.docs[0].id;

                                  DocumentSnapshot document =
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(id)
                                          .get();
                                  userData =
                                      document.data() as Map<String, dynamic>;
                                }
                              } catch (e) {
                                print('Error Logging in');
                              }
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen(
                                            firstName:
                                                userData?['firstName'] ?? '',
                                            email: userData?['email'] ?? '',
                                            lastName:
                                                userData?['lastName'] ?? '',
                                            phoneNumber:
                                                userData?['phoneNumber'] ?? '',
                                            profilePicture:
                                                userData?['profilePicture'] ??
                                                    '',
                                          )));
                              setState(() {
                                isLoadingEnabled = false;
                              });
                            }
                          },
                          isLoading: isLoadingEnabled,
                        ),
                        Image.asset(
                          'assets/images/Rectangle 47 (2).png',
                          width: screenSize.width * 0.7,
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

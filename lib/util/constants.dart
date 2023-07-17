import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

const kButton = Color.fromARGB(255, 17, 8, 71);
const kSecondaryColor = Color.fromARGB(255, 228, 131, 5);
const kPrimaryColor = Color.fromARGB(255, 4, 18, 44);
bool isMechanic = false;
bool isfrontidUploaded = false;
bool isprofilepictureUploaded = false;
bool isfrontpolicerecordUploaded = false;
bool isbackpolicerecordUploaded = false;
bool isLoadingEnabled = false;

late File idFront, profilePhoto, policerecordFront, policerecordBack;
final firstNameController = TextEditingController();
final lastNameController = TextEditingController();
final phoneNumberController = TextEditingController();
final emailController = TextEditingController();
final businessNameController = TextEditingController();
final businessAddressController = TextEditingController();
final passwordController = TextEditingController();
final confirmPasswordController = TextEditingController();
Position? position;

String? firstName,
    lastName,
    phoneNumber,
    email,
    businessName,
    businessAddress,
    password,
    confirmPassword;

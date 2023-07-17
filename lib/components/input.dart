import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Input extends StatelessWidget {
  String text;
  Icon icon;
  bool hide;
  bool lengthLimiter;
  TextEditingController controller;

  Input({
    Key? key,
    required this.text,
    required this.icon,
    required this.hide,
    required this.lengthLimiter,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 290,
      height: 50,
      margin: const EdgeInsets.all(7),
      child: TextFormField(
        obscureText: hide,
        controller: controller,
        decoration: InputDecoration(
          hintText: text,
          prefixIcon: icon,
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
          } else if (lengthLimiter == true) {
            if (value.length > 15) {
              return "Value should be less than 15 words";
            }
          }
          return null;
        },
      ),
    );
  }
}

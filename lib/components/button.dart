import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Button extends StatelessWidget {
  Color color;
  String text;
  VoidCallback onPress;
  bool isLoading;

  Button(
      {Key? key,
      required this.color,
      required this.text,
      required this.onPress,
      required this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: onPress,
      child: Container(
        margin: const EdgeInsets.all(5),
        height: screenSize.height / 14,
        width: screenSize.width / 2.5,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          shape: BoxShape.rectangle,
        ),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Visibility(
                visible: !isLoading,
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Etna Sans serif',
                      fontSize: 15),
                ),
              ),
              Visibility(
                visible: isLoading,
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

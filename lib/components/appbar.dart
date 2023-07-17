import 'package:flutter/material.dart';

import '../util/constants.dart';

PreferredSizeWidget? customAppBar() {
  return AppBar(
    shadowColor: kSecondaryColor,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'ROUTE',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 28,
            fontFamily: 'Etna Sans Serif',
          ),
        ),
        Column(
          children: const [
            Text(
              'GENIE',
              style: TextStyle(
                color: kSecondaryColor,
                fontSize: 25,
                fontFamily: 'Blanka',
              ),
            ),
            SizedBox(
              height: 10.5,
            )
          ],
        ),
      ],
    ),
    backgroundColor: kPrimaryColor,
  );
}

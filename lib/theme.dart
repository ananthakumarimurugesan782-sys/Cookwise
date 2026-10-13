import 'package:flutter/material.dart';

const kBg = Color(0xFFFFFDD6); // cream background from wireframes
const kRed = Color(0xFFF40000); // button / accent red
const kText = Colors.black;
const kFont = 'serif'; // wireframes use a serif face

ThemeData cookwiseTheme() => ThemeData(
      scaffoldBackgroundColor: kBg,
      fontFamily: kFont,
      colorScheme: ColorScheme.fromSeed(seedColor: kRed, primary: kRed),
      useMaterial3: true,
    );

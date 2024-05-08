import 'dart:ui';

import 'package:flutter/cupertino.dart';

class AppTextSize {
  AppTextSize._();

  static const double extraLarge = 30;
  static const double large = 26;
  static const double medium = 23;
  static const double normal = 20;
  static const double normalM1 = 19;
  static const double small = 17;
  static const double extraSmall = 14;
  static const double extraExtraSmall = 12;
}

class CustomTextStyle {
  CustomTextStyle._();

  static TextStyle getBoldTextStyle({
    required Color textColor,
    required double textSize,
  }) {
    return TextStyle(
      color: textColor,
      fontSize: textSize,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle getNormalTextStyle({
    required Color textColor,
    required double textSize,
  }) {
    return TextStyle(
      color: textColor,
      fontSize: textSize,
      fontWeight: FontWeight.normal,
    );
  }
}

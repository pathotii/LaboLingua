import 'package:flutter/material.dart';

class TColor {
  static Color get primaryColor1 => const Color(0xFFFBAC08);
  static Color get primaryColor2 => const Color(0xFFFFFAA7);

  static Color get secondaryColor1 => const Color(0xffC58BF2);
  static Color get secondaryColor2 => const Color(0xffEEA4CE);

  static List<Color> get primaryG => [primaryColor2, primaryColor1];
  static List<Color> get secondaryG => [secondaryColor1, secondaryColor2];

  static Color get black => const Color(0xff1D1617);
  static Color get gray => const Color(0xff786F72);
  static Color get white => const Color(0xffFFFFFF);
  static Color get lightGray => const Color(0xffF7F8F8);
}

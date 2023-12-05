import 'package:flutter/material.dart';

class MyColor {
  static Color getColor(String platformTag) {
    switch (platformTag.toLowerCase()) {
      case 'lz':
        return Colors.redAccent;
      case 'kp':
        return Colors.yellowAccent;
      case 'nv':
        return Colors.lightGreenAccent;
    // Add more cases as needed for other platforms
      default:
        return Colors.cyan; // Default color
    }
  }
}


import 'package:flutter/cupertino.dart';

sealed class MySpacing {

  static const SizedBox spacingSW = SizedBox(width: 8.0,);
  static const SizedBox spacingMW = SizedBox(width: 16.0,);
  static const SizedBox spacingFW = SizedBox(width: 32.0,);
  static const SizedBox spacingSH = SizedBox(height: 8.0,);
  static const SizedBox spacingMH = SizedBox(height: 16.0,);
  static const SizedBox spacingFH = SizedBox(height: 32.0,);
}
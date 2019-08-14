import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';


void main() {

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Color(0xFF1E263A), // Color for Android
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark // Dark == white status bar -- for IOS.
  ));


  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new App());
  });

}

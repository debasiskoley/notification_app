import 'package:notification_app/pages/home.page.dart';
import 'package:notification_app/pages/login.page.dart';
import 'package:notification_app/utilities/constants.dart';

final routes = {
  '/login': (context) => LoginPage(title: cAppName),
  '/home': (context) => HomePage(title: cAppName),
};

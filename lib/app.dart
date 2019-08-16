import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:notification_app/services/auth.services.dart';
import 'package:notification_app/utilities/constants.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:uni_links/uni_links.dart';

import 'config/route.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App>  with SingleTickerProviderStateMixin {

  @override
  void initState() {
    _initPushNotification();
    super.initState();
  }


  Future<void> _initPushNotification() async {
    if(!mounted) return;

    var settings = {
      OSiOSSettings.autoPrompt: true,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    };

    OneSignal.shared.init("a85cc974-b433-4e1f-96af-080bf43e5fb3", iOSSettings: settings);
    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
  }

  @override
  Widget build(BuildContext context) {
    final app = new MaterialApp(
        title: cAppName,
        theme: _appTheme,
        debugShowCheckedModeBanner: false,
        home: new SplashScreen(),
        routes: routes
    );
    return app;
  }
}

Future<bool> checkUserAndNavigate(BuildContext context) async {
  var loginStatus = await isLoggedIn();
  var status = loginStatus ? true : false;
  return status;
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  String initialLink;
  AnimationController controller;
  Animation<double> animation;
  bool _isComplete, _isIos;

  @override
  void initState() {
    super.initState();
    _isComplete = false;
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isComplete = true;
        });

        // Initialize Deep link by using uni_link flutter
        _initPlatformState();

//         // Initialize Branch flutter to install app deep link
//        _initBranch()

        // Handle Notification call
        _handleNotificationReceived();

        // Start and redirection if user logged in.
        _startAppInit();
      }
    });

  }


  // Initialize uni_link here
  _initPlatformState() async {
    await _initUniLinks();
  }


//  _initBranch(){
//    if (Platform.isAndroid) FlutterBranchIoPlugin.setupBranchIO();
////    FlutterBranchIoPlugin.listenToDeepLinkStream().listen((string) {
////      print("DEEPLINK $string");
////      // PROCESS DEEPLINK HERE
////    });
//    if (Platform.isAndroid) {
//      FlutterAndroidLifecycle.listenToOnStartStream().listen((string) {
//        print("ONSTART");
//        FlutterBranchIoPlugin.setupBranchIO();
//      });
//    }
//  }

  /// An implementation using a [String] link
  Future<Null> _initUniLinks() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialLink = await getInitialLink();
    } on PlatformException {
      initialLink = 'Failed to get initial link.';
    } on FormatException {
      initialLink = 'Failed to parse the initial link as Uri.';
    }

  }

  // Notification Receive Handler and Open Handler
  void _handleNotificationReceived() {

    // Receive Handler
    OneSignal.shared.setNotificationReceivedHandler((OSNotification notification) {
      print("Recive : ${notification.jsonRepresentation()}");
    });

    // Open Handler
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print("Opened notification: \n${result.notification.jsonRepresentation()}");


      // Redirect after checking login user.
      checkUserAndNavigate(context).then((res) {
          if (res == true) {
            Navigator.pushReplacementNamed(context, '/profile');
          } else {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/login', (Route<dynamic> route) => false);
          }
      });
    });

  }


  // App Initialize after checking user stat.
  Future<void> _startAppInit() async {
    checkUserAndNavigate(context).then((res) {
      if(_isComplete) {
        if (res == true) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/login', (Route<dynamic> route) => false);
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;

    return Container(
        color: Color(0xFF1E263B),
        child: FadeTransition(
            opacity: animation,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Text(
                    'Loading ..',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                  )
                ]
            )
        )
    );

  }

}

final ThemeData _appTheme = _buildFlutterTheme();

ThemeData _buildFlutterTheme() {
  final ThemeData base = ThemeData.light();

  return base.copyWith(
    iconTheme: IconThemeData(color: Color(0xFF4F5F78)),
    primaryColor:  Color(0xFF1E263B),
    primaryColorBrightness: Brightness.dark,
    brightness: Brightness.light,
  );
}

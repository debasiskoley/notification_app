import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:notification_app/services/auth.services.dart';
import 'package:notification_app/utilities/constants.dart';
import 'package:uni_links/uni_links.dart';

import 'config/route.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App>  with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
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
        initPlatformState();
//        _initBranch();
        _startAppInit();
      }
    });

  }

  initPlatformState() async {
    await initUniLinks();
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
  Future<Null> initUniLinks() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialLink = await getInitialLink();
    } on PlatformException {
      initialLink = 'Failed to get initial link.';
    } on FormatException {
      initialLink = 'Failed to parse the initial link as Uri.';
    }

  }

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

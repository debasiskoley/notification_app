import 'package:flutter/material.dart';
import 'package:notification_app/services/auth.services.dart';
import 'package:notification_app/utilities/constants.dart';
import 'package:toast/toast.dart';

class HomePage extends StatefulWidget {

  final String title;
  HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  DateTime currentBackPressTime = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  void dispose() {
    _scaffoldKey.currentState?.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
//    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return  Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      key: _scaffoldKey,
      body: WillPopScope(
        child: new Stack(
          children: <Widget>[
            GestureDetector(
              child: _showBody(),
              onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
            ),
          ],
        ),
        onWillPop: onWillPop,
      ),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Toast.show('Press again to exit app.', context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      return Future.value(false);
    }
    return Future.value(true);
  }


  Widget _showBody(){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: RaisedButton(
          padding: EdgeInsets.all(15),
            child: Text('Logout'),
            onPressed:(){
              setState(() {
                logout();
                LoginStat.isLogin = false;
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login', (Route<dynamic> route) => false);
              });
            },
        ),
      ),
    );
  }

}

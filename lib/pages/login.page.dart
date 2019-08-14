import 'package:flutter/material.dart';
import 'package:notification_app/services/auth.services.dart';
import 'package:notification_app/utilities/constants.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {

  final String title;
  LoginPage({Key key, this.title}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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


  Future<void> _login() async {
    logIn();
    setState(() {
      LoginStat.isLogin = true;
      Navigator.pushReplacementNamed(context, '/home');
    });
  }


  @override
  Widget build(BuildContext context) {
//    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return  Scaffold(
      appBar: AppBar(
        title: Text('Login'),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Login Page'),
          SizedBox(height: 200,),
          RaisedButton(
            padding: EdgeInsets.all(15),
            child: Text('Login'),
            onPressed:() => _login(),
          ),
        ],
      ),
    );
  }


}

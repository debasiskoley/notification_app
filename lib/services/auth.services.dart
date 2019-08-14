import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

Future logIn() async {
    await storage.deleteAll();
    await storage.write(key: 'token',
        value: 'Bearer-some-token');
}

Future logout() async {
  await storage.deleteAll();
}


Future<bool> isLoggedIn() async {
  var checkToken = await storage.read(key: 'token');
  var loginStatus =  ( checkToken != null) ? true : false;
  return loginStatus;
}

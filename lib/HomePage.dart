import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Login.dart';
import 'SignUp.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(10)),
            Align(
                child: IconButton(
                    icon: const Icon(Icons.info_outline),
                    tooltip: "About",
                    onPressed: (() async {
                      showAboutDialog(
                          context: context,
                          applicationName: 'StudentHub',
                          applicationVersion: '1.0.0',
                          applicationLegalese:
                              '©️ 2021 Google logo\n©️ 2021 Facebook logo',
                          children: <Widget>[
                            InkWell(
                                child: const Text('Privacy Policy'),
                                onTap: () async {
                                  var url =
                                      'https://gist.github.com/mostafanaax69/2660aef1bef581031866cb5997a03169';
                                  await launch(url);
                                }),
                            InkWell(
                                child: const Text('Terms & Conditions'),
                                onTap: () async {
                                  var url =
                                      'https://gist.github.com/mostafanaax69/871b4152b09a2e9c40091f5b58b04d5b';
                                  await launch(url);
                                }),
                            InkWell(
                                child: const Text('Credits'),
                                onTap: () async {
                                  var url =
                                      'https://gist.github.com/mostafanaax69/118ab1cb1cbfa18dcd7ebe0df39b0db4';
                                  await launch(url);
                                }),
                          ]);
                    })),
                alignment: Alignment.bottomLeft),
            new Image.asset(
              'images/bot.png',
              height: 152,
              width: 152,
            ),
            Text(
              'Hey!',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Montserrat'),
            ),
            Padding(padding: EdgeInsets.all(5)),
            Text("I'm StudentHub",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                )),
            Text("Content Bot!",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            Padding(padding: EdgeInsets.all(5)),
            Text(" Since your and other student's ",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Montserrat')),
            Text(" Safety is important ",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Montserrat')),
            Padding(padding: EdgeInsets.all(10)),
            Text(" Please Sign Up or Log in ",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Montserrat')),
            Padding(padding: EdgeInsets.all(15)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shadowColor: Colors.white,
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  fixedSize: const Size(264, 84)),
              onPressed: () {
                Navigator.of(context).pushNamed('/Auth/Signup');
              },
              child: Text('Sign Up'),
            ),
            Padding(padding: EdgeInsets.all(10)),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/Auth/Login');
              },
              child: Text('Log in'),
              style: OutlinedButton.styleFrom(
                  primary: Colors.white,
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  side: BorderSide(width: 1, color: Colors.white),
                  fixedSize: Size(213.48, 52.9),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0))),
            )
          ],
        ),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [Colors.deepPurpleAccent, Colors.white])),
      ),
    );
  }
}

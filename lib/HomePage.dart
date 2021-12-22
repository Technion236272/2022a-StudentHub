import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Login.dart';
import 'SignUp.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(50)),
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
                  color: Colors.white,fontFamily: 'Montserrat'),
            ),
            Padding(padding: EdgeInsets.all(5)),
            Text("I'm StudentHub",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,fontFamily: 'Montserrat',)),
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
                    color: Colors.white,fontFamily: 'Montserrat' )),
            Text(" Safety is important ",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,fontFamily: 'Montserrat')),
            Padding(padding: EdgeInsets.all(10)),
            Text(" Please Sign Up or Log in ",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,fontFamily: 'Montserrat')),
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()));
              },
              child: Text('Sign Up'),
            ),
            Padding(padding: EdgeInsets.all(10)),
            OutlinedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Auth.dart';
import 'package:provider/provider.dart';

import 'CatogryHomePage.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreen createState() => _LoginScreen();

}


class _LoginScreen extends State<LoginScreen> {

  final _email_controller = TextEditingController();
  final _password_controller = TextEditingController();
  var _obsecure_flag = true;
  var scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AuthRepository>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          SafeArea(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.15,
                color: Color(0xFF8C88F9),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(
                            onPressed: () {Navigator.of(context).pop();},
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ))
                      ],
                    ),
                    Text(
                      "Log Into StudentHub",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,fontFamily: 'Montserrat'
                      ),
                    )
                  ],
                ),
                alignment: Alignment.center,
              )),
          Flexible(
              child: Container(
            height: MediaQuery.of(context).size.height * 0.85,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Color(0xFF8C88F9), spreadRadius: 12, blurRadius: 10)
              ],
            ),
            alignment: Alignment.center,
            child:  Column(
              children: <Widget>[
              Padding(padding: EdgeInsets.all(10)),
          new Image.asset(
            'images/login.png',
            height: 75,
            width: 75,
          ),
          Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.all(20),),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.all(5.0)),
                    TextField(
                      controller: _email_controller,
                      decoration: InputDecoration(
                        /// To check about the length and if the input is bigger than 1 line
                          contentPadding: EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFF0F4F8)),
                          ),
                         // border: InputBorder.none,
                          icon: Icon(
                            Icons.email,
                            color: Color(0xFFA6BCD0),
                            size: 30,
                          ),
                          labelText: 'Email',
                          labelStyle: TextStyle(fontSize: 20, color: Color(0xFFA6BCD0)),
                          constraints: BoxConstraints(maxWidth: 330),
                          floatingLabelBehavior: FloatingLabelBehavior.never
                      ),
                    )
                  ],
                ),
                height: 60,
                width: 362,
                decoration: BoxDecoration(
                    color: Color(0xFFF0F4F8),
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
              ),
              Padding(padding: EdgeInsets.all(10)),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.all(5.0)),
                    TextField(

                      obscureText: _obsecure_flag,
                      controller: _password_controller,
                      decoration: InputDecoration(
                        /// To check about the length and if the input is bigger than 1 line
                          contentPadding: EdgeInsets.fromLTRB(5.0,4.0, 5.0, 0),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFF0F4F8)),
                          ),

                          suffixIcon: IconButton(
                            icon: Icon(
                              _obsecure_flag ? Icons.visibility : Icons.visibility_off,
                              color: Color(0xFFA6BCD0),
                              size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                                _obsecure_flag = !_obsecure_flag;
                              });
                            },
                          ),
                         // border: InputBorder.none,
                          icon: Icon(
                            Icons.lock,
                            color: Color(0xFFA6BCD0),
                            size: 30,
                          ),
                          labelText: 'Password',
                          labelStyle: TextStyle(fontSize: 20, color: Color(0xFFA6BCD0)),
                          constraints: BoxConstraints(maxWidth: 330),

                          floatingLabelBehavior: FloatingLabelBehavior.never),
                    )
                  ],
                ),
                height: 60,
                width: 362,
                decoration: BoxDecoration(
                    color: Color(0xFFF0F4F8),
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
              ),
              Padding(padding: EdgeInsets.all(30)),
              user.status == Status.Authenticating
                  ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepPurpleAccent,
                  ))
                  :ElevatedButton(
                onPressed: () async{
                  bool res = await user.signIn(_email_controller.text, _password_controller.text);
                  if (res == false) {
                    final snackbar = SnackBar(
                      content:
                      Text('Log in failed incorrect email or password '),
                      backgroundColor: Color(0xFF9189F3),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  } else {
                    /// To Do Add the HomePage of the User (Categories page)
                    final snackbar = SnackBar(
                      content:
                      Text('You are successfully logged in '),
                      backgroundColor: Color(0xFF9189F3),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CategoryPageScreen()));
                  }


                },
                child: Text("LOG IN"),
                style: ElevatedButton.styleFrom(
                    primary: Color(0xFFA1A3FF),
                    onPrimary: Colors.white,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    fixedSize: Size(315, 60),
                    textStyle: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white,)),
              )
            ],
          )
        ],
      ),
          ))
        ],
      ),
    );
  }


}
